/* Pizza_Sales SQL + PowerBI project

*/

CREATE DATABASE pizza_sales

USE pizza_sales

/* we need to modify the name of the created database to SQL_PowerBI_Project4_pizza_sales */

ALTER DATABASE pizza_sales MODIFY NAME = SQL_PowerBI_Project4_pizza_sales

USE SQL_PowerBI_Project4_pizza_sales


SELECT * FROM [dbo].[pizza_sales]

/* column order_time has datetime(2) data type - we ned to convert it into time data type*/

ALTER TABLE [dbo].[pizza_sales]
ALTER COLUMN [order_time] TIME NOT NULL;

/* Data Cleaning- we will check if is there any  redundancy  in the data or not */

SELECT * FROM [dbo].[pizza_sales]
WHERE [pizza_id] IS NULL  
 OR  [order_id] IS NULL
 OR [pizza_name_id] IS NULL
 OR [pizza_category]  IS NULL
 OR [quantity] IS NULL
 OR [order_date] IS NULL
 OR [order_time] IS NULL
 OR [unit_price] IS NULL
 OR  [total_price] IS NULL
 OR [pizza_size] IS NULL
 OR [pizza_ingredients] IS NULL
 OR [pizza_name] IS NULL;

 /* 
 Checking for duplicates 
 */

 SELECT * FROM [dbo].[pizza_sales]

 SELECT [pizza_id],  [order_id], COUNT(*) AS count_order_id
 FROM [dbo].[pizza_sales]
 GROUP BY [pizza_id] , order_id
 HAVING COUNT(*) > 1;


 /* Data Transformation - pizza size re presented as S, M, L, XL,XXL in data, 
 we need to transform it to  S= small, M= Medium, L=Large, XL = XLarge XXL = XXLarge)*/
  --We can create additional colum in PowerBI --
 

---KPI requirements 

--Total Revenue - The sum of the total price of all pizza orders

SELECT SUM([total_price]) AS total_revenue FROM[dbo].[pizza_sales]

--Average Order Value - The average amount spent per order, calculated by dividing the total revenue by the total number of orders

SELECT SUM([total_price]) / COUNT(DISTINCT [order_id]) AS avg_order_value FROM [dbo].[pizza_sales]


--Total Pizzas Sold - The sum of the quantities of all pizzas sold

SELECT SUM([quantity]) AS total_pizza_sold FROM [dbo].[pizza_sales] --- it throws error so we change data type to int


ALTER TABLE [dbo].[pizza_sales]
ALTER COLUMN [quantity] int NOT NULL;


SELECT SUM([quantity]) AS total_pizza_sold FROM [dbo].[pizza_sales]

--Total Orders - The total number of orders placed.

SELECT COUNT(DISTINCT [order_id]) AS Total_Orders FROM [dbo].[pizza_sales]


--Average Pizzas Per Order - The average number of pizzas sold per order, 
--calculated by dividing the total number of pizzas sold by the total number of orders.

SELECT SUM([quantity]) /COUNT(DISTINCT [order_id]) AS avg_pizza_per_order FROM [dbo].[pizza_sales]

--chart requirements

-- Daily Trend For Total Orders - Create a bar chart that displays the daily trend of total orders 
--over a specific time period. This chart will help us identify any patterns or fluctuations in the order volumes on a daily basis.
/* 
we need to first find the day of weeks as order_day then count the orders
*/
SELECT DATENAME(DW, [order_date]) AS Order_day, COUNT(DISTINCT [order_id]) AS total_orders 
FROM [dbo].[pizza_sales]
GROUP BY DATENAME(DW, [order_date]);

-- Monthly Trend for Total Orders - Create a line chart that illustrates the hourly trend of total orders throughout the day. 
--This chart will allow us to identify peak hours or periods of high order activity.

/* 
we need to first find the day of weeks as order_month then count the orders
*/

SELECT DATENAME(Month, [order_date]) AS Order_month, COUNT([order_id]) AS total_orders
FROM [dbo].[pizza_sales]
GROUP BY DATENAME(Month, [order_date]);



-- Percentage of Sales by Pizza Category - Create a pie chart that shows the distribution 
--of sales across different pizza categories. This chart will provide insights into the 
--popularity of various pizza categories and their contribution to overall sales.

SELECT [pizza_category], 
	ROUND(SUM([total_price]), 2) AS total_revenue,
	ROUND(SUM([total_price])* 100 / (SELECT SUM([total_price])FROM [dbo].[pizza_sales]),2) AS percentage_of_pizza_sales_by_category
