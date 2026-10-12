/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select *
from [project 1]..CovidDeaths
where continent is not null
order by 3,4


-- Select Data that we are going to be starting with

select Location, date, total_cases, new_cases, total_deaths , population
from [project 1]..CovidDeaths
where continent is not null
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths ,(total_deaths/total_cases)*100 as Deathpercentage
from [project 1]..CovidDeaths
where location like '%Egypt%'
and continent is not null
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
select Location, date, total_cases, population ,(total_cases/population)*100 as percentofPopulationInfected
from [project 1]..CovidDeaths
where location like '%Egypt%'
and continent is not null
order by 1,2

-- Countries with Highest Infection Rate compared to Population
  
select Location, MAX(total_cases)as HighestInfectionCount, population ,Max((total_cases/population))*100 as percentofPopulationInfected
from [project 1]..CovidDeaths
--where location like '%Egypt%'
group by location, population
order by percentofPopulationInfected desc

-- Countries with Highest Death Count per Population
  
select Location, MAX(cast (total_deaths as int)) as totaldeathcount
from [project 1]..CovidDeaths
--where location like '%Egypt%'
where continent is not null
group by location
order by totaldeathcount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population
  
select continent, MAX(cast (total_deaths as int)) as totaldeathcount
from [project 1]..CovidDeaths
--where location like '%Egypt%'
where continent is not null
group by continent
order by totaldeathcount desc

  
-- GLOBAL NUMBERS  

select  Sum(new_cases) as total_cases,Sum(Cast(new_deaths as int)) as total_deaths, Sum(Cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercentage
from [project 1]..CovidDeaths
--where location like '%Egypt%'
where continent is not null
--group by date
order by 1,2

  
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
  

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [project 1]..CovidDeaths dea
join [project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With popvsVac (continent, location, date, population,New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [project 1]..CovidDeaths dea
join [project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from popvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query
  
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [project 1]..CovidDeaths dea
join [project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations
  
go
Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from [project 1]..CovidDeaths dea
join [project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
go

-- this is just testing if the table worked 
-- select *
-- from PercentPopulationVaccinated
