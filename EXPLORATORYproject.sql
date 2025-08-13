-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT industry, company, MAX(total_laid_off)
FROM layoffs_staging2
GROUP BY industry, company
ORDER BY 3 DESC;

SELECT company, industry, total_laid_off, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off = 1
order by 3 DESC;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

SELECT YEAR(`date`), SUM(total_laid_off) -- YEAR function
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT country, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Review Substrings
SELECT SUBSTRING(`date`, 1, 4) AS `year`, SUBSTRING(`date`, 6, 2) AS `month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 4) OR SUBSTRING(`date`, 6, 2) IS NOT NULL
GROUP BY `year`, `month`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `year-month`, SUM(total_laid_off) AS tlo
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `year-month`
ORDER BY 1 ASC
)
SELECT `year-month`, tlo, SUM(tlo) OVER(ORDER BY `year-month`) AS rolling -- Rolling Total
FROM Rolling_Total;

WITH Roll_toll AS -- self
(
SELECT company, SUBSTRING(`date`, 1, 4) AS `year`, SUM(total_laid_off) AS tlo2
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 4) IS NOT NULL
GROUP BY `year`, company
ORDER BY 1 ASC
)
SELECT company, `year`, tlo2, SUM(tlo2) OVER(ORDER BY `company`) AS rolling
FROM Roll_toll;

-- guided
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year(company, years, total_laidoff) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laidoff DESC) AS rank_year
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE rank_year <= 5 -- top 5
ORDER BY years;

SELECT *
FROM layoffs_staging2
WHERE industry = 'Crypto' AND total_laid_off IS NOT NULL
ORDER BY total_laid_off DESC;

SELECT *, ROW_NUMBER() OVER() AS row_num
FROM layoffs_staging2
LIMIT 50;

