
-- 1. Rank Properties by Price within Each City (Window Function)
-- Use case: Helps agencies analyze high-value properties in each city.
SELECT 
    p.property_id,
    l.city,
    p.price,
    RANK() OVER (PARTITION BY l.city ORDER BY p.price DESC) AS price_rank
FROM Properties p
JOIN Locations l ON p.location_id = l.location_id;


-- 2. Calculate the Running Total of Sales by Month (Window Function)
-- Use case: Tracks cumulative revenue growth over time.
SELECT 
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    SUM(sale_price) AS monthly_sales,
    SUM(SUM(sale_price)) OVER (ORDER BY DATE_FORMAT(transaction_date, '%Y-%m')) AS running_total_sales
FROM Transactions
GROUP BY month;

-- 3. Identify Agents with Above-Average Sales (Window & Aggregate Function)
-- Use case: Identifies top-performing agents for commissions and bonuses.
WITH AgentSales AS (
    SELECT 
        agent_id, 
        SUM(sale_price) AS total_sales
    FROM Transactions
    GROUP BY agent_id
)
SELECT 
    a.agent_id, 
    a.name, 
    s.total_sales
FROM AgentSales s
JOIN Agents a ON s.agent_id = a.agent_id
WHERE s.total_sales > (SELECT AVG(total_sales) FROM AgentSales);


-- 4. Properties with No Transactions in the Last 6 Months (LEFT JOIN & Date Filtering)
-- Use case: Helps agencies focus on properties that need marketing efforts.
SELECT 
    p.property_id, 
    p.price, 
    p.status
FROM Properties p
LEFT JOIN Transactions t 
    ON p.property_id = t.property_id 
    AND t.transaction_date >= CURDATE() - INTERVAL 6 MONTH
WHERE t.transaction_id IS NULL;

-- 5. Identify Tenants with Late Payments (CTE & Window Function)
-- Use case: Detects tenants who consistently delay payments.
WITH PaymentStatus AS (
    SELECT 
        r.property_id, 
        p.payment_date, 
        LEAD(p.payment_date) OVER (PARTITION BY r.property_id ORDER BY p.payment_date) AS next_payment
    FROM Payments p
    JOIN Rentals r ON p.rental_id = r.rental_id
)
SELECT * FROM PaymentStatus
WHERE DATEDIFF(next_payment, payment_date) > 30;


-- 6. Monthly Rental Income per City (JOIN & Aggregation)
-- Use case: Helps agencies evaluate high-revenue locations.
SELECT 
    l.city, 
    SUM(r.rent_amount) AS total_rental_income
FROM Rentals r
JOIN Properties p ON r.property_id = p.property_id
JOIN Locations l ON p.location_id = l.location_id
GROUP BY l.city
ORDER BY total_rental_income DESC;

-- 7. Agent Commission Analysis (Window Function)
-- Use case: Identifies top-earning agents.
SELECT 
    a.agent_id, 
    a.name, 
    SUM(c.amount) AS total_commission,
    RANK() OVER (ORDER BY SUM(c.amount) DESC) AS commission_rank
FROM Commissions c
JOIN Agents a ON c.agent_id = a.agent_id
GROUP BY a.agent_id, a.name;

-- 8. Average Selling Price Per Property Type (Aggregation)
-- Use case: Helps understand pricing trends in different property categories.
SELECT 
    p.property_type, 
    AVG(t.sale_price) AS avg_price
FROM Transactions t
JOIN Properties p ON t.property_id = p.property_id
GROUP BY p.property_type;


-- 9. Yearly Growth Rate of Sales (Window Function)
-- Use case: Analyzes business performance trends over time.
WITH YearlySales AS (
    SELECT 
        YEAR(transaction_date) AS year, 
        SUM(sale_price) AS total_sales
    FROM Transactions
    GROUP BY YEAR(transaction_date)
)
SELECT 
    year, 
    total_sales, 
    LAG(total_sales) OVER (ORDER BY year) AS previous_year_sales,
    (total_sales - LAG(total_sales) OVER (ORDER BY year)) / LAG(total_sales) OVER (ORDER BY year) * 100 AS growth_rate
FROM YearlySales;
