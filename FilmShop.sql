USE FilmShop
GO
--1.	Create a view named ‘ViewStaffData’ to display StaffName, StaffGender, and StaffPhone for every staff whose name contains more than 2 words.
--(create view, like)
--StaffName, StaffGender, StaffPhone
--Staff
CREATE VIEW ViewStaffData
AS
SELECT s.StaffName,
		s.StaffGender,
		s.StaffPhone
FROM Staff s
WHERE s.StaffName LIKE '% % %'

SELECT *
FROM ViewStaffData

--2.	Display CustomerName, CustomerEmail, and CustomerPhone for every customer who has done a transaction on Wednesday.
--(in, datename, weekday)

SELECT c.CustomerName,
		c.CustomerEmail,
		c.CustomerPhone
FROM Customer c
WHERE c.CustomerID IN
( 
	SELECT c2.CustomerID
	FROM Customer c2
	JOIN TransactionHeader th ON c2.CustomerID = th.CustomerID
	WHERE DATENAME(WEEKDAY, th.TransactionDate) = 'wednesday'
)

--3.Display StaffName, StaffEmail, StaffPhone, and TransactionHandled (obtained from the total number of transaction) 
--for every staff who has handled transactions where the difference between the transaction date and the date of 2021-05-15 is 3 day.
--Then combine it with StaffName, StaffEmail, StaffPhone, and TransactionHandled (obtained from the total number of transaction) for every staff 
--who has handled a transaction with a customer whose CustomerId is ‘CU005’.
--(count, datediff, group by, union, like)

--syarat union -> kolom di query pertama dan kedua harus sama
--keyword UNION -> Combine
--fungsinya gabungin 2/lebih query

--StaffName, StaffEmail, StaffPhone, TransactionID, TransactionDate, CustomerID
--Staff, TransactionID

SELECT
	s.StaffName,
	s.StaffEmail,
	s.StaffPhone,
	[TransactionHandled] = COUNT(th.TransactionID)
FROM Staff s
JOIN TransactionHeader th ON s.StaffID = th.StaffID
WHERE DATEDIFF(Day, th.TransactionDate, '2021-05-15') = 3
GROUP BY s.StaffName, s.StaffEmail,s.StaffPhone
UNION
SELECT
	s.StaffName,
	s.StaffEmail,
	s.StaffPhone,
	[TransactionHandled] = COUNT(th.TransactionID)
FROM Staff s
JOIN TransactionHeader th ON s.StaffID = th.StaffID
WHERE th.CustomerID LIKE 'CU005'
GROUP BY s.StaffName, s.StaffEmail,s.StaffPhone

--4.	Display TransactionDate (obtained from TransactionDate in ‘MM dd, yyyy’ format), 
--and TotalTransaction (obtained from the total number of transactions) for every transaction
--which film title equals to ‘The Dark Knight’ or ‘Toy Story’ and the transaction was done between 12th and 13th.
--(convert, count, join, datepart, day, between, group by)

SELECT [TransactionDate] = CONVERT(varchar, th.TransactionDate, 107),
		[TotalTransaction] = COUNT(th.TransactionID)
FROM TransactionHeader th
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN Film f ON td.FilmID = f.FilmID
WHERE f.FilmTitle IN ('The Dark Knight', 'Toy Story')
AND DATEPART(DAY, th.TransactionDate) BETWEEN 12 AND 13
GROUP BY CONVERT(VARCHAR, th.TransactionDate, 107)

--5
SELECT 
	th.TransactionID,
	[ID] = RIGHT(s.StaffID,3),
	th.TransactionDate,
	[FilmPrice] = 'Rp. ' + CAST(f.FilmPrice as VARCHAR)
FROM Staff s
JOIN TransactionHeader th ON s.StaffID = th.StaffID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN Film f ON td.FilmID = f.FilmID, (
	SELECT 
		[Average] = AVG(f2.FilmPrice)
		FROM Film f2
) AsAveragePrice
WHERE f.FilmPrice > AsAveragePrice.Average
AND DAY(th.TransactionDate) BETWEEN 12 AND 14