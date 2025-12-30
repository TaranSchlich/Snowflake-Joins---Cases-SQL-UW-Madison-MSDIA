# Joins & CASE Statements SQL (Snowflake)
**By: Taran Schlichtmann**
**Date: 10/22/2025**

[![SQL](https://img.shields.io/badge/SQL-Snowflake-blue)]
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)]
[![License](https://img.shields.io/badge/License-MIT-green)]

---

## Business Context
Perform advanced SQL queries in Snowflake using **CENSUS** database to analyze demographic and geographic data. Tasks include joins, aggregations, and CASE statements to categorize age groups, gender distribution, and educational data. Results exported to Excel with separate tabs for clarity.

---

## Repository Structure
```
.
├── sql/
│   └── Assignment 3 - Joins and Cases.sql
├── outputs/
│   └── GB882_Assignment 3_Schlichtmann_T.xlsx
└── README.md
```

---

## How to Reproduce
1. Create a Snowflake worksheet and select the `CLASSWORK` warehouse and `CENSUS` database.
2. Run queries from `sql/Assignment 3 - Joins and Cases.sql`.
3. Export results to Excel, one sheet per query, as shown in `outputs/GB882_Assignment 3_Schlichtmann_T.xlsx`.

---

## Queries Summary
```sql
/* Query 1: Total population by reporting year */
SELECT reporting_year, SUM(population_total) AS "Total Population" FROM census_by_zip_code GROUP BY reporting_year ORDER BY reporting_year DESC;

/* Query 2: Top 5 counties with most zip codes */
SELECT county, state_name, COUNT(DISTINCT zip_code) AS zip_count FROM zip_codes WHERE county IS NOT NULL GROUP BY county, state_name ORDER BY zip_count DESC LIMIT 5;

/* Query 3: Categorize zip codes by median age */
SELECT ZIP_CODE, MEDIAN_AGE, CASE WHEN POPULATION_TOTAL < 150 THEN 'unable to calculate' WHEN MEDIAN_AGE <= 35 THEN 'young adults' WHEN MEDIAN_AGE > 35 AND MEDIAN_AGE <= 55 THEN 'middle-aged adults' WHEN MEDIAN_AGE > 55 THEN 'older adults' ELSE 'unable to calculate' END AS AGE_CATEGORY FROM census_by_zip_code WHERE REPORTING_YEAR = 2018 ORDER BY ZIP_CODE ASC;

/* Query 4: Count zip codes by age category */
SELECT CASE WHEN MEDIAN_AGE <= 35 THEN 'young adults' WHEN MEDIAN_AGE > 35 AND MEDIAN_AGE <= 55 THEN 'middle-aged adults' WHEN MEDIAN_AGE > 55 THEN 'older adults' END AS AGE_CATEGORY, COUNT(*) AS ZIP_CODE_COUNT FROM census_by_zip_code WHERE REPORTING_YEAR = 2018 AND POPULATION_TOTAL >= 150 AND MEDIAN_AGE IS NOT NULL GROUP BY CASE WHEN MEDIAN_AGE <= 35 THEN 'young adults' WHEN MEDIAN_AGE > 35 AND MEDIAN_AGE <= 55 THEN 'middle-aged adults' WHEN MEDIAN_AGE > 55 THEN 'older adults' END;

/* Query 5: Gender distribution classification */
SELECT ZIP_CODE, ROUND(POPULATION_FEMALE * 1.0 / POPULATION_TOTAL, 2) AS GENDER_DISTRIBUTION, CASE WHEN POPULATION_FEMALE * 1.0 / POPULATION_TOTAL > 0.60 THEN 'predominantly female' WHEN POPULATION_FEMALE * 1.0 / POPULATION_TOTAL < 0.40 THEN 'predominantly male' ELSE 'evenly distributed' END AS GENDER_DISTRIBUTION_CLASSIFICATION FROM census_by_zip_code WHERE REPORTING_YEAR = 2018 AND POPULATION_TOTAL >= 1000 ORDER BY ZIP_CODE ASC;

/* Query 6: Children in grades 1-8 by state and county */
SELECT ZIP_CODES.STATE_NAME, ZIP_CODES.COUNTY, SUM(CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_1_TO_4 + CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_5_TO_8) AS TOTAL_CHILDREN_GRADES_1_TO_8 FROM CENSUS_BY_ZIP_CODE JOIN ZIP_CODES ON CENSUS_BY_ZIP_CODE.ZIP_CODE = ZIP_CODES.ZIP_CODE WHERE CENSUS_BY_ZIP_CODE.REPORTING_YEAR = 2018 GROUP BY ZIP_CODES.STATE_NAME, ZIP_CODES.COUNTY HAVING SUM(CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_1_TO_4 + CENSUS_BY_ZIP_CODE.CHILDREN_IN_GRADES_5_TO_8) >= 100000 ORDER BY ZIP_CODES.STATE_NAME ASC;
```

---

## Key Results
- Total population in 2018: **326,274,356**
- Zip codes in Los Angeles County: **284**
- Age category for zip code 10003: **young adults**
- Zip codes categorized as young adults: **5,339**
- Female population % in zip code 10004: **0.58**
- Children in grades 1-8 in Maricopa County, AZ: **400,897**

---

## License
MIT — Educational use only.
