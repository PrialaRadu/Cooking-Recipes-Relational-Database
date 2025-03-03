CREATE DATABASE ReteteCulinare;
GO

USE ReteteCulinare;
GO

-- creare tabel Ingredient
CREATE TABLE Ingredient (
    ID_INGREDIENT INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NUME VARCHAR(50) NOT NULL,
    KCAL INT,
    ALERGENI VARCHAR(100),
    UNITATE_MASURA VARCHAR(20)
);
GO

-- creare tabel Categorie
CREATE TABLE Categorie (
    ID_CATEGORIE INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NUME VARCHAR(50) NOT NULL,
    STIL_CULINAR VARCHAR(50),
    DIFICULTATE INT
);
GO

-- creare tabel Reteta
CREATE TABLE Reteta (
    ID_RETETA INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NUME VARCHAR(50) NOT NULL,
    NR_INGREDIENTE INT NOT NULL,
    DURATA INT NOT NULL,  -- in minute
    ID_CATEGORIE INT NOT NULL,
    CONSTRAINT fk_categorie_reteta FOREIGN KEY(ID_CATEGORIE) REFERENCES Categorie(ID_CATEGORIE)
);
GO

-- creare tabel relatie Reteta-Ingredient (many to many)
CREATE TABLE Reteta_Ingredient (
    ID_RETETA INT NOT NULL,
    ID_INGREDIENT INT NOT NULL,
    CANTITATE DECIMAL(10,2),
    CONSTRAINT fk_reteta_ingredient_reteta FOREIGN KEY(ID_RETETA) REFERENCES Reteta(ID_RETETA),
    CONSTRAINT fk_reteta_ingredient_ingredient FOREIGN KEY(ID_INGREDIENT) REFERENCES Ingredient(ID_INGREDIENT)
        ON DELETE CASCADE
);
GO

-- creare tabel Utilizator
CREATE TABLE Utilizator
(
    ID_UTILIZATOR INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    NUME VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(100) NOT NULL UNIQUE,
    DATA_INREGISTRARE DATETIME DEFAULT GETDATE(),
);

-- creare tabel Review
CREATE TABLE Review
(
    ID_REVIEW INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ID_RETETA INT NOT NULL,
    ID_UTILIZATOR INT NOT NULL,
    RATING FLOAT NOT NULL CHECK(RATING >= 1 AND RATING <= 10),
    COMMENT VARCHAR(255),
    REVIEW_DATE DATETIME DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT fk_review_reteta FOREIGN KEY (ID_RETETA) REFERENCES Reteta(ID_RETETA),
    CONSTRAINT fk_review_utilizator FOREIGN KEY (ID_UTILIZATOR) REFERENCES Utilizator(ID_UTILIZATOR)
);

-- inserare date

-- Inseram categorii
INSERT INTO Categorie (NUME, STIL_CULINAR, DIFICULTATE) VALUES
('Salate', 'Vegetariana', 2),
('Supe', 'Clasica', 3),
('Paste', 'Italiana', 2),
('Deserturi', 'Dulce', 3),
('Pizza', 'Italiana', 2);

-- Inseram ingrediente
INSERT INTO Ingredient (NUME, KCAL, ALERGENI, UNITATE_MASURA) VALUES
('rosii', 20, NULL, 'buc'), 
('castraveti', 15, NULL, 'buc'), 
('carne de vita', 250, 'Gluten', 'g'), 
('sare', 0, NULL, 'lingurita'), 
('zahar', 387, NULL, 'lingurite'), 
('faina', 350, 'Gluten', 'g');

-- Inseram retete
INSERT INTO Reteta (NUME, NR_INGREDIENTE, DURATA, ID_CATEGORIE) VALUES
('Salata de rosii si castraveti', 2, 15, 1),
('Ciorba de burta', 5, 90,2),
('Paste carbonara', 4, 30, 3);


INSERT INTO Utilizator (NUME, EMAIL)
VALUES 
    ('Ion Popescu', 'ion.popescu@example.com'),
    ('Maria Ionescu', 'maria.ionescu@example.com'),
    ('Andrei Vasile', 'andrei.vasile@example.com');

