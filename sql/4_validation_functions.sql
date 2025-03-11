-- User-Defined Functions for parameter validation ------------------------

GO
CREATE FUNCTION dbo.ValidateTextLength(@text NVARCHAR(255), @minLength INT, @maxLength INT)
RETURNS BIT
AS
BEGIN
    IF LEN(@text) BETWEEN @minLength AND @maxLength
        RETURN 1
    RETURN 0
END;
GO

GO
CREATE FUNCTION dbo.ValidateIntegerRange(@value INT, @minValue INT, @maxValue INT)
RETURNS BIT
AS
BEGIN
    IF @value BETWEEN @minValue AND @maxValue
        RETURN 1
    RETURN 0
END;
GO

GO
CREATE FUNCTION dbo.ValidateEmail(@email NVARCHAR(100))
RETURNS BIT
AS
BEGIN
    IF CHARINDEX('@', @email) > 0
        RETURN 1
    RETURN 0
END;
GO