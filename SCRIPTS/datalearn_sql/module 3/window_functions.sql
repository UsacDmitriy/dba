select *
from salary
;

select department,
       max(gross_salary)
from salary
group by department;

select id,
       first_name,
       department,
       max(gross_salary)
from salary
group by id, first_name, department;


-- с помощью join
select s.id,
       s.first_name,
       s.department,
       max_s.max_salary
from salary s
         join (select department,
                      max(gross_salary) as max_salary
               from salary s
               group by s.department) max_s on max_s.department = s.department
    and max_s.max_salary = s.gross_salary;

-- с помощью окошек
select s.id,
       s.first_name,
       s.department,
       s.gross_salary,
       max(s.gross_salary) over (partition by s.department) as max_gross_salary
from salary s;
--
select *
from (select s.id,
             s.first_name,
             s.department,
             s.gross_salary,
             max(s.gross_salary) over (partition by s.department) as max_gross_salary
      from salary s) as max_s
where max_s.max_gross_salary = max_s.gross_salary
order by max_s.id;

-- показать пропорцию зарплат
with gross_by_department as (select s.department,
                                    sum(gross_salary) as department_gross_salary
                             from salary s
                             group by s.department)

select s.id,
       s.first_name,
       s.department,
       s.gross_salary,
       round((s.gross_salary::numeric / gbd.department_gross_salary) * 100, 2)                as department_ratio,
       round((s.gross_salary::numeric / (select sum(s.gross_salary) from salary s)) * 100, 2) as total_ratio
from salary s
         join gross_by_department as gbd using (department)
order by s.department,
         department_ratio desc;
-- решение с помощью оконок
select s.id,
       s.first_name,
       s.department,
       s.gross_salary,
       round(((s.gross_salary::numeric / sum(s.gross_salary) over (partition by department)) * 100),
             2)                                                                  as department_ratio,
       round(((s.gross_salary::numeric / sum(s.gross_salary) over ()) * 100), 2) as total_ratio
from salary s

order by s.department,
         department_ratio desc;

-- вывести имя сотрудника у которого самая высокая зп

select s.id,
       s.first_name,
       s.department,
       s.gross_salary,
       first_value(s.first_name) over (partition by department order by gross_salary desc) as highest_paid_employee

from salary s;

-- вывести имя сотрудника у которого самая низкая зп

select s.id,
       s.first_name,
       s.department,
       s.gross_salary,
       last_value(s.first_name)
       over (partition by department order by s.gross_salary desc rows between unbounded preceding and unbounded following) as lowest_paid_employee

from salary s;


-- вывести лданные о приросте последователенй для аккаунта instagram

select username,
       sum(change_in_followers)
from social_media
where username = 'instagram'
group by username;

--   с помощью окошек
select username,
       change_in_followers,
       sum(change_in_followers) over (order by change_in_followers asc) as running_total
from social_media
where username = 'instagram';

-- c партициями
select username,
       month,
       change_in_followers,
       sum(change_in_followers) over (partition by username order by month asc) as running_total,
       avg(change_in_followers) over (partition by username order by month asc) as running_avg
from social_media;

-- с first_value

select username,
       month,
       posts,
       first_value(posts) over (partition by username order by posts desc ) as most_months
from social_media;

-- с last_value

select username,
       month,
       posts,
       last_value(posts) over (partition by username order by posts ) as most_months
from social_media;

-- LEAD and LAG

select *
from streams;

select artist,
       week,
       streams_millions,
       lag(streams_millions::text, 2, 'нет значений') over (order by week asc) as previous_week
from streams
where artist = 'Lady Gaga';

select artist,
       week,
       streams_millions,
       streams_millions - lag(streams_millions, 1, streams_millions) over (order by week asc) as change_week
from streams
where artist = 'Lady Gaga';


-- изменения по всем артистам
select artist,
       week,
       streams_millions,

       streams_millions -
       lag(streams_millions, 1, streams_millions) over (partition by artist order by week asc) as change_week,
       chart_position,
       lag(chart_position, 1, chart_position) over (partition by artist order by week asc) -
       chart_position                                                                          as chart_change

from streams;


select artist,
       week,
       streams_millions,
       lead(streams_millions, 1, streams_millions) over (partition by artist order by week asc) -
       streams.streams_millions as change_week,
       chart_position,
       chart_position - lead(chart_position, 1, chart_position) over (partition by artist order by week asc)
                                as chart_change

from streams;

-- row number

with our_rows as (select artist,
                         week,
                         streams_millions,
                         row_number() over (order by streams_millions asc) as row_num
                  from streams)

select *
from our_rows
where row_num = 30;

-- rank
select artist,
       week,
       streams_millions,
       rank() over (order by streams_millions asc)       as rank_number,
       dense_rank() over (order by streams_millions asc) as rank_number

from streams;

select artist,
       week,
       streams_millions,
       rank() over (partition by week order by streams_millions asc) as rank_number,
       dense_rank() over (partition by week
           order by streams_millions asc)                            as rank_number

from streams;

-- NTILE

select artist,
       week,
       streams_millions,
       ntile(5) over (order by streams_millions desc) as weekly_streams_group

from streams;

select artist,
       week,
       streams_millions,
       ntile(4) over (partition by week
           order by streams_millions desc) as weekly_streams_group

from streams;


select *
from state_climate;

-- изменение климата в каждм штате в течении времени

select state,
       year,
       tempf,
       avg(tempf) over (partition by state order by year) as running_far

from state_climate;

select state,
       year,
       tempf,
       first_value(tempf) over (partition by state order by tempf) as running_far

from state_climate;

select state,
       year,
       tempf,
       last_value(tempf)
       over (partition by state order by tempf range between unbounded preceding and unbounded following) as running_far

from state_climate;

select state,
       year,
       tempf,
       rank() over (order by tempf) as change_tmp

from state_climate;

select state,
       year,
       tempf,
       rank() over (partition by state order by tempf desc) as change_tmp

from state_climate;

select state,
       year,
       tempf,
       ntile(4) over (partition by state order by tempf) as quartile,
       ntile(5) over (partition by state order by tempf) as change_tmp
from state_climate;






