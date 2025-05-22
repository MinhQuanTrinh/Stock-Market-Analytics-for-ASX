-- SQL Script to use in Snowflake
-- This script is used to load the raw data from the S3 bucket to the rawdata.asx_prices_raw table in Snowflake.

CREATE OR REPLACE STAGE asx_stage
URL = 's3://asx-stock-raw-data-bucket/raw/'
STORAGE_INTEGRATION = asx_s3_integration
FILE_FORMAT = (TYPE = JSON);

CREATE OR REPLACE TABLE rawdata.asx_prices_raw (
  json_data VARIANT
);

LIST @asx_stage/2025-05-21/;

COPY INTO rawdata.asx_prices_raw
FROM @asx_stage/2025-05-21/stock.json
FILE_FORMAT = (TYPE = JSON)
ON_ERROR = 'CONTINUE';

-- Transform the data: LATERAL FLATTEN is used to flatten the json_data column
-- The transformed data is then loaded into the rawdata.asx_prices table
INSERT INTO rawdata.asx_prices
SELECT
  value:"Date"::TIMESTAMP AS datetime,
  value:"Ticker"::STRING AS symbol,
  value:"Open"::FLOAT AS open,
  value:"High"::FLOAT AS high,
  value:"Low"::FLOAT AS low,
  value:"Close"::FLOAT AS close,
  value:"Volume"::FLOAT AS volume
FROM rawdata.asx_prices_raw,
LATERAL FLATTEN(input => json_data);