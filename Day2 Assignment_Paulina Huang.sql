use AdventureWorks2022

--1. How many products can you find in the Production.Product table?
select count(p.ProductID)
from Production.Product as p;

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
select count(p.ProductID)
from Production.Product as p
where ProductSubcategoryID is not null;

--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
select p.ProductSubcategoryID, count(p.ProductID) as CountedProducts
from Production.Product as p
where ProductSubcategoryID is not null
group by ProductSubcategoryID;

--4. How many products that do not have a product subcategory.
select count(p.ProductID)
from Production.Product as p
where ProductSubcategoryID is null;

--5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
select sum(i.Quantity)
from Production.ProductInventory as i
group by i.ProductID;

--6.  Write a query to list the sum of products in the Production.ProductInventory table 
--and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
select i.ProductID, sum(i.Quantity) as "TheSum"
from Production.ProductInventory as i
where i.LocationID = 40
group by i.ProductID
having sum(i.Quantity) < 100;

--7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 
--and limit the result to include just summarized quantities less than 100
select i.Shelf, i.ProductID, sum(i.Quantity) as "TheSum"
from Production.ProductInventory as i
where i.LocationID = 40
group by i.ProductID, i.Shelf
having sum(i.Quantity) < 100;

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
select i.ProductID, avg(i.Quantity) as "TheAvg"
from Production.ProductInventory as i
where LocationID = 10
group by i.ProductID;

--9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
select i.ProductID, i.Shelf, avg(i.Quantity) as "TheAvg"
from Production.ProductInventory as i
group by i.Shelf, i.ProductID;

--10. Write query  to see the average quantity  of  products by shelf excluding rows 
--that has the value of N/A in the column Shelf from the table Production.ProductInventory
select i.ProductID, i.Shelf, avg(i.Quantity) as "TheAvg"
from Production.ProductInventory as i
where Shelf != 'N/A'
group by i.Shelf, i.ProductID;

--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. 
--Exclude the rows where Color or Class are null.
select Color, Class, count(*) as "TheCount", avg(p.ListPrice) as "TheAvg"
from Production.Product as p
where Color is not null and Class is not null
group by Color, Class;

--12.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. 
--Join them and produce a result set similar to the following.
select c.Name as Country, s.name as province
from person.CountryRegion as c join person.StateProvince as s 
on c.CountryRegionCode = s.CountryRegionCode;

--13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and 
--list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
select c.Name as Country, s.name as province
from person.CountryRegion as c join person.StateProvince as s 
on c.CountryRegionCode = s.CountryRegionCode
where c.Name != 'Germany' and c.Name != 'Canada';

USE Northwind
--14. List all Products that has been sold at least once in last 25 years.
select * from dbo.Products

select * from dbo.Orders

select * from dbo.[Order Details]

select od.ProductID, p.ProductName
from dbo.Orders as o join dbo.[Order Details] as od
on o.OrderID = od.OrderID
join dbo.Products as p
on od.ProductID = p.ProductID
where DATEDIFF(year, o.OrderDate, GETDATE()) <25;

--15. List top 5 locations (Zip Code) where the products sold most.
select top 5 o.ShipPostalCode, sum(od.Quantity) as sales
from dbo.Orders as o join dbo.[Order Details] as od
on o.OrderID = od.OrderID
where o.ShipPostalCode is not null
group by o.ShipPostalCode
order by sales desc;

--16. List top 5 locations (Zip Code) where the products sold most in last 25 years.
select top 5 o.ShipPostalCode, sum(od.Quantity) as sales
from dbo.Orders as o join dbo.[Order Details] as od
on o.OrderID = od.OrderID
where o.ShipPostalCode is not null and DATEDIFF(year, o.OrderDate, GETDATE()) <25
group by o.ShipPostalCode
order by sales desc;

--17. List all city names and number of customers in that city.
select o.ShipCity, count(o.CustomerID) as "number of customers"
from dbo.Orders as o
group by o.ShipCity;

--18. List city names which have more than 2 customers, and number of customers in that city
select o.ShipCity, count(o.CustomerID) as "number of customers"
from dbo.Orders as o
group by o.ShipCity
having count(CustomerID) >2;

--19. List the names of customers who placed orders after 1/1/98 with order date.
select distinct c.CompanyName
from dbo.Orders as o join dbo.Customers as c
on o.CustomerID = c.CustomerID
where o.OrderDate > '1998-1-1';

--20. List the names of all customers with most recent order dates
select distinct c.CompanyName, max(o.OrderDate) as "most recent order date"
from dbo.Orders as o join dbo.Customers as c
on o.CustomerID = c.CustomerID
group by c.CompanyName;

--21. Display the names of all customers  along with the  count of products they bought
select c.CompanyName, ISNULL(sum(od.Quantity),0) as sales
from dbo.Customers as c left join dbo.Orders as o
on o.CustomerID = c.CustomerID
left join dbo.[Order Details] as od
on o.OrderID = od.OrderID
group by c.CompanyName;

--22. Display the customer ids who bought more than 100 Products with count of products.
select c.CustomerID, sum(od.Quantity) as sales
from dbo.Customers as c left join dbo.Orders as o
on o.CustomerID = c.CustomerID
left join dbo.[Order Details] as od
on o.OrderID = od.OrderID
group by c.CustomerID
having sum(od.Quantity) > 100;

--23. List all of the possible ways that suppliers can ship their products. Display the results as below
select * from dbo.Shippers
select * from dbo.Suppliers
select * from dbo.Orders

select distinct sup.CompanyName as "Supplier Company Name", s.CompanyName as "Shipping Company Name"
from Orders as o
left join dbo.[Order Details] as od
ON o.OrderID = od.OrderID
inner join dbo.Products as p
ON od.ProductID = p.ProductID
right join dbo.Suppliers sup
ON p.SupplierID = sup.SupplierID
inner join dbo.Shippers as s
ON o.ShipVia = s.ShipperID;

--24. Display the products order each day. Show Order date and Product Name.
select * from dbo.Orders
select * from dbo.Products
select * from dbo.[Order Details]

select o.OrderDate, p.ProductName
from dbo.Orders as o
left join dbo.[Order Details] as od
on o.OrderID = od.OrderID
inner join dbo.Products as p
on od.ProductID = p.ProductID
group by o.OrderDate, p.ProductName
order by o.OrderDate, p.ProductName;

--25. Displays pairs of employees who have the same job title.
select * from dbo.Employees

select e1.FirstName, e1.LastName, e1.TitleOfCourtesy, e2.FirstName, e2.LastName, e2.TitleOfCourtesy
from dbo.Employees as e1
cross join dbo.Employees as e2
where e1.TitleOfCourtesy = e2.TitleOfCourtesy and e1.FirstName + ' ' + e1.LastName <> e2.FirstName + ' ' + e2.LastName;

--26. Display all the Managers who have more than 2 employees reporting to them.
select e1.EmployeeID, e1.FirstName, e1.LastName
from dbo.Employees as e1
join dbo.Employees as e2
on e1.EmployeeID = e2.ReportsTo
where e2.ReportsTo is not null
group by e1.EmployeeID,e1.FirstName, e1.LastName
having count(e2.ReportsTo) >2;

--27. Display the customers and suppliers by city. The results should have the following columns
select c.City, c.CompanyName, c.ContactName, 'Customer' as Type
from dbo.Customers as c
union
select s.City, s.CompanyName, s.ContactName, 'Supplier' as Type
from dbo.Suppliers as s;

