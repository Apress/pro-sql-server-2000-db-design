
----------------------------------------------------------------------
--Triggers - Accessing Modified Rows
----------------------------------------------------------------------

--build a trigger that returns as a result set as 
--inserted and deleted tables for demonstration purposes
--only. For real triggers, this is a bad idea
CREATE TRIGGER artist$afterUpdate$showInsertedAndDeleted
ON artist
AFTER UPDATE -- fires after the update has occurred
AS

SELECT 'contents of inserted' -- informational output
SELECT * 
FROM INSERTED

SELECT 'contents of deleted' -- informational output
SELECT * 
FROM DELETED
GO

UPDATE artist
SET name = UPPER(name)
go


----------------------------------------------------------------------
-- Triggers - Determining which Columns have been Modified
----------------------------------------------------------------------

CREATE TABLE columnUpdatedTest
(
   columnUpdatedTestId int IDENTITY, --bitmask value 1
   column1 int,                      --bitmask value 2
   column2 int,                      --bitmask value 4
   column3 int                       --bitmask value 8
)
go

CREATE TRIGGER testIt
ON columnUpdatedTest
AFTER INSERT,UPDATE
AS
IF update(columnUpdatedTestId) 
BEGIN
   SELECT 'columnUpdatedTestId modified'
END
IF update(column1) 
BEGIN
   SELECT 'column1 modified'
END
IF update(column2) 
BEGIN
   SELECT 'column2 modified'
END
IF update(column3)
BEGIN
   SELECT 'column3 modified'
END
GO
----------------------------

INSERT columnUpdatedTest(column1,column2, column3)
VALUES (1,1,1)
go
----------------------------

UPDATE columnUpdatedTest
SET column2 = 2
WHERE columnUpdatedTestId = 1
go

----------------------------------------------------------------------
--Triggers - Writing Multi-row Validations
----------------------------------------------------------------------
CREATE TRIGGER artist$afterUpdate$demoMultiRow
ON artist
AFTER INSERT, UPDATE --fires after the insert and update has occurred
AS
IF NOT EXISTS ( SELECT *
   FROM INSERTED
   WHERE name IN ('the who','the beatles','jethro tull')
   )
   BEGIN
      SELECT 'Invalid artist validation 1'
   END

IF EXISTS ( SELECT *
   FROM INSERTED
   WHERE name NOT IN ('the who','the beatles','jethro tull')
   )
   BEGIN
      SELECT 'Invalid artist validation 2'
   END
GO

----------------------------

BEGIN TRANSACTION

INSERT INTO artist (name, defaultFl, catalogNumberMask)
VALUES ('ROLLING STONES',0,'%')

ROLLBACK TRANSACTION --undo our test rows
go

----------------------------

BEGIN TRANSACTION

INSERT INTO artist (name, defaultFl, catalogNumberMask)
SELECT 'ROLLING STONES',0,'%'
UNION
SELECT 'JETHRO TULL',0,'%'

ROLLBACK TRANSACTION --undo our test rows
go

----------------------------------------------------------------------
--Having multiple triggers for the same action
----------------------------------------------------------------------
CREATE TABLE tableA 
(
   field varchar(40) NOT NULL
) 
CREATE TABLE tableB 
(
   field varchar(40) not NULL
) 
GO

----------------------------

CREATE TRIGGER tableA$afterUpdate$demoNestRecurse
ON tableA
AFTER INSERT
AS

--tell the user that the trigger has fired
SELECT 'table a insert trigger'

--insert the values into tableB
INSERT INTO tableB (field)
SELECT field
FROM INSERTED
GO


CREATE TRIGGER tableB$afterUpdate$demoNestRecurse
ON tableB
AFTER INSERT
AS

--tell the user that the trigger has fired
SELECT 'table b insert trigger'

--insert the values into tableB
INSERT INTO tableA (field)
SELECT field
FROM INSERTED
GO


EXEC sp_configure 'nested triggers', 0 -- (1 = on, 0 = off)
RECONFIGURE      --required for immediate acting server configuration 
go

----------------------------

INSERT INTO tableA (field)
VALUES ('test value')
go

EXEC sp_configure 'nested triggers', 1 -- where 1 = ON, 0 = OFF
RECONFIGURE
EXEC sp_dboption 'bookTest','recursive triggers','FALSE'
go
----------------------------

