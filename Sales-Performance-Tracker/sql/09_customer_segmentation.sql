USE sales_performance_tracker;
-- RFM on all statuses, snapshot = one day after last observed order.
-- Quartile scores use explicit thresholds; equal values receive equal scores.
-- PERCENT_RANK handles ties; small cohorts may yield uneven score counts.
CREATE OR REPLACE VIEW customer_rfm AS
WITH rfm AS (
 SELECT CUSTOMERNAME,
 DATEDIFF((SELECT DATE_ADD(MAX(ORDERDATE),INTERVAL 1 DAY) FROM sales),MAX(ORDERDATE)) AS recency_days,
 COUNT(DISTINCT ORDERNUMBER) AS frequency, SUM(SALES) AS monetary
 FROM sales GROUP BY CUSTOMERNAME
), scores AS (
 SELECT *, 4-LEAST(3,FLOOR(PERCENT_RANK() OVER (ORDER BY recency_days)*4)) AS r_score,
 1+LEAST(3,FLOOR(PERCENT_RANK() OVER (ORDER BY frequency)*4)) AS f_score,
 1+LEAST(3,FLOOR(PERCENT_RANK() OVER (ORDER BY monetary)*4)) AS m_score FROM rfm
)
SELECT *, CASE WHEN r_score>=3 AND f_score>=3 AND m_score>=3 THEN 'Champions'
 WHEN r_score<=2 AND f_score>=3 THEN 'At risk'
 WHEN f_score>=3 THEN 'Loyal'
 WHEN r_score>=3 THEN 'Recent / developing'
 ELSE 'Occasional / inactive' END AS segment FROM scores;
SELECT segment, COUNT(*) AS customers, ROUND(SUM(monetary),2) AS sales,
 ROUND(AVG(recency_days),1) AS average_recency_days FROM customer_rfm
GROUP BY segment ORDER BY sales DESC,segment;
SELECT * FROM customer_rfm ORDER BY monetary DESC,CUSTOMERNAME;
