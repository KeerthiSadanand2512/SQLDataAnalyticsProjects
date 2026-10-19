USE real_estate;
-- Fixed snapshot ensures reproducible results. Edit this date for another period.
SET @as_of_date = DATE('2025-12-31');

-- 1. Rank properties within a city/state/country; show ties with RANK.
SELECT p.property_id, l.city, l.state, p.asking_price,
       RANK() OVER (PARTITION BY l.city, l.state, l.country ORDER BY p.asking_price DESC) AS price_rank
FROM Properties p JOIN Locations l USING (location_id)
ORDER BY l.city, price_rank, p.property_id;

-- 2. Monthly sales volume and cumulative sales volume (not agency revenue).
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS sales_month,
       SUM(sale_price) AS sales_volume,
       SUM(SUM(sale_price)) OVER (ORDER BY DATE_FORMAT(transaction_date, '%Y-%m')) AS cumulative_sales_volume
FROM Transactions WHERE transaction_date <= @as_of_date
GROUP BY sales_month ORDER BY sales_month;

-- 3. Above-average agents, including agents with zero sales in the benchmark.
WITH AgentSales AS (
    SELECT a.agent_id, a.name, COALESCE(SUM(t.sale_price), 0) AS sales_volume
    FROM Agents a LEFT JOIN Listings l ON l.agent_id = a.agent_id
    LEFT JOIN Transactions t ON t.listing_id = l.listing_id AND t.transaction_date <= @as_of_date
    GROUP BY a.agent_id, a.name
)
SELECT * FROM AgentSales WHERE sales_volume > (SELECT AVG(sales_volume) FROM AgentSales)
ORDER BY sales_volume DESC, agent_id;

-- 4. Open sale listings at least 90 days old as of the reporting date.
SELECT l.listing_id, p.property_id, DATEDIFF(@as_of_date, l.listing_date) AS days_on_market
FROM Listings l JOIN Properties p USING (property_id)
WHERE l.listing_type = 'Sale' AND l.listing_date <= @as_of_date - INTERVAL 90 DAY
  AND l.expiration_date >= @as_of_date AND (l.closed_date IS NULL OR l.closed_date > @as_of_date)
ORDER BY days_on_market DESC, l.listing_id;

-- 5. Outstanding overdue rent. Aggregate payments first to avoid multiplying charges.
WITH Paid AS (
    SELECT charge_id, SUM(amount) AS amount_paid FROM Payments
    WHERE payment_date <= @as_of_date GROUP BY charge_id
)
SELECT t.tenant_id, t.name, c.charge_id, c.due_date,
       c.amount_due, COALESCE(p.amount_paid, 0) AS amount_paid,
       c.amount_due - COALESCE(p.amount_paid, 0) AS outstanding_balance,
       DATEDIFF(@as_of_date, c.due_date) AS days_overdue
FROM RentCharges c LEFT JOIN Paid p USING (charge_id)
JOIN Rentals r USING (rental_id) JOIN LeaseAgreements la USING (lease_id)
JOIN Tenants t USING (tenant_id)
WHERE c.due_date < @as_of_date AND c.amount_due > COALESCE(p.amount_paid, 0)
ORDER BY outstanding_balance DESC, c.charge_id;

-- 6. Cash collected by calendar month and city; independent of charge period.
SELECT DATE_FORMAT(pay.payment_date, '%Y-%m') AS payment_month,
       l.city, l.state, l.country, SUM(pay.amount) AS rent_collected
FROM Payments pay JOIN RentCharges c USING (charge_id)
JOIN Rentals r USING (rental_id) JOIN LeaseAgreements la USING (lease_id)
JOIN Properties p USING (property_id) JOIN Locations l USING (location_id)
WHERE pay.payment_date <= @as_of_date
GROUP BY payment_month, l.city, l.state, l.country ORDER BY payment_month, l.city;

-- 7. Commission earnings, including zero-earning agents.
SELECT a.agent_id, a.name, COALESCE(SUM(c.amount), 0) AS commission_earned,
       RANK() OVER (ORDER BY COALESCE(SUM(c.amount), 0) DESC) AS commission_rank
FROM Agents a LEFT JOIN Listings l ON a.agent_id = l.agent_id
LEFT JOIN Transactions t ON t.listing_id = l.listing_id AND t.transaction_date <= @as_of_date
LEFT JOIN Commissions c ON c.transaction_id = t.transaction_id
GROUP BY a.agent_id, a.name ORDER BY commission_rank, a.agent_id;

-- 8. Average completed sale price by property type.
SELECT p.property_type, COUNT(*) AS sale_count, ROUND(AVG(t.sale_price), 2) AS average_sale_price
FROM Transactions t JOIN Listings l USING (listing_id) JOIN Properties p USING (property_id)
WHERE t.transaction_date <= @as_of_date GROUP BY p.property_type ORDER BY p.property_type;

-- 9. Compare complete calendar years only. Missing adjacent year gives NULL growth.
WITH Yearly AS (
    SELECT YEAR(transaction_date) AS sales_year, SUM(sale_price) AS sales_volume
    FROM Transactions WHERE transaction_date < MAKEDATE(YEAR(@as_of_date) +
        IF(DATE_FORMAT(@as_of_date, '%m-%d') = '12-31', 1, 0), 1)
    GROUP BY YEAR(transaction_date)
)
SELECT y.sales_year, y.sales_volume, prev.sales_volume AS previous_year_volume,
       ROUND(100.0 * (y.sales_volume - prev.sales_volume) / NULLIF(prev.sales_volume, 0), 2) AS growth_pct
FROM Yearly y LEFT JOIN Yearly prev ON prev.sales_year = y.sales_year - 1
ORDER BY y.sales_year;

-- 10. Repeat maintenance and completed-job turnaround.
SELECT property_id, COUNT(*) AS request_count, SUM(cost) AS recorded_cost,
       ROUND(AVG(CASE WHEN completed_date <= @as_of_date THEN DATEDIFF(completed_date, request_date) END), 2) AS average_completed_days
FROM MaintenanceRequests WHERE request_date <= @as_of_date
GROUP BY property_id HAVING COUNT(*) > 1 ORDER BY request_count DESC, property_id;

-- 11. Expected rent by charge month, distinct from cash collection month.
SELECT DATE_FORMAT(period_start, '%Y-%m') AS charge_month, SUM(amount_due) AS expected_rent
FROM RentCharges WHERE period_start <= @as_of_date
GROUP BY charge_month ORDER BY charge_month;

-- 12. Late-settled charges: balance is zero today, but was positive after due date.
SELECT c.charge_id, c.due_date, SUM(p.amount) AS paid_as_of_date,
       SUM(CASE WHEN p.payment_date <= c.due_date THEN p.amount ELSE 0 END) AS paid_by_due_date
FROM RentCharges c JOIN Payments p ON p.charge_id = c.charge_id AND p.payment_date <= @as_of_date
WHERE c.due_date < @as_of_date
GROUP BY c.charge_id, c.due_date, c.amount_due
HAVING SUM(p.amount) >= c.amount_due
   AND SUM(CASE WHEN p.payment_date <= c.due_date THEN p.amount ELSE 0 END) < c.amount_due
ORDER BY c.charge_id;
