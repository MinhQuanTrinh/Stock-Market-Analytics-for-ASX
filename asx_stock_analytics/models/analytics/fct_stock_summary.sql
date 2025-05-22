-- Script for creating a fact table that summarizes stock prices by day
-- This table is used to provide a high-level overview of stock prices and trading activity

{{ config(materialized='table') }}

SELECT
  symbol,
  DATE_TRUNC('day', datetime) AS trade_date,
  MAX(high) AS max_high,
  MIN(low) AS min_low,
  AVG(close) AS avg_close,
  SUM(volume) AS total_volume
FROM {{ ref('stg_asx_prices') }}
GROUP BY symbol, DATE_TRUNC('day', datetime)