USE bank_marketing_sql;

-- 01_quality
-- Unknown is an explicit missing-information category; retain it.
SELECT COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 SUM(CASE WHEN credit_default='unknown' THEN 1 ELSE 0 END) AS unknown_default,
 SUM(CASE WHEN pdays=999 THEN 1 ELSE 0 END) AS never_previously_contacted,
 SUM(CASE WHEN age<0 OR campaign<1 OR duration<0 OR subscribed NOT IN (0,1) THEN 1 ELSE 0 END) AS invalid_records
FROM bank;



-- 02_kpis
SELECT COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct,
 ROUND(AVG(campaign),2) AS avg_campaign_contacts,
 ROUND(AVG(duration),2) AS avg_last_call_seconds FROM bank;


-- 03_job_segments
WITH segments AS (
 SELECT job AS segment, COUNT(*) AS records, SUM(subscribed) AS subscriptions, AVG(subscribed) AS rate
 FROM bank GROUP BY job
)
SELECT segment, records, subscriptions, ROUND(100*rate,2) AS conversion_pct,
 ROUND(rate/(SELECT AVG(subscribed) FROM bank),2) AS lift,
 DENSE_RANK() OVER (ORDER BY rate DESC) AS conversion_rank
FROM segments ORDER BY rate DESC;


-- 04_age_segments
SELECT age_band AS segment, COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct FROM bank GROUP BY age_band ORDER BY age_band;


-- 05_channel
SELECT contact AS segment, COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct FROM bank GROUP BY contact ORDER BY conversion_pct DESC;


-- 06_contact_frequency
SELECT contact_band AS segment, COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct FROM bank GROUP BY contact_band ORDER BY contact_band;


-- 07_previous_outcome
SELECT poutcome AS segment, COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct FROM bank GROUP BY poutcome ORDER BY conversion_pct DESC;


-- 08_month
-- Pooled `month`-of-year comparison, not a continuous monthly time series.
SELECT `month` AS segment, COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct FROM bank GROUP BY `month`
ORDER BY CASE `month` WHEN 'jan' THEN 1 WHEN 'feb' THEN 2 WHEN 'mar' THEN 3 WHEN 'apr' THEN 4 WHEN 'may' THEN 5 WHEN 'jun' THEN 6 WHEN 'jul' THEN 7 WHEN 'aug' THEN 8 WHEN 'sep' THEN 9 WHEN 'oct' THEN 10 WHEN 'nov' THEN 11 ELSE 12 END;


-- 09_loan_context
-- Descriptive exposure indicators, not a credit-risk score.
SELECT housing, loan, COUNT(*) AS records, SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct FROM bank GROUP BY housing,loan ORDER BY records DESC;


-- 10_channel_adjusted
-- Compare channels within prior-outcome strata; this still does not identify causality.
SELECT poutcome,contact,COUNT(*) AS records,SUM(subscribed) AS subscriptions,
 ROUND(100.0*AVG(subscribed),2) AS conversion_pct FROM bank GROUP BY poutcome,contact ORDER BY poutcome,contact;


-- 11_candidate_segments
-- Exploratory candidates with minimum support; no predictive or causal claim.
WITH s AS (SELECT job,contact,poutcome,COUNT(*) AS records,SUM(subscribed) AS subscriptions,
 AVG(subscribed) AS rate FROM bank GROUP BY job,contact,poutcome HAVING COUNT(*)>=100)
SELECT s.*, ROUND(rate/(SELECT AVG(subscribed) FROM bank),2) AS lift
FROM s ORDER BY rate DESC LIMIT 10;
