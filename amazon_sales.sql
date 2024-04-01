-- Creating a data base and importing data --
create database amazon_sales_data;

-- Viewing data --
select *
from amazon_sales_data.sales_data;

-- formating columns into right format --
Alter table amazon_sales_data.sales_data
modify Region varchar(50),
modify Country varchar(50),
change column `Item Type` item_type varchar(50),
change column `Sales Channel` sales_channel varchar(50),
change column `Order Priority` order_priority varchar(50),
change column `Order Date` order_date varchar(50),
change column `Order ID` order_id varchar(20),
change column `Ship Date` ship_date varchar(20), 
change column `Units Sold` unit_sold varchar(20),
change column `Unit Price` unit_price decimal(10,2),
change column `Unit Cost` unit_cost decimal(10,2),
change column `Total Revenue` total_revenue decimal(20,2),
change column `Total Cost` total_cost decimal(20,2),
change column `Total Profit` total_profit decimal(10,2);

Update amazon_sales_data.sales_data
SET order_date = str_to_date(order_date, '%m/%d/%Y');

Update amazon_sales_data.sales_data
SET ship_date = str_to_date(ship_date, '%m/%d/%Y');

-- Now moving to analysis--

-- 1. Region wise sales revenue --
select Region, SUM(total_revenue) AS total_revenue
from amazon_sales_data.sales_data 
group by Region 
order by total_revenue DESC;

-- 2. Region wise sales profit --
select Region, SUM(total_profit) AS total_profit
from amazon_sales_data.sales_data 
group by Region
order by total_profit DESC;

-- 3. Top 10 Country sales profit wise--
select Country, SUM(total_profit) AS total_profit
from amazon_sales_data.sales_data 
group by Country
order by total_profit DESC
limit 10;

-- 4. lowest 10 Country sales profit wise--
select Country, SUM(total_profit) AS total_profit
from amazon_sales_data.sales_data 
group by Country
order by total_profit
limit 10;

-- Sales trend based on day --
select dayname(order_date) AS Days, SUM(total_revenue) as total_revenue, 
	ROUND(SUM(total_revenue)*100/(select SUM(total_revenue) from amazon_sales_data.sales_data),2) AS percentage
from amazon_sales_data.sales_data
group by dayname(order_date)
order by percentage DESC;

-- Sales trend based on months --
select monthname(order_date) AS months, count(distinct(order_id)) as no_of_sales
from amazon_sales_data.sales_data
group by monthname(order_date)
order by no_of_sales DESC;

-- Sales trend based on year --
select year(order_date) AS year, count(distinct(order_id)) as no_of_sales
from amazon_sales_data.sales_data
group by year(order_date)
order by year(order_date);

-- Sales trend based on caegory --
select item_type, SUM(total_revenue) as total_revenue, 
	ROUND(SUM(total_revenue)*100/(select SUM(total_revenue) from amazon_sales_data.sales_data),2) AS percentage
from amazon_sales_data.sales_data
group by item_type
order by percentage DESC;