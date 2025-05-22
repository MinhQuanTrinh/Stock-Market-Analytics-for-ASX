-- Script for creating a fact table that summarizes stock prices by day
-- This table is used to provide a high-level overview of stock prices and trading activity

{{ config(materialized='table') }}

-- Fact table summarizing stock prices by day and enriched with company and calendar dimensions

SELECT
  f.symbol,
  DATE_TRUNC('day', f.datetime) AS trade_date,
  MAX(f.high) AS max_high,
  MIN(f.low) AS min_low,
  AVG(f.close) AS avg_close,
  SUM(f.volume) AS total_volume,
  c.company_name,
  c.sector,
  d.weekday_name,
  d.is_weekend
FROM {{ ref('stg_asx_prices') }} f
LEFT JOIN {{ ref('dim_company') }} c ON f.symbol = c.symbol
LEFT JOIN {{ ref('dim_date') }} d ON DATE(f.datetime) = d.date
GROUP BY
  f.symbol,
  DATE_TRUNC('day', f.datetime),
  c.company_name,
  c.sector,
  d.weekday_name,
  d.is_weekend