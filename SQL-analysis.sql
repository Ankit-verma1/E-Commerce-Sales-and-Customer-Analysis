-- CREATING CUSTOMER TABLE
CREATE TABLE customers(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
gender VARCHAR(20),
age INT,
city VARCHAR(50),
state VARCHAR(50)
);

-- CREATING PRODUCT TABLE
CREATE TABLE products(
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
sub_category VARCHAR(50),
unit_price DECIMAL(10,2),
unit_cost DECIMAL(10,2)
);

--CREATING ORDERS TABLE
CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id INT,
product_id INT,
order_date DATE,
quantity INT,
discount DECIMAL(10,2),
FOREIGN KEY (customer_id )
REFERENCES customers(customer_id),
FOREIGN KEY(product_id)
REFERENCES products(product_id)
);

-- CREATING PAYMENTS TABLE
CREATE TABLE payments(
payment_id INT PRIMARY KEY,
order_id INT,
payment_method VARCHAR(30),
payment_status VARCHAR(30),
payment_date DATE,
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
);

--CREATING RETURNS TABLE
CREATE TABLE returns(
return_id INT PRIMARY KEY,
order_id INT,
return_date DATE,
return_raeson VARCHAR(100),
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
);


SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM payments;

SELECT 
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'products'
ORDER BY ordinal_position;

-- REVIEWING EACH TABLES NUMBER OF ROWS
SELECT 'customers' AS table_name, COUNT(*) AS toatl_rows FROM customers
UNION ALL
SELECT 'products',COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL 
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'returns',COUNT(*) FROM returns;

-- REVIEWING EVERY TABLES 5 ROWS
SELECT * FROM CUSTOMERS LIMIT 5;
SELECT * FROM PRODUCTS LIMIT 5;
SELECT * FROM ORDERS LIMIT 5;
SELECT * FROM PAYMENTS LIMIT 5;
SELECT *  FROM RETURNS LIMIT 5;


-- CHECKING NULL OR EMPTY CELLS IN DATASET
SELECT * FROM CUSTOMERS 
WHERE age IS NULL OR city IS NULL;

SELECT * FROM PRODUCTS
WHERE  unit_price IS NULL OR unit_cost IS NULL;

SELECT * FROM ORDERS
WHERE order_date IS NULL OR quantity IS NULL OR discount IS NULL;


-- ANALYSING SALES, COST AND PROFIT
SELECT 
 o.order_id,
 o.product_id,
 p.product_name,
 o.quantity,
 o.discount,
 p.unit_price,
 p.unit_cost
FROM orders o
JOIN products p ON o.product_id=p.product_id;


-- CALCULATING SALES AMOUNT (Sales = Quantity × Unit Price × (1 − Discount/100))

SELECT o.order_id,
o.product_id,
p.product_name,
o.quantity,
o.discount,
p.unit_price,
p.unit_cost,
o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100) AS sales
FROM orders o 
JOIN products p ON o.product_id=p.product_id;

-- CALCULATING COST AMOUNT (Cost = Quantity × Unit Cost)

SELECT o.order_id,
o.product_id,
p.product_name,
o.quantity,
o.discount,
p.unit_price,
p.unit_cost,
o.quantity*p.unit_cost AS cost
FROM orders o
JOIN products p ON o.product_id=p.product_id;

-- CALCULATING PROFIT AMOUNT (Profit = Sales − Cost)

SELECT o.order_id,
p.product_id,
p.product_name,
o.quantity,
o.discount,
p.unit_price,
p.unit_cost,

o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100) AS sales,
o.quantity*p.unit_price AS cost,

o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100) - o.quantity*p.unit_cost AS profit

FROM orders o
JOIN products p ON o.product_id=p.product_id;             


-- CALCULATING TOTAL SALES
SELECT SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100)) AS Total_sales
FROM orders o
JOIN products p ON o.product_id=p.product_id;


-- CALCULATING TOATL PROFIT (total profit = total_sales-toatl_cost)
SELECT SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100)-o.quantity*p.unit_cost) AS total_profit
FROM orders o
JOIN products p ON o.product_id=p.product_id;

-- CALCULATING PROFIT MARGIN (Profit Margin = Profit ÷ Sales × 100)
SELECT 
ROUND(
SUM(o.quantity*p.unit_price
*(1-COALESCE(o.discount,0)/100)
- o.quantity*p.unit_cost
)
/
SUM(o.quantity*p.unit_price
*(1-COALESCE(o.discount,0)/100)
)*100,
2)
AS profit_margin
FROM orders o
JOIN products p ON o.product_id=p.product_id;

