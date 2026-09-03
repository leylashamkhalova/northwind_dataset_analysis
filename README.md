Northwind SQL Analysis
Project Overview

This project focuses on analyzing the Northwind database using SQL to explore customers, products, orders, sales, employees, suppliers, inventory, and shipping performance.

The analysis consists of a series of business-oriented SQL queries designed to answer practical questions and extract insights from relational data.

Dataset

The project uses the Northwind database, a sample relational database containing information about:
- Customers ,
- Orders and Order Details ,
- Products , Categories ,
- Suppliers ,
- Employees ,
- Shippers ,
- Territories and Regions.

Business Questions & Analysis
- Customer Analysis ,
- Number of customers by country ,
- Number of customers by customer type ,
- Number of orders per customer
- Top 5 customers by number of orders
- Top customers by total order amount
- Customers who have never placed an order
- Customers who placed only one order or more than one order
- Most frequently ordered category for each customer
- Favorite product of each customer

Product & Category Analysis
- Number of products in each category
- Average product price by category
- Top 10 most expensive products
- Cheapest product
- Most expensive product in each category
- Most frequently ordered product in each category
- Products with less than 50 units in stock
- Three least-ordered products
- Products that have never been sold
- Discontinued products

Sales Analysis
- Total sales amount
- Sales amount and order count per employee
- Top orders by total order amount
- Average order amount per customer
- Sales and order trends over time
- Percentage of orders placed with a discount

Employee Analysis
- Number of orders handled by each employee
- Number of employees by country
- Employees hired per year
- Employees working in more than five territories
- Number of employees working in each region

Shipping & Delivery Analysis
- Number of orders delivered by each shipping company
- Shipping company with the highest number of delivery delays
- Number of delayed orders
- Orders shipped early, on time, and late
- Average delivery time
- Orders shipped to each country and their delay rates
- Orders shipped to each city by country

Supplier & Inventory Analysis
- Number of products supplied by each supplier
- Main product category supplied by each supplier
- Products that need to be reordered
- Required reorder quantity based on stock levels and reorder levels

Time-Based Analysis
- Number of orders placed in 1997
- Number of orders placed each year
- Monthly order volume
- Peak day by number of orders
- Monthly sales analysis
- SQL Concepts & Techniques

This project demonstrates practical use of:

- SELECT, WHERE, GROUP BY, ORDER BY
- Aggregate functions: COUNT(), SUM(), AVG()
- JOIN and LEFT JOIN
- Subqueries
- CASE WHEN
- TOP
- ROUND()
- Date functions such as YEAR(), FORMAT(), DATEDIFF()
- Conditional aggregation
- Common relational data analysis techniques
- Window functions
- ROW_NUMBER() with PARTITION BY
- Ranking and top-per-group analysis

Key Skills Demonstrated

The project demonstrates how SQL can be used to transform raw relational data into answers to business questions, identify patterns, compare performance, and support data-driven decision-making.

Particular focus was placed on aggregation, relational joins, subqueries, conditional logic, date analysis, and window functions.

Tools
- SQL Server / T-SQL
- Northwind Database
- Git & GitHub

Project Structure
Northwind-SQL-Analysis/
│
├── northwind_dataset_analysis_sql.sql
└── README.md

Purpose
 
The main goal of this project was to strengthen practical SQL skills by working with a relational dataset and solving business-oriented analytical questions rather than focusing only on isolated SQL syntax.
