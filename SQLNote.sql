USE Musica
/*
Insert -> INSERT INTO [Nama Tabel] VALUES (data)
Update -> UPDATE [Nama Tabel] SET [kolom] = data
Delete -> DELETE ...
*/
SELECT TransactionID, EmployeeID FROM HeaderTransaction

-- munculin data yang CustName A...
-- STRCMP, STRCMPI
SELECT * FROM HeaderTransaction WHERE CustomerName LIKE 'A%'
-- % menandakan bisa apapun dan berapa karakterpun (wildcard) 
-- versi lebih detail dari si wildcard _ 

SELECT * FROM HeaderTransaction WHERE TransactionID LIKE 'TR00[0-9]'

-- AND -> lebih dari 1 syarat
SELECT * FROM HeaderTransaction WHERE TransactionID = 'TR006' AND EmployeeID = 'EM001'
-- AND -> wajib semua terpenuhi
-- OR -> salah satu ok semua ok
SELECT * FROM HeaderTransaction WHERE TransactionID = 'TR006' OR EmployeeID = 'EM001'

-- TOP itu buat ngambil n data dari atas
SELECT TOP 1 * FROM HeaderTransaction WHERE TransactionID = 'TR006' OR EmployeeID = 'EM001'

-- ORDER itu buat sort data
SELECT TOP 2 * FROM HeaderTransaction WHERE TransactionID = 'TR006' OR EmployeeID = 'EM001' ORDER BY CustomerName DESC -- default akan ASC

-- DISTINCT itu buat ambil data non duplikat
SELECT DISTINCT EmployeeID FROM HeaderTransaction ORDER BY EmployeeID



-- JOIN KW
SELECT * FROM MsMusicIns a, MsMusicInsType b WHERE a.MusicInsTypeID = b.MusicInsTypeID -- tidak best practice

-- JOIN yang Beneran
SELECT * FROM MsMusicIns a JOIN MsMusicInsType b ON a.MusicInsTypeID = b.MusicInsTypeID

-- INNER JOIN 
SELECT * FROM MsMusicIns a INNER JOIN MsMusicInsType b ON a.MusicInsTypeID = b.MusicInsTypeID

-- LEFT JOIN
SELECT * FROM MsMusicIns a LEFT JOIN MsMusicInsType b ON a.MusicInsTypeID = b.MusicInsTypeID

-- RIGHT JOIN
SELECT * FROM MsMusicIns a RIGHT JOIN MsMusicInsType b ON a.MusicInsTypeID = b.MusicInsTypeID


-- BETWEEN
SELECT * FROM MsMusicIns WHERE Stock BETWEEN 15 AND 30

-- LEN
/*
1. [NamaKolom] = Data
2. Data AS [NamaKolom]
*/
SELECT EmployeeName, LEN(EmployeeName) AS [NameLen] FROM MsEmployee

-- SUBSTRING
SELECT SUBSTRING(EmployeeName, 1, 3) AS [ThreeFirstChar] FROM MsEmployee

-- CHARINDEX = dapetin index dari character tertentu
SELECT CHARINDEX(' ', EmployeeName) FROM MsEmployee WHERE EmployeeName LIKE '% %'
SELECT SUBSTRING(EmployeeName, 1, CHARINDEX(' ', EmployeeName)) FROM MsEmployee WHERE EmployeeName LIKE '% %'

-- REPLACE
SELECT REPLACE(EmployeeID, 'EM', 'Employee ') AS [EMPNO] FROM MsEmployee

-- UPPER LOWER
SELECT UPPER(EmployeeName) AS [EmpName] FROM MsEmployee
SELECT LOWER(EmployeeName) AS [EmpName] FROM MsEmployee

-- RIGHT LEFT -> mengambil char dari r/l sebanyak n
SELECT LEFT(EmployeeID, 2) FROM MsEmployee
SELECT RIGHT(EmployeeID, 3) FROM MsEmployee

-- CAST CONVERT
SELECT RIGHT(CAST(GETDATE() AS VARCHAR), 6)
SELECT CONVERT(VARCHAR, GETDATE(), 103)

-- DATENAME itu buat dapetin nama hari/bulan
SELECT DATENAME(WEEKDAY, GETDATE())
SELECT YEAR(GETDATE())

-- DATEADD itu buat namabahin n hari/bulan/tahun/waktu ke tanggal tertentu
SELECT YEAR(DATEADD(YEAR, 2, GETDATE()))

-- COALESCE null value prevention
SELECT COALESCE(NULL, 123) AS[sebuahkolom]

-- CASE WHEN IF ELSE
SELECT 
	CASE WHEN Gender = 'M' THEN 'Laki-Laki'
		WHEN Gender = 'F' THEN 'Perempuan'
		ELSE 'Others'
	END
	AS [JK]
FROM MsEmployee
/*
IF(_condition_)
BEGIN
	*Todo task
END
ELSE IF(_condition_)
BEGIN
	*Todo task
END
ELSE
BEGIN
	*Todo task
END
*/

-- ARITHMETIC + - == = % / *
SELECT 1*10

-- GROUPING, HAVING, COUNT, SUM, MIN, MAX, AVG
SELECT MusicInsID, COUNT(*) AS [Jumlah Transaksi]
FROM DetailTransaction
GROUP BY MusicInsID
-- AGG FUNC tidak bisa pake where
HAVING COUNT(*) >2

