--Note that the exact data that is returned from these queries will vary slightly from what is in 
--the text of the book.  The examples were not developed in the linear manner that the 
--examples may be executed in this script

-----------------------------------------------------------------------------------
--Transactions
-----------------------------------------------------------------------------------

BEGIN TRANSACTION --start a transaction

   -- insert two records
   INSERT INTO artist (name)
   VALUES ('mariah carey')
   INSERT INTO artist (name)
   VALUES ('britney spears')

   -- make sure that they are in the database
   SELECT artistId, name FROM artist
go

-----------------------------------

ROLLBACK TRANSACTION
SELECT artistId, name FROM artist
go

-----------------------------------

SELECT @@trancount AS zero
BEGIN TRANSACTION
   SELECT @@trancount AS one
   BEGIN TRANSACTION
      SELECT @@trancount AS two
      BEGIN TRANSACTION
      SELECT @@trancount AS three
      COMMIT TRANSACTION
   SELECT @@trancount AS two
   COMMIT TRANSACTION
SELECT @@trancount AS one
COMMIT TRANSACTION
SELECT @@trancount AS zero
go

-----------------------------------


SELECT @@trancount AS one
BEGIN TRANSACTION
   SELECT @@trancount AS two
   BEGIN TRANSACTION
      SELECT @@trancount AS three
      BEGIN TRANSACTION
         SELECT @@trancount AS four
         ROLLBACK TRANSACTION
         SELECT @@trancount AS zero
go

-----------------------------------

   BEGIN TRANSACTION --start a transaction

   --insert two records
   INSERT INTO artist (name)
   VALUES ('moody blues')

   SAVE TRANSACTION britney
   INSERT INTO artist (name)
   VALUES ('britney spears')

   --make sure that they are in the database
   SELECT artistId, name FROM artist
go

-----------------------------------

ROLLBACK TRANSACTION britney

COMMIT TRANSACTION

SELECT artistId, name FROM artist
GO

-----------------------------------------------------------------------------------
--Isolation Levels
-----------------------------------------------------------------------------------
CREATE TABLE testIsolationLevel
(
   testIsolationLevelId INT IDENTITY,
   value varchar(10)
)

INSERT INTO dbo.testIsolationLevel(value)
VALUES ('Value1')
INSERT INTO dbo.testIsolationLevel(value)
VALUES ('Value2')
go

-----------------------------------

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

--set for illustrative purposes only. If we do not set this on a connection 
--it will be in read committed mode anyway because this is the default.

BEGIN TRANSACTION
SELECT * FROM dbo.testIsolationLevel
go

-----------------------------------

--***************************************************************
--open a different connection to execute this code
--***************************************************************
/*
DELETE FROM dbo.testIsolationLevel 
WHERE testIsolationLevelId = 1
*/

-----------------------------------

SELECT * FROM dbo.testIsolationLevel

COMMIT TRANSACTION
go

-----------------------------------

--not in text.  This code will reset our example
--clean out and reload the tables
truncate table testIsolationLevel
INSERT INTO dbo.testIsolationLevel(value)
VALUES ('Value1')
INSERT INTO dbo.testIsolationLevel(value)
VALUES ('Value2')
go

-----------------------------------

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

BEGIN TRANSACTION
SELECT * FROM dbo.testIsolationLevel
go

--***************************************************************
--open a different connection to execute this code
--***************************************************************
/*
DELETE FROM dbo.testIsolationLevel 
WHERE testIsolationLevelId = 1
*/

-----------------------------------

SELECT * FROM dbo.testIsolationLevel

COMMIT TRANSACTION
go

-----------------------------------

--not in text.  This code will reset our example
--clean out and reload the tables
truncate table testIsolationLevel
INSERT INTO dbo.testIsolationLevel(value)
VALUES ('Value1')
INSERT INTO dbo.testIsolationLevel(value)
VALUES ('Value2')
go

-----------------------------------

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

BEGIN TRANSACTION
SELECT * FROM dbo.testIsolationLevel
go

--***************************************************************
--open a different connection to execute this code
--***************************************************************
/*
INSERT INTO dbo.testIsolationLevel(value)
VALUES ('Value3')
*/

SELECT * FROM dbo.testIsolationLevel

COMMIT TRANSACTION
go

-----------------------------------------------------------------------------------
--Temporary tables
-----------------------------------------------------------------------------------

--create the table to hold the names of the objects
CREATE TABLE #counting
(
   specific_name sysname
)

--insert all of the rows that have between 2 and 3 parameters
INSERT INTO #counting (specific_name)
SELECT specific_name
FROM information_schema.parameters as parameters
GROUP BY specific_name
HAVING COUNT(*) between 2 and 3

--count the number of values in the table
SELECT COUNT(*)
FROM #counting

DROP TABLE #counting
go


-----------------------------------

SELECT count(*)
FROM (SELECT specific_name
   FROM information_schema.parameters AS parameters
   GROUP BY specific_name
   HAVING count(*) between 2 and 3 ) AS TwoParms
go

-----------------------------------
--recursive table example

--first we create the type table
CREATE TABLE type
(
   typeId int,                 --not identity because we need to reference 
                               --it in this test script
   parentTypeId int NULL,
   name varchar(60) NOT NULL, 
)

