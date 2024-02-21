
-- reduce traffic

create procedure test
as
select *
from EmployeeDemographics

exec test




create procedure temp_emp4
as
drop table if exists #templ_employee
create table #templ_employee (
JobTitle varchar(100),
EmployeePerJob int,
AvgAge int,
AvgSalary int
)


insert into #templ_employee
select JobTitle, count(JobTitle), Avg(Age), Avg(Salary)
from EmployeeDemographics emp
join EmployeeSalary sal
	on emp.EmployeeID = sal.EmployeeID
group by JobTitle

select *
from #templ_employee

exec temp_emp4



-- stored procedure mean precompiled code
-- naming.. sp(stored procedure)nameOftable_whatitdoes
create procedure dbo.spPeople_GetAll
as
begin
	select *
	from EmployeeDemographics
end

exec dbo.spPeople_GetAll


alter procedure dbo.spPeople_GetAll
as
begin
	set nocount on;
	select *
	from EmployeeDemographics
end

exec dbo.spPeople_GetAll




create procedure dbo.spPeople_GetByLastName
@LastName nvarchar(50) --variable
as
begin
	select EmployeeID, FirstName, LastName
	from dbo.EmployeeDemographics
	where LastName = @LastName
end

-- when we execute, we can use key value pair by calling our variable @lastname but we just provide a value
-- it will take it by the order of variables by itself
exec dbo.spPeople_GetByLastName 'scott'  

alter procedure dbo.spPeople_GetByLastName
@LastName nvarchar(50), --variable
@FirstName nvarchar(50)
as
begin
	select EmployeeID, FirstName, LastName
	from dbo.EmployeeDemographics
	where LastName = @LastName and FirstName = @FirstName
end

exec dbo.spPeople_GetByLastName 'scott', 'Michael'