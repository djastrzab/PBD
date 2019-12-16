use library
select firstname,lastname,birth_date,street,city
from juvenile
inner join member on juvenile.member_no = member.member_no
left outer join adult a on juvenile.adult_member_no = a.member_no

select  dziecko.firstname,dziecko.lastname,birth_date,street,city, rodzic.firstname,rodzic.lastname
from juvenile
inner join member dziecko on juvenile.member_no = dziecko.member_no
left outer join adult a on juvenile.adult_member_no = a.member_no
join member rodzic on rodzic.member_no = a.member_no

-----------------------------------------------------------
--Cwiczenia do zrobienia
select *
from adult
join member m on adult.member_no = m.member_no
join juvenile j on adult.member_no = j.adult_member_no
where DATEDIFF(d, j.birth_date,'1996-01-01'))>0
-----------------------------------------------------------
select (firstname +' ' +lastname) as "name" ,(street+' ' +city+' ' +state+' ' +zip) as "Adress"
from adult
inner join member m on adult.member_no = m.member_no

select item.isbn,c.copy_no,on_loan,title,translation,cover
from item
inner join copy c on item.isbn = c.isbn
inner join title t on c.title_no = t.title_no
inner join loanhist l on c.isbn = l.isbn and c.copy_no = l.copy_no
where item.isbn in (1,500,1000)

select member.member_no, firstname,lastname,isbn,due_date
from member
left outer join adult a on member.member_no = a.member_no
left outer join loan l on member.member_no = l.member_no
where member.member_no in (250,342,1675)

select *
from adult
inner join member m on adult.member_no = m.member_no
inner join juvenile j on adult.member_no = j.adult_member_no
where adult.state='AZ'
ORDER BY adult.member_no DESC





