/* Calculating total population by reporting year and ordering results by year with most recent year first */
SELECT
    reporting_year,
    SUM(population_total) AS "Total Population"
FROM
    census_by_zip_code
GROUP BY 
    reporting_year
ORDER BY
    reporting_year DESC;

/* Listing top 5 counties with the most zip codes. Results include county and state. Exlcuding null counties. Listing the top 5 counties from the most to the fewest number of zip codes */


SELECT 
    county, 
    state_name, 
    COUNT(DISTINCT zip_code) AS zip_count
FROM 
    zip_codes
WHERE 
    county IS NOT NULL
GROUP BY 
    county, state_name
ORDER BY 
    zip_count DESC
LIMIT 5;

/* Listing all zip codes, and in a new column, categorizing zip codes based on their median age in 2018. Categories are "young adults" (median age <= 35), "middle-aged adults" (median age > 35 and <= 55), and "older adults" (median age > 55). If there are fewer than 150 people in the zip code, recording "unable to calculate". Results only show the zip code, median age, and age category -- and sort by zip codes in ascending order. */


SELECT 
    ZIP_CODE,
    MEDIAN_AGE,
    CASE 
        WHEN POPULATION_TOTAL < 150 THEN 'unable to calculate'
        WHEN MEDIAN_AGE <= 35 THEN 'young adults'
        WHEN MEDIAN_AGE > 35 AND MEDIAN_AGE <= 55 THEN 'middle-aged adults'
        WHEN MEDIAN_AGE > 55 THEN 'older adults'
        ELSE 'unable to calculate'
    END AS AGE_CATEGORY
FROM 
    census_by_zip_code
WHERE 
    REPORTING_YEAR = 2018
ORDER BY 
    ZIP_CODE ASC;

/* Couting the number of zip codes in the age categories of "young adults" (median age <= 35), "middle-aged adults" (median age > 35 and <= 55), and "older adults" (median age > 55). Only using the 2018 reporting year. Results to only show age category and number of zip codes. */


SELECT 
    CASE 
        WHEN MEDIAN_AGE <= 35 THEN 'young adults'
        WHEN MEDIAN_AGE > 35 AND MEDIAN_AGE <= 55 THEN 'middle-aged adults'
        WHEN MEDIAN_AGE > 55 THEN 'older adults'
    END AS AGE_CATEGORY,
    COUNT(*) AS ZIP_CODE_COUNT
FROM 
    census_by_zip_code
WHERE 
    REPORTING_YEAR = 2018
    AND POPULATION_TOTAL >= 150
    AND MEDIAN_AGE IS NOT NULL
GROUP BY 
    CASE 
        WHEN MEDIAN_AGE <= 35 THEN 'young adults'
        WHEN MEDIAN_AGE > 35 AND MEDIAN_AGE <= 55 THEN 'middle-aged adults'
        WHEN MEDIAN_AGE > 55 THEN 'older adults'
    END;


/* Listing all zip codes along with a column that classifies gender distribution in 2018. Calculated distribution by taking the female population divided by the total population. For classification, if the % female is greater than 60% then called "predominantly female". If it is below 40%, then called "predominantly male." For everything else, inputed as "evenly distributed". Results include the zip code, gender distribution (%), and the gender distribution classification. Final results only include zip codes with a total population of at least 1000 people and sorted by the zip code in ascending order. */


SELECT 
    ZIP_CODE,
    ROUND(POPULATION_FEMALE * 1.0 / POPULATION_TOTAL, 2) AS GENDER_DISTRIBUTION,
    CASE 
        WHEN POPULATION_FEMALE * 1.0 / POPULATION_TOTAL > 0.60 THEN 'predominantly female'
        WHEN POPULATION_FEMALE * 1.0 / POPULATION_TOTAL < 0.40 THEN 'predominantly male'
        ELSE 'evenly distributed'
    END AS GENDER_DISTRIBUTION_CLASSIFICATION
FROM 
    census_by_zip_code
WHERE 
    REPORTING_YEAR = 2018
    AND POPULATION_TOTAL >= 1000
    AND POPULATION_FEMALE IS NOT NULL
    AND POPULATION_TOTAL IS NOT NULL
ORDER BY 
    ZIP_CODE ASC;

/* Sum the children in grades 1-8 by state and county in 2018. Results include the state name, county name, and total children in grades 1-8. When joining the tables, set the census data table as the "left table" and only select matching records between the two tables. Ordered by the state name and county name alphabetically and only included counties with at least 100,000 children in these grades. */

SELECT 
    ZIP_CODES.STATE_NAME,
    ZIP_CODES.COUNTY,
    SUM(CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_1_TO_4 + CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_5_TO_8) AS TOTAL_CHILDREN_GRADES_1_TO_8
FROM 
    CENSUS_BY_ZIP_CODE
JOIN 
    ZIP_CODES ON CENSUS_BY_ZIP_CODE.ZIP_CODE = ZIP_CODES.ZIP_CODE
WHERE 
    CENSUS_BY_ZIP_CODE.REPORTING_YEAR = 2018
GROUP BY 
    ZIP_CODES.STATE_NAME, ZIP_CODES.COUNTY
HAVING 
    SUM(CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_1_TO_4 + CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_5_TO_8) >= 100000
ORDER BY 
    ZIP_CODES.STATE_NAME ASC;

    