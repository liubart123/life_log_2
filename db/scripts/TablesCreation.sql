drop table if exists daily_activity;

create table daily_activity(
	id serial primary key,
	category varchar(255) not null,
	subcategory varchar(255) not null,
	start_time timestamp,
	duration interval,
	attrs jsonb
);

CREATE OR REPLACE procedure upsert_daily_activity(
	p_id int,
    p_category VARCHAR(255),
    p_subcategory VARCHAR(255),
    p_start_time TIMESTAMP,
    p_duration INTERVAL,
    p_attrs JSONB
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO daily_activity(id, category, subcategory, start_time, duration, attrs)
    VALUES (p_id, p_category, p_subcategory, p_start_time, p_duration, p_attrs)
    ON CONFLICT (id)
    DO UPDATE set
    	category = excluded.category,
    	subcategory = excluded.subcategory,
    	start_time = excluded.start_time,
        duration = EXCLUDED.duration,
        attrs = EXCLUDED.attrs;
END;
$$

CREATE OR REPLACE procedure delete_daily_activity(
	p_id int
)
LANGUAGE plpgsql
AS $$
BEGIN
	delete from daily_activity where id = p_id;
END;
$$

CREATE FUNCTION mytest(p_id int) 
RETURNS test AS 
$$ 
SELECT * FROM test WHERE id = p_id;
$$ LANGUAGE SQL;


call upsert_daily_activity(2, 'e', 'example_subcategory', '2023-01-01 12:00:00', '2 hours', '{"key": "value"}');
call delete_daily_activity(2);

select * from daily_activity;