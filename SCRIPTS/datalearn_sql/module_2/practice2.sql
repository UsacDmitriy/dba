select *
from premium_users pu
         join plans p on pu.membership_plan_id = p.id
;

select user_id, play_date, title
from plays p
         join songs s on s.id = p.song_id;

select *
from users
         left join premium_users pu on users.id = pu.user_id
where user_id is not null;


with january as
         (select *
          from plays
          where extract(month from play_date) = 1),

     february as (select *
                  from plays
                  where extract(month from play_date) = 2)

select count(*)
from january as j
         left join february as f on j.user_id = f.user_id
where f.user_id is null;

select pu.user_id, pu.purchase_date::date, pu.cancel_date::date, m.months::date
from months m
         cross join premium_users pu;

select pu.user_id, pu.purchase_date::date, pu.cancel_date::date, m.months::date
from months m
         cross join premium_users pu;

select *
from songs
union
select *
from bonus_songs
limit 10;

with play_count as (select song_id, count(*)
                    from plays
                    group by song_id)
select *
from play_count pc
         join songs s on pc.song_id = s.id;

-- metropolitan museum

select *
from met;

select distinct category
from met
where title ilike '%cel%';

select date, title, medium
from met;

select category,
       count(*)
from met
group by category
having count(*) > 100;

select *
from vr_startup.employees;
select *
from projects;

select first_name, last_name
from employees
where current_project is null;

select *
from projects
where project_id not in
      (
          select current_project
          from vr_startup.employees
          where current_project is not null
      );

select p.project_name,
       count(e.employee_id)
from projects p
join vr_startup.employees e on p.project_id = e.current_project
group by p.project_name
order by count(e.employee_id) desc;

select *
from projects;


















