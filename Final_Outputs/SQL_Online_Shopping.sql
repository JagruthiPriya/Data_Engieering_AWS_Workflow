CREATE DATABASE online_shopping;
USE online_shopping;

CREATE TABLE customers (
    customer_id VARCHAR(10),
    customer_name VARCHAR(100),
    city VARCHAR(100));

INSERT INTO customers (customer_id, customer_name, city) VALUES
('C101', 'Rahul', 'Hyderabad'),
('C102', 'Priya', 'Bangalore'),
('C103', 'Amit', 'Chennai'),
('C101', 'Rahul', 'Hyderabad');

CREATE TABLE products (
    product_id VARCHAR(10),
    product_name VARCHAR(100),
    price DECIMAL(10,2));
    
INSERT INTO products (product_id, product_name, price) VALUES
('P101', 'Laptop', 50000),
('P102', 'Mobile', 20000),
('P103', 'Headphones', 2000);

CREATE TABLE orders (
    order_id VARCHAR(10),
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    status VARCHAR(50));
    
INSERT INTO orders
(order_id, customer_id, product_id, quantity, status) VALUES
('O101', 'C101', 'P101', 1, 'Delivered'),
('O102', 'C102', 'P102', 2, 'Delivered'),
('O103', 'C103', 'P103', 1, 'Pending'),
('O104', 'C101', 'P102', 1, 'Delivered'),
('O105', 'C105', 'P101', 1, 'Delivered');

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;

# check duplicates:
SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers GROUP BY customer_id HAVING COUNT(*) > 1;

CREATE TABLE clean_customers AS SELECT DISTINCT customer_id, customer_name, 
city FROM customers;

# invalid customer IDs
SELECT o.* FROM orders o LEFT JOIN clean_customers c
ON o.customer_id = c.customer_id WHERE c.customer_id IS NULL;

# Display all orders with customer and product names
SELECT o.order_id, c.customer_name, p.product_name, o.quantity, o.status
FROM orders o JOIN clean_customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

# Calculate total order amount for each customer
SELECT c.customer_id, c.customer_name, SUM(o.quantity * p.price) AS total_order_amount
FROM clean_customers c JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;

# Find the number of orders for each status
SELECT status, COUNT(*) AS order_count
FROM orders GROUP BY status;

# Find the product with the highest total sales
SELECT p.product_id, p.product_name, SUM(o.quantity * p.price) AS total_sales
FROM products p JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name ORDER BY total_sales DESC LIMIT 1;

# Find customers who have not placed any orders
SELECT c.customer_id, c.customer_name, c.city
FROM clean_customers c LEFT JOIN orders o
ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;