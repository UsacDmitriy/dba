select *, 'test case' as "test colomun"
from books;

select title, language_code, language_code = 'eng' as English_books
from books;

select title,
       num_pages,
       num_pages > 652 as more_than_653,
       average_rating,
       average_rating < 4
from books;

select max(total_volume),
       min(total_volume),
       avg(total_volume),
       count(total_volume)
from avocado_prices
where region='Albany' and total_volume is not null ;

select count(distinct region)
from avocado_prices;

select region,
       max(total_volume),
       min(total_volume),
       avg(total_volume),
       count(total_volume)
from avocado_prices
group by region
order by region;