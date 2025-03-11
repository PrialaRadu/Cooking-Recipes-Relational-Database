-- View for recipe details -------------------------------------------------
GO
CREATE VIEW RecipeDetails AS
SELECT 
    R.NAME AS RECIPE,
    C.NAME AS CATEGORY,
    I.NAME AS INGREDIENT,
    RI.QUANTITY,
    RV.RATING,
    RV.COMMENT
FROM Recipe R
INNER JOIN Recipe_Ingredient RI ON R.RECIPE_ID = RI.RECIPE_ID
INNER JOIN Ingredient I ON RI.INGREDIENT_ID = I.INGREDIENT_ID
INNER JOIN Category C ON R.CATEGORY_ID = C.CATEGORY_ID
LEFT JOIN Review RV ON R.RECIPE_ID = RV.RECIPE_ID;
GO