--then we have to populate the type table
INSERT INTO type (typeId, parentTypeId, name)
VALUES (1, NULL, 'Top')
INSERT INTO type (typeId, parentTypeId, name)
VALUES (2,1, 'TopChild1')
INSERT INTO type (typeId, parentTypeId, name)
VALUES (3,1, 'TopChild2')
INSERT INTO type (typeId, parentTypeId, name)
VALUES (4,2, 'TopChild1Child1')
INSERT INTO type (typeId, parentTypeId, name)
VALUES (5,2, 'TopChild1Child2')
go

-----------------------------------
CREATE TABLE #holdItems
(
   typeId int NOT NULL,        --pkey of type table
   parentTypeID int NULL,      --recursive attribute
   name varchar(100),          --name of the type
   indentLevel int,            --level of the tree for indenting display
   sortOrder varchar(1000)     --sort order for final display
)
go
-----------------------------------

--get the toplevel items
INSERT INTO #holdItems

-- First pass will start at indentLevel 1. We put the parent primary key into
-- the sortOrder, padded with zeroes to the right, then we will append each
-- level of child to each sublevel
SELECT typeId, parentTypeID, name, 1 AS indentLevel, 
       LTRIM(replicate('0',10 - LEN(CAST(typeId AS char(10)))) + 
       CAST(typeId AS char(10))) AS sortOrder
FROM dbo.type
WHERE parentTypeID IS NULL           --parent is NULL means top node
go


-----------------------------------

DECLARE @currLevel int
SET @currLevel = 2

