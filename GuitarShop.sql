USE [TanGuitar]


CREATE TABLE Discount (
	DiscountId CHAR(5) PRIMARY KEY CHECK(DiscountId LIKE 'DI[0-9][0-9][0-9]'),
	GuitarId CHAR(5) NOT NULL,
	DiscountValue NUMERIC CHECK(DiscountValue >= 10 AND DiscountValue <= 50) NOT NULL,
	DiscountDate DATE NOT NULL
)

ALTER TABLE Customer
ADD CustomerEmail VARCHAR(255)

ALTER TABLE Customer
ADD CONSTRAINT CK_CustomerEmail CHECK (CustomerEmail LIKE '%.com')

SELECT *
FROM Customer

INSERT INTO Staff VALUES ('ST008', 'John Connor', 'Male', '1990-02-03')

SELECT *
FROM Staff

SELECT
	GuitarId,
	GuitarName,
	GuitarPrice
FROM Guitar
WHERE (LEN(GuitarName)>=10)

UPDATE Guitar
SET GuitarPrice += 50000
FROM Guitar, GuitarType
WHERE Guitar.GuitarTypeID = GuitarType.GuitarTypeID AND (GuitarTypeName IN ('Silent' , 'Acoustic'))
SELECT *
FROM Guitar