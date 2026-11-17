
-- DATA CLAENING 
-- REMOVING DUPLICATE 



create table layoffs_staging
like layoffs;

insert layoffs_staging
select * from layoffs;


select * from layoffs_staging;

with duplicate_cte as(
select *, row_number() over
(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) row_num
from layoffs_staging
) select * from duplicate_cte
where row_num>1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * from layoffs_staging2;


insert layoffs_staging2
select *, row_number() over
(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) row_num
from layoffs_staging;

select * from layoffs_staging2;

select * from layoffs_staging2
where row_num>1;

delete from layoffs_staging2
where row_num>1;



-- standardizing data 

-- company

select * from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select company ,trim(company)  from layoffs_staging2;

-- industry


select  distinct industry  from layoffs_staging2 order by industry	;

select * from layoffs_staging2
where industry like 'crypto%'
order by industry
;


update layoffs_staging2
set industry = 'Crypto'
where industry like 'crypto%';


select distinct industry from layoffs_staging2 order by industry;


-- country


select distinct country from layoffs_staging2 order by country;


select distinct country from layoffs_staging2
where country like 'united%' order by country;

select distinct country,trim(trailing '.' from country)
from layoffs_staging2
order by country;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'united states%' ;

-- date

select `date`,str_to_date(`date`,'%m/%d/%Y') from layoffs_staging2;


update layoffs_staging2
set `date`= str_to_date(`date`,'%m/%d/%Y');


-- modifify date column

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date`  date;


-- WORKING WITH NULL AND SPACE

select * from layoffs_staging2
WHERE percentage_laid_off is null 
and total_laid_off is null ;

update layoffs_staging2
set industry = null
where industry ='';


select distinct industry from layoffs_staging2  ;


select *
from layoffs_staging2
WHERE  industry IS NULL
OR industry = ''
;


select *
from layoffs_staging2
where company = 'Airbnb';


 
 select * from layoffs_staging2 t1
 join layoffs_staging2 t2
 on t1.company = t2.company
 where t1.industry is null
 and t2.industry is not null;



update layoffs_staging2 t1
join layoffs_staging2 t2
 on t1.company = t2.company
 set t1.industry = t2.industry
where t1.industry is null
 and t2.industry is not null;
 
 



 select t1.industry,t2.industry from layoffs_staging2 t1
 join layoffs_staging2 t2
 on t1.company = t2.company
 where t1.industry is null 
 and t2.industry is not null;
 
 
 
 select *
from layoffs_staging2
where company = 'Airbnb';


SELECT * 
FROM layoffs_staging2
WHERE company = 'Carvana';


UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE company = 'Airbnb' AND (industry IS NULL OR industry = '');

UPDATE layoffs_staging2
SET industry = 'Transportation'
WHERE company = 'Carvana' AND (industry IS NULL OR industry = '');

UPDATE layoffs_staging2
SET industry = 'Consumer'
WHERE company = 'Juul' AND (industry IS NULL OR industry = '');



select * from layoffs_staging2
where total_laid_off is null and 
percentage_laid_off is null;


-- if you want to delet the null data you can delete based on you confident 



select * from layoffs_staging2;


DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;


alter table layoffs_staging2
drop column row_num;



-- exploratory data analysis

-- Data Cleaning vs EDA


select * from layoffs_staging2; 


select max(total_laid_off) from layoffs_staging2; 


select * from layoffs_staging2
where  cast(percentage_laid_off as decimal(10,4)) = 1
order by total_laid_off desc;



select * from layoffs_staging2
where  cast(percentage_laid_off as decimal(10,4)) = 1
order by funds_raised_millions desc;


select company , sum(total_laid_off) from layoffs_staging2 
where total_laid_off is not null
group by company
order by 2 desc
; 

SELECT min(`date`),max(`date`)
from layoffs_staging2;


select industry,sum(total_laid_off)
from layoffs_staging2
group by 1
order by 2 desc;


select country,sum(total_laid_off) from layoffs_staging2
group by 1
order by 2 desc;


select year(`date`),sum(total_laid_off) from layoffs_staging2
group by 1
order by 2 desc;








select substring(`date`,1,7) as `month` , 
sum(total_laid_off) from layoffs_staging2
where substring(`date`,1,7) is not null
group by 1
order by 1 asc;


with rolling_total as (
select substring(`date`,1,7) as `month` , 
sum(total_laid_off) as total_off 
from layoffs_staging2
where substring(`date`,1,7) is not null
group by 1
order by 1 asc
)
select *,sum(total_off) over(order by`month`) as ROLLING_TOTAL from rolling_total order by `month`;
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 1;


-- exploratory data analysis

-- Data Cleaning vs EDA

select * from layoffs_staging2;


select max(total_laid_off),max(cast(percentage_laid_off as decimal(10,4)))
from layoffs_staging2;


select * from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;




select company ,sum(total_laid_off) from layoffs_staging2
group by company 
order by 2 desc;


select min(`date`),max(`date`) from layoffs_staging2;


select industry ,sum(total_laid_off) 
from layoffs_staging2 
group by industry 
order by 2 desc; 



select country ,sum(total_laid_off) 
from layoffs_staging2 
group by country 
order by 2 desc; 

select `date` , sum(total_laid_off)
from layoffs_staging2
group by 1
order by 1 desc;


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT *, SUM(total_off) OVER(order by `month`) AS rolling_total
FROM Rolling_Total;

select company , year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company , year(`date`)
order by 3 desc;


with company_year (company ,years,total_laid_off) as (
select company , year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company , year(`date`)
),company_year_rank as 
(select * ,dense_rank() over(partition by years order by total_laid_off desc ) as ranking
from company_year 
where years is not null
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <=  5
ORDER BY years ASC, ranking ASC;