WHILE 1=1                        -- since there is no repeat until in T-SQL
   BEGIN

      INSERT INTO #holdItems

      -- add the sort order of this item to current sort order
      -- of the parent's sort order
      SELECT type.TypeId, type.parentTypeID, type.name, 
             @currLevel AS indentLevel, 
             RTRIM(#holdItems.sortOrder) + 
             LTRIM(replicate('0',10 - LEN(CAST(type.typeId AS char(10)))) + 
             CAST(type.typeId as char(10)))
      FROM dbo.type AS type

      -- this join gets us the child records of the items in the 
      -- #holdItemsTable
      JOIN #holdItems 
         ON Type.parentTypeId = #holdItems.typeId

         -- currlevel tells us the level we are adding, so we need the parent 
         -- in the @join 
         WHERE #holdItems.indentLevel = @currLevel - 1

      -- if there are no children on the new level, we break
      IF @@rowcount = 0
         BREAK

      -- otherwise we simply increment the counter and move on.
      SET @currLevel = @currLevel + 1
   END

-----------------------------------

SELECT typeId, parentTypeId, CAST(name AS varchar(15)) AS name, indentLevel
FROM #holdItems
ORDER BY sortorder, parentTypeID 

-- drop table is not explicitly required if in a stored procedure or if
-- we disconnect between executions
DROP TABLE #holdItems


-----------------------------------------------------------------------------------
--cursors
-----------------------------------------------------------------------------------

SELECT getdate()              -- get time before the code is run 

--temporary table to hold the procedures as we loop through
CREATE TABLE #holdProcedures
(
   specific_name sysname
)

DECLARE @cursor CURSOR,       --cursor variable
        @c_routineName sysname    -- variable to hold the values as we loop 

SET @cursor = CURSOR FAST_FORWARD FOR SELECT DISTINCT specific_name
				     FROM information_schema.parameters 

OPEN @cursor                  --activate the cursor
FETCH NEXT FROM @cursor INTO @c_routineName  --get the first row

WHILE @@fetch_status = 0      --this means that the row was fetched cleanly
   BEGIN
      --check to see if the count of parameters for this specific name
      --is between 2 and 3
      IF ( SELECT count(*)
           FROM information_schema.parameters as parameters
           WHERE parameters.specific_name = @c_routineName ) 
              BETWEEN 2 AND 3
         BEGIN                --it was, so put into temp storage
            INSERT INTO #holdProcedures
            VALUES (@c_routineName)
         END

      FETCH NEXT FROM @cursor INTO @c_routineName   --get the next row
   END

SELECT count(*)
FROM #holdProcedures

SELECT getdate() --output the time after the code is complete
go


-----------------------------------

SELECT GETDATE()    --again for demo purposes

SELECT COUNT(*)
--use a nested subquery to get all of the functions with
--the proper count of parameters
FROM (SELECT parameters.specific_name
      FROM information_schema.parameters AS parameters
      GROUP BY parameters.specific_name
      HAVING COUNT(*) BETWEEN 2 AND 3) AS counts

SELECT GETDATE()

-----------------------------------------------------------------------------------
--uses of cursors
-----------------------------------------------------------------------------------

--not in text, but there was already an item table
DROP TABLE item
go
-- table to demonstrate cursors
CREATE TABLE item
(
   itemId int IDENTITY
   CONSTRAINT XPKItem PRIMARY KEY, 
   sortOrderId int 
   CONSTRAINT xAKItem_sortOrder UNIQUE 
)
-----------------------------------

DECLARE @holdSortOrderId int, @counter int
SET @counter = 1                           --initialize counter

WHILE @counter <= 5
   BEGIN
      --use random numbers between 0 and 1000
      SET @holdSortOrderId = CAST(RAND() * 1000 AS int)

      --make sure the random number doesn't already exist as 
      --a sort order
      IF NOT EXISTS (SELECT * 
                     FROM dbo.item 
                     WHERE sortOrderId = @holdSortOrderId)
      BEGIN
         --insert it 
         INSERT INTO dbo.item (sortOrderId)
         VALUES (@holdSortOrderId)

         --increment the counter
         SET @counter = @counter + 1
      END
   END

-----------------------------------

SELECT * 
FROM dbo.item 
ORDER BY sortOrderId
go
-----------------------------------

DECLARE @cursor CURSOR,                    --cursor variable
        @c_itemId int, @c_sortOrderId int, --cursor item variables
        @currentSortOrderId int            --used to increment the sort order
SET @currentSortOrderId = 1                --initialize the counter

--use static cursor so we do not see changed values
SET @cursor = CURSOR FORWARD_ONLY STATIC FOR SELECT itemId, sortOrderId
        FROM dbo.item
        ORDER BY sortOrderId
OPEN @cursor                               --activate the cursor

--get the first row
FETCH NEXT FROM @cursor INTO @c_itemId, @c_sortOrderId 

--fetch_status = 0 says that the fetch went fine
WHILE @@fetch_status = 0     --this means that the row was fetched cleanly
   BEGIN
      --update the table to the new value of the sort order
      UPDATE dbo.item
      SET sortOrderId = @currentSortOrderId
      WHERE itemId = @c_itemId

      --increment the sort order counter to add 100 items of space
      SET @currentSortOrderId = @currentSortOrderId + 100

      --left out of text
      SELECT @c_itemId as c_itemId, @c_sortOrderId as c_sortOrderId, @currentsortOrderId as currentsortOrderId

      --get the next row
      FETCH NEXT FROM @cursor INTO @c_itemId, @c_sortOrderId 
   END

go

-----------------------------------

SELECT * 
FROM dbo.item 
ORDER BY sortOrderId
go

-----------------------------------------------------------------------------------
--Nulls
-----------------------------------------------------------------------------------

SELECT CASE WHEN NOT(1=NULL) THEN 'True' ELSE 'False' END
go

-----------------------------------

SELECT CASE WHEN NOT(NOT(1=NULL)) THEN 'True' ELSE 'False' END
go

-----------------------------------

SELECT CASE WHEN (NOT((1=1) OR (1=NULL)) AND (1=1)) 
            THEN 'True' 
            ELSE 'False' 
       END 
go

declare @field varchar(20)
set @field = null

SELECT '*' + @field + '*'

SELECT CASE @field
   WHEN NULL THEN ''
   ELSE @field
END

SELECT ISNULL(@field,'')

SELECT COALESCE(@field,'')

go

-----------------------------------------------------------------------------------
--Views as encapsulation devices
-----------------------------------------------------------------------------------

--yes, again there already is an item table
drop table item
go
--items that we sell 
CREATE TABLE item
(
   itemId int NOT NULL IDENTITY,
   name varchar(60) NOT NULL,
   price money
)

--records sales
CREATE TABLE sale
(
   saleId int NOT NULL IDENTITY,
   itemId int NOT NULL,         --foreign key to the item table
   date datetime NOT NULL,
   itemCount int NOT NULL       --number of items sold
)
go

-----------------------------------

CREATE VIEW v_sale
AS 
SELECT sale.saleId, sale.itemId, sale.date, sale.itemCount, 
       item.name, item.price
FROM dbo.sale AS sale
JOIN dbo.item AS item
   ON sale.itemId = item.itemId
go

-----------------------------------------------------------------------------------
--Views in Real-Time Reporting
-----------------------------------------------------------------------------------

CREATE VIEW v_saleHourlyReport
AS 
SELECT item.itemId, dbo.date$removeTime(sale.date) AS saleDate, 
       datePart(hour,sale.date) AS saleHour, 
       sum(sale.itemCount) AS totalSold,
       sum(sale.itemCount * item.price) AS soldValue
FROM dbo.item as item (readuncommitted) 
JOIN dbo.sale as sale(readuncommitted)
   ON sale.itemId = item.itemId
--group by item ID information, then the day and the hour of the day, to 
--give what was asked
GROUP BY item.itemId, item.name, dbo.date$removeTime(sale.date), 
         datePart(hour,sale.date)


-----------------------------------------------------------------------------------
--Views as security mechanisms
-----------------------------------------------------------------------------------

CREATE TABLE person
(
   personId int IDENTITY,
   firstName varchar(20) ,
   lastName varchar(40)
)
go

-----------------------------------

CREATE VIEW vPerson
AS
SELECT personId, firstName, lastName
FROM dbo.person
go

-----------------------------------

CREATE VIEW v_saleHourlyReport_socksOnly
AS 
SELECT itemId, saleDate, saleHour, totalSold, soldValue
FROM dbo.v_saleHourlyReport
WHERE itemId = 1 
go


-----------------------------------------------------------------------------------
--Indexed Views
-----------------------------------------------------------------------------------

CREATE VIEW v_itemSale
WITH SCHEMABINDING 
AS

SELECT 	item.itemId, item.name, sum(sale.itemCount) AS soldCount,
	sum(sale.itemCount * item.price) AS soldValue
FROM 	dbo.item
	  JOIN dbo.sale
		ON item.itemId = sale.itemId
GROUP 	BY item.itemId, item.name
GO

-----------------------------------

--NOTE: This index cannot be created without the Enterprise Edition
CREATE INDEX XV_itemSale_materialize 
ON v_itemSale (itemId, name, soldCount, soldValue)


-----------------------------------

CREATE VIEW v_itemNoPrice
AS
SELECT itemId, name 
FROM dbo.item
go


-----------------------------------------------------------------------------------
--DISTRIBUTED PARTITIONED VIEWS
-----------------------------------------------------------------------------------

CREATE TABLE sale_itemA
(
   saleId int NOT NULL,
   itemId int NOT NULL 
   CONSTRAINT chk$sale_itemA$itemId$One CHECK (itemId = 1),
   itemCount int NOT NULL,
)
CREATE TABLE sale_itemB
(
   saleId int NOT NULL,
   itemId int NOT NULL 
   CONSTRAINT chk$sale_itemB$itemId$One CHECK (itemId = 2),
   itemCount int NOT NULL
)
go

-----------------------------------
CREATE VIEW v_sale
AS 
SELECT saleId, itemId, itemCount 
FROM dbo.sale_itemA

UNION ALL -- no sort or duplicate removal 

SELECT saleId, itemId, itemCount 
FROM dbo.sale_itemB
go

-----------------------------------------------------------------------------------
--Stored Procedure Return Values
-----------------------------------------------------------------------------------

CREATE PROCEDURE returnValue$test
(
     @returnThis int = 0
)
AS
RETURN @returnThis 
go
-----------------------------------

DECLARE @returnValue int
EXEC @returnValue = returnValue$test @returnThis = 0
SELECT @returnValue AS returnValue
go

-----------------------------------

CREATE PROCEDURE caller$testreturnvalue
(
    @testValue int
)
AS

DECLARE @returnValue int
EXEC @returnValue = returnValue$test @testValue
SELECT @returnValue AS returnValue

IF @returnValue < 0 --negative is bad
   BEGIN
      SELECT 'An error has occurred: ' + CAST(@returnValue AS varchar(10))
                      AS status
   END
ELSE                -- positive or zero is good
   BEGIN
      SELECT 'Call succeeded: ' + CAST(@returnValue AS varchar(10))  
                      AS status
   END
GO

-----------------------------------

EXEC caller$testreturnvalue -10
go

-----------------------------------------------------------------------------------
-- Result Sets
-----------------------------------------------------------------------------------

CREATE PROCEDURE test$statement
AS

SELECT 'Hi' AS hiThere
SELECT 'Bye' AS byeThere
GO
-----------------------------------

EXEC test$statement
go
-----------------------------------------------------------------------------------
--Error Handling
-----------------------------------------------------------------------------------

EXEC dbo.doesntExist
go

-----------------------------------

SELECT error, description 
FROM master.dbo.sysmessages 
WHERE error = 2812
go

-----------------------------------

RAISERROR 911911911 'This is a test message' 
go

-----------------------------------

CREATE PROCEDURE test$validateParm
(
   @parmValue int 
) AS 

IF @parmValue < 0
   BEGIN
      DECLARE @msg varchar(100)
      SET @msg = 'Invalid @parmValue: ' + CAST(@parmValue AS varchar(10)) +
                 '. Value must be non-negative.' 
      RAISERROR 50000 @msg
      RETURN -100
   END
SELECT 'Test successful.'
RETURN 0
GO

----------------------------------------

exec dbo.test$validateParm 0
exec dbo.test$validateParm -1
go


-----------------------------------
--not in text
drop table test
go

CREATE TABLE test
(
   testId int IDENTITY,
   name varchar(60) NOT NULL
   CONSTRAINT AKtest_name UNIQUE 
)

go
-----------------------------------

CREATE PROCEDURE test$ins
(
   @name varchar(60)
) AS

INSERT INTO dbo.test(name)
VALUES(@name)
IF @@error <> 0
   BEGIN
      -- raise an error that tells the user what has just occurred.
      RAISERROR 50000 'Error inserting into test table'
   END
GO

-----------------------------------

EXEC dbo.test$ins @name = NULL



-----------------------------------------------------------------------------------
-- Constraint Mapping
-----------------------------------------------------------------------------------

ALTER TABLE dbo.test
ADD CONSTRAINT chkTest$name$string$notEqualToBob
CHECK (name <> 'Bob')
go

-----------------------------------

INSERT INTO dbo.test (name)
VALUES ('Bob')
go

-----------------------------------

EXEC sp_addextendedproperty @name = 'ErrorMessage', 
     @value = 
           'The name column may not store a value of ''Bob''',
     @level0type = 'User', @level0name = 'dbo', 
     @level1type = 'table', @level1name = 'test',
     @level2type = 'constraint', @level2name = 
           'chkTest$name$string$notEqualToBob'
go

-----------------------------------

SELECT value AS message
FROM ::FN_LISTEXTENDEDPROPERTY('ErrorMessage', 'User', 'dbo', 'table', 'test',
             'constraint', 'chkTest$name$string$notEqualToBob')
go


-----------------------------------------------------------------------------------
--Tagging Error Messages
-----------------------------------------------------------------------------------

CREATE PROCEDURE test$errorMessage
(
    @key_testId int
)  AS

--declare variable used for error handling in blocks
DECLARE @error int,            --used to hold error value
        @msg varchar(255),     --used to preformat error messages
        @msgtag varchar(255)   --used to hold the tags for the error message 

--set up the error message tag
SET @msgTag = '<' + object_name(@@procid) + ';type=P'
                  + ';keyvalue=' + '@key_routineId:' 
                  + CONVERT(varchar(10),@key_testId) 

--call to some stored procedure or modification statement on some table

--get the rowcount and error level for the error handling code
SELECT  @error = 100            --simulated error

IF @error != 0                  --an error occurred outside this procedure
   BEGIN
      SELECT @msg = 'A problem occurred calling the nonExistentProcedure. ' +
                     @msgTag + ';call=(procedure nonExistentProcedure)>'
      RAISERROR 50000 @msg
      RETURN -100
   END

GO
-----------------------------------

test$errorMessage @key_testId = 10
go


-----------------------------------------------------------------------------------
-- Constraint Mapping
-----------------------------------------------------------------------------------

CREATE PROCEDURE tranTest$inner
AS
BEGIN TRANSACTION

--code finds an error, decides to rollback
ROLLBACK TRANSACTION
RETURN -100
go

CREATE PROCEDURE tranTest$outer
AS
DECLARE @retValue int
BEGIN TRANSACTION

EXEC @retValue = tranTest$inner
IF @retValue < 0
   BEGIN
     ROLLBACK TRANSACTION
     RETURN @retValue
   END
COMMIT TRANSACTION
go


-----------------------------------

EXEC tranTest$outer

-----------------------------------

--changed to alter
ALTER PROCEDURE tranTest$inner
AS
DECLARE @tranPoint sysname                 --the data type of identifiers
SET @tranPoint = object_name(@@procId) + CAST(@@nestlevel AS varchar(10))

BEGIN TRANSACTION
SAVE TRANSACTION @tranPoint

--again doesn't do anything for simplicity
ROLLBACK TRANSACTION @tranPoint
COMMIT TRANSACTION
RETURN -100
GO

--changed to alter
ALTER PROCEDURE tranTest$outer
AS
DECLARE @retValue int
DECLARE @tranPoint sysname                 --the data type of identifiers
SET @tranPoint = object_name(@@procId) + CAST(@@nestlevel AS varchar(10))

BEGIN TRANSACTION
SAVE TRANSACTION @tranPoint

EXEC @retValue = tranTest$inner
IF @retValue < 0
   BEGIN
      ROLLBACK TRANSACTION @tranPoint
      COMMIT TRANSACTION
      RETURN @retvalue
   END
COMMIT TRANSACTION
GO
-----------------------------------

EXEC tranTest$outer

-----------------------------------------------------------------------------------
-- Common Practices with Stored Procedures
-----------------------------------------------------------------------------------

CREATE TABLE routine
(
   routineId int NOT NULL IDENTITY CONSTRAINT PKroutine PRIMARY KEY,
   name varchar(384) NOT NULL CONSTRAINT akroutine_name UNIQUE,
   description varchar(100) NOT NULL,
   timestamp timestamp
)

-----------------------------------

--database name changed to master.  
INSERT INTO routine (name, description)
SELECT specific_catalog + '.' + specific_schema + '.' + specific_name, 
   routine_type + ' in the ' + specific_catalog + ' database created on ' + 
   CAST(created AS varchar(20))
FROM master.information_schema.routines

SELECT count(*) FROM routine

-----------------------------------------------------------------------------------
-- Retrieve
-----------------------------------------------------------------------------------

CREATE PROCEDURE routine$list
(
   @routineId int = NULL,          --primary key to retrieve single row
   @name varchar(60) = '%',        --like match on routine.name
   @description varchar(100) = '%' --like match on routine.description
)

-- Description : gets routine records for displaying in a list
--             : 
-- Return Val  : nonnegative:  success
--             : -1 to -99:  system generated return value on error
--             : -100:  generic procedure failure

AS

-- as the count messages have been known to be a problem for clients
SET NOCOUNT ON

-- default the @name parm to '%' if the passed value is NULL
IF @name IS NULL SELECT @name = '%'

-- default the @description parm to '%' if the passed value is NULL
IF @description IS NULL SELECT @description = '%'

--s elect all of the fields (less the timestamp) from the table for viewing. 
SELECT routine.routineId AS routineId, routine.name AS name,
       routine.description AS description
FROM dbo.routine AS routine
WHERE (routine.routineId = @routineId 
      OR @routineId IS NULL)
      AND (routine.name LIKE @name)
      AND (routine.description LIKE @description)
ORDER BY routine.name
RETURN
go

--------------------------------------------------------

SET STATISTICS IO ON
DBCC freeproccache    --clear cache to allow it to choose best plan

SELECT GETDATE() AS before

--run the procedure version
EXEC routine$list @routineId = 848

SELECT GETDATE() AS middle

--then run it again as an ad-hoc query
SELECT routine.routineId AS routineId, routine.name AS name,
       routine.description AS description
FROM dbo.routine AS routine
WHERE (routine.routineId = 848 OR 848 IS NULL)
      AND (routine.name LIKE '%')
      AND (routine.description LIKE '%')
ORDER BY routine.name

SELECT GETDATE() AS after

---------------------------------------------------

SET STATISTICS IO ON
DBCC freeproccache      --clear cache to allow it to choose best plan

SELECT GETDATE() AS before

EXEC routine$list @description = 'procedure in the master named sp_helpsql%'

SELECT GETDATE() AS middle

SELECT routine.routineId AS routineId, routine.name AS name,
       routine.description AS description
FROM dbo.routine AS routine
WHERE (routine.routineId = NULL OR NULL IS NULL)
  AND (routine.name LIKE '%')
  AND (routine.description LIKE 'procedure in the master named sp_helpsql%')
ORDER BY routine.name

SELECT GETDATE() AS after


---------------------------------------------------

--changed to alter because we are replacing the previous version
alter PROCEDURE routine$list
(
   @routineId int = NULL,          -- primary key to retrieve single row
   @name varchar(60) = '%',        -- like match on routine.name
   @description varchar(100) = '%' -- like match on routine.description
) AS

--as the count messages have been known to be a problem for clients
SET NOCOUNT ON

-- create a variable to hold the main query
DECLARE @query varchar(8000)
-- select all of the fields from the table for viewing
SET @query = 'SELECT routine.routineId AS routineId, routine.name AS name,
                     routine.description AS description
              FROM dbo.routine AS routine'

-- create a variable to hold the where clause, which we will conditionally
-- build
DECLARE @where varchar(8000) SET @where = '' --since NULL + 'anything' = NULL

-- add the name search to the where clause
IF @name <> '%' AND @name IS NOT NULL
   SELECT @where = @where + CASE WHEN LEN(RTRIM(@where)) > 0 
   THEN ' AND ' ELSE '' END + ' name LIKE ''' + @name + ''''

-- add the name search to the where clause
IF @description <> '%' AND @description IS NOT NULL
   SELECT @where = @where + CASE WHEN LEN(RTRIM(@where)) > 0 
   THEN ' AND ' ELSE '' END + ' name LIKE ''' + @description + ''''

-- select all of the fields from the table for viewing
IF @routineId IS NOT NULL 
   SELECT @where = @where + CASE WHEN LEN(RTRIM(@where)) > 0 
   THEN ' AND ' ELSE '' END + 
   ' routineId = ' + CAST(@routineId AS varchar(10))

-- create a variable for the where clause
DECLARE @orderBy varchar(8000)
-- set the order by to return rows by name
SET   @orderBy = ' ORDER BY routine.name'

EXEC (@query + @where + @orderBy)
GO


-----------------------------------------------------------------------------------
-- Create
-----------------------------------------------------------------------------------

CREATE PROCEDURE routine$ins
(
   @name varchar(384),
   @description varchar(500),
   @new_routineId int = NULL OUTPUT
) AS

-- declare variable used for error handling in blocks
DECLARE @rowcount int,      -- holds the rowcount returned from dml calls
   @error int,              -- used to hold the error code after a dml 
   @msg varchar(255),       -- used to preformat error messages
   @retval int,             -- general purpose variable for retrieving 
                            -- return values from stored procedure calls
   @tranName sysname,       -- used to hold the name of the transaction
   @msgTag varchar(255)     -- used to hold the tags for the error message 

-- set up the error message tag
SET @msgTag = '<' + object_name(@@procid) + ';type=P'

-- default error handling code used for most procedures
-- generic tran name generation guarantees unique transaction name, 
-- even if the procedure is called twice in a chain, since if one is active
-- and another gets called it cannot be at the same nest level
SET @tranName = object_name(@@procid) + CAST(@@nestlevel AS varchar(2))


-- note that including this transaction is not actually necessary as we only
-- have a single statement. I like to include this just as a precaution for
-- when the need arises to change the code.

BEGIN TRANSACTION          -- start a transaction
SAVE TRANSACTION @tranName -- save tran so we can rollback our action without 
                           -- killing entire transaction

-- perform the insert
INSERT INTO routine(name,description)
VALUES (@name,@description)

-- check for an error
IF (@@ERROR!=0)
   BEGIN
   -- raise an additional error to help us see where the error occurred
   SELECT @msg = 'There was a problem inserting a new row into the ' + 
      'routine table.'  + @msgTag + ';call=(insert routine)>'
   RAISERROR 50000 @msg
   ROLLBACK TRAN @tranName
   COMMIT TRAN
   RETURN -100
END

-- then retrieve the identity value from the row we created error
SET @new_routineId = scope_identity()

COMMIT TRANSACTION
GO

-----------------------------------

BEGIN TRANSACTION -- wrap test code in a transaction so we don't affect db
DECLARE @new_routineId int
EXEC routine$ins @name = 'Test', 
   @description = 'Test', @new_routineId = @new_routineId OUTPUT
-- see what errors occur
SELECT NAME, DESCRIPTION FROM routine WHERE routineId = @new_routineId

-- to cause duplication error

EXEC routine$ins @name = 'Test', 
   @description = 'Test', @new_routineId = @new_routineId OUTPUT

ROLLBACK TRANSACTION -- no changes to db

-----------------------------------------------------------------------------------
-- Modify
-----------------------------------------------------------------------------------

CREATE PROCEDURE routine$upd
(
   @key_routineId int, -- key column that we will use as the key to the
                       -- update. Note that we cannot update the primary key
   @name varchar(384) ,
   @description varchar(500),
   @ts_timeStamp timestamp  --optimistic lock 
)
AS

-- declare variable used for error handling in blocks
DECLARE @rowcount int,     -- holds the rowcount returned from dml calls
        @error int,        -- used to hold the error code after a dml 
        @msg varchar(255), -- used to preformat error messages
        @retval int,       -- general purpose variable for retrieving 
                           -- return values from stored procedure calls
        @tranname sysname, -- used to hold the name of the transaction
        @msgTag varchar(255) -- used to hold the tags for the error message 

-- set up the error message tag

SET @msgTag = '<' + object_name(@@procid) + ';type=P'
                  + ';keyvalue=' + '@key_routineId:' 
                  + CONVERT(varchar(10),@key_routineId) 

SET @tranName = object_name(@@procid) + CAST(@@nestlevel AS varchar(2))

-- make sure that the user has passed in a timestamp value, as it will
-- be very wasteful if they have not
IF @ts_timeStamp IS NULL
   BEGIN
   SET @msg = 'The timestamp value must not be NULL' + @msgTag + '>'
   RAISERROR 50000 @msg
   RETURN -100
END

BEGIN TRANSACTION
SAVE TRANSACTION @tranName 

UPDATE routine
SET NAME = @name, description = @description 
WHERE routineId = @key_routineId AND timeStamp = @ts_timeStamp

-- get the rowcount and error level for the error handling code
SELECT @rowcount = @@rowcount, @error = @@error

IF @error != 0  --an error occurred outside of this procedure
   BEGIN
      SELECT @msg = 'A problem occurred modifying the routine record.'  + 
         @msgTag + ';call=(UPDATE routine)>'
      RAISERROR 50001 @msg
      ROLLBACK TRAN @tranName 
      COMMIT TRAN
      RETURN -100
   END
ELSE IF @rowcount <> 1  -- this must not be the primary key 
                        -- anymore or the record doesn't exist
   BEGIN
      IF (@rowcount = 0) 
         BEGIN
            -- if the record exists without the timestamp,
            -- it has been modified by another user
            IF EXISTS ( SELECT *
               FROM routine
                  WHERE routineId = @key_routineId)
                  BEGIN
                     SELECT @msg = 'The routine record has been modified' + 
                                   ' by another user.'
                  END
            ELSE
                  BEGIN
                     SELECT @msg = 'The routine record does not exist.'
                  END
           END
      ELSE
         BEGIN
            SELECT @msg = 'Too many records were modified.'
         END

         SELECT  @msg = @msg + @msgTag + ';CALL=(UPDATE routine)>'
         RAISERROR 50000 @msg
         ROLLBACK TRAN @tranName 
         COMMIT TRAN
         RETURN -100

   END

COMMIT TRAN
RETURN 0
go

--*********************************************
--Change to update applied
--*********************************************

ALTER PROCEDURE routine$upd
(
   @key_routineId int, -- key column that we will use as the key to the
                       -- update. Note that we cannot update the primary key
   @name varchar(384) ,
   @description varchar(500),
   @ts_timeStamp timestamp  --optimistic lock 
)
AS

-- declare variable used for error handling in blocks
DECLARE @rowcount int,     -- holds the rowcount returned from dml calls
        @error int,        -- used to hold the error code after a dml 
        @msg varchar(255), -- used to preformat error messages
        @retval int,       -- general purpose variable for retrieving 
                           -- return values from stored procedure calls
        @tranname sysname, -- used to hold the name of the transaction
        @msgTag varchar(255) -- used to hold the tags for the error message 

-- set up the error message tag

SET @msgTag = '<' + object_name(@@procid) + ';type=P'
                  + ';keyvalue=' + '@key_routineId:' 
                  + CONVERT(varchar(10),@key_routineId) 

SET @tranName = object_name(@@procid) + CAST(@@nestlevel AS varchar(2))

-- make sure that the user has passed in a timestamp value, as it will
-- be very wasteful if they have not
IF @ts_timeStamp IS NULL
   BEGIN
   SET @msg = 'The timestamp value must not be NULL' + @msgTag + '>'
   RAISERROR 50000 @msg
   RETURN -100
END

BEGIN TRANSACTION
SAVE TRANSACTION @tranName 

--**************************************

-- leave the timestamp out of this statement, as we do not want 
-- to update the description field because the timestamp has changed
IF EXISTS (SELECT * FROM routine WHERE routineId = @key_routineId
             AND description = @description)
   BEGIN
      UPDATE routine
      SET name = @name WHERE routineId = @key_routineId
         AND timeStamp = @ts_timeStamp

      -- get the rowcount and error level for the error handling code
      SELECT @rowcount = @@rowcount, @error = @@error
   END
ELSE
   BEGIN
      UPDATE routine
      SET name = @name, description = @description WHERE routineId = 
                 @key_routineId
      AND timeStamp = @ts_timeStamp

      -- get the rowcount and error level for the error handling code
      SELECT @rowcount = @@rowcount, @error = @@error
   END

--**************************************


-- get the rowcount and error level for the error handling code
SELECT @rowcount = @@rowcount, @error = @@error

IF @error != 0  --an error occurred outside of this procedure
   BEGIN
      SELECT @msg = 'A problem occurred modifying the routine record.'  + 
         @msgTag + ';call=(UPDATE routine)>'
      RAISERROR 50001 @msg
      ROLLBACK TRAN @tranName 
      COMMIT TRAN
      RETURN -100
   END
ELSE IF @rowcount <> 1  -- this must not be the primary key 
                        -- anymore or the record doesn't exist
   BEGIN
      IF (@rowcount = 0) 
         BEGIN
            -- if the record exists without the timestamp,
            -- it has been modified by another user
            IF EXISTS ( SELECT *
               FROM routine
                  WHERE routineId = @key_routineId)
                  BEGIN
                     SELECT @msg = 'The routine record has been modified' + 
                                   ' by another user.'
                  END
            ELSE
                  BEGIN
                     SELECT @msg = 'The routine record does not exist.'
                  END
           END
      ELSE
         BEGIN
            SELECT @msg = 'Too many records were modified.'
         END

         SELECT  @msg = @msg + @msgTag + ';CALL=(UPDATE routine)>'
         RAISERROR 50000 @msg
         ROLLBACK TRAN @tranName 
         COMMIT TRAN
         RETURN -100

   END

COMMIT TRAN
RETURN 0
go


-----------------------------------------------------------------------------------
-- Destroy
-----------------------------------------------------------------------------------

CREATE PROCEDURE routine$del
(
   @key_routineId int,
   @ts_timeStamp timestamp = NULL  --optimistic lock
)
AS

-- declare variable used for error handling in blocks
DECLARE @rowcount int,         -- holds the rowcount returned from dml calls
        @error int,            -- used to hold the error code after a dml 
        @msg varchar(255),     -- used to preformat error messages
        @retval int,           -- general purpose variable for retrieving 
                               -- return values from stored procedure calls
        @tranname sysname,     -- used to hold the name of the transaction
        @msgTag varchar(255)   -- used to hold the tags for the error message 

-- set up the error message tag
SET @msgTag = '<' + object_name(@@procid) + ';type=P'
                  + ';keyvalue=' + '@key_routineId:' 
                  + CONVERT(varchar(10),@key_routineId) 

SET @tranName = object_name(@@procid) + CAST(@@nestlevel AS varchar(2))

BEGIN TRANSACTION
SAVE TRANSACTION @tranName

DELETE routine WHERE routineId = @key_routineId AND @ts_timeStamp = timeStamp

-- get the rowcount and error level for the error handling code
SELECT @rowcount = @@rowcount, @error = @@error

IF @error != 0  -- an error occurred outside of this procedure
   BEGIN
      SELECT @msg = 'A problem occurred removing the routine record.'  + 
      @msgTag + 'call=(delete routine)>'
      RAISERROR 50000 @msg
      ROLLBACK TRAN @tranName
      COMMIT tran
      RETURN -100
   END
ELSE IF @rowcount > 1  -- this must not be the primary key anymore or the 
                       -- record doesn't exist
   BEGIN
      SELECT   @msg = 'Too many routine records were deleted. ' + 
      @msgTag + '; call=(DELETE routine)>'

      RAISERROR 50000 @msg
      ROLLBACK TRAN @tranName
      COMMIT tran
      RETURN -100

   END
ELSE IF @rowcount = 0 
   BEGIN
      IF EXISTS (SELECT * FROM routine WHERE routineId = @key_routineId )
         BEGIN
            SELECT @msg = 'The routine record has been modified' + 
                          ' by another user.' + ';call=(delete routine)>'
            RAISERROR 50000 @msg
            ROLLBACK TRAN @tranName
            COMMIT TRAN
            RETURN -100

         END
      ELSE
         BEGIN
            SELECT @msg = 'The routine record you tried to delete' + 
                      ' does not exist.' + @msgTag + ';call=(delete routine)>'
                      raiserror 50000 @msg
                 -- the needs of the system should decide whether or
                 -- not to actually implement this error, or even if
                 -- if we should quit here and return a negative value. 
                 -- If you were trying to remove something
                 -- and it doesn't exist, is that bad?
         END
   END

COMMIT TRAN
RETURN 0
go

-----------------------------------------------------------------------------------
-- Security Considerations
-----------------------------------------------------------------------------------

SELECT specific_name , 
       CASE WHEN permissions(object_id(specific_name)) & 32 = 32 
       THEN 1 
       ELSE 0 
       END AS CAN_EXECUTE
FROM information_schema.routines
WHERE specific_name LIKE 'routine$%'
go

-----------------------------------------------------------------------------------
-- Row-Level Security
-----------------------------------------------------------------------------------

CREATE VIEW v_album
AS
   SELECT albumId, name, artistId FROM dbo.album
   WHERE artistId <> 1 --Beatles
      OR is_member('BeatlesFan') = 1 
GO

-----------------------------------

SELECT * 
FROM dbo.v_album
Go
-----------------------------------

CREATE TABLE rlsAlbum
(
   rlsAlbumId int NOT NULL identity, 
   artistId int, 
   memberOfGroupName sysname
)
GO

-----------------------------------

--we build a view that includes our row level security table.
ALTER VIEW v_album
AS
SELECT album.albumId, album.name, album.artistId
FROM   dbo.album AS album
          JOIN (SELECT   DISTINCT artistId
                   FROM rlsAlbum
                      WHERE is_member(memberOfGroupName) = 1) AS security
                         ON album.artistId = security.artistId 
GO

-----------------------------------

--executed as member of no group
SELECT * FROM v_album
go

-----------------------------------

--db_owner, probably added in insert trigger on albumTable
INSERT INTO rlsAlbum(artistId, memberOfGroupName)
VALUES (1, 'db_owner')
INSERT INTO rlsAlbum(artistId, memberOfGroupName)
VALUES (2, 'db_owner')

INSERT INTO rlsAlbum(artistId, memberOfGroupName)
VALUES (1, 'BeatlesFan')
INSERT INTO rlsAlbum(artistId, memberOfGroupName)
VALUES (2, 'WhoFan')
GO

-----------------------------------

--executed as member of no group
SELECT * FROM v_album
go

-----------------------------------------------------------------------------------
-- Column-Level Security
-----------------------------------------------------------------------------------

ALTER VIEW v_album
AS
SELECT album.albumId, --assume the user can see the pk pointer
	CASE WHEN PERMISSIONS(OBJECT_ID('album'),'name') & 1 = 1 
	THEN NAME 
	ELSE NULL 
	END AS NAME,
	CASE WHEN PERMISSIONS(object_id('album'),'artistId') & 1 = 1 
	THEN album.artistId 
	ELSE NULL 
	END AS artistId
FROM dbo.album AS album
	JOIN (SELECT DISTINCT artistId
		FROM rlsAlbum
		WHERE is_member(memberOfGroupName) = 1) AS security
	ON album.artistId = security.artistId
go