INSERT INTO tableA (field)
VALUES ('test value')
go

----------------------------

--not in book.  Forgot the recursive trigger
EXEC sp_configure 'nested triggers', 1 -- where 1 = ON, 0 = OFF
RECONFIGURE
EXEC sp_dboption 'bookTest','recursive triggers','TRUE'
go


ALTER TRIGGER tableA$afterUpdate$demoNestRecurse
ON tableA
AFTER INSERT
AS

--tell the user that the trigger has fired
SELECT 'table a insert trigger'

--insert the values into tableB
INSERT INTO tableA (field)
SELECT field
FROM INSERTED
GO

----------------------------

INSERT INTO tableA (field)
VALUES ('test value')
go

----------------------------------------------------------------------
--After triggers
----------------------------------------------------------------------

CREATE TRIGGER artist$trInsertDemo ON artist
AFTER INSERT
AS

SELECT 'contents of inserted'
SELECT artistId, name --just PK and name so it fits on a line in the book
FROM INSERTED 

SELECT 'contents of artist'
SELECT artistId, name
FROM artist
GO

INSERT INTO artist (name)
VALUES ('jethro tull')

go

----------------------------------------------------------------------
--Implementing Multiple AFTER Triggers
----------------------------------------------------------------------

--not in book.  turn the recursive triggers back off
EXEC sp_configure 'nested triggers', 0 -- where 1 = ON, 0 = OFF
RECONFIGURE
EXEC sp_dboption 'bookTest','recursive triggers','FALSE'
go

ALTER TRIGGER tableA$afterUpdate$demoNestRecurse
ON tableA
AFTER INSERT
AS
SELECT 'table a insert trigger'

INSERT INTO tableB (field)
VALUES (object_name(@@procid))     --@@procid gives the object_id of the 
                                   --of the current executing procedure
GO


CREATE TRIGGER tableA$afterUpdate$demoNestRecurse2
ON tableA
AFTER INSERT
AS
SELECT 'table a insert trigger2'

INSERT INTO tableB (field)
VALUES (object_name(@@procid))
GO

CREATE TRIGGER tableA$afterUpdate$demoNestRecurse3
ON tableA
AFTER INSERT
AS
SELECT 'table a insert trigger3'

INSERT INTO tableB (field)
VALUES (object_name(@@procid))
GO

----------------------------

--truncate table deletes the rows in the table very fast with a single log
--entry, plus it resets the identity values
TRUNCATE TABLE tableA
TRUNCATE TABLE tableB

go

INSERT INTO tableA
VALUES ('Test Value')
go

SELECT * FROM tableA
SELECT * FROM tableB
go

----------------------------

EXEC sp_settriggerorder 
              @triggerName = 'tableA$afterUpdate$demoNestRecurse3', 
              @order = 'first', 
              @stmttype = 'insert'
GO

TRUNCATE TABLE tableA
TRUNCATE TABLE tableB

INSERT INTO tableA
VALUES ('Test Value')

SELECT * FROM tableA
SELECT * FROM tableB
GO


--------------------------------------------------------------------------------
--Using AFTER Triggers to Solve Common Problems
--------------------------------------------------------------------------------
/*

CREATE TRIGGER <triggerName> 
ON <tableName> 
FOR <action> AS
------------------------------------------------------------------------------
-- Purpose : Trigger on the <action> that fires for any <action> DML 
------------------------------------------------------------------------------
BEGIN
   DECLARE @rowsAffected int,    --stores the number of rows affected 
   @errNumber int,               --used to hold the error number after DML
   @msg varchar(255),            --used to hold the error message
   @errSeverity varchar(20),
   @triggerName sysname

   SET @rowsAffected = @@rowcount
   SET @triggerName = object_name(@@procid)      --used for messages

   --no need to continue on if no rows affected
   IF @rowsAffected = 0 return 

<insert snippets here >

END

*/

--------------------------------------------------------------------------------
--Cascading Inserts
--------------------------------------------------------------------------------

create table url
(
	urlId	int identity,
	url	varchar(400) not null
)

create table urlStatusType
(
	
	urlStatusTypeId	int identity,
	name		varchar(60) not null,
	defaultFl	bit	not null
)

create table urlStatus
(
	urlStatusId	int identity,
	urlStatusTypeId	int not null,
	urlId		int not null
)

