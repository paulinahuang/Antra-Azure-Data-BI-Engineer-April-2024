--1. What a way to start https://www.wiseowl.co.uk/sql/exercises/standard/simple-queries/4100/
USE WorldEvents

select e.EventName, e.EventDate
from tblEvent as e
order by e.EventDate desc;

--2. Singular episodes https://www.wiseowl.co.uk/sql/exercises/standard/views/4041/
use DoctorWho
---vwEpisodeCompanion	Llist all of the episodes which had only a single companion.
create view vwEpisodeCompanion as
select e.EpisodeId, e.Title ,count(*) as "num of companion"
from tblEpisodeCompanion as ec
join tblEpisode as e
on e.EpisodeId = ec.EpisodeId
group by e.EpisodeId, e.Title
having count(*) = 1;

select * from vwEpisodeCompanion;

---vwEpisodeEnemy	List all of the episodes which had only a single enemy.
create view vwEpisodeEnemy as
select e.EpisodeId, e.Title, count(*) as "num of enemy"
from tblEpisode as e
join tblEpisodeEnemy as ee
on e.EpisodeId= ee.EpisodeId
group by e.EpisodeId, e.Title
having count(*) = 1;

select * from vwEpisodeEnemy

---vwEpisodeSummary	List all of the episodes which have no corresponding rows in either the vwEpisodeCompanion or vwEpisodeEnemy tables.
create view vwEpisodeSummary as 
select e.EpisodeId, e.Title
from tblEpisode as e
left join vwEpisodeEnemy as vwee
on e.EpisodeId = vwee.EpisodeId
left join vwEpisodeCompanion as vwec
on e.EpisodeId = vwec.EpisodeId
where vwee.EpisodeId is null and vwec.EpisodeId is null;

select * from vwEpisodeSummary

--3. Game Of Thrones https://www.wiseowl.co.uk/sql/exercises/standard/transactions/4226/
use WorldEvents

--4. Last 3 categories https://www.wiseowl.co.uk/sql/exercises/standard/simple-queries/4101/
select top 3 c.CategoryID, c.CategoryName
from tblCategory as c
order by c.CategoryName desc;

--5. Post-Int Notes https://www.wiseowl.co.uk/sql/exercises/standard/subqueries/4132/
select e.EventName, e.EventDate, c.CountryName
from tblEvent as e
join tblCountry as c
on e.CountryID = c.CountryID
where e.EventDate > (select max(e.EventDate) from tblEvent as e where e.CountryID = 21)
order by e.EventDate desc;

--6. Generate genres https://www.wiseowl.co.uk/sql/exercises/standard/creating-tables/1789/
---https://www.w3schools.com/sql/sql_autoincrement.asp
use Books

create table tblGenre (
	GenreID int identity(1,1) primary key,
	GenreName varchar(20) not null,
	Rating int
);

insert into tblGenre (GenreName, Rating)
values('Romance', 3);

insert into tblGenre (GenreName, Rating)
values('Science Fiction', 7);

insert into tblGenre (GenreName, Rating)
values('Thriller', 5);

insert into tblGenre (GenreName, Rating)
values('Humour', 3);

select * from tblGenre;

PRINT ''
PRINT 'Last one added was number ' + CAST(@@IDENTITY AS varchar(5))
PRINT ''


--7. The dawn of history https://www.wiseowl.co.uk/sql/exercises/standard/simple-queries/4102/
use WorldEvents

select * from tblEvent

select top 5 e.EventName as What, e.EventDetails as Details
from tblEvent as e
order by e.EventDate asc;


--8. More words, more important https://www.wiseowl.co.uk/sql/exercises/standard/subqueries/4227/
select * from tblEvent

select e.EventName
from tblEvent as e
where len(e.EventName) > (select avg(len(e.EventName)) from tblEvent as e)
group by e.EventName;


--9. Going Places https://www.wiseowl.co.uk/sql/exercises/standard/creating-tables/4230/


--10. How times change https://www.wiseowl.co.uk/sql/exercises/standard/simple-queries/4103/
SET NOCOUNT ON 

select top 2 e.EventName as What, e.EventDate as "When"
from tblEvent as e
order by e.EventDate asc;

select top 2 e.EventName as What, e.EventDate as "When"
from tblEvent as e
order by e.EventDate desc;


