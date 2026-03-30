-- Create sales table according to your csv columns
CREATE TABLE sales (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    order_date DATE 
);

-- Enable local file loading
SET GLOBAL local_infile = 1;

-- Load CSV into sales table
-- Place sales.csv in the same folder as this script
-- Use copy as path
LOAD DATA LOCAL INFILE "sales.csv"
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows;

-- Disable local file loading (security)
SET GLOBAL local_infile = 0;

-- Verify data
SELECT * FROM sales;

-- Get total spending per customer (highest to lowest)
SELECT customer_id, SUM(quantity * price) AS total_spend
FROM sales GROUP BY customer_id
ORDER BY total_spend DESC;

-- Find top 3 best-selling products based on quantity sold
SELECT product_name, SUM(quantity) AS total_sell
FROM sales GROUP BY product_name
ORDER BY total_sell DESC LIMIT 3;

-- Calculate monthly revenue
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(quantity*price) AS amount
FROM sales GROUP BY MONTH ORDER BY MONTH;

-- Category-wise total sales (revenue)
select category,
SUM(quantity*price) AS total_sales
FROM sales GROUP BY category ORDER BY total_sales;

-- Get all high-value products (price greater than 1000)
SELECT product_name, category, price
from sales WHERE price > 1000;


SELECT * FROM sales;
