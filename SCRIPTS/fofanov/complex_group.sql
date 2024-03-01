select * from products;


select supplier_id, sum(units_in_stock)
from products
group by supplier_id
order by supplier_id;

select supplier_id, category_id, sum(units_in_stock)
from products
group by supplier_id, category_id
order by supplier_id, category_id;


select supplier_id, category_id, sum(units_in_stock)
from products
group by grouping sets ((supplier_id), (supplier_id, category_id))
order by supplier_id, category_id nulls first;

select supplier_id, sum(units_in_stock) from
products
group by rollup (supplier_id)
order by supplier_id desc;


select supplier_id, category_id, reorder_level, sum(units_in_stock)
from products
group by rollup (supplier_id, category_id, reorder_level)
order by supplier_id, category_id nulls first ;

select supplier_id,category_id, sum(units_in_stock) from
products
group by cube (supplier_id, category_id)
order by supplier_id, category_id desc;

select supplier_id, category_id, reorder_level, sum(units_in_stock)
from products
group by cube (supplier_id, category_id, reorder_level)
order by supplier_id, category_id nulls first ;


select employee_id, sum(unit_price*od.quantity)
from orders
left join order_details od on orders.order_id = od.order_id
group by rollup (employee_id)
order by sum(unit_price*od.quantity) desc;


select employee_id, ship_country, sum(unit_price*od.quantity)
from orders
left join order_details od on orders.order_id = od.order_id
group by rollup (employee_id, ship_country)
order by employee_id, sum(unit_price*od.quantity) desc;

select employee_id, ship_country, sum(unit_price*od.quantity)
from orders
left join order_details od on orders.order_id = od.order_id
group by cube(employee_id, ship_country)
order by employee_id, sum(unit_price*od.quantity) desc;


