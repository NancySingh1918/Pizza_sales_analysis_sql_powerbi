create database pizza_sales;
use  pizza_sales;
select*from pizza_sales;
-- 1. Total Revenue 
 select sum(total_price) as Total_Revenue from pizza_sales;
 -- 2.Average order value
 select sum(total_price)/count(distinct order_id) as Avg_order_value from pizza_sales;
 -- 3. Total pizza sold 
 select sum(quantity) as Total_pizza_sold from pizza_sales;
 -- 4.Total orders placed
 select count(distinct order_id) as Total_order from pizza_sales;
 -- 5. Average pizzas per order
 select cast(cast( sum(quantity) as decimal(10,2))/ 
 cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as Avg_pizza_per_order from pizza_sales;
 -- Chart Requirement

-- coverting order date from text to date 
DESCRIBE pizza_sales;
ALTER TABLE pizza_sales ADD order_date_clean DATE;

SELECT order_date
FROM pizza_sales
LIMIT 20;
SET SQL_SAFE_UPDATES = 0;

UPDATE pizza_sales
SET order_date_clean = STR_TO_DATE(order_date, '%d-%m-%Y')
WHERE order_id IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;
-- 1.Daily trend for total orders 
SELECT DAYNAME(order_date_clean) AS order_day,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DAYNAME(order_date_clean)
ORDER BY FIELD(order_day,
               'Monday','Tuesday','Wednesday',
               'Thursday','Friday','Saturday','Sunday');
-- 2. Monthly trend for total orders
SELECT MONTHNAME(order_date_clean) AS Month_Name,
       COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE order_date_clean IS NOT NULL
GROUP BY MONTH(order_date_clean), MONTHNAME(order_date_clean)
ORDER BY MONTH(order_date_clean);

-- 3.Percentage of sales by pizza category 
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;

-- 4. Percentage of sales by pizza size 
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

-- 5. Total pizzas sold by pizza category
SELECT pizza_category, SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date_clean) = 1
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

-- 6.Top 5 pizza by revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
limit 5;
 
 -- 7. Bottom 5 pizza by revenue 
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue asc
limit 5;

-- 8. Top 5 pizza by quantity
SELECT pizza_name, SUM(quantity) AS Total_pizza_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_pizza_sold desc
limit 5;   

--  9. Bottom 5 pizza by quantity 
SELECT pizza_name, SUM(quantity) AS Total_pizza_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_pizza_sold asc
limit 5;  
           
-- 10. Top 5 pizza by Total orders
SELECT pizza_name, count(distinct order_id) AS Total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_orders desc
limit 5; 

-- 11. Bottom 5 pizza by total orders 
SELECT pizza_name, count(distinct order_id) AS Total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_orders asc
limit 5;            
               










 