--11. Eventful countries https://www.wiseowl.co.uk/sql/exercises/standard/subqueries/4133/
---Using Having
select c.CountryName
from tblCountry as c
join tblEvent as e
on c.CountryID = e.CountryID
group by c.CountryName
having count(e.EventID) >8
order by c.CountryName asc;

---Using subquery 
select c.CountryName
from tblCountry as c
where (
	select count(*)
	from tblEvent as e
	where c.CountryID = e.CountryID
) > 8
order by c.CountryName asc;


--12. Continental Counting https://www.wiseowl.co.uk/sql/exercises/standard/creating-tables/4229/
select * from tblContinent
select * from tblCountry
select * from tblEvent

select 
	ContinentName
	,Count(DISTINCT(c2.CountryID)) AS [Countries in Continent]
	,Count(DISTINCT(e.EventID)) AS [Events in Continent]
	,Min(e.EventDate) AS [Earliest continent event]
	,Max(e.EventDate) AS [Lastest continent event]
INTO Continent_Summary
from tblContinent as c1
join tblCountry as c2
on c1.ContinentID = c2.ContinentID
join tblEvent as e
on c2.CountryID = e.CountryID
group by ContinentName

select * from Continent_Summary


--13. Love, actually https://www.wiseowl.co.uk/sql/exercises/standard/setting-criteria-using-where/4104/
select * from tblEvent
select * from tblCategory

select e.EventName, e.EventDate
from tblEvent as e
join tblCategory as c
on e.CategoryID = c.CategoryID
where c.CategoryID =11;


--14. Quiet places to visit https://www.wiseowl.co.uk/sql/exercises/standard/subqueries/4228/
select top 3 c1.ContinentName
from tblContinent as c1
join tblCountry as c2
on c1.ContinentID = c2.ContinentID
join tblEvent as e
on c2.CountryID = e.CountryID
group by c1.ContinentName
order by count(e.EventID) asc;

select c1.ContinentName, e.EventName
from tblContinent as c1
join tblCountry as c2
on c1.ContinentID = c2.ContinentID
join tblEvent as e
on c2.CountryID = e.CountryID
where c1.ContinentName in (
	select top 3 c1.ContinentName
	from tblContinent as c1
	join tblCountry as c2
	on c1.ContinentID = c2.ContinentID
	join tblEvent as e
	on c2.CountryID = e.CountryID
	group by c1.ContinentName
	order by count(e.EventID) asc
);


--15. Manual would have been quicker https://www.wiseowl.co.uk/sql/exercises/standard/creating-tables/3980/
BEGIN TRY
	DROP TABLE tblProductionCompany
END TRY
BEGIN CATCH
END CATCH
GO

Create TABLE tblProductionCompany(
	ProductionCompanyId int IDENTITY(1,1) PRIMARY KEY,
	ProductionCompanyName varchar(100),
	Abbreviation varchar(10)
);

INSERT INTO tblProductionCompany (ProductionCompanyName,Abbreviation) 
VALUES ('British Broadcasting Corporation','BBC');

INSERT INTO tblProductionCompany (ProductionCompanyName,Abbreviation) 
VALUES ('Canadian Broadcasting Corporation','CBC');

select * from tblProductionCompany;


--16. Looby La La https://www.wiseowl.co.uk/sql/exercises/standard/setting-criteria-using-where/4105/
select e.EventName, e.EventDate
from tblEvent as e
where e.EventName like '%Teletubbies%' or e.EventName like '%Pandy%';


--17. Early events https://www.wiseowl.co.uk/sql/exercises/standard/subqueries/4134/
select e.EventName, e.EventDetails
from tblEvent as e
where e.CountryID not in (
	select a.CountryID
	from (
		select distinct top 30 e.CountryID, c.CountryName
		from tblEvent as e 
		join tblCountry as c
		on e.CountryID = c.CountryID
		order by c.CountryName desc
	) as a
) and e.CategoryID not in (
	select b.CategoryID
	from (
	select distinct top 15 ct.CategoryID, ct.CategoryName
		from tblEvent as e
		join tblCategory as ct
		on e.CategoryID = ct.CategoryID
		order by ct.CategoryName desc
	) as b
)
order by e.EventDate;