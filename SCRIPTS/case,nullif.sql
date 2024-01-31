select product_name,
       unit_price,
       units_in_stock,
       case
           when units_in_stock >= 100 then 'lots of'
           when units_in_stock >= 50 and units_in_stock < 100 then 'average'
           when units_in_stock < 50 then 'low number'
           else 'unknown'
           end as amount
from products
order by units_in_stock desc;


select order_id,
       order_date,
       case
           when date_part('month', order_date) between 3 and 5 then 'spring'
           when date_part('month', order_date) between 6 and 8 then 'summer'
           when date_part('month', order_date) between 9 and 11 then 'fall'
           else 'winter'
           end as season
from orders;

select product_name,
       case
           when unit_price < 30 then 'expensive'
           else 'cheap'
           end
from products;

select *
from orders
limit 10;

select order_id, order_date, coalesce(ship_region, 'unknown') as region
from orders
limit 10;

select *
from employees;

select last_name, first_name, coalesce(region, 'n/a')
from employees;

select *
from customers;

select contact_name, coalesce(nullif(city, ''), 'undefined') as city
from customers;

select contact_name, city, country
from customers
order by contact_name,
         (
             case
                 when city is null then country
                 else city
                 end
             );


select contact_name, coalesce(order_id::text, 'Igor_Kuko')
from customers
         left outer join orders o on customers.customer_id = o.customer_id
where order_id is null;

select concat(last_name, ' ', first_name), coalesce(nullif(title, 'Sales Representative'), 'Igor')
from employees;

