use library
select firstname,lastname,birth_date
from juvenile
inner join member
on juvenile.member_no = member.member_no

select title
from loan
inner join title t
    on loan.title_no = t.title_no

select in_date, datediff(d,in_date,due_date) , fine_paid, fine_assessed,fine_waived
from title
inner join loanhist l
    on title.title_no = l.title_no and fine_paid is not null
where title='Tao Teh King'

select isbn
from reservation
inner join member
    on reservation.member_no = member.member_no
where  firstname='Stephen' and middleinitial='A' and lastname='Graff'


