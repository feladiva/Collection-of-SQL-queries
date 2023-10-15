CREATE DATABASE Photographer
USE Photographer

CREATE TABLE Customer(
	CustID CHAR(5) PRIMARY KEY,
	CustName VARCHAR(50) NOT NULL,
)

INSERT INTO Customer
VALUES('CU001', 'Nadia'),
('CU002', 'Wisnu Handoko'),
('CU003', 'Jeanni Lee')

CREATE TABLE Photographer(
	PhotographerID CHAR(5) PRIMARY KEY,
	PhotographerName VARCHAR(50),
	PhotographerGender VARCHAR(10)
)


INSERT INTO Photographer VALUES
('PH001', 'Amanda Wijaya', 'Female'),
('PH002', 'Daniel Surya', 'Male'),
('PH003', 'Nanda Julia', 'Female')

CREATE TABLE PortofolioAlbum(
	PortofolioAlbumID CHAR(5) PRIMARY KEY,
	PhotographerID CHAR(5) FOREIGN KEY REFERENCES Photographer(PhotographerID),
	AlbumTitle VARCHAR(50) NOT NULL
)


INSERT INTO PortofolioAlbum
VALUES('PA001', 'PH001', 'Portofolio A'),
('PA002', 'PH002', 'Daniel Documentations'),
('PA003', 'PH003', 'Through the Lenses')


CREATE TABLE TransactionHeader (
	TransactionID CHAR(5) PRIMARY KEY,
	CustID CHAR(5) FOREIGN KEY REFERENCES Customer(CustID),
	PhotographerID CHAR(5) FOREIGN KEY REFERENCES Photographer(PhotographerID),
	EventDate DATE NOT NULL,
	BookingDate DATE NOT NULL
)


INSERT INTO TransactionHeader
VALUES
('TR001', 'CU001', 'PH001', '2021-09-15', '2021-05-22'),
('TR002', 'CU002', 'PH002', '2019-03-24', '2019-01-26'),
('TR003', 'CU003', 'PH003', '2022-10-02', '2022-08-21')

CREATE TABLE Payment(
	PaymentID CHAR(5) PRIMARY KEY,
	TransactionID CHAR(5) FOREIGN KEY REFERENCES TransactionHeader(TransactionID),
	PaymentDate DATE NOT NULL
)

INSERT INTO Payment
VALUES
('PY001', 'TR001', '2021-05-29'),
('PY002', 'TR002', '2019-01-28'),
('PY003', 'TR003', '2022-09-01')

GO
--CREATE VIEW

--INNER JOIN
CREATE VIEW ViewMayTransaction 
AS
SELECT 
	PhotographerID, 
	PaymentDate
FROM TransactionHeader tr INNER JOIN Payment pm ON tr.TransactionID = pm.TransactionID
WHERE DATENAME(MONTH, PaymentDate) = 'May'
GO

SELECT * FROM ViewMayTransaction
GO

--OUTER JOIN
CREATE VIEW ViewPhotographerPortofolio
AS
SELECT PhotographerName, AlbumTitle
FROM Photographer p FULL OUTER JOIN PortofolioAlbum pa ON p.PhotographerID = pa.PhotographerID
GO

SELECT * FROM ViewPhotographerPortofolio
GO


--SET OPERATOR
CREATE VIEW
ViewTransactionBasedOnBooking
AS
SELECT TransactionID, EventDate, BookingDate
FROM TransactionHeader
WHERE DATENAME(YEAR, BookingDate) = 2021
UNION
SELECT TransactionID, EventDate, BookingDate
FROM TransactionHeader
WHERE DATENAME(YEAR, BookingDate) = 2022
GO

SELECT * FROM ViewTransactionBasedOnBooking
GO


--SUBQUERY IN
CREATE VIEW
ViewMalePhotographerPorto
AS
SELECT PhotographerID, AlbumTitle
FROM PortofolioAlbum pa
WHERE pa.PhotographerID IN (
SELECT p.PhotographerID
FROM Photographer p
WHERE PhotographerGender = 'Male' )
GO

SELECT * FROM ViewMalePhotographerPorto
GO

--SUBQUERY EXISTS
CREATE VIEW ViewMayCustomer
AS
SELECT c.CustID, c.CustName
FROM Customer c
WHERE EXISTS (
SELECT *
FROM TransactionHeader tr JOIN Payment pm ON tr.TransactionID = pm.TransactionID
WHERE DATENAME(MONTH, pm.PaymentDate) = 'May' AND
c.CustID = tr.CustID)
GO

SELECT * FROM ViewMayCustomer
