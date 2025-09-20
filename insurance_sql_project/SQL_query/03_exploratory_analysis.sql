SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'insurance_claims';

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
-- Analyze claim amounts by customer age bands (<25, 25–40, 40–60, 60+)
-- Check relationship between policy deductible and average claim amount


-- =============================================
-- Incident Insights
-- =============================================

-- Count most common incident types
-- Find collision types with the highest average claim amounts
-- Analyze claims by time of day (incident_hour_of_the_day)


-- =============================================
-- Geographic & Vehicle Trends
-- =============================================

-- Identify top cities and states by number of claims
-- Find most common auto makes and models in claims
-- Check whether vehicle year impacts average claim amount


-- =============================================
-- KPI Definitions
-- =============================================

-- Total number of claims
-- Total claim payout amount (sum of all claims)
-- Average claim amount across all records
-- Fraud rate percentage
-- Top 5 states by claim volume
-- Top 5 occupations with highest fraud claims


-- =============================================
-- Trend Analysis
-- =============================================

-- Claims trend year by year
-- Fraud trend over time
-- Average claim amount trend per year
