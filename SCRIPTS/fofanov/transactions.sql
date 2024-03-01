begin;

with prod_update as (
    update products
        set discontinued = 1
        where units_in_stock < 10
        returning product_id
)
select *
into last_orders_on_discontinued
from order_details
where product_id in (select product_id from prod_update);
drop table  last_orders_on_discontinued1;
commit;

select * from last_orders_on_discontinued;


