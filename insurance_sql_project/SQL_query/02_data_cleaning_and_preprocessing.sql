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









