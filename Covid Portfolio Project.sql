SELECT *
FROM coviddeaths
WHERE continent != ''
ORDER BY continent;

-- SELECT *
-- FROM covidvaccinations
-- ORDER BY 3,4;

-- Select the preferred Data
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY location;

-- Total Cases vs Total Deaths 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE location like '%Nigeria%'
ORDER BY location;

-- Total Cases vs Population
-- To see percentage of population that got Covid
SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeaths
-- WHERE location like '%Nigeria%'
ORDER BY location;

-- Highest infection rate per population of each country
SELECT location, population, MAX(total_cases), MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM coviddeaths
-- WHERE location like '%Nigeria%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Highest death count per population 
SELECT location, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM coviddeaths
WHERE continent != ''
GROUP BY location
ORDER BY totaldeathcount DESC;

SELECT location, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM coviddeaths
WHERE continent = ''
GROUP BY location
ORDER BY totaldeathcount DESC;

-- SHOWING CONTINENT WITH HIGHEST DEATH COUNT
SELECT continent, MAX(CAST(total_deaths AS float)) AS HighestDeathCount
FROM coviddeaths
WHERE continent != ''
GROUP BY continent
ORDER BY totaldeathcount DESC;

-- GLOBAL NUMBERS PER DAY
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_death, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
-- WHERE location like '%Nigeria%'
WHERE continent != ''
GROUP BY date
ORDER BY date;

-- GLOBAL NUMBERS TOTAL
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_death, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
-- WHERE location like '%Nigeria%'
WHERE continent != ''
ORDER BY total_cases, total_death;

-- TOTAL POPULATION vs VACCINATIONS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent !=''
ORDER BY dea.location, dea.date;

-- USE CTE to get the RollingPeopleVaccinated percentage
WITH PopvsVac AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent !=''
-- ORDER BY dea.location, dea.date
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
	ON dea.lopercentpopulationvaccinatedcation = vac.location
    AND dea.date = vac.date
WHERE dea.continent !=''
-- ORDER BY dea.location, dea.date
;

SELECT *
FROM TotalCasesDeathPercent;

CREATE VIEW TotalCasesDeathPercent AS
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_death, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM coviddeaths
-- WHERE location like '%Nigeria%'
WHERE continent != ''
ORDER BY total_cases, total_death;
