SELECT *
FROM portfolio_project..covid_deaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM portfolio_project..covid_vaccinations

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM portfolio_project..covid_deaths
ORDER BY 1,2


--Total Cases Vs Total Deaths
--Shows likelihood of dying due to COVID in India

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM portfolio_project..covid_deaths
WHERE location = 'India'
ORDER BY 1,2


--Total Cases VS Population
--What % of population got COVID

SELECT location, date, total_cases, population, (total_cases/population)*100 AS percent_population_infected
FROM portfolio_project..covid_deaths
WHERE location = 'India'
ORDER BY 1,2



--Looking at countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS percent_population_infected
FROM portfolio_project..covid_deaths
GROUP BY location, population
ORDER BY percent_population_infected DESC


--Showing countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM portfolio_project..covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC



--Continent's with highest death counts

SELECT continent, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM portfolio_project..covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC



--Total Population VS Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM portfolio_project..covid_deaths AS dea
JOIN portfolio_project..covid_vaccinations AS vac
    ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Use CTE

With pop_vs_vac (continent, location, data, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated 
FROM portfolio_project..covid_deaths AS dea
JOIN portfolio_project..covid_vaccinations AS vac
    ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
SELECT*, (rolling_people_vaccinated/population)*100
FROM pop_vs_vac


--Creating View

CREATE VIEW percent_population_vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated 
FROM portfolio_project..covid_deaths AS dea
JOIN portfolio_project..covid_vaccinations AS vac
    ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

SELECT*
FROM percent_population_vaccinated




