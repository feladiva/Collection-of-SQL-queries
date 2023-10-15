USE VOkin
GO

--1.
CREATE VIEW ProductView
AS
SELECT
	ProductID,
	ProductName,
	ProductPrice
FROM MsProduct
WHERE ProductPrice BETWEEN 100000 AND 120000

GO


--2.
SELECT
	CustomerName,
	CustomerGender,
	CustomerPhone
FROM MsCustomer mc
WHERE mc.CustomerID IN
(
	SELECT
		th.CustomerID
	FROM TransactionHeader th
	WHERE MONTH(TransactionDate) = '7'
)

--3.
SELECT
	mc.CustomerID,
	CustomerName,
	CustomerGender,
	[Purchase Year] = DATEPART(YEAR, TransactionDate),
	[Purchase Count] = COUNT(TransactionID)
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE mc.CustomerID LIKE 'CU001'
GROUP BY mc.CustomerID, CustomerName, CustomerGender, DATEPART(YEAR, TransactionDate)
UNION
SELECT
	mc.CustomerID,
	CustomerName,
	CustomerGender,
	[Purchase Year] = DATEPART(YEAR, TransactionDate),
	[Purchase Count] = COUNT(TransactionID)
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE mc.CustomerID LIKE 'CU002'
GROUP BY mc.CustomerID, CustomerName, CustomerGender, DATEPART(YEAR, TransactionDate)

--4.
SELECT
	StaffName,
	StaffGender,
	[TransactionDate] = CONVERT(VARCHAR, TransactionDate, 103),
	[Total Product Sold] = SUM(Quantity)
FROM MsStaff ms JOIN TransactionHeader th ON ms.StaffID = th.StaffID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
WHERE StaffGender LIKE 'female' AND DATENAME(WEEKDAY, TransactionDate) = 'tuesday'
GROUP BY StaffName, StaffGender, CONVERT(VARCHAR, TransactionDate, 103)

--5.
SELECT DISTINCT
	[ProductID] = 'VOkin' + RIGHT(ProductID, 3),
	ProductName,
	ProductPrice,
	VariantName
FROM MsProduct mp JOIN MsVariant mv ON mp.VariantID = mv.VariantID,
(
	SELECT
	[Avg] = AVG(mp2.ProductPrice)
	FROM MsProduct mp2
) x
WHERE VariantName LIKE 'calming' AND ProductPrice < x.[Avg]



