--create three Schemas in 2Market database to be used for
--storing initial data in 'raw', 
--all cleaning done in 'staging', 
--ready tables to be used for reporting in 'reporting'
create schema raw;
create schema staging;
create schema reporting;

--in raw schema created two tables as per cvs.
--to avoid import issues only 'ID' column's data type bigserial primary key, everything else varchar(225) 
create table raw.marketing_data (
"ID" bigserial primary key,
"Year_Birth" varchar(225),
"Education" varchar(225),
"Marital_Status"varchar(225),
"Income"varchar(225),
"Kidhome"varchar(225),
"Teenhome" varchar(225),
"Dt_Customer" varchar(225),
"Recency" varchar(225),
"AmtLiq" varchar(225),
"AmtVege" varchar(225),
"AmtNonVeg" varchar(225),
"AmtPes" varchar(225),
"AmtChocolates" varchar(225),
"AmtComm" varchar(225),
"NumDeals" varchar(225),
"NumWebBuy"varchar(225),
"NumWalkinPur" varchar(225),
"NumVisits"varchar(225),
"Response" varchar(225),
"Complain"varchar(225),
"Country" varchar(225),
"Count_success" varchar(225)
);

create table raw.ad_data(
"ID" bigserial primary key,
"Bulkmail_ad"varchar(225),
"Twitter_ad" varchar(225),
"Instagram_ad" varchar(225),
"Facebook_ad" varchar(225),
"Brochure_ad" varchar(225)
);

---- check for duplicates of primary key in ea table and move on to staging Schema to do cleaning
select "ID", count(*) 
from raw.ad_data
group by "ID"
having count(*)>1

---create a table of both tables in staging for further interaction; view does not permit alter option to rename columns
create table staging.ad_data as
select * from raw.ad_data;

create table staging.marketing_data as
select * from raw.marketing_data;

--- change column names in both tables to be lower case for convenince & to avoid using quation marks
alter table  staging.ad_data
rename column "ID" to id; 
alter table  staging.ad_data
rename column "Bulkmail_ad" to bulkmail_ad;
alter table  staging.ad_data
rename column "Twitter_ad" to twitter_ad;
alter table  staging.ad_data
rename column "Instagram_ad" to instagram_ad;
alter table  staging.ad_data
rename column "Facebook_ad" to facebook_ad;
alter table  staging.ad_data
rename column "Brochure_ad" to brochure_ad
;

alter table staging.marketing_data
rename column "ID" to id;
alter table staging.marketing_data
rename column "Year_Birth" to year_birth;
alter table staging.marketing_data
rename column "Education" to education;
alter table staging.marketing_data
rename column"Marital_Status" to marital_status;
alter table staging.marketing_data
rename column"Income" to income;
alter table staging.marketing_data
rename column"Kidhome"to kidhome;
alter table staging.marketing_data
rename column"Teenhome" to teenhome;
alter table staging.marketing_data
rename column"Dt_Customer" to dt_customer;
alter table staging.marketing_data
rename column"Recency" to recency;
alter table staging.marketing_data
rename column"AmtLiq" to amtliq;
alter table staging.marketing_data
rename column"AmtVege" to amtveg;
alter table staging.marketing_data
rename column"AmtNonVeg" to amtnonveg;
alter table staging.marketing_data
rename column"AmtPes" to amtpes;
alter table staging.marketing_data
rename column"AmtChocolates" to amtchocolates;
alter table staging.marketing_data
rename column"AmtComm" to amtcomm;
alter table staging.marketing_data
rename column"NumDeals" to numdeals;
alter table staging.marketing_data
rename column"NumWebBuy"to numwebbuy;
alter table staging.marketing_data
rename column"NumWalkinPur" to numwalkinpur;
alter table staging.marketing_data
rename column"NumVisits"to numvisits;
alter table staging.marketing_data
rename column"Response" to response;
alter table staging.marketing_data
rename column"Complain"to complain;
alter table staging.marketing_data
rename column"Country" to country;
alter table staging.marketing_data
rename column"Count_success" to count_success;

---change data type to appropriate for columns in both tables
---- id columns in both tables have been imported as bigint primary key 
---- for the remaining columns before data type can be changed to the appropriate one to check for: 
---in ad_data table:
-----a) whether integer appearing values have accidental spaces (trim)
-----b) whether values have any other symbols ('^\d+$')

alter table staging.ad_data
alter column brochure_ad set data type integer
using case 
when trim(brochure_ad)~'^\d+$' then trim(brochure_ad)::integer
else 0
end;

---CLEANING in ad-data table DONE

---in marketing_data table:
----- columns year_birth, kidhome, teenhome,recency,amtliq,amtveg,amtnonveg,amtpes,amtchocolates,
------amtcomm,numdeals,numwebbuy,numwalkinpur,numvisits,response,complain & count_success:
-----a) whether integer appearing values have accidental spaces (trim)
-----b) whether values have any other symbols ('^\d+$')   

alter table staging.marketing_data
alter column count_success set data type integer
using case 
when trim(count_success)~'^\d+$' then trim(count_success)::integer
else 0
end;

-----column income to be changed to numeric (12,2)
-----remove $ & thousands delimiter ','
alter table staging.marketing_data
alter column income set data type numeric (12,2)
using replace(replace (income,'$',''),',','')::numeric(12,2);

-----column dt_customer data type to be changed to date type
-----given income is in $, assumed all date values are in mm/dd/yy format
-----used to_date() function to explicitly convert the mm/dd/yy format to date.

alter table staging.marketing_data
alter column dt_customer set data type date
using to_date(dt_customer,'mm/dd/yy');

---update country column values to full country name in marketing_data
update staging.marketing_data
set country = case
when country = 'AUS' then	'Australia'
when country =	'CA' then	'Canada'
when country =	'GER' then 	'Germany'
when country = 'IND' then 'India'
when country =	'ME' then 'Montenegro'
when country = 'SA' then 'South Africa'
when country = 'SP' then 'Spain'
when country = 'US' then 'USA'
end;

---tidy up marital_status:
----check what's in the data
	select distinct marital_status, count(marital_status)
	from staging.marketing_data
	group by marital_status;
---- use update case to uniform it 
	update staging.marketing_data
	set marital_status = case
	when marital_status = 'Alone' then 'Single'
	when marital_status = 'Divorced' then 'Divorced'
	when marital_status = 'Married' then 'Married'
	when marital_status = 'Single' then 'Single'
	when marital_status = 'Together' then 'In Relationship'
	when marital_status = 'Widow' then 'Widow'
	else 'Unknow'
	end;

--- tidy up education
----check what's in the data
	select distinct education, count(education)
	from staging.marketing_data
	group by education;
----use replace '2nd Cycle' w 'Master' 
	update staging.marketing_data
	set education = replace (education, '2nd Cycle', 'Master')
	where education = '2n Cycle';
	
--- new column for age of customers (reference point 2024)
alter table staging.marketing_data
add column age integer;
update staging.marketing_data
set age=2024-year_birth
where year_birth is not null; 
--- sense check age i.e. not <15 and not >100 & replace with null
select id, age
from staging.marketing_data
where age < 15 or age>100;

update staging.marketing_data
set age  = case
when age >100 then null
else age
end;

select *
from staging.marketing_data
where age is null;

---CLEANING in marketing-data table DONE

--create views not tables (UPD Dee said we can do anything with views as w tables not views as otherwise won't be able to introduce new columns &etc) 
--and move on to reporting Schema for further interaction

create view reporting.ad_data as
select * from staging.ad_data;

create view reporting.marketing_data as
select * from staging.marketing_data;



select * from reporting.marketing_data
limit 2;