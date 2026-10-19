# 🦠 COVID-19 Data Exploration with SQL

> A SQL Server analysis of global COVID-19 case, death and vaccination data, covering infection rates, mortality, and vaccination progress by country and continent.

![SQL Server](https://img.shields.io/badge/SQL%20Server-T--SQL-CC2927)
![Status](https://img.shields.io/badge/status-complete-brightgreen)
![Focus](https://img.shields.io/badge/focus-data%20exploration-blue)

## Overview

This project explores COVID-19 data using T-SQL to answer practical questions about the pandemic:

- How likely was a person to die after contracting COVID-19 in a given country?
- What share of each country's population was infected?
- Which countries and continents had the highest infection rates and death counts?
- How quickly did vaccination roll out, and what percentage of each population was vaccinated?

The final query is saved as a **SQL view**, ready to plug into a visualization tool such as Tableau or Power BI.

## Skills Demonstrated

| Skill | Where it's used |
|-------|-----------------|
| **Joins** | Combining the deaths and vaccinations tables on location and date |
| **CTEs** | Calculating vaccination percentage on top of a window-function result |
| **Temp tables** | Storing intermediate results for further calculation |
| **Window functions** | Rolling (cumulative) vaccination totals with `SUM() OVER (PARTITION BY ... ORDER BY ...)` |
| **Aggregate functions** | `MAX`, `SUM` for infection counts, death counts and global totals |
| **Views** | Saving a reusable dataset for visualization |
| **Data type conversion** | `CAST` and `CONVERT` to handle numeric columns stored as text |

## Dataset

Two tables in a SQL Server database named `project 1`:

- **`CovidDeaths`**: location, continent, date, population, total/new cases, total/new deaths
- **`CovidVaccinations`**: location, date, new vaccinations

> Data source: Our World in Data COVID-19 dataset. *(Update this line if you used a different source.)*

## Analysis Breakdown

### 1. Total cases vs. total deaths
Calculates the death percentage (`total_deaths / total_cases × 100`) over time, which estimates the likelihood of dying if infected. Filtered to **Egypt** as a case study.

### 2. Total cases vs. population
Shows the percentage of the population that was infected over time, also filtered to Egypt.

### 3. Highest infection rate by country
Ranks countries by the peak percentage of their population infected.

### 4. Highest death count by country
Ranks countries by total deaths, with `total_deaths` cast to an integer.

### 5. Breakdown by continent
Compares continents by total death count.

### 6. Global numbers
Aggregates worldwide new cases and new deaths to compute the overall global death percentage.

### 7. Population vs. vaccinations
Joins deaths and vaccinations and uses a window function to compute a **rolling total of people vaccinated** per country.

### 8. CTE and temp table
Two approaches to calculate the percentage of each population vaccinated, since a window-function alias can't be reused in the same `SELECT`.

### 9. View for visualization
`PercentPopulationVaccinated` stores the final dataset for later use in dashboards.

## Sample Query

```sql
-- Rolling vaccination count per country
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(int, vac.new_vaccinations))
           OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM [project 1]..CovidDeaths dea
JOIN [project 1]..CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;
```

## Getting Started

### Prerequisites
- Microsoft Excel
- Microsoft SQL Server
- SQL Server Management Studio (SSMS) or Azure Data Studio

### Setup
1. Import `CovidDeaths` and `CovidVaccinations` Excel sheets into a database (the script uses one named `project 1`; update the name if yours differs).
2. Open `SQLQuery1_Project_1.sql` in SSMS.
3. Run the queries section by section to see each result.

## Project Structure

```
├── SQLQuery1_Project_1.sql   # All queries
├── data/                     # Source data (optional)
└── README.md
```

## Key Takeaways

- Death percentage and infection percentage can be tracked over time for any country
- Window functions make cumulative metrics like vaccination progress straightforward
- CTEs and temp tables are both valid ways to build on a window-function result; the choice depends on whether the intermediate data needs to be reused
- Saving results as a view separates the analysis from the visualization layer

## Next Steps

- Build a Tableau or Power BI dashboard on top of the `PercentPopulationVaccinated` view
- Compare Egypt against regional neighbors
- Add analysis of vaccination rate vs. death rate over time

## Contact

**Ali Eldin Mohamed** · [LinkedIn](https://www.linkedin.com/in/alieldin190) · alyshaker2004@gmail.com
