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
    return sum(units_in_stock)
        from products;
end;
$$ language plpgsql;


select get_total_number_of_goods();

create or replace function get_price_boundaries_by_discontinued() returns real as
$$
begin
    return max(unit_price)
        from products
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

select * from middle_price_with_options();


create or replace function convert_temp(temperature real, to_celsius bool default true) returns real as
    $$
    declare
        result_temp real;
    begin
        if to_celsius then
            result_temp := (5.9/9.0)*(temperature-32);
            else
            result_temp := (9*temperature + (32*5))/9;
        end if;
        return  result_temp;
    end;

    $$ language plpgsql;

select convert_temp(80);









