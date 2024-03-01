select company_name
from suppliers
where country in (
    select country
    from customers
);


with customer_countries as (
    select country
    from customers
)
select company_name
from suppliers
where country in (
    select *
    from customer_countries
);

select company_name
from suppliers
where not exists(
        select products.product_id
        from products
                 join order_details od on products.product_id = od.product_id
                 join orders o on o.order_id = od.order_id
        where suppliers.supplier_id = products.supplier_id
          and order_date between '1998-02-01' and '1998-02-04'
    );

select company_name
from products
         join order_details od on products.product_id = od.product_id
         join orders o on o.order_id = od.order_id
         join suppliers s on s.supplier_id = products.supplier_id
where order_date between '1998-02-01' and '1998-02-04'

with filtered as (
    select company_name, s.supplier_id
    from products
             join order_details od on products.product_id = od.product_id
             join orders o on o.order_id = od.order_id
             join suppliers s on s.supplier_id = products.supplier_id
    where order_date between '1998-02-01' and '1998-02-04'
)
--      cte2 as(
--
--      )
select company_name
from suppliers
where supplier_id not in (select supplier_id from filtered);

-- reverse CTE

create table employee
(
    employee_id int primary key,
    first_name  varchar not null,
    last_name   varchar not null,
    manager_id  int,
    foreign key (manager_id) references employee (employee_id) on delete cascade
);

insert into employee (employee_id, first_name, last_name, manager_id)
VALUES (1, 'windy', 'Hays', null),
       (2, 'def', 'fujk', 1),
       (3, 'susan', 'rich', 1),
       (4, 'kurt', 'void', 2),
       (5, 'kerry', 'shine', 2),
       (6, 'igor', 'kuko', 3),
       (7, 'timur', 'deploy', 3);

select *
from employee;

select concat(e.first_name, ' ', e.last_name) as employee,
       concat(m.first_name, ' ', m.last_name) as manager
from employee e
         left join employee m on m.employee_id = e.manager_id
order by manager;

with recursive submission(
                          sub_line, employee_id
    ) as (
        select last_name, employee_id from employee
        where manager_id is null
        union all
        select sub_line || ' -> ' || e.last_name, e.employee_id
        from employee e, submission s
        where e.manager_id = s.employee_id
)
select * from submission;
