USE [BlueJack Coin Market]

--1.
CREATE TABLE Staff(
	StaffId CHAR(5) PRIMARY KEY CHECK(StaffId LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(100) NOT NULL,
	StaffGender VARCHAR(20) NOT NULL CHECK(StaffGender = 'Male' OR StaffGender = 'Female'),
	StaffSalary INT NOT NULL
)

--2. 
ALTER TABLE Exchange
ADD ExchangeWebsite VARCHAR(75)

ALTER TABLE Exchange
ADD CONSTRAINT CK_ExchangeWebsite CHECK(LEN(ExchangeWebsite) BETWEEN 10 AND 75)

SELECT *
FROM Exchange

--3.
INSERT INTO Customer VALUES 
('CU006', 'Elon Musk', 'Jl Raya Serpong No. 3, Serpong', 'Male', '081811833333')

SELECT *
FROM Customer

--4.
SELECT 
	CustomerId,
	CryptoId,
	Amount,
	Price
	FROM HeaderTransaction
	WHERE MONTH(TransactionDate) % 2 = 1

--5.
UPDATE Customer
SET CustomerPhone = '08185313713'
FROM Customer, HeaderTransaction
WHERE Customer.CustomerId = HeaderTransaction.CustomerId AND DAY(TransactionDate) = 4

SELECT *
FROM Customer