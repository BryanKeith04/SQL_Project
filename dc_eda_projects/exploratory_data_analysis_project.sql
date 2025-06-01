select *
from layoffs_staging2;

select company, sum(total_laid_off) sum
from layoffs_staging2
where total_laid_off is not null
group by company;

with total_laid_off_by_company as
(
select company, sum(total_laid_off) sum
from layoffs_staging2
where total_laid_off is not null
group by company
)
select company, sum, dense_rank() over(order by sum desc) ranking
from total_laid_off_by_company
where sum is not null
order by 2 desc;

select industry, sum(total_laid_off) sum
from layoffs_staging2
where industry is not null
group by industry;

with total_laid_off_by_industry as
(
select industry, sum(total_laid_off) sum
from layoffs_staging2
where industry is not null
group by industry
)
select industry, sum, dense_rank() over(order by sum desc) ranking
from total_laid_off_by_industry
order by sum desc;

select left(`date`,7) month, sum(total_laid_off)
from layoffs_staging2
where left(`date`,7) is not null
group by `month`
order by `month` asc;

select year(`date`) year, sum(total_laid_off) sum
from layoffs_staging2
where year(`date`) is not null
group by `year`
order by `year` asc;

select country, sum(total_laid_off) sum
from layoffs_staging2
where total_laid_off is not null
and country is not null
group by country
order by sum desc;

with total_laid_off_by_country as
(
select country, sum(total_laid_off) sum
from layoffs_staging2
where total_laid_off is not null
and country is not null
group by country
order by sum desc
)
select country, sum, dense_rank() over(order by sum desc) ranking
from total_laid_off_by_country;

select industry, left(`date`,7) month, total_laid_off,
sum(total_laid_off) over(partition by industry order by left(`date`,7) asc) accumulative
from layoffs_staging2
where industry is not null
and total_laid_off is not null;

select industry, year(`date`) year, sum(total_laid_off) sum
from layoffs_staging2
where total_laid_off is not null
and year(`date`) is not null
group by year(`date`), industry
order by industry, `year`;

with industry_accumulative_each_year as
(
select industry, year(`date`) year, sum(total_laid_off) sum
from layoffs_staging2
where total_laid_off is not null
and year(`date`) is not null
group by year(`date`), industry
order by industry, `year`
)
select industry, `year`, sum,
sum(`sum`) over(partition by industry order by `year`) accumulative
from industry_accumulative_each_year;

select company, year(`date`) year, sum(total_laid_off) sum
from layoffs_staging2
where year(`date`) is not null
and total_laid_off is not null
group by company, `year`
order by `year`;

with rank_by_year_company as
(
select company, year(`date`) year, sum(total_laid_off) sum
from layoffs_staging2
where year(`date`) is not null
and total_laid_off is not null
group by company, `year`
order by `year`
), rank_by_year_company2 as
(select *, dense_rank()over(partition by `year` order by sum desc) ranking
from rank_by_year_company)
select *
from rank_by_year_company2
where ranking <=5;

