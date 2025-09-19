-- Step 1: Initial Data Assessment
-- =============================================
-- Check total records and basic stats
SELECT
	COUNT(*) AS total_records,
	COUNT(DISTINCT claim_id) AS unique_claims,
	MIN(incident_date) AS earliest_incident,
	MAX(incident_date) AS latest_incident
FROM insurance_claims;

-- Check for completely duplicate records
SELECT 
	policy_number, incident_date, incident_type, total_claim_amount, COUNT(*) AS duplicate_count
FROM insurance_claims
GROUP BY policy_number, incident_date, incident_type, total_claim_amount;

-- Step 2: Handle Missing Values and Nulls
-- =============================================

-- Check for null values in critical columns
SELECT 
	COUNT(*) - COUNT(policy_number) AS policy_number_nulls,
	COUNT(*) - COUNT(incident_date) AS incident_date_nulls,
	COUNT(*) - COUNT(total_claim_amount) AS total_claim_amount_nulls,
	COUNT(*) - COUNT(fraud_reported) AS fraud_reported_nulls,
	COUNT(*) - COUNT(age) AS age_nulls,
	COUNT(*) - COUNT(policy_state) AS policy_state_nulls
FROM insurance_claims;

-- Handle question marks as missing values in specific columns
UPDATE insurance_claims
SET property_damage = Null
WHERE property_damage = '?';

UPDATE insurance_claims
SET collision_type = Null
WHERE collision_type = '?';

UPDATE insurance_claims
SET police_report_available = Null
WHERE police_report_available = '?';

-- Step 3: Data Type Corrections and Standardization
-- =============================================

-- Standardize text data to uppercase for consistency
UPDATE insurance_claims 
SET 
    policy_state = UPPER(TRIM(policy_state)),
    incident_state = UPPER(TRIM(incident_state)),
    insured_sex = UPPER(TRIM(insured_sex)),
    incident_type = UPPER(TRIM(incident_type)),
    collision_type = UPPER(TRIM(collision_type)),
    incident_severity = UPPER(TRIM(incident_severity)),
    authorities_contacted = UPPER(TRIM(authorities_contacted)),
    property_damage = UPPER(TRIM(property_damage)),
    police_report_available = UPPER(TRIM(police_report_available)),
    fraud_reported = UPPER(TRIM(fraud_reported));

-- Standardize education levels
UPDATE insurance_claims 
SET insured_education_level = CASE 
    WHEN UPPER(TRIM(insured_education_level)) IN ('HIGH SCHOOL', 'HS') THEN 'HIGH SCHOOL'
    WHEN UPPER(TRIM(insured_education_level)) IN ('BACHELORS', 'BACHELOR') THEN 'BACHELORS'
    WHEN UPPER(TRIM(insured_education_level)) IN ('MASTERS', 'MASTER') THEN 'MASTERS'
    WHEN UPPER(TRIM(insured_education_level)) IN ('PHD', 'DOCTORATE') THEN 'PHD'
    WHEN UPPER(TRIM(insured_education_level)) IN ('ASSOCIATE', 'ASSOCIATES') THEN 'ASSOCIATES'
    WHEN UPPER(TRIM(insured_education_level)) IN ('JD', 'LAW') THEN 'JD'
    WHEN UPPER(TRIM(insured_education_level)) IN ('MD', 'MEDICAL') THEN 'MD'
    ELSE UPPER(TRIM(insured_education_level))
END;

-- Step 4: Handle Outliers and Invalid Values
-- =============================================

-- Identify and handle age outliers (assuming valid age range 16-100)
SELECT 
    COUNT(*) as invalid_ages,
    MIN(age) as min_age,
    MAX(age) as max_age
FROM insurance_claims 
WHERE age < 16 OR age > 100 OR age IS NULL;

-- Handle negative claim amounts
UPDATE insurance_claims 
SET total_claim_amount = ABS(total_claim_amount) 
WHERE total_claim_amount < 0;

UPDATE insurance_claims 
SET injury_claim = ABS(injury_claim) 
WHERE injury_claim < 0;

UPDATE insurance_claims 
SET property_claim = ABS(property_claim) 
WHERE property_claim < 0;

UPDATE insurance_claims
SET vehicle_claim = ABS(vehicle_claim) 
WHERE vehicle_claim < 0;

-- Handle invalid vehicle years
UPDATE insurance_claims
SET auto_year = NULL
WHERE auto_year < 1900 OR auto_year > EXTRACT(YEAR FROM CURRENT_DATE) + 2;

-- Step 5: Business Logic Validations
-- =============================================

-- Add validation flags for business rules

ALTER TABLE insurance_claims ADD COLUMN validation_flag VARCHAR(100);

UPDATE insurance_claims
SET validation_flag = COALESCE(validation_flag || '; ', '') || 'INCIDENT_BEFORE_POLICY'
WHERE incident_date < policy_bind_date;

