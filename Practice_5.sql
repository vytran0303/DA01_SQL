--Mid-course test
--Q1
select distinct replacement_cost 
from film
order by replacement_cost
--Q2
select
sum(case when replacement_cost between 9.99 and 19.99 then 1 else 0 end) as low,
sum(case when replacement_cost between 20.00 and 24.99 then 1 else 0 end) as medium,
sum(case when replacement_cost between 25.00 and 29.99 then 1 else 0 end) as high
from film
--Q3
select f.title, c.name as category, f.length
from film as f
left join film_category as fc
on f.film_id=fc.film_id
left join category as c
on fc.category_id=c.category_id
where c.name = 'Drama' or c.name = 'Sports'
order by f.length desc
--Q4
select c.name as category, count(f.title) as number_films
from film as f
left join film_category as fc
on f.film_id=fc.film_id
left join category as c
on fc.category_id=c.category_id
group by category
order by number_films desc
--Q5
select concat(a.first_name, ' ', a.last_name) as full_name, count(film_id) as number_film
from actor as a
left join film_actor as fa
on a.actor_id = fa.actor_id
group by full_name
order by number_film desc
--Q6
select a.address
from address as a
left join customer as c
on a.address_id = c.address_id
where c.customer_id is null
--Q7
select city.city, sum(p.amount) as total_revenue
from payment as p
left join customer as c
on p.customer_id = c.customer_id
left join address as a 
on c.address_id = a.address_id
left join city
on a.city_id = city.city_id
group by city.city_id
order by total_revenue desc
--Q8
select concat(city.city, ', ', ct.country), sum(p.amount) as total_revenue
from payment as p
left join customer as c
on p.customer_id = c.customer_id
left join address as a 
on c.address_id = a.address_id
left join city
on a.city_id = city.city_id
left join country as ct
on city.country_id = ct.country_id
group by concat(city.city, ', ', ct.country)
order by total_revenue 

--Ex1
SELECT CONTINENT, FLOOR(AVG(C1.POPULATION))
FROM CITY AS C1
INNER JOIN COUNTRY AS C2
ON C1.COUNTRYCODE = C2.CODE
GROUP BY CONTINENT;
--Ex2

select round(count(t.email_id)::decimal/count(e.email_id),2) as activation_rate
from emails as e
left join texts as t
on t.email_id = e.email_id
and t.signup_action = 'Confirmed'

--Ex3
SELECT ab.age_bucket,
      round(100.0 *sum(case when activity_type = 'send' then time_spent else 0 end)
      /sum(case when activity_type = 'send' or activity_type = 'open' then time_spent else 0 end),2) as send_perc,
      round(100.0 *sum(case when activity_type = 'open' then time_spent else 0 end)
      /sum(case when activity_type = 'send' or activity_type = 'open' then time_spent else 0 end),2) as open_perc
from activities as a
inner join age_breakdown as ab 
on a. user_id = ab.user_id
group by ab.age_bucket
--Ex4
SELECT c.customer_id
from customer_contracts as c
left join products as p
on c.product_id = p.product_id
group by customer_id
having count(distinct p.product_category) = 3
--Ex5
select e1.employee_id,
       e1.name,
       count(*) as reports_count, 
       round(avg(e2.age)) as average_age
from employees as e1
inner join employees as e2
on e1.employee_id = e2.reports_to
group by e1.employee_id, e1.name
order by e1.employee_id
--Ex6
select p.product_name, sum(o.unit) as unit
from products as p
inner join orders as o
on p.product_id = o.product_id
where extract(month from order_date)=2 
and extract(year from order_date)=2020
group by p.product_name
having sum(o.unit) >=100
--Ex7
select page_id
from pages
except
select page_id
from page_likes



