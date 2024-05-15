-- Query 1: Check for NULL values in specific columns
SELECT *
FROM corona_virus_dataset
WHERE 
  Province  IS NULL OR
  "Country/Region" IS NULL OR
  Latitude  IS NULL OR
  Longitude  IS NULL OR
  Date IS NULL OR
  Confirmed IS NULL OR 
  Deaths IS NULL OR
  Recovered IS NULL;

 
-------------------------------------------------------------------------------------------------------------

 
-- Query 2: Update NULL values with zeros in specific columns
UPDATE corona_virus_dataset
SET 
  Province = COALESCE(Province, ''),
  "Country/Region" = COALESCE("Country/Region", ''),
  Latitude = COALESCE(Latitude, 0),
  Longitude = COALESCE(Longitude, 0),
  Date = COALESCE(Date, '2020-01-01'), -- Default date
  Confirmed = COALESCE(Confirmed, 0),
  Deaths = COALESCE(Deaths, 0),
  Recovered = COALESCE(Recovered, 0)
WHERE
  Province IS NULL 
  OR "Country/Region" IS NULL
  OR Latitude IS NULL
  OR Longitude IS NULL
  OR Date IS NULL
  OR Confirmed IS NULL
  OR Deaths IS NULL
  OR Recovered IS NULL;

  
-------------------------------------------------------------------------------------------------------------

 
 --- Query 3: Check total number of rows
SELECT COUNT(*)
FROM corona_virus_dataset;   


-------------------------------------------------------------------------------------------------------------


--- Convert Date(VARCHAR) To Date(DATE)
  
-- Step 1: Add a new column for the converted dates
ALTER TABLE corona_virus_dataset
ADD COLUMN Date_new DATE; 

-- Step 2: Update the new column with converted values
UPDATE corona_virus_dataset
SET Date_new = DATE(SUBSTR(Date, 7, 4) || '-' || SUBSTR(Date, 4, 2) || '-' || SUBSTR(Date, 1, 2));
 
-- Step 3: (Optional) Drop the original VARCHAR column and rename the new column
ALTER TABLE corona_virus_dataset
DROP COLUMN Date; 

ALTER TABLE corona_virus_dataset
RENAME COLUMN Date_new TO Date;
  

-------------------------------------------------------------------------------------------------------------


--- Query 4: Check the Starting date and Ending date
SELECT MIN(Date) AS start_date,
       MAX(Date) AS end_date 
FROM corona_virus_dataset; 


-------------------------------------------------------------------------------------------------------------


--- Query 5: Number of month present in dataset
SELECT COUNT(DISTINCT strftime('%m', Date)) AS num_months
FROM corona_virus_dataset;


-------------------------------------------------------------------------------------------------------------


 -- Querry 6: Find monthly average for confirmed, deaths, recovered
SELECT 
    strftime('%m', Date) AS month,
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered
FROM corona_virus_dataset
GROUP BY strftime('%m', Date);


-------------------------------------------------------------------------------------------------------------


-- Querry 7: Find most frequent value for confirmed, deaths, recovered each month
SELECT 
    strftime('%m', Date) AS month,
    (SELECT Confirmed
     FROM corona_virus_dataset
     WHERE strftime('%m', Date) = strftime('%m', corona_virus_dataset.Date)
     GROUP BY Confirmed
     ORDER BY COUNT(*) DESC
     LIMIT 1) AS most_frequent_confirmed,
    (SELECT Deaths
     FROM corona_virus_dataset
     WHERE strftime('%m', Date) = strftime('%m', corona_virus_dataset.Date)
     GROUP BY Deaths
     ORDER BY COUNT(*) DESC
     LIMIT 1) AS most_frequent_deaths,
    (SELECT Recovered
     FROM corona_virus_dataset
     WHERE strftime('%m', Date) = strftime('%m', corona_virus_dataset.Date)
     GROUP BY Recovered
     ORDER BY COUNT(*) DESC
     LIMIT 1) AS most_frequent_recovered
FROM corona_virus_dataset
GROUP BY strftime('%m', Date);

-------------------------------------------------------------------------------------------------------------

-- Querry 8: Find minimum values for confirmed, deaths, recovered per year
SELECT 
    strftime('%Y', Date) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM corona_virus_dataset
GROUP BY strftime('%Y', Date);


-------------------------------------------------------------------------------------------------------------


-- Querry 9: Find maximum values for confirmed, deaths, recovered per year
SELECT 
    strftime('%Y', Date) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM corona_virus_dataset
GROUP BY strftime('%Y', Date);


-------------------------------------------------------------------------------------------------------------


-- Querry 10. The total number of cases of confirmed, deaths, recovered each month
SELECT 
    strftime('%m', Date) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM corona_virus_dataset
GROUP BY strftime('%m', Date)
ORDER BY month;


-------------------------------------------------------------------------------------------------------------


-- Querry 11: Check how coronavirus spread out with respect to confirmed cases
SELECT
    COUNT(*) AS total_cases,
    AVG(Confirmed) AS average_confirmed,
    VARIANCE(Confirmed) AS variance_confirmed,
    STDEV(Confirmed) AS stdev_confirmed
FROM
    corona_virus_dataset;

   
-------------------------------------------------------------------------------------------------------------

 
   -- Querry 12: Check how coronavirus spread out with respect to death cases per month
SELECT
    strftime('%m', Date) AS month,
    COUNT(*) AS total_cases,
    AVG(Deaths) AS average_deaths,
    VARIANCE(Deaths) AS variance_deaths,
    STDEV(Deaths) AS stdev_deaths
FROM
    corona_virus_dataset
GROUP BY
    strftime('%m', Date)
ORDER BY
    month;


-------------------------------------------------------------------------------------------------------------
   
   
-- Querry 13: Check how coronavirus spread out with respect to recovered cases (overall analysis)
SELECT
    COUNT(*) AS total_cases,
    AVG(Recovered) AS average_recovered,
    VARIANCE(Recovered) AS variance_recovered,
    STDEV(Recovered) AS stdev_recovered
FROM
    corona_virus_dataset;

   
-------------------------------------------------------------------------------------------------------------
   
   
-- Querry 14: Find the country with the highest number of confirmed cases
SELECT
    "Country/Region",
    MAX(Confirmed) AS max_confirmed_cases
FROM
    corona_virus_dataset;
   
   
-------------------------------------------------------------------------------------------------------------
   
   
-- Querry 15: Find Country having lowest number of the death case
SELECT
    "Country/Region",
    MIN(Deaths) AS min_death_cases
FROM
    corona_virus_dataset; 


-------------------------------------------------------------------------------------------------------------
   
   
-- Querry 16:  Find top 5 countries having highest recovered case
-- The top 5 countries with the highest total number of recovered cases (aggregated across all dates)
SELECT
    "Country/Region",
    SUM(Recovered) AS total_recovered_cases
FROM
    corona_virus_dataset
GROUP BY
    "Country/Region"
ORDER BY
    total_recovered_cases DESC
LIMIT 5;

