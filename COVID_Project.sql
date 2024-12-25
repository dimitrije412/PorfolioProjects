Select *
From [Portfolio Project]..CovidDeaths2
Where continent is not null
order by 3,4

--Select Location, date, total_cases, new_cases, total_deaths, population
--From [Portfolio Project]..CovidDeaths2
--order by 1,2

--Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, 100*(total_deaths*1.0 /total_cases) as DeathPercentage
From [Portfolio Project]..CovidDeaths2
Where location like 'Serbia'
and continent is not null
order by 1,2

--Infected Population

Select Location, date, total_cases, Population, 100*(total_cases*1.0 /Population) as PopulationInfectedPercentage
From [Portfolio Project]..CovidDeaths2
Where location like 'Serbia'
and continent is not null
order by 1,2

--Highest Infected Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, 100*MAX((total_cases*1.0 /Population)) as PopulationInfectedPercentage
From [Portfolio Project]..CovidDeaths2
Where continent is not null
Group by Location, Population
order by PopulationInfectedPercentage desc

--Death Count

Select Location, Max(total_deaths) as TotalDeathCount
From [Portfolio Project]..CovidDeaths2
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Highest Death Count

Select continent, Max(total_deaths) as TotalDeathCount
From [Portfolio Project]..CovidDeaths2
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 1.0*SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths2
Where continent is not null
Group by date
order by 1,2

--Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations as int)) OVER  (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths2 dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Using CTE

--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--SUM(CAST(vac.new_vaccinations as int)) OVER  (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
----,(RollingPeopleVaccinated/population)*100
--From [Portfolio Project]..CovidDeaths2 dea
--Join [Portfolio Project]..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
----order by 2,3
--)
--Select *, 1.0*(RollingPeopleVaccinated/Population)*100
--From PopvsVac


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations as int)) OVER  (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths2 dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, 1.0*(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations as int)) OVER  (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths2 dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3