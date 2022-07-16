SELECT *	
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
order by 3,4

--Select *	
--FROM PortfolioProject..CovidVaccinations$
--order by 3,4

--Select the data that we are going to be using 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
order by 1,2

--Looking at the Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid
SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE location like '%states%'
order by 1,2

--Looking at the Total Cases vs Population
--Shows what percventage of the population got covid
SELECT location, date, population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
--WHERE location like '%states%'
order by 1,2

--Looking at countries with Highest Infection Rate compared to Population
SELECT location, population,MAX(total_cases)as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
--WHERE location like '%states%'
WHERE continent is not null
GROUP by Population, Location
order by PercentPopulationInfected desc

--Showing Countries with the Highest Death Count per Population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCounts
FROM PortfolioProject..CovidDeaths$
--WHERE location like '%states%'
WHERE continent is not null
GROUP by Location
order by TotalDeathCounts desc

--LET'S BREAK THINGS DOWN BY CONTINENT 
--Showing the Continents with the Highest death count

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCounts
FROM PortfolioProject..CovidDeaths$
--WHERE location like '%states%'
WHERE continent is not null
GROUP by continent
order by TotalDeathCounts desc

-- GLOBAL NUMBERS

SELECT SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths$
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
order by 1,2


--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, dea.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.Location, dea.date) as RollingPeopleVaccinated,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location= vac.location
	and dea.date=vac.date
	WHERE dea.continent is not null
order by 2,3


--Use CTE

With PopvsVac(Continent, Location, Date, Population, New_Vaccinations,RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location,dea.Date)as RollingPeopleVaccinated
--,RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location= vac.location
	and dea.date=vac.date
	WHERE dea.continent is not null
--order by 2,3
)

Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac



---TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location,dea.Date)as RollingPeopleVaccinated
--,RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location= vac.location
	and dea.date=vac.date
	--WHERE dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


---Creating view to store data for later visualization

Create View  PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location,dea.Date)as RollingPeopleVaccinated
--,RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated


