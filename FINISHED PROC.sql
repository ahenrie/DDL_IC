-- Create a program to fill in the dimDate table
ALTER PROC fillDates
    (@StartDate DATE, @EndDate DATE)
AS
BEGIN
--    DECLARE @StartDate DATE; --Creating a date value for the insert
--    SET @StartDate = '4/3/2022'; --Setting the starting date value
    WHILE @StartDate <= @EndDate     --Looping through dates to insert
    BEGIN
        INSERT INTO dimDate
        VALUES (@StartDate, DATENAME(WEEKDAY, @StartDate), DATENAME(MONTH, @StartDate), DATEPART(QUARTER, @StartDate), YEAR(@StartDate),     getDate());    
        SET @StartDate = DATEADD(DAY, 1, @StartDate);
    END;
END;
GO



--Running the fillDates stored procedure to put dates in our dim table
EXEC fillDates @StartDate = '1/1/2024', @EndDate = '12/31/2024';



SELECT * FROM dimDate;



SELECT DISTINCT SaleDate
FROM BookSales;
GO



--A program to snapshot the Books data with full replacement
ALTER PROC fillBooks
AS
BEGIN
    ALTER TABLE dwSalesFacts
    NOCHECK CONSTRAINT FK__dwSalesFac__ISBN__48CFD27E;
    DELETE FROM dimBooks;
    INSERT INTO dimBooks
    SELECT ISBN, BookTitle, BookPrice, PubDate, NumPages, getDate()
    FROM Books;
    ALTER TABLE dwSalesFacts
    CHECK CONSTRAINT FK__dwSalesFac__ISBN__48CFD27E;
END;
GO



EXEC fillBooks;
SELECT * FROM Books;
SELECT * FROM dimBooks;



INSERT INTO Books
VALUES ('def456', 'The First Thanksgiving', 19.99, '11/1/2022', 1289, 1100);
GO



--A procedure to snapshot seller data with incremental updates.
CREATE PROC fillSellers
AS
BEGIN
    INSERT INTO dimSellers
    SELECT SellerID, SellerName, getDate()
    FROM Sellers
    WHERE SellerID NOT IN (SELECT SellerID FROM dimSellers);
END;
GO



EXEC fillSellers;
SELECT * FROM Sellers;
SELECT * FROM dimSellers;
INSERT INTO Sellers
VALUES ('Bob''s Books');



--A stored proc to populate the dimPublishers table with incremental update
CREATE PROC fillPublishers
AS
BEGIN
    INSERT INTO dimPublishers
    SELECT PubID, PubName, getDate()
    FROM Publishers
    WHERE PubID NOT IN (SELECT PubID FROM dimPublishers);
END;
GO



EXEC fillPublishers;



--Stored procedure to add revenue to aggregation for books with full replacement
ALTER PROC fillRevAgg
AS
BEGIN
    DELETE FROM dimRevenueAgg;
    INSERT INTO dimRevenueAgg
    SELECT B.ISBN, COUNT(SaleID), SUM(BS.BookPrice),
        IIF(COUNT(BS.SaleID) = 0, NULL, SUM(B.BookPrice)),
        getDATE()
    FROM Books B LEFT JOIN BookSales BS
    ON B.ISBN = BS.ISBN
    GROUP BY B.ISBN;
END;
GO



EXEC fillRevAgg;
SELECT * FROM dimRevenueAgg;



--Create proc to populate the books sales fact table with no update
CREATE PROC fillSalesFacts
AS
BEGIN
    INSERT INTO dwSalesFacts
    SELECT s.SaleID, p.PubID, s.SellerID, NULL, s.ISBN, s.BookPrice, getDate()
    FROM BookSales s JOIN Books b
    ON b.ISBN = s.ISBN JOIN Publishers p
    ON p.PubID = b.PubID
END;
GO



EXEC fillSalesFacts;
