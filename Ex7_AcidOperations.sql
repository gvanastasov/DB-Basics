USE SoftUni
GO

-- 01. Employees with salary above 35000

Create PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
	select [FirstName], [LastName] FROM Employees
	 where [Salary] > 35000

exec dbo.usp_GetEmployeesSalaryAbove35000

-- 02. Employees with Salary Above Number































