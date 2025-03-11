-- Triggers for Ingredient table ------------------------------------------

-- 1) Trigger for INSERT
GO
CREATE TRIGGER trg_Ingredient_Insert
ON Ingredient
AFTER INSERT
AS
BEGIN
    DECLARE @currentTime DATETIME = GETDATE();
    PRINT CONCAT('Operation: INSERT; Table: Ingredient; Date and time: ', @currentTime);
END;
GO

-- 2) Trigger for DELETE
GO
CREATE TRIGGER trg_Ingredient_Delete
ON Ingredient
AFTER DELETE
AS
BEGIN
    DECLARE @currentTime DATETIME = GETDATE();
    PRINT CONCAT('Operation: DELETE; Table: Ingredient; Date and time: ', @currentTime);
END;
GO
