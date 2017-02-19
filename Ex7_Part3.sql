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









