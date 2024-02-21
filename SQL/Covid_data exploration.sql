select *
from CovidDeath$
order by 3, 4

select *
from CovidVaccinations$
order by 3, 4


select location, date, total_cases, new_cases, total_deaths, population
from CovidDeath$
order by 1, 2


-- total cases vs total deaths
select location, date, total_cases, total_deaths, (convert(float,total_deaths)/convert(float, total_cases))*100 as DeathPercentage
from CovidDeath$
order by 1, 2


-- total case vs population
select location, date, total_cases, population, (convert(float, total_cases)/convert(float, population))*100 as InfectedPopulationPercentage
from CovidDeath$
order by 1, 2


-- infection rate over different countries
select location, population, max(total_cases) as HighestInfectionCount, max((convert(float,total_cases)/convert(float, population)))*100 as InfectedPopulationPercentage
from PortfolioProject.dbo.CovidDeath$
group by location, population
order by InfectedPopulationPercentage desc



-- highest death count per population
select location, max(cast(total_deaths as int)) as totalDeathCount
from CovidDeath$
where continent is not null
group by location, population
order by totalDeathCount desc



-- continental analysis
select continent, max(cast(total_deaths as int)) as totalDeathCount
from CovidDeath$
where continent is not null
group by continent
order by totalDeathCount desc


-- global analysis
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) total_death, (sum(cast(new_deaths as int))/sum(new_cases))*100 as newDeathReate
from CovidDeath$
where continent is not null
--group by date
order by 1, 2


--vaccination

select *
from CovidVaccinations$



select da.continent, da.location, da.date, da.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by da.location order by da.location, da.date) as RollingPeopleVaccinated
from CovidDeath$ da
join CovidVaccinations$ vac
	on da.location = vac.location 
	and da.date = vac.date
where da.continent is not null
order by 2, 3



-- CTE
with PopulationVsVaccination(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select da.continent, da.location, da.date, da.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by da.location order by da.location, da.date) as RollingPeopleVaccinated
from CovidDeath$ da
join CovidVaccinations$ vac
	on da.location = vac.location 
	and da.date = vac.date
where da.continent is not null
--order by 2, 3
)

select *, (RollingPeopleVaccinated/Population)*100
from PopulationVsVaccination


-- temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select da.continent, da.location, da.date, da.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by da.location order by da.location, da.date) as RollingPeopleVaccinated
from CovidDeath$ da
join CovidVaccinations$ vac
	on da.location = vac.location 
	and da.date = vac.date
--where da.continent is not null
--order by 2, 3


select *
from #PercentPopulationVaccinated


-- view for visualization
create view PercentPopulationVaccinated as
select da.continent, da.location, da.date, da.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) over (partition by da.location order by da.location, da.date) as RollingPeopleVaccinated
from CovidDeath$ da
join CovidVaccinations$ vac
	on da.location = vac.location 
	and da.date = vac.date
where da.continent is not null
--order by 2, 3

select *
from PercentPopulationVaccinated
