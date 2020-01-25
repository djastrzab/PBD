use library
go

select distinct m.firstname, m.lastname,
       ( select count(*)
         from loanhist as lh
         where year(lh.in_date) = 2001
            and lh.member_no = m.member_no
       )
from member as m
join adult as a
    on a.member_no = m.member_no
join juvenile as j
    on j.adult_member_no = a.member_no
where a.state = 'AZ'
    and ( select count(*)
          from juvenile as jw
          where jw.adult_member_no = a.member_no
        ) > 2

union

select distinct m2.firstname, m2.lastname,
       ( select count(*)
         from loanhist as lh2
         where year(lh2.in_date) = 2001
            and lh2.member_no = m2.member_no
       )
from member as m2
join adult as a2
    on a2.member_no = m2.member_no
join juvenile as j2
    on j2.adult_member_no = a2.member_no
where a2.state = 'CA'
    and ( select count(*)
          from juvenile as jw2
          where jw2.adult_member_no = a2.member_no
        ) > 3
