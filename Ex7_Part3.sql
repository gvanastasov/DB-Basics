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
		where [Id] = @userGameId

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
				where [Id] = @userGameId

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



--

