go



CREATE TRIGGER url$afterInsert$autoSetStatus
ON url
FOR insert AS
------------------------------------------------------------------------------
-- Purpose : Trigger on the <action> that fires for any <action> DML 
------------------------------------------------------------------------------
BEGIN
   DECLARE @rowsAffected int,    --stores the number of rows affected 
   @errorNumber int,             --used to hold the error number after DML
   @msg varchar(255),            --used to hold the error message
   @errSeverity varchar(20),
   @triggerName sysname

   SET @rowsAffected = @@rowcount
   SET @triggerName = object_name(@@procid)      --used for messages

   --no need to continue on if no rows affected
   IF @rowsAffected = 0 return 

   --add a record to the urlStatus table to tell it that the new record
   --should start out as the default status
   INSERT INTO urlType (urlId, urlTypeId)
   SELECT INSERTED.urlId, urlType.urlTypeId
   FROM INSERTED
      CROSS JOIN urlType     --use cross join with a where clause
                             --as this is not technically a join between
                             --INSERTED and urlType
   WHERE urlType.defaultFl = 1 

   SET @errorNumber = @@error
   IF @errorNumber <> 0
   BEGIN
      SET @msg = 'Error: ' + CAST(@errorNumber as varchar(10)) + 
                              ' occurred during the creation of urlStatus'
      RAISERROR 50000 @msg
      ROLLBACK TRANSACTION
      RETURN 
   END


END

--------------------------------------------------------------------------------
--range checks
--------------------------------------------------------------------------------



CREATE TRIGGER urlStatusType$afterUpdate$rangeCheck
ON urlStatusType
FOR update AS
------------------------------------------------------------------------------
-- Purpose : Trigger on the <action> that fires for any <action> DML 
------------------------------------------------------------------------------
BEGIN
   DECLARE @rowsAffected int,    --stores the number of rows affected 
   @errorNumber int,             --used to hold the error number after DML
   @msg varchar(255),            --used to hold the error message
   @errSeverity varchar(20),
   @triggerName sysname

   SET @rowsAffected = @@rowcount
   SET @triggerName = object_name(@@procid)      --used for messages

   --no need to continue on if no rows affected
   IF @rowsAffected = 0 return 

   --if the defaultFl column was modified
   IF UPDATE(defaultFl)
   BEGIN
      --update any other rows in the status type table to not default if 
      --a row was inserted that was set to default
      UPDATE urlStatusType
      SET defaultFl = 0
      FROM urlStatusType
            --only rows that were already default
      WHERE urlStatusType.defaultFl = 1 
            --and not in the inserted rows
        AND urlStatusTypeid NOT IN 
        ( SELECT urlStatusTypeId
        FROM inserted
        WHERE defaultFl = 1
        )

      SET @errorNumber = @@error
      IF @errorNumber <> 0
      BEGIN
         SET @msg = 'Error: ' + CAST(@errorNumber as varchar(10)) + 
                    ' occurred during the modification of defaultFl'
         RAISERROR 50000 @msg
         ROLLBACK TRANSACTION
         RETURN 
      END

      --see if there is more than 1 row set to default
      --like if the user updated more than one in a single operation
      IF ( SELECT count(*)
           FROM urlStatusType
           WHERE urlStatusType.defaultFl = 1 ) > 1
      BEGIN
         SET @msg = 'Too many rows with default flag = 1'
         RAISERROR 50000 @msg
         ROLLBACK TRANSACTION
         RETURN 
      END
   END



END

go

--------------------------------------------------------------------------------
--Cascading Deletes Setting the values of Child Tables to NULL
--------------------------------------------------------------------------------

create table company
(
	companyId	int identity,
	name		varchar(60) not null,
	urlId		int null
)

go



