SELECT c.table_schema,
       c.table_name,
       c.column_name,
       pgd.description
FROM pg_catalog.pg_statio_all_tables AS st
         INNER JOIN pg_catalog.pg_description pgd ON (pgd.objoid = st.relid)
         INNER JOIN information_schema.columns c ON (pgd.objsubid = c.ordinal_position
    AND c.table_schema = st.schemaname AND c.table_name = st.relname);

select id, client_id, utm_campaign
from user_attributes
limit 100;

select id, client_id, hitdatetime, action, payment_amount
from user_payment_log;

select client_id, hitdatetime, action
from user_activity_log
limit 100;

SELECT tc.table_name,
       kcu.column_name,
       ccu.table_name  AS foreign_table_name,
       ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
         JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
                  AND tc.table_schema = kcu.table_schema
         JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
                  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY';

select *
from user_attributes
         join user_activity_log ual using (client_id)
limit 100;

select *
from user_attributes
         inner join user_payment_log upl on user_attributes.client_id = upl.client_id
limit 100;

select client_id,
       case
           when action = 'visit' then hitdatetime
           else null
           end as visit_dt,
       case
           when action = 'registration' then 1
           else 0
           end as is_registration
from user_activity_log
limit 10;



select *

from user_activity_log
order by client_id
limit 10;



select client_id,
       case
           when action = 'visit' then hitdatetime
           else null
           end as fst_visit_dt


from user_activity_log
group by client_id
;

SELECT client_id,
       MIN(hitdatetime)                                            AS fst_visit_dt,
       MIN(CASE WHEN action = 'registration' THEN hitdatetime END) AS registration_dt,
       MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)    AS is_registration
FROM public.user_activity_log
GROUP BY client_id
ORDER BY client_id
LIMIT 10;


SELECT client_id,
       DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
       DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
       MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
FROM user_activity_log
GROUP BY client_id
LIMIT 10;

select ua.client_id,
       ua.utm_campaign,
       ual.fst_visit_dt,
       ual.registration_dt,
       ual.is_registration,
       upl.total_payment_amount
from user_attributes ua
         join (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
) as ual using (client_id)
         join (
    select client_id,
           sum(payment_amount) as total_payment_amount
    from user_payment_log
    group by client_id
) as upl on ua.client_id = upl.client_id;


with ual as (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),
     upl as (
         select client_id,
                sum(payment_amount) as total_payment_amount
         from user_payment_log
         group by client_id
     )
select ua.client_id,
       ua.utm_campaign,
       ual.fst_visit_dt,
       ual.registration_dt,
       ual.is_registration,
       upl.total_payment_amount
from user_attributes as ua
         join ual using (client_id)
         join upl using (client_id);

CREATE VIEW my_view AS
SELECT customer_id, total
FROM invoice;
CREATE MATERIALIZED VIEW my_other_view AS
SELECT customer_id, total
FROM invoice;

REFRESH MATERIALIZED VIEW my_other_view;

DROP VIEW IF EXISTS my_view;

DROP MATERIALIZED VIEW IF EXISTS my_other_view;


WITH i AS (
    SELECT customer_id,
           DATE_TRUNC('month', CAST(invoice_date AS timestamp)) AS invoice_month,
           total
    FROM invoice
)
SELECT i.customer_id,
       client.company IS NOT NULL AS is_from_company,
       i.invoice_month,
       COUNT(i.total),
       SUM(i.total)
FROM i
         LEFT JOIN client
                   ON i.customer_id = client.customer_id
GROUP BY i.customer_id, i.invoice_month, client.company;

DROP VIEW IF EXISTS client_activity;

create or replace view client_activity as

WITH i AS (
    SELECT customer_id,
           DATE_TRUNC('month', CAST(invoice_date AS timestamp)) AS invoice_month,
           total
    FROM invoice
)
SELECT i.customer_id,
       client.company IS NOT NULL AS is_from_company,
       i.invoice_month,
       COUNT(i.total),
       SUM(i.total)
FROM i
         LEFT JOIN client
                   ON i.customer_id = client.customer_id
GROUP BY i.customer_id, i.invoice_month, client.company
having SUM(i.total) > 1;

select *
from client_activity
where invoice_month
          = '2021-06-01 00:00:00.000000';

INSERT INTO invoice (customer_id, invoice_date, total)
VALUES (9, DATE '2021-06-01', 2);


