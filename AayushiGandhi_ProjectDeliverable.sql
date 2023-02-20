-- Create DATABASE Video_Games_Sales;
USE Video_Games_Sales;

-- Drop Table Game_Platform;

Create Table GameDetails (
    GameDetailsId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    RANK INT NOT NULL,
    YEAR INT NOT NULL,
    PublisherId INT NOT NULL,
    SalesId INT NOT NULL,
    GenreId INT NOT NULL,
    GameId INT NOT NULL
);

Create Table Game(
    GameId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Game_Name VARCHAR(100) NOT NULL,
)


Create Table Game_Platform (
    Game_PlatformId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    GameId INT NOT NULL,
    PlatformID INT NOT NULL
);

Create Table Platform (
    PlatformId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    PlatformName VARCHAR(100) NOT NULL
);

Create Table Genre(
    GenreId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    GenreName Varchar(100) NOT NULL
);

Create Table Sales(
    SalesId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    NA_SALES DECIMAL(15,2) NOT NULL,
    EU_SALES DECIMAL(15,2) NOT NULL,
    JP_SALES DECIMAL(15,2) NOT NULL,
    Other_SALES DECIMAL(15,2) NOT NULL,
    Global_SALES DECIMAL(15,2) NOT NULL
);

Create Table Publisher(
    PublisherId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    PublisherName VARCHAR(100)
);

Alter Table GameDetails
ADD CONSTRAINT FK_Publisher1 FOREIGN KEY (PublisherId) REFERENCES Publisher(PublisherId),
CONSTRAINT FK_Sales1 FOREIGN KEY (SalesId) REFERENCES Sales(SalesId),
CONSTRAINT FK_Game1 FOREIGN KEY (GameId) REFERENCES Game(GameId),
CONSTRAINT FK_Genre1 FOREIGN KEY (GenreId) REFERENCES Genre(GenreId)
;



Alter Table Game_Platform
ADD CONSTRAINT FK_Game2 FOREIGN KEY (GameId) REFERENCES Game(GameId),
CONSTRAINT FK_Platform1 FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID)
;



Insert Into Platform(PlatformName) VALUES ('PC'),('Xbox360'),('PSP'),('PS2'),('PS4')

Insert Into Genre(GenreName) VALUES ('Sports'),('Role-Playing'),('Puzzle'),('Racing'),('Action')

Insert Into Publisher(PublisherName) VALUES ('Nintendo'),('Microsoft Game Studio'),('Take-Two Interactive'),('Sony Computer Entertainment'),('Activision')

Insert Into Sales(NA_SALES,EU_SALES,JP_SALES,Other_SALES,Global_SALES) VALUES ('41.49','29.02','3.77','8.46','82.74'), ('29.08','3.58','6.81','0.77','40.24'), ('15.85','12.88','3.79','3.31','35.82'),('15.75','11.01','3.28','2.96','33'),('11.27','8.89','10.22','1','31.37') 

Insert Into Game(Game_Name) VALUES ('Wii Sports'),('Super Mario Bros'), ('Grand Theft Auto V'), ('Pokemon Go'), ('Duck Hunt')

Insert Into GameDetails(RANK) VALUES ('1'),('2'),('3'),('4'),('5')


-- Stored Procedures

GO 
CREATE PROC InsertIntoGameDetailsTable
@Rank NUMERIC(8,2),
@Year VARCHAR(8),
@PublisherName VARCHAR(50),
@GameName VARCHAR(50),
@GlobalSales VARCHAR(50),
@GenreName VARCHAR(50)

AS DECLARE @A_ID INT
 DECLARE @B_ID INT
 DECLARE @C_ID INT
 DECLARE @D_ID INT

SET @A_ID = (Select t1.PublisherId
            FROM Publisher as t1
            where t1.PublisherName = @PublisherName);

SET @B_ID = (Select t2.GameId
            FROM Game as t2
            where t2.Game_Name = @GameName );

SET @C_ID = (Select t3.SalesId
            FROM Sales as t3
            where t3.Global_SALES = @GlobalSales);
        
SET @D_ID = (Select t4.GenreId
            FROM Genre as t4
            where t4.GenreName = @GenreName);

IF @A_ID IS NULL
    BEGIN
        PRINT 'Publisher Name is NULL; check all parameters';
        THROW 55623, '@A_ID cannot be NULL; process is terminating', 1;
    END

IF @B_ID IS NULL
    BEGIN
        PRINT 'Game Name is NULL; check all parameters';
        THROW 55623, '@B_ID cannot be NULL; process is terminating', 1;
    END

IF @C_ID IS NULL
    BEGIN
        PRINT 'Global Sales is NULL; check all parameters';
        THROW 55623, '@C_ID cannot be NULL; process is terminating', 1;
    END

IF @D_ID IS NULL
    BEGIN
        PRINT 'Genre Name is NULL; check all parameters';
        THROW 55623, '@D_ID cannot be NULL; process is terminating', 1;
    END

BEGIN TRANSACTION T1
INSERT INTO GameDetails(RANK,YEAR,PublisherId,GameId,SalesId,GenreId)
VALUES (@Rank,@Year, @A_ID,@B_ID,@C_ID,@D_ID)
COMMIT TRANSACTION T1

