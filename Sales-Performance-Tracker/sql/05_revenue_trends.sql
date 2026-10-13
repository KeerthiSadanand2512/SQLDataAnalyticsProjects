USE sales_performance_tracker;
WITH monthly AS (
 SELECT DATE_FORMAT(ORDERDATE,'%Y-%m') AS month, SUM(SALES) AS sales,
 COUNT(DISTINCT ORDERNUMBER) AS orders FROM sales GROUP BY DATE_FORMAT(ORDERDATE,'%Y-%m')
), changes AS (SELECT *, LAG(sales) OVER (ORDER BY month) AS previous_sales FROM monthly)
SELECT month, ROUND(sales,2) AS sales, orders,
 ROUND(100.0*(sales-previous_sales)/NULLIF(previous_sales,0),2) AS month_growth_pct
FROM changes ORDER BY month;
-- Comparable Jan-May window: 2005 ends May 31. No full-year 2005 comparison.
SELECT YEAR_ID AS year, ROUND(SUM(SALES),2) AS jan_may_sales,
 COUNT(DISTINCT ORDERNUMBER) AS orders FROM sales WHERE MONTH_ID <= 5 GROUP BY YEAR_ID ORDER BY year;
SELECT YEAR_ID AS year, ROUND(SUM(SALES),2) AS sales, COUNT(DISTINCT ORDERNUMBER) AS orders
FROM sales GROUP BY YEAR_ID ORDER BY year;
