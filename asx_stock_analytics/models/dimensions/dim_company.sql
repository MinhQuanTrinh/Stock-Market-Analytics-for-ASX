-- SQL Script for dimension table for company from fact table fct_stock_summary
{{ config(materialized='table') }}

SELECT * FROM VALUES
  ('CBA.AX', 'Commonwealth Bank', 'Financials'),
  ('NDQ.AX', 'Betashares Nasdaq 100 ETF', 'Technology'),
  ('DTR.AX', 'Dateline Resources', 'Mining'),
  ('TMK.AX', 'Tamarack Valley Energy', 'Energy'),
  ('RMD.AX', 'ResMed Inc.', 'Healthcare')
  AS dim_company(symbol, company_name, sector)