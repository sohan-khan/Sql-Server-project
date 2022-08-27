/*

                              project title : hospital Management System
							Creator of Projector: Sohan Mollah
								   Trainee Id: 1267457
								Batch ID: ESAD-CS/PNTL-M/49/01
						 -----------------------------------------
						

*/

        use hospital_management_db
        go
 
 --database all info with default sp
 exec sp_helpdb hospital_management_db
 go
 
 --- query with aggregatefunction without grouping
 select count(p.patientid) as 'total patients',sum(amount) as 'total amount' from patients as p
 inner join hospitaldetail as h on h.patientid=p.patientid
 inner join lab as l on h.labid=l.labid
 go
 /**
 join query with cube
 patienttype and test wise amount 
 **/
 
 select count( p.patientid) as 'total patient',patienttype,count(testcatagory) as 'total test' ,amount from patients  as p
 inner join hospitaldetail as h on p.patientid=h.patientid
 inner join lab as l on h.labid=l.labid
 group by patienttype,amount with cube
 go

 -- join query  with rollup 
 select count( p.patientid) as 'total patient',patienttype,count(testcatagory) as 'total test' ,amount from patients  as p
 inner join hospitaldetail as h on p.patientid=h.patientid
 inner join lab as l on h.labid=l.labid
 group by patienttype,amount with rollup
 go

 --- join query nwith over claue
 SELECT  labid, testcatagory, amount,
        COUNT(*) OVER (PARTITION BY amount
                       ORDER BY testcatagory) as 'row number'
                  from lab




 /*
 subquery
 left join
            */

 select distinct testcatagory,deptname,l.labid  from lab as l
 left join hospitaldetail as h on h.labid=l.labid
 left join employees as e on h.employeeid=e.employeeid
 where l.testcatagory not  in(select distinct deptname from employees)
 order by labid
 go


--full join
select pname,doctorname,age,gender,deptname,designation from patients as p
full join hospitaldetail as h on p.patientid=h.patientid
full join doctors as d on h.doctorid=d.doctorid
go

select  *  from doctors
--- group by with having clause
select distinct deptname, count (doctorname) as 'no of doctor'  from doctors
group by deptname
having count(doctorname)>=2
--testing virtual table
select * from labpatient
/** using agrregate function
max,min avg
**/
--max
select * from lab
select patienttype,amount from  lab
where amount in(select max(amount) from lab)

--min
select patienttype,amount from  lab
where amount in(select min(amount) from lab)
--avg
select patienttype,avg(amount) as 'average' from  lab
group by patienttype
--create cte  
select * from doctors
go
with cte_patientsdiagnosis  (pname,age,patienttype,doctorname,deptname) 
as
(
select pname,age,patienttype,doctorname,deptname
	from patients as p
	inner join hospitaldetail as h on p.patientid=h.patientid
	inner join lab as l on h.labid=l.labid
	inner join doctors as d on h.doctorid=d.doctorid
)

select * from cte_patientsdiagnosis
go

--testing view
select * from vwpatienttype

/*
testing  trigger
*/
--insert trigger
insert into lab(labid,amount) values(7,250)
insert into lab(labid,amount) values(8,500)
---update trigger
insert into lab(labid,amount) values(7,280)
insert into lab(labid,amount) values(8,600)
-






/**testing function

inline valued table function
multi statement table function
**/
--inline valued function
select * from fnbillsummery(1,'liver problem')
--multi statement table function
select * from mstvf_patients(1)
go

--testing index
exec sp_helpindex patients

-- use case function 
select labid,patienttype,testcatagory,amount,
  case
	   when amount=3000 then 'exclusive test'
	   when amount=1200 then 'mid- level test'
	   else'normal test'
  end as test_rank
	     from lab 
 go

 -- using cast ----
select cast('30-november-2021 10:00' as date) as date
go

--using convert---
select CONVERT(time,'30-november-2021 10:00',1) as 'time'

-- merge two table in one--
select distinct l.patienttype from lab as l
union all
select distinct b.patienttype from  bill as b

--upadte table
	update lab
	set patienttype='cardiac problem'
	where labid=5
	go

--delete column
	alter table lab
	drop column testcatagory
	go
 
 -- count tables in database
 SELECT COUNT(*) 'table number'
FROM sys.tables

