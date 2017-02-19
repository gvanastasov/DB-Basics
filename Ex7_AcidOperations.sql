-----------------------------------
-- PART I
-----------------------------------

USE SoftUni
GO

-- 01. Employees with salary above 35000

Create PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
	select [FirstName], [LastName] FROM Employees
	 where [Salary] > 35000

exec dbo.usp_GetEmployeesSalaryAbove35000
go
-- 02. Employees with Salary Above Number

create procedure usp_GetEmployeesSalaryAboveNumber
	@tresshold money
as
	select [FirstName], [LastName] FROM Employees
	 where [Salary] >= @tresshold

exec dbo.usp_GetEmployeesSalaryAboveNumber @tresshold = 48100
go

-- 03 Town Names Starting With

create procedure usp_GetTownsStartingWith
	@startChar nvarchar(max)
as
	select [Name] from Towns
	 where Left([Name], LEN(@startChar)) = @startChar

exec dbo.usp_GetTownsStartingWith @startChar = 'bo'
go

-- 04. Emplpoyees from Town

create procedure usp_GetEmployeesFromTown
	@townName nvarchar(max)
as
	select [FirstName], [LastName] 
	from 
		Employees as e

		inner join (
			select a.[AddressID], t.[Name] from Addresses as a
			inner join Towns as t on a.[TownID]= t.[TownID]
		) as atn on e.[AddressID] = atn.[AddressID]

	where atn.[Name] = @townName 

exec dbo.usp_GetEmployeesFromTown @townName = 'Sofia'
go

-- 05. Salary Level Function

create function ufn_GetSalaryLevel (@salary money)
returns nvarchar(max)
as
	begin
		declare @level as nvarchar(max);
		select @level = case
			when @salary < 30000 then 'Low'
			when @salary between 30000 and 50000 then 'Average'
			else 'High'
		end;
		return @level;
	end
go

select [Salary], 
	   dbo.ufn_GetSalaryLevel([Salary]) as [Salary Level]
  from Employees
go
-- 06. Employees by Salary Level

create procedure usp_EmployeesBySalaryLevel
	@salaryLevel as nvarchar(max)
as
	select [FirstName], 
		   [LastName]
      from Employees
	 where dbo.ufn_GetSalaryLevel([Salary]) = @salaryLevel
go

exec dbo.usp_EmployeesBySalaryLevel @salaryLevel='high'
go

-- 07. Define Function

create function ufn_IsWordComprised(
	@setOfLetters nvarchar(max), 
	@word nvarchar(max))
returns bit
as
	begin
		declare @letter char;
		while LEN(@word) > 0
			begin
			set @letter = LEFT(@word,1);
			if CHARINDEX(@letter, @setOfLetters) = 0
				return 0;
			set @word = RIGHT(@word, LEN(@word) - 1);
			end
		return 1;
	end

go

select [Name], dbo.ufn_IsWordComprised('tndeuklh',[Name]) from Towns
go



-- 08. Delete Employees and Departments

begin transaction

declare @delTargets Table(
	[Id] int, 
	[Name] nvarchar(max), 
	[DepartmentID] int);

insert into @delTargets 
	select e.[EmployeeID], d.[Name], d.[DepartmentID] 
	from Employees as e
		inner join [Departments] as d
		on e.[DepartmentID] = d.[DepartmentID]
	where d.[Name] in ('Production','Production Control')

alter table dbo.Departments
alter column [ManagerID] int null

delete from EmployeesProjects
where [EmployeeID] in (select [Id] from @delTargets)
					  
update Employees set [ManagerID] = NULL
where [ManagerID] in (select [Id] from @delTargets)

update Departments set [ManagerID] = NULL
where [ManagerID] in (select [Id] from @delTargets)

delete from Employees
where [DepartmentID] in (select [DepartmentID] from @delTargets)

delete from dbo.Departments
where [Name] in (select [Name] from @delTargets)

rollback
go

-- 09. Employees with Three Projects

create procedure usp_AssignProject
	@employeeId int,
	@projectId int
as
	begin
		
		declare @currentProjCount int;
		set @currentProjCount = (select count(*) 
								from EmployeesProjects
								where [EmployeeID] = @employeeId);

		begin transaction


		if @currentProjCount >= 3
			begin
				raiserror('The employee has too many projects!', 16, 1);
				rollback;
				return;
			end

		insert into EmployeesProjects ([EmployeeID], [ProjectID])
		values (@employeeId, @projectId)
		commit;
	end

go

exec dbo.usp_AssignProject @employeeId=2, @projectId=1
exec dbo.usp_AssignProject @employeeId=2, @projectId=2
exec dbo.usp_AssignProject @employeeId=2, @projectId=3
-- next will throw exception
exec dbo.usp_AssignProject @employeeId=2, @projectId=4
exec dbo.usp_AssignProject @employeeId=2, @projectId=5

delete from [EmployeesProjects]
where [EmployeeID] = 2
go
-----------------------------------
-- PART II
-----------------------------------
use Bank
go

-- 10. Find Full Name

create procedure usp_GetHoldersFullName
as
	begin
		select CONCAT([FirstName],' ',[LastName]) as [Full Name]
		from AccountHolders
	end
go

exec dbo.usp_GetHoldersFullName
















