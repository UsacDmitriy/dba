select distinct country
from customers;


select company_name, country
from suppliers
where country in (
    select distinct country
    from customers
);

select distinct s.company_name
from suppliers s
         join customers c on s.country = c.country;

select category_name, sum(units_in_stock)
from products
         join categories c on c.category_id = products.category_id
group by category_name
order by sum(units_in_stock) desc
limit (
    select min(product_id) + 4
    from products
);

select avg(units_in_stock)
from products;

select product_name, units_in_stock
from products p
where units_in_stock > (
    select avg(units_in_stock)
    from products
)
order by units_in_stock desc;

select company_name, contact_name
from customers
where exists(
              select customer_id
              from orders
              where orders.customer_id = customers.customer_id
                and freight between 50 and 100
          );

select product_name
from products
where not exists(
        select orders.order_id
        from orders
                 join order_details od on orders.order_id = od.order_id
        where od.order_id = products.product_id
          and order_date between '1995-02-01' and '1995-02-15'
    );

select distinct company_name
from customers c
         join orders o on c.customer_id = o.customer_id
         join order_details od on o.order_id = od.order_id
where quantity > 40;

select customer_id
from orders
         join order_details od on orders.order_id = od.order_id
where quantity > 40;

select distinct company_name
from customers
where customer_id = any (
    select customer_id
    from orders
             join order_details od on orders.order_id = od.order_id
    where quantity > 40
);

select avg(quantity)
from order_details;


select distinct product_name, quantity
from products
         join order_details od on products.product_id = od.product_id
where quantity > (
    select avg(quantity)
    from order_details
);

select avg(quantity)
from order_details
group by product_id
order by avg(quantity) desc;


select distinct product_name, quantity
from products
         join order_details od on products.product_id = od.product_id
where quantity > ALL (
    select avg(quantity)
    from order_details
    group by product_id
)
order by quantity;


select avg(quantity)
from order_details
group by product_id;

select product_name, units_in_stock
from products
where units_in_stock < all (
    select avg(quantity)
    from order_details
    group by product_id
)
order by units_in_stock desc;

select customer_id, avg(freight) as freight_sum
from orders
group by customer_id
order by avg(freight) desc;

select o.customer_id, sum(freight) as freight_sum
from orders o
         join (select customer_id, avg(freight) as freight_avg
               from orders
               group by customer_id) oa
              on oa.customer_id = o.customer_id
where freight > freight_avg
  and shipped_date between '1996-07-16' and '1996-07-31'
group by o.customer_id
order by freight_sum;

select order_id,
       sum(unit_price * order_details.quantity - unit_price * order_details.quantity * discount) as order_price
from order_details
group by order_id;

select customer_id, ship_country, order_price
from orders
         join (select order_id,
                      sum(unit_price * order_details.quantity -
                          unit_price * order_details.quantity * discount) as order_price
               from order_details
               group by order_id) od
              on orders.order_id = od.order_id
where ship_country in ('Argentina')
  and order_date >= '1997-09-01'
order by order_price desc
limit 5;

select product_id
from order_details
where quantity = 10;

select product_name
from products
where product_id = any (
    select product_id
    from order_details
    where quantity = 10
);














