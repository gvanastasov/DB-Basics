----------------------------------------------
-- 1. Database design
----------------------------------------------

create database Bakery
go

use Bakery
go

create table Countries(
	[Id] int identity(1,1) PRIMARY KEY,
	[Name] nvarchar(50) UNIQUE
)

create table Customers(
	
	[Id] int identity(1,1) PRIMARY KEY,
	[FirstName] nvarchar(25),
	[LastName] nvarchar(25),
	[Gender] varchar(1) CHECK (Gender IN('M','F')),
	[Age] int,
	[PhoneNumber] varchar(10) CHECK (DATALENGTH(PhoneNumber) = 10),
	[CountryId] int FOREIGN KEY REFERENCES Countries(Id)

)

create table Products(
	
	[Id] int identity(1,1) PRIMARY KEY,
	[Name] nvarchar(25) UNIQUE,
	[Description] nvarchar(250),
	[Recipe] nvarchar(max),
	[Price] money CHECK([Price] >= 0)

)

create table Feedbacks(

	[Id] int identity(1,1) PRIMARY KEY,
	[Description] nvarchar(255),
	[Rate] decimal(10,2) CHECK ([Rate] between 0.00 and 10.00),
	[ProductId] int FOREIGN KEY references Products(Id),
	[CustomerId] int FOREIGN KEY references Customers(Id)

)

create table Distributors(

	[Id] int identity(1,1) PRIMARY KEY,
	[Name] nvarchar(25) UNIQUE,
	[AddressText] nvarchar(30),
	[Summary] nvarchar(200),
	[CountryId] int FOREIGN KEY references Countries(Id)

)


create table Ingredients(

	[Id] int identity(1,1) PRIMARY KEY,
	[Name] nvarchar(30),
	[Description] nvarchar(200),
	[OriginCountryId] int FOREIGN KEY references Countries(Id),
	[DistributorId] int FOREIGN KEY references Distributors(Id)

)

create table ProductsIngredients(

	[ProductId] int FOREIGN KEY references Products(Id),
	[IngredientId] int FOREIGN KEY references Ingredients(Id)
	CONSTRAINT PK_ProductIngredient PRIMARY KEY ([ProductId], [IngredientId])

)

----------------------------------------------
-- 02. Insert
----------------------------------------------

