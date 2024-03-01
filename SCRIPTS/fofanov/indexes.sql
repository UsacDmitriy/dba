select amname from pg_am;

drop table perf_test;

create table perf_test(
    id int,
    reason text collate "C",
    annotation text collate "C"
);


-- Генерация случайных данных в таблицу
insert into perf_test (id, reason, annotation)
select s.id, md5(random()::text), null
from generate_series(1, 10000000) as s(id)
order by random();

update perf_test
set annotation  = upper(md5(random()::text));

explain
select * from perf_test
where id =78788;

create index idx_perf_test_id on perf_test(id);

explain
select * from perf_test
where reason like 'bc%' and annotation like 'AB%';


analyze perf_test;

create index idx_perf_test_reason_annotation on perf_test(reason, annotation);

explain
select * from perf_test
where reason like 'bc%';

explain
select *
from perf_test
where annotation like 'AB%';

create index idx_perf_test_annotation on perf_test(annotation);

explain
select *from perf_test where lower(annotation) like ('ab%');

create index idx_perf_test_annotation_lower on perf_test(lower(annotation));


-- Сложные индексы
explain
select * from perf_test
where reason like '%cde%';

create extension pg_trgm;

create index trgm_idx_perf_test_reason on perf_test using gin (reason gin_trgm_ops);



