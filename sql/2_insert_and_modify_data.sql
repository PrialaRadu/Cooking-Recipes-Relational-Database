
-- Insert categories
INSERT INTO Category (NAME, CUISINE_STYLE, DIFFICULTY) VALUES
('Salads', 'Vegetarian', 2),
('Soups', 'Classic', 3),
('Pasta', 'Italian', 2),
('Desserts', 'Sweet', 3),
('Pizza', 'Italian', 2),
('Grill', 'American', 3),
('Vegetarian', 'International', 2),
('Smoothie', 'Healthy', 1),
('Asian Food', 'Asian', 4);
GO

-- Insert ingredients
INSERT INTO Ingredient (NAME, KCAL, ALLERGENS, MEASUREMENT_UNIT) VALUES
('tomatoes', 20, NULL, 'pcs'), 
('cucumbers', 15, NULL, 'pcs'), 
('beef', 250, 'Gluten', 'g'), 
('salt', 0, NULL, 'tsp'), 
('sugar', 387, NULL, 'tsp'), 
('flour', 350, 'Gluten', 'g'),
('chicken', 165, NULL, 'g'),
('bell pepper', 30, NULL, 'pcs'),
('milk', 42, 'Lactose', 'ml'),
('eggs', 155, 'Lactose', 'pcs'),
('tuna', 132, NULL, 'g'),
('honey', 304, NULL, 'tbsp'),
('Greek yogurt', 59, 'Lactose', 'g'),
('dark chocolate', 546, NULL, 'g');
GO

-- Insert recipes
INSERT INTO Recipe (NAME, INGREDIENT_COUNT, DURATION, CATEGORY_ID) VALUES
('Tomato and cucumber salad', 2, 15, 1),
('Beef tripe soup', 5, 90, 2),
('Pasta carbonara', 4, 30, 3),
('Grilled chicken with vegetables', 3, 25, 6),
('Banana and honey smoothie', 3, 5, 8),
('Tuna salad with Greek yogurt', 4, 10, 7),
('Asian-style chicken and rice', 5, 40, 9);
GO

-- Insert users
INSERT INTO UserAccount (NAME, EMAIL)
VALUES 
    ('Ion Popescu', 'ion.popescu@example.com'),
    ('Maria Ionescu', 'maria.ionescu@example.com'),
    ('Andrei Vasile', 'andrei.vasile@example.com'),
    ('Elena Georgescu', 'elena.georgescu@example.com'),
    ('Victor Marin', 'victor.marin@example.com'),
    ('Alex Dobre', 'alex.dobre@example.com'),
    ('Diana Ilie', 'diana.ilie@example.com');
GO

-- Insert reviews
INSERT INTO Review (RECIPE_ID, USER_ID, RATING, COMMENT)
VALUES
    (1, 1, 8, 'Good recipe, but a little spicy.'),
    (2, 2, 9, 'Best soup ever!'),
    (3, 1, 7, 'The pasta was slightly overcooked.'),
    (4, 4, 9, 'The chicken was very juicy!'),
    (5, 2, 10, 'The smoothie was delicious and healthy.'),
    (6, 3, 8, 'Tasty and fresh salad.'),
    (7, 1, 7, 'Great Asian dish, but a bit too spicy.');
GO

-- Insert recipe-ingredient relationships (with quantities)
INSERT INTO Recipe_Ingredient (RECIPE_ID, INGREDIENT_ID, QUANTITY) VALUES
(1, 1, 2), 
(1, 2, 1), 
(2, 3, 200), 
(2, 4, 1), 
(3, 3, 100), 
(3, 5, 2), 
(4, 7, 200), 
(4, 8, 1), 
(5, 6, 2), 
(5, 9, 150), 
(6, 10, 100), 
(6, 11, 50), 
(7, 7, 150), 
(7, 12, 100);
GO

-- Update: change the unit of measurement for salt
UPDATE Ingredient
SET MEASUREMENT_UNIT = 'gram'
WHERE NAME = 'salt';
GO

-- Delete: remove all ingredients that have no specified allergens
DELETE FROM Ingredient
WHERE ALLERGENS IS NULL;
GO

-- Update: increase the quantity of beef and flour by 10% in all recipes
UPDATE Recipe_Ingredient
SET QUANTITY = QUANTITY * 1.1
WHERE INGREDIENT_ID IN (SELECT INGREDIENT_ID FROM Ingredient WHERE NAME IN ('beef', 'flour'));
GO

-- Delete: remove reviews that are too short or too long
DELETE FROM Review
WHERE LEN(COMMENT) < 8 OR LEN(COMMENT) > 100;
GO

-- View data
SELECT * FROM UserAccount;
SELECT * FROM Review;
GO
