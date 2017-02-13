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
ORDER BY [LongestMagicWand]

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



