FROM [dbo].[pizza_sales]
GROUP BY [pizza_category];


-- Percentage of Sales by Pizza Size - Generate a pie chart that represents 
--the percentage of sales attributed to different pizza sizes. This chart will help us understand 
--customer preferences for pizza sizes and their impact on sales.

SELECT [pizza_size], 
	ROUND(SUM([total_price]), 2) AS total_revenue,
	ROUND (SUM([total_price]) *100 / (SELECT SUM([total_price]) FROM[dbo].[pizza_sales]),2) AS Percentage_of_pizza_sales_by_size
FROM [dbo].[pizza_sales]
GROUP BY [pizza_size];


-- Total Pizzas Sold by Pizza Category - Create a funnel chart that presents 
--the total number of pizzas sold for each pizza category. This chart will allow us to compare 
--the sales performance of different pizza categories.

SELECT [pizza_category], SUM([quantity]) AS total_quantity_of_pizza_sold
FROM [dbo].[pizza_sales]
GROUP BY [pizza_category]
ORDER BY total_quantity_of_pizza_sold;

-- Top 5 Best Sellers by Revenue, Total Quantity, and Total Orders
--- Create a bar chart highlighting the top 5 best-selling pizzas based on the Revenue, 
--Total Quantity, Total Orders. This chart will help us identify the most popular pizza options.

SELECT TOP 5 [pizza_name], SUM([total_price]) AS total_revenue, COUNT([order_id]) AS top5_total_orders 
FROM [dbo].[pizza_sales]
GROUP BY [pizza_name]
ORDER BY total_revenue DESC;

-- Bottom 5 Sellers by Revenue, Total Quantity, and Total Orders 
--- Create a bar chart showcasing the bottom 5 worst selling pizzas based on the Revenue, 
---Total Quantity, and Total Orders. This chart will enable us to identify underperforming or less popular pizza options.


SELECT TOP 5 [pizza_name], SUM([total_price]) AS total_revenue, COUNT([order_id]) AS bottom5_total_orders 
FROM [dbo].[pizza_sales]
GROUP BY [pizza_name]
ORDER BY total_revenue ASC;


---top 5 pizza by quantity

SELECT TOP 5 [pizza_name], SUM([quantity]) AS top5_total_quantity_sold
FROM [dbo].[pizza_sales]
GROUP BY [pizza_name]
ORDER BY top5_total_quantity_sold DESC;

---bottom 5 pizza by quantity

SELECT TOP 5 [pizza_name], SUM([quantity]) AS bottom5_total_quantity_sold
FROM [dbo].[pizza_sales]
GROUP BY [pizza_name]
ORDER BY bottom5_total_quantity_sold ASC;


---top 5 pizza by total order

SELECT TOP 5 [pizza_name], COUNT(DISTINCT [order_id]) AS top5_total_no_of_order
FROM [dbo].[pizza_sales]
GROUP BY [pizza_name]
ORDER BY top5_total_no_of_order DESC;

---bottom 5 pizza by total order

SELECT TOP 5 [pizza_name], COUNT(DISTINCT [order_id]) AS bottom5_total_no_of_order
FROM [dbo].[pizza_sales]
GROUP BY [pizza_name]
ORDER BY bottom5_total_no_of_order ASC;


---extra sql queries Group by, having, order by ---we will not use below queries in Power Bi report
/*Top 5 Classic pizzas of Medium (M) or Large (L) size that have been ordered more than once, 
sorted by the total number of distinct orders in ascending order. */

/*
The query will return a table with four columns (pizza_name, pizza_category, pizza_size, and Total_Orders) 
showing the 5 least ordered Medium or Large 'Classic' pizzas that appeared in more than one distinct order.*/ 

SELECT TOP 5  pizza_name,[pizza_category],[pizza_size], COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic' AND [pizza_size] IN ('M', 'L')
GROUP BY pizza_name, [pizza_category],[pizza_size]
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY Total_Orders ASC;


---Bottom 5 "Classic" category pizzas in sizes Medium ('M') and Large ('L'), 
--ranked by the total number of unique orders for each, but only includes those pizzas
--- that have been ordered at least twice.
SELECT TOP 5 pizza_name,[pizza_category],[pizza_size], COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic' AND [pizza_size] IN ('M', 'L')
GROUP BY pizza_name, [pizza_category],[pizza_size]
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY Total_Orders DESC;
