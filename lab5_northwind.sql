use Northwind

select Boss.FirstName,Boss.LastName,E.FirstName,E.LastName
from Employees as E
left outer  join  Employees Boss on E.ReportsTo=Boss.EmployeeID
where Boss.FirstName is not null

select Boss.FirstName,Boss.LastName
from Employees as Boss
left outer  join  Employees E on E.ReportsTo=Boss.EmployeeID
where E.FirstName is null

