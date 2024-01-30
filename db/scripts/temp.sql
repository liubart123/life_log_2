
SELECT * FROM daily_activity 
where start_time 
order by start_time desc, id desc limit 10;


DECLARE
    new_id int;
call upsert_daily_activity(15, 'e', 'example_subcategory', '2023-01-01 12:23:34', '7380000123 microseconds', '{"key": "value"}');
call upsert_daily_activity(null, 'e', 'example_subcategory', '2023-01-01 12:23:34', '2 hours 3 millisecond', '{"key": "value"}');
call upsert_daily_activity(12, 'e', 'example_subcategory', '2023-01-01 12:23:34', '12:34:00', '{"key": "value"}');
call delete_daily_activity(2);
select * from select_daily_activity(89);
select * from select_daily_activity();

select * from daily_activity order by id desc;

select * from select_daily_activity();
select * from select_daily_activity('2023-12-20 13:34:58', 12);

truncate daily_activity ;

select * from daily_activity order by id desc;


