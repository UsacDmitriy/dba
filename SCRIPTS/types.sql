create or replace function type_testing(money_val float8) returns void as
$$
    begin
        raise notice 'ran %', money_val;
    end;
    $$ language plpgsql;

select type_testing(0.5);
select type_testing(0.5::float4);
select type_testing(1);


create or replace function type_testing2(money_val int) returns void as
$$
    begin
        raise notice 'ran %', money_val;
    end;
    $$ language plpgsql;

select type_testing2(2);
select type_testing2(0.5);
select type_testing2(0.5::int);
select  type_testing2(0.4::int);
select type_testing2(cast(0.5 as int));

select 50! as big_factorial;


select cast(50 as bigint)! as big_factorial;

select 'abc' || 1;

select '10' = 10;