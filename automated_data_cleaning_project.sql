-- Automated Data Cleaning

select *
from data_cleaning_automation.us_household_income;

select * 
from data_cleaning_automation.us_household_income_Cleaned;



delimiter $$
drop procedure if exists Copy_and_Clean_Data;
create procedure Copy_and_Clean_Data()
begin
	create table if not exists `us_household_income_Cleaned` (
	  `row_id` int default null,
	  `id` int default null,
	  `State_Code` int default null,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int default null,
	  `Area_Code` int default null,
	  `ALand` int default null,
	  `AWater` int default null,
	  `Lat` double default null,
	  `Lon` double default null,
	  `TimeStamp` timestamp default null
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
	insert into us_household_income_Cleaned
    select *, current_timestamp
	from data_cleaning_automation.us_household_income;
    
	delete from us_household_income_Cleaned 
	where row_id in
        (
		select row_id
		from (select row_id, id, row_number() over(partition by id, `TimeStamp` order by id, `TimeStamp`) as row_num
                from us_household_income_Cleaned) duplicates
		where row_num > 1
		);

	update us_household_income_Cleaned
	set State_Name = 'Georgia'
	where State_Name = 'georia';

	update us_household_income_Cleaned
	set County = upper(County);

	update us_household_income_Cleaned
	set City = upper(City);

	update us_household_income_Cleaned
	set Place = upper(Place);

	update us_household_income_Cleaned
	set State_Name = upper(State_Name);

	update us_household_income_Cleaned
	set `Type` = 'CDP'
	where `Type` = 'CPD';

	update us_household_income_Cleaned
	set `Type` = 'Borough'
	where `Type` = 'Boroughs';

end $$
delimiter ;



call Copy_and_Clean_Data();



drop event run_data_cleaning;
create event run_data_cleaning
	on schedule every 30 day
	do call Copy_and_Clean_Data(); 



delimiter $$
create trigger Transfer_clean_data
	after insert on data_cleaning_automation.us_household_income
    for each row
begin
	call Copy_and_Clean_Data();
end $$
delimiter ;



insert into data_cleaning_automation.us_household_income
(`row_id`,`id`,`State_Code`,`State_Name`,`State_ab`,`County`,`City`,`Place`,`Type`,`Primary`,`Zip_Code`,`Area_Code`,`ALand`,`AWater`,`Lat`,`Lon`)
values
(121671,37025904,37,'North Carolina','NC','Alamance County','Charlotte','Alamance','Track','Track',28215,980,24011255,98062070,35.2661197,-80.6865346);



select row_id, id, row_num, `timestamp`
from (select row_id, id, row_number() over(partition by id order by id) as row_num, `timestamp`
		from us_household_income_Cleaned) duplicates
where row_num > 1;

select count(row_id)
from us_household_income_Cleaned;

select State_Name, count(State_Name)
from us_household_income_Cleaned
group by State_Name;


