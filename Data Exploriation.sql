Select * 
from layoffs_staging2;

Select Max(total_laid_off), Max(percentage_laid_off)
from layoffs_staging2;

Select *
from layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

Select *
from layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

Select company, SUM(total_laid_off)
from layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

Select Min(`date`), Max(`date`)
from layoffs_staging2;

Select industry, SUM(total_laid_off)
from layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
;

Select country, SUM(total_laid_off)
from layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;

Select `date`,  SUM(total_laid_off)
from layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC
;

Select YEAR(`date`),  SUM(total_laid_off)
from layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;

Select stage,  SUM(total_laid_off)
from layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
;

Select substring(`date`,1,7) AS `MONTH` , SUM(total_laid_off)
from layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
Select substring(`date`,1,7) AS `MONTH` , SUM(total_laid_off) AS Total_Loff
from layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC
)
Select `MONTH`, Total_Loff,
SUM(Total_Loff) OVER(ORDER BY `MONTH`) AS Rolling_Total
FROM Rolling_Total
;

Select company, YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
;

WITH Company_Year ( Company, Years, Total_laid_off) AS
(
Select company, YEAR(`date`), SUM(total_laid_off)
from layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), 
Company_Year_Rank AS
(
Select *, DENSE_RANK() OVER (partition by Years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
Where Years IS NOT NULL
ORDER BY Ranking ASC
)
Select *
From Company_Year_Rank
WHERE Ranking <= 5
;








