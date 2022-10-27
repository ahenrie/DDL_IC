--DDL for Data Warehouse

CREATE TABLE dimBooks (
	ISBN CHAR(14) PRIMARY KEY,
	BookTitle VARCHAR(100),
	BookPrice MONEY,
	PubDate DATE,
	NumPages INT,
	RecTimestamp DATETIME
)
;
GO

CREATE TABLE dimDate (
	DateID INT IDENTITY(1,1) PRIMARY KEY,
	CalDate DATE,
	DayOfTheWeek VARCHAR(9),
	MonthOfTheYear VARCHAR(9),
	QuarterOfTheYear INT,
	SaleYear INT,
	RecTimestamp DATETIME 
)
;
GO

CREATE TABLE dimRevenueAgg (
	ISBN CHAR(14) PRIMARY KEY,
	CopiesSold INT,
	TotalSalePrice MONEY,
	TotalWhslePrice MONEY,
	RecTimestamp DATETIME
)
;
GO

CREATE TABLE dimPublishers (
	PubID INT PRIMARY KEY,
	PubName VARCHAR(20),
	RecTimestamp DATETIME
)
;
GO

CREATE TABLE dimSellers (
	SellerID INT PRIMARY KEY,
	SellerName VARCHAR(25),
	RecTimestamp DATETIME
)
;
GO

--Book Sales Fact Table
CREATE TABLE dwSalesFacts (
	SaleID INT PRIMARY KEY,
	PubID INT REFERENCES dimPublishers(PubID),
	SellerID INT REFERENCES dimSellers(SellerID),
	DateID INT REFERENCES dimDate(DateID),
	ISBN CHAR(14),
	SalePrice MONEY,
	RecTimestamp DATETIME,
	FOREIGN KEY (ISBN) REFERENCES dimBooks(ISBN),
	FOREIGN KEY (ISBN) REFERENCES dimRevenueAgg(ISBN)
)
;
GO
