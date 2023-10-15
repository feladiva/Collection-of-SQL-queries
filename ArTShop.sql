USE ArTShop
GO
--1.	Create a view named ‘PaintingViewer’ to display PaintingID, 
--PaintingName, and PaintingPrice for every painting that has a price between 100000 and 150000.
--(create view, between)

CREATE VIEW PaintingViewer 
AS
SELECT 
	PaintingID,
	PaintingName,
	PaintingPrice
FROM Painting
WHERE PaintingPrice BETWEEN 100000 AND 150000

--2. Display StaffID, StaffName, and StaffGender 
--for every staff that handled transactions that occurred in odd month.

SELECT
	StaffID,
	StaffName,
	StaffGender
FROM Staff s
WHERE s.StaffID IN (
	SELECT th.StaffID
	FROM TransactionHeader th
	WHERE MONTH(TransactionDate) % 2 =1
)

--3.
SELECT
	[Painting Name] = LOWER(PaintingName),
	PaintingType,
	[Total Sold] = SUM(Qty)
FROM Painting p JOIN TransactionDetail td ON p.PaintingID = td.PaintingID
WHERE PaintingType LIKE 'Pastel'
GROUP BY PaintingName, PaintingType
UNION 
SELECT
	[Painting Name] = LOWER(PaintingName),
	PaintingType,
	[Total Sold] = SUM(Qty)
FROM Painting p JOIN TransactionDetail td ON p.PaintingID = td.PaintingID
WHERE DATENAME(WEEKDAY, PaintDate) = 'Saturday'
GROUP BY PaintingName, PaintingType

--4. 

SELECT
	[CustomerName] = UPPER(CustomerName),
	[TotalPurchase] = SUM(Qty)
FROM Customer c JOIN TransactionHeader th ON c.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
WHERE CustomerGender LIKE 'Male'
AND DATENAME(MONTH, TransactionDate) = 'June'
GROUP BY CustomerName

--5.
SELECT
	[Staff Name] = SUBSTRING(s.StaffName, 1, CHARINDEX(' ', s.StaffName)),
	PaintingName
FROM Staff s
JOIN TransactionHeader th ON s.StaffID = th.StaffID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN Painting p ON td.PaintingID = p.PaintingID,
(
	SELECT 
	[Avg] = AVG(Qty)
	FROM TransactionDetail
) AS  x
WHERE PaintingOriginality LIKE 'International'
AND Qty < x.Avg