--Ex1
select count(distinct company_id)
from (
select company_id, title, description, count(job_id)
from job_listings
group by company_id, title, description
having count(job_id) >1) as count_duplicate

--Ex2
select a.category, a.product, sum(spend)
from product_spend as a
where extract(year from transaction_date) =2022
and product in (select b.product
                from product_spend as b
                where extract(year from transaction_date) =2022 and
                a.category = b.category
                group by b.category, b.product
                order by b.category, sum(b.spend) desc
                limit 2)
group by category, product
order by a.category, sum(a.spend) desc
--Ex3
WITH call_records AS (
SELECT
  policy_holder_id,
  COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
)

SELECT COUNT(policy_holder_id) AS member_count
FROM call_records;

--ex4
select page_id
from pages
except
select page_id
from page_likes

--Ex5
with cte as (select user_id, count(user_id)
from (
select user_id, extract(month from event_date), count(user_id)
from user_actions
where (extract(month from event_date) =7 
or extract(month from event_date)=6) 
and extract(year from event_date)= 2022 
group by user_id, extract(month from event_date)) as count_actions
group by user_id
having count(user_id) =2)

select '7' as mth, count(user_id) as monthly_active_users
from cte

--Ex6

select to_char(a.trans_date, 'yyyy-mm') as month, 
       a.country, 
       count(a.id) as trans_count,
       count(b.id) as approved_count,
       sum(a.amount) as trans_total_amount,
       case when sum(b.amount) is null then 0 else sum(b.amount) end as approved_total_amount
from transactions as a 
left join (select *
           from transactions
           where state = 'approved') as b
on a.id = b.id
group by 1, 2
  
--ex7
select product_id,
       year as first_year,
       quantity,
       price
from sales as a
where year in (
    select min(year)
    from sales as b
    where a.product_id=b.product_id
    group by product_id)
--ex8
select customer_id
from customer
group by customer_id
having count(distinct product_key) = (select count(*)
                                     from product)
--ex9
select employee_id
from employees
where salary < 30000 and
manager_id not in (select employee_id
                   from employees)
order by employee_id
--ex10
select count(distinct company_id)
from (
select company_id, title, description, count(job_id)
from job_listings
group by company_id, title, description
having count(job_id) >1) as job_count
--ex11
(select u.name as results
from movierating as mr
join users as u
on mr.user_id = u.user_id
group by u.name
order by count(mr.rating) desc, u.name
limit 1)
union all
(select m.title
from movierating as mr
join movies as m
on mr.movie_id = m.movie_id
where extract(month from created_at) = 2
and extract(year from created_at) = 2020
group by m.title
order by avg(mr.rating) desc, m.title
limit 1)
--ex12
with cte as(
select requester_id as id, count(requester_id) as c1
from requestaccepted
group by requester_id
union all
select accepter_id, count(accepter_id) as c2
from requestaccepted
group by accepter_id)

select id, sum(c1) as num
from cte
group by id
order by num desc
limit 1




