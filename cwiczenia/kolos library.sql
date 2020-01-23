use library

select distinct m.lastname,m.firstname from adult as a
join juvenile j on a.member_no = j.adult_member_no
join member m on a.member_no = m.member_no
left outer join loan l on m.member_no = l.member_no
left outer join copy c on l.isbn = c.isbn and l.copy_no = c.copy_no
--left outer join loanhist l2 on c.isbn = l2.isbn and c.copy_no = l2.copy_no
where state='AZ' or state='CA'
group by m.lastname, m.firstname
having count(j.member_no)=2-- or count(j.member_no)=3





select member_no from (select a.member_no, count(j.member_no)as 'NumberOfKids' from adult as a
join juvenile j on a.member_no = j.adult_member_no
group by a.member_no)
where NumberOfKids=2

select * from adult as a
join juvenile j on a.member_no = j.adult_member_no

where a.state='AZ'