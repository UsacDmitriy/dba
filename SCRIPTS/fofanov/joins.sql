select  avg(units_in_stock), region from products
inner join suppliers s on s.supplier_id = products.supplier_id
group by region;


select order_id, customer_id, first_name, last_name, title
from orders
inner join employees e on e.employee_id = orders.employee_id;


select order_date, product_name, ship_country, p.unit_price, quantity, discount
from orders
inner join order_details od on orders.order_id = od.order_id
inner join products p on p.product_id = od.product_id;

select company_name, product_name
from suppliers
left join products p on suppliers.supplier_id = p.supplier_id;

select company_name, order_id
from customers
left join orders o on customers.customer_id = o.customer_id
where order_id is null;

select count(*)
from employees
left join orders o on employees.employee_id = o.employee_id
where order_id is null;

select contact_name, company_name, phone, first_name, last_name, title, order_date, product_name, ship_country, p.unit_price,
       quantity, discount
from orders
join order_details od on orders.order_id = od.order_id
join products p on p.product_id = od.product_id
join customers c on c.customer_id = orders.customer_id
join employees e on e.employee_id = orders.employee_id
where ship_country='USA';

select contact_name, company_name, phone, first_name, last_name, title, order_date, product_name, ship_country, p.unit_price,
       quantity, discount
from orders
join order_details od using (order_id) --on orders.order_id = od.order_id
join products p  using (product_id) --p.product_id = od.product_id
join customers c on c.customer_id = orders.customer_id
join employees e on e.employee_id = orders.employee_id
where ship_country='USA';


select order_id, customer_id, order_date
from orders;

select c.company_name, concat(e.first_name, ' ', e.last_name)
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id
join shippers s on s.shipper_id = o.ship_via
where c.city = 'London' and e.city = 'London' and s.company_name = 'Speedy Express';

select product_name, p.units_in_stock, contact_name, phone
from products p
join categories c on c.category_id = p.category_id
join suppliers s on s.supplier_id = p.supplier_id
where (c.category_name = 'Seafood' or c.category_name = 'Bevarages') and p.units_in_stock < 20;

select contact_name, order_id
from customers
left join orders o on customers.customer_id = o.customer_id
where order_id is null;


