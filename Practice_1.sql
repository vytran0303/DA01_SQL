-- Ex1
select name
from city
where countrycode = 'USA'
and population > 120000

-- Ex2
select *
from city
where countrycode = 'JPN'

-- Ex3
select city, state
from station

--Ex4
select distinct city
from station 
where city LIKE 'E%'
or city LIKE 'A%'
or city LIKE 'I%'
or city LIKE 'O%'
or city LIKE 'U%'

--Ex5
select distinct city
from station 
where city LIKE '%e'
or city LIKE '%a'
or city LIKE '%i'
or city LIKE '%o'
or city LIKE '%u'

--Ex6
select distinct city
from station 
where city NOT LIKE 'E%'
and city NOT LIKE 'A%'
and city NOT LIKE 'I%'
and city NOT LIKE 'O%'
and city NOT LIKE 'U%'

--Ex7
select name
from employee
order by name

--Ex8
select name
from employee
where salary >2000
and months <10
order by employee_id

--Ex9
select product_id
from products
where low_fats = 'Y' and recyclable = 'Y'

--Ex10
select name
from customer
where referee_id <> 2 or referee_id is null  

--Ex11
select name, population, area
from world
where population >=25000000
or area >=3000000

--Ex12
select distinct author_id as id
from views
where author_id = viewer_id
order by id

--Ex13
select part, assembly_step
from parts_assembly
where finish_date is null

--Ex14
select * 
from lyft_drivers
where yearly_salary <=30000
or yearly_salary >=70000

--Ex15
select distinct advertising_channel
from uber_advertising
where year =2019
and money_spent >100000
