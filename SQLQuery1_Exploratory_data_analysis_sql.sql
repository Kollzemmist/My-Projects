
--Exploratory Data Analysis

select * from world_layoffs.world_layoffs_staging
select MAX(total_laid_off), max(percentage_laid_off) from world_layoffs.world_layoffs_staging

select * from world_layoffs.world_layoffs_staging
where percentage_laid_off = 1
order by funds_raised_millions desc

SELECT COMPANY, SUM(total_laid_off)
from world_layoffs.world_layoffs_staging
Group by company
order by 2 DESC

select MIN(DATE), MAX(DATE)
FROM world_layoffs.world_layoffs_staging

SELECT industry, SUM(total_laid_off)
from world_layoffs.world_layoffs_staging
Group by industry
order by 2 DESC

SELECT country, SUM(total_laid_off)
from world_layoffs.world_layoffs_staging
Group by country
order by 2 DESC

SELECT date, SUM(total_laid_off)
from world_layoffs.world_layoffs_staging
Group by date
order by 1 DESC

SELECT YEAR(date), SUM(total_laid_off)
from world_layoffs.world_layoffs_staging
Group by YEAR(date)
order by 1 DESC
	
SELECT stage, SUM(total_laid_off)
from world_layoffs.world_layoffs_staging
Group by stage
order by 2 DESC
	
SELECT FORMAT(date, 'yyyy-MM') AS YEAR_MONTH, SUM(total_laid_off) as sum_total_laid_off
FROM world_layoffs.world_layoffs_staging
WHERE FORMAT(date, 'yyyy-MM') IS NOT NULL
GROUP BY FORMAT(date, 'yyyy-MM')
order by 1 ASC


WITH ROLLING_TOTAL AS
(SELECT FORMAT(date, 'yyyy-MM') AS YEAR_MONTH,YEAR(date) AS yr,
MONTH(date) AS mth,
SUM(total_laid_off) as sum_total_laid_off
FROM world_layoffs.world_layoffs_staging
WHERE date IS NOT NULL
GROUP BY FORMAT(date, 'yyyy-MM'),YEAR(date), MONTH(date)
)
SELECT YEAR_MONTH, sum_total_laid_off, SUM(sum_total_laid_off)
OVER(ORDER BY yr, mth ROWS UNBOUNDED PRECEDING) AS rolling_total
FROM ROLLING_TOTAL
ORDER BY yr, mth ASC

SELECT COMPANY, YEAR(date), SUM(total_laid_off)
from world_layoffs.world_layoffs_staging
Group by company, YEAR(date)
ORDER BY 3 DESC

WITH company_year AS
(
SELECT COMPANY, YEAR(date) as yr, SUM(total_laid_off) as sum_laid
from world_layoffs.world_layoffs_staging
Group by company, YEAR(date)
), company_year_ranking as
(
SELECT *, DENSE_RANK () over (partition by yr order by sum_laid desc) as ranking
FROM
company_year
where yr is not null)
select * from company_year_ranking
where ranking <= 5

with monthly as (
select
	format(date, 'yyyy-MM') as year_month, year(date) as yr, month(date) as mth,
	SUM(total_laid_off) as monthly_total
	from world_layoffs.world_layoffs_staging
	where date is not null
	group by format(date, 'yyyy-MM'), year(date), month(date)
	)
	select year_month, monthly_total,
	LAG(monthly_total) 
	over(order by yr, mth) AS prev_month_total,
	monthly_total - LAG(monthly_total) over (order by yr, mth) as month_diff
	from monthly
	order by yr, mth ASC

	WITH RANKED AS (
	SELECT company, YEAR(date) as yr, total_laid_off, 
	RANK() OVER(PARTITION BY YEAR(DATE) ORDER BY total_laid_off desc) as rnk
	from world_layoffs.world_layoffs_staging
	where total_laid_off is not null
	and date is not null
	)
	select company, yr, total_laid_off 
	from RANKED
	where rnk = 1
	order by yr asc