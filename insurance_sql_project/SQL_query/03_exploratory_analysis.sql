-- =============================================
-- Fraud Analysis
-- =============================================

-- Calculate percentage of claims reported as fraud

SELECT ROUND((COUNT(CASE WHEN fraud_reported='Y' THEN 1 END) * 1.0 / COUNT(*)) * 100, 2) AS fraud_percentage
FROM insurance_claims;

-- Identify states with the highest fraud rates

SELECT 
    policy_state, 
    COUNT(*) AS total_claims,
    COUNT(CASE WHEN fraud_reported='Y' THEN 1 END) AS fraud_claims,
    ROUND((COUNT(CASE WHEN fraud_reported='Y' THEN 1 END) * 1.0 / COUNT(*)) * 100, 2) AS fraud_rate
FROM insurance_claims
GROUP BY policy_state
ORDER BY fraud_rate DESC;

-- Compare average claim amounts between fraud and non-fraud cases
SELECT 
	CASE 
		WHEN fraud_reported = 'Y' THEN 'Fraud'
		WHEN fraud_reported = 'N' THEN 'Non-Fraud'
		ELSE 'Unknown'
	END AS fraud_status,
	ROUND(AVG(total_claim_amount), 2) AS avg_claim_amount
FROM insurance_claims
GROUP BY fraud_status;

-- =============================================
-- Claims by Policy & Customer
-- =============================================

-- Find policy states with the highest average claim amount

SELECT 
	policy_state,
	COUNT(*) AS total_claims,
	ROUND(AVG(total_claim_amount),2) AS avg_claim_amount
FROM insurance_claims
GROUP BY policy_state
ORDER BY avg_claim_amount desc;

-- Analyze claim amounts by customer age bands (<25, 25–40, 40–60, 60+)

SELECT 
	CASE 
		WHEN age < 25 THEN 'Under 25'
		WHEN age BETWEEN 25 AND 40 THEN '25 to 40'
		WHEN age BETWEEN 40 AND 60 THEN '40 to 60'
		ELSE '60 and over'
	END AS age_group,
	COUNT(*) AS total_claims,
    ROUND(AVG(total_claim_amount),2) AS avg_claim_amount
FROM insurance_claims
GROUP BY age_group
ORDER BY avg_claim_amount DESC;
	 
-- Check relationship between policy deductible and average claim amount

SELECT 
	policy_deductable,
	COUNT(*) AS total_claims,
	ROUND(AVG(total_claim_amount),2) AS avg_claim_amount	
FROM insurance_claims
GROUP BY policy_deductable
ORDER BY policy_deductable;

-- =============================================
-- Incident Insights
-- =============================================

-- Count most common incident types

SELECT 
	COALESCE(incident_type,'UNKNOWN') AS incident_type, 
	COUNT(*) AS incident_count
FROM insurance_claims
GROUP BY incident_type
ORDER BY incident_count DESC;

-- Find collision types with the highest average claim amounts

SELECT 
	COALESCE(collision_type,'UNKNOWN') AS collision_type,
	COUNT(*) AS total_claims,
	ROUND(AVG(total_claim_amount),2) avg_claim_amount
FROM insurance_claims
WHERE collision_type IS NOT NULL
GROUP BY collision_type
ORDER BY avg_claim_amount DESC;

-- Analyze claims by time of day (incident_hour_of_the_day)

SELECT 
	incident_hour_of_the_day,
	COUNT(*) AS frequency
FROM insurance_claims
GROUP BY incident_hour_of_the_day
ORDER BY incident_hour_of_the_day;

-- =============================================
-- Geographic & Vehicle Trends
-- =============================================

-- Identify top cities and states by number of claims

SELECT
	incident_state,
	incident_city,
	COUNT(*) AS total_claims
FROM insurance_claims
GROUP BY incident_state,incident_city
ORDER BY total_claims DESC;

-- Find most common auto makes and models in claims

SELECT 
	auto_make, 
	auto_model,
	COUNT(*) AS total_claims
FROM insurance_claims
GROUP BY auto_make, auto_model
ORDER BY total_claims DESC;

-- Check whether vehicle year impacts average claim amount

SELECT
	auto_year,
	COUNT(*) AS total_claims,
	ROUND(AVG(total_claim_amount),2) AS avg_claim_amount
FROM insurance_claims
GROUP BY auto_year
ORDER BY auto_year;

-- =============================================
-- KPI Definitions
-- =============================================

-- Baseline KPIs: Total claims, total payouts, avg claim amount, fraud rate

SELECT
    COUNT(*) AS total_claims,
    SUM(total_claim_amount) AS total_payout_amount,
    ROUND(AVG(total_claim_amount),2) AS avg_claim_amount,
    ROUND((COUNT(CASE WHEN fraud_reported='Y' THEN 1 END) * 100.0 / COUNT(*)), 2) AS fraud_rate_pct
FROM insurance_claims;

-- Total claim payout amount (sum of all claims)

SELECT SUM(total_claim_amount) AS total_claim_payout
FROM insurance_claims

-- Top 5 states by claim volume

SELECT
	incident_state,
	COUNT(*) AS total_claims
FROM insurance_claims
GROUP BY incident_state
ORDER BY total_claims DESC
LIMIT 5;

-- Top 5 occupations with the highest fraud claims

SELECT
	insured_occupation,
	COUNT(*) AS fraud_claims
FROM insurance_claims
WHERE fraud_reported = 'Y'
GROUP BY insured_occupation
ORDER BY fraud_claims DESC
LIMIT 5;

-- =============================================
-- Trend Analysis
-- =============================================

-- Claims trend year by year

SELECT
	EXTRACT(MONTH FROM incident_date) AS incident_month,
	COUNT(*) AS total_claims
FROM insurance_claims
GROUP BY incident_month
ORDER BY incident_month;

-- Fraud trend over time

-- Fraud trend by month

SELECT
    EXTRACT(MONTH FROM incident_date) AS claim_month,
    COUNT(*) AS total_claims,
    COUNT(CASE WHEN fraud_reported = 'Y' THEN 1 END) AS fraud_claims,
    ROUND(
        (COUNT(CASE WHEN fraud_reported = 'Y' THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS fraud_rate_pct
FROM insurance_claims
WHERE incident_date IS NOT NULL
GROUP BY claim_month
ORDER BY claim_month;

-- Average claim amount trend per year

SELECT 
	EXTRACT(MONTH FROM incident_date) AS claim_month,
	ROUND(AVG(total_claim_amount),2) AS avg_claim
FROM insurance_claims
GROUP BY claim_month
ORDER BY claim_month;