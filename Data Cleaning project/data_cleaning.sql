-- DATA CLEANING PROJECT
SELECT *
FROM layoffs;

-- Step 1 -> Remove the duplicate if any!!
-- Step 2 -> Standardize the Data (like spelling mistake if any)
-- Step 3 -> Null values or Blank values
-- Step 4 -> Removing irrelevant column if any


-- NOW WE ARE HERE DUPLICATING THIS DATA TO A NEW TABLE LAYOFF_STAGING (by this command will only get column without data in it)
CREATE TABLE layoff_staging
LIKE layoffs;

SELECT * 
FROM layoff_staging;

-- FOR INSERTING DATA INTO THE COLUMN

INSERT layoff_staging
SELECT * FROM
layoffs;

-- NOW WE HAVE EXACTLY 2 SAME TABLE 	(we did this because we gonna make so much changes in staging table so if smth happened our raw that will there be there untouched)


SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company,location,industry,percentage_laid_off,total_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoff_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company,location,industry,percentage_laid_off,total_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoff_staging
)
SELECT * FROM duplicate_cte
WHERE row_num >1;

SELECT * 
from layoff_staging
where company= 'Casper';

-- NOW WE GOT THE DUPLICATE IN THE DATA SO WHAT WE WILL DO IS WILL MAKE ANOTHER TABLE (LAYOFF_STAGING2)

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT    -- ADDED BY US
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- NOW WE HAVE CREATED ANOTHER TABLE 

select * from layoff_staging2;

-- now we have the coloums and we need to insert the information which we have in our cte

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company,location,industry,percentage_laid_off,total_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoff_staging;


-- NOW WE HAVE THE SAME DATA WITH A NEW COLUMN ROW_NUM BY WHICH WE CAN FILTER

SELECT *
FROM layoff_staging2
WHERE row_num>1;

-- NOW WE NEED TO DELETE THIS DUPLICATE

DELETE
FROM layoff_staging2
WHERE row_num>1;
-- (successfully deleted!!!)


-- STEP 2 [STANDARDIZING DATA (means finding issues and solving in your data)]

-- NOW WILL REMOVE THE EXTRA SPACES WE HAVE IN OUR DATA
SELECT company ,TRIM(company)
FROM layoff_staging2;

-- UPDATING THE COMPANY COLUMN WITH TRIM(COMPANY)

UPDATE layoff_staging2
SET company = TRIM(company);

-- WE CAN CHECK BELOW THAT WE HAVE UPLOAD 
SELECT * FROM layoff_staging2;


--   NOW WILL CHECK  FOR INDUSTRY 

SELECT industry
from layoff_staging2;

SELECT *
FROM layoff_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoff_staging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';


--  NOW WILL CHECK EACH COLUMN MANULLY THAT THEY HAVE SOME ERROR OR NOT 

SELECT DISTINCT LOCATION
FROM layoff_staging2
ORDER BY 1;
-- NO ISSUE HERE

SELECT DISTINCT country
from layoff_staging2
order by 1;
-- found error in united states

UPDATE layoff_staging2
SET country = 'United States'
Where country like 'United States%';
-- FIXED!!!

select * 
from layoff_staging2;

-- NOW WILL CHANGE THE format OF DATE (TEXT TO DATE FORMAT)

SELECT `date`,
       STR_TO_DATE(`date`,'%m/%d/%Y') 
FROM layoff_staging2;

-- NOW WILL UPDATE THE STR_DATE COLOUM TO OUR TABLE

UPDATE layoff_staging2
set `date`=STR_TO_DATE(`date`,'%m/%d/%Y') ;
-- updated

select * 
from layoff_staging2;

-- NOW WILL CHANGE THE DATA TYPE OF THE DATE  FROM TEXT TO DATE

ALTER TABLE layoff_staging2 
MODIFY `date` date;

-- DONE!!!

-- STEP-3 (WE GONNA WORK ON NULL VALUES)

SELECT *
FROM layoff_staging2
where total_laid_off IS NULL;


SELECT * 
from temp_table
WHERE industry is NULL
OR
industry = '';

-- will try to populate the data 
SELECT * 
from layoff_staging2
where company = 'Airbnb';

-- now we got a row of airbnb which has data in it's data column so will take it and populate in other airbnb row


SELECT t1.industry,t2.industry
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL OR t1.industry = ''
AND t2.industry IS NOT NULL;


-- NOW POPULATING THE DATA 
UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


SELECT industry
from layoff_staging2 t1
where industry ='';

UPDATE layoff_staging2
set industry = NULL
where industry ='';

-- NOW GOT INTO A PROBLEM THAT EVERYTHING GOT DOUBLED 
-- SOLVING THAT

CREATE TABLE temp_table
as 
select distinct * from layoff_staging2;


TRUNCATE TABLE layoff_staging2;


INSERT into layoff_staging2 
select * from temp_table;

select * from temp_table;
	