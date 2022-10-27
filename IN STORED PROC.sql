--Create a program to fill in the dimDate table
CREATE PROC fillDates
AS
BEGIN
	DECLARE @StartDate DATE;
	SET @StartDate = '4/3/2022'
	WHILE @StartDate <= '12/31/2023'
	BEGIN
		INSERT INTO dimDate
		VALUES(@StartDate, 
			DATENAME(WEEKDAY, @StartDate), 
			DATENAME(MONTH, @StartDate), 
			DATEPART(QUARTER, @StartDate), 
			YEAR(@StartDate), 
			getDATE()
			);
		SET @StartDate
	END;
END;
GO



SELECT * FROM dimDate;
