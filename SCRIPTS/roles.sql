create role sales_staff;
create role northwind_admins;

create user john_smith with password 'qwerty';
create user north_admin1 with password 'qwerty';

revoke create on schema public from public;
revoke all on database test from public;

grant connect on database test to sales_staff;
grant connect on database test to northwind_admins;

grant usage on schema public to sales_staff;

grant usage on schema public to northwind_admins;
grant create on schema public to northwind_admins;
grant create on database test to northwind_admins;

grant sales_staff to john_smith;
grant northwind_admins to north_admin1;

select grantee, privilege_type
from information_schema.role_table_grants
where table_name = 'orders';

grant select, insert, update, delete on table public.orders, order_details, products to sales_staff;

grant select, insert, update, delete, references, trigger on ALL TABLES IN SCHEMA public
    to northwind_admins;