-- CALCULATE MONTHLY SALES TREND

SELECT DATE_TRUNC('month',o.order_date) AS month,
ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100)),
2) AS monthly_sales
FROM orders o 
JOIN products p ON o.product_id=p.product_id
WHERE o.order_date IS NOT NULL
GROUP BY DATE_TRUNC('month',o.order_date)
ORDER BY month;


-- CALCULATING CATEGORY WISE SALES
SELECT p.category,
ROUND(SUM(o.quantity*p.unit_cost*(1-COALESCE(o.discount,0)/100)),2) AS total_sales
FROM orders o 
JOIN products p ON o.product_id=p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- TOP PRODUCT BY SALES
SELECT p.product_name,p.category, 
ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100))
,2
) AS total_sales
FROM orders o 
JOIN products p ON o.product_id=p.product_id
GROUP BY p.product_name,p.category
ORDER BY total_sales DESC
LIMIT 10;

-- Customer Analysis
-- ANALAYSING WHICH CUSTOMER GENERATE THE MOST SALES

SELECT c.customer_id,c.customer_name,c.gender,c.age,c.city,c.state,
ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100))
,2) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id
GROUP BY c.customer_id,c.customer_name,c.gender,c.age,c.city,c.state
ORDER BY total_sales DESC
LIMIT 10;


--Repeat Customers
-- ANALYSING THE CUSTOMERS WHO ORDER FREQUENTLY
SELECT c.customer_id,c.customer_name,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING COUNT(o.order_id)>1
ORDER BY total_orders DESC
LIMIT 10;

-- TOTAL REPEAT CUSTOMERS
SELECT COUNT(*) AS repeat_customers
FROM(
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)>1
) AS repeat_customers_list;

-- REPEAT CUSTOMER PERCENTAGE
SELECT
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS repeat_customer_list;


-- STATE WISE SALES ANALYSIS
-- FROM WHICH STATES HOW MUCH SALES ARE GENERATED ?
SELECT c.state,
ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100))
,2) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id 
GROUP BY c.state 
ORDER BY total_sales DESC;

-- Payment Method Analysis
SELECT payment_method,COUNT(*) AS total_payment_method
FROM payments
GROUP BY payment_method
ORDER BY payment_method DESC;

-- Payment Status Analysis
-- Now let's check how many payments were Completed, Pending, Failed, etc.

SELECT payment_status, COUNT(*) AS status_count
FROM payments
GROUP BY payment_status
ORDER BY status_count DESC;

--Returns Analysis
SELECT COUNT(*) AS total_return
FROM returns;

-- Analysing return rate 
SELECT ROUND(
COUNT(*)*100/(SELECT COUNT(*) FROM orders)
,2)
FROM returns;

-- Return Reasons Analysis
SELECT return_raeson, COUNT(*) AS total_return
FROM returns
GROUP BY return_raeson
ORDER BY total_return DESC;

-- Most Returned Products
SELECT p.product_name,p.category,COUNT(r.return_id) AS total_return
FROM returns r
JOIN orders o ON r.order_id=o.order_id
JOIN products p ON o.product_id=p.product_id
GROUP BY p.product_name,p.category
ORDER BY total_return DESC
LIMIT 10;


-- Return Rate by Product
SELECT
    p.product_name,
    p.category,
    COUNT(o.order_id) AS total_orders,
    COUNT(r.return_id) AS total_returns,
    ROUND(
        COUNT(r.return_id) * 100.0 / COUNT(o.order_id),
        2
    ) AS return_rate
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
LEFT JOIN returns r
    ON o.order_id = r.order_id
GROUP BY
    p.product_name,
    p.category
HAVING COUNT(o.order_id) >= 5
ORDER BY return_rate DESC;


-- Analysing Profit by Category
SELECT p.category,
ROUND(SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100) - o.quantity-p.unit_cost) 
,2) AS total_profit
FROM orders o 
JOIN products p ON o.product_id=p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;

-- Analysing highest profit genrated products

SELECT p.product_name,p.category,
ROUND(SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100)-o.quantity-p.unit_cost)
,2) AS total_profit
FROM orders o
JOIN products p ON o.product_id=p.product_id
GROUP BY p.product_name,p.category
ORDER BY total_profit DESC
LIMIT 10;

-- Discount Analysis
-- Analyzing on different discount level what the actual sales and profit are generated;
SELECT
    CASE
        WHEN o.discount IS NULL OR o.discount = 0 THEN 'No Discount'
        WHEN o.discount <= 10 THEN '1-10%'
        WHEN o.discount <= 20 THEN '11-20%'
        WHEN o.discount <= 30 THEN '21-30%'
        ELSE 'Above 30%'
    END AS discount_range,

    COUNT(o.order_id) AS total_orders,

    ROUND(
        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
        ),
        2
    ) AS total_sales,

    ROUND(
        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
            - o.quantity * p.unit_cost
        ),
        2
    ) AS total_profit

