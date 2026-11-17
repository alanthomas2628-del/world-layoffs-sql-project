# World Layoffs SQL Project

## Project Overview
This project explores global company layoffs using MySQL. The goal is to clean the dataset and perform Exploratory Data Analysis (EDA) to identify patterns and trends in layoffs across companies, industries, countries, and years.

## Tools Used
- MySQL
- MySQL Workbench
- SQL

## Data Cleaning
The following data-cleaning tasks were performed:
- Identified and removed duplicate records using `ROW_NUMBER()`.
- Standardized company names using `TRIM()`.
- Standardized industry and country values.
- Converted the date column from text to the DATE data type.
- Handled missing and NULL values.
- Populated missing industry values where possible.

## Exploratory Data Analysis (EDA)
The analysis explored:
- Total layoffs by company.
- Layoffs by industry and country.
- Maximum layoffs and percentage of workforce laid off.
- Layoffs by year and month.
- Monthly rolling totals.
- Top five companies by layoffs for each year using `DENSE_RANK()`.

## SQL Concepts Practised
- Aggregate functions (`SUM`, `MAX`, `MIN`)
- `GROUP BY` and `ORDER BY`
- Common Table Expressions (CTEs)
- Window functions
- Joins
- String and date functions
- Data cleaning and EDA

## Project File
The complete SQL queries are available in `World_Layoffs_SQL_Project.sql`.
## Credits
- Tutorial and dataset reference: Alex The Analyst.
