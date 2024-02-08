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
select *
from get_price_boundaries_by_discontinuity(1);

create or replace function get_total_number_of_goods() returns bigint as
$$
begin
    return sum(units_in_stock) from products;
end;
$$ language plpgsql;


select get_total_number_of_goods();

create or replace function get_price_boundaries_by_discontinued() returns real as
$$
begin
    return max(unit_price) from products
        where
    discontinued = 1;
end;
$$ language plpgsql;

select get_price_boundaries_by_discontinued();


create or replace function get_price_boundaries(out max_price real, out min_price real) as
$$
begin
    --         max_price := max(unit_price) from products;
--         min_price := min(unit_price) from products;
    select max(unit_price), min(unit_price)
    into max_price, min_price
    from products;
end;
$$ language plpgsql;

select *
from get_price_boundaries();

create or replace function get_sum(x int, y int, out result int) as
$$
begin
    result := x + y;
    return;
end;
$$ language plpgsql;


select *
from get_sum(2, 3);

create or replace function get_customers_by_country(customer_country varchar) returns setof customers as
$$
begin
    return query
        select *
        from customers
        where country = customer_country;
end;
$$ language plpgsql;

create or replace function get_avg_prices_by_prod_categories() returns setof double precision as
$$
begin
    return query
        select avg(unit_price)
        from products
        group by category_id;
end;
$$ language plpgsql;

select *
from get_avg_prices_by_prod_categories();

create or replace function get_customers_by_country2(customer_country varchar)
    returns table
            (
                char_code    char,
                company_name varchar
            )
as
$$
begin
    return query
        select customer_id, customers.company_name
        from customers
        where country = customer_country;
end;
$$ language plpgsql;

select *
from get_customers_by_country2('USA');


create or replace function get_customers_by_country3(customer_country varchar) returns setof customers as
$$
begin
    return query
        select *
        from customers
        where country = customer_country;
end;
$$ language plpgsql;

select *
from get_customers_by_country3('USA');

create or replace function triangle_square(ab real, bc real, ac real) returns real as
$$
declare
    perimetr real;
begin
    perimetr := ab + bc + ac;
    return sqrt(perimetr * (perimetr - ab) * (perimetr - bc) * (perimetr - ac));
end;
$$ language plpgsql;

select triangle_square(6, 6, 6);

create or replace function middle_price_with_options() returns setof products as
$$
declare
    avg_price  real;
    low_price  real;
    high_price real;

begin
    select avg(unit_price) into avg_price from products;

    low_price = avg_price * 0.75;
    high_price = avg_price * 1.25;

    return query
        select *
        from products
        where unit_price between low_price and high_price;

end;
$$ language plpgsql;

select *
from middle_price_with_options();


create or replace function convert_temp(temperature real, to_celsius bool default true) returns real as
$$
declare
    result_temp real;
begin
    if to_celsius then
        result_temp := (5.9 / 9.0) * (temperature - 32);
    else
        result_temp := (9 * temperature + (32 * 5)) / 9;
    end if;
    return result_temp;
end;

$$ language plpgsql;

select convert_temp(80);

create or replace function fibonachi(n int) returns int as
$$
declare
    counter int := 0;
    i       int := 0;
    j       int := 1;

begin
    if n < 0 then
        return 0;
    end if;

    while counter <= n
        loop
            counter := counter + 1;
            select j, i + j into i, j;
        end loop;
    return i;

end;
$$ language plpgsql;


select fibonachi(20);

do
$$
    begin
        for counter in 1..50 by 2
            loop
                raise notice 'counter: %', counter;
            end loop;
    end
$$;

create or replace function return_ints() returns setof int as
$$
begin
    return next 1;
    return next 2;
    return next 3;
end;
$$ LANGUAGE plpgsql;

select return_ints();

create or replace function after_chrismas_sale() returns setof products as
$$
declare
    product record;
begin
    for product in select * from products
        loop
            if product.category_id in (1, 4, 8) then
                product.unit_price := product.unit_price * 0.8;
            elseif product.category_id in (2, 3, 7) then
                product.unit_price := product.unit_price * 0.7;
            else
                product.unit_price := product.unit_price * 1.1;

            end if;
            return next product;
        end loop;

end;

$$ language plpgsql;

select *
from after_chrismas_sale();

create or replace function backup_customers() returns void as
$$
drop table if exists backuped_customers;
    --     select into backup_customers
--     from customers;

    create table backuped_customers as
    select *
    from customers;

    $$ language sql;

select backup_customers();

select *
from backuped_customers;

create or replace function get_avg_freight() returns float8 as
$$
select avg(freight)
from orders;

$$ language sql;

select *
from get_avg_freight();


create or replace function random_between(low int, high int) returns int as
$$
begin
    return floor(random() * (high - low + 1) + low);
end;

$$ language plpgsql;

select random_between(1, 3)
from generate_series(1, 5);

create or replace function get_salary_boundaries_by_city(emp_city varchar, out min_salary numeric, max_salary numeric) as
$$
select min(salary), max(salary)
from employees
where city = emp_city;


$$ language sql;

alter table employees
    add
        column salary numeric;
update employees
set salary = floor(random_between(1, 100));

select concat(last_name, ' ', first_name), salary
from employees
order by salary desc;
------------------------------------

drop function if exists correct_salary(upper_boundary numeric, correction_rate numeric);
create or replace function correct_salary(upper_boundary numeric default 85, correction_rate numeric default 0.15)
    returns table
            (
                last_name  text,
                first_name text,
                title      text,
                salary     numeric
            )
as
$$
update employees
set salary = salary + (salary * correction_rate)
where salary <= upper_boundary
returning last_name, first_name, title, salary;


$$ language sql;

select correct_salary();
select salary
from employees
order by salary;
---------------------------------

create or replace function get_orders_by_shipping(ship_method int) returns setof orders as
$$
DECLARE
    average numeric;
    maximum numeric;
    middle  numeric;

begin
    select max(freight)
    into maximum
    from orders
    where ship_via = ship_method;

    maximum := maximum - (maximum * 0.3);

    select avg(freight)
    into average
    from orders
    where ship_via = ship_method;

    middle := (maximum + average) / 2;

    return query select *
                 from orders
                 where freight < middle;


end;

$$ LANGUAGE plpgsql;

select count(*)
from get_orders_by_shipping(1);
---------------------------------

create or replace function should_increase_salary(cur_salary numeric, max_salary numeric default 80,
                                                  min_salary numeric default 30,
                                                  increase_rate numeric default 0.2) returns bool as
$$
declare
    new_salary numeric;

begin

    if cur_salary >= max_salary or cur_salary >= min_salary
    then
        return false;
    end if;

    if cur_salary < min_salary then
        new_salary := cur_salary + (cur_salary * increase_rate);
    end if;
    if new_salary > max_salary then
        return false;
    else
        return true;
    end if;

end;
$$ language plpgsql;

select should_increase_salary(40, 80,30,0.2);
select should_increase_salary(79, 81,80,0.2);
select should_increase_salary(20, 80,30,0.2);