CREATE TRIGGER company$afterDelete$cascadeSetNull
ON company
FOR delete AS
------------------------------------------------------------------------------
-- Purpose : Trigger on the <action> that fires for any <action> DML 
------------------------------------------------------------------------------
BEGIN
   DECLARE @rowsAffected int,    --stores the number of rows affected 
   @errorNumber int,             --used to hold the error number after DML
   @msg varchar(255),            --used to hold the error message
   @errSeverity varchar(20),
   @triggerName sysname

   SET @rowsAffected = @@rowcount
   SET @triggerName = object_name(@@procid)      --used for messages

   --no need to continue on if no rows affected
   IF @rowsAffected = 0 return 

   UPDATE company
   SET urlId = NULL
   FROM DELETED
      JOIN company
      ON DELETED.urlId = company.urlId 

   SET @errorNumber = @@error
   IF @errorNumber <> 0
   BEGIN
      SET @msg = 'Error: ' + CAST(@errorNumber as varchar(10)) + 
                            ' occurred during delete cascade set NULL'
      RAISERROR 50000 @msg
      ROLLBACK TRANSACTION
      RETURN 
   END



END

go


----------------------------------------------------------------------
-- Instead of Trigger
----------------------------------------------------------------------

CREATE TRIGGER artist$insteadOfInsert ON artist
INSTEAD OF INSERT
AS
--output the contents of the inserted table
SELECT 'contents of inserted'
SELECT * FROM inserted

--output the contents of the physical table
SELECT 'contents of artist'
SELECT * FROM artist
GO

----------------------------

INSERT INTO artist (name)
VALUES ('John Tesh')
go

SELECT artistId, name 
FROM artist
go

----------------------------

--not in text.  Need to drop existing trigger
drop trigger artist$insteadOfInsert
drop trigger artist$insteadOfDelete
go


CREATE TRIGGER artist$insteadOfInsert on artist
INSTEAD OF INSERT
AS

-- must mimic the operation we are doing "instead of".
-- note that must supply a column list for the insert
-- and we cannot simply do a SELECT * FROM INSERTED because of the
-- identity column, which complains when you try to pass it a value
INSERT INTO artist(name, defaultFl, catalogNumberMask) 
SELECT name, defaultFl, catalogNumberMask
FROM INSERTED
GO

CREATE TRIGGER artist$insteadOfDelete on artist
INSTEAD OF DELETE
AS

-- must mimic the operation we are doing "instead of"
DELETE FROM artist
FROM DELETED
   -- we always join the inserted and deleted tables
   -- to the real table via the primary key, 
   JOIN ARTIST
   ON DELETED.artistId = artist.artistId

go

----------------------------

INSERT INTO artist(name, defaultFl, catalogNumberMask)
VALUES ('raffi',0,'%')

SELECT * FROM artist WHERE name = 'raffi'
go

----------------------------

DELETE FROM artist
WHERE name = 'raffi'
go

SELECT * FROM artist WHERE name = 'raffi'
go

----------------------------------------------------------------------
--Uses of Instead-Of Triggers - automatically maintaining fields
----------------------------------------------------------------------
drop trigger artist$insteadOfInsert
go

CREATE TRIGGER artist$insteadOfInsert ON artist
INSTEAD OF INSERT
AS
INSERT INTO artist(name, defaultFl, catalogNumberMask)
SELECT dbo.string$properCase(name), defaultfl, catalogNumberMask
FROM INSERTED
GO

CREATE TRIGGER artist$insteadOfUpdate on artist
INSTEAD OF UPDATE
AS
UPDATE artist
SET name = dbo.string$properCase(INSERTED.name), 
           defaultFl = INSERTED.defaultFl,
           catalogNumberMask = INSERTED.catalogNumberMask
FROM artist
JOIN INSERTED ON artist.artistId = INSERTED.artistId
GO

----------------------------

-- insert fairly obviously improperly formatted name
INSERT INTO artist (name, defaultFl, catalogNumberMask)
VALUES ('eLvIs CoStElLo',0,'77_______')

-- then retrieve the last inserted value into this table
SELECT artistId, name
FROM artist
WHERE artistId = ident_current('artist')

go

----------------------------

SELECT artistId, name 
FROM artist
go

UPDATE artist
SET name = UPPER(name)
go

SELECT artistId, name 
FROM artist
go

----------------------------------------------------------------------
--Uses of Instead-Of Triggers - Conditional Insert
----------------------------------------------------------------------
ALTER TABLE album
    DROP CONSTRAINT chkAlbum$catalogNumber$function$artist$catalogNumberValidate
go
----------------------------

CREATE TABLE albumException
(
   albumExceptionId int NOT NULL IDENTITY,
   name varchar(60) NOT NULL,
   artistId int NOT NULL,
   catalogNumber char(12) NOT NULL,
   exceptionAction char(1),
   exceptionDate datetime
)
go