INSERT INTO Review (ID_RETETA, ID_UTILIZATOR, RATING, COMMENT)
VALUES
    (1, 1, 8, 'Reteta buna, dar putin picanta.'),
    (2, 2, 9, 'Cea mai buna ciorba!'),
    (3, 1, 7, 'Pastele au fost putin prea fierte.');

-- Inseram relatia dintre retete si ingrediente (cu cantitati)
INSERT INTO Reteta_Ingredient (ID_RETETA, ID_INGREDIENT, CANTITATE) VALUES
(1, 1, 2), -- Salata de rosii si castraveti - 2 rosii
(1, 2, 1), -- Salata de rosii si castraveti - 1 castravete
(2, 3, 200), -- Ciorba de burta - 200g carne de vita
(2, 4, 1), -- Ciorba de burta - 1 lingurita sare
(3, 3, 100), -- Paste carbonara - 100g carne de vita
(3, 5, 2); -- Paste carbonara - 2 lingurite zahar;

-- modificare: actualizam unitatea de masura pentru sare
UPDATE Ingredient
SET UNITATE_MASURA = 'gram'
WHERE NUME = 'sare';

-- stergere: stergem toate ingredientele care nu au alergeni specificati
DELETE FROM Ingredient
WHERE ALERGENI IS NULL;

-- modificare: crestem cu 10% cantitatea de carne de vita si faina din toate retetele
UPDATE Reteta_Ingredient
SET CANTITATE = CANTITATE * 1.1
WHERE ID_INGREDIENT = (SELECT ID_INGREDIENT FROM Ingredient WHERE NUME = 'carne de vita');

-- stergem review-urile scurte si lungi
DELETE FROM Review
WHERE LEN(COMMENT) < 8 OR LEN(COMMENT) > 100;

-- vizualizam datele
SELECT * FROM Utilizator;
SELECT * FROM Review;


-- 1) Interogare cu UNION ----------------------------------------------------------
-- Retete care contin carne de vita sau zahar
SELECT NUME AS RETETA, DURATA 
FROM Reteta
WHERE ID_RETETA IN (SELECT ID_RETETA FROM Reteta_Ingredient WHERE ID_INGREDIENT = (SELECT ID_INGREDIENT FROM Ingredient WHERE NUME = 'carne de vita'))
UNION
SELECT NUME AS RETETA, DURATA 
FROM Reteta
WHERE ID_RETETA IN (SELECT ID_RETETA FROM Reteta_Ingredient WHERE ID_INGREDIENT = (SELECT ID_INGREDIENT FROM Ingredient WHERE NUME = 'zahar'));

-- 2) Interogari cu JOIN ------------------------------------------------------------
-- a) INNER JOIN
-- Listeaza toate retetele, ingredientele lor si cantitatile folosite
SELECT 
    R.NUME AS RETETA,
    I.NUME AS INGREDIENT,
    RI.CANTITATE,
    C.NUME AS CATEGORIE
FROM Reteta R
INNER JOIN Reteta_Ingredient RI ON R.ID_RETETA = RI.ID_RETETA
INNER JOIN Ingredient I ON RI.ID_INGREDIENT = I.ID_INGREDIENT
INNER JOIN Categorie C ON R.ID_CATEGORIE = C.ID_CATEGORIE;

-- b) LEFT JOIN
-- Afiseaza toate ingredientele, impreuna cu retetele in care sunt folosite (daca sunt folosite)
SELECT DISTINCT 
    I.NUME AS INGREDIENT,
    R.NUME AS RETETA,
    RI.CANTITATE
FROM Ingredient I
LEFT JOIN Reteta_Ingredient RI ON I.ID_INGREDIENT = RI.ID_INGREDIENT
LEFT JOIN Reteta R ON RI.ID_RETETA = R.ID_RETETA;


-- c) FULL JOIN
-- Afiseaza toate retetele si utilizatorii care le-au evaluat (daca exista evaluari)
SELECT 
    R.NUME AS RETETA,
    U.NUME AS UTILIZATOR,
    RV.RATING
