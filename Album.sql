USE [MusicStore]

--1.
CREATE TABLE Customer(
	customerId CHAR(5) PRIMARY KEY CHECK(customerId LIKE 'CS[0-9][0-9][0-9]'),
	customerName VARCHAR(70) CHECK(LEN(CustomerName)>5 AND LEN(CustomerName)<70),
	customerDOB DATE NOT NULL,
	customerEmail VARCHAR(254) NOT NULL,
	customerPassword VARCHAR(128) NOT NULL
	)

--2.
ALTER TABLE Staff
ADD staffAddress VARCHAR (255)

ALTER TABLE Staff
ADD CONSTRAINT CK_staffEmail CHECK(staffEmail LIKE '%@musicstr.com')

--3.
INSERT INTO Artist VALUES ('AR011', 'Bruno Mars', '10-08-1985', 'brunomars.com')

--4.
SELECT
	UPPER(albumName) AS [Name],
	price AS [Price]
FROM Album
WHERE price > 180000

--5.
UPDATE Album
SET price += 8000
FROM Album, Artist
WHERE Album.artistId = Artist.artistId AND YEAR(artistDOB) = 1988

SELECT *
FROM Album