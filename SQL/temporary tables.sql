-- temporary tables are tables that we store some queries that we want ot access regularly
-- this saves tons of computing power.
-- they only exist in one session and if the session is cancelled we won'tfind them again

create table #temp_employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

select *
from #temp_employee

insert into #temp_employee values (
'1001', 'HR', '45000'
)

insert into #temp_employee
select *
from EmployeeSalary


drop table if exists #temp_employee2 --this makes sure to drop the table b/c temporary tables cannot be created twice

create table #temp_employee2 (
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int
)


insert into #temp_employee2
select JobTitle, count(JobTitle), Avg(Age), Avg(Salary)
from EmployeeDemographics emp
join EmployeeSalary sal
	on emp.EmployeeID = sal.EmployeeID
group by JobTitle

select * 
from #temp_employee2