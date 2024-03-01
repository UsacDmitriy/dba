create domain text_no_space_null as text not null check ( value ~ '^(?!\s*$).+');

create table agent
(
    first_name text_no_space_null,
    last_name  text_no_space_null

);

insert into agent
values ('bob', 'taylor');

select *
from agent;
insert into agent
values ('', 'taylor');

insert into agent
values ('   ', 'taylor');

insert into agent
values (null, 'taylor');

drop table agent;
drop domain text_no_space_null;

create domain text_no_space_null as text not null check ( value ~ '^(?!\s*$).+');
alter domain text_no_space_null add constraint text_no_space_null_length32 check ( length(value) < 32 ) not valid;

-- Составные типы

create type price_bounds as
(
    max_price real,
    min_price real
);

create type complex as
(
    r float8,
    i float8
);

create table math_calcs
(
    math_id serial,
    val     complex
);

insert into math_calcs(val)
values (row (3.0, 4.0)),
       (row (2.0, 1.0));

select (val).r
from math_calcs;

select (val).*
from math_calcs;

update math_calcs
set val = row (6.9, 9.7)
where math_id = 1;

select *
from math_calcs;

-- enumiration

create table chess_title
(
    title_id serial primary key,
    title    text
);

create table chess_player
(
    player_id  serial primary key,
    first_name text,
    last_name  text,
    title_id   int references chess_title (title_id)
);

insert into chess_title(title)
values ('Candidate'),
       ('FIDE master'),
       ('Grand master'),
       ('Super master');

insert into chess_player (first_name, last_name, title_id)
values ('wesley', 'so', 4),
       ('vlad', 'kramnik', 4),
       ('vasiliy', 'pupkin', 1);

select *
from chess_player
         join chess_title ct on ct.title_id = chess_player.title_id;

drop table chess_title cascade;

drop table chess_player;

create type chess_title as enum
    ('Candidate',
        'FIDE master',
        'Grand master');

select enum_range(null::chess_title);

alter type chess_title add value 'Super Master' after 'Grand master';

create table chess_player
(
    player_id  serial primary key,
    first_name text,
    last_name  text,
    title      chess_title
);

insert into chess_player (first_name, last_name, title)
values ('wesley', 'so', 'Super Master'),
       ('vlad', 'kramnik', 'FIDE master'),
       ('vasiliy', 'pupkin', 'Candidate');

select *
from chess_player;



