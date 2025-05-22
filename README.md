# Stock-Market-Analytics-for-ASX
This pipeline fetch stock data from Yahoo Finance API. The tickers are my current holding in the portfolio. The refined data is then used to produce a dashboard for visualization.
Tech stack: Airflow, Docker, Snowflake, dbt, AWS S3, PowerBI.


Step	    Component	                    Purpose
1	    rawdata.asx_prices_raw	    Raw JSON data loaded from S3
2	    rawdata.asx_prices	        Flattened structured table(staging data)
3	    stg_asx_prices (dbt view)	Cleaned, renamed version of raw table used for modeling
4	    fct_stock_summary	        Final analytics-ready fact table for reporting
