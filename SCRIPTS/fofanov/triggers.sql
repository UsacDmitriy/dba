alter table customers
    add column last_updated timestamp;

create or replace function track_changes_on_customers() returns trigger as
$$
begin
    new.last_updated = now();
    return new;
end;
$$ language plpgsql;

drop trigger if exists customers_timestamp on customers;
create trigger customers_timestamp
    before insert or update
    on customers
    for each row
execute procedure track_changes_on_customers();


select *
from customers
where customer_id = 'ALFKI';

update customers
set address ='bla'
where customer_id = 'ALFKI';

--
alter table employees
    add column user_changed text;


create or replace function track_changes_on_employees() returns trigger as
$$
begin
    new.user_changed = session_user;
    return new;
end;
$$ language plpgsql;

drop trigger if exists employees_user_change on employees;
create trigger employees_user_change
    before insert or update
    on employees
    for each row
execute procedure track_changes_on_employees();

select *
from employees;

update employees
set salary=88
where employee_id = 1;


-- Триггеры на аудит таблиц

drop table if exists products_audit;

create table products_audit
(

    op                char(1)     not null,
    user_changed      text        not null,
    time_stamp        timestamp   not null,

    product_id        smallint    not null,
    product_name      varchar(40) not null,
    supplier_id       smallint,
    category_id       smallint,
    quantity_per_unit varchar(20),
    unit_price        real,
    units_in_stock    smallint,
    units_on_order    smallint,
    reorder_level     smallint,
    discontinued      integer     not null
);

create or replace function build_audit_products() returns trigger as
$$
begin
    if tg_op = 'INSERT' then
        insert into products_audit
        select 'I', session_user, now(), nt.*
        from new_table nt;
    elseif tg_op = 'UPDATE' then
        insert into products_audit
        select 'U', session_user, now(), nt.*
        from new_table nt;
    elseif
        tg_op = 'DELETE' then
        insert
        into products_audit
        select 'D', session_user, now(), ot.*
        from old_table ot;
    end if;
    return null;

end;
$$ language plpgsql;


drop trigger if exists audit_products_insert on products;
create trigger audit_products_insert
    after insert
    on products
    referencing new table as new_table
    for each statement execute procedure build_audit_products();


drop trigger if exists audit_products_update on products;
create trigger audit_products_update
    after update
    on products
    referencing new table as new_table
    for each statement execute procedure build_audit_products();

drop trigger if exists audit_products_delete on products;
create trigger audit_products_delete
    after delete
    on products
    referencing old table as old_table
    for each statement execute procedure build_audit_products();


select * from products order by product_id desc ;

insert into products values (78,'Russian food',11,1,'12 boxes',20,15,4,15,0
);

select * from products_audit;

update products
set unit_price = 60
where product_id = 78;

select * from products_audit;

delete from products
where product_id=78;

-- аудирование таблички
alter table products add column last_updated timestamp;

create or replace function  track_products_changes() returns trigger as
    $$
    begin
        new.last_updated = now();
        return new;
    end;
    $$ language plpgsql;

drop trigger if exists products_timestamp on products;

create trigger products_timestamp before insert or update on products
    for each row execute procedure  track_products_changes();


select last_updated,*
from products
where product_id=2;

update products
set unit_price= 19.5
where product_id=2;

alter table products
disable trigger audit_products_update;