FROM orders o
JOIN products p
    ON o.product_id = p.product_id

GROUP BY discount_range

ORDER BY total_sales DESC;

-- Analyzing average order value
SELECT ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100))/COUNT(o.order_id) 
,2) AS average_order_value
FROM orders o
JOIN products p ON o.product_id=p.product_id;

-- Analyzing customers who order frequently
SELECT o.customer_id,c.customer_name,
COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id,c.customer_name
ORDER BY total_orders DESC;


--Customer Value Analysis
-- ANALYZING THE TOP CUSTOMER WHO GENERATE THE MAXIMUM SALES TO THE BUSINESS
SELECT c.customer_id,c.customer_name,
COUNT(o.order_id) AS total_orders,
ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100))
,2) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN products p ON o.product_id=p.product_id
GROUP BY c.customer_id,c.customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Monthly Orders & Quantity
-- ANALYZING EVERY MONTH ORDER AND QUANTITY SELL
SELECT 
DATE_TRUNC('month',o.order_date) AS month,
COUNT(o.order_id) AS total_orders,
SUM(o.quantity) AS total_quantity
FROM orders o
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month',o.order_date)
ORDER BY month;

-- Customer Segmentation by Order Frequency
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        WHEN total_orders BETWEEN 2 AND 3 THEN 'Occasional'
        WHEN total_orders BETWEEN 4 AND 6 THEN 'Regular'
        ELSE 'Frequent'
    END AS customer_segment,
    
    COUNT(*) AS total_customers

FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) customer_orders

GROUP BY customer_segment
ORDER BY total_customers DESC;

-- Customer Sales by Segment
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        WHEN total_orders BETWEEN 2 AND 3 THEN 'Occasional'
        WHEN total_orders BETWEEN 4 AND 6 THEN 'Regular'
        ELSE 'Frequent'
    END AS customer_segment,

    COUNT(*) AS total_customers,

    ROUND(SUM(total_sales), 2) AS total_sales

FROM (
    SELECT
        c.customer_id,
        COUNT(o.order_id) AS total_orders,

        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
        ) AS total_sales

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN products p
        ON o.product_id = p.product_id

    GROUP BY c.customer_id
) customer_data

GROUP BY customer_segment
ORDER BY total_sales DESC;

-- Category-wise Average Order Value
SELECT p.category,
ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100))/COUNT(o.order_id)
,2) AS average_order_value
FROM orders o
JOIN products p ON o.product_id=p.product_id
GROUP BY p.category
ORDER BY average_order_value DESC;

-- Category-wise Profit Margin
SELECT p.category,
ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100)-o.quantity-p.unit_price)
,2) AS tota_profit,

ROUND(
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100)-o.quantity-p.unit_price)
/
SUM(o.quantity*p.unit_price*(1-COALESCE(o.discount,0)/100))*100
,2) AS profit_margin

FROM orders o

JOIN products p ON o.product_id=p.product_id
GROUP BY p.category
ORDER BY profit_margin DESC;

--Data Quality Check
SELECT
    COUNT(*) AS total_orders,

    COUNT(*) FILTER (
        WHERE quantity IS NULL
    ) AS missing_quantity,

    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS missing_order_date,

    COUNT(*) FILTER (
        WHERE discount IS NULL
    ) AS missing_discount,

    COUNT(*) FILTER (
        WHERE discount < 0 OR discount > 100
    ) AS invalid_discount

FROM orders;



-- FINAL KPI 
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT o.customer_id) AS total_customers,

    ROUND(
        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
        ),
        2
    ) AS total_sales,

    ROUND(
        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
            - o.quantity * p.unit_cost
        ),
        2
    ) AS total_profit,

    ROUND(
        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
            - o.quantity * p.unit_cost
        )
        /
        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
        ) * 100,
        2
    ) AS profit_margin,

    ROUND(
        SUM(
            o.quantity * p.unit_price
            * (1 - COALESCE(o.discount, 0) / 100)
        )
        / COUNT(o.order_id),
        2
    ) AS average_order_value,

    COUNT(*) FILTER (
        WHERE r.return_id IS NOT NULL
    ) AS total_returns

FROM orders o
JOIN products p
    ON o.product_id = p.product_id
LEFT JOIN returns r
    ON o.order_id = r.order_id;