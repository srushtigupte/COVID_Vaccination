Select *
From PortfolioProject.coviddeaths
order by 3,4;

SELECT location, date, total_cases, new_cases, population
FROM PortfolioProject.coviddeaths
ORDER BY 1, 2;

-- Total cases v/s total death
-- Likelihood of death by covid by date
SELECT location, date, total_cases, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE location = "United States"
ORDER BY 1, 2;

-- Total cases v/s total death
-- Likelihood of death by covid by date
SELECT location, date, total_cases, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE location = "United States"
ORDER BY 1, 2;

-- Total cases v/s population
-- Percentage of infection rate
SELECT location, date, total_cases, (total_cases/population)*100 AS PopulationInfectedPercentage
FROM PortfolioProject.coviddeaths
ORDER BY 1, 2;

-- Countries with Highest Infection Rate compared to Population
SELECT location, max(total_cases) AS HighestInfectionCount, max((total_cases/population)*100) AS HighestInfectionPercentage
FROM PortfolioProject.coviddeaths
GROUP BY location
ORDER BY HighestInfectionPercentage desc;

-- Highest count of deaths by countries
SELECT location, max(total_deaths) AS HighestDeaths
FROM PortfolioProject.coviddeaths
WHERE continent <> ""
GROUP BY location
ORDER BY HighestDeaths desc;

-- Exploring by Continent
-- Continents with highest death count
SELECT location, max(total_deaths) AS HighestDeaths
FROM PortfolioProject.coviddeaths
WHERE continent = "" AND location <> "High Income" AND location <> "Low Income"
GROUP BY location
ORDER BY HighestDeaths desc;

-- Exploring global data
SELECT date, sum(new_cases) AS TotalCases, sum(new_deaths) AS TotalDeaths, (sum(new_deaths)/sum(new_cases))*100 AS GlobalDeathPercentage
FROM PortfolioProject.coviddeaths
GROUP BY date
ORDER BY 1;

-- Total population and vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RunningTotalVaccination
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
	ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent <> "" AND dea.location <> "High Income" AND dea.location <> "Low Income"
ORDER BY 1,2;

-- Using CTE
WITH PopvsVac (Continent, Location, Date, Population, NewVaccination, RunningTotalVaccination)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RunningTotalVaccination
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
	ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent <> "" AND dea.location <> "High Income" AND dea.location <> "Low Income"
ORDER BY 1,2
)
SELECT *, (RunningTotalVaccination/Population)*100 AS VaccinatedPopPercentage
FROM PopvsVac;