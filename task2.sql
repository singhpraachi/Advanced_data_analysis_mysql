show databases;

use mysql_db

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    registration_date DATE,
    city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


INSERT INTO Customers (customer_id, customer_name, registration_date, city) VALUES
(1, 'Alice Smith', '2023-01-15', 'New York'),
(2, 'Bob Johnson', '2023-02-20', 'Los Angeles'),
(3, 'Charlie Brown', '2023-01-25', 'New York'),
(4, 'Diana Prince', '2023-03-10', 'Chicago'),
(5, 'Eve Adams', '2023-02-01', 'Los Angeles'),
(6, 'Frank White', '2024-01-05', 'New York');

INSERT INTO Products (product_id, product_name, category, price) VALUES
(101, 'Laptop Pro', 'Electronics', 1200.00),
(102, 'Gaming Mouse', 'Electronics', 75.00),
(103, 'Office Chair', 'Furniture', 300.00),
(104, 'Desk Lamp', 'Home Decor', 45.00),
(105, 'Smartphone X', 'Electronics', 900.00),
(106, 'Coffee Table', 'Furniture', 150.00),
(107, 'Smart TV', 'Electronics', 800.00);

INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2023-03-01', 1275.00),
(2, 2, '2023-03-05', 300.00),
(3, 1, '2023-04-10', 900.00),
(4, 3, '2023-04-15', 1200.00),
(5, 4, '2023-05-01', 45.00),
(6, 2, '2023-05-10', 150.00),
(7, 5, '2023-06-01', 800.00),
(8, 1, '2024-02-01', 75.00), 
(9, 6, '2024-02-15', 1200.00); 

INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, item_price) VALUES
(1, 1, 101, 1, 1200.00),
(2, 1, 102, 1, 75.00),
(3, 2, 103, 1, 300.00),
(4, 3, 105, 1, 900.00),
(5, 4, 101, 1, 1200.00),
(6, 5, 104, 1, 45.00),
(7, 6, 106, 1, 150.00),
(8, 7, 107, 1, 800.00),
(9, 8, 102, 1, 75.00),
(10, 9, 101, 1, 1200.00);


-- SECTION 1: MONTHLY SALES AND ORDER TRENDS (USING WINDOW FUNCTIONS)
-- This query shows the total sales and number of orders for each month,
-- and also calculates the month-over-month sales growth.
SELECT
    FORMAT(order_date, 'yyyy-MM') AS sales_month, -- SQL Server specific (SQL Server 2012+)
    -- Alternatively: CONVERT(VARCHAR(7), order_date, 120) AS sales_month,
    SUM(total_amount) AS monthly_sales,
    COUNT(order_id) AS total_orders,
    LAG(SUM(total_amount), 1, 0) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')) AS previous_month_sales,
    CASE
        WHEN LAG(SUM(total_amount), 1, 0) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')) = 0 THEN NULL
        ELSE (SUM(total_amount) - LAG(SUM(total_amount), 1, 0) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM'))) * 100.0 / LAG(SUM(total_amount), 1, 0) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM'))
    END AS month_over_month_growth_pct
FROM
    Orders
GROUP BY
    FORMAT(order_date, 'yyyy-MM') -- Group by the formatted string
    -- Alternatively: GROUP BY CONVERT(VARCHAR(7), order_date, 120)
ORDER BY
    sales_month;

-- SECTION 2: TOP 5 CUSTOMERS BY TOTAL SPENDING (USING SUBQUERIES)
-- This query identifies the customers who have spent the most,
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    customer_spending.total_spent
FROM
    Customers c
JOIN
    (SELECT
        customer_id,
        SUM(total_amount) AS total_spent
    FROM
        Orders
    GROUP BY
        customer_id
    ORDER BY
        total_spent DESC
    LIMIT 5) AS customer_spending
ON
    c.customer_id = customer_spending.customer_id
ORDER BY
    customer_spending.total_spent DESC;


-- SECTION 3: PRODUCT PERFORMANCE RANKING WITHIN CATEGORIES (USING WINDOW FUNCTIONS)
-- This query ranks products by their total sales within each product category,
-- providing insight into best-selling items per category.
SELECT
    p.category,
    p.product_name,
    SUM(oi.quantity * oi.item_price) AS total_product_sales,
    -- Rank products within their category based on sales
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.item_price) DESC) AS rank_in_category
FROM
    Products p
JOIN
    Order_Items oi ON p.product_id = oi.product_id
GROUP BY
    p.category, p.product_name
ORDER BY
    p.category, rank_in_category;


-- SECTION 4: CUSTOMER COHORT ANALYSIS - FIRST ORDER VALUE BY REGISTRATION MONTH (USING CTES AND WINDOW FUNCTIONS)
-- This analysis helps understand if customers registering in certain months tend to make larger initial purchases.
WITH CustomerRegistrationMonth AS (
    SELECT
        customer_id,
        FORMAT(registration_date, 'yyyy-MM') AS registration_month -- SQL Server specific
        -- Alternatively: CONVERT(VARCHAR(7), registration_date, 120) AS registration_month
    FROM
        Customers
),
CustomerFirstOrder AS (
    SELECT
        o.customer_id,
        MIN(o.order_date) AS first_order_date,
        FIRST_VALUE(o.total_amount) OVER (PARTITION BY o.customer_id ORDER BY o.order_date ASC) AS first_order_amount
    FROM
        Orders o
    GROUP BY
        o.customer_id, o.order_date, o.total_amount
)
SELECT
    crm.registration_month,
    COUNT(DISTINCT cfo.customer_id) AS number_of_customers,
    AVG(cfo.first_order_amount) AS avg_first_order_value
FROM
    CustomerRegistrationMonth crm
JOIN
    CustomerFirstOrder cfo ON crm.customer_id = cfo.customer_id
GROUP BY
    crm.registration_month
ORDER BY
    crm.registration_month;


-- SECTION 5: IDENTIFYING "POWER SHOPPERS" (USING CTE FOR CLARITY AND SUBQUERY CONCEPT)
-- Define "Power Shoppers" as customers with more than 2 orders.
-- This showcases how CTEs can break down complex queries into logical steps.
WITH CustomerOrderCounts AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders_placed
    FROM
        Orders
    GROUP BY
        customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    c.registration_date,
    coc.total_orders_placed
FROM
    Customers c
JOIN
    CustomerOrderCounts coc ON c.customer_id = coc.customer_id
WHERE
    coc.total_orders_placed > 2 -- Threshold for "Power Shopper"
ORDER BY
    coc.total_orders_placed DESC;
