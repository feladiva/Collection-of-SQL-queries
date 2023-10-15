USE JeNT
GO
--1.
CREATE VIEW ViewDeliveryTypeInformation
AS
SELECT
	DeliveryTypeId,
	DeliveryTypeName,
	DeliveryTypePrice
FROM MsDeliveryType
WHERE DeliveryTypePrice BETWEEN 50000 AND 65000
GO
--2.
SELECT
	ms.StaffId,
	ms.StaffName,
	ms.StaffAddress,
	ms.StaffSalary
FROM MsStaff ms
WHERE ms.StaffId 
IN (
	SELECT th.StaffId
	FROM TransactionHeader th
	WHERE MONTH(TransactionDate) = 8
)

--3.
SELECT
	mc.CustomerId,
	CustomerName,
	CustomerDOB,
	[Number of Transaction] = COUNT(TransactionId)
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerId = th.CustomerId
WHERE DATEDIFF(WEEKDAY, TransactionDate, '2021-08-17') <= 7
GROUP BY mc.CustomerId, CustomerName,CustomerDOB
UNION
SELECT
	mc.CustomerId,
	CustomerName,
	CustomerDOB,
	[Number of Transaction] = COUNT(TransactionId)
FROM MsCustomer mc JOIN TransactionHeader th ON mc.CustomerId = th.CustomerId
WHERE LEN(CustomerName) > 6
GROUP BY mc.CustomerId, CustomerName,CustomerDOB

--4.
SELECT 
	td.TransactionId,
	[Total Amount] = SUM(DeliveryTypePrice),
	TransactionDate
FROM TransactionDetail td JOIN MsDeliveryType mdt ON td.DeliveryTypeId = mdt.DeliveryTypeId
JOIN TransactionHeader th ON td.TransactionId = th.TransactionId
WHERE DeliveryTypeName LIKE '% %'
AND DATEDIFF(DAY, '2021-08-01', TransactionDate) <= 1
GROUP BY td.TransactionId, TransactionDate


--5.
SELECT
	th.TransactionId,
	CONVERT(VARCHAR, TransactionDate, 107),
	[Package Origin] = SUBSTRING(UPPER(CityName), 1, 3)
FROM TransactionHeader th JOIN MsCity mci ON th.CityOriginId = mci.CityId
JOIN TransactionDetail td ON th.TransactionId = td.TransactionId 
JOIN MsDeliveryType mdt ON td.DeliveryTypeId = mdt.DeliveryTypeId,
(
	SELECT 
		[Avg] = AVG(DeliveryTypePrice)
	FROM MsDeliveryType
	) x
WHERE CityName LIKE '%Java%'
AND DeliveryTypePrice <= x.Avg

