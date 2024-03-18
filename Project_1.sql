select * from sales_dataset_rfm_prj
-- 1. Change data type
alter table sales_dataset_rfm_prj
alter column ordernumber type numeric
using ordernumber::numeric

alter table sales_dataset_rfm_prj
alter column quantityordered type int
using ordernumber::int

alter table sales_dataset_rfm_prj
alter column priceeach type numeric
using priceeach::numeric

alter table sales_dataset_rfm_prj
alter column orderlinenumber type int
using orderlinenumber::int

alter table sales_dataset_rfm_prj
alter column sales type numeric
using sales::numeric

alter table sales_dataset_rfm_prj
alter column orderdate type date
using orderdate::date

alter table sales_dataset_rfm_prj
alter column status type varchar(20)
using status::varchar

alter table sales_dataset_rfm_prj
alter column msrp type int
using msrp::int

--2. Null/Blank
select *
from sales_dataset_rfm_prj
where ordernumber is null
or quantityordered is null
or priceeach is null
or orderlinenumber is null
or sales is null
or orderdate is null
--No null/blank value in these fields

--3. Add columns contactlastname, contactfirstname
--Add columns
alter table sales_dataset_rfm_prj
add column contactlastname VARCHAR

alter table sales_dataset_rfm_prj
add column contactfirstname VARCHAR
--Update
update sales_dataset_rfm_prj
set contactfirstname = initcap(substring(contactfullname from 0 for position('-' in contactfullname)))

update sales_dataset_rfm_prj
set contactlastname = initcap(substring(contactfullname from position('-' in contactfullname)+1 for length(contactfullname)))

--4.Add columns qtr_id, month_id, year_id

alter table sales_dataset_rfm_prj
add column qtr_id int

alter table sales_dataset_rfm_prj
add column month_id int

alter table sales_dataset_rfm_prj
add column year_id int

update sales_dataset_rfm_prj
set qtr_id=extract(quarter from orderdate)

update sales_dataset_rfm_prj
set month_id=extract(month from orderdate)

update sales_dataset_rfm_prj
set year_id=extract(year from orderdate)

--5.Identify outlier
--5.1.Box plot
with min_max_value as (
select Q1-1.5*IQR as min, Q3+1.5*IQR as max
from (
select percentile_cont(0.25) within group (order by quantityordered) as Q1,
       percentile_cont(0.75) within group (order by quantityordered) as Q3,
	   percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered) as IQR
from sales_dataset_rfm_prj))

select *
from sales_dataset_rfm_prj
where quantityordered < (select min from min_max_value)
or quantityordered > (select max from min_max_value)

--No outlier for box plot method
--5.2 Z-score

with cte as (
select *, 
(select avg(quantityordered)
from sales_dataset_rfm_prj) as avg, 
(select stddev(quantityordered) 
from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj)

select ordernumber, quantityordered,
       (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev) >2
	   
-- No outlier for z-score method














