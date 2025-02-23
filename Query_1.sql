-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

Select *
from layoffs;

Select *
from layoffs_staging2;

Create Table layoffs_staging
like layoffs;

Select *
from layoffs_staging;

Insert layoffs_staging 
Select * 
from layoffs;

SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY company, industry, total_laid_off,`date`) AS row_num
	FROM layoffs_staging;
    
With Duplicate_cte as
(
	SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY company, location, industry, total_laid_off,`date`, country, funds_raised_millions) AS row_num
	FROM layoffs_staging
)

Select *
from Duplicate_cte
where ROW_NUM > 1;

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
   row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
from layoffs_staging2;

Insert into layoffs_staging2 
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY company, location, industry, total_laid_off,`date`, country, funds_raised_millions) AS row_num
	FROM layoffs_staging;

Delete
from layoffs_staging2
where row_num > 1;

Select *
from layoffs_staging2;

Select Company, (trim(company))
from layoffs_staging2;

Update layoffs_staging2
Set Company = trim(company);

Select Distinct industry
from layoffs_staging2
order by 1;

Select *
from layoffs_staging2
where industry like 'crypto%';

Update layoffs_staging2
Set industry = 'Crypto'
Where industry like 'crypto%';

Select Distinct country
from layoffs_staging2
order by 1;

Update layoffs_staging2
Set country = 'United States'
Where country like 'United State%';

Select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

Update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter Table layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
from layoffs_staging2
where industry IS NULL
OR industry = '';

SELECT *
from layoffs_staging2
WHERE company LIKE 'bally%';

Select  *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    AND t1.location = t2.location
Where t1.industry IS NULL OR t1.industry
AND T2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

select *
from layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

Delete
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

