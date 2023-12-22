drop table if exists daily_activity cascade;

create table daily_activity(
	id serial primary key,
	category varchar(255) not null,
	subcategory varchar(255) not null,
	start_time timestamptz not null,
	duration interval not null,
	attrs jsonb not null
);

CREATE OR REPLACE procedure upsert_daily_activity(
	inout p_id int,
    p_category VARCHAR(255),
    p_subcategory VARCHAR(255),
    p_start_time TIMESTAMPTZ,
    p_duration INTERVAL,
    p_attrs JSONB
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF p_id IS NULL THEN
	    INSERT INTO daily_activity(category, subcategory, start_time, duration, attrs)
	    VALUES (p_category, p_subcategory, p_start_time, p_duration, p_attrs)
		RETURNING id INTO p_id;
	ELSE
	    INSERT INTO daily_activity(id, category, subcategory, start_time, duration, attrs)
	    VALUES (p_id, p_category, p_subcategory, p_start_time, p_duration, p_attrs)
	    ON CONFLICT (id)
	    DO UPDATE set
	    	category = excluded.category,
	    	subcategory = excluded.subcategory,
	    	start_time = excluded.start_time,
	        duration = EXCLUDED.duration,
	        attrs = EXCLUDED.attrs;
	end if;
end;
$$;

CREATE OR REPLACE procedure delete_daily_activity(
	p_id int
)
LANGUAGE plpgsql
AS $$
BEGIN
	delete from daily_activity where id = p_id;
END;
$$;

create or replace FUNCTION select_daily_activity(p_id int) 
RETURNS SETOF daily_activity AS 
$$ 
	SELECT * FROM daily_activity WHERE id = p_id limit 1;
$$ LANGUAGE SQL;

create or replace FUNCTION select_daily_activity() 
RETURNS SETOF daily_activity AS 
$$ 
	SELECT * FROM daily_activity order by start_time desc, id desc limit 10;
$$ LANGUAGE SQL;

create or replace FUNCTION select_daily_activity(last_start_time timestamp, last_id int) 
RETURNS SETOF daily_activity AS 
$$ 
	SELECT * FROM daily_activity 
	where start_time < last_start_time or (start_time = last_start_time and id < last_id)
	order by start_time desc, id desc limit 10;
$$ LANGUAGE SQL;
