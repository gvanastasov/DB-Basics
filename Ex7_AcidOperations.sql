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

--

















