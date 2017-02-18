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
ORDER BY [FirstName] asc, [LastName] desc

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

select top(3) e.[EmployeeID], [FirstName], p.[ProjectID]
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
where DATEDIFF(day, '1/1/1999', [HireDate]) > 0
	  and d.[Name] in ('Sales', 'Finance')
order by e.[HireDate] asc
 












































