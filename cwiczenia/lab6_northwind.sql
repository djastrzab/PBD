use northwind
select ContactName,Phone from Customers as c
where c.CustomerID in (select o.CustomerID from Orders as o where year(o.ShippedDate)=1997 and
                                          o.ShipVia=(select ShipperID from Shippers as s where s.CompanyName='United Package'))
order by ContactName

select distinct c.ContactName,c.Phone from Customers as c
join Orders O on c.CustomerID = O.CustomerID and year(O.ShippedDate)=1997
join Shippers S on O.ShipVia = S.ShipperID and S.CompanyName='United Package'
order by ContactName


select ContactName,Phone from Customers as c
where c.CustomerID not in (select o.CustomerID from Orders as o where year(o.ShippedDate)=1997 and
                                          o.ShipVia in (select ShipperID from Shippers as s where s.CompanyName='United Package'))


select c.ContactName,c.Phone from Customers as c
join Orders O on c.CustomerID = O.CustomerID
join Shippers S on O.ShipVia = S.ShipperID
--self outer join do ogarnięcia ;)