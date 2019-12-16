use Northwind
select Products.ProductName , Suppliers.Address
from Products
inner join Suppliers
on Products.SupplierID=Suppliers.SupplierID
where UnitPrice between 20 and 30

select ProductName,UnitsInStock
from Products
inner join Suppliers
on Products.SupplierID=Suppliers.SupplierID
where CompanyName='Tokyo Traders'


select CompanyName
from Customers
left outer join Orders
on Customers.CustomerID=Orders.CustomerID
where year(OrderDate)=1997




select CompanyName
from Customers
left outer join Orders
on Customers.CustomerID=Orders.CustomerID and year(OrderDate)=1997
where EmployeeID is null

--------- MANY JOINS----------


select ProductName, UnitPrice
from  Products
inner join Suppliers S on Products.SupplierID = S.SupplierID
inner join Categories C on Products.CategoryID = C.CategoryID and CategoryName='Meat/Poultry'
where   UnitPrice between 20 and 30

select ProductName,UnitPrice,CompanyName
from Products
inner join Categories C on Products.CategoryID = C.CategoryID
inner join Suppliers S on Products.SupplierID = S.SupplierID
where CategoryName='Confections'

select Customers.CompanyName,Customers.Phone
from Customers
inner join Orders O on Customers.CustomerID = O.CustomerID
inner join Shippers S on O.ShipVia = S.ShipperID
 where S.CompanyName='United Package'

select CompanyName,Phone
from Customers
inner join Orders O on Customers.CustomerID = O.CustomerID
inner join [Order Details]  OD on OD.OrderID=O.OrderID
inner join Products P on OD.ProductID = P.ProductID
inner join Categories C on P.CategoryID = C.CategoryID
where CategoryName='Confections'
