

USE TanGuitar

--1. 
SELECT 
	CustomerID,
	CustomerName

FROM Customer

--2.	Display StaffId, StaffName, Staff Age (obtained from date difference of Staff DOB and '2020/11/13') 
--for every staff whose age is less than 38 and served any transaction in 2020. 
--(in, year, datediff)

SELECT 
	s.StaffID,
	s.StaffName,
	[Staff Age] = DATEDIFF(Year, s.StaffDOB, '2020-11-13')
FROM Staff s
WHERE DATEDIFF(Year, s.StaffDOB, '2020-11-13') < 38
AND s.StaffID IN(
	SELECT
	s2.StaffID
	FROM Staff s2
	JOIN HeaderTransaction ht ON s2.StaffID = ht.StaffID
	WHERE YEAR(ht.TransactionDate) = '2020'
)

--3
SELECT 
	s.StaffID,
	s.StaffName, 
	[Services] = COUNT(ht.TransactionID),
	[Service Month] = DATENAME(MONTH, ht.TransactionDate) 
FROM Staff s
JOIN HeaderTransaction ht ON s.StaffID = ht.StaffID
WHERE MONTH(ht.TransactionDate) < 6
GROUP BY s.StaffID, s.StaffName,  DATENAME(MONTH, ht.TransactionDate) 
UNION
SELECT 
	s.StaffID,
	s.StaffName, 
	[Services] = COUNT(ht.TransactionID),
	[Service Month] = DATENAME(MONTH, ht.TransactionDate) 
FROM Staff s
JOIN HeaderTransaction ht ON s.StaffID = ht.StaffID
WHERE MONTH(ht.TransactionDate) > 9
GROUP BY s.StaffID, s.StaffName,  DATENAME(MONTH, ht.TransactionDate) 


--4.Display GuitarName, Total Bought (obtained from total quantity of guitar bought in that month), 
--Transaction Month (obtained from the name of the month) for every transaction that occurred where 
--the length of the month name is greater than 3 and month name is not July. 
--(sum, datename, len)

SELECT 
	g.GuitarName,
	[Total Bought] = SUM(dt.Qty),
	[Transaction Month] = DATENAME(MONTH, ht.TransactionDate)
FROM Guitar g
JOIN DetailTransaction dt ON g.GuitarID = dt.GuitarID
JOIN HeaderTransaction ht ON dt.TransactionID = ht.TransactionID
WHERE LEN(DATENAME(MONTH, ht.TransactionDate)) > 3
AND DATENAME(MONTH, ht.TransactionDate) != 'July'
GROUP BY g.GuitarName, DATENAME(MONTH, ht.TransactionDate)

--5.
SELECT
	ht.TransactionID,
	[CustomerName] = LEFT(c.CustomerName, CHARINDEX(' ', c.CustomerName)),
	[TransactionTime] = CONCAT(DATEDIFF(WEEKDAY, ht.TransactionDate, '2020/11/13'), ' days ', 'ago')
FROM Customer c
JOIN HeaderTransaction ht ON c.CustomerID = ht.CustomerID
JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
JOIN Guitar g ON dt.GuitarID = g.GuitarID,
( SELECT [Average] = AVG(g2.GuitarPrice)
	FROM Guitar g2) AsAvgGuitarPrice
	WHERE g.GuitarPrice > AsAvgGuitarPrice.Average

	SELECT TransactionDate
	FROM HeaderTransaction



	------------------------------------------------------
--1.

SELECT
	CustomerID,
	CustomerName,
	CustomerGender
FROM Customer
WHERE LEN(CustomerName) < 14

--2.
SELECT
	StaffID,
	StaffName,
	[Staff Age] = DATEDIFF(YEAR, StaffDOB, '2020-11-13')
FROM Staff s
WHERE s.StaffID IN (
	SELECT
	ht.StaffID
	FROM HeaderTransaction ht
	WHERE YEAR(TransactionDate) = '2020'
) AND DATEDIFF(YEAR, StaffDOB, '2020-11-13') < 38

--3.
SELECT
	s.StaffID,
	s.StaffName,
	[Services] = COUNT(ht.TransactionID),
	[Service Month] = DATENAME(MONTH, ht.TransactionDate)
FROM Staff s JOIN HeaderTransaction ht ON s.StaffID = ht.StaffID
WHERE MONTH(TransactionDate) < 6
GROUP BY s.StaffID, S.StaffName, DATENAME(MONTH, ht.TransactionDate)
UNION
SELECT
	s.StaffID,
	s.StaffName,
	[Services] = COUNT(ht.TransactionID),
	[Service Month] = DATENAME(MONTH, ht.TransactionDate)
FROM Staff s JOIN HeaderTransaction ht ON s.StaffID = ht.StaffID
WHERE MONTH(TransactionDate) > 9
GROUP BY s.StaffID, S.StaffName, DATENAME(MONTH, ht.TransactionDate)


--4.
SELECT
FROM He