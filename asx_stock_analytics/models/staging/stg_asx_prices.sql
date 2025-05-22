{{ config(materialized='view') }}

SELECT
  datetime,
  symbol,
  open,
  high,
  low,
  close,
  volume
FROM rawdata.asx_prices
WHERE datetime IS NOT NULL