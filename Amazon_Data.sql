create database Capstone;
select * from amazon;

#1.Data wranglining
create table amazon(
invoice_id VARCHAR(30) not null,
branch VARCHAR(5) not null, 
city VARCHAR(30) not null,
customer_type VARCHAR(30) not null,
gender VARCHAR(30) not null,
product_line VARCHAR(100) not null,
unit_price DECIMAL(10, 2) not null, 
quantity int not null,
VAT float(6,4) not null,
total DECIMAL(10, 2) not null,
date date not null,
time time not null,
payment_method VARCHAR(30) not null,
cogs DECIMAL(10, 2) not null, 
gross_margin_percentage float(11, 9) not null,
gross_income DECIMAL(10, 2) not null,
rating float(2,1) not null 
);

#2.Feature Engineering:

#adding column timeofday
alter table amazon
add column timeofday varchar(20) after time;

set sql_safe_updates = 0;

update amazon
	set timeofday =
		case 
             when time(time) >= '00:00:00' and time(time) < '12:00:00' then 'Morning'
             when time(time) >= '12:00:00' and time(time) < '18:00:00' then 'Afternoon'
             else 'evening'
         end;    
    
    
#adding column dayname
alter table amazon 
add column dayname varchar(20) after date;

update amazon
set dayname =dayname(date);

#adding column monthname
alter table amazon 
add column monthname varchar(20 )after date;

update amazon 
set monthname=monthname(date);


#Business Questions To Answer:

#1.What is the count of distinct cities in the dataset?
select count(distinct city) as Total_no_of_city from amazon;

#2.For each branch, what is the corresponding city?
select  distinct branch,city from amazon;

#3.What is the count of distinct product lines in the dataset?
select count(distinct product_line) as Total_no_of_Productline from amazon;

#4.Which payment method occurs most frequently?
select payment_method,count(payment_method) as frequency from amazon
group by payment_method
order by frequency desc

#5.Which product line has the highest sales?
 select product_line,count(*) as total_sales from amazon
 group by product_line
 order by total_sales desc;

#6.How much revenue is generated each month?
select distinct monthname,sum(total) as revenue from amazon
group by monthname
order by revenue desc;

#7.In which month did the cost of goods sold reach its peak?
select monthname,sum(cogs) as Total_cogs from amazon
group by monthname
order by  Total_cogs desc 
limit 1;

#8.Which product line generated the highest revenue?
select product_line,sum(total) as highest_revenue from amazon
group by product_line
order by highest_revenue desc
limit 1;

#9.In which city was the highest revenue recorded?
select city,sum(total) as highest_revenue from amazon
group by city
order by highest_revenue desc
limit 1;

#10.Which product line incurred the highest Value Added Tax?
select product_line,sum(VAT) as highest_Value_Added_Tax from amazon
group by product_line
order by highest_Value_Added_Tax desc
limit 1;

#11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select product_line,sum(total) as total_sales,
case
    when sum(total) > (select avg(total) from amazon) then 'Good'
    else 'Bad'
end as sales_status 
from amazon
group by product_line
order by total_sales desc;

#12.Identify the branch that exceeded the average number of products sold.
select branch,sum(quantity) as total_quantity
from amazon
group by branch
having sum(quantity) > (select avg(quantity) from amazon);
select avg(quantity) from amazon

#13.Which product line is most frequently associated with each gender?
select product_line,gender,count(*) as frequency from amazon
group by gender,product_line
order by frequency desc

#14.Calculate the average rating for each product line.
select product_line,avg(rating) avg_rat from amazon
group by product_line
order by avg_rat desc

#15.Count the sales occurrences for each time of day on every weekday.
select dayname,timeofday,count(*) as sales_occurrence  from amazon
group by dayname,timeofday
order by sales_occurrence desc

#16.Identify the customer type contributing the highest revenue.
select customer_type,sum(total) as revenue from amazon
group by customer_type
order by  revenue desc
limit 1;

#17.Determine the city with the highest VAT percentage.
select city,
sum(VAT) as highest_VAT,
sum(total) as total_sales,
(sum(VAT) / sum(total) ) * 100 as highest_VAT_percentage
from amazon
group by city
order by highest_VAT_percentage desc;

#18.Identify the customer type with the highest VAT payments.
select customer_type,sum(VAT) as VAT_payments from amazon
group by customer_type
order by VAT_payments desc
limit 1;

#19.What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as distinct_customers from amazon;

#20.What is the count of distinct payment methods in the dataset?
select count(distinct payment_method) as distinct_payment from amazon;

#21.Which customer type occurs most frequently?
select customer_type,count(customer_type) as frequent_customer from amazon
group by customer_type
order by frequent_customer desc
limit 1;

#22.Identify the customer type with the highest purchase frequency.
select customer_type,count(*) as highest_purchase from amazon
group by customer_type
order by highest_purchase desc
limit 1;

#23.Determine the predominant gender among customers.
select gender,count(*) as predominant from amazon
group by gender
order by predominant desc
limit 1;

#24.Examine the distribution of genders within each branch.
select branch,gender,count(gender) as distribution from amazon
group by branch,gender
order by distribution desc

#25.Identify the time of day when customers provide the most ratings.
select timeofday,count(rating) as rating_count from amazon
group by timeofday
order by rating_count desc
limit 1;

#26.Determine the time of day with the highest customer ratings for each branch.
select timeofday,branch,avg(rating) as rating_count from amazon
group by timeofday,branch
order by rating_count desc

#27.Identify the day of the week with the highest average ratings.
select dayname,avg(rating) as highest_average_rating from amazon
group by dayname
order by highest_average_rating desc;

#28.Determine the day of the week with the highest average ratings for each branch.
select dayname,branch,avg(rating) as highest_average_rating from amazon
group by dayname,branch
order by highest_average_rating desc;