FROM Reteta R
FULL JOIN Review RV ON R.ID_RETETA = RV.ID_RETETA
FULL JOIN Utilizator U ON RV.ID_UTILIZATOR = U.ID_UTILIZATOR;

-- 3) Interogari cu GROUP BY ------------------------------------------------------
-- a) Total ingrediente per reteta
SELECT 
    R.NUME AS RETETA,
    COUNT(RI.ID_INGREDIENT) AS NR_INGREDIENTE
FROM Reteta R
INNER JOIN Reteta_Ingredient RI ON R.ID_RETETA = RI.ID_RETETA
GROUP BY R.NUME
ORDER BY NR_INGREDIENTE DESC;

-- b) Calorii totale per reteta
SELECT 
    R.NUME AS RETETA,
    SUM(I.KCAL * RI.CANTITATE / 100) AS TOTAL_KCAL
FROM Reteta R
INNER JOIN Reteta_Ingredient RI ON R.ID_RETETA = RI.ID_RETETA
INNER JOIN Ingredient I ON RI.ID_INGREDIENT = I.ID_INGREDIENT
GROUP BY R.NUME
HAVING SUM(I.KCAL * RI.CANTITATE / 100) > 200
ORDER BY TOTAL_KCAL DESC;

-- c) Numar de evaluari si ratingul mediu per reteta
SELECT 
    R.NUME AS RETETA,
    COUNT(RV.ID_REVIEW) AS NR_REVIEW,
    AVG(RV.RATING) AS RATING_MEDIU
FROM Reteta R
LEFT JOIN Review RV ON R.ID_RETETA = RV.ID_RETETA
GROUP BY R.NUME
ORDER BY RATING_MEDIU DESC;

-- 4) Interogari imbricate -------------------------------------------------
-- a) Folosind IN
-- Gaseste utilizatorii care au evaluat retete cu mai mult de 3 ingrediente
SELECT U.NUME AS UTILIZATOR
FROM Utilizator U
WHERE ID_UTILIZATOR IN (
    SELECT RV.ID_UTILIZATOR
    FROM Review RV
    WHERE RV.ID_RETETA IN (
        SELECT R.ID_RETETA
        FROM Reteta R
        WHERE R.NR_INGREDIENTE > 3
    )
);

-- b) Folosind EXISTS
-- Listeaza retetele care au fost evaluate de utilizatorul "Ion Popescu"
SELECT R.NUME AS RETETA
FROM Reteta R
WHERE EXISTS (
    SELECT 1
    FROM Review RV
    INNER JOIN Utilizator U ON RV.ID_UTILIZATOR = U.ID_UTILIZATOR
    WHERE RV.ID_RETETA = R.ID_RETETA AND U.NUME = 'Ion Popescu'
);

-- Am folosit conditii compuse sus la UNION.
-- Am folosit DISTINCT la 2) b) LEFT JOIN


-- Functii User-Defined pentru validarea parametrilor:
-- Functie pentru validarea lungimii unui text (nume, comentariu, etc.):
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

-- Functie pentru validarea unui numar intreg:
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

-- Functie pentru validarea unui email:
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

-- Proceduri stocate ----------------------------------------------------------------
-- Procedura pt adaugarea unui ingredient
GO
CREATE PROCEDURE AddIngredient
    @NUME NVARCHAR(50),
    @KCAL INT,
    @ALERGENI NVARCHAR(100) = NULL,
    @UNITATE_MASURA NVARCHAR(20)
AS
BEGIN
    IF dbo.ValidateTextLength(@NUME, 1, 50) = 0
    BEGIN
        PRINT 'Eroare: Numele ingredientului trebuie sa contina intre 1 si 50 de caractere.';
        RETURN;
    END

    INSERT INTO Ingredient (NUME, KCAL, ALERGENI, UNITATE_MASURA)
    VALUES (@NUME, @KCAL, @ALERGENI, @UNITATE_MASURA);

    PRINT 'Ingredientul a fost adaugat cu succes.';
