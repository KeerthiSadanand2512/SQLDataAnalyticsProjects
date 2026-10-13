USE sales_performance_tracker;
-- All-status order value, not recognized accounting revenue. Currency unspecified.
SELECT 'All statuses' AS scope, COUNT(*) AS order_lines, COUNT(DISTINCT ORDERNUMBER) AS orders,
 COUNT(DISTINCT CUSTOMERNAME) AS customers, SUM(QUANTITYORDERED) AS units,
 ROUND(SUM(SALES),2) AS sales, ROUND(SUM(SALES)/COUNT(DISTINCT ORDERNUMBER),2) AS average_order_value
FROM sales
UNION ALL
SELECT 'Shipped only', COUNT(*), COUNT(DISTINCT ORDERNUMBER), COUNT(DISTINCT CUSTOMERNAME),
 SUM(QUANTITYORDERED), ROUND(SUM(SALES),2), ROUND(SUM(SALES)/COUNT(DISTINCT ORDERNUMBER),2)
FROM sales WHERE STATUS='Shipped';