insert into Distributors([Name],[CountryId], [AddressText], [Summary]) values
	('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
	('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
	('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
	('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group'),
	('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')

insert into Customers([FirstName], [LastName], [Age], [Gender], [PhoneNumber], [CountryId]) values
	('Francoise','Rautenstrauch',15,'M','0195698399',5),
	('Kendra','Loud',22,'F','0063631526',11),
	('Lourdes','Bauswell',50,'M','0139037043',8),
	('Hannah','Edmison',18, 'F','0043343686',1),
	('Tom','Loeza',31,'M','0144876096', 23),
	('Queenie','Kramarczyk',30,'F','0064215793', 29),
	('Hiu','Portaro',25,'M','0068277755', 16),
	('Josefa','Opitz',42,'F','0197887645',17)

----------------------------------------------
-- 03. Update
----------------------------------------------

update Ingredients
set [DistributorId] = 35
where [Name] in ('Bay Leaf','Paprika','Poppy')

update Ingredients
set [OriginCountryId] = 14
where [OriginCountryId] = 8

----------------------------------------------
-- 04. Delete
----------------------------------------------

delete from Feedbacks
where
	([CustomerId] = 14
	OR [ProductId] = 5)

----------------------------------------------
-- 05. Products by Price
----------------------------------------------

SELECT [Name], [Price], [Description] from Products
ORDER BY [Price] desc, [Name] asc


----------------------------------------------
-- 06. Ingredients
----------------------------------------------

select [Name], [Description], [OriginCountryId] from Ingredients
where [OriginCountryId] in (1,10,20)
order by [Id] asc


----------------------------------------------
-- 07. Ingredients from Bulgaria and Greece
----------------------------------------------

select top (15) i.[Name], 
				i.[Description], 
				c.[Name] as [CountryName] from Ingredients as i
join Countries as c on i.OriginCountryId = c.Id
where 
	c.[Name] in ('Bulgaria', 'Greece')
order by
	i.[Name] asc, [CountryName] asc


----------------------------------------------
-- 08. Best Rated Products
----------------------------------------------

select top (10) [Name], 
			    [Description],
			    AVG([Rate]) as [AverageRate],
			    COUNT([Rate]) as [FeedbacksAmount] from
						(
							select p.[Name], p.[Description], f.[Rate] from Products as p
							join Feedbacks as f on p.[Id] = f.[ProductId]
						) as rates
group by [Name], [Description]
order by 
	[AverageRate] desc, [FeedbacksAmount] desc


----------------------------------------------
-- 09. Negative Feedback
----------------------------------------------

select [ProductId], [Rate], [Description], [CustomerId], c.[Age], c.[Gender] from Feedbacks as f
join Customers as c on f.[CustomerId] = c.[Id]
where [Rate] < 5.0
order by [ProductId] desc, [Rate] asc


----------------------------------------------
-- 10. Customers without Feedback
----------------------------------------------

select  [FirstName] + ' ' + [LastName] as [CustomerName],
		[PhoneNumber],
		[Gender] from Customers as c
where 
	c.[Id] not in (select [CustomerId] from Feedbacks)
order by 
	c.[Id] asc


----------------------------------------------
-- 11. Honorable Mentions
----------------------------------------------

select f.[ProductId],
	   c.[FirstName] + ' ' + c.[LastName] as [CustomerName],
	   f.[Description] from Feedbacks as f
join Customers as c on f.[CustomerId] = c.[Id]
where 
	[CustomerId] in (select [CustomerId] from Feedbacks
					 group by [CustomerId]
					 having COUNT([CustomerId]) >= 3)
order by [ProductId], [CustomerName], f.[Id]

----------------------------------------------
-- 12. Customers by Criteria
----------------------------------------------

select [FirstName], [Age], [PhoneNumber] from Customers
where
	[Age] >= 21 AND [FirstName] LIKE '%an%'
	OR RIGHT(2, [PhoneNumber]) = '38'
order by
	[FirstName] asc, [Age] desc

----------------------------------------------
-- 13. Middle Range Distributors
----------------------------------------------

select d.[Name] as [DistributorName],
	   i.[Name] as [IngredientName],
	   mid.[ProductName],
	   mid.[AverageRate] from 
							(select p.[Id],
									p.[Name] as [ProductName],
									AVG(f.[Rate]) as [AverageRate] 
							from Products as p
							join Feedbacks as f on f.[ProductId] = p.[Id]
							group by 
								p.[Id], p.[Name]
							having
								AVG(f.[Rate]) between 5 and 8) as mid

join ProductsIngredients as pri on pri.[ProductId] = mid.[Id]
join Ingredients as i on i.[Id] = pri.[IngredientId]
join Distributors as d on d.[Id] = i.[DistributorId]
order by [DistributorName], [IngredientName], [ProductName]

----------------------------------------------
-- 14. The Most Positive Country
----------------------------------------------

select [Name], [FeedbackRate] from 
	
	(select ctr.[Name], AVG([Rate]) as [FeedbackRate],
		   RANK() OVER(ORDER BY AVG([Rate]) desc) as [Rank] 
													from Feedbacks as f
	join Customers as cm on cm.[Id] = f.[CustomerId]
	left join Countries as ctr on ctr.[Id] = cm.[CountryId]
	group by ctr.[Name]) as tops
where
	[Rank] = 1
	
----------------------------------------------
-- 15. Country Representative
----------------------------------------------
select [CountryName], [DistributorName] from (
	select c.[Name] as [CountryName],
		   d.[Name] as [DistributorName],
		   Rank() OVER(
						PARTITION BY c.[Name] 
						ORDER BY dtr.[DistributionAmount]) as [Rank] from 
				(select [DistributorId], 
						COUNT([DistributorId]) as [DistributionAmount] from Ingredients as i
				group by [DistributorId]) as dtr
	join Distributors as d on d.[Id] = dtr.[DistributorId]
	join Countries as c on c.[Id] = d.[CountryId] ) as rkd
where [Rank] = 1
order by [CountryName], [DistributorName]

----------------------------------------------
-- 16. Customers with Countries
----------------------------------------------

go

create view v_UserWithCountries as
select [FirstName] + ' ' + [LastName] as [CustomerName], 
       [Age], 
	   [Gender], 
	   ctr.[Name] as [CountryName] from Customers as c
join Countries as ctr on ctr.[Id] = c.[CountryId]

go

select top(5) * from v_UserWithCountries order by Age

----------------------------------------------
-- 17. Feedback by Product Name
----------------------------------------------
go

create function udf_GetRating(@name nvarchar(25))
returns nvarchar(20)
as
	begin
		declare @rate as decimal(10,2);

		select @rate = AVG(f.[Rate]) from Products as p
		join Feedbacks as f on f.[ProductId] = p.[Id]
		group by p.[Name]
		having p.[Name] = @name

		declare @word as nvarchar(20);
		select @word = case 
			when @rate < 5 then 'Bad'
			when @rate between 5 and 8 then 'Average'
			when @rate > 8 then 'Good'
			else 'No rating'
		end;

		return @word;
	end

go

SELECT TOP 5 Id, Name, dbo.udf_GetRating(Name) FROM Products ORDER BY Id

----------------------------------------------
-- 18. Send Feedback
----------------------------------------------
go
create procedure usp_SendFeedback
	@CustomerId int,
	@ProductId int,
	@Rate decimal(10,2),
	@Description nvarchar(200)
as
	begin
		declare @currentRateCount int;

		select @currentRateCount = COUNT(f.[Id]) from Feedbacks as f
		where 
			f.[CustomerId] = @CustomerId 
			AND f.[ProductId] = @ProductId

		begin transaction
		if @currentRateCount >= 3
			begin
				raiserror('You are limited to only 3 feedbacks per product!', 16, 1);
				rollback;
				return;
			end

		insert into Feedbacks
		values (@Description, @Rate, @ProductId, @CustomerId)
		commit;
	end

go


exec usp_SendFeedback 1, 5, 7.50, 'Average experience';

select COUNT(*) from Feedbacks where CustomerId = 1 AND ProductId = 5

----------------------------------------------
-- 19. Delete Products
----------------------------------------------
go

drop trigger tr_DeleteProduct

go

create trigger tr_DeleteProduct on Products instead of DELETE
as
	begin

	begin transaction
	
	create table ids([Id] int);
	insert into ids select [Id] from DELETED

	delete from ProductsIngredients
	where
		ProductId in (select * from ids)

	delete from Feedbacks
	where 
		ProductId in (select * from ids)
			
	delete from Products
	where
		[Id] in (select * from ids)

	rollback

	end

go

delete from Products where id = 7


----------------------------------------------
-- 20. Products by One Distributor
----------------------------------------------
select p.[Name] as [ProductName],
	   AVG( [ProductAverageRate] from (
	select p.[Id]
	from ProductsIngredients as pri
		join Ingredients as i on i.[Id] = pri.[IngredientId]
		join Distributors as d on d.[Id] = i.[DistributorId]
		join Products as p on p.[Id] = pri.ProductId
	group by p.[Id]
	having 
		COUNT(d.[Id]) = 1) as up
join Products as p on p.[Id] = up.[Id]
right join Feedbacks as f on f.[ProductId] = up.[Id]
group by p.[Name]
order by up.[Id]















