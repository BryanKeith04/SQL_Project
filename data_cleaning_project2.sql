select *
from data_cleaning;

alter table data_cleaning
rename column ï»¿sweepstake_id to sweepstake_id;

select sweepstake_id
from (select sweepstake_id, customer_id, row_number()over(partition by customer_id) row_num
from data_cleaning) as row_num
where row_num > 1;

delete from data_cleaning
where sweepstake_id in 
(select sweepstake_id
from (select sweepstake_id, customer_id, row_number()over(partition by customer_id) row_num
from data_cleaning) as row_num
where row_num > 1);

select phone, regexp_replace(phone, '[-()/]+', '')
from data_cleaning;

update data_cleaning
set phone = regexp_replace(phone, '[-()/]+', '');

select phone, concat(substring(phone,1,3),'-', substr(phone,4,3),'-', substr(phone,7,4))
from data_cleaning
where phone <> '';

update data_cleaning
set phone = concat(substring(phone,1,3),'-', substr(phone,4,3),'-', substr(phone,7,4))
where phone <> '';

select birth_date, concat(substr(birth_date,9,2),'/', substr(birth_date,6,2),'/', substr(birth_date,1,4))
from data_cleaning;

update data_cleaning
set birth_date = concat(substr(birth_date,9,2),'/', substr(birth_date,6,2),'/', substr(birth_date,1,4))
where sweepstake_id in (9, 11);

select birth_date, str_to_date(birth_date,'%m/%d/%Y')
from data_cleaning;

update data_cleaning
set birth_date = str_to_date(birth_date,'%m/%d/%Y');

select *
from data_cleaning;

select `Are you over 18?`,
(case
	when `Are you over 18?` = 'Yes' then 'Y'
    when `Are you over 18?` = 'No' then 'N'
    else `Are you over 18?`
end)
from data_cleaning;

update data_cleaning
set `Are you over 18?` =
(case
	when `Are you over 18?` = 'Yes' then 'Y'
    when `Are you over 18?` = 'No' then 'N'
    else `Are you over 18?`
end);

select address, 
substring_index(address,',',1) as street, 
substring_index(substring_index(address,',',-2),',',1) as city, 
substring_index(address,',',-1) as state
from data_cleaning;

alter table data_cleaning
add column `street` varchar(50) after address,
add column `city` varchar(50) after street,
add column `state` varchar(50) after city;

update data_cleaning
set street = substring_index(address,',',1),
city = substring_index(substring_index(address,',',-2),',',1),
state = substring_index(address,',',-1);

select *
from data_cleaning;

update data_cleaning
set state = upper(state);

update data_cleaning
set phone =  null
where phone = '';

update data_cleaning
set income =  null
where income = '';

select year(birth_date), year(now()), year(now())-year(birth_date), `Are you over 18?`,
(case
when year(now())-year(birth_date) > 18 then 'Y'
when year(now())-year(birth_date) <= 18 then 'N'
end)
from data_cleaning;

update data_cleaning
set `Are you over 18?` =
(case
when year(now())-year(birth_date) > 18 then 'Y'
when year(now())-year(birth_date) <= 18 then 'N'
end);

select *
from data_cleaning;

alter table data_cleaning
drop column address;