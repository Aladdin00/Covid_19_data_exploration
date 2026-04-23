select *
from [project 1]..CovidDeaths
where continent is not null
order by 3,4

--select *
--from [project 1]..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths , population
from [project 1]..CovidDeaths
where continent is not null
order by 1,2


select Location, date, total_cases, total_deaths ,(total_deaths/total_cases)*100 as Deathpercentage
from [project 1]..CovidDeaths
where location like '%Egypt%'
and continent is not null
order by 1,2


select Location, date, total_cases, population ,(total_cases/population)*100 as percentofPopulationInfected
from [project 1]..CovidDeaths
where location like '%Egypt%'
and continent is not null
order by 1,2


select Location,MAX(total_cases)as HighestInfectionCount, population ,Max((total_cases/population))*100 as percentofPopulationInfected
from [project 1]..CovidDeaths
--where location like '%Egypt%'
group by location, population
order by percentofPopulationInfected desc


select Location,MAX(cast (total_deaths as int)) as totaldeathcount
from [project 1]..CovidDeaths
--where location like '%Egypt%'
where continent is not null
group by location
order by totaldeathcount desc


select continent,MAX(cast (total_deaths as int)) as totaldeathcount
from [project 1]..CovidDeaths
--where location like '%Egypt%'
where continent is not null
group by continent
order by totaldeathcount desc


select  Sum(new_cases) as total_cases,Sum(Cast(new_deaths as int)) as total_deaths, Sum(Cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercentage
from [project 1]..CovidDeaths
--where location like '%Egypt%'
where continent is not null
--group by date
order by 1,2


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

--USE CTE

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

-- Temp Table
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

select *
from PercentPopulationVaccinated