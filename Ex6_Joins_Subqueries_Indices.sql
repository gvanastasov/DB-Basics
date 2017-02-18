Use SoftUni
GO

-- 01. Employee Address

select TOP (5) [EmployeeID],
		[JobTitle],
		e.[AddressID],
		a.[AddressText]
from Employees as e
JOIN Addresses as a ON e.[AddressID] = a.[AddressID]
ORDER BY e.[AddressID]

-- 02. Addresses with Towns

select TOP(50) [FirstName], 
				[LastName], 
				t.[Name] as [Town], 
				a.[AddressText]
from Employees as e
JOIN Addresses as a ON e.[AddressID] = a.[AddressID]
JOIN Towns as t ON a.[TownID] = t.[TownID]
ORDER BY [FirstName] asc, [LastName]

-- 03. Sales Employee

select [EmployeeID], [FirstName], [LastName], d.[Name] as [DepartmentName]
from Employees as e
inner join Departments as d on d.[DepartmentID] = e.[DepartmentID]
where d.[Name] = 'Sales'
order by [EmployeeID] asc

-- 04. Employee Departments

select TOP(5) [EmployeeID], 
				[FirstName], 
				[Salary], 
				d.[Name] as [DepartmentName]
from Employees as e
inner join Departments as d on d.[DepartmentID] = e.[DepartmentID]
where e.[Salary] > 15000
order by e.[DepartmentID] asc


-- 05. Employees without project

select top(3) e.[EmployeeID], [FirstName]
from Employees as e
left join EmployeesProjects as p on p.[EmployeeID] = e.[EmployeeID]
where p.ProjectID is null
order by e.[EmployeeID]


-- 06. Employees Hired After

select [FirstName], 
		[LastName], 
		[HireDate], 
		d.[Name] as [DeptName]
from Employees as e
inner join Departments as d on d.[DepartmentID] = e.[DepartmentID]
where DATEDIFF(day, CONVERT(smalldatetime,'1/1/1999', 103), [HireDate]) > 0
	  and d.[Name] in ('Sales', 'Finance')
order by e.[HireDate] asc
 

-- 07. Employees with Project
-- casting codes: msdn.microsoft.com/en-us/library/ms187928(v=sql.90).aspx

select top(5) e.[EmployeeID], 
				[FirstName], 
				p.[Name] as [ProjectName]
from Employees as e
inner join EmployeesProjects as ep on ep.[EmployeeID] = e.[EmployeeID]
inner join Projects as p on p.[ProjectID] = ep.[ProjectID]
where DATEDIFF(day, CONVERT(smalldatetime,'13/08/2002', 103), p.[StartDate]) > 0
      AND p.[EndDate] is null
order by e.[EmployeeID] asc



-- 08. Employee 24

select e.[EmployeeID], 
		 [FirstName], 
		 case 
			 when DATEPART(year, p.[StartDate]) >= 2005 then NULL
			 else p.[Name]
		 end as [ProjectName]
from Employees as e
inner join EmployeesProjects as ep on ep.[EmployeeID] = e.[EmployeeID]
inner join Projects as p on p.[ProjectID] = ep.[ProjectID]
where e.[EmployeeID] = 24


-- 09. Employee Manager

select e.[EmployeeID], 
       e.[FirstName], 
	   e.[ManagerID], m.[FirstName] as [ManagerName]
from Employees as e
right outer join Employees as m on m.[EmployeeID] = e.[ManagerID]
where e.ManagerID in (3,7)
order by e.[EmployeeID] asc



-- 10. Employee Summary

select top(50) e.[EmployeeID],
		e.[FirstName] + ' ' + e.[LastName] as [EmployeeName],
		m.[FirstName] + ' ' + m.[LastName] as [ManagerName],
		d.[Name] as [DepartmentName]
from Employees as e
join Employees as m on m.[EmployeeID] = e.[ManagerID]
join Departments as d on d.[DepartmentID] = e.[DepartmentID]
order by e.[EmployeeID]


-- 11. Min Average Salary

select TOP(1) AVG([Salary]) as [MinAverageSalary]
from Employees
group by [DepartmentID]
order by AVG([Salary]) asc


-- 12. Highest peaks in Bulgaria

USE Geography
GO

select [CountryCode], [MountainRange], [PeakName], [Elevation]
from Peaks as p
join Mountains as m on m.[Id] = p.[MountainId]
join MountainsCountries as mc on mc.[MountainId] = p.[MountainId]
where [Elevation] > 2835 AND mc.[CountryCode] = 'BG'
order by [Elevation] desc


-- 13. Count Mountain Ranges

select mc.[CountryCode],
		COUNT([MountainId]) as [MountainRanges]
from MountainsCountries as mc
join Countries as c on c.[CountryCode] = mc.[CountryCode] 
where c.[CountryName] in ('United States','Russia','Bulgaria')
group by mc.[CountryCode]


-- 14.





































