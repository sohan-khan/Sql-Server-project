/*

                              
							project title : hospital Management System
							Creator of Projector: Sohan Mollah
								   Trainee Id: 1267457
								Batch ID: ESAD-CS/PNTL-M/49/01
						 -----------------------------------------

*/


     --create database
create database hospital_management_db

ON
(
    NAME = 'hospital_management_db _Data_1',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ hospital_management_db_Data_1.mdf',
    SIZE = 25MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5%
)
LOG ON
(
    NAME = 'hospital_management_db _Log_1',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ hospital_management_db _log_1.ldf',
    SIZE = 2MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 1MB
)
GO
use hospital_management_db
go
--3 normalization

 create table patients
(
patientid int primary key identity not null,
pname nchar(50) not null,
pweight nchar(50),
age float not null,
gender nchar(50) not null,
paddress nchar(50),
phonno int not null
)

create table doctors
(
doctorid int primary key identity not null,
doctorname nchar(50) not null,
deptname nchar(50) not null,
designation nchar(50),
institution nchar(50) 
)
go
create table employees
(
employeeid int primary key identity not null,
ename nchar(50) not null,
deptname nchar(50) not null,
adress nchar(50),
phoneno int not null
)

create table lab
(
labid int primary key identity not null,
testcatagory nchar(50) not null,
patienttype nchar(50),
amount money not  null,
)
 create table room 
 (
 roomid int primary key identity not null,
 roomtype nchar(50),
 roomstatus nchar(50)
 )
  create table bills
  (
  billid int primary key identity not null,
  patienttype nchar(50) not null,
  doctorcharge int,
  medicinecharge int,
  testcharge int,
  roomcharge int,
  operationcharge int,
  noofdays int,
  )


  create table hospitaldetail
  (
  patientid int references patients(patientid),
  doctorid int references doctors(doctorid),
  employeeid int references employees(employeeid),
  labid int references lab(labid),
  roomid int references room(roomid),
  billid int references bills(billid)
  )
  go
  

  select * from patients

insert into patients values
('sumon','62','28','m','dhaka',01537583899),
('sohana','52','25','f','khulna',01537583898),
('sahin','65','27','m','cumilla',01537583897),
('sumona','53','26','f','narayangonj',01537583896),
('najmul','70','27','m','barisal',01537583895),
('joni','75','30','m','dhaka',01537583894),
('sohel','76','28','m','dinajpur',01537583893),
('faruk','68','29','m','bagura',01537583892),
('sabuj','66','28','m','gaibanda',01537583891),
('himel','63','24','m','narayangonj',01537583890)
go
select * from doctors
insert into doctors values
('Dr.dewan saifuddin','medicine','professor','bsmmu hospital'),
('Dr.rafiqul islam ','orthopedic & truma','professor','nitor'),
('Dr.md.monsurul islam','cardiology',' assco.professor','dmc hospital'),
('Dr.md. rakan-uz-zaman','neurologist','consaltant','birdem hospital'),
('Dr.md.sarwar ferdous','pediatric','professor','labaid hospital'),
('Dr.sufia jannat','cardiology','consaltant','ibna sina hospital'),
('Dr.nazlima nargis ','gynae & obs','professor','midford hospital'),
('Dr.dr.md.shafiqur rahman ','urologist',' assco.professor','greenlife hospital')
go
select * from employees
insert into  employees values
('nafiza','ot','dhaka',01955115801),
('mera','blood collection','rangpur',01955115802),
('sonia','altrasnogram','bagerhat',01955115803),
('mahfuz','x-ray','tangail',01955115804),
('sudip','lab','munshigonj',01955115805),
('nirob','ct scan','dhaka',01955115806),
('maliha','ecg','chapainababgonj',01955115807)
go
select * from lab

insert into lab values
('blood',' liver problem',180),
('x-ray',' truma injury',550),
('altrasnogram',' pregnancy problem',850),
('ct scan',' brain problem',3000),
('ecg',' heart problem',1200),
('uric acid',' urin problem',180),
('mri',' head problem',4500),
('laproscopy operation',' kidney problem',26000)

