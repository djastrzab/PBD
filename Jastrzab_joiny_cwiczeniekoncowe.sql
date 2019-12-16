use northwind

-------CWICZENIE 1
--Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta.
select O.OrderID, SUM(OD.Quantity) as 'Common Quantity', C.ContactName from Orders as O
join [Order Details] as OD on O.OrderID = OD.OrderID
join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, C.ContactName
order by O.OrderID

--Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia,
--dla których łączna liczbę zamówionych jednostek jest większa niż
--250
select O.OrderID, SUM(OD.Quantity) as 'Common Quantity', C.ContactName from Orders as O
join [Order Details] as OD on O.OrderID = OD.OrderID
join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, C.ContactName
having Sum(Quantity)>250
order by O.OrderID

-- Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta.
select O.CustomerID, sum(OD.UnitPrice * Od.Quantity) as 'Common price' from Customers
join Orders O on Customers.CustomerID = O.CustomerID
join [Order Details] OD on O.OrderID = OD.OrderID
group by O.CustomerID

-- Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia,
--dla których łączna liczba jednostek jest większa niż 250.
select O.CustomerID, sum(OD.UnitPrice * Od.Quantity) as 'Common price' from Customers
join Orders O on Customers.CustomerID = O.CustomerID
join [Order Details] OD on O.OrderID = OD.OrderID
group by O.CustomerID
having sum(Quantity)>250

-- Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i
--nazwisko pracownika obsługującego zamówienie
select O.CustomerID, sum(OD.UnitPrice * Od.Quantity) as 'Common price', E.FirstName, E.LastName from Customers as C
join Orders O on C.CustomerID = O.CustomerID
join [Order Details] OD on O.OrderID = OD.OrderID
left outer join Employees E on O.EmployeeID = E.EmployeeID
group by O.CustomerID, E.FirstName, E.LastName
having sum(Quantity)>250

-------CWICZENIE 2
-- Dla każdej kategorii produktu (nazwa), podaj łączną liczbę
--zamówionych przez klientów jednostek towarów z tek kategorii.
select C.CategoryName, sum(P.UnitsOnOrder) as 'number of orders' from Products as P
join Categories C on P.CategoryID = C.CategoryID
group by C.CategoryName

--Dla każdej kategorii produktu (nazwa), podaj łączną wartość
--zamówionych przez klientów jednostek towarów z tek kategorii.
select C.CategoryName, sum(P.UnitsOnOrder * P.UnitPrice) as 'worth of orders' from Products as P
join Categories C on P.CategoryID = C.CategoryID
group by C.CategoryName

--Posortuj wyniki w zapytaniu z poprzedniego punktu wg:

--a) łącznej wartości zamówień
select C.CategoryName, sum(P.UnitsOnOrder * P.UnitPrice) as 'worth of orders' from Products as P
join Categories C on P.CategoryID = C.CategoryID
group by C.CategoryName
order by  sum(P.UnitsOnOrder * P.UnitPrice)

--b) łącznej liczby zamówionych przez klientów jednostek towarów.
select C.CategoryName, sum(P.UnitsOnOrder * P.UnitPrice) as 'worth of orders' from Products as P
join Categories C on P.CategoryID = C.CategoryID
group by C.CategoryName
order by  sum(P.UnitsOnOrder)

--Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za
--przesyłkę
select O.OrderID, sum(OD.Quantity*OD.UnitPrice)+O.Freight as 'worth of orders with shipping' from Orders as O
join [Order Details] OD on OD.OrderID=O.OrderID
group by O.OrderID, O.Freight

-------CWICZENIE 3
--Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które
--przewieźli w 1997r

select CompanyName, count(OrderID) from Shippers as S
join Orders O on O.ShipVia=S.ShipperID
where year(ShippedDate)=1997
group by CompanyName

-- Który z przewoźników był najaktywniejszy (przewiózł największą
--liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika
select TOP 1 CompanyName, count(OrderID) from Shippers as S
join Orders O on O.ShipVia=S.ShipperID
where year(ShippedDate)=1997
group by CompanyName
order by  count(OrderID) DESC

--Dla każdego pracownika (imię i nazwisko) podaj łączną wartość
--zamówień obsłużonych przez tego pracownika
select E.FirstName, E.LastName, count(O.OrderID) as 'Number of orders' from Employees as E
join Orders O on E.EmployeeID = O.EmployeeID
group by E.FirstName, E.LastName

--Który z pracowników obsłużył największą liczbę zamówień w 1997r,
--podaj imię i nazwisko takiego pracownika
select TOP 1 E.FirstName, E.LastName from Employees as E
join Orders O on E.EmployeeID = O.EmployeeID
where year(O.OrderDate)=1997
group by E.FirstName, E.LastName
order by count(O.OrderID) DESC

-- Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia
--o największej wartości) w 1997r, podaj imię i nazwisko takiego
--pracownika
select TOP 1 E.FirstName, E.LastName from Employees as E
join Orders O on E.EmployeeID = O.EmployeeID
join [Order Details] OD on OD.OrderID=O.OrderID
where year(O.OrderDate)=1997
group by E.FirstName, E.LastName
order by sum(OD.UnitPrice * OD.Quantity) DESC

-------------------CWICZENIE 4
--Dla każdego pracownika (imię i nazwisko) podaj łączną wartość
--zamówień obsłużonych przez tego pracownika
--Ogranicz wynik tylko do pracowników

select  E.FirstName, E.LastName,sum(OD.UnitPrice * OD.Quantity) from Employees as E
join Orders O on E.EmployeeID = O.EmployeeID
join [Order Details] OD on OD.OrderID=O.OrderID
group by E.FirstName, E.LastName
order by sum(OD.UnitPrice * OD.Quantity) DESC

--a) którzy mają podwładnych
select  Boss.FirstName, Boss.LastName,sum(OD.UnitPrice * OD.Quantity) as 'Worth of Orders' from Employees as E
join Orders O on E.EmployeeID = O.EmployeeID
join [Order Details] OD on OD.OrderID=O.OrderID
join Employees Boss on E.ReportsTo=Boss.EmployeeID
group by Boss.FirstName, Boss.LastName
order by sum(OD.UnitPrice * OD.Quantity) DESC

--b) którzy nie mają podwładnych
select  Boss.FirstName, Boss.LastName,sum(OD.UnitPrice * OD.Quantity) as 'Worth of Orders' from Employees as Boss
join Orders O on Boss.EmployeeID = O.EmployeeID
join [Order Details] OD on OD.OrderID=O.OrderID
left outer join Employees E on E.ReportsTo=Boss.EmployeeID
where E.LastName is null
group by Boss.FirstName, Boss.LastName
order by sum(OD.UnitPrice * OD.Quantity) DESC
