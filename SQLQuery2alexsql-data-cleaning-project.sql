--Data Cleaning
USE Kollzemmy

select * 
from world_layoffs.world_layoffs

--1. Remove duplicates
--2. Standardize the Data
--3. Null values or blank values
--4. Remove any columns not required but duplicate this first

USE [Kollzemmy]
GO

/****** Object:  Table [world_layoffs].[world_layoffs]    Script Date: 4/2/2026 5:50:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [world_layoffs].[world_layoffs_staging](
	[company] [nvarchar](50) NULL,
	[location] [nvarchar](50) NULL,
	[industry] [nvarchar](50) NULL,
	[total_laid_off] [nvarchar](50) NULL,
	[percentage_laid_off] [float] NULL,
	[date] [date] NULL,
	[stage] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[funds_raised_millions] [nvarchar](50) NULL
) ON [PRIMARY]
GO

INSERT INTO world_layoffs.world_layoffs_staging
SELECT *
FROM world_layoffs.world_layoffs;

select *,
ROW_NUMBER() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions order by date) AS row_num
from world_layoffs.world_layoffs_staging


go
with duplicate_cte as
(
select *,
ROW_NUMBER() over(
partition by company,location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions order by date) AS row_num
from world_layoffs.world_layoffs_staging)

delete from duplicate_cte
where row_num > 1
go

go
with duplicate_cte as
(
select *,
ROW_NUMBER() over(
partition by company,location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions order by date) AS row_num
from world_layoffs.world_layoffs_staging)

select * from duplicate_cte
where company = 'casper'


--Standardization
select company,trim(company) as trim_company
from world_layoffs.world_layoffs_staging

UPDATE world_layoffs.world_layoffs_staging
SET company = trim(company)

Select *
from world_layoffs.world_layoffs_staging
where industry like 'crypto%'

Select distinct(industry)
from world_layoffs.world_layoffs_staging
order by 1



Update world_layoffs.world_layoffs_staging
set industry = 'Crypto'
where industry like 'Crypto%'

Select distinct(country), TRIM(trailing '.' from country)
from world_layoffs.world_layoffs_staging
order by 1

Update world_layoffs.world_layoffs_staging
set country = TRIM(trailing '.' from country)
where country like 'United States%'

select * from world_layoffs.world_layoffs_staging

--Nulls/blanks
select * 
from world_layoffs.world_layoffs_staging
where total_laid_off IS NULL
AND percentage_laid_off IS NULL

select
COUNT (*) AS total_rows,
Count(total_laid_off)  AS non_null_count,
SUM(CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END) AS null_count
FROM world_layoffs.world_layoffs_staging

select column_name, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'World_layoffs_staging'
AND COLUMN_NAME = 'total_laid_off'

select * 
from world_layoffs.world_layoffs_staging
where total_laid_off = 'NULL'

UPDATE world_layoffs.world_layoffs_staging
SET total_laid_off = NULL
WHERE total_laid_off like 'NULL'

select * 
from world_layoffs.world_layoffs_staging
where company = 'Airbnb'

select t1.industry, t2.industry
from world_layoffs.world_layoffs_staging t1
JOIN world_layoffs.world_layoffs_staging t2
	ON t1.company = t2.company
	OR t1.location = t2.location
	WHERE t1.industry IS NULL OR t1.industry = ' '
	AND t2.industry IS NOT NULL

	UPDATE t2
	SET t2.industry = t1.industry
	FROM world_layoffs.world_layoffs_staging t1
	JOIN world_layoffs.world_layoffs_staging t2
		ON t1.company = t2.company	
	where t2.industry IS NULL 
	AND t1.industry IS NOT NULL

	
select * from world_layoffs.world_layoffs_staging
where industry IS NULL 
OR industry = ' '

select * from world_layoffs.world_layoffs_staging
where company = 'Bally''s Interactive'

UPDATE world_layoffs.world_layoffs_staging
set industry = NULL
Where industry = 'NULL'

select * from world_layoffs.world_layoffs_staging

select * 
from world_layoffs.world_layoffs_staging
where total_laid_off IS NULL
AND percentage_laid_off IS NULL

DELETE
from world_layoffs.world_layoffs_staging
where total_laid_off IS NULL
AND percentage_laid_off IS NULL

select column_name, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'World_layoffs_staging'
AND COLUMN_NAME = 'funds_raised_millions'

	SELECT * FROM world_layoffs.world_layoffs_staging
	WHERE country = 'NULL'
			OR stage = 'NULL'
			OR company = 'NULL'
			OR industry = 'NULL'

UPDATE world_layoffs.world_layoffs_staging
SET stage = NULL
WHERE stage = 'NULL'



ALTER TABLE world_layoffs.world_layoffs_staging
ALTER COLUMN funds_raised_millions DECIMAL (10,2)


ALTER TABLE world_layoffs.world_layoffs_staging
ALTER COLUMN total_laid_off INT

select funds_raised_millions from world_layoffs.world_layoffs_staging
where ISNUMERIC(funds_raised_millions) = 0
AND funds_raised_millions IS NOT NULL

order by
	CASE WHEN funds_raised_millions IS NULL THEN 1 ELSE 0 END,
	funds_raised_millions desc

	UPDATE world_layoffs.world_layoffs_staging
	SET funds_raised_millions = NULL
	WHERE funds_raised_millions = 'NULL'