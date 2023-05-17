/* 현제 요일과 시간을 기준으로 영업 여부를 판단하는 함수 */
create function petme3.fn_open_yn(p_place_id bigint)
    returns varchar(1)
begin
	declare v_open_yn varchar(1);
	declare v_day_of_week int;
	declare v_start_time time;
	declare v_end_time time;
	declare v_now_time time;

	set v_open_yn = 'n';

	-- 요일 구하
select weekday(now()) into v_day_of_week
from dual;

if v_day_of_week = 0 then
select
    str_to_date(substring_index(monday_hours, '-', 1), '%H:%i'),
    str_to_date(substring_index(substring_index(monday_hours, '-', 2), '-', -1), '%H:%i'),
    time(now())
into v_start_time, v_end_time, v_now_time
from tb_place_business_hours
where tb_place_id = p_place_id;
elseif v_day_of_week = 1 then
select
    str_to_date(substring_index(tuesday_hours, '-', 1), '%H:%i'),
    str_to_date(substring_index(substring_index(tuesday_hours, '-', 2), '-', -1), '%H:%i'),
    time(now())
into v_start_time, v_end_time, v_now_time
from tb_place_business_hours
where tb_place_id = p_place_id;
elseif v_day_of_week = 2 then
select
    str_to_date(substring_index(wednesday_hours, '-', 1), '%H:%i'),
    str_to_date(substring_index(substring_index(wednesday_hours, '-', 2), '-', -1), '%H:%i'),
    time(now())
into v_start_time, v_end_time, v_now_time
from tb_place_business_hours
where tb_place_id = p_place_id;
elseif v_day_of_week = 3 then
select
    str_to_date(substring_index(thursday_hours, '-', 1), '%H:%i'),
    str_to_date(substring_index(substring_index(thursday_hours, '-', 2), '-', -1), '%H:%i'),
    time(now())
into v_start_time, v_end_time, v_now_time
from tb_place_business_hours
where tb_place_id = p_place_id;
elseif v_day_of_week = 4 then
select
    str_to_date(substring_index(friday_hours, '-', 1), '%H:%i'),
    str_to_date(substring_index(substring_index(friday_hours, '-', 2), '-', -1), '%H:%i'),
    time(now())
into v_start_time, v_end_time, v_now_time
from tb_place_business_hours
where tb_place_id = p_place_id;
elseif v_day_of_week = 5 then
select
    str_to_date(substring_index(saturday_hours, '-', 1), '%H:%i'),
    str_to_date(substring_index(substring_index(saturday_hours, '-', 2), '-', -1), '%H:%i'),
    time(now())
into v_start_time, v_end_time, v_now_time
from tb_place_business_hours
where tb_place_id = p_place_id;
elseif v_day_of_week = 6 then
select
    str_to_date(substring_index(sunday_hours, '-', 1), '%H:%i'),
    str_to_date(substring_index(substring_index(sunday_hours, '-', 2), '-', -1), '%H:%i'),
    time(now())
into v_start_time, v_end_time, v_now_time
from tb_place_business_hours
where tb_place_id = p_place_id;
end if;

	if v_now_time >= v_start_time and v_now_time <= v_end_time then
		set v_open_yn = 'y';
end if;

return v_open_yn;

end