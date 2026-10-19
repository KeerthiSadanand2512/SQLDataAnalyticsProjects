USE bank_marketing_sql;
SELECT COUNT(*)=41188 AS row_count_pass,
 SUM(subscribed)=4640 AS subscription_count_pass,
 ROUND(100*AVG(subscribed),2)=11.27 AS conversion_pass,
 COUNT(DISTINCT record_id)=41188 AS row_id_pass,
 SUM(credit_default='unknown')=8597 AS unknown_default_pass,
 SUM(pdays=999)=39673 AS pdays_sentinel_pass
FROM bank;
-- Every result above should equal 1.
