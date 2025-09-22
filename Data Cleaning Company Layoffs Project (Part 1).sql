-- DATA CLEANING Company Layoffs Project (Part 1)

-- 1. Remove Duplicates
-- 2. Standardize the Data; finding issues in your data then fixing it
-- 3. Null Values or blank values
-- 4. Remove Any Columns or Rows
____________________________________________________________________________________________


-- 1. Remove Duplicates(If any)
-- Create copy of raw data to ensure original copy is not unintentionally altered.
CREATE TABLE layoffs_staging
LIKE layoffs;
SELECT * 
FROM layoffs_staging;
INSERT layoffs_staging
SELECT * 
FROM layoffs;


-- Checks for duplicates
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
;

WITH duplicates_cte AS
(
	SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage
    , country, funds_raised_millions) AS row_num
	FROM layoffs_staging
)  
SELECT * 
FROM duplicates_cte
WHERE row_num > 1;


-- Create another new table with the CTE data as new data. Using row_num as new column.
CREATE TABLE layoffs_staging2 (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

-- Insert into new table.
INSERT INTO layoffs_staging2
(SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage
    , country, funds_raised_millions) AS row_num
	FROM layoffs_staging
);

-- Removes duplicate values and confirms they are deleted.
SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;
SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;




-- 2. Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Find that the crypto industry has differing names.
SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1; 

-- Find the entities within the cryptocurrency industry.
SELECT *
FROM layoffs_staging2
WHERE INDUSTRY LIKE '%crypto%'; 

-- Updates entities to all be the same industry name.
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- We find there are two "United States" and "United States." entities.
SELECT DISTINCT country,
FROM layoffs_staging2
ORDER BY 1;

-- Updates table to get rid of the trailing period from 'United States'
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Date Format 
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- Changes Date to MM/DD/YY
SELECT `date`
FROM layoffs_staging2;
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Alters "date" column to be date type instead of text type.
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



-- 3. Analyzing Null or blank values.

SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Takes industry value from the company's other entities to make t1's industry match up with t2's industry.
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Deletes entities with no laid off data.
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

--Drops extra column, no longer in use.
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

--The 'layoffs' Table has now been cleaned.
