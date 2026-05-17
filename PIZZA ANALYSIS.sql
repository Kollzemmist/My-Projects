--KPI'S QUERIES
SELECT * FROM pizza_sales

select sum(total_price) as total_revenue from pizza_sales;

select sum(total_price)/ count(distinct order_id) AS AVG_ORDER_VALUE from pizza_sales;

Select sum(quantity) AS Total_pizza_solds from pizza_sales;

Select count(distinct order_id) AS Total_orders from pizza_sales;

select cast(sum(quantity) as decimal(10,2))/
cast(count(distinct order_id) as decimal(10,2))  from pizza_sales;

--CHART REQUIREMENT QUERIES
--Daily Trend

select datename(DW, order_date) as order_day, count(distinct order_id) as Total_orders
from pizza_sales
Group by datename(DW, order_date);


create index idx_pizza_order_time
on pizza_sales(order_time, order_id);

create index idx_order_hour_order_id
on pizza_sales(order_time, order_id);
--Hourly Trend

select datepart(HOUR, order_time) as order_hour,COUNT(DISTINCT order_id)
from pizza_sales
GROUP BY DATEPART(HOUR, order_time)
OPTION (RECOMPILE);


SELECT DISTINCT ORDER_ID FROM PIZZA_SALES;
set statistics time on;
set statistics IO ON;



EXEC sp_help pizza_sales;
dbcc FREEPROCCACHE;

SET LOCK_TIMEOUT -1

select DATEPART(hour, order_time), count(distinct order_id)
from pizza_sales
group by DATEPART(hour, order_time)

SELECT order_hour, count(*) as order_count
FROM (
	select DATEPART(hour, order_time) as order_hour, order_id
		from pizza_sales
	group by DATEPART(hour, order_time), order_id
	) AS distinct_orders
	Group by order_hour
	order by order_hour;

	--Percentage of sales by pizza category
select pizza_category, sum(total_price) as Total_sales, sum(total_price) * 100 / (select SUM (total_price) from pizza_sales where month(order_date) = 1) as percentage_total
from pizza_sales
where month(order_date) = 1
group by pizza_category;

--percentage of sales by pizza_size
select pizza_size, cast(sum(total_price) as decimal(10,2)) as Total_sales, cast(sum(total_price) * 100 / (select SUM (total_price) 
from pizza_sales where datepart(QUARTER, order_date) =1)
as decimal(10,2)) as percentage_total 
from pizza_sales
where datepart(QUARTER, order_date) =1
group by pizza_size
order by percentage_total desc;

select pizza_category, sum(quantity) as total_pizza_sold
from pizza_sales 
group by pizza_category;

select * from pizza_sales
--Top 5 best sellers by total pizza sold

select TOP 5 pizza_name, sum(quantity) as Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold DESC;

--Bottom 5 worst sellers by total pizza sold
select TOP 5 pizza_name, sum(quantity) as Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold ASC;