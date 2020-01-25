use northwind

SELECT CustomerID from Customers
where CustomerID not in
      (select DISTINCT O.CustomerID from Orders as O
      join [Order Details] [O D] on O.OrderID = [O D].OrderID
      join Products P on [O D].ProductID = P.ProductID
      join Categories C on P.CategoryID = C.CategoryID
      where year(O.OrderDate)=1997 and C.CategoryName like 'confections' )

SELECT Count( O.CustomerID) from Customers C
    left outer join Orders O on C.CustomerID = O.CustomerID and Year(O.OrderDate)=1997
group by C.CustomerID


select * from Customers