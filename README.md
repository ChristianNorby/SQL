# 🧹 SQL Data Cleaning Company Layoffs
Date: July 2025

Files: 
- Data Cleaning Company Layoffs Project (Part 1)
- Data Cleaning Company Layoffs Project (Part 2)
# 📌 Project Overview
You start with a messy layoffs dataset (mixed date formats, inconsistent categories like “United States.” vs “United States”, “Crypto” variants, stray whitespace, potential dupes, blanks). The project goal is to turn that raw file into an analysis-ready table by:
- 1 Staging the raw data
- 2 Deduplicating
- 3 Standardizing strings and dates
- 4 Resolving NULL/blank values
- 5 Dropping helper columns—then finishing with a short EDA pass (top companies, countries, industries, yearly totals, rolling totals).

# 🛠 Tools & Skills Used
- MySQL (window functions, CTEs, STR_TO_DATE, DATE types)
- SQL client/IDE (e.g., MySQL Workbench) to import CSV and run queries
- Spreadsheet/CSV loader for the initial import and quick sanity checks

# 🧠 Skills demonstrated

- Data staging & protection: CREATE TABLE … LIKE … + INSERT … SELECT … to work on a copy (so the raw stays intact).
- Deduplication with window functions: ROW_NUMBER() OVER (PARTITION BY …) to mark and delete duplicate rows.
- Text standardization: TRIM, TRAILING '.', category normalization (e.g., force “Crypto”).
- Date normalization: STR_TO_DATE(...) + ALTER … DATE for type safety and consistent YYYY-MM-DD.
- NULL/blank handling: converting empty strings to NULL; self-join to backfill missing industry from other rows of the same company.
- Data pruning: removing rows with no layoff info (both total_laid_off and percentage_laid_off null).
- Exploratory analysis: top layoffs by company, country, industry, year; full-layoff counts; rolling totals with a CTE and window function.

# Snippet of Raw Excel CSV Data
<img width="950" height="702" alt="image" src="https://github.com/user-attachments/assets/808c9c02-5fd5-422c-bb8a-08282c622a74" />
