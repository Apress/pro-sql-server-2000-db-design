--Note that the exact data that is returned from these queries will vary slightly from what is in 
--the text of the book.  The examples were not developed in the linear manner that the 
--examples may be executed in this script

----------------------------------------------------------------------
-- Example Table
----------------------------------------------------------------------

CREATE TABLE artist
(
   artistId int NOT NULL IDENTITY,
   name varchar(60),
   --note that the primary key is clustered to make a 
   --point later in the chapter
   CONSTRAINT XPKartist PRIMARY KEY CLUSTERED (artistId),
   CONSTRAINT XAKartist_name UNIQUE NONCLUSTERED (name)
)

INSERT INTO artist(name)
VALUES ('the beatles')
INSERT INTO artist(name)
VALUES ('the who')
GO

CREATE TABLE album
(
   albumId int NOT NULL IDENTITY,
   name varchar(60),
   artistId int NOT NULL,
   --note that the primary key is clustered to make a 
   --point later in the chapter
   CONSTRAINT XPKalbum PRIMARY KEY CLUSTERED(albumId),
   CONSTRAINT XAKalbum_name uNIQUE NONCLUSTERED (name),
   CONSTRAINT artist$records$album FOREIGN KEY (artistId) REFERENCES artist
)

INSERT INTO album (name, artistId)
VALUES ('the white album',1)
INSERT INTO album (name, artistId)
VALUES ('revolver',1)
INSERT INTO album (name, artistId)
VALUES ('quadraphenia',2)
go

----------------------------------------------------------------------
-- Scalar Function
----------------------------------------------------------------------

CREATE FUNCTION integer$increment
(
   @integerVal int
)
RETURNS int AS
BEGIN 
   SET @integerVal = @integerVal + 1
   RETURN @integerVal
END
GO

----------------------------

DECLARE @integer int
EXEC @integer = integer$increment @integerVal = 1
SELECT @integer AS value
go

----------------------------

--this will raise an error
SELECT integer$increment (1) AS value
go

--this will not
SELECT dbo.integer$increment (1) AS value
go

----------------------------

--these also will not
SELECT dbo.integer$increment @integerVal = 1 AS value
SELECT dbo.integer$increment (@integerVal = 1) AS value
go

--nesting calls
SELECT dbo.integer$increment(dbo.integer$increment(dbo.integer$increment (1))) AS value
go

----------------------------


CREATE FUNCTION string$properCase
(
   @inputString varchar(2000)
)
RETURNS varchar(2000) AS
BEGIN 
   -- set the whole string to lower
   SET @inputString = LOWER(@inputstring) 
   -- then use stuff to replace the first character
   SET @inputString = 
   --STUFF in the uppercased character in to the next character,
   --replacing the lowercased letter
   STUFF(@inputString,1,1,UPPER(SUBSTRING(@inputString,1,1)))

   --@i is for the loop counter, initialized to 2
   DECLARE @i int 
   SET @i = 1 

   --loop from the second character to the end of the string
   WHILE @i < LEN(@inputString)
   BEGIN
      --if the character is a space
      IF SUBSTRING(@inputString,@i,1) = ' '
      BEGIN
         --STUFF in the uppercased character into the next character
         SET @inputString = STUFF(@inputString,@i + 
         1,1,UPPER(SUBSTRING(@inputString,@i + 1,1))) 
      END
      --increment the loop counter
      SET @i = @i + 1
   END
   RETURN @inputString
END
GO

----------------------------

SELECT name, dbo.string$properCase(name) AS artistProper
FROM artist
go

----------------------------

CREATE FUNCTION album$recordCount
(
   @artistId int
)
RETURNS int AS
BEGIN 
   DECLARE @count AS int -- variable to hold output

   --count the number of rows in the table
   SELECT @count = count(*)
   FROM album
   WHERE artistId = @artistId

   RETURN @count 
END
GO

----------------------------

SELECT dbo.album$recordCount(1) AS albumCount
go

