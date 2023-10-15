USE PuDY
GO

--1. 
CREATE VIEW ViewStaffInformation
AS
SELECT
	StaffName,
	StaffGender,
	[StaffDOB] = CONVERT(VARCHAR, StaffDOB, 107),
	StaffSalary
FROM MsStaff
WHERE StaffSalary < 3500000

SELECT * FROM ViewStaffInformation

--2. 
SELECT
	CustomerName,
	CustomerGender,
	CustomerPhone,
	CustomerEmail
FROM MsCustomer mc
WHERE mc.CustomerID IN (
	SELECT th.CustomerID
	FROM TransactionHeader th
	WHERE MONTH(TransactionDate) = '6'
)

--3.
SELECT
	mc.CustomerID,
	CustomerName,
	[Total Purchase] = COUNT(TransactionID),
	[Month of Purchase] = DATENAME(MONTH, TransactionDate)
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE DAY(TransactionDate) = '12'
GROUP BY mc.CustomerID, CustomerName, DATENAME(MONTH, TransactionDate)
UNION
SELECT
	mc.CustomerID,
	CustomerName,
	[Total Purchase] = COUNT(TransactionID),
	[Month of Purchase] = DATENAME(MONTH, TransactionDate)
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE DAY(TransactionDate) = '30'
GROUP BY mc.CustomerID, CustomerName, DATENAME(MONTH, TransactionDate)

--4.
SELECT
	mp.PuddingID,
	PuddingName,
	[Total Income] = SUM(Quantity * PuddingPrice)
FROM MsPudding mp JOIN TransactionDetail td ON mp.PuddingID = td.PuddingID
JOIN TransactionHeader th ON th.TransactionID = td.TransactionID
WHERE TransactionDate BETWEEN '2021-04-10' AND DATEADD(DAY, 5, '2021-04-10')
AND PuddingPrice >= 30000
GROUP BY mp.PuddingID, PuddingName

--5.
SELECT
	[StaffName] = LOWER(StaffName),
	TransactionDate,
	[Flavor] = LEFT(PuddingName, CHARINDEX(' ', PuddingName) - 1),
	Quantity
FROM MsStaff ms JOIN TransactionHeader th ON ms.StaffID = th.StaffID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsPudding mp ON mp.PuddingID = td.PuddingID,
(
	SELECT
		[Avg] = AVG(mp2.PuddingPrice)
	FROM MsPudding mp2
) X
WHERE Quantity >= 5 AND PuddingPrice < X.[Avg]