/* Pizza_Sales SQL + PowerBI project

*/

Create database pizza_sales

use pizza_sales

/* we need to modify the name of the created database to SQL_PowerBI_Project4_pizza_sales */

Alter database pizza_sales modify name = SQL_PowerBI_Project4_pizza_sales

Use SQL_PowerBI_Project4_pizza_sales


select * from [dbo].[pizza_sales]

/* column order_time has datetime(2) data type - we ned to convert it into time data type*/

alter table [dbo].[pizza_sales]
alter column [order_time] time not null;

/* Data Cleaning- we will check if is there any  redundancy  in the data or not */

Select * from [dbo].[pizza_sales]
Where [pizza_id] is null  
 or  [order_id] is null
 or [pizza_name_id] is null
 or [pizza_category]  is null
 or [quantity] is null
 or [order_date] is null
 or [order_time] is null
 or [unit_price] is null
 or  [total_price] is null
 or [pizza_size] is null
 or [pizza_ingredients] is null
 or [pizza_name] is null;

 /* 
 Checking for duplicates 
 */

 Select * from [dbo].[pizza_sales]

 Select [pizza_id],  [order_id], count(*) as count_order_id
 from [dbo].[pizza_sales]
 group by [pizza_id] , order_id
 having count(*) > 1;


 /* Data Transformation - pizza size re presented as S, M, L, XL,XXL in data, 
 we need to transform it to  S= small, M= Medium, L=Large, XL = XLarge XXL = XXLarge)*/
  --We can create additional colum in PowerBI --
 

---KPI requirements 

--Total Revenue – The sum of the total price of all pizza orders

Select sum([total_price]) as total_revenue from[dbo].[pizza_sales]

--Average Order Value – The average amount spent per order, calculated by dividing the total revenue by the total number of orders

Select sum([total_price]) / count(distinct [order_id]) as avg_order_value from [dbo].[pizza_sales]


--Total Pizzas Sold – The sum of the quantities of all pizzas sold

Select sum([quantity]) as total_pizza_sold from [dbo].[pizza_sales] --- it throws error so we change data type to int


alter table [dbo].[pizza_sales]
alter column [quantity] int not null;


Select sum([quantity]) as total_pizza_sold from [dbo].[pizza_sales]

--Total Orders – The total number of orders placed.

Select Count(distinct [order_id]) as Total_Orders from [dbo].[pizza_sales]


--Average Pizzas Per Order - The average number of pizzas sold per order, 
--calculated by dividing the total number of pizzas sold by the total number of orders.

Select sum([quantity]) /Count(distinct [order_id]) as avg_pizza_per_order from [dbo].[pizza_sales]

--chart requirements

-- Daily Trend For Total Orders – Create a bar chart that displays the daily trend of total orders 
--over a specific time period. This chart will help us identify any patterns or fluctuations in the order volumes on a daily basis.
/* 
we need to first find the day of weeks as order_day then count the orders
*/
Select DATENAME(DW, [order_date]) as Order_day, count(distinct [order_id]) as total_orders 
From [dbo].[pizza_sales]
group by DATENAME(DW, [order_date]);

-- Monthly Trend for Total Orders – Create a line chart that illustrates the hourly trend of total orders throughout the day. 
--This chart will allow us to identify peak hours or periods of high order activity.

/* 
we need to first find the day of weeks as order_month then count the orders
*/

Select DATENAME(Month, [order_date]) as Order_month, count([order_id]) as total_orders
from [dbo].[pizza_sales]
Group by DATENAME(Month, [order_date]);



-- Percentage of Sales by Pizza Category – Create a pie chart that shows the distribution 
--of sales across different pizza categories. This chart will provide insights into the 
--popularity of various pizza categories and their contribution to overall sales.

Select [pizza_category], 
	Round(Sum([total_price]), 2) as total_revenue,
	Round(Sum([total_price])* 100 / (Select sum([total_price])from [dbo].[pizza_sales]),2) as percentage_of_pizza_sales_by_category
FROM [dbo].[pizza_sales]
Group by [pizza_category];


