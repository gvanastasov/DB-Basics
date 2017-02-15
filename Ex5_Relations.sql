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








