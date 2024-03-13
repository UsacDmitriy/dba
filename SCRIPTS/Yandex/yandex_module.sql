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
having SUM(i.total) >1;

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
having SUM(i.total) >1;

select *
from client_activity
where invoice_month
          = '2021-05-01 00:00:00.000000';




INSERT INTO invoice (customer_id, invoice_date, total)
VALUES (9, DATE '2021-05-01', 2);

REFRESH MATERIALIZED VIEW client_activity;

select * from
information_schema.columns

order by table_name;