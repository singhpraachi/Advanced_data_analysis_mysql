Company: CODTECH IT SOLUTIONS PVT. LTD. Name: PRAACHI SINGH Intern ID: CT04DH2285 Domain: SQL Duration: 4 Weeks Mentor: NEELA SANTOSH

Welcome to trends practice project built during my CODTECH Internship. This project demonstrates practical usage of USE WINDOW FUNCTIONS,

SUBQUERIES, AND CTES (COMMON TABLE EXPRESSIONS) FOR ADVANCED DATA ANALYSIS.

Advanced SQL Data Analysis Project 

 **Project:** Sales Trends & Customer Behavior Analysis
 **Tech:** SQL (MySQL 8 / PostgreSQL), CTEs, Window Functions, Subqueries
 **Goal:** Identify key sales trends, top product performance, and high-value customer engagement



 **Project Overview**

During my internship, I worked on building an **advanced SQL report** that analyzes **sales performance** over time and provides actionable business insights.
This project was designed to **demonstrate the use of:**

* **Window Functions** – RANK, NTILE, running totals
* **Common Table Expressions (CTEs)** – to simplify complex queries
* **Subqueries** – for filtering and data segmentation
* **Aggregate Functions & Joins** – for combining multiple datasets


**Data Structure**

I designed and worked with the following dataset structure:

* **customers** – Customer info (`customer_id`, `customer_name`, `country`)
* **products** – Product catalog (`product_id`, `product_name`, `category`)
* **orders** – Orders with date and total (`order_id`, `customer_id`, `order_date`, `total_amount`)
* **order\_items** – Detailed items per order (`order_item_id`, `order_id`, `product_id`, `quantity`, `price`)

 **What the Analysis Delivers**

1. **Monthly Sales Performance**

   * Total revenue per month
   * Total orders per month
2. **Top-Selling Product Each Month**

   * Using `RANK()` to find the highest-selling product per month
3. **Customer Lifetime Value (LTV)**

   * Total spend, average order value, number of orders
4. **Top 10% Customers**

   * Identified with `NTILE(10)` for segmentation
5. **Customer Engagement Trend**

   * How often high-value customers make purchases each month

 **SQL Techniques Used**

* **CTEs** to break down the logic into smaller, manageable parts
* **Window Functions** (`RANK`, `NTILE`) to identify rankings and segments
* **Subqueries** to filter and refine results
* **Aggregations** (`SUM`, `COUNT`, `AVG`) for KPIs

 **Business Insights Gained**

* **Seasonal Trends:** Big-ticket products like laptops and smartphones spike in specific months
* **Inventory Planning:** Identifying which products consistently rank in the top helps manage stock levels
* **Customer Retention:** The top 10% of customers contribute disproportionately to sales — these are priority targets for loyalty campaigns

 **Sample Output**

| Month      | Total Sales | Total Orders | Top Product | Units Sold | Top Customers’ Orders |
| ---------- | ----------- | ------------ | ----------- | ---------- | --------------------- |
| 2023-01-01 | 2000.00     | 2            | Laptop      | 1          | 1                     |
| 2023-02-01 | 750.00      | 2            | Headphones  | 2          | 1                     |
| 2023-03-01 | 350.00      | 2            | Coffee Mug  | 3          | 0                     |
| 2023-04-01 | 2120.00     | 2            | Laptop      | 2          | 1                     |
| 2023-05-01 | 2650.00     | 2            | Smartphone  | 2          | 1                     |

 **Files Included**

* `TASK2.sql` – Table creation, data insertion, and analysis query
* `README.md` – Project documentation (this file)

 **Next Steps**

I plan to extend this analysis by:

* Adding **running total revenue**
* Identifying **new vs. returning customers**
* Creating a **visual dashboard** in Power BI/Tableau

---

💬 **Let’s connect!** If you’re into data analytics, SQL, or BI tools, I’d love to exchange ideas.

📧 **Contact:** \[SINGHPRAACHI2904@GMAIL.COM]
🔗 **LinkedIn:** \[www.linkedin.com/in/praachi-singh-485596361]


