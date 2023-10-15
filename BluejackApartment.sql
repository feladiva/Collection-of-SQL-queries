USE BluejackApartment

--1. 

CREATE VIEW MidApartmentList
AS
SELECT
	ApartmentUnitID,
	ApartmentFloor,
	ApartmentPrice
FROM ApartmentUnit
WHERE ApartmentPrice BETWEEN 500000000 AND 1000000000

SELECT * FROM MidApartmentList

--2.
SELECT
	ResidentName,
	ResidentGender,
	ResidentDOB
FROM Resident r
WHERE r.ResidentID IN
(
	SELECT s.ResidentID
	FROM SalesHeader s
	WHERE ApartmentStaffID LIKE 'ST002'
)

--3.
SELECT
	[Name] = ResidentName ,
	[DOB] = ResidentDOB,
	[Transaction Count] = COUNT(SalesID)
FROM Resident r JOIN SalesHeader s ON r.ResidentID = s.ResidentID
WHERE LEN(ResidentName) > 4
GROUP BY ResidentName, ResidentDOB
UNION
SELECT
	[Name] = ApartmentStaffName,
	[DOB] = ApartmentStaffDOB,
	[Transaction Count] = COUNT(SalesID)
FROM ApartmentStaff ast JOIN SalesHeader sh ON ast.ApartmentStaffID = sh.ApartmentStaffID
WHERE DATENAME(YEAR, ApartmentStaffDOB) < 1997
GROUP BY ApartmentStaffName, ApartmentStaffDOB

--4. 
SELECT
	ResidentName,
	ResidentGender,
	ApartmentStaffName,
	[Transaction Count] = COUNT(SalesID)
FROM Resident r JOIN SalesHeader sh ON r.ResidentID = sh.ResidentID
JOIN ApartmentStaff ast ON sh.ApartmentStaffID = ast.ApartmentStaffID
WHERE DATENAME(WEEKDAY, ApartmentStaffDOB) = 'Thursday'
AND ApartmentStaffGender LIKE 'female'
GROUP BY ResidentName, ResidentGender, ApartmentStaffName

--5.
SELECT
	ResidentName,
	[Gender] = LEFT(ResidentGender, 1),
	sh.SalesID,
	au.ApartmentUnitID
FROM Resident r JOIN SalesHeader sh ON r.ResidentID = sh.ResidentID
JOIN SalesDetail sd ON sh.SalesID = sd.SalesID
JOIN ApartmentUnit au ON sd.ApartmentUnitID = au.ApartmentUnitID,
(
	SELECT
	[Avg] = AVG(ApartmentPrice)
	FROM ApartmentUnit
) x
WHERE ApartmentPrice > x.[Avg] AND CONVERT(INT, SUBSTRING(sh.SalesID,3,3)) % 2 = 1