select * from room
insert into room values
('ward','avaibable'),
('twin bed','avaibable'),
('single standered','n/a'),
('single delux','booked'),
('suit room','n/a'),
('icu','booked'),
('ccu','avaibable'),
('ct-ccu','n/a')
go
select * from bills
go
insert into bills(patienttype,doctorcharge,medicinecharge,testcharge,roomcharge,operationcharge,noofdays) values
('liver problem',600,250,180,3600,0,1),
('truma injury ',850,560,550,800,3000,0),
('pregnancy problem',750,350,850,500,0,3),
('brain problem',1000,220,3000,500,0,0),
('heart problem',550,500,1200,100,0,1),
('urin problem',650,350,180,600,0,1),
('head problem',750,650,4500,600,0,1),
 ('kidney problem',1200,1500,560,0,26000,0)
 go
 
 select * from hospitaldetail
 insert into hospitaldetail values
 (1,1,1,1,1,1),
 (2,2,2,2,2,2),
 (3,3,3,3,3,3),
 (4,4,4,4,4,4),
 (5,5,5,5,5,5),
 (6,6,6,6,6,6),
 (7,7,7,7,7,7),


  /*
create trigger for preventing lab from updatedelete
  */
  create trigger tr_labinsertupdatedelete
  on lab
  for insert, update,delete
  as 
   print 'you can not inseert and update or delete  status table'
   rollback transaction
  go
 
 /*
 create  update trigger on lab
 */
 select * from lab
 go
 create trigger tr_labinserts
 on lab
 for insert
 as 
   begin
       declare
	   @labid int,
	    @amount int
	   select @labid =labid, @amount=amount from inserted
	   update lab
	   set amount= amount-@amount
	   where labid=@labid
 end
 go
 
 /**
 delete trigger on lab
 **/

create trigger tr_labdel
on lab 
for delete
as
begin
    declare @i int,
	        @am int

   select @i=labid,@am=amount from deleted
    
	update lab
	set amount=amount-@am
	where labid=@i

end
go
--testing
select * from lab

 
 /**
instead of trigger with raise error
**/

select * from patients
go
create trigger tr_patients
on patients
instead of insert
as 
  begin
   declare @i int,
           @w int,
		   @a int,
		   @c int
	select @i=patientid,@w=pweight,@a=age from inserted

	select @c= count(patientid) from patients
	where pweight=@w and age=@a

	 if @c>1
	  begin
	    insert into patients( patientid,pweight,age)
		select patientid,pweight,age from inserted
	  end
   else
      begin
	    raiserror('not enough worker available',16,1)
	 end
end
go
/**
instead of trigger from view
**/
select * from patients
go
create view vwpatients
as
 select p.patientid,p.pname,p.age,p.pweight from patients as p
 go
 create trigger tr_vwpatients
 on vwpatients
 instead of insert 
 as 
   begin
     insert into vwpatients(pname,age,pweight)
	 select pname,age,pweight from inserted
end 
go
--inserting data  store procedure
create proc [dbo].[sp_patientsinsert]
							@pname nchar(50),
							@pweight int,
							@age int,
							@gender nchar(50),
							@paddress nchar(50),
							@phonno int

as
 begin
 insert into patients(pname,pweight,age,gender,paddress,phonno) values(@pname,@pweight,@age,@gender,@paddress,@phonno)
  end
GO

exec sp_patientsinsert 'sumon',62,28,'m','dhaka',1537583899
exec sp_patientsinsert 'sohana',52,25,'f','khulna',1537583898
exec sp_patientsinsert 'sumona',53,26,'f','narayangonj',1537583896
exec sp_patientsinsert 'najmul',70,27,'m','barisal',1537583895
exec sp_patientsinsert 'joni',75,30,'m' ,'dhaka',1537583894
exec sp_patientsinsert 'sohel',76,28,'m','dinajpur',1537583893
exec sp_patientsinsert 'faruk',68,29,'m','bagura',1537583892
exec sp_patientsinsert 'sabuj',66,28,'m','gaibanda',1537583891
exec sp_patientsinsert 'himel',63,24,'m','narayangonj',1537583890
exec sp_patientsinsert 'rajo',54,25,'m' ,'bagura ',1537583891
exec sp_patientsinsert 'farid',80,27,'m','dinajpur',1537583892
exec sp_patientsinsert 'rajan',85,28,'m','narayangonj',1537583893
exec sp_patientsinsert 'asad',65 ,26,'m','mymensing',1537583894
exec sp_patientsinsert 'niyaj',75,27,'m','b.baria' ,1537583895
exec sp_patientsinsert 'shanta',76,28,'f','noakhal',1537583896
exec sp_patientsinsert 'badrul',72,30,'m','barisal',1537583897
exec sp_patientsinsert 'polash',68, 28,'m','noakhali',1537583898

