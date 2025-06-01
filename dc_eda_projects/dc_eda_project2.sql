-- data cleaning
select *
from world_life_expectancy;

select row_id, country_year, row_num
from 
(select row_id, concat(country, `year`) country_year, row_number()over(partition by concat(country, `year`)) row_num
from world_life_expectancy) as `remove`
where row_num > 1;

delete from world_life_expectancy
where row_id in
(
select row_id
from 
(select row_id, concat(country, `year`) country_year, row_number()over(partition by concat(country, `year`)) row_num
from world_life_expectancy) as `remove`
where row_num > 1
);

select * 
from world_life_expectancy
where status = '';

select distinct country
from world_life_expectancy
where status = 'Developing';

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country=t2.country
set t1.status = 'Developing'
where t1.status = ''
and t2.status != ''
and t2.status = 'Developing';

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country=t2.country
set t1.status = 'Developed'
where t1.status = ''
and t2.status != ''
and t2.status = 'Developed';

select *
from world_life_expectancy;

select *
from world_life_expectancy
where `Life expectancy` = '';

select t1.country, t1.year, t1.`Life expectancy`, 
t2.country, t2.year, t2.`Life expectancy`,
t3.country, t3.year, t3.`Life expectancy`,
round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
from world_life_expectancy t1
join world_life_expectancy t2
	on t1.year=t2.year +1 and t1.country=t2.country
join world_life_expectancy t3
	on t1.year=t3.year -1 and t1.country=t3.country
where t1.`Life expectancy` = '';

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.year=t2.year +1 and t1.country=t2.country
join world_life_expectancy t3
	on t1.year=t3.year -1 and t1.country=t3.country
set t1.`Life expectancy` = round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = '';





-- exploratory data
select *
from world_life_expectancy;

select country, round(avg(`life expectancy`),1) avg_exp
from world_life_expectancy
group by country
having avg_exp <> 0
order by avg_exp asc;

select year, round(avg(`life expectancy`),1) avg_exp
from world_life_expectancy
where `life expectancy` <> 0
group by year;

select country, round(avg(`life expectancy`),1) avg_life_exp, round(avg(gdp),1) avg_gdp
from world_life_expectancy
where `life expectancy` <> 0
and gdp <> 0
group by country
order by avg_gdp asc;

select country, gdp
from world_life_expectancy
where gdp <> 0
order by gdp desc;

select
sum(case when gdp > 1700 then 1 else 0 end) high_gdp,
round(avg(case when gdp > 1700 then `life expectancy` end),1) avg_life_exp,
sum(case when gdp < 1700 then 1 else 0 end) low_gdp,
round(avg(case when gdp < 1700 then `life expectancy` end),1) avg_life_exp
from world_life_expectancy
where gdp <> 0
and `life expectancy` <> 0;

select status, round(avg(`Life expectancy`),1) avg_life_exp
from world_life_expectancy
where `Life expectancy` <> 0
group by status;
