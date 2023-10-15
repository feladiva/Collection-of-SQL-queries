USE MouseAN_Shop
GO
--1.Create view named ViewCustomer for displaying Customer data 
--for every customer whose name contains 2 words.
--(create view, like)

CREATE VIEW ViewCustomer
AS
SELECT *
FROM MsCustomer
WHERE CustomerName LIKE '% %'
GO

SELECT *
FROM ViewCustomer


--2.Display CustomerID, CustomerName for every Customer 
--that has transaction on June. 
--(exists, datename, month) -> subquery

--query luar -> view
--query dalam -> condition

SELECT	
	CustomerID,
	CustomerName
FROM MsCustomer
WHERE EXISTS (
	SELECT *
	FROM HeaderTransaction
	WHERE DATENAME(MONTH, TransactionDate) = 'June' AND
	MsCustomer.CustomerID = HeaderTransaction.CustomerID
)

SELECT	
	CustomerID,
	CustomerName
FROM MsCustomer mc
WHERE mc.CustomerID IN (--dari mscust
	SELECT ht.CustomerID --dari header
	FROM HeaderTransaction ht
	WHERE DATENAME(MONTH, TransactionDate) = 'June'
)


--3.Display CashierID, CashierName and CashierGender for every Cashier
--who has been handle transaction in the last 5 months from 2019-04-15 
--and then combine with CashierID, CashierName and CashierGender for every 
--Cashier who has been handle transaction more than 2 times.
--(datediff, month, having, union, count)

SELECT
	mca.CashierID,
	mca.CashierName,
	mca.CashierGender
FROM MsCashier mca JOIN HeaderTransaction ht ON 
mca.CashierID = ht.CashierID
WHERE DATEDIFF(MONTH, TransactionDate, '2019-04-15') <= 5
UNION
SELECT
	mca.CashierID,
	mca.CashierName,
	mca.CashierGender
FROM MsCashier mca JOIN HeaderTransaction ht ON 
mca.CashierID = ht.CashierID
GROUP BY mca.CashierID, mca.CashierName, mca.CashierGender
HAVING COUNT(ht.TransactionID) > 2


--4.Display MouseName, MousePrice (obtained from MousePrice and started with ‘Rp.’) 
--and Total Sold (obtained from total sum of quantity) for every Mouse that stock less 
--than or equals 15 and sold on 2018-10-15 then sort by Total Sold in descending order.
--(convert, sum, join, group by, order by)

SELECT 
	MouseName,
	[Mouse Price] = 'Rp. ' + CONVERT(VARCHAR, MousePrice),
	[Total Sold] = SUM(quantity)
FROM HeaderTransaction ht JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
JOIN MsMouse mm ON dt.MouseID = mm.MouseID
WHERE MouseStock <= 15 AND TransactionDate ='2018-10-15'
GROUP BY MouseName, MousePrice
ORDER BY [Total Sold] DESC

--5.Display CustomerID and LastName (obtained from the last name of CustomerName) for 
--every Customer that bought K20-Basic Mouse with only 1 transaction.
--(alias subquery, right, charindex, count, reverse, group by)

SELECT 
	mc.CustomerID,
	[Last Name] = RIGHT(CustomerName, CHARINDEX(' ', REVERSE(CustomerName)))
FROM MsCustomer mc,
(
	SELECT [TotalTransaction] = COUNT(ht.TransactionID),
	CustomerID
	FROM HeaderTransaction ht JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
	JOIN MsMouse mm ON dt.MouseID = mm.MouseID
	WHERE MouseName = 'K20-Basic'
	GROUP BY CustomerID
) x
WHERE mc.CustomerID = x.CustomerID AND x.TotalTransaction = 1


SELECT 
	mc.CustomerID,
	[Last Name] = RIGHT(CustomerName, CHARINDEX(' ', REVERSE(CustomerName)))
FROM MsCustomer mc, 
--hitung total transaksi
(
	SELECT COUNT(ht.TransactionID) AS 'CountTransaction',
	CustomerID
	FROM HeaderTransaction ht JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
	JOIN MsMouse mm ON dt.MouseID = mm.MouseID
	WHERE MouseName ='K20-Basic'
	GROUP BY CustomerID
) x
WHERE mc.CustomerID = x.CustomerID AND x.CountTransaction =1