EXEC InsertIntoGameDetailsTable
@GameName = 'Super Mario Bros',
@GenreName = 'Sports',
@GlobalSales = '40.24',
@PublisherName = 'Nintendo',
@Rank = '1',
@Year = '2014'

EXEC InsertIntoGameDetailsTable
@GameName = 'Grand Theft Auto V',
@GenreName = 'Action',
@GlobalSales = '35.82',
@PublisherName = 'Activision',
@Rank = '2',
@Year = '2017'

EXEC InsertIntoGameDetailsTable
@GameName = 'Pokemon Go',
@GenreName = 'Puzzle',
@GlobalSales = '82.74',
@PublisherName = 'Nintendo',
@Rank = '3',
@Year = '2015'
 
GO 
CREATE PROC InsertIntoGamePlatformTable
@GameName VARCHAR(100),
@PlatformName VARCHAR(100) 

AS 
DECLARE @E_ID INT, @F_ID INT

SET @E_ID = (Select t1.GameId
            FROM Game as t1
            where t1.Game_Name =@GameName)

SET @F_ID = (Select t2.PlatformID
            FROM Platform as t2
            where t2.PlatformName =@PlatformName)

IF @E_ID IS NULL
    BEGIN
        PRINT 'Game Name is NULL; check all parameters';
        THROW 55623, '@E_ID cannot be NULL; process is terminating', 1;
    END

IF @F_ID IS NULL
    BEGIN
        PRINT 'Platform Name is NULL; check all parameters';
        THROW 55623, '@F_ID cannot be NULL; process is terminating', 1;
    END



BEGIN TRANSACTION T2
INSERT INTO Game_Platform(GameId, PlatformID)
VALUES (@E_ID,@F_ID)
COMMIT TRANSACTION T2

EXEC InsertIntoGamePlatformTable
@GameName = 'Super Mario Bros',
@PlatformName = 'PS2'

EXEC InsertIntoGamePlatformTable
@GameName = 'Grand Theft Auto V',
@PlatformName = 'PS4'

EXEC InsertIntoGamePlatformTable
@GameName = 'Pokemon Go',
@PlatformName = 'PS4'

--Business Rules

BEGIN TRANSACTION T1
ALTER TABLE Genre
ADD CHECK (GenreName in ('Sports','Role-Playing','Puzzle','Racing','Action'))
COMMIT TRANSACTION T1


BEGIN TRANSACTION T1
ALTER TABLE Platform
ADD CHECK (PlatformName in ('PC','Xbox360','PSP','PS2','PS4'))
COMMIT TRANSACTION T1

-- Complex Queries

-- 1. Select top 2 games having platform as PS4 and order them by most recent 

 SELECT top 2 Game.Game_Name, Platform.PlatformName, GameDetails.[YEAR]
 from Platform join Game_Platform on Game_Platform.PlatformID = Platform.PlatformId
 join Game on Game.GameId = Game_Platform.GameId
 join GameDetails on Game.GameId = GameDetails.GameId
 where Platform.PlatformName = 'PS4'
 order by [YEAR] DESC


-- 2. Which platform has the highest global sales

SELECT Platform.PlatformName, sum(Sales.Global_SALES) as Highest
 from Platform join Game_Platform on Game_Platform.PlatformID = Platform.PlatformId
 join Game on Game.GameId = Game_Platform.GameId
 join GameDetails on Game.GameId = GameDetails.GameId
 join Sales on GameDetails.SalesId = Sales.SalesId
 group by Platform.PlatformName
 order by Highest desc




-- User-defined functions

-- 1. Divide games into two time-frames : 'old' and 'new' where anything before 2015 is old and after 2015 is new
GO
CREATE FUNCTION TimeFrame (@Game_Name VARCHAR(500))
RETURNS VARCHAR(50) AS
BEGIN
    DECLARE @TimeFrame VARCHAR(50)
    SET @TimeFrame = (
        select case when GameDetails.[YEAR] < 2015 then 'Old'
                    when GameDetails.[YEAR] >= 2015 then 'New'
                END AS TimeFrame
            FROM Game
            join GameDetails on Game.GameId = GameDetails.GameId
            WHERE Game.Game_Name = @Game_Name
    );
    RETURN @TimeFrame
END;

GO

SELECT dbo.TimeFrame ('Pokemon Go') as ReadTime
SELECT dbo.TimeFrame ('Super Mario Bros') as ReadTime

--2. Most recently published game by publisher
 
GO
CREATE FUNCTION LatestPublished12 (@PublisherName VARCHAR(100))
RETURNS VARCHAR(500) AS
BEGIN
    DECLARE @LatestPublished12 VARCHAR (100), @Year VARCHAR
    set @LatestPublished12 = (
        select top 1 Game.Game_Name FROM Game
        join GameDetails on Game.GameId = GameDetails.GameId
        join Publisher on GameDetails.PublisherId = Publisher.PublisherId
        WHERE Publisher.PublisherName = @PublisherName
        order by GameDetails.YEAR desc
    );

    RETURN @LatestPublished12
END;

GO 
SELECT dbo.LatestPublished12 ('Nintendo') as LatestPublished12
SELECT dbo.LatestPublished12 ('Activision') as LatestPublished12
SELECT dbo.LatestPublished12 ('Microsoft Game Studio') as LatestPublished12 -- null since no matching values

