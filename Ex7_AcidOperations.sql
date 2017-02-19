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
go

-- 11. People with Balance Higher Than

create PROCEDURE usp_GetHoldersWithBalanceHigherThan
(
	@sum MONEY
)
AS
BEGIN 
	SELECT FirstName AS [First Name], LastName AS [Last Name] FROM
	(
		SELECT FirstName, LastName, SUM(a.Balance) AS TotalBalance FROM AccountHolders AS ah
		JOIN Accounts AS a
		ON a.AccountHolderId = ah.Id
		GROUP BY ah.FirstName, ah.LastName
	) AS tb
	WHERE tb.TotalBalance > @sum
END

exec dbo.usp_GetHoldersWithBalanceHigherThan @sum=15000
go
-- 12. Future Value Function

create function ufn_CalculateFutureValue(
	@sum money, @yearlyInterestRate float, @years int)
returns money
as
	begin
		declare @futureValue money;
		set @futureValue = @sum * POWER((1+@yearlyInterestRate), @years);
		return @futureValue;
	end
go

select dbo.ufn_CalculateFutureValue(1000, 0.1, 5)
go




-- 13. Calculating Interest

create procedure usp_CalculateFutureValueForAccount
	@accountId int,
	@interestRate float
as
	begin
		select acc.[Id] as [Account Id],
				ah.[FirstName] as [First Name],
				ah.[LastName] as [Last Name],
				acc.[Balance] as [Current Balance],
				dbo.ufn_CalculateFutureValue(acc.[Balance], @interestRate, 5) as [Balance in 5 years]
		from AccountHolders as ah
		inner join Accounts as acc on ah.[Id] = acc.[AccountHolderId]
		where acc.[Id] = @accountId
	end
go

exec dbo.usp_CalculateFutureValueForAccount @accountId = 1, @interestRate = 0.1
go



-- 14. Deposit Money Procedure

create procedure usp_DepositMoney
	@accountId int,
	@amount money
as
	begin
		begin transaction
			update Accounts set [Balance] += @amount
			where [Id] = @accountId
		commit
	end
go

-- 15. Withdraw Money

create procedure usp_WithdrawMoney
	@accountId int,
	@amount money
as
	begin
		begin transaction
			update Accounts set [Balance] -= @amount
			where [Id] = @accountId
		commit
	end
go




-- 16. Money Transfer

create procedure usp_TransferMoney
	@senderId int,
	@receiverId int,
	@amount money
as
	begin
		
		declare @senderBalance money = (select [Balance]
										from Accounts
										where [Id] = @senderId);

		declare @receiverBalance money = (select [Balance]
										  from Accounts
										  where [Id] = @receiverId);
		
		declare @expectedSenderBalance money = @senderBalance - @amount;
		declare @expectedReceiverBalance money = @receiverBalance + @amount;

		begin transaction

		update Accounts set [Balance] -= @amount
		where [Id] = @senderId

		update Accounts set [Balance] += @amount
		where [Id] = @receiverId

		set @senderBalance = (select [Balance]
							  from Accounts
							  where [Id] = @senderId);

		set @receiverBalance = (select [Balance]
								from Accounts
								where [Id] = @receiverId);

		if(@expectedSenderBalance <> @senderBalance)
			begin
				raiserror('Sender''s Balance changed in due transaction time', 16, 1);
				rollback;
				return;
			end
		else if(@expectedReceiverBalance <> @receiverBalance)
			begin
				raiserror('Receiver''s Balance changed in due transaction time', 16, 1);
				rollback;
				return;
			end
		else if(@senderBalance < 0)
			begin
				raiserror('Sender has less money than amount', 16, 1);
				rollback;
				return;
			end
		else
			commit

	end


-- 17. Create Table logs

create table Logs(
	[LogId] int primary key identity(1,1),
	[AccountId] int not null,
	[OldSum] money default(0.00),
	[NewSum] money default(0.00)
)
go

create trigger tr_AccountsUpdate on Accounts instead of UPDATE
as
	begin
		declare @id int,
				@accountHolderId int,
		        @currentBalance money,
				@newBalance money;

		select @id = inserted.[Id],
				@accountHolderId = inserted.[AccountHolderId],
				@newBalance = inserted.[Balance] 
		from inserted

		set @currentBalance = (select [Balance] from Accounts
								where [Id] = @id)

		update Accounts 
		set [AccountHolderId] = @accountHolderId,
		    [Balance] = @newBalance
		where [id] = @id;

		insert into Logs values (@id, @currentBalance, @newBalance)
	end 

-- testing transaction
begin transaction
declare @t nvarchar(max) = (select [Balance] 
						    from Accounts 
							where [Id] = 1);
raiserror (@t, 0, 0) with nowait

exec dbo.usp_WithdrawMoney @accountId = 1, @amount = 15.09

set @t = (select [Balance] 
			from Accounts 
			where [Id] = 1);
raiserror (@t, 0, 0) with nowait

declare @log nvarchar(max);
select @log = Cast([LogId] as nvarchar(max)) + ' ' + 
					Cast([AccountId] as nvarchar(max)) + ' ' + 
					Cast([OldSum] as nvarchar(max)) + ' ' + 
					Cast([NewSum] as nvarchar(max)) from Logs
raiserror (@log, 0, 0) with nowait
rollback


-- 































