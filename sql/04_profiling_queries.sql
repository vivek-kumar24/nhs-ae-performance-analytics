-- How many rows total?
SELECT COUNT(*) FROM stg_ae_raw;

-- How many months per year?
SELECT financial_year, COUNT(DISTINCT file_month) AS months
FROM stg_ae_raw GROUP BY financial_year ORDER BY financial_year;

-- How many unique Trusts?
SELECT COUNT(DISTINCT org_code) FROM stg_ae_raw;

-- Find suppressed values (NHS uses * for small counts)
SELECT COUNT(*) FROM stg_ae_raw WHERE total_over4hr = '*';

-- Find dash values (not applicable)
SELECT COUNT(*) FROM stg_ae_raw WHERE total_over4hr = '-';