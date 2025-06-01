-- Tampilkan Fname dan Lname pegawai yang berjenis kelamin wanita (F).
select *
from employee;

select fname, lname
from employee
where sex = 'F';





-- Tampilkan Fname dan Ssn pegawai yang bekerja di departemen “Research”
select *
from employee;
select *
from department;

select e.fname, e.ssn
from employee e
join department d
on e.Dno=d.dnumber
where d.dname = 'Research';





-- Tampilkan nama departemen (secara unik) tempat
-- pegawai yang memiliki nama berawalan huruf “A” bekerja
select *
from department;
select *
from employee;

select distinct d.dname
from employee e
join department d
on e.Dno=d.dnumber
where left(e.fname,1) ='A';





-- Tampilkan nama departemen dan nama project
-- dimana pegawai bernama “Alicia” bekerja
select *
from department;
select *
from employee;
select*
from project;

select d.dname, p.pname
from department d
join project p
on d.dnumber=p.Dnum
join employee e
on d.dnumber=e.Dno
where e.fname = 'Alicia';

select *
from department d
join project p
on d.dnumber=p.Dnum
join employee e
on d.dnumber=e.Dno
order by fname asc;





-- Tampilkan daftar FName pegawai yang bekerja di suatu project.
select *
from employee;
select *
from works_on;

select distinct e.fname
from employee e
join works_on wo on e.Ssn=wo.Essn;





-- Tampilkan nama project yang dikerjakan oleh pegawai bernama “Franklin”
select *
from employee;
select *
from project;
select *
from works_on;

select p.pname
from project p
join works_on wo on p.Pnumber=wo.Pno
join employee e on wo.Essn=e.Ssn
where e.fname = 'Franklin';





-- Tampilkan nama pegawai beserta nama pasangannya (suami/istri)
-- yang terdaftar sebagai dependent dari pegawai tersebut
select *
from employee;
select *
from dependent;

select e.fname, d.dependent_name
from employee e
join dependent d on e.Ssn=d.Essn
where d.Relationship = 'Spouse';





-- Tambahkan salary pegawai yang bekerja di
-- departemen “Administration” sebesar 10000
select *
from employee;
select *
from department;

update employee
set salary = salary+10000
where dno = 4;





-- Tampilkan nama Employee dan nama Departemennya dimana
-- Employee tersebut minimal terlibat pada satu project.
select *
from employee;
select *
from department;
select *
from works_on;

select e.fname, d.dname
from employee e
join department d on e.Dno=d.dnumber
join works_on wo on e.Ssn=wo.Essn
group by wo.essn
having count(wo.essn) >=1;





-- Tampilkan nama depan manager dan nama department
-- manager tersebut bekerja dimana project pada departemen
-- tersebut dikerjakan terdapat karyawan yang memiliki jam kerja 0.
select *
from department;
select *
from project;
select *
from works_on;
select *
from employee;

select d.Mgr_ssn, d.dname
from department d
where exists
(
select *
from project p
join works_on wo on p.Pnumber=wo.Pno
where Hours = 0
and d.dnumber=p.Dnum);





-- Tampilkan nama depan dan ssn employee yang mempunyai
-- departemen dan jenis kelamin yang sama dengan Franklin Wong
-- (Franklin Wong tidak ditampilkan dalam hasil).
select *
from employee
where fname  = 'franklin';

select Fname, Ssn
from employee
where dno = 5
and sex = 'm'
and fname != 'franklin';





-- Tampilkan nama belakang dan alamat employee yang
-- tidak memiliki tanggungan anak (Son atau Daughter).
select *
from employee;
select *
from dependent;

select e.lname, e.address
from employee e
join dependent d on e.Ssn=d.Essn
where d.Relationship != 'Son'
and d.Relationship != 'Daughter';





-- Tampilkan nama depan dan ssn employee dimana project
-- yang employee tersebut kerjakan selalu sama dengan yang
-- dikerjakan oleh James Borg.
select *
from employee;
select *
from project;
select *
from works_on;

select e.fname, e.ssn
from employee e
join works_on wo on e.Ssn=wo.Essn
where pno =
(select pno
from employee e
join works_on wo on e.Ssn=wo.Essn
where fname = 'James')
and fname != 'James';





-- Untuk setiap pegawai, tampilkan nama dan jumlah
-- project yang dikerjakan oleh pegawai tersebut.
-- Apabila pegawai tidak terlibat pada project, jumlah
-- project diisi dengan null.
select *
from employee;
select *
from works_on;

select e.fname, e.Minit, e.Lname, count(wo.essn)
from employee e
join works_on wo on e.Ssn=wo.Essn
group by wo.essn;

select e.fname, e.Minit, e.Lname, 
case
when count(wo.essn)>0 then count(wo.essn)
when count(wo.essn)=0 then null
end jumlah_project
from employee e
join works_on wo on e.Ssn=wo.Essn
group by wo.essn;





-- Tampilkan nama semua pegawai yang bekerja di sebuah
-- department yang memiliki pegawai dengan salary tertinggi.
select *
from employee;
select *
from department;

select *, dense_rank()over(partition by dno order by salary desc) `rank`
from employee;

select fname, minit, lname, dno, `rank`
from
(select *, dense_rank()over(partition by dno order by salary desc) `rank`
from employee) ranking
where `rank` = 1;





-- Untuk setiap department yang rata-rata salary pegawainya kurang
-- dari 50000, tampilkan nama department beserta jumlah pegawainya.
select *
from employee;
select *
from department;

select d.dname, count(e.Ssn) jumlah_pegawai, avg(e.Salary) avg_salary
from employee e
join department d on e.Dno=d.dnumber
group by d.dnumber
having avg(e.Salary)<50000;





--  Serupa dengan nomor 8, dapatkah kita menampilkan nama
-- department beserta jumlah pegawainya, untuk department
-- yang rata-rata salary pegawai laki-lakinya kurang dari 50000?
select *
from employee;
select *
from department;

with cte1 as
(select dno
from employee e
group by dno, sex
having sex = 'M'
and avg(salary)<50000)
select d.dname, count(e.ssn) jumlah_pegawai
from employee e
join cte1 on e.Dno=cte1.dno
join department d on e.Dno=dnumber
group by e.Dno;





-- Buatlah sebuah view bernama EMPLOYEE_HOURS yang berisi
-- daftar nama depan pegawai dan akumulasi total jam kerja
-- pegawai tersebut dari semua project yang dikerjakan.
create view employee_hours as
(
select e.fname, sum(wo.hours) total_jam
from employee e
join works_on wo on e.Ssn=wo.Essn
group by e.ssn
);
