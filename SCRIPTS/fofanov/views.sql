create view product_suppliers_categories as
select product_name,
       quantity_per_unit,
       unit_price,
       units_in_stock,
       company_name,
       contact_name,
       phone,
       category_name,
       description
from products
         join suppliers s on s.supplier_id = products.supplier_id
         join categories c on c.category_id = products.category_id;

select *
from product_suppliers_categories;

select *
from product_suppliers_categories
where unit_price > 20;

drop view if exists product_suppliers_categories;

select *
from orders;

create view heavy_orders as
select *
from orders
where freight > 50;

select *
from heavy_orders
order by freight;


create or replace view heavy_orders as
select *
from orders
where freight > 100
with cascaded check option;

select *
from heavy_orders
order by freight;

create view product_suppliers_categories as
select product_name,
       quantity_per_unit,
       unit_price,
       units_in_stock,
       company_name,
       contact_name,
       phone,
       category_name,
       description
from products
         join suppliers s on s.supplier_id = products.supplier_id
         join categories c on c.category_id = products.category_id;


select max(order_id)
from orders;
--
-- insert into heavy_orders
-- values
-- (11078, 'VINET')


select min(freight)
from orders;

delete
from heavy_orders
where freight < 0.05;

select min(freight)
from heavy_orders;

delete
from heavy_orders
where freight < 100.25;


insert into heavy_orders
values (11901, 'ERNSH', 3, '1998-01-27', '1998-02-24', '1998-02-05', 1, 80, 'Ernst Handel', 'Kirchgasse 6', 'Graz',
        null, 8010, 'Austria');


select *
from orders
where order_id = 11900;

create view customer_employees as
select order_date,
       required_date,
       shipped_date,
       ship_postal_code,
       company_name,
       contact_name,
       phone,
       last_name,
       first_name,
       title
from orders
join customers c on c.customer_id = orders.customer_id
join employees e on e.employee_id = orders.employee_id;

select * from customer_employees
where order_date >'1997-01-01';

create or replace view customer_employees as
select order_date,
       required_date,
       shipped_date,
       ship_postal_code,
       company_name,
       contact_name,
       phone,
       last_name,
       first_name,
       title,
       ship_postal_code
from orders
join customers c on c.customer_id = orders.customer_id
join employees e on e.employee_id = orders.employee_id;

alter view customer_employees rename to ce_old;

create or replace view customer_employees as
select order_date,
       required_date,
       shipped_date,
       ship_postal_code,
       company_name,
       contact_name,
       phone,
       last_name,
       first_name,
       title,
       c.postal_code
from orders
join customers c on c.customer_id = orders.customer_id
join employees e on e.employee_id = orders.employee_id;


drop view if exists ce_old;


