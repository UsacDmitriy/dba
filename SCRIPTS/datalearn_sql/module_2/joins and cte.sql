select distinct name
from babies
where name like 'S__o%';

select distinct name
from babies
where name ilike 's__o%';


select name,
       case
           when imdb_rating > 8 then 'recomended'
           else 'unrecomended'
           end as recomendation
from movies;

select current_timestamp, now();

show timezone;

select now(),
       extract(year from now());

select *
from drama_students;

select *
from band_students;


select bs.id, bs.first_name, bs.last_name
from band_students bs
         join drama_students ds on bs.id = ds.id;

select bs.id, bs.first_name, bs.last_name
from band_students bs
where bs.id in (select ds.id
                from drama_students ds);

select * from drama_students
where grade not in (select band_students.grade
                from band_students
where id =20
    );

select first_name, last_name
from band_students
where id not in (
    select id
    from drama_students
    );

select grade
from band_students
where exists (
    select drama_students.grade
    from drama_students
    );


with previous_query as (select customer_id, count(subscription_id) as subscritions
from orders
group by customer_id)
select customer_name, previous_query.subscritions, c.address
from previous_query
join customers c on previous_query.customer_id=c.customer_id
order by customer_name;