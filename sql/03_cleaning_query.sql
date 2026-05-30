INSERT INTO fact_ae_monthly (
    period_date, financial_year, financial_quarter,
    org_code, org_name, region,
    type1_attendances, type2_attendances, type3_attendances, total_attendances,
    type1_under4hr, type2_under4hr, type3_under4hr, total_under4hr,
    type1_over4hr, type2_over4hr, type3_over4hr, total_over4hr,
    pct_within4hr_all, pct_within4hr_type1, pct_within4hr_type2, pct_within4hr_type3,
    emergency_admissions_type1, emergency_admissions_type2, emergency_admissions_type3,
    total_emergency_admissions_via_ae, other_emergency_admissions, total_emergency_admissions,
    over4hr_decision_to_admit, over12hr_decision_to_admit,
    breach_rate_pct, is_suppressed
)
SELECT
    TO_DATE(file_month, 'Month YYYY')                           AS period_date,
    financial_year,

    CASE EXTRACT(MONTH FROM TO_DATE(file_month, 'Month YYYY'))
        WHEN 4  THEN 'Q1' WHEN 5  THEN 'Q1' WHEN 6  THEN 'Q1'
        WHEN 7  THEN 'Q2' WHEN 8  THEN 'Q2' WHEN 9  THEN 'Q2'
        WHEN 10 THEN 'Q3' WHEN 11 THEN 'Q3' WHEN 12 THEN 'Q3'
        WHEN 1  THEN 'Q4' WHEN 2  THEN 'Q4' WHEN 3  THEN 'Q4'
    END                                                          AS financial_quarter,

    UPPER(TRIM(org_code))                                        AS org_code,
    TRIM(org_name)                                               AS org_name,
    TRIM(region)                                                 AS region,

    NULLIF(NULLIF(NULLIF(type1_attendances, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(type2_attendances, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(type3_attendances, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(total_attendances, '*'), '-'), '')::DECIMAL::INTEGER,

    NULLIF(NULLIF(NULLIF(type1_under4hr, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(type2_under4hr, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(type3_under4hr, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(total_under4hr, '*'), '-'), '')::DECIMAL::INTEGER,

    NULLIF(NULLIF(NULLIF(type1_over4hr, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(type2_over4hr, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(type3_over4hr, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(total_over4hr, '*'), '-'), '')::DECIMAL::INTEGER,

    NULLIF(NULLIF(NULLIF(pct_within4hr_all,   '*'), '-'), '')::DECIMAL,
    NULLIF(NULLIF(NULLIF(pct_within4hr_type1, '*'), '-'), '')::DECIMAL,
    NULLIF(NULLIF(NULLIF(pct_within4hr_type2, '*'), '-'), '')::DECIMAL,
    NULLIF(NULLIF(NULLIF(pct_within4hr_type3, '*'), '-'), '')::DECIMAL,

    NULLIF(NULLIF(NULLIF(emergency_admissions_type1,        '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(emergency_admissions_type2,        '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(emergency_admissions_type3,        '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(total_emergency_admissions_via_ae, '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(other_emergency_admissions,        '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(total_emergency_admissions,        '*'), '-'), '')::DECIMAL::INTEGER,

    NULLIF(NULLIF(NULLIF(over4hr_decision_to_admit,  '*'), '-'), '')::DECIMAL::INTEGER,
    NULLIF(NULLIF(NULLIF(over12hr_decision_to_admit, '*'), '-'), '')::DECIMAL::INTEGER,

    ROUND(
        NULLIF(NULLIF(total_over4hr, '*'), '-')::DECIMAL
        /
        NULLIF(NULLIF(NULLIF(total_attendances, '*'), '-')::DECIMAL, 0)
        * 100
    , 2)                                                         AS breach_rate_pct,

    CASE WHEN total_over4hr = '*' THEN TRUE ELSE FALSE END       AS is_suppressed

FROM stg_ae_raw
WHERE org_code NOT IN ('-', '', 'nan')
  AND org_name NOT IN ('', 'nan');