select category_id, avg(unit_price) as avg_price
from products
group by category_id
limit 7;


select category_id,
       category_name,
       product_name,
       unit_price,
       avg(unit_price) over (partition by category_id) as avg_price
from products
         join categories using (category_id);

-- Нарастающий итог по заказам

select order_id,
       order_date,
       product_id,
       customer_id,
       unit_price                                                       as sub_total,
       sum(unit_price) over (partition by order_id order by product_id) as sales_sum
from orders
         join order_details using (order_id);

-- с общим нарастающим итогом
select order_id,
       order_date,
       product_id,
       customer_id,
       unit_price                               as sub_total,
       sum(unit_price) over (order by order_id) as sales_sum
from orders
         join order_details using (order_id)
order by order_id;

select row_id,
       order_id,
       order_date,
       product_id,
       customer_id,
       unit_price                             as sub_total,
       sum(unit_price) over (order by row_id) as sales_sum
from (
         select order_id,
                order_date,
                product_id,
                customer_id,
                unit_price,
                row_number() over () as row_id
         from orders
                  join order_details using (order_id)
     ) subquery
order by order_id;

-- Ранжирование

select product_name,
       units_in_stock,
       rank() over (order by product_id)
from products;

select product_name,
       units_in_stock,
       rank() over (order by units_in_stock)
from products;

select product_name,
       units_in_stock,
       dense_rank() over (order by units_in_stock)
from products;

select product_name,
       unit_price,
       dense_rank() over (
           order by case
                        when unit_price > 80 then 1
                        when unit_price > 30 and unit_price < 80 then 2
                        else 3
               end
           ) as ranking
from products
order by unit_price desc;


select product_name,
       unit_price,
       lag(unit_price) over (order by unit_price desc) - products.unit_price as price_lag
from products
order by unit_price desc;


select product_name,
       unit_price,
       lead(unit_price) over (order by unit_price ) - products.unit_price as price_lag
from products
order by unit_price;

select product_name,
       unit_price,
       lead(unit_price, 2) over (order by unit_price ) - products.unit_price as price_lag
from products
order by unit_price;

-- Возврат N записей

select product_id,
       unit_price,
       row_number() over (order by unit_price DESC ) as nth
from products;

select *
from products
where product_id = any (
    select product_id
    from (select product_id,
                 unit_price,
                 row_number() over (order by unit_price DESC ) as nth
          from products) sorted_prices
    where nth < 4
);

select *
from (
         select product_id,
                product_name,
                unit_price,
                units_in_stock,
                row_number() over (order by unit_price DESC ) as nth
         from products
     ) as sorted_prices
where nth < 4
order by unit_price;

select *
from (
         select order_id,
                product_id,
                unit_price,
                quantity,
                rank() over (partition by order_id order by (quantity) Desc) as rank_quant
         from orders
                  join order_details using (order_id)
     ) as subquery
where rank_quant >= 3;

-- суммы продаж

select employee_id, sum(unit_price * order_details.quantity) over (partition by employee_id) as total_by_employee
from orders
         left join order_details using (order_id);


select distinct employee_id, total_by_employee, avg(total_by_employee) over () as avg_price
from (select employee_id, sum(unit_price * order_details.quantity) over (partition by employee_id) as total_by_employee
      from orders
               left join order_details using (order_id)) q
order by total_by_employee desc;

select last_name, first_name, salary, title, dense_rank() over (order by salary desc) from employees;









