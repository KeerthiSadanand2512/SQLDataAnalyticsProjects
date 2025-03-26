### *1. Rank Properties by Price within Each City (Window Function)*
SELECT 
    p.property_id,
    l.city,
    p.price,
    RANK() OVER (PARTITION BY l.city ORDER BY p.price DESC) AS price_rank
FROM real_estate.Properties p
JOIN real_estate.Locations l ON p.location_id = l.location_id
ORDER BY p.property_id DESC;

### *2. Calculate the Running Total of Sales by Month (Window Function)*
SELECT 
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    SUM(sale_price) AS monthly_sales,
    SUM(SUM(sale_price)) OVER (ORDER BY DATE_FORMAT(transaction_date, '%Y-%m')) AS running_total_sales
FROM real_estate.Transactions
GROUP BY month 
ORDER BY month DESC;

### *3. Identify Agents with Above-Average Sales (Window & Aggregate Function)*

WITH AgentSales AS (
    SELECT 
        agent_id, 
        SUM(sale_price) AS total_sales
    FROM real_estate.Transactions
    GROUP BY agent_id
)
SELECT 
    a.agent_id, 
    a.name, 
    s.total_sales
FROM AgentSales s
JOIN real_estate.Agents a ON s.agent_id = a.agent_id
WHERE s.total_sales > (SELECT AVG(total_sales) FROM AgentSales);

### *4. Properties with No Transactions in the Last 6 Months (LEFT JOIN & Date Filtering)*
SELECT 
    p.property_id, 
    p.price, 
    p.status
FROM real_estate.Properties p
LEFT JOIN real_estate.Transactions t 
    ON p.property_id = t.property_id 
    AND t.transaction_date >= CURDATE() - INTERVAL 6 MONTH
WHERE t.transaction_id IS NULL;

### *5. Identify Tenants with Late Payments (CTE & Window Function)*
WITH PaymentStatus AS (
    SELECT 
        r.property_id, 
        p.payment_date, 
        LEAD(p.payment_date) OVER (PARTITION BY r.property_id ORDER BY p.payment_date) AS next_payment
    FROM real_estate.Payments p
    JOIN real_estate.Rentals r ON p.rental_id = r.rental_id
)
SELECT * FROM PaymentStatus
WHERE DATEDIFF(next_payment, payment_date) > 30;

### *6. Monthly Rental Income per City (JOIN & Aggregation)*
SELECT 
    l.city, 
    SUM(r.rent_amount) AS total_rental_income
FROM real_estate.Rentals r
JOIN real_estate.Properties p ON r.property_id = p.property_id
JOIN real_estate.Locations l ON p.location_id = l.location_id
GROUP BY l.city
ORDER BY total_rental_income DESC;

### *7. Agent Commission Analysis (Window Function)*
SELECT 
    a.agent_id, 
    a.name, 
    SUM(c.amount) AS total_commission,
    RANK() OVER (ORDER BY SUM(c.amount) DESC) AS commission_rank
FROM real_estate.Commissions c
JOIN real_estate.Agents a ON c.agent_id = a.agent_id
GROUP BY a.agent_id, a.name;

### *8. Average Selling Price Per Property Type (Aggregation)*
SELECT 
    p.property_type, 
    AVG(t.sale_price) AS avg_price
FROM real_estate.Transactions t
JOIN real_estate.Properties p ON t.property_id = p.property_id
GROUP BY p.property_type
ORDER BY p.property_type;

### *9. Identify Properties with Frequent Maintenance Issues (Join & Count)*
SELECT 
    p.property_id, 
    COUNT(m.request_id) AS maintenance_count
FROM real_estate.MaintenanceRequests m
LEFT JOIN real_estate.Properties p ON m.property_id = p.property_id
GROUP BY p.property_id
HAVING COUNT(m.request_id) > 1;

### *10. Yearly Growth Rate of Sales (Window Function)*
WITH YearlySales AS (
    SELECT 
        YEAR(transaction_date) AS years, 
        SUM(sale_price) AS total_sales
    FROM real_estate.Transactions
    GROUP BY YEAR(transaction_date)
)
SELECT 
    years, 
    total_sales, 
    LAG(total_sales) OVER (ORDER BY years) AS previous_year_sales,
    (total_sales - LAG(total_sales) OVER (ORDER BY years)) / LAG(total_sales) OVER (ORDER BY years) * 100 AS growth_rate
FROM YearlySales
ORDER BY YearlySales.years DESC;

