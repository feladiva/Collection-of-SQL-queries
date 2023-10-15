USE Snopy

--1.
CREATE VIEW DisplayStaffData
AS
SELECT
	StaffName,
	StaffGender,
	StaffAddress,
	StaffSalary,
	StaffPhoneNumber
FROM MsStaff
WHERE StaffSalary BETWEEN 7000000 AND 10000000

SELECT * FROM DisplayStaffData

--2.
SELECT
	StaffName,
	StaffEmail,
	StaffSalary,
	StaffPhoneNumber
FROM MsStaff ms
WHERE EXISTS (
	SELECT *
	FROM TrPurchaseHeader th
	WHERE MONTH(PurchaseDate) = '8'
	AND ms.StaffID = th.StaffID
)

--3.
SELECT
	ms.StaffID,
	StaffName,
	StaffAddress,
	[Transaction Count] = COUNT(PurchaseID)
FROM MsStaff ms JOIN TrPurchaseHeader th ON ms.StaffID = th.StaffID
WHERE StaffName LIKE '% % %'
GROUP BY ms.StaffID, StaffName, StaffAddress
UNION
SELECT
	ms.StaffID,
	StaffName,
	StaffAddress,
	[Transaction Count] = COUNT(PurchaseID)
FROM MsStaff ms JOIN TrPurchaseHeader th ON ms.StaffID = th.StaffID
WHERE DATEPART(QUARTER, StaffDOB) = '3'
GROUP BY ms.StaffID, StaffName, StaffAddress

--4.
SELECT 
	th.PurchaseID,
	PurchaseDate,
	BranchName,
	[Total Quantity] = SUM(Quantity)
FROM TrPurchaseHeader th JOIN TrPurchaseDetail td ON th.PurchaseID = td.PurchaseID
JOIN MsBranch mb ON th.BranchID = mb.BranchID
WHERE RIGHT(th.PurchaseID, 3) % 2 = 1
AND DATEDIFF(MONTH, th.PurchaseDate, '2021-08-01') > 15
GROUP BY th.PurchaseID, PurchaseDate, BranchName

--5.
SELECT
	ms.StaffID,
	StaffName,
	th.PurchaseID,
	PurchaseDate,
	ProductName,
	ProductPrice
FROM MsStaff ms JOIN TrPurchaseHeader th ON ms.StaffID = th.StaffID
JOIN TrPurchaseDetail td ON th.PurchaseID = td.PurchaseID
JOIN MsProduct mp ON td.ProductID = mp.ProductID,
(
	SELECT 
	[Avg] = AVG(ms2.StaffSalary)
	FROM MsStaff ms2
) x
WHERE DATENAME(WEEKDAY, PurchaseDate) = 'Wednesday' AND StaffSalary > x.Avg

SELECT * FROM MsStaff
SELECT
	LEFT(StaffName, CHARINDEX(' ', StaffName)-1)
FROM MsStaff