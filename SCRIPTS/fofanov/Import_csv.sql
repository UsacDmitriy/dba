drop table patients;

create table patients
(
    patient_id       int primary key,
    sex              text,
    birth_year       int,
    country          text,
    region           text,
    desease          text,
    patient_group            text,
    infection_reason text,
    infection_order  int,
    infected_by      int,
    contact_number  int,
    confirmed_date   date,
    released_date    date,
    deceased_date    date,
    state            text
);

select birth_year, count(*)
from patients
where deceased_date is not null
group by birth_year
order by birth_year desc ;
