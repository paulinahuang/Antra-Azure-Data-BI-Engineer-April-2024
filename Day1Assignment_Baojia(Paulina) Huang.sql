USE AdventureWorks2022

--Day1 Assignment
--1. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, with no filter. 
select ProductID, Name, Color, ListPrice
from Production.Product;

--2. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, excludes the rows that ListPrice is 0.
select ProductID, Name, Color, ListPrice
from Production.Product
where ListPrice != 0;

--3. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are NULL for the Color column.
select ProductID, Name, Color, ListPrice
from Production.Product
where Color is null;

--4. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the Color column.
select ProductID, Name, Color, ListPrice
from Production.Product
where Color is not null;

--5. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
select ProductID, Name, Color, ListPrice
from Production.Product
where Color is not null and ListPrice > 0;

--6. Write a query that concatenates the columns Name and Color from the Production.Product table by excluding the rows that are null for color.
select Name + ': ' + Color
from Production.Product
where Color is not null;

--7. Write a query that generates the following result set from Production.Product: NAME: LL Crankarm  --  COLOR: Black
select 'NAME: '+ Name+' -- COLOR: '+ Color
from Production.Product
where Color is not null;

--8. Write a query to retrieve the to the columns ProductID and Name from the Production.Product table filtered by ProductID from 400 to 500
select ProductID, Name
from Production.Product
where ProductID between 400 and 500;

--9. Write a query to retrieve the to the columns  ProductID, Name and color from the Production.Product table restricted to the colors black and blue
select ProductID, Name, Color
from Production.Product
where Color = 'black' or Color = 'blue';

--10. Write a query to get a result set on products that begins with the letter S. 
select Name, ListPrice
from Production.Product
where name like 'S%';

--11. Write a query that retrieves the columns Name and ListPrice from the Production.Product table. 
--Your result set should look something like the following. Order the result set by the Name column. 
select Name, ListPrice
from Production.Product
where name like 'S%'
order by Name;

--12. Write a query that retrieves the columns Name and ListPrice from the Production.Product table. 
--Your result set should look something like the following. Order the result set by the Name column. The products name should start with either 'A' or 'S'
select Name, ListPrice
from Production.Product
where name like 'S%' or name like 'A%'
order by Name;

--13. Write a query so you retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. 
--After this zero or more letters can exists. Order the result set by the Name column.
select Name, ListPrice
from Production.Product
where name like 'SPO%' and name not like 'SPOK%'
order by Name;

--14. Write a query that retrieves unique colors from the table Production.Product. Order the results  in descending  manner
select distinct Color
from Production.Product
order by Color desc;

--15. Write a query that retrieves the unique combination of columns ProductSubcategoryID and Color from the Production.Product table. 
--Sort based on Color first and then ProductSubcategoryID, both in descending order. We do not want any rows that are NULL.in any of the two columns in the result.
select ProductSubcategoryID, Color
from Production.Product
where ProductSubcategoryID is not null and Color is not null
order by ProductSubcategoryID, Color desc;

--16. What is the different between UNION and UNION ALL?
Union all allows duplicates.

--17. What is the difference between the WHERE and HAVING clauses? When is it appropriate to each?
where can only filter existing columns in table, having can be used on aggragated function like sum(); where is used before group by, having is used after group by.

--18. What is an execution plan? How would you go about viewing an execution plan?
execution plan is a detailed steps offered by sql server about how it acquiring query result. you use explain above your query.

--19. Briefly describe types of joins in SQL.
inner join will return the rows that has matched elements in both left and right query.
full outer join will return all the rows of both queries, even if there is no match.
left outer join will return all rows from left table, even if there are unmatched data.
right outer join will return all rows from right table.

--20. How to you select all even numbered user_id’s from users table?
SELECT user_id
FROM users 
where user_id % 2 = 0;

--21. If USER_ID column in users table is a unique identifier, how would you select first 100 odd user_id values from the table? 
--(For the purpose of this question assume there are more than 100 users)
SELECT user_id
FROM users 
where user_id % 2 != 0
limit 100;

--22. I have another table called dbo.users2 with list of USER_ID’s. 
--Write a query that would retrieve list of user_id’s that are in dbo.users but not in dbo.users2? Write at least 2 ways to achieve the desired result.
select user_id
from dbo.users 
where user_id not in (select user_id from dbo.users2);

SELECT user_id
FROM dbo.users left join dbo.users2 on dbo.users.user_id = dbo.users2.user_id
WHERE dbo.users2.user_id is null;

--23. Write a query to retrieve list of users that had training on either on 2nd or 3rd of August and on the 4th of August.
select distinct user_id
from training_details
where user_id in (select user_id from training_details where training_date = "2015-08-04") and (training_date = "2015-08-02" or training_date = "2015-08-03");
