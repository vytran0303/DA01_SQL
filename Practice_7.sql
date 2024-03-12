--ex1
select extract(year from transaction_date) as year,
       product_id,
       spend as curr_year_spend,
       lag(spend) over(partition by product_id order by extract(year from transaction_date)) as prev_year_spend,
       round((spend - lag(spend) over(partition by product_id order by extract(year from transaction_date)))/
       lag(spend) over(partition by product_id order by extract(year from transaction_date)) *100,2) as yoy_rate
from user_transactions
--ex2
  
with cte as (select issue_month, card_name, 
       issued_amount,
       row_number() over(partition by card_name order by make_date(issue_year, issue_month, 1)) as row
from monthly_cards_issued)
select card_name, issued_amount
from cte
where row = 1
order by issued_amount desc

--ex3
with cte as (
             select *,
             row_number() over(partition by user_id order by transaction_date) as row
             from transactions)
select user_id, spend, transaction_date
from cte
where row =3

--ex4
with cte as (
             select product_id, user_id, transaction_date,
                    rank() over(partition by user_id order by transaction_date desc) as rank
             from user_transactions)
select transaction_date, user_id, count(product_id)
from cte 
where rank=1
group by user_id, transaction_date
order by transaction_date

--ex5
select user_id,
       tweet_date, 
       round(avg(tweet_count) over(partition by user_id order by tweet_date 
                                  rows between 2 preceding and current row), 2) as rolling_avg_3d
from tweets

--ex6
with cte as (select *,
      count(merchant_id) over(partition by merchant_id, credit_card_id, amount order by amount) as count
from transactions),

same_amount as (select *,
       lead(transaction_timestamp) over(partition by merchant_id order by transaction_timestamp) as next_trans,
       round(extract(epoch from age(lead(transaction_timestamp) over(partition by merchant_id order by transaction_timestamp),
       transaction_timestamp))/60::int) as gap_trans
from cte
where count>1)

select count(merchant_id)
from same_amount
where gap_trans >=10

--ex7

with cte as (select category, product, sum(spend) as total_spend,
       rank() over(partition by category order by sum(spend) desc) as rank
from product_spend
where extract(year from transaction_date)=2022
group by category, product)
select category, product, total_spend
from cte 
where rank=1 or rank=2

--ex8

with cte as (select a.artist_name, count(*),
                   dense_rank() over(order by count(*) desc) as artist_rank

from global_song_rank as g
join songs as s 
on g.song_id = s.song_id
join artists as a
on a.artist_id= s.artist_id
where rank<=10
group by artist_name
order by count(*) desc
)

select artist_name, artist_rank
from cte
where artist_rank<=5

