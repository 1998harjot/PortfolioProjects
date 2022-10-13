----lets break things down by continent

select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject.. coviddeaths
where continent is not null
group by continent 
order by  TotalDeathCount desc

--sort by location

select location, Max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject.. coviddeaths
where continent is null
group by location
order by  TotalDeathCount desc


--showing contintents with highest death count per population

select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject.. coviddeaths
where continent is not null
group by continent
order by  TotalDeathCount desc


--global numbers

select date, SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths,  Sum(cast(new_deaths as int))/SUM(new_cases) as DeathPercentage
from coviddeaths
where continent is not null
group by date
order by 1,2

select  SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths,  Sum(cast(new_deaths as int))/SUM(new_cases) as DeathPercentage
from coviddeaths
where continent is not null
--group by date
order by 1,2

select*
from coviddeaths dea
join covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date


---looking at total populaion vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast(vac.new_vaccinations as bigint) ) OVER (partition by dea.Location order by dea.location, dea.Date)
as RollingPeopleVaccinated,
---*(RollingPeopleVaccinated/Population)*100
from coviddeaths dea
join covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not  null
order by 2,3


-- use city
with PopvsVac (continents, Location,date, population, new_vaccinations, RollingPeopleVaccinated)
as
(

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast(vac.new_vaccinations as bigint) ) OVER (partition by dea.Location order by dea.location, dea.Date)
as RollingPeopleVaccinated
---*(RollingPeopleVaccinated/Population)*100
from coviddeaths dea
join covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not  null
--order by 2,3 
)
select*, (RollingPeopleVaccinated/population)*100
from popvsvac



-- tem table
drop table  percentpopulationvaccinated
create table percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

insert into percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast(vac.new_vaccinations as bigint) ) OVER (partition by dea.Location order by dea.location, dea.Date)
as RollingPeopleVaccinated
---*(RollingPeopleVaccinated/Population)*100
from coviddeaths dea
join covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not  null
--order by 2,3 


select*, (RollingPeopleVaccinated/population)*100
from 
 percentpopulationvaccinated


 --creating view store data for later visualization

 create view  ppercentpopulationvaccinated as
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast(vac.new_vaccinations as bigint) ) OVER (partition by dea.Location order by dea.location, dea.Date)
as RollingPeopleVaccinated
---*(RollingPeopleVaccinated/Population)*100
from coviddeaths dea
join covidvacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not  null
--order by 2,3 


select*
from 
 ppercentpopulationvaccinated