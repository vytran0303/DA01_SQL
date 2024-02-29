--Ex1
select  
sum(case when device_type = 'laptop' then 1 else 0 end) as laptop_views,
sum(case when device_type = 'tablet' or device_type = 'phone' then 1 else 0 end) as mobile_views
from viewership

--Ex2
select x, y, z,
       case when x + y > z 
             and x + z > y 
             and y + z > x then 'Yes'
            else 'No' end as triangle
from triangle
--Ex3





--Ex4

select name
from customer
where referee_id <> 2 or referee_id is null
--Ex5
select survived,
sum(case when pclass=1 then 1 else 0 end) as first_class,
sum(case when pclass=2 then 1 else 0 end) as second_class,
sum(case when pclass=3 then 1 else 0 end) as third_class
from titanic
group by survived