----------------------------

SELECT name, 
   artistId, 
   dbo.album$recordCount(artistId) AS albumCount
FROM album
Go

----------------------------------------------------------------------
--Inline Table-Valued Functions
----------------------------------------------------------------------
CREATE FUNCTION album$returnKeysByArtist
(
   @artistId int
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN ( 
   SELECT albumId
   FROM dbo.album
   WHERE artistId = @artistId )
go

----------------------------

EXEC dbo.album$returnKeysbyArtist @artistId = 1
go

----------------------------

SELECT album.albumId, album.name
FROM album
   JOIN dbo.album$returnKeysbyArtist(1) AS functionTest
   ON album.albumId = functionTest.albumId
go


----------------------------------------------------------------------
--Schema Binding
----------------------------------------------------------------------
DROP TABLE album
go

ALTER TABLE album
ADD description varchar(100) NULL
ALTER TABLE album
DROP COLUMN description
go

----------------------------

--this will cause an error 
ALTER TABLE album
DROP COLUMN artistId
go

----------------------------

--this will cause an error 
ALTER FUNCTION album$returnKeysByArtist
(
   @artistId int
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN ( 
   SELECT albumId
   FROM album ---- used to be dbo.album
   WHERE artistId = @artistId)
go

----------------------------

alter FUNCTION album$returnKeysByArtist
(
   @artistId int
)
RETURNS TABLE
AS
RETURN ( 
   SELECT albumId
   FROM dbo.album
   WHERE artistId = @artistId )
go

----------------------------------------------------------------------
--Multi-Statement Table-Valued Functions
----------------------------------------------------------------------
CREATE FUNCTION album$returnNamesInUpperCase
(
   @artistId int
)
RETURNS @outTable table ( 
   albumId int,
   name varchar(60) )
WITH SCHEMABINDING
AS
BEGIN
   --add all of the albums to the output table
   INSERT INTO @outTable
   SELECT albumId, name
   FROM dbo.album
   WHERE artistId = @artistId

   --second superfluous update to show that it
   --is a multi-statement function
   UPDATE @outTable
   SET name = UPPER(name)
   RETURN
END
GO

----------------------------

SELECT * FROM dbo.album$returnNamesInUpperCase(1)
go


----------------------------------------------------------------------
--What User Defined Functions Cannot Do
----------------------------------------------------------------------

--this will fail because of the update
CREATE FUNCTION album$setAllToTheBeatles
(
)
RETURNS int AS
BEGIN 
   DECLARE @rowcount int

   UPDATE album
   SET artistId = 1
   WHERE artistId <> 1

   RETURN 1
END
go

----------------------------------------------------------------------
--literal defaults
----------------------------------------------------------------------
SELECT * FROM artist
go
ALTER TABLE album
   ADD CONSTRAINT dfltAlbum$artistId$integer$one
   DEFAULT (1)
   FOR artistId
go

----------------------------

ALTER TABLE artist
   ADD defaultFl bit NOT NULL 
      CONSTRAINT dfltArtist$defaultFl$boolean$false 
	    DEFAULT (0)
go

----------------------------

UPDATE artist
SET defaultFl = 1
WHERE name = 'the beatles'
go

----------------------------

CREATE FUNCTION artist$returnDefaultId
(
)
RETURNS int 
WITH SCHEMABINDING
AS
BEGIN 
   DECLARE @artistId int

   SELECT @artistId = artistId
   FROM dbo.artist
   WHERE defaultFl = 1

   RETURN @artistId
END
GO

----------------------------

SELECT dbo.artist$returnDefaultId() AS defaultValue
go

----------------------------

--not in text
alter table album
	drop constraint dfltAlbum$artistId$integer$one
go

ALTER TABLE album
   ADD CONSTRAINT dfltAlbum$artistId$function$useDefault
   DEFAULT dbo.artist$returnDefaultId()
   FOR artistId
go

----------------------------

INSERT INTO album(name)
VALUES ('rubber soul')

----------------------------

SELECT album.name AS albumName, artist.name AS artistName
FROM album 
   JOIN artist 
   ON album.artistId = artist.artistId
WHERE album.name = 'rubber soul'
go


----------------------------------------------------------------------
--Check Constraints
----------------------------------------------------------------------

--in a transaction so we don't actually add the rows to the database
begin transaction
INSERT INTO album ( name, artistId)
VALUES ('',1)
INSERT INTO album ( name, artistId)
VALUES ('',1)
rollback transaction

go

----------------------------

ALTER TABLE album WITH CHECK 
   ADD CONSTRAINT chkAlbum$name$string$noEmptyString
   --trim the value in name, adding in stars to handle 
   --values safer than just checking length of the rtrim which
   --will be NULL if name is NULL, and a single char if not.  The coalesce
   --makes certain
   CHECK (( '*' + COALESCE(rtrim(name),'') + '*') <> '**' )
go

----------------------------

--not in text
INSERT INTO album ( name, artistId)
VALUES ('',1)
go

/* already added, this is just in case you want to try it
ALTER TABLE album WITH NOCHECK 
   ADD CONSTRAINT chkAlbum$name$string$noEmptyString
   --trim the value in name, adding in stars to handle 
   --values safer than just checking length of the rtrim
   CHECK (( '*' + COALESCE(rtrim(name),'') + '*') <> '**' )
*/

--slight deviation from the text to make things a bit more linear in the 
--code samples.  This will cause the error.
UPDATE album
SET name = ''
go

----------------------------

CREATE FUNCTION string$checkForEmptyString
(
   @stringValue varchar(8000)
) 
RETURNS bit
AS
BEGIN 
   DECLARE @logicalValue bit
   IF ( '*' + COALESCE(RTRIM(@stringValue),'') + '*') = '**' 
       SET @logicalValue = 1
   ELSE
       SET @logicalValue = 0
  
   RETURN @logicalValue
END
go

----------------------------

--not in text, but is here for cleanup
ALTER TABLE album 
   drop CONSTRAINT chkAlbum$name$string$noEmptyString
go

----------------------------

ALTER TABLE album WITH NOCHECK 
   ADD CONSTRAINT chkAlbum$name$string$noEmptyString
   --trim the value in name, adding in stars to handle 
   --values safer than just checking length of the rtrim
   CHECK (dbo.string$checkForEmptyString(name) = 0)
go

----------------------------

ALTER TABLE album
   ADD catalogNumber char(12) NOT NULL 
   --temporary default so we can make the column 
   --not NULL in intial creation
   CONSTRAINT tempDefaultAlbumCatalogNumber DEFAULT ('111-11111-11')

----------------------------

 --drop it because this is not a proper default
ALTER TABLE album
   DROP tempDefaultAlbumCatalogNumber
go

----------------------------

CREATE FUNCTION album$catalogNumberValidate
(
   @catalogNumber char(12)
) 
RETURNS bit
AS
BEGIN 
   DECLARE @logicalValue bit
   --check to see if the value like the mask we have set up
   IF @catalogNumber LIKE 
            '[0-9][0-9][0-9]-[0-9][0-9][0-9a-z][0-9a-z][0-9a-z]-[0-9][0-9]'
      SET @logicalValue = 1 --yes it is
   ELSE
      SET @logicalValue = 0 --no it is not
   --note that we cannot just simply say RETURN 1, or RETURN 0 as the 
   --function must have only one exit point
   RETURN @logicalValue
END
go

----------------------------

IF dbo.album$catalogNumberValidate('433-11qww-33') = 1 
   SELECT 'Yes' AS result
ELSE
   SELECT 'No' AS result
go

----------------------------

ALTER TABLE album
   ADD CONSTRAINT 
   chkAlbum$catalogNumber$function$artist$catalogNumberValidate
   --keep it simple here, encapsulating all we need to in the
   --function
   CHECK (dbo.album$catalogNumbervalidate(catalogNumber) = 1)
go

----------------------------

UPDATE album
SET catalogNumber = '1'
WHERE name = 'the white album'
go

UPDATE album
SET catalogNumber = '433-43ASD-33'
WHERE name = 'the white album'
go

----------------------------

ALTER TABLE artist
   ADD catalogNumberMask varchar(100) NOT NULL 
   -- it is acceptable to have a mask of percent in this case
   CONSTRAINT dfltArtist$catalogNumberMask$string$percent 
   DEFAULT ('%')

go

----------------------------

--not in text.  We drop the constraint so we can change the function
ALTER TABLE album
   drop CONSTRAINT 
   chkAlbum$catalogNumber$function$artist$catalogNumberValidate
go

----------------------------

ALTER FUNCTION album$catalogNumberValidate
(
   @catalogNumber char(12),
   @artistId int --now based on the artist id
) 
RETURNS bit
AS
BEGIN 
   DECLARE @logicalValue bit, @catalogNumberMask varchar(100)

   SELECT @catalogNumberMask = catalogNumberMask 
   FROM artist 
   WHERE artistId = @artistId

   IF @catalogNumber LIKE @catalogNumberMask
      SET @logicalValue = 1
   ELSE
      SET @logicalValue = 0

   RETURN @logicalValue
END
GO

----------------------------

--note that we have set these via the artistId which is an identity value
--you may have to modify these values if you had trouble loading the artist 
--data 
UPDATE artist
SET catalogNumberMask =
          '[0-9][0-9][0-9]-[0-9][0-9][0-9a-z][0-9a-z][0-9a-z]-[0-9][0-9]'
WHERE artistId = 1 --the beatles

UPDATE artist
SET catalogNumberMask = 
          '[a-z][a-z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
WHERE artistId = 2 --the who
go

----------------------------

IF dbo.album$catalogNumberValidate('433-43ASD-33',1) = 1 
   SELECT 'Yes' AS result
ELSE
   SELECT 'No' AS result

IF dbo.album$catalogNumberValidate('aa1111111111',2) = 1 
   SELECT 'Yes' AS result
ELSE
   SELECT 'No' AS result
GO

----------------------------

ALTER TABLE album
   ADD CONSTRAINT 
   chkAlbum$catalogNumber$function$artist$catalogNumberValidate
   CHECK (dbo.album$catalogNumbervalidate(catalogNumber,artistId) = 1)
go

----------------------------

--to find where our data is not ready for the constraint, 
--we run the following query
SELECT dbo.album$catalogNumbervalidate(catalogNumber,artistId) 
   AS validCatalogNumber,
   artistId, name, catalogNumber
FROM album
WHERE dbo.album$catalogNumbervalidate(catalogNumber,artistId) <> 1
go

----------------------------

UPDATE album
SET catalogNumber = '1'
WHERE name = 'the white album'
go

UPDATE album
SET catalogNumber = '433-43ASD-33'
WHERE name = 'the white album' --the artist is the beatles
go

----------------------------------------------------------------------
--Handling Errors Caused by Constraints
----------------------------------------------------------------------

BEGIN TRANSACTION

   DECLARE @errorHold int

   UPDATE album
   SET catalogNumber = '1'
   WHERE name = 'the white album'

   SET @errorHold = @@error
   IF @errorHold <> 0 
   BEGIN
      RAISERROR 50000 'Error modifying the first catalogNumber for album'
      ROLLBACK TRANSACTION 
   END

   IF @errorHold = 0
   BEGIN
      UPDATE album
      SET catalogNumber = '1'
      WHERE name = 'the white album'

      SET @errorHold = @@error
      IF @errorHold <> 0 
      BEGIN
         RAISERROR 50000 'Error modifying the second catalogNumber'
         ROLLBACK TRANSACTION 
      END
   END

IF @errorHold = 0
   COMMIT TRANSACTION
ELSE
   RAISERROR 50000 'Update batch did not succeed'

go
