
drop table day_log_tag;
drop table day_log;
CREATE TABLE day_log (
	id SERIAL PRIMARY KEY,
	day_date date NOT null,
	sleep_start timestamp NULL,
	sleep_end timestamp NULL,
	sleep_time interval NULL GENERATED ALWAYS AS (sleep_end - sleep_start) STORED,
	deep_sleep interval null,
	notes text NULL,
	CONSTRAINT day_log_unique unique (day_date)
);
CREATE TABLE day_log_tag (
	id SERIAL PRIMARY KEY,
	tag_name text,
	day_log_id serial REFERENCES day_log (Id)
);
DO $$ 
DECLARE
    i integer;
   	j integer;
    num_cycles integer;
   	tag_array text[] := ARRAY['Банановый Хамак','Лама Драма','Огуречные Пижамы','Диско Торнадо','Робот Равиоли','Единороговый Сэндвич','Вомбат Жамбори','Чизбургерный Балет','Ниндзя Картофель','Зомби Такос','Беконный Близард','Зефирный Смокинг','Пиратские Блины','Космический Огурец','Симфония На Погостке','Туалетная Бумага Танго','Лепреконовые Леггинсы','Опера Резиновой Курицы','Гулянье с Обручем и Хула-Хуп','Гирафий Гумбо','Перчаточный Театр Кукол','Фламенко для Белок','Попкорн Полька','Динозаврская Диско','Балет с Банановыми Улитками','Желе-Джамбалайя для Медуз','Тофу Танго','Клоунский Карнавал','Самба Сасквача','Балет с Пузырчатой Пленкой','Полька для Пингвинов','Кактусовый Кабаре','Караоке для Кенгуру','Резиновая Уточка в Опере','Хиппо-Хутенанси','Читовый Ча-Ча','Вечеринка в Пижамах с Пингвинами','Ниндзя из Тофу','Вальс из Вафель','Диско на Огурцах','Торнадо из Такос','Зомби на Цуккини','Лимбо с Ламами','Парад с Огурцами','Перинные Бои Пингвинов','Робот в Родео','Сальса с Кукольными Носками','Банановая Лодка в Буги-Вуги','Кабаре с Коалами','Вальс из Чикен-Наггетс','Буян с Единорогами','Мамбо с Зефирками','Гирафины в Горизонтальном Положении','Полька на Погостке с Погостком','Пирожное из Пиратов','Космическая Спагетти','Джайв из Желе-Бобы','Плачь Лепреконов','Хула-Хуп на Хула-Хупе','Вальс из Вомбатов','Парад Попкорна','Дуэль Динозавров','Банжо из Бекона','Свинг Сасквачей','Каллипсо с Клоунами в Клоунской Машине','Концерт Кенгуру','Тапенад из Тофу','Родео с Резиновыми Уточками','Гулянье с Гиппо','Чарльстон с Читой','Прогулка с Пандой','Брейк-данс из Пузырчатой Пленки','Тап-данс на Тако','Дракон в Диско','Зомби Зажигание','Линейный Танец с Ламами','Пижамный Паровоз с Огурцами','Робот в Румбе','Шум в Шерсти Укладывающихся Носков','Банановое Буйство','Киклайн с Коалами','Ча-Ча с Чикен-Наггетс','Ураганный Унисон Унисона','Разнос с Зефиром','Гроов Гирафов','Пиццикато на Погостке с Погостком','Пируэт Пиратов','Самба Космических Кальмаров','Джайв с Медузами','Ламентации Лепреконов','Веселый Вихрь с Хула-Хупом','Вальс Вомбатов','Погружение в Попкорн','Танцы Динозавров','Брейкбит из Бекона','Свинг Сасквача','Калипсо в Клоунской Машине','Концерт Кенгуру','Тапенад из Тофу','Полонез с Перцем'];
BEGIN
	truncate day_log cascade;

    FOR i IN 1..10000 LOOP
        -- Generate a random date within a date range (adjust the range as needed)
        INSERT INTO day_log (id, day_date) VALUES (i, CURRENT_DATE - (i * interval '1 day'));
        -- Generate random sleep_start and sleep_end times within a day
        UPDATE day_log
        SET
            sleep_start = (day_date +  interval '20 hours' + random() * interval '6 hours'),
            sleep_end = (day_date + interval '1 day 6 hours' + random() * interval '6 hours'),
            deep_sleep = (random() * interval '4 hours'),
            notes = 'Random notes for day ' || i
        WHERE id = i;
    	num_cycles := floor(random() * 15 + 2);
       	FOR j IN 1..num_cycles LOOP
        	INSERT INTO day_log_tag (tag_name, day_log_id) VALUES (tag_array[floor(random() * array_length(tag_array, 1)+1)], i);
	    END LOOP;
    END LOOP;
END $$;

commit;

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
	