SELECT MusicInsID, SUM(Qty) AS [QTY trx]
FROM DetailTransaction
GROUP BY MusicInsID


-- VIEW
CREATE VIEW UserLevelEmployeeView 
AS 
SELECT EmployeeName, Gender 
FROM MsEmployee

SELECT * FROM UserLevelEmployeeView

-- CALLING A SP
EXEC SelectEmployeeAndBranch 'a'


SELECT *
FROM Customer
WHERE CustomerAge IN(10, 20)


CREATE TABLE Customer (
	CustomerAge INT


	CONSTRAINT CustomerAge CHECK (CustomerAge IN(10, 20))

)


---SOAL
--1
SELECT TOP 2 EmployeeID, EmployeeName, Gender 
FROM MsEmployee
WHERE Gender = 'F'

--2
SELECT *
FROM MsEmployee
WHERE CAST(RIGHT(Phone,1) AS INT) % 5 = 0 AND Salary >  4000000

--3
GO
CREATE VIEW getMusic
AS
SELECT *
FROM MsMusicIns
WHERE (Price BETWEEN 5000000 AND 10000000) AND MusicIns LIKE 'Yamaha%' 

--4
SELECT 'Branch Employee' =  REPLACE(EmployeeName, SUBSTRING(EmployeeName, 1, CHARINDEX(' ', EmployeeName)), BranchID + ' ') 
FROM MsEmployee
WHERE EmployeeName LIKE '% %% %'

--5
SELECT 'Brand' = SUBSTRING(MusicIns, 1, CHARINDEX(' ', MusicIns)),
		'Price' = 'Rp. ' + CAST(Price AS VARCHAR),
		Stock,
		'Instrument Type' = MusicInsType
FROM MsMusicIns mm
JOIN MsMusicInsType mt
ON mm.MusicInsTypeID = mt.MusicInsTypeID



--6
SELECT EmployeeName, 'Employee Gender' = Gender, 
	   'Tanggal' = CONVERT(VARCHAR, TransactionDate, 106),
	   CustomerName
FROM MsEmployee me
JOIN HeaderTransaction ht ON me.EmployeeID = ht.EmployeeID
WHERE Gender LIKE '%M%' AND EmployeeName LIKE '% %'

--7
SELECT me.EmployeeID,
	   EmployeeName,
	   'DateOfBirth' = CONVERT(VARCHAR, DateofBirth, 106),
	   CustomerName,
	   TransactionDate = CONVERT(VARCHAR, TransactionDate, 106)
FROM MsEmployee me
JOIN HeaderTransaction ht ON me.EmployeeID = ht.EmployeeID
WHERE DATENAME(MONTH, DateofBirth) = 'December' AND DATENAME(Day, TransactionDate) = 16

--8
SELECT BranchName,	
		EmployeeName
FROM MsBranch mb
JOIN MsEmployee me ON mb.BranchID = me.BranchID
WHERE EXISTS(
	SELECT * 
	FROM HeaderTransaction ht 
	WHERE me.EmployeeID = ht.EmployeeID AND DATENAME(Month, TransactionDate) = 'October' 
	AND TransactionID IN (
		SELECT TransactionID FROM DetailTransaction  WHERE Qty >= 5
		)
)


--9
GO
ALTER PROCEDURE Search(@search VARCHAR(255))
AS
BEGIN
	SELECT EmployeeName, Address, Phone, Gender
	FROM MsEmployee
	WHERE EmployeeName LIKE '%' + @search + '%' 
	OR Address LIKE '%' + @search + '%' 
	OR Phone LIKE '%' + @search + '%'
	OR Gender LIKE '%' + @search + '%'
END

EXEC Search 'lim'

EXEC Search '19'

EXEC Search 'F'


--10
GO
CREATE PROCEDURE Check_Transaction 
(
	@id VARCHAR(10)
)
AS
BEGIN
	SELECT CustomerName, EmployeeName, BranchName, MusicIns, Price 
	FROM MsEmployee me
	JOIN HeaderTransaction ht ON me.EmployeeID = ht.EmployeeID
	JOIN MsBranch mb ON me.BranchID = mb.BranchID
	JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
	JOIN MsMusicIns ms ON dt.MusicInsID = ms.MusicInsID
	WHERE ht.TransactionID = 'Tr003'
END




EXEC Check_Transaction'Tr003'
EXEC Check_Transaction'Tr004'
EXEC Check_Transaction'Tr001'
EXEC Check_Transaction'Tr002'

SELECT CustomerName, EmployeeName, BranchName, MusicIns, Price 
FROM MsEmployee me
JOIN HeaderTransaction ht ON me.EmployeeID = ht.EmployeeID
JOIN MsBranch mb ON me.BranchID = mb.BranchID
JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
JOIN MsMusicIns ms ON dt.MusicInsID = ms.MusicInsID
WHERE ht.TransactionID = 'Tr003'







---DATE CONVERT
SELECT 'Tanggal' = CONVERT(VARCHAR, TransactionDate, 106)
FROM HeaderTransaction

--101 mm/dd/yyyy
--103 dd/mm/yyyy
--105 dd-mm-yyyy
--106 dd mon yyyy
--111 yyyy/mm/dd