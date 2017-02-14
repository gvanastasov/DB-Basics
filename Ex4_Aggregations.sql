USE Gringotts
GO

-- 1. Records' Count

SELECT Count([Id]) as [Count] FROM WizzardDeposits

-- 2. Longest Magic Wand

SELECT MAX([MagicWandSize]) as [LongestMagicWand] FROM WizzardDeposits

-- 3. Longest Magic Wand per Deposit Groups

SELECT [DepositGroup],
	   MAX([MagicWandSize]) as [LongestMagicWand] FROM WizzardDeposits
GROUP BY [DepositGroup]

-- 4. Smallest Depost Group per Magic Wand Size

SELECT [DepositGroup] FROM WizzardDeposits
GROUP BY [DepositGroup]
HAVING AVG([MagicWandSize]) = (
								SELECT 
									TOP(1) AVG([MagicWandSize]) as [ave]
								FROM WizzardDeposits
								GROUP BY [DepositGroup]
								ORDER BY [ave])

-- 5. Deposits Sum

SELECT [DepositGroup],
	   SUM([DepositAmount]) AS [TotalSum]
FROM WizzardDeposits
GROUP BY [DepositGroup]


-- 6. Deposits Sum for ollivander family

  SELECT [DepositGroup], 
	     SUM([DepositAmount]) AS [TotalSum] 

    FROM WizzardDeposits
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]

-- 7. Deposits Filter

  SELECT [DepositGroup], 
	     SUM([DepositAmount]) AS [TotalSum] 

    FROM WizzardDeposits
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]
  HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

-- 8. Deposit Charge

SELECT [DepositGroup],
	   [MagicWandCreator],
	   MIN([DepositCharge]) as [MinDepositCharge]
FROM WizzardDeposits
GROUP BY [DepositGroup], [MagicWandCreator]
ORDER BY [MagicWandCreator], [DepositGroup]

-- 9. Age Groups

SELECT	grp.age_group as [AgeGroup], 
		Count(grp.Id) as [WizardCount]
  FROM (
		SELECT case 
					when [Age] BETWEEN 0 AND 10 then '[0-10]'
					when [Age] BETWEEN 11 AND 20 then '[11-20]'
					when [Age] BETWEEN 21 AND 30 then '[21-30]'
					when [Age] BETWEEN 31 AND 40 then '[31-40]'
					when [Age] BETWEEN 41 AND 50 then '[41-50]'
					when [Age] BETWEEN 51 AND 60 then '[51-60]'
					else '[61+]'
					end as age_group,
				Id FROM WizzardDeposits
		) as grp
GROUP BY grp.age_group

-- 10.First Letter

SELECT LEFT([FirstName], 1) as [FirstLetter] FROM WizzardDeposits
WHERE [DepositGroup] = 'Troll Chest'
GROUP BY LEFT([FirstName], 1)
ORDER BY [FirstLetter]

-- 11.Average Interest

  SELECT [DepositGroup],
	     [IsDepositExpired],
	     AVG([DepositInterest])
    FROM WizzardDeposits

   WHERE [DepositStartDate] >= CAST('01/01/1985' AS datetime)
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] desc, [IsDepositExpired] asc

-- 12.Rich Wizard, poor wizard

SELECT CONVERT(decimal(18,2), SUM(df.[difference])) 
FROM (
	SELECT [DepositAmount] - (SELECT DepositAmount 
								FROM WizzardDeposits 
							   WHERE [Id] = hdb.[Id] + 1) as [difference]
	 FROM WizzardDeposits as hdb
) as df

-- 13.Department TOtal Salaries

USE SoftUni
GO

SELECT [DepartmentID], 
		SUM([Salary]) AS [TotalSalary]
FROM Employees
GROUP BY [DepartmentID]
ORDER BY [DepartmentID]


-- 14. Employees Minimum Salaries

SELECT [DepartmentID],
		MIN([Salary])
FROM Employees
WHERE [HireDate] >= CAST('01/01/2000' AS datetime)
GROUP BY [DepartmentID]
HAVING [DepartmentID] in (2,5,7)


-- 15. Employees aaverage salaries

SELECT * INTO [EmployeesAS] FROM Employees
WHERE Employees.[Salary] >= 30000

DELETE FROM EmployeesAS
WHERE [ManagerID] = 42

UPDATE EmployeesAS
SET [Salary] += 5000
WHERE [DepartmentID] = 1

SELECT [DepartmentID],
	AVG([Salary]) as [AverageSalary]
FROM EmployeesAS
GROUP BY [DepartmentID]

-- 16. Employees Maximum Salaries

SELECT [DepartmentID],
	MAX([Salary]) as [MaxSalary]
FROM Employees
GROUP BY [DepartmentID]
HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000


-- 17. Employees Count Salaries

SELECT Count(EmployeeID) AS [Count] FROM Employees
WHERE [ManagerID] IS NULL
GROUP BY [ManagerID]


























