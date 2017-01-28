-- 01. Use the given Softuni DB and query

-- 02. Find all information about deparments

SELECT * FROM Departments

-- 03. Find all Department Names

SELECT [Name] FROM Departments

-- 04. Find Salary of Each Employee

SELECT [FirstName], [LastName], [Salary] FROM Employees

-- 05. Find Full Name of Each Employee

SELECT [FirstName], [MiddleName], [LastName] FROM Employees

-- 06. Find Email Address of Each Employee

SELECT [FirstName] + '.' + [LastName] + '@softuni.bg' 
    AS [Full Email Address]
  FROM Employees

-- 07. Find All Different Employee's Salaries

SELECT DISTINCT [Salary] 
		   FROM Employees

-- 08. Find all Information About Employees

SELECT * FROM Employees
		WHERE [JobTitle] = 'Sales Representative'

-- 09. Find Names of All Employees by Salary in Range

SELECT [FirstName], [LastName], [JobTitle] 
  FROM Employees
 WHERE ([Salary] >= 20000) AND ([Salary] <= 30000)
 -- can also use BETWEEN x AND y

-- 10. Find Names of All Employees

SELECT [FirstName] + ' ' + [MiddleName] + ' ' + [LastName]
    AS [Full Name]
  FROM Employees
 WHERE [Salary] IN (25000, 14000, 12500, 23600)

-- 11. Find All Employees Without Manager

SELECT [FirstName], [LastName] FROM Employees
 WHERE ManagerID IS NULL

-- 12. Find All Employees with Salary More Than

SELECT [FirstName], [LastName], [Salary] FROM Employees
 WHERE Salary > 50000 
 ORDER BY Salary DESC

-- 13. Find 5 Best Paid Employees

SELECT TOP 5 [FirstName], [LastName] FROM Employees
ORDER BY [Salary] DESC

-- 14. Find All Employees Except Marketing

SELECT [FirstName], [LastName] FROM Employees
 WHERE NOT [DepartmentID] = 4

-- 15. Sort Employees Table

SELECT * FROM Employees
ORDER BY [Salary] DESC
		,[FirstName]
		,[LastName] DESC
		,[MiddleName]

-- 16. Create View Employess With Salaries

CREATE VIEW V_EmployeesSalaries AS
	 SELECT [FirstName], [LastName], [Salary] FROM Employees
GO
SELECT * FROM V_EmployeesSalaries

-- 17. Create View Employees with Job Titles
GO
CREATE VIEW V_EmployeeNameJobTitle AS
     SELECT [FirstName] + ' '
	      + ISNULL([MiddleName],'') + ' ' 
		  + [LastName] AS [Full Name]

		  , [JobTitle] FROM Employees
GO
SELECT * FROM V_EmployeeNameJobTitle 
DROP VIEW V_EmployeeNameJobTitle 

-- 18. Distinct Job Titles

SELECT DISTINCT [JobTitle] FROM Employees

-- 19. Find First 10 Started Projects

SELECT TOP (10) * FROM Projects
		ORDER BY [StartDate] ASC,
		         [Name]

--20. Last 7 Hired Employees

SELECT TOP (7) [FirstName], [LastName], [HireDate] FROM Employees
	ORDER BY [HireDate] DESC


-- 21. Increase Salaries

BACKUP DATABASE SoftUni
TO DISK = 'C:\Users\Georgi\Documents\Softuni\05 DB Basics\DB_Backups\SoftUni_ex2_CRUD.Bak'
	WITH FORMAT,
		MEDIANAME = 'DB_Backups',
		NAME = 'Full Backup of SoftUni';

USE master
GO
ALTER DATABASE SoftUni
SET SINGLE_USER
--This rolls back all uncommitted transactions in the db.
WITH ROLLBACK IMMEDIATE
GO
RESTORE DATABASE SoftUni
FROM DISK = 'C:\Users\Georgi\Documents\Softuni\05 DB Basics\DB_Backups\SoftUni_ex2_CRUD.Bak'
GO

USE SoftUni
GO
UPDATE Employees
   SET Salary = Salary + Salary * 12 / 100
 WHERE [DepartmentId] IN 
						(
							SELECT [DepartmentId] 
							  FROM [Departments]
							 WHERE [Name] IN 
											('Engineering'
											,'Tool Design'
											,'Marketing'
											,'Information Services')
						)

GO
						
SELECT [Salary] 
  FROM [Employees]

-- 22. All Mountain Peaks

USE Geography
GO

  SELECT [PeakName] FROM Peaks
ORDER BY [PeakName]

-- 23. Biggest Countries by Population

SELECT TOP (30) [CountryName], [Population] FROM Countries
WHERE [ContinentCode] IN (
							SELECT [ContinentCode] FROM Continents
							 WHERE [ContinentName] = 'Europe'
						)
ORDER BY [Population] DESC, [CountryName] ASC


-- 24. Countries and Currency (Euro / Not Euro)

SELECT [CountryName]
	  ,[CountryCode]
	  ,CASE [CurrencyCode]
			WHEN 'EUR' THEN 'Euro'
			ELSE 'Not Euro' 
	   END as [Currency]
FROM Countries
ORDER BY [CountryName]


-- 25. All Diablo Characters

Use Diablo
GO

SELECT [Name] FROM Characters
ORDER BY [Name]



















