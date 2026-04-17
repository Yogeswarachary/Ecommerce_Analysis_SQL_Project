# Ecommerce Analytics Project
Ecommerce Analytics Project is a comprehensive database and analytics system designed to support data-driven decision making in the ecommerce industry. The project consists of two primary components: a database schema and a set of SQL queries for data analysis.

## Key Features
* A robust database schema with tables for customers, products, orders, order items, payments, refunds, warehouses, and deliveries
* A set of SQL queries for analyzing sales trends, customer behavior, product performance, and logistics operations
* Support for data-driven decision making through insights into revenue trends, customer segmentation, and operational efficiency

## Database Schema

The database schema consists of the following tables:
*   **customers**: stores information about customers, including customer ID, name, city, state, signup date, and segment.
*   **products**: stores information about products, including product ID, name, category, subcategory, and price.
*   **orders**: stores information about orders, including order ID, customer ID, order date, order status, channel, and warehouse ID.
*   **order_items**: stores information about order items, including order item ID, order ID, product ID, quantity, unit price, and discount.
*   **payments**: stores information about payments, including payment ID, order ID, payment date, payment method, payment status, and amount paid.
*   **refunds**: stores information about refunds, including refund ID, order ID, refund date, refund amount, and refund reason.
*   **warehouses**: stores information about warehouses, including warehouse ID, name, city, and state.
*   **deliveries**: stores information about deliveries, including delivery ID, order ID, dispatch date, delivery date, and delivery status.

## Installation Instructions
To install and use the Ecommerce Analytics Project, follow these steps:
1. Create a new database in your preferred relational database management system (e.g., MySQL)
2. Execute the SQL script in `Schema_Creation_Table_Creation_Data_Insertion.sql` to create the database schema and populate it with sample data
3. Open the `Data_analysis_queries_using_sql.sql` file and execute the queries to analyze the data and generate insights

## Usage Examples
The following code blocks demonstrate how to use the Ecommerce Analytics Project to analyze sales trends and customer behavior:
```sql
-- Monthly revenue trend
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS Order_Month,
SUM((oi.quantity * oi.unit_price) - oi.discount) as Montly_Revenue
FROM orders o JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY Order_Month ASC;
```

```sql
-- Top 3 customers by net spend
SELECT c.customer_id, c.customer_name, 
SUM((oi.quantity * oi.unit_price) - oi.discount) AS Total_Spend
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY Total_Spend DESC LIMIT 3;
```

```sql
-- Category-Wise Sales Contribution
SELECT p.category,
SUM((oi.unit_price * oi.quantity) - oi.discount) AS Category_Revenue,
ROUND(100 * SUM((oi.unit_price * oi.quantity) - oi.discount) / 
SUM(SUM((oi.unit_price * oi.quantity) - oi.discount)) OVER (), 2) as Revenue_Share_PCT
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY Category_Revenue DESC;
```

## Project Structure
The Ecommerce Analytics Project consists of two primary files:
* `Schema_Creation_Table_Creation_Data_Insertion.sql`: This file contains the database schema and sample data for the ecommerce analytics system.
* `Data_analysis_queries_using_sql.sql`: This file contains a set of SQL queries for analyzing sales trends, customer behavior, product performance, and logistics operations.
