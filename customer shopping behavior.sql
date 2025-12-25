

-- ---------------------- Q1 total revenue by gender ------------------------

select gender , sum(purchase_amount) as total_revenue
from customer 
group by gender ;

-- -------------------------- Q2  which customer use discount by and  buy more than avr revenue  ------------------

select avg(purchase_amount)
from customer;

select customer_id, purchase_amount 
from customer
where discount_applied ='yes' and purchase_amount > (select avg(purchase_amount) from customer)
order by 2 desc; 

-- ---------------------Q3  top 5 products with highiest review rating 

select item_purchased , round(avg(review_rating ), 2) as "avg product rating"
from customer 
group by 1 
order by 2 desc 
limit 5  ;


-- ---------------Q4  compare between express shipping and standart  -------------

 select distinct (shipping_type)
 from customer ;

 select shipping_type, round(avg(purchase_amount), 2) 
 from customer 
 where shipping_type in ('express' , 'standard')
 group by 1 ;
 
-- ---------------Q5   comparer avg spend betwenn subscribers and non subscribers

 select subscription_status, count(customer_id) as customer ,round(avg(purchase_amount), 2) as arg_purchace , sum(purchase_amount) as total_spend
 from customer 
 where subscription_status in ('yes' , 'no')
 group by 1 ;


-- ---------------Q6   5 products  with highiest percentage of purchases with discount   ------

select item_purchased , 
	   round(100 *sum(case when discount_applied='yes' then 1 else 0 end) / count(*),2) as  discount_rate 
from customer
group by 1
order by 2 desc 
limit 5  ;      

-- ------------------------ sagement customer into new , returning , and loyal 


with customer_type as (
    select customer_id , previous_purchases ,
    case 
	    when  previous_purchases = 1 then 'new'
        when previous_purchases between 2 and 10  then 'returning'
        else 'loyal'
        end 
        as customer_sagment

from customer 
)
select  customer_sagment, count(customer_sagment) 
from customer_type
group by 1;


-- -----------------  Q8 top 3 products for each category ------------------
with item_count as (
select item_purchased , category ,  count(customer_id) as total_orders , 
row_number() over(partition by category order by count(customer_id) desc ) as item_rank
from customer 
group by category , item_purchased
)
select item_rank , item_purchased , category , total_orders
from item_count
where item_rank <= 3 ; 


with item_counts as (
select item_purchased , category , count(customer_id) as total_orders, 
       row_number() over(partition by category order by count(customer_id) desc) as item_rank 
from customer 
group by category , item_purchased       
)
select item_rank  , category , item_purchased,  total_orders 
from item_counts 
where item_rank <=3;


-- -------------   Q9 are customers ( who buy more than previuos  5 items )  like to sub  --------


select  count(customer_id) as repeat_buyers ,subscription_status 
from customer
where previous_purchases > 5 
group by 2;


-- ----------------Q10  revenue for each age group 
select age_group  , sum(purchase_amount) as total_revenue 
from customer
group by 1 





























