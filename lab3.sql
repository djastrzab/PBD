use Northwind

--select * from customers where ContactTitle='Owner'

--select * from customers

select TOP 5 WITH TIES orderid,productid,quantity from [Order Details] order by Quantity DESC

select count (ReportsTo) from Employees

--ĆWICZENIA

select count(ProductID) from Products where UnitPrice > 10 and UnitPrice <20

select max(UnitPrice) from Products where UnitPrice < 20

select * from Products
select min(UnitPrice),max(UnitPrice),avg(UnitPrice) from Products where QuantityPerUnit like '&bottle&'

-----------------------------------------------------------------------------------------------------------------------

select productid,sum(quantity)
from orderhist
group by productid

select productid,sum(quantity)
from orderhist
where productid<3
group by productid
order by productid

-----------------------------------------------------------------------------------------------------------------------

--ĆWICZENIA

--1
select OrderID,max(UnitPrice)
from [Order Details]
group by OrderID

--2
select OrderID
from [Order Details]
group by OrderID
order by max(UnitPrice group by OrderID)


--5
select TOP(1)  ShipVia, count (*)
from Orders
where year(ShippedDate)=1997
group by ShipVia
order by count(*) desc

-----------------------------------------------------------------------------------------------------------------------

SELECT productid, SUM(quantity) AS total_quantity
FROM [order details]
--where
GROUP BY productid
HAVING SUM(quantity)>1200
--order by

-----------------------------------------------------------------------------------------------------------------------

--ĆWICZENIA

select *
from [Order Details]

--1
select OrderID, count(OrderID)
from [Order Details]
where count(OrderID)>5
group by OrderID


select OrderID
from [Order Details]
where count(
              select OrderID, count(OrderID)
              from [Order Details]
              group by OrderID
          )>5

-----------------------------------------------------------------------------------------------------------------------

--ROLLUP

SELECT orderid, productid, SUM(quantity) AS total_quantity FROM [order details]
WHERE orderid < 10250
GROUP BY orderid, productid
WITH ROLLUP
ORDER BY orderid, productid

--ROLLUP bez ROLLUP
SELECT  productid, orderid,SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY  productid,orderid
union
SELECT productid, null, SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid
union
SELECT null, null, SUM(quantity) AS total_quantity
FROM orderhist