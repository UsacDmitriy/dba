select *
from customers;


select *
into tmp_customers
from customers;

select *
from tmp_customers;

update tmp_customers
set region = 'Unknown'
where region is null;


create or replace function fix_customer_region() returns void as
$$
update tmp_customers
set region = 'Kuko'
where region = 'Unknown'
$$
    language sql;

select fix_customer_region();

create or replace function sum_products() returns bigint as
$$
select sum(units_in_stock)
from products
$$ language sql;

select sum_products() as total_goods;

create or replace function get_product_price_by_name(prod_name varchar) returns real as
$$
select unit_price
from products
where product_name = prod_name
$$
    language sql;


select get_product_price_by_name('Chocolade') as price;


create or replace function get_price_boundaries_by_discontinuity(in is_discontinued int default 1, out max_price real, out min_price real) as
$$
    select max(unit_price), min(unit_price)
    from products
    where discontinued = is_discontinued
$$ language sql;


select get_price_boundaries(1);
select * from get_price_boundaries_by_discontinuity(1);