----------------------------

CREATE TRIGGER album$insteadOfUpdate
ON album
INSTEAD OF UPDATE
AS 

DECLARE @errorValue int -- this is the variable for capturing error status

UPDATE album 
SET name = INSERTED.name, artistId = INSERTED.artistId,
           catalogNumber = INSERTED.catalogNumber
FROM inserted
JOIN album
   ON INSERTED.albumId = album.albumId
   -- only update rows where the criteria is met
   WHERE dbo.album$catalogNumbervalidate(INSERTED.catalogNumber,
           INSERTED.artistId) = 1

-- check to make certain that an error did not occur in this statement
SET @errorValue = @@error
IF @errorValue <> 0
BEGIN
   RAISERROR 50000 'Error inserting valid album records'
   ROLLBACK TRANSACTION
   RETURN
END

-- get all of the rows where the criteria is not met
INSERT INTO albumException (name, artistId, catalogNumber, exceptionAction, 
                            exceptionDate)
SELECT name, artistId, catalogNumber, 'U',getdate()
FROM INSERTED
WHERE NOT(      -- generally the easiest way to do this is to copy
                -- the criteria and do a not(where ...)
          dbo.album$catalogNumbervalidate(INSERTED.catalogNumber,
          INSERTED.artistId) = 1 )

SET @errorValue = @@error
IF @errorValue <> 0
BEGIN
   RAISERROR 50000 'Error logging exception album records'
   ROLLBACK TRANSACTION
   RETURN
END
GO

----------------------------

-- update the album table with a known good match to the catalog number
UPDATE album
SET catalogNumber = '222-22222-22'
WHERE name = 'the white album'

-- then list the artistId and catalogNumber of the album in the "real" table
SELECT artistId, catalogNumber
FROM album 
WHERE name = 'the white album'

-- as well as the exception table
SELECT artistId, catalogNumber, exceptionAction, exceptionDate 
FROM albumException 
WHERE name = 'the white album'
go

----------------------------

UPDATE album
SET catalogNumber = '1'
WHERE name = 'the white album'

-- then list the artistId and catalogNumber of the album in the "real" table
SELECT artistId, catalogNumber
FROM album 
WHERE name = 'the white album'

-- as well as the exception table
SELECT artistId, catalogNumber, exceptionAction, exceptionDate 
FROM albumException 
WHERE name = 'the white album'
go

----------------------------

-- create view, excluding the defaultFl column, which we don't want to let 
-- users see in this view, and we want to view the names in upper case.
CREATE VIEW vArtistExcludeDefault
AS
SELECT artistId, UPPER(name) AS name, catalogNumberMask 
FROM artist
GO

-- then we create a very simple INSTEAD OF insert trigger 

CREATE TRIGGER vArtistExcludeDefault$insteadOfInsert
ON vArtistExcludeDefault
INSTEAD OF INSERT
AS
BEGIN
   --note that we don't use the artistId from the INSERTED table
   INSERT INTO artist (name, catalogNumberMask, defaultFl)
   SELECT NAME, catalogNumberMask, 0 --only can set defaultFl to 0 
                                     --using the view
   FROM INSERTED
END
GO


----------------------------

INSERT INTO vArtistExcludeDefault (name, catalogNumberMask)
VALUES ('The Monkees','44_______')
go

----------------------------


INSERT INTO vArtistExcludeDefault (artistId, name, catalogNumberMask)
VALUES (-1, 'The Monkees','44_______')

SELECT * FROM vArtistExcludeDefault 
WHERE artistId = ident_current('vArtistExcludeDefault')
go

----------------------------------------------------------------------
--Optionally Cascading Deletes
----------------------------------------------------------------------

CREATE PROCEDURE account$delete
( 
    @accountId int,
    @removeChildTransactionsFl bit = 0
) as

-- if they asked to delete them, just delete them
IF @removeChildTransactionsFl = 1
   DELETE [transaction] --table named with keyword
   WHERE  accountId = @accountId
ELSE --check for existance
  BEGIN
      IF EXISTS (SELECT *
                 FROM  [transaction]
                 WHERE  accountId = @accountId)
        BEGIN
             RAISERROR 50000 'Child transactions exist'
             RETURN -100 
        END
  END

DELETE account
WHERE  accountID = @accountId
go




