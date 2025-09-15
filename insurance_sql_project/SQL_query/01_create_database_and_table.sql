CREATE DATABASE insurance_db;

-- Table Schema --
CREATE TABLE insurance_claims (
    claim_id SERIAL PRIMARY KEY,                  -- internal surrogate key
    months_as_customer INT,
    age INT,
    policy_number VARCHAR(50),
    policy_bind_date DATE,
    policy_state CHAR(2),
    policy_csl VARCHAR(20),                       -- liability limit, stored as text (e.g. "250/500")
    policy_deductable INT,
    policy_annual_premium NUMERIC(12,2),
    umbrella_limit BIGINT,
    insured_zip VARCHAR(10),
    insured_sex VARCHAR(10),
    insured_education_level VARCHAR(50),
    insured_occupation VARCHAR(100),
    insured_hobbies VARCHAR(100),
    insured_relationship VARCHAR(50),
    capital_gains INT,
    capital_loss INT,
    incident_date DATE,
    incident_type VARCHAR(100),
    collision_type VARCHAR(50),
    incident_severity VARCHAR(50),
    authorities_contacted VARCHAR(50),
    incident_state CHAR(2),
    incident_city VARCHAR(100),
    incident_location VARCHAR(200),
    incident_hour_of_the_day INT,
    number_of_vehicles_involved INT,
    property_damage VARCHAR(10),                  -- may contain "YES"/"NO"/"?"
    bodily_injuries INT,
    witnesses INT,
    police_report_available VARCHAR(10),          -- "YES"/"NO"/"?"
    total_claim_amount NUMERIC(12,2),
    injury_claim NUMERIC(12,2),
    property_claim NUMERIC(12,2),
    vehicle_claim NUMERIC(12,2),
    auto_make VARCHAR(50),
    auto_model VARCHAR(50),
    auto_year INT,
    fraud_reported CHAR(1),                       -- 'Y' or 'N'
    raw_extra_col VARCHAR(255)                    -- placeholder for _c39 (drop later if always null)
);

-- loading data from csv --
COPY insurance_claims(
    months_as_customer,
    age,
    policy_number,
    policy_bind_date,
    policy_state,
    policy_csl,
    policy_deductable,
    policy_annual_premium,
    umbrella_limit,
    insured_zip,
    insured_sex,
    insured_education_level,
    insured_occupation,
    insured_hobbies,
    insured_relationship,
    capital_gains,
    capital_loss,
    incident_date,
    incident_type,
    collision_type,
    incident_severity,
    authorities_contacted,
    incident_state,
    incident_city,
    incident_location,
    incident_hour_of_the_day,
    number_of_vehicles_involved,
    property_damage,
    bodily_injuries,
    witnesses,
    police_report_available,
    total_claim_amount,
    injury_claim,
    property_claim,
    vehicle_claim,
    auto_make,
    auto_model,
    auto_year,
    fraud_reported,
    raw_extra_col
)
FROM 'D:/SQL_portfolio_project/insurance_sql_project/dataset/insurance_claims.csv'
DELIMITER ','
CSV HEADER;
