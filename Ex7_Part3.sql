-----------------------------------------
-- PART III
-----------------------------------------

use Diablo
go

--BACKUP DATABASE Diablo
--TO DISK = 'C:\Users\Georgi\Documents\Softuni\05 DB Basics\DB_Backups\Diablo_ex7.Bak'
--	WITH FORMAT,
--		MEDIANAME = 'DB_Backups',
--		NAME = 'Full Backup of DiabloDB';
--go

--use master
--go
--RESTORE DATABASE Diablo
--FROM DISK = 'C:\Users\Georgi\Documents\Softuni\05 DB Basics\DB_Backups\Diablo_ex7.Bak';
--go


--  19. Scalar function: cash in user games odd rows

create function ufn_CashInUsersGames(@gameName nvarchar(50))
returns @cash table (
				[GameCash] money)
as
	begin

	insert into @cash
		select Sum([Cash]) 
		from(
			select [GameId], 
				   [Cash],
				   ROW_NUMBER() OVER (order by [Cash] desc) AS [RowNumber]
			from UsersGames as ug
			join Games as g on ug.[GameId] = g.[Id]
			where g.[Name] = @gameName
		) as c
		WHERE c.[RowNumber] % 2 <>0

	return;
	end
go

select * from dbo.ufn_CashInUsersGames('Lily Stargazer')
go

-- 20. Trigger

create trigger tr_OnUserAddItem on UserGameItems instead of INSERT
as
	begin
		
		declare @itemId int, 
				@userGameId int,
				@userLevel int,
				@itemLevel int,
				@itemPrice money;
		
		select @itemId = [ItemId], 
			   @userGameId = [UserGameId] 
		from inserted

		select @userLevel = [Level]
		from UsersGames
		where [GameId] = @userGameId

		select @itemLevel = [MinLevel],
				@itemPrice = [Price]
		from Items
		where [Id] = @itemId

		declare @t nvarchar(200) = Concat('ugameid: ',@userGameId,'ulvl: ',@userLevel,' ilvl: ',@itemLevel);
		raiserror(@t, 0,0)  

		if @userLevel >= @itemLevel
			begin
				insert into UserGameItems
				values (@itemId, @userGameId)

				update UsersGames set [Cash] -= @itemPrice
				where [GameId] = @userGameId

			end
		else
			raiserror('Character level is too low',1,16)
	end
go

delete from UserGameItems
where [ItemId] = 6 and [UserGameId] = 212

-- will not work coz of level trigger
insert into UserGameItems
values (6, 212)

while LEN(@word) > 0
			begin
			set @letter = LEFT(@word,1);
			if CHARINDEX(@letter, @setOfLetters) = 0
				return 0;
			set @word = RIGHT(@word, LEN(@word) - 1);
			end

-- 21. Massive Shopping

declare @gameId int, @sum1 money, @sum2 money

select @gameId = usg.[Id]
	from UsersGames as usg
	join Games as g 
		on usg.[GameId] = g.[Id]
	where g.[Name] = 'Safflower'

set @sum1 = (SELECT SUM(i.Price)
			FROM Items i
			WHERE MinLevel BETWEEN 11 AND 12)
set @sum2 = (SELECT SUM(i.Price)
			FROM Items i
			WHERE MinLevel BETWEEN 19 AND 21)

begin transaction
IF (SELECT Cash FROM UsersGames WHERE Id = @gameId) < @sum1
	ROLLBACK
ELSE 
	BEGIN
		UPDATE UsersGames
		SET Cash = Cash - @sum1
		WHERE Id = @gameId

		INSERT INTO UserGameItems (UserGameId, ItemId)
		SELECT @gameId, Id 
		FROM Items 
		WHERE MinLevel BETWEEN 11 AND 12

		COMMIT
	END

begin transaction

IF (SELECT Cash FROM UsersGames WHERE Id = @gameId) < @sum2
	ROLLBACK
ELSE 
	BEGIN
		UPDATE UsersGames
		SET Cash = Cash - @sum2
		WHERE Id = @gameId

		INSERT INTO UserGameItems (UserGameId, ItemId)
		SELECT @gameId, Id 
		FROM Items 
		WHERE MinLevel BETWEEN 19 AND 21
		COMMIT
	END

SELECT i.Name AS 'Item Name' 
FROM UserGameItems ugi
JOIN Items i
ON ugi.ItemId = i.Id
WHERE ugi.UserGameId = @gameId

-- 22. Number of Users for Email Provider



















