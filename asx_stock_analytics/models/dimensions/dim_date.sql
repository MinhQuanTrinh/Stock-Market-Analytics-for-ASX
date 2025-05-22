{{ config(materialized='table') }}

WITH date_range AS (
  SELECT
    DATEADD(DAY, SEQ4(), DATEADD(DAY, -30, CURRENT_DATE())) AS date
  FROM TABLE(GENERATOR(ROWCOUNT => 400))  -- 400 days of data
)

SELECT
  date,
  YEAR(date) AS year,
  MONTH(date) AS month,
  DAY(date) AS day,
  TO_CHAR(date, 'DY') AS weekday_abbr,
  TO_CHAR(date, 'Day') AS weekday_name,
  TO_CHAR(date, 'Mon') AS month_name,
  WEEK(date) AS week_of_year,
  CASE WHEN DAYOFWEEK(date) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend
FROM date_range
