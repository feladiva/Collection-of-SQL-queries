USE [FlowerDelivery]

--1.
CREATE TABLE DeliveryType(
	DeliveryID CHAR(6) PRIMARY KEY CHECK(DeliveryID LIKE 'DLR[0-9][0-9][0-9]'),
	DeliveryTypeName VARCHAR(50) NOT NULL CHECK(DeliveryTypeName = 'Regular' OR DeliveryTypeName = 'Express'),
	DeliveryCost INT NOT NULL
)

--2.
ALTER TABLE Staff
ADD Salary INT

SELECT *
FROM Staff

ALTER TABLE Staff
DROP COLUMN Salary

--3.
SELECT * FROM Staff

INSERT INTO Staff VALUES
('STF008', 'Agus Sasmito', 'Male', '1989-12-29', 'Driver', 'ajustgaus@sasa.com', 'Graha ...', '0810178')

--4.
SELECT
	FlowerID,
	FlowerName,
	FlowerColor,
	FlowerType,
	Price
FROM Flower
WHERE FlowerName LIKE 'P%'

--5.
SELECT * FROM DetailTransaction
UPDATE d
SET AdditionalReq = 'Ribbon'
FROM DetailTransaction d, HeaderTransaction ht
WHERE d.TransactionID = ht.TransactionID AND DAY(TransactionDate) = 6