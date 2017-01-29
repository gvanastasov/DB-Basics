USE SoftUni
GO

-- 01. Find all names of employess by first name

SELECT [FirstName], [LastName] FROM Employees
WHERE LEFT([FirstName], 2) = 'SA'

-- 02. Find Names of All Employees by Last Name

SELECT [FirstName], [LastName] FROM Employees
WHERE [LastName] LIKE '%ei%'

-- 03. Find First Names of All Employess

SELECT [FirstName] FROM Employees
 WHERE 
		[DepartmentID] IN (3, 10) 
   AND
		DATENAME(year,[HireDate]) BETWEEN 1995 AND 2005

-- 04. Find All Employees Except Engineers

-- wildcard
SELECT [FirstName], [LastName] FROM Employees
 WHERE [JobTitle] NOT LIKE '%engineer%'

SELECT [FirstName], [LastName] FROM Employees
 WHERE CHARINDEX('engineer', [JobTitle]) = 0

 -- 05. Find Towns with Name Length

SELECT [Name] FROM Towns
WHERE LEN([Name]) IN (5,6)
ORDER BY [Name]


--  06. Find Towns Starting With

SELECT * FROM Towns
WHERE LEFT([Name],1) IN ('M','K','B','E')
ORDER BY [Name]

SELECT * FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

-- 07. Find Towns Not Starting with

SELECT * FROM Towns
WHERE LEFT([Name],1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

SELECT * FROM Towns
WHERE [Name] LIKE '[^RBD]%'
ORDER BY [Name]

-- 08. Create View Employees Hired After
GO
CREATE VIEW V_EmployeesHiredAfter2000
AS 
	(SELECT [FirstName], [LastName] FROM Employees
	  WHERE DATENAME(year, [HireDate]) > 2000)

GO
SELECT * FROM V_EmployeesHiredAfter2000

-- 09. Length of Last Name

SELECT [FirstName], [LastName] FROM Employees
WHERE DATALENGTH([LastName]) = 5

-- 10. Countries Holding 'A' 3 or more times

USE Geography
GO

SELECT [CountryName], [IsoCode] FROM Countries
WHERE (DATALENGTH([CountryName]) - DATALENGTH(REPLACE([CountryName], 'A', '')) >= 3)
ORDER BY [IsoCode]

-- 11. Mix of Peak and River Names

SELECT p.[PeakName]
      ,r.[RiverName]
	  ,LOWER(CONCAT(
			p.[PeakName], 
			SUBSTRING(r.[RiverName],2, LEN(r.[RiverName]))
			)) AS [Mix]
 FROM Peaks  AS p, 
	  Rivers AS r
WHERE RIGHT(p.[PeakName], 1) = LEFT(r.[RiverName], 1)
ORDER BY [Mix]
	
-- 12. Games From 2011 and 2012 Year

USE Diablo
GO

SELECT TOP (50) [Name]
			   ,REPLACE(
					CONVERT(varchar(19), [Start], 102),
					'.','-')
	  FROM Games
     WHERE DATEPART(year, [Start]) IN (2011, 2012)
  ORDER BY [Start], [Name]


SELECT TOP (50) [Name]
			   ,FORMAT([Start], 'yyyy-MM-dd')
	  FROM Games
     WHERE DATEPART(year, [Start]) IN (2011, 2012)
  ORDER BY [Start], [Name]



-- 13. User Email Providers

SELECT [Username]
      ,RIGHT([Email],LEN([Email]) - CHARINDEX('@',[Email],0)) AS [Email Provider] 
  FROM Users
ORDER BY [Email Provider], [Username]


-- 14. Get Users with IPAddress Like Pattern


SELECT [Username], [IpAddress] FROM Users
 WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]


-- 15. Show All Games with Duration

SELECT [Name] AS [Game]
 	 , CASE
			WHEN DATEPART(hour,[Start]) >= 0 AND DATEPART(hour,[Start]) < 12 THEN 'Morning'
			WHEN DATEPART(hour, [Start]) >= 12 AND DATEPART(hour,[Start]) < 18 THEN 'Afternoon'
			WHEN DATEPART(hour, [Start]) >= 18 AND DATEPART(hour,[Start]) < 24 THEN 'Evening'
	   END AS 'Part of the Day'
	 , Case
			WHEN [Duration] <= 3 THEN 'Extra Short'
			WHEN [Duration] >= 4 AND [Duration] <= 6 THEN 'Short'
			WHEN [Duration] > 6 THEN 'Long'
			ELSE 'Extra Long'		 
	   END AS 'Duration'
	 
  FROM Games
ORDER BY [Name],
		 [Duration],
	     [Start]

-- 16. Orders Table

USE Orders
GO























