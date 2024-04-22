USE Northwind

--1. List all cities that have both Employees and Customers.
select e.City from dbo.Employees as e
select distinct c.City from dbo.Customers as c

select distinct e.City
from dbo.Employees as e
where e.City in (select distinct c.City from dbo.Customers as c);


--2.  List all cities that have Customers but no Employee.
---a. Use sub-query
select distinct c.City
from dbo.Customers as c
where c.City not in (select e.City from dbo.Employees as e);

---b. Do not use sub-query
select distinct c.City from dbo.Customers as c
except
select distinct e.City from dbo.Employees as e;


--3. List all products and their total order quantities throughout all orders.
select * from dbo.[Order Details]
select * from dbo.Products

select p.ProductID, p.ProductName, sum(od.Quantity) as sales
from dbo.[Order Details] as od
join dbo.Products as p
on od.ProductID = p.ProductID
group by p.ProductID, p.ProductName;


--4. List all Customer Cities and total products ordered by that city.
select c.City, sum(od.Quantity) as "total sales"
from dbo.Orders as o
join dbo.[Order Details] as od
on o.OrderID = od.OrderID
join dbo.Customers as c
on c.CustomerID = o.CustomerID
group by c.City;


--5. List all Customer Cities that have at least two customers.
---a. Use union
select c.City from dbo.Customers as c group by c.City having count(distinct c.CustomerID) >=2
union
select o.ShipCity as City
from dbo.Orders as o
join dbo.[Order Details] as od
on o.OrderID = od.OrderID
group by o.ShipCity
having count(distinct o.CustomerID) >= 2;

---b. Use sub-query and no union
select c.City 
from dbo.Customers as c
group by c.City
having count(*) >=2;


--6. List all Customer Cities that have ordered at least two different kinds of products.
select * from dbo.Orders
select * from dbo.[Order Details]
select * from dbo.Customers

select c.City
from dbo.Orders as o 
join dbo.[Order Details] as od 
on o.OrderID = od.OrderID
join dbo.Customers as c
on o.CustomerID = c.CustomerID
group by c.City
having count(distinct od.ProductID) >=2;


--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
select distinct c.CustomerID, c.ContactName, o.ShipCity, c.City
from dbo.Orders as o 
join dbo.[Order Details] as od 
on o.OrderID = od.OrderID
join dbo.Customers as c
on o.CustomerID = c.CustomerID
where o.ShipCity <> c.City


--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
select top 5 ProductID,AVG(UnitPrice) as AvgPrice,(select top 1 City from Customers c join Orders o on o.CustomerID=c.CustomerID join [Order Details] od2 on od2.OrderID=o.OrderID where od2.ProductID=od1.ProductID group by city order by SUM(Quantity) desc) as City from [Order Details] od1
group by ProductID 
order by sum(Quantity) desc

select top 5 od.ProductID, avg(od.UnitPrice), t.City
from dbo.[Order Details] as od 
join (
	select c.City, od.ProductID, sum(od.Quantity)
	from dbo.Orders as o 
	join dbo.[Order Details] as od 
	on o.OrderID = od.OrderID
	join dbo.Customers as c
	on o.CustomerID = c.CustomerID
	group by c.City, od.ProductID
	order by sum(od.Quantity) desc
) as t
on od.ProductID = t.ProductID
group by od.ProductID, t.City


--9. List all cities that have never ordered something but we have employees there.
---a. Use sub-query
select * from Orders
select * from [Order Details]
select * from Customers
select City from Employees

select distinct e.City
from Employees as e
where e.City not in (select o.ShipCity from Orders as o where ShipCity is not null);

---b. Do not use sub-query
select distinct City from Employees
except
select distinct e.City 
from Employees as e 
join Orders as o
on e.City = o.ShipCity;


--10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
--and also the city of most total quantity of products ordered from. (tip: join  sub-query)
select * from Orders
select * from [Order Details]
select * from Customers
select * from Employees

select distinct e.city from Employees as e
