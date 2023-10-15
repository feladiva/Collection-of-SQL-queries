USE [MouseAN_Shop]

CREATE TABLE MsTypeMouse (
	TypeID CHAR(5) PRIMARY KEY CHECK (TypeID LIKE 'TY[0-9][0-9][0-9]') NOT NULL,
	TypeName VARCHAR(20) CHECK (TypeName LIKE 'Mouse %') NOT NULL,
	TypeDescription VARCHAR(255) NOT NULL
)

ALTER TABLE MsCashier
ADD CashierEmail VARCHAR(20)

ALTER TABLE MsCashier
ADD CONSTRAINT CK_CashierEmail CHECK(CashierEmail LIKE '%.com')

--SELECT * 
--FROM MsCashier


INSERT INTO MsCustomer VALUES ('CU011', 'Stefanus Geory Michael', 'Male', '57, King Cobra Street', '08980418508')
SELECT *
FROM MsCustomer

SELECT
CustomerName,
CustomerAddress,
CustomerGender
FROM MsCustomer
WHERE CustomerName LIKE 'A%'

SELECT *
FROM HeaderTransaction

UPDATE MsCashier
SET CashierSalary += 50000
FROM MsCashier, HeaderTransaction
WHERE MsCashier.CashierID = HeaderTransaction.CashierID AND MONTH(TransactionDate) = 6
SELECT *
FROM MsCashier

DROP DATABASE [MouseAN_Shop]