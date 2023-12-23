
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

insert into daily_activity (category,subcategory,start_time) values
('test1','subtest0','2023-12-20 12:34:56'),
('test1','subtest1','2023-12-20 12:34:56'),
('test1','subtest2','2023-12-20 12:34:56'),
('test1','subtest3','2023-12-20 13:34:56'),
('test1','subtest4','2023-12-20 13:34:56'),
('test1','subtest5','2023-12-20 13:34:56'),
('test1','subtest6','2023-12-20 13:34:56'),
('test1','subtest7','2023-12-20 14:34:56'),
('test1','subtest8','2023-12-20 14:34:56'),
('test1','subtest9','2023-12-20 14:34:56')
;

select * from daily_activity;