select *
from client_activity
where invoice_month
          = '2021-06-01 00:00:00.000000';

DROP VIEW IF EXISTS client_activity;
create materialized view client_activity as


WITH i AS (
    SELECT customer_id,
           DATE_TRUNC('month', CAST(invoice_date AS timestamp)) AS invoice_month,
           total
    FROM invoice
)
SELECT i.customer_id,
       client.company IS NOT NULL AS is_from_company,
       i.invoice_month,
       COUNT(i.total),
       SUM(i.total)
FROM i
         LEFT JOIN client
                   ON i.customer_id = client.customer_id
GROUP BY i.customer_id, i.invoice_month, client.company
having SUM(i.total) > 1;

select *
from client_activity
where invoice_month
          = '2021-05-01 00:00:00.000000';



INSERT INTO invoice (customer_id, invoice_date, total)
VALUES (9, DATE '2021-05-01', 2);

REFRESH MATERIALIZED VIEW client_activity;

select *
from information_schema.columns

order by table_name;

SELECT table_name,
       (SELECT count(1) from user_payment_log)
FROM INFORMATION_SCHEMA.TABLES
where table_name = 'user_payment_log'
UNION ALL
SELECT table_name,
       (SELECT count(1) from user_activity_log)
FROM INFORMATION_SCHEMA.TABLES
where table_name = 'user_activity_log'
UNION ALL
SELECT table_name,
       (SELECT count(1) from user_attributes)
FROM INFORMATION_SCHEMA.TABLES
WHERE table_name = 'user_attributes';

select count(distinct client_id), count(distinct utm_campaign)
from user_attributes;

select *
from user_activity_log;

select client_id, coalesce(utm_campaign, 'N/A')
from user_attributes
limit 20;

drop table if exists source_systems;
create
    table source_systems
(
    id   int primary key,
    code char(3),
    name varchar(100),
    desc varchar(255)
);

insert into source_systems
values ('001', 'Moscow CRM', 'Система по работе с клиентами в офисе в Москве'),
       ('002', 'SPB CRM', 'Система по работе с клиентами в офисе в Санкт-Петербурге'),
       ('003', 'Online shop', 'Онлайн-магазин компании');

select client_id, client_firstname, client_lastname, client_email
from "002_DM_clients"
-- where (client_id is null) or (client_firstname is  null) or (client_lastname is null) or  (client_email is null);

select *
from "002_BUFF_clients";

-- Добавление поля age в таблицу 002_DM_clients

ALTER TABLE "002_DM_clients"
    ADD age INT;

-- Заполнение поля age значениями из таблицы 002_BUFF_clients

UPDATE "002_DM_clients"
SET age = b.age
FROM "002_BUFF_clients" b
WHERE "002_DM_clients".client_id = b.client_id;

-- добавьте код сюда
create materialized view user_activity_payment_datamart as
WITH ual AS (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),

     upl AS (
         SELECT client_id,
                SUM(payment_amount) AS total_payment_amount
         FROM user_payment_log
         GROUP BY client_id
     )
SELECT ua.client_id,
       ua.utm_campaign,
       ual.fst_visit_dt,
       ual.registration_dt,
       ual.is_registration,
       upl.total_payment_amount
FROM user_attributes AS ua
         LEFT JOIN ual ON ua.client_id = ual.client_id
         LEFT JOIN upl ON ua.client_id = upl.client_id;

with ual as (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),
     upl as (
         select client_id,
                sum(payment_amount) as total_payment_amount
         from user_payment_log
         group by client_id
     )
select ua.client_id,
       ua.utm_campaign,
       ual.fst_visit_dt,
       ual.registration_dt,
       ual.is_registration,
       upl.total_payment_amount,
       dm.client_firstname
from user_attributes as ua
         join ual using (client_id)
         join upl using (client_id)
         join "002_DM_clients" AS dm using (client_id)
;


ALTER TABLE "002_DM_clients"
    ADD age INT;

-- Заполнение поля age значениями из таблицы 002_BUFF_clients

UPDATE "002_DM_clients"
SET age =
    b.age
FROM "002_BUFF_clients" b
WHERE "002_DM_clients".client_id = b.client_id;

with ual as (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),
     upl as (
         select client_id,
                sum(payment_amount) as total_payment_amount
         from user_payment_log
         group by client_id
     )
