USE sales_performance_tracker;
SELECT COUNTRY, ROUND(SUM(SALES),2) AS sales, COUNT(DISTINCT ORDERNUMBER) AS orders,
 COUNT(DISTINCT CUSTOMERNAME) AS customers,
 ROUND(100.0*SUM(SALES)/(SELECT SUM(SALES) FROM sales),2) AS sales_share_pct
FROM sales GROUP BY COUNTRY ORDER BY sales DESC,COUNTRY;
-- NA is a valid territory code here (North America); do not convert it to NULL.
SELECT TERRITORY, ROUND(SUM(SALES),2) AS sales FROM sales GROUP BY TERRITORY ORDER BY sales DESC,TERRITORY;
