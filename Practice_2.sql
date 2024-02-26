--ex1
select distinct city
from station
where id % 2 =0
--ex2
select count(*) - count(distinct city)
from station;
--ex3
select ceiling(avg(salary) - avg(replace(salary, 0, '')))
from employees
--ex4
select round(
sum(item_count::decimal*order_occurrences)/sum(order_occurrences),1)
from items_per_order
--ex5
select candidate_id
from candidates
where skill = 'Python'
or skill = 'Tableau'
or skill = 'PostgreSQL'
group by candidate_id
having count(*) = 3
order by candidate_id
--ex6
select user_id, max(post_date)::date - min(post_date)::date
from posts
where date_part('year', post_date) = 2021
group by user_id
having max(post_date)::date - min(post_date)::date >0
--ex7
select card_name, max(issued_amount) - min(issued_amount)
from monthly_cards_issued
group by card_name
order by max(issued_amount) - min(issued_amount) desc
--ex8
select manufacturer, 
       count(drug) as drug_count, 
       sum(cogs - total_sales) as total_losses
from pharmacy_sales
where cogs > total_sales
group by manufacturer
order by total_losses desc
--ex9
select *
from cinema
where description <> 'boring'
and id % 2 <> 0
order by rating desc
--ex10
select teacher_id, count(distinct subject_id)
from teacher
group by teacher_id
--ex11
select user_id, count(follower_id) as followers
from followers
group by user_id
order by user_id
--ex12
select class
from Courses
group by 1
having count(*)>=5