-- Flag records where claim components don't add up to total
UPDATE insurance_claims
SET validation_flag = COALESCE(validation_flag || '; ', '') || 'CLAIM_AMOUNT_MISMATCH'
WHERE ABS(total_claim_amount - COALESCE(injury_claim,0) - COALESCE(property_claim,0) - COALESCE(vehicle_claim,0)) > 0.01;

-- Flag records with zero claim amounts
UPDATE insurance_claims
SET validation_flag = COALESCE(validation_flag || '; ', '') || 'ZERO_CLAIM_AMOUNT'
WHERE total_claim_amount = 0 OR total_claim_amount is NULL;

-- Step 6: Handle Date Inconsistencies
-- =============================================

-- Check for future dates
SELECT COUNT(*) AS future_incidents
FROM insurance_claims
WHERE incident_date > CURRENT_DATE;

-- Flag future incident dates
UPDATE insurance_claims
SET validation_flag = COALESCE(validation_flag || '; ', '') || 'FUTURE_INCIDENT_DATE'
WHERE incident_date > CURRENT_DATE;

-- Step 7: Clean and Standardize ZIP codes
-- =============================================

-- Remove non-numeric characters from ZIP codes and standardize length
UPDATE insurance_claims 
SET insured_zip = CASE 
    WHEN LENGTH(REGEXP_REPLACE(insured_zip, '^0-9', '', 'g')) >= 5
	THEN LEFT(REGEXP_REPLACE(insured_zip, '^0-9', '', 'g'),5)
	ELSE NULL
END;

-- Step 8: Remove Unnecessary Columns
-- =============================================

-- Drop the raw_extra_col if it's always null (check first)
SELECT COUNT(*) AS non_null_count
FROM insurance_claims 
WHERE raw_extra_col IS NOT NULL AND TRIM(raw_extra_col) != '';

ALTER TABLE insurance_claims DROP COLUMN raw_extra_col;

-- Step 9: Create Data Quality Summary
-- =============================================

-- Create a summary table of data quality issues

CREATE TEMP TABLE data_quality_summary AS
SELECT
	'Total Records' AS metrics,
	COUNT(*)::TEXT AS value
FROM insurance_claims

UNION ALL

SELECT
	'Records with Validation Issues' AS metrics,
	COUNT(*)::TEXT AS value
FROM insurance_claims
WHERE validation_flag IS NOT NULL

UNION ALL

SELECT
	'Records with Missing Policy Number' AS metrics,
	COUNT(*)::TEXT AS value
FROM insurance_claims
WHERE policy_number IS NULL

UNION ALL

SELECT
	'Records with Missing Incident Date' AS metrics,
	COUNT(*)::TEXT AS value
FROM insurance_claims
WHERE incident_date IS NULL

UNION ALL

SELECT
	'Records with Missing Claim Amount' AS metrics,
	COUNT(*)::TEXT AS value
FROM insurance_claims
WHERE total_claim_amount IS NULL OR total_claim_amount= 0;

-- Display the summary
SELECT * FROM data_quality_summary;

-- Step 10: Final Data Validation Queries
-- =============================================

-- Check distinct values for categorical columns
SELECT 'policy_state' AS column_name, policy_state AS value, COUNT(*) AS count
FROM insurance_claims
GROUP BY policy_state
UNION ALL
SELECT 'insured_sex' AS column_name, insured_sex AS value, COUNT(*) AS count
FROM insurance_claims
GROUP BY insured_sex
UNION ALL
SELECT 'incident_severity' AS column_name, incident_severity AS value, COUNT(*) AS count
FROM insurance_claims
GROUP BY incident_severity
ORDER BY column_name, COUNT DESC;

-- Final statistics
SELECT 
	'Cleaned Data Summary' AS summary,
	COUNT(*) AS total_records,
	COUNT(CASE WHEN fraud_reported='Y' THEN 1 END) AS fraud_cases,
	ROUND(AVG(age),2) AS avg_age,
	ROUND(AVG(total_claim_amount),2) AS avg_claim_amount,
	COUNT(DISTINCT policy_state) AS unique_states,
	COUNT(CASE WHEN validation_flag IS NOT NULL THEN 1 END) AS flagged_records
FROM insurance_claims;

-- Step 11: Create Clean Dataset View (Optional)
-- =============================================

-- Create a view with only clean, valid records for analysis
CREATE OR REPLACE VIEW clean_insurance_claims AS
SELECT *
FROM insurance_claims 
WHERE 
    policy_number IS NOT NULL
    AND incident_date IS NOT NULL 
    AND total_claim_amount > 0
    AND age BETWEEN 16 AND 100
    AND incident_date >= policy_bind_date
    AND incident_date <= CURRENT_DATE
    AND validation_flag IS NULL;

-- Check the clean dataset
SELECT 
	COUNT(*) AS clean_records,
	(COUNT(*) * 100.0/ (SELECT COUNT(*) FROM insurance_claims))::NUMERIC(5,2) AS percentage_clean
FROM clean_insurance_claims









