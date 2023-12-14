

select 
	d.id, day_date, 
	TO_CHAR(sleep_start,'yyyy-MM-dd HH24:MI') sleep_start, 
	TO_CHAR(sleep_end,'yyyy-MM-dd HH24:MI') sleep_end, 
	TO_CHAR(sleep_time,'HH24:MI') sleep_time, 
	TO_CHAR(deep_sleep,'HH24:MI') deep_sleep, 
	notes,
    array_agg(t.tag_name) AS day_log_tag_ids
from day_log d left join day_log_tag t
	on d.id = t.day_log_id
group by d.id
order by day_date desc
limit 5; 

update day_log set 
	day_date = TO_TIMESTAMP(, 'yyyy-MM-dd HH24:MI'),
	sleep_start = @sleep_start,
	sleep_end = @sleep_end,
	deep_sleep = @deep_sleep,
	notes = @notes
where id = @id;

select * from day_log_tag;
	

