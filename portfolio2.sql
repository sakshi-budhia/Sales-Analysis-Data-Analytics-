----data cleaning----
select *
from markets
where zone is null

delete from markets
where zone is null

----------------------------------------------------------------
-- in this case we would ask the company what has to be done
select * from transactions where sales_amount <=0

--here we see that the price for same item in the same place is not same,we then mention this to our company ,here i am deleting the rows
select market_code,product_code,sales_amount,sales_amount/sales_qty as price_per_item,count(product_code) over (partition by product_code)
from transactions 

delete from transactions
where sales_amount <=0
-----------------------------------------------------------------
select count(currency),currency from transactions group by currency
select * from transactions
where currency='usd'

update transactions
set sales_amount=sales_amount*82.44 where currency='usd'

update transactions
set currency='INR' where currency='usd'

-----------------------------------------------------------------

--total number of transactions
select count(*) from transactions
--total no of customers
select count(*) from customers
--total no of products
select count(*) from product


--show transactions from a particular place
select t.customer_code,t.order_date,t.product_code,t.sales_amount,t.sales_qty,m.markets_name
from transactions as t
join markets as m
on t.market_code=m.market_code
where m.markets_name= 'chennai'
order by order_date

--total transaction from the places
--1) tells us which place did the most bussiness
select m.markets_name,sum(t.sales_amount) as total_amt,sum(t.sales_qty) as total_quant
from transactions as t
join markets as m
on t.market_code=m.market_code
group by m.markets_name
order by sum(t.sales_amount)

--total trasaction from a place in a particular year
select d.year,markets_name,sum(t.sales_amount) as total_amt,sum(t.sales_qty) as total_quant
from transactions as t
join markets as m
on t.market_code=m.market_code
join date as d
on t.order_date=d.date
--where year='2020'
group by m.markets_name,d.year
order by year





--show transactions from every customer
--4)shows which customer has the higest transaction
select s.customer_name,sum(t.sales_amount) as total_amt,sum(t.sales_qty) as total_quant
from transactions as t
join customers as s
on s.customer_code=t.customer_code
group by customer_name
order by sum(t.sales_amount) desc

--show transaction on montly basis
--2)shows which mounth has the higest transaction
select month_name,sum(t.sales_amount),sum(t.sales_qty)
from transactions as t
join date as d
on d.date=t.order_date
group by d.month_name
order by sum(t.sales_amount)

--shows transaction on yearly basis
--3)check to see if our business is declining and incresing yearly
select d.year,sum(t.sales_amount) as total_amt ,sum(t.sales_qty) as total_qty
from transactions as t
join date as d
on d.date=t.order_date
group by d.year
order by sum(t.sales_amount)

--show transactions of every customered ordered from a particulr place
select t.customer_code,sum(t.sales_amount) as total_sales,sum(t.sales_qty) as total_quant
from transactions as t
join markets as m
on t.market_code=m.market_code
where m.markets_name= 'mumbai'
group by t.customer_code
order by t.customer_code

------------------------------------------------------------------------------------------
--find total number of trasaction done by customers at a particular place 
select t.customer_code,count(t.sales_amount)
from transactions as t
join markets as m
on t.market_code=m.market_code
where m.markets_name= 'chennai'
group by t.customer_code
order by count(t.sales_amount)

--find how many trasactions are foreign trasactions
select COUNT(t.product_code)
from transactions as t
where t.currency='usd'

--5)find top selling products
select t.product_code,count(t.sales_amount) 
from transactions as t
group by t.product_code
order by count(t.sales_amount) desc 

--6)top selling products in the year 2020
select t.product_code,count(t.sales_amount) 
from transactions as t
join date as d
on t.order_date=d.date
where d.year=2020
group by t.product_code
order by count(t.sales_amount) desc 

--7)which products are selling more and giving revenue -own brand or distribution
select product_type,sum(t.sales_amount) as total_revenue,sum(t.sales_qty) as sales_qty
from transactions as t
join product as p
on p.product_code=t.product_code
group by product_type

--transaction based on the markets
--8)tells us which market get the company the most revenue
select m.markets_name , sum(t.sales_amount)
from transactions as t
join markets as m
on m.market_code=t.market_code
group by m.markets_name
order by sum(t.sales_amount) desc



