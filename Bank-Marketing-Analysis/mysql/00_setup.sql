-- MySQL 8.0+ / 8.4. No existing tables are dropped.
CREATE DATABASE IF NOT EXISTS bank_marketing_sql CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bank_marketing_sql;
SET NAMES utf8mb4;
CREATE TABLE IF NOT EXISTS bank_raw (record_id INT PRIMARY KEY, age INT NOT NULL, job VARCHAR(64) NOT NULL, marital VARCHAR(64) NOT NULL, education VARCHAR(64) NOT NULL, credit_default VARCHAR(64) NOT NULL, housing VARCHAR(64) NOT NULL, loan VARCHAR(64) NOT NULL, contact VARCHAR(64) NOT NULL, `month` VARCHAR(64) NOT NULL, day_of_week VARCHAR(64) NOT NULL, duration INT NOT NULL, campaign INT NOT NULL, pdays INT NOT NULL, previous INT NOT NULL, poutcome VARCHAR(64) NOT NULL, emp_var_rate DECIMAL(10,4) NOT NULL, cons_price_idx DECIMAL(10,4) NOT NULL, cons_conf_idx DECIMAL(10,4) NOT NULL, euribor3m DECIMAL(10,4) NOT NULL, nr_employed DECIMAL(10,4) NOT NULL, y VARCHAR(64) NOT NULL);
CREATE OR REPLACE VIEW bank AS SELECT bank_raw.*, CASE y WHEN 'yes' THEN 1 ELSE 0 END AS subscribed,
 CASE WHEN age<30 THEN 'Under 30' WHEN age<40 THEN '30–39' WHEN age<50 THEN '40–49' WHEN age<60 THEN '50–59' ELSE '60+' END AS age_band,
 CASE WHEN campaign=1 THEN '1' WHEN campaign=2 THEN '2' WHEN campaign=3 THEN '3' WHEN campaign<=5 THEN '4–5' ELSE '6+' END AS contact_band
 FROM bank_raw;
