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

-- 03. Many-To-Many

create table Students
(
	[StudentID] int primary key identity(1,1),
	[Name] nvarchar(50) not null
)

create table Exams
(
	[ExamID] int primary key identity(101,1),
	[Name] nvarchar(50) not null
)

create table StudentsExams
(
	[StudentID] int not null foreign key references Students([StudentID]),
	[ExamID] int not null foreign key references Exams([ExamID]),
	constraint PK_StudentExam primary key ([StudentID],[ExamID])
)

insert into Students values
('Mila'),('Toni'),('Ron')

insert into Exams values
('SpringMVC'),('Neo4j'),('Oracle 11g')

insert into StudentsExams values
(1,101),(1,102),
(2,101),
(3,103),
(2,102),(2,103)


-- 04. Self-Referencing

create table Teachers
(
	[TeacherID] int primary key identity(101,1),
	[Name] nvarchar(50) not null,
	[ManagerID] int null
)

insert into Teachers values
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

alter table Teachers
add constraint SR_Teacher_Manager
foreign key ([ManagerID])
references Teachers([TeacherID])

-- 05. Online Store Database

CREATE DATABASE OnlineStore
GO
USE OnlineStore
GO

USE master
DROP Database OnlineStore

create table Cities
(
	[CityID] int primary key,
	[Name] nvarchar(50) not null
)

create table Customers
(
	[CustomerID] int primary key,
	[Name] nvarchar(50) not null,
	[Birthday] date not null,
	[CityID] int not null foreign key references Cities([CityID])
)

create table Orders
(
	[OrderID] int primary key,
	[CustomerID] int not null foreign key references Customers([CustomerID])
)

create table ItemTypes
(
	[ItemTypeID] int primary key,
	[Name] nvarchar(50) not null
)

create table Items
(
	[ItemID] int primary key,
	[Name] nvarchar(50) not null,
	[ItemTypeID] int not null foreign key references ItemTypes([ItemTypeID])
)

create table OrderItems
(
	[OrderID] int not null foreign key references Orders([OrderID]),
	[ItemID] int not null foreign key references Items([ItemID]),
	constraint PK_Order_Item primary key ([OrderID],[ItemID])
)



















