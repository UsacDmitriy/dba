create table new_test.student
(
    student_id serial,
    first_name varchar,
    last_name varchar,
    birthday date,
    phone varchar
);

create table new_test.cathedra
(
    cathedra_id serial,
    cathedra_name varchar,
    dean varchar
);

alter table  new_test.student
add column middle_name varchar;

alter table new_test.student
add column rating float;

alter table new_test.student
add column enrolled date;

alter table new_test.student
drop column middle_name;

alter table new_test.cathedra
rename to chair;

alter table new_test.chair
rename cathedra_id to chair_id;

alter table new_test.chair
rename cathedra_name to chair_name;

alter table new_test.student
alter column first_name set data type  varchar(64);
alter table new_test.student
alter column last_name set data type varchar(64);
alter table new_test.student
alter column phone set data type varchar(30);

create table new_test.faculty
(
    faculty_id serial,
    faculty_name varchar
);

insert into new_test.faculty (faculty_name)
values
('faculty_1'),
('faculty_2'),
('faculty_3');

select *
from new_test.faculty;

truncate table new_test.faculty restart identity ;


create table new_test.teacher
(
    teacher_id serial,
    first_name  varchar,
    last_name varchar,
    birthday date,
    phone varchar,
    title varchar
);

alter table new_test.teacher
add column middle_name varchar;

alter table new_test.teacher
drop column middle_name;

alter table new_test.teacher
rename birthday to birth_date;
alter table new_test.teacher
alter column phone set data type varchar(32);

create table new_test.exam
(
    exam_id serial,
    exam_name varchar(256),
    exam_date date
);

insert into new_test.exam (exam_name)
values 
('math'),
       ('culture'),
       ('science');

select *
from new_test.exam;

truncate table new_test.exam restart identity ;




