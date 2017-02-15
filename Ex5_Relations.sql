-- 0. Prapare database

CREATE DATABASE RelationsHWK
GO

USE RelationsHWK
GO

-- 1. One-To-One Relationship
create table Persons
(
	PersonID int not null,
	FirstName nvarchar(50) not null,
	Salary decimal(10,2) not null,
	PassportID int not null
)

create table Passports
(
	PassportID int not null,
	PassportNumber nvarchar(8) not null
)

INSERT INTO Persons VALUES
(1,'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101)

INSERT INTO Passports VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

ALTER TABLE Persons
ADD PRIMARY KEY (PersonID)

ALTER TABLE Passports
ADD PRIMARY KEY (PassportID)

ALTER TABLE Persons
ADD CONSTRAINT FK_Person_Passport 
FOREIGN KEY ([PassportID]) 
REFERENCES Passports([PassportID]) 

-- 02. One-To-Many Relationship

create table Models
(
	[ModelID] int primary key identity(101,1),
	[Name] nvarchar(50) not null,
	[ManufacturerID] int not null
)

create table Manufacturers
(
	[ManufacturerID] int primary key identity(1,1),
	[Name] nvarchar(50) not null,
	[EstablishedOn] date not null
)

insert into Models([Name], [ManufacturerID]) VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

insert into Manufacturers ([Name], [EstablishedOn]) VALUES
('BMW', CONVERT(date, '07/03/1916')),
('Tesla', CONVERT(date, '01/01/2003')),
('Lada', CONVERT(date, '01/05/1966'))

ALTER TABLE Models
ADD CONSTRAINT FK_Model_Manufacturer
FOREIGN KEY ([ManufacturerID])
REFERENCES Manufacturers([ManufacturerID])







