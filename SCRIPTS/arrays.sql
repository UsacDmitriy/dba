create table chess_game
(
    white_plyer  text,
    black_player text,
    moves        text[],
    final_state  text[][]
);

insert into chess_game
values ('Caruana', 'Nakamura', Array ['d4', 'd5', 'c4', 'c6' ], ARRAY [['Ra8', 'Qe8', 'x', 'x', 'x','x','x','x'],[
    'a7', 'x', 'x', 'x','x','x','x', 'x'
    ],[
    'Kb5', 'Bc5', 'd5','x', 'x', 'x','x','x'
    ]]);

select moves[2:3]
from chess_game;

select moves[:3]
from chess_game;

select moves[2:]
from chess_game;

select array_dims(moves), array_length(moves, 1)
from chess_game;

select *
from chess_game
where 'c6' = any (moves);


select array [1, 2, 3, 4] = array [1, 2, 3, 4];

select array [1, 2, 3, 4] @> array [1, 2, 5];

select array [1, 2, 3, 4] && array [1, 2];

select *
from chess_game
where moves && array ['d4'];

create or replace function filter_even(variadic numbers int[]) returns setof int as
$$
    declare
        counter int;
begin
--     for counter in 1..array_upper(numbers, 1)

     foreach counter in array  numbers
        loop
            continue when counter % 2 != 0;
            return next counter;
        end loop;
end;
$$ language plpgsql;

select * from
filter_even(1,2,3,4,5,6,7,8);


create or replace function get_avg_freight_by_countries3(variadic countries text[]) returns float8 as
    $$
    select avg(freight)
    from orders
    where ship_country = any(countries)

    $$ language sql;

select get_avg_freight_by_countries3(variadic array['USA', 'UK']);


create or replace function filter_by_operator(oper int, variadic numbers text[]) returns setof text as
    $$
    declare
        cur_val text;
        begin
        foreach cur_val in array numbers
        loop
            raise notice 'cur val is %', cur_val;
            continue when cur_val not like concat('__(', oper,')%');
            return next cur_val;
            end loop;
    end;
    $$ language plpgsql;

select *
from filter_by_operator(917, '+7(917)9725343');


