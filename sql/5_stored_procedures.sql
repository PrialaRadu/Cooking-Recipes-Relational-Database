-- Stored Procedures ------------------------------------------------------

-- 1) Procedure for adding an ingredient
GO
CREATE PROCEDURE AddIngredient
    @NAME NVARCHAR(50),
    @KCAL INT,
    @ALLERGENS NVARCHAR(100) = NULL,
    @UNIT_OF_MEASURE NVARCHAR(20)
AS
BEGIN
    IF dbo.ValidateTextLength(@NAME, 1, 50) = 0
    BEGIN
        PRINT 'Error: The ingredient name must be between 1 and 50 characters.';
        RETURN;
    END

    INSERT INTO Ingredient (NAME, KCAL, ALLERGENS, MEASUREMENT_UNIT)
    VALUES (@NAME, @KCAL, @ALLERGENS, @UNIT_OF_MEASURE);

    PRINT 'Ingredient added successfully.';
END;
GO

-- 2) Procedure for adding a recipe
GO 
CREATE PROCEDURE AddRecipe
    @NAME NVARCHAR(50),
    @NUM_INGREDIENTS INT,
    @DURATION INT,
    @CATEGORY_ID INT
AS
BEGIN
    IF dbo.ValidateTextLength(@NAME, 1, 50) = 0
    BEGIN
        PRINT 'Error: The recipe name must have between 1 and 50 characters.';
        RETURN;
    END

    IF dbo.ValidateIntegerRange(@NUM_INGREDIENTS, 1, 50) = 0
    BEGIN
        PRINT 'Error: The number of ingredients must be between 1 and 50.';
        RETURN;
    END

    INSERT INTO Recipe (NAME, INGREDIENT_COUNT, DURATION, CATEGORY_ID)
    VALUES (@NAME, @NUM_INGREDIENTS, @DURATION, @CATEGORY_ID);

    PRINT 'Recipe added successfully.';
END;
GO

-- 3) Procedure for adding a relationship in the linking table (Recipe_Ingredient)
GO
CREATE PROCEDURE AddRecipeIngredient
    @RECIPE_ID INT,
    @INGREDIENT_ID INT,
    @QUANTITY DECIMAL(10, 2)
AS
BEGIN
    IF @QUANTITY <= 0
    BEGIN
        PRINT 'Error: Quantity must be greater than 0.';
        RETURN;
    END

    INSERT INTO Recipe_Ingredient (RECIPE_ID, INGREDIENT_ID, QUANTITY)
    VALUES (@RECIPE_ID, @INGREDIENT_ID, @QUANTITY);

    PRINT 'Ingredient successfully added to the recipe.';
END;
GO