-- Percentage of Sales by Pizza Size – Generate a pie chart that represents 
--the percentage of sales attributed to different pizza sizes. This chart will help us understand 
--customer preferences for pizza sizes and their impact on sales.

Select [pizza_size], 
	Round(Sum([total_price]), 2) as total_revenue,
	Round (Sum([total_price]) *100 / (Select SUM([total_price]) from[dbo].[pizza_sales]),2) as Percentage_of_pizza_sales_by_size
FROM [dbo].[pizza_sales]
Group by [pizza_size];


-- Total Pizzas Sold by Pizza Category – Create a funnel chart that presents 
--the total number of pizzas sold for each pizza category. This chart will allow us to compare 
--the sales performance of different pizza categories.

Select [pizza_category], sum([quantity]) as total_quantity_of_pizza_sold
From [dbo].[pizza_sales]
Group by [pizza_category]
Order by total_quantity_of_pizza_sold;

-- Top 5 Best Sellers by Revenue, Total Quantity, and Total Orders
--– Create a bar chart highlighting the top 5 best-selling pizzas based on the Revenue, 
--Total Quantity, Total Orders. This chart will help us identify the most popular pizza options.

Select top 5 [pizza_name], sum([total_price]) as total_revenue, count([order_id]) as top5_total_orders 
from [dbo].[pizza_sales]
group by [pizza_name]
order by total_revenue DESC;

-- Bottom 5 Sellers by Revenue, Total Quantity, and Total Orders 
--– Create a bar chart showcasing the bottom 5 worst selling pizzas based on the Revenue, 
---Total Quantity, and Total Orders. This chart will enable us to identify underperforming or less popular pizza options.


Select TOP 5 [pizza_name], sum([total_price]) as total_revenue, count([order_id]) as bottom5_total_orders 
from [dbo].[pizza_sales]
group by [pizza_name]
order by total_revenue ASC;


---top 5 pizza by quantity

Select top 5 [pizza_name], sum([quantity]) as top5_total_quantity_sold
from [dbo].[pizza_sales]
group by [pizza_name]
order by top5_total_quantity_sold DESC;

---bottom 5 pizza by quantity

Select top 5 [pizza_name], sum([quantity]) as bottom5_total_quantity_sold
from [dbo].[pizza_sales]
group by [pizza_name]
order by bottom5_total_quantity_sold ASC;


---top 5 pizza by total order

Select top 5 [pizza_name], count(distinct [order_id]) as top5_total_no_of_order
from [dbo].[pizza_sales]
group by [pizza_name]
order by top5_total_no_of_order DESC;

---bottom 5 pizza by total order

Select top 5 [pizza_name], count(distinct [order_id]) as bottom5_total_no_of_order
from [dbo].[pizza_sales]
group by [pizza_name]
order by bottom5_total_no_of_order ASC;


---extra sql queries Group by, having, order by ---we will not use below queries in Power Bi report
/*Top 5 Classic pizzas of Medium (M) or Large (L) size that have been ordered more than once, 
sorted by the total number of distinct orders in ascending order. */

/*
The query will return a table with four columns (pizza_name, pizza_category, pizza_size, and Total_Orders) 
showing the 5 least ordered Medium or Large 'Classic' pizzas that appeared in more than one distinct order.*/ 

SELECT Top 5  pizza_name,[pizza_category],[pizza_size], COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic' and [pizza_size] in ('M', 'L')
GROUP BY pizza_name, [pizza_category],[pizza_size]
Having COUNT(DISTINCT order_id) > 1
ORDER BY Total_Orders ASC;


---Bottom 5 "Classic" category pizzas in sizes Medium ('M') and Large ('L'), 
--ranked by the total number of unique orders for each, but only includes those pizzas
--- that have been ordered at least twice.
SELECT Top 5 pizza_name,[pizza_category],[pizza_size], COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic' and [pizza_size] in ('M', 'L')
GROUP BY pizza_name, [pizza_category],[pizza_size]
Having COUNT(DISTINCT order_id) > 1
ORDER BY Total_Orders DESC;
