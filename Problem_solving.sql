select count(distinct company_id)
from (
select company_id, title, description, count(job_id)
from job_listings
group by company_id, title, description
having count(job_id) >1) as count_duplicate
