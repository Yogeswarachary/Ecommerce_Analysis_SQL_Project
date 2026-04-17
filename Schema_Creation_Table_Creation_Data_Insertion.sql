# CREATE DATABASE FOR THE ECOMMERCE ANALYTICS PROJECT
CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE customers(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
city VARCHAR(50),
state VARCHAR(50),
signup_date DATE,
segment VARCHAR(30)
);

CREATE TABLE products(
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
subcategory VARCHAR(50),
price DECIMAL(10, 2)
);

CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id INT,
order_date DATE,
order_status VARCHAR(30),
channel VARCHAR(30),
warehouse_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items(
order_item_id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
unit_price DECIMAL(10, 2),
discount DECIMAL(5, 2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

ALTER TABLE order_items
MODIFY COLUMN discount DECIMAL(10, 2);

CREATE TABLE payments(
payment_id INT PRIMARY KEY,
order_id INT,
payment_date DATE,
payment_method VARCHAR(30),
payment_status VARCHAR(30),
amount_paid DECIMAL(10, 2),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE refunds(
refund_id INT PRIMARY KEY,
order_id INT,
refund_date DATE,
refund_amount DECIMAL(10, 2),
refund_reason VARCHAR(100),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE warehouses(
warehourse_id INT PRIMARY KEY,
warehouse_name VARCHAR(100),
city VARCHAR(50),
state VARCHAR(50)
);

ALTER TABLE warehouses
RENAME COLUMN warehourse_id to warehouse_id;

CREATE TABLE deliveries(
delivery_id INT PRIMARY KEY,
order_id INT,
dispatch_date DATE,
delivery_date DATE,
delivery_status VARCHAR(30),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

# Now we are inserting data into the Tables
INSERT INTO customers VALUES
(1, 'Amit Sharma', 'Hyderabad', 'Telangana', '2023-01-10', 'Premium'),
(2, 'Sneha Reddy', 'Benguluru', 'Karnataka', '2023-02-15', 'Standard'),
(3, 'Rahul Verma', 'Mumbai', 'Maharashtra', '2023-03-12', 'Premium'),
(4, 'Priya Nair', 'Chennai', 'Tamil Nadu', '2023-04-20', 'Standard'),
(5, 'Kiran Rao', 'Pune', 'Maharashtra', '2023-05-18','Premium');

INSERT INTO products VALUES
(101, 'iPhone 14', 'Electronics', 'Mobiles', 70000),
(102, 'Samsung TV', 'Electronics', 'Television', 45000),
(103, 'Office Chair', 'Furniture', 'Seating', 8000),
(104, 'Running Shoes', 'Fashion', 'Footwear', 3500),
(105, 'Laptop Bag', 'Accessories', 'Bags', 1500);

INSERT INTO warehouses VALUES
(1, 'Hyderabad Hub', 'Hyderabad', 'Telangana'),
(2, 'Bengaluru Hub', 'Bengaluru', 'Karnataka'),
(3, 'Mumbai Hub', 'Mumbai', 'Maharashtra');

INSERT INTO orders VALUES
(1001, 1, '2024-01-05', 'Completed', 'Online', 1),
(1002, 2, '2024-01-07', 'Completed', 'App', 2),
(1003, 3, '2024-01-08', 'Cancelled', 'Online', 3),
(1004, 1, '2024-02-10', 'Completed', 'App', 1),
(1005, 4, '2024-02-14', 'Completed', 'Online', 2),
(1006, 5, '2024-03-01', 'Completed', 'Online', 3);

INSERT INTO order_items VALUES
(1, 1001, 101, 1, 70000, 5000),
(2, 1001, 105, 1, 1500, 100),
(3, 1002, 102, 1, 45000, 3000),
(4, 1003, 103, 2, 8000, 500),
(5, 1004, 104, 2, 3500, 200),
(6, 1005, 103, 1, 8000, 0),
(7, 1006, 101, 1, 70000, 4000);

INSERT INTO payments VALUES
(1, 1001, '2024-01-05', 'Credit Card', 'Paid', 66400),
(2, 1002, '2024-01-07', 'UPI', 'Paid', 42000),
(3, 1003, '2024-01-08', 'Debit Card', 'Failed', 0),
(4, 1004, '2024-02-10', 'UPI', 'Paid', 6800),
(5, 1005, '2024-02-14', 'Net Banking', 'Paid', 8000),
(6, 1006, '2024-03-01', 'Credit Card', 'Paid', 66000);

INSERT INTO refunds VALUES
(1, 1002, '2024-01-15', 5000, 'Damaged Product'),
(2, 1005, '2024-02-20', 1000, 'Late Delivery');

INSERT INTO deliveries VALUES
(1, 1001, '2024-01-06', '2024-01-08', 'Delivered'),
(2, 1002, '2024-01-08', '2024-01-12', 'Delivered'),
(3, 1004, '2024-02-11', '2024-02-13', 'Delivered'),
(4, 1005, '2024-02-15', '2024-02-21', 'Delivered'),
(5, 1006, '2024-03-02', '2024-03-05', 'Delivered');