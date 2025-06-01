-- data cleaning
select * 
from us_household_income;

select *
from us_household_income_statistics;

alter table us_household_income_statistics
rename column `Id` to `id`;

delete from us_household_income
where id in
(select id
from (select id, count(id)
from us_household_income
group by id
having count(id) > 1) duplicate);

select distinct State_Name
from us_household_income;

select *
from us_household_income
where State_Name = 'georia';

update us_household_income
set state_name = 'Georgia'
where state_name = 'georia';

select *
from us_household_income
where place = '';

select *
from us_household_income
where county = 'Autauga County'
and city = 'Vinemont';

update us_household_income
set place = 'Autaugaville'
where place = ''
and county = 'Autauga County'
and city = 'Vinemont';

select distinct State_ab
from us_household_income;

select distinct type, count(type)
from us_household_income
group by type;

select *
from us_household_income
where type like '%borough%';

update us_household_income
set type = 'Borough'
where type = 'Boroughs';

select distinct `primary`, count(`primary`)
from us_household_income
group by `primary`;

update us_household_income
set State_Name = 'Alabama'
where State_Name = 'alabama';

delete from us_household_income_statistics
where mean = 0
or median = 0;



-- exploratory data
select State_Name, sum(ALand) land, sum(AWater) water
from us_household_income
group by State_Name
order by land desc;

select State_Name, sum(ALand) land, sum(AWater) water
from us_household_income
group by State_Name
order by water desc;

select State_Name, sum(ALand) land, sum(AWater) water, sum(ALand) + sum(AWater) total
from us_household_income
group by State_Name
order by total desc;

select u.State_Name, round(avg(mean),1) avg_mean, round(avg(median),1) avg_median
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
group by u.State_Name
order by avg(mean) desc;

select type, round(avg(mean),1) avg_mean, round(avg(median),1) avg_median
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
group by type
order by avg(mean) desc;

select *
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id;
