-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off) AS max_layoff, MAX(percentage_laid_off) AS max_perlayoff
FROM layoffs_staging2;

SELECT company, MAX(total_laid_off) AS max_layoff
FROM layoffs_staging2
GROUP BY company
ORDER BY max_layoff DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC
;
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC
;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC
;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC
;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC
;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC;

SELECT MONTH(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTH(`date`)
ORDER BY SUM(total_laid_off) DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(percentage_laid_off) DESC
;

-- ROLLING TOTAL

SELECT MONTH(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY MONTH(`date`)
ORDER BY SUM(total_laid_off) DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC;

WITH Rollin_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS layoff
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC
)
SELECT `MONTH`,layoff, SUM(layoff) OVER(ORDER BY `MONTH`) AS rollin_total
FROM Rollin_total
;


SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(percentage_laid_off) DESC
;

SELECT company, YEAR(`date`), SUM(total_laid_off) AS layoff
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY layoff DESC
;

WITH company_year (company, years, total_laid_off)AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC
), Company_year_rank AS
(
SELECT company,
years,
total_laid_off,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE Ranking <=5;

