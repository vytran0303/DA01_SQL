--Ex1
select name
from students
where marks > 75
order by right(name,3), id
--Ex2

select user_id, 
concat(upper(left(name,1)), lower(substring(name, 2, length(name)))) as name
from users
order by user_id
--Ex3

select manufacturer, concat('$', round(sum(total_sales), -6)/10^6, ' ', 'million') as total_sales
from pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer
--Ex4

select extract(month from submit_date) as month,
       product_id,
       round(avg(stars), 2) as avg_rating
from reviews
group by product_id, month
order by month, product_id
--Ex5


select sender_id, count(message_id)
from messages
where extract(month from sent_date) = '08'
and extract(year from sent_date) = '2022'
group by sender_id
order by count(message_id) desc
limit 2
--Ex6

select tweet_id
from tweets
where length(content) >15
--Ex7

select activity_date as day, count(distinct user_id) as active_users 
from activity 
where activity_date between date '2019-07-27' - interval '29 day' and '2019-07-27' 
group by activity_date
--Ex8

select count(*)
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) = '2022'
--Ex9

select position('a' in first_name)
from worker
where first_name = 'Amitah'
--Ex10

select title, substring(title from length(winery)+2 for 4)
from winemag_p2
where country = 'Macedonia'
