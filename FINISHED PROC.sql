--Create a program to fill in the dimDate table
ALTER PROC fillDates
	(@StartDate DATE, @EndDate DATE)
AS
BEGIN
--	DECLARE @StartDate DATE;
--	SET @StartDate = '4/3/2022'
	WHILE @StartDate <= @EndDate
	BEGIN
		INSERT INTO dimDate
		VALUES(@StartDate, 
			DATENAME(WEEKDAY, @StartDate), 
			DATENAME(MONTH, @StartDate), 
			DATEPART(QUARTER, @StartDate), 
			YEAR(@StartDate), 
			getDATE()
			);
		SET @StartDate = DATEADD(DAY,1,@StartDate)
	END;
END;
GO

--Execute fillDate stored proc to populate dates
EXEC fillDates @StartDate='1/1/2024', @EndDate='12/31/2024';

SELECT * FROM dimDate;

--Program to snapshot Books data with full replacement
ALTER PROC fillBooks
AS
BEGIN
	DELETE FROM dimBooks;
	INSERT INTO dimBooks
	SELECT ISBN, BookTitle, BookPrice, PubDate, NumPages, GETDATE() 'RecTimestamp'
	FROM Books;
END;
GO

EXEC fillBooks;
SELECT * FROM dimBooks;

INSERT INTO Books VALUES
('DEF246', 'The First Thanksgiving', 19.99, '11/1/2022', 1289, 1100);


--Procedure to snapshot Seller data with incremental updates.
CREATE PROC fillSellers
AS
BEGIN
	INSERT INTO dimSellers
	SELECT SellerID, SellerName, getDATE()
	FROM Sellers
	WHERE SellerID NOT IN (SELECT SellerID FROM dimSellers);

END;
GO

EXEC fillSellers;
SELECT * FROM dimSellers;
SELECT * FROM Sellers;

INSERT INTO Sellers
VALUES ('Bob''s Books');