END;
GO

-- Procedura pentru adaugarea unei retete
GO 
CREATE PROCEDURE AddRecipe
    @NUME NVARCHAR(50),
    @NR_INGREDIENTE INT,
    @DURATA INT,
    @ID_CATEGORIE INT
AS
BEGIN
    IF dbo.ValidateTextLength(@NUME, 1, 50) = 0
    BEGIN
        PRINT 'Eroare: Numele retetei trebuie sa aiba intre 1 si 50 de caractere.';
        RETURN;
    END

    IF dbo.ValidateIntegerRange(@NR_INGREDIENTE, 1, 50) = 0
    BEGIN
        PRINT 'Eroare: Numarul de ingrediente trebuie sa fie intre 1 si 50.';
        RETURN;
    END

    INSERT INTO Reteta (NUME, NR_INGREDIENTE, DURATA, ID_CATEGORIE)
    VALUES (@NUME, @NR_INGREDIENTE, @DURATA, @ID_CATEGORIE);

    PRINT 'Reteta a fost adaugata cu succes.';
END;
GO

-- Procedura pentru adaugarea unei relatii in tabelul de legatura (Reteta_Ingredient)
GO
CREATE PROCEDURE AddRecipeIngredient
    @ID_RETETA INT,
    @ID_INGREDIENT INT,
    @CANTITATE DECIMAL(10, 2)
AS
BEGIN
    IF @CANTITATE <= 0
    BEGIN
        PRINT 'Eroare: Cantitatea trebuie sa fie mai mare decat 0.';
        RETURN;
    END

    INSERT INTO Reteta_Ingredient (ID_RETETA, ID_INGREDIENT, CANTITATE)
    VALUES (@ID_RETETA, @ID_INGREDIENT, @CANTITATE);

    PRINT 'Ingredientul a fost adaugat la reteta cu succes.';
END;
GO

SELECT * FROM Reteta_Ingredient
select * from Ingredient

exec AddRecipeIngredient 1, 6, 10 

-- 2) Crearea unui VIEW care combina date din 3 tabele -----------------------------------------
-- View care afiseaza retetele, ingredientele lor si utilizatorii care le-au evaluat:
GO
CREATE VIEW RecipeDetails AS
SELECT 
    R.NUME AS RETETA,
    I.NUME AS INGREDIENT,
    RI.CANTITATE,
    U.NUME AS UTILIZATOR,
    RV.RATING,
    RV.COMMENT
FROM Reteta R
INNER JOIN Reteta_Ingredient RI ON R.ID_RETETA = RI.ID_RETETA
INNER JOIN Ingredient I ON RI.ID_INGREDIENT = I.ID_INGREDIENT
LEFT JOIN Review RV ON R.ID_RETETA = RV.ID_RETETA
LEFT JOIN Utilizator U ON RV.ID_UTILIZATOR = U.ID_UTILIZATOR;
GO

Select * from RecipeDetails

-- 3) Implementarea triggerelor pentru Ingredient -----------------------------------------
-- Trigger pt INSERT
GO
CREATE TRIGGER trg_Ingredient_Insert
ON Ingredient
AFTER INSERT
AS
BEGIN
    DECLARE @currentTime DATETIME = GETDATE();
    PRINT CONCAT('Operatie: INSERT; Tabel: Ingredient; Data si ora: ', @currentTime);
END;
GO

INSERT INTO Ingredient (NUME, KCAL, ALERGENI, UNITATE_MASURA) VALUES
('rosii', 20, NULL, 'buc'), 
('castraveti', 15, NULL, 'buc'), 
('carne de vita', 250, 'Gluten', 'g')

-- Trigger pt DELETE
GO
CREATE TRIGGER trg_Ingredient_Delete
ON Ingredient
AFTER DELETE
AS
BEGIN
    DECLARE @currentTime DATETIME = GETDATE();
    PRINT CONCAT('Operatie: DELETE; Tabel: Ingredient; Data si ora: ', @currentTime);
END;
GO

DELETE FROM Ingredient
WHERE nume = 'rosii'

