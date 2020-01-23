use Northwind

select O.EmployeeID, sum(UnitPrice*Quantity*(1-Discount)+O.Freight) as value from [Order Details]
join Orders O on [Order Details].OrderID = O.OrderID
where O.EmployeeID in (select Boss.EmployeeID from Employees as E
join Employees as Boss on Boss.EmployeeID=E.ReportsTo
group by Boss.EmployeeID) and YEAR(O.OrderDate) = 1997 and MONTH(O.OrderDate)=12
group by  O.EmployeeID

SELECT b.EmployeeID, b.LastName, b.FirstName, COUNT(e.ReportsTo) AS 'MaPodwladnych',
	(SELECT SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) + SUM(o.Freight)
		FROM [Order Details] as od JOIN Orders AS o ON od.OrderID = o.OrderID
		WHERE o.EmployeeID = b.EmployeeID AND YEAR(o.OrderDate) = 1997 AND MONTH(O.OrderDate) = 12) AS 'WartoscZamowien'
	 FROM Employees AS e JOIN Employees AS b ON e.ReportsTo = b.EmployeeID
	 GROUP BY b.EmployeeID, b.LastName, b.FirstName

select Boss.EmployeeID from Employees as E
join Employees as Boss on Boss.EmployeeID=E.ReportsTo
group by Boss.FirstName,Boss.LastName

select c.CustomerID, c.CompanyName from Customers as c
left join Orders O on o.CustomerID = c.CustomerID and year(OrderDate)=1997
where O.OrderDate is null

select C.CustomerID from Customers C
where C.CustomerID not in
(select O.CustomerID from Orders O where C.CustomerID=O.CustomerID and year(OrderDate)=1997)


select C.CustomerID from Customers C
where  not exists
(select O.CustomerID from Orders O where o.CustomerID=C.CustomerID and year(OrderDate)=1997)