/**
input parameters store procedure
**/
select * from patients
go
create proc sp_patientsinsert
							@pname nchar(50),
							@pweight int,
							@gender nchar(50)

as
 insert into patients(pname,pweight,gender) values(@pname,@pweight,@gender) 
go

/**
* retrun a value 
in input parameter srtor procedure
**/
create proc sp_patientsinsertwithreturn
									@pateintid int,
									@pname nchar(50),
									@age int,
									@gender nchar(50)
as
 insert into patients(patientid,pname,age,gender) values(@pateintid,@pname,@age,@gender)
 select @pateintid =ident_current('patients')
 return @pateintid
go
/**
applying procedural intigrity
in output parameters
**/
select * from patients
go
create proc sp_patientsinsertwithcheckage
                                        @pname nchar(50),
										@pweight int,
										@age int
as
   If @age<26
       insert into patients(pname,pweight,age)
       values( @pname,@pweight,@age)
  else
   begin
     raiserror ('age can not be 26 0r -ve',16,1)
	 return
   end
go

/**
error handling with try catch
in stor procedure
**/
create proc sp_patientsinsert
							@i int,
							@n nchar(50),
							@w int,
							@a int
as 
  begin try
      insert into patients(patientid,pname,pweight,age) values(@i,@n,@w,@a)
	  return 0
  
  end try
   begin catch
         declare @f nchar(200)
		 set @f=ERROR_MESSAGE()
		 raiserror(@f,16,1)
		 return error_number()
   end catch
go
--create view
create view vwpatienttype
as
select pname,age,gender,patienttype,testcatagory,amount from patients as p
inner join hospitaldetail as h on p.patientid=h.patientid
inner join lab as l on l.labid=h.labid
where testcatagory= 'blood' 
/**
scaler valued function
**/
select * from bills
go
create function fncalsdiscount(@doctorcharge int,@medicinecharge int,@testcharge int,@roomcharge int,@noofdays int ,@discountpercent float)
 returns float
 as
  begin
    declare @discountearned float
	set @discountearned=(@doctorcharge+@medicinecharge+@testcharge+@roomcharge*@noofdays*@discountpercent)
    return @discountearned 
end 
go

/**
inline table valued function
**/
select * from bills
go
create function fnbillsummery(@billid int, @patienttype nchar(50))
returns table
as
return 
   (
   select billid,patienttype,doctorcharge, roomcharge,noofdays,
   sum(doctorcharge+medicinecharge+testcharge+roomcharge+b.operationcharge*noofdays) as 'total bill'
   from bills as b
   where billid =@billid and patienttype= @patienttype
   group by billid,patienttype,doctorcharge, roomcharge,noofdays
   )
   go
  
  --multi statement table valued function
  select * from patients
  go
  create function mstvf_patients( @patientid int)
  returns @patients table(patientid int,pname nchar(50),pweight int,age int, gender nchar(50))
  as
   begin
     insert into @patients
	    select patientid,pname,pweight,age,gender from patients
		where patientid=@patientid
		return
 end
 go

   --index creating
   create index nc_ix_patientid
   on patients(patientid)
	
	--create virtual table
	select * from lab
	select pname,age,gender,testcatagory,patienttype,amount 
	into labpatient
	from patients as p
	inner join hospitaldetail as h on p.patientid=h.patientid
	inner join lab as l on h.labid=l.labid
	go





