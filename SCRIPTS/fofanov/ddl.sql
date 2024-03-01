create table chair
(
    chair_id   serial primary key,
    chair_name varchar,
    dean       varchar
);

insert into chair
values (1, 'math', 'dean'),
       (2, 'cul', 'dean2');

select *
from chair;

drop table chair;

create table chair
(
    chair_id   serial UNIQUE not null,
    chair_name varchar,
    dean       varchar
);

select constraint_name
from information_schema.key_column_usage
where column_name = 'chair_id';

drop table publisher;
drop table book_author;
drop table book;

create table publisher
(
    publisher_id   int,
    publisher_name varchar(128) not null,
    address        text,

    constraint pk_publisher_publisher_id primary key (publisher_id),
    constraint fk_books_publisher foreign key (publisher_id) references publisher (publisher_id)
);

create table book
(
    book_id      int,
    title        text        not null,
    isbn         varchar(32) not null,
    publisher_id int,

    constraint pk_book_book_id primary key (book_id)
);

alter table book
    add constraint fk_books_publisher foreign key (publisher_id) references publisher (publisher_id);

drop table if exists book;

create table book
(
    book_id      int,
    title        text        not null,
    isbn         varchar(32) not null,
    publisher_id int,

    constraint pk_book_book_id primary key (book_id)
);

alter table book
    add column price decimal
        constraint CHK_book_price check ( price >= 0 );

insert into book
values (1, 'title', 'isbn', 1, 100);

create table customer
(
    customer_id serial,
    full_name   text,
    status      char default 'r',
    constraint pk_customer_customer_id primary key (customer_id),
    constraint chk_customer_status check ( status in ('p', 'r'))
);

insert into customer (full_name)
values ('John');

select *
from customer;


alter table customer
    alter column status drop default;

alter table customer
    alter column status set default 'r';

create sequence seq1;

select nextval('seq1');
select currval('seq1');
select lastval();

select setval('seq1', 16, true);

select currval('seq1');
select nextval('seq1');


create sequence if not exists seq2 increment 16;
select nextval('seq2');

create sequence if not exists seq3
increment 16
minvalue 0
maxvalue 128
start with 0;

select nextval('seq3');

drop sequence seq4;

drop table if exists book;
create table book
(
    book_id      serial ,
    title        text        not null,
    isbn         varchar(32) not null,
    publisher_id int not null ,

    constraint pk_book_book_id primary key (book_id)
);

select
       *
from book;

create sequence if not exists book_book_id_seq
start with 1 owned by book.book_id;

insert into book(title, isbn, publisher_id)
values ('title', 'isbn', 1);

alter table book
alter column book_id set default nextval('book_book_id_seq');

drop table book;

create table book
(
    book_id      int generated always as identity not null ,
    title        text        not null,
    isbn         varchar(32) not null,
    publisher_id int not null ,

    constraint pk_book_book_id primary key (book_id)
);

insert into book(title, isbn, publisher_id)
overriding system value 
values ('title', 'isbn', 1);

insert into author
values
        (7,'Name 1', 3.4),
       (4, 'Name 2', 4),
       (5, 'Name 3', 4),
       (6, 'Name 4', 4);

select *
from author;

select *
into best_authors
from author
where rating > 4;

select *
from best_authors;

insert into best_authors
select * from author
where rating <4.6;


select * from author;

update author
set full_name = 'Alias', rating = 5
where author_id = 3;


delete from author
where author_id=6;

drop table book;


create table book
(
    book_id      int generated always as identity not null ,
    title        text        not null,
    isbn         varchar(32) not null,
    publisher_id int not null ,

    constraint pk_book_book_id primary key (book_id)
);


insert into book (title, isbn, publisher_id)
values ('title', 'isbn', 3)
returning book_id, title, isbn, publisher_id;


create table exam
(
    exam_id serial unique not null ,
    exam_name varchar,
    exam_date date
);

alter table exam
drop constraint exam_exam_id_key;

alter table exam
add primary key (exam_id);

create table person
(
    person_id int not null,
    first_name varchar not null ,
    last_name varchar not null,

    constraint pk_person_person_id primary key (person_id)
);

create table passport
(
    passport_id int,
    serial_number int not null ,
    registration text  not null,
    person_id int not null ,

    constraint pk_passport_passport_id primary key (passport_id),
    constraint fk_passport_person foreign key (person_id) references person(person_id)
);


alter table book
add column weight decimal constraint chk_book_weight check ( weight > 0 and weight < 100 );


alter table products
add constraint chk_products_price check ( unit_price > 0 );

create table student
(
    student_id serial,
    full_name varchar,
    grade int default 1
);

alter table student
alter  column grade drop default ;

select max(product_id) from products;

create sequence if not exists products_product_id_seq
start with 78 owned by products.product_id;

alter table products
alter column product_id set default nextval('products_product_id_seq');



