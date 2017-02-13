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



















