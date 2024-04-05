--1. Total users and orders each month from 1/2019-4/2022
select format_date('%Y-%m', created_at) as month_year,
       count(distinct user_id) as total_user,
       count(order_id) as total_orders
from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete'
and created_at between '2019-01-01' and '2022-04-30'
group by 1
order by 1 desc
--2. AOV and distint user
select format_date('%Y-%m', a.created_at) as month_year,
       count(distinct a.user_id) as distinct_user,
       round(sum(b.sale_price)/count(distinct a.order_id),2) as avg_order_value
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id=b.order_id
where a.created_at between '2019-01-01' and '2022-04-30'
group by 1
order by 1 
--Theo thời gian từ 1/2019-4/2022, AOV dao động không đáng kể cho thấy cần có những campaign khuyến khích khách hàng mua hàng nhiều hơn như upsell, cross-sell


--3.Youngest/Oldest male and female
with min_max_age as (select first_name, last_name, gender, age, 'oldest' as tag
from bigquery-public-data.thelook_ecommerce.users
where age in (
select max(age)
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-01-01' and '2022-04-30'
group by gender)
and created_at between '2019-01-01' and '2022-04-30'
union all
select first_name, last_name, gender, age, 'youngest' as tag
from bigquery-public-data.thelook_ecommerce.users
where age in (
select min(age)
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-01-01' and '2022-04-30'
group by gender)
and created_at between '2019-01-01' and '2022-04-30')

select sum(case when tag='youngest' then 1 else 0 end) as total_youngest_user,
       min(age) as youngest_age,
       sum(case when tag='oldest' then 1 else 0 end) as total_oldest_user,
       max(age) as oldest_age
from min_max_age

--User trẻ nhất có độ tuổi là 12 và có 1052 user
--User lớn nhất có độ tuổi là 70 và có 990 user

--4. Top 5 highest profit product each month
with cte as (
select *,
       dense_rank() over(partition by month_year order by profit desc) as rank_per_month
from (
  select format_date('%Y-%m', c.created_at) as month_year,
       a.product_id,
       b.name,
       round(sum(a.sale_price) over(partition by format_date('%Y-%m', c.created_at), a.product_id order by format_date('%Y-%m', c.created_at)),2) as sale,
       round((sum(a.sale_price) over(partition by format_date('%Y-%m', c.created_at), a.product_id order by format_date('%Y-%m', c.created_at))/b.retail_price)*b.cost,2) as cost,
       round(sum(a.sale_price) over(partition by format_date('%Y-%m', c.created_at), a.product_id order by format_date('%Y-%m', c.created_at))-(sum(a.sale_price) over(partition by format_date('%Y-%m', c.created_at), a.product_id order by format_date('%Y-%m', c.created_at))/b.retail_price)*b.cost,2) as profit
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
join bigquery-public-data.thelook_ecommerce.orders as c
on a.order_id=c.order_id
where c.status = 'Complete'))

select distinct *
from cte
where rank_per_month in (1,2,3,4,5)
order by 1, rank_per_month


--5. Daily category revenue with in 3 months (current date 15/4/2022)
select distinct cast(c.created_at as date) as dates,
       b.category as product_category,
       round(sum(a.sale_price) over(partition by cast(a.created_at as date), b.category order by cast(a.created_at as date)),2) as revenue
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
join bigquery-public-data.thelook_ecommerce.orders as c
on a.order_id=c.order_id
where cast(c.created_at as date) between '2022-01-15' and '2022-04-15'
and c.status = 'Complete'

--Required dataset (month, year, category, tpv, tpo, revenue growth, order growth, total cost, total profit, profit to cost ratio)

with a as (select distinct format_date('%Y-%m', c.created_at) as Month,
       b.category as Product_category,
       c.order_id,
       b.cost,
       round(sum(a.sale_price) over(partition by format_date('%Y-%m', c.created_at), b.category order by format_date('%Y-%m', c.created_at)),2) as TPV
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
join bigquery-public-data.thelook_ecommerce.orders as c
on a.order_id=c.order_id
where c.status = 'Complete'
),

b as (select month,
       product_category,
       TPV,
       count(distinct order_id) as TPO,
       round(sum(cost),2) as Total_cost
from a
group by month, product_category, TPV)

select month,
             Product_category,
             TPV,
             TPO,
      concat(round(((TPV-lag(TPV) over(partition by product_category order by month))/lag(TPV) over(partition by product_category order by month))*100.00,2), '%') as Revenue_growth,
      concat(round(((TPO-lag(TPO) over(partition by product_category order by month))/lag(TPO) over(partition by product_category order by month))*100.00,2), '%') as Order_growth,
      Total_cost,
      round(TPV-Total_cost,2) as Total_profit,
      round((TPV-Total_cost)/Total_cost,2) as Profit_to_cost_ratio
from b
order by product_category, month

--Cohort Analysis
with a as (select user_id,
       created_at,
       first_purchase_date,
       (extract(year from created_at)-extract(year from first_purchase_date))*12
	+(extract(month from created_at)-extract(month from first_purchase_date)) as index
from (
select *,
       min(created_at) over(partition by user_id) as first_purchase_date
from bigquery-public-data.thelook_ecommerce.orders
where status ='Complete')),

b as (
select format_date('%Y-%m', created_at) as cohort_date,
       index,
       count(distinct user_id) as cnt
from a
group by cohort_date, index
order by cohort_date),
--customer cohort
c as (
select cohort_date,
       sum(case when index=0 then cnt else 0 end) as m0,
       sum(case when index=1 then cnt else 0 end) as m1,
       sum(case when index=2 then cnt else 0 end) as m2,
       sum(case when index=3 then cnt else 0 end) as m3
from b
group by 1
order by 1)

--retention cohort
select cohort_date,
       concat(round(100*m0/m0,2), '%') as m0,
       concat(round(100*m1/m0,2), '%') as m1,
       concat(round(100*m2/m0,2), '%') as m2,
       concat(round(100*m3/m0,2), '%') as m3
from c