select

       case
           when dm.age between 18 and 24 then '18-25'
           when dm.age between 26 and 30  then '26-30'
           when dm.age between 31 and 40  then '31-40'
           when dm.age between 41 and 55 then '41-55'
           when dm.age > 55  then '55+'
           else 'n/a'
           end as age_groups,
       sum(upl.total_payment_amount)
from user_attributes as ua
         join ual using (client_id)
         join upl using (client_id)
         join "002_DM_clients" AS dm using (client_id)
group by age_groups
order by   age_groups desc ;



select

       case
           when "002Dc".age between 18 and 25 then '18-25'
           when "002Dc".age between 26 and 30  then '26-30'
           when "002Dc".age between 31 and 40  then '31-40'
           when "002Dc".age between 41 and 55 then '41-55'
           when "002Dc".age > 55  then '55+'
           else 'n/a'
           end as age_groups,
       sum(ul.payment_amount)
from user_payment_log ul
join "002_DM_clients" "002Dc" on ul.client_id = "002Dc".client_id
group by age_groups;


with ual as (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),
     upl as (
         select client_id,
                sum(payment_amount) as total_payment_amount
         from user_payment_log
         group by client_id
     )
select ua.client_id,
       ua.utm_campaign,
       ual.fst_visit_dt,
       ual.registration_dt,
       ual.is_registration,
       upl.total_payment_amount,
       dm.age
from user_attributes as ua
         join ual using (client_id)
         join upl using (client_id)
         join "002_DM_clients" AS dm using (client_id);


DROP MATERIALIZED VIEW IF EXISTS user_activity_payment_datamart;


CREATE MATERIALIZED VIEW user_activity_payment_datamart AS
with ual as (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),
     upl as (
         select client_id,
                sum(payment_amount) as total_payment_amount
         from user_payment_log
         group by client_id
     )
select ua.client_id,
       ua.utm_campaign,
       ual.fst_visit_dt,
       ual.registration_dt,
       ual.is_registration,
       upl.total_payment_amount,
       dm.age
from user_attributes as ua
         join ual using (client_id)
         join upl using (client_id)
         join "002_DM_clients" AS dm using (client_id);

select *
from user_activity_payment_datamart;
refresh materialized view user_activity_payment_datamart;

DROP MATERIALIZED VIEW IF EXISTS user_activity_payment_datamart;

create materialized view user_activity_payment_datamart as
WITH ual AS (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),

     upl AS (
         SELECT client_id,
                SUM(payment_amount) AS total_payment_amount
         FROM user_payment_log
         GROUP BY client_id
     )
SELECT ua.client_id,
       ua.utm_campaign,
       ual.fst_visit_dt,
       ual.registration_dt,
       ual.is_registration,
       upl.total_payment_amount,
       "002Dc".age
FROM user_attributes AS ua
         LEFT JOIN ual ON ua.client_id = ual.client_id
         LEFT JOIN upl ON ua.client_id = upl.client_id
            left join "002_DM_clients" "002Dc" on ua.client_id = "002Dc".client_id;


with ual as (
    SELECT client_id,
           DATE(MIN(CASE WHEN action = 'visit' THEN hitdatetime ELSE NULL END))        AS fst_visit_dt,
           DATE(MIN(CASE WHEN action = 'registration' THEN hitdatetime ELSE NULL END)) AS registration_dt,
           MAX(CASE WHEN action = 'registration' THEN 1 ELSE 0 END)                    AS is_registration
    FROM user_activity_log
    GROUP BY client_id
),
     upl as (
         select client_id,
                sum(payment_amount) as total_payment_amount
         from user_payment_log
         group by client_id
     )
select

       case
           when dm.age < 26 then '18-25'
           when dm.age between 26 and 30  then '26-30'
           when dm.age between 31 and 40  then '31-40'
           when dm.age between 41 and 55 then '41-55'
           when dm.age > 55  then '55+'
           else 'n/a'
           end as age_groups,
       sum(upl.total_payment_amount)
from user_attributes as ua
         left join ual using (client_id)
         left join upl using (client_id)
         left join "002_DM_clients" AS dm using (client_id)

group by age_groups
having sum(upl.total_payment_amount) is not null
order by   age_groups desc ;

select *
from user_activity_payment_datamart
;

refresh materialized view user_activity_payment_datamart