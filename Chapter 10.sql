
--Note:  Each snippet of code is preceded by a comment
--block that corresponds to the section prior to the section
--in the book.

------------------------------------------------------------
--  identity columns
------------------------------------------------------------

CREATE TABLE testIdentity
(
   identityColumn int NOT NULL IDENTITY (1, 2),
   value    varchar(10)  NOT NULL
)

INSERT INTO testIdentity (value)
VALUES ('one')
INSERT INTO testIdentity (value)
VALUES ('two')
INSERT INTO testIdentity (value)
VALUES ('three')

SELECT * FROM testIdentity
go

------------------------------------------------------------
--approximate numeric data
------------------------------------------------------------

SELECT CAST(1 AS float(53))/CAST( 10 AS float(53)) AS funny_result

SELECT CAST(.1 AS float) AS funny_result
go

------------------------------------------------------------
--Using User-defined Data Types to Manipulate Dates and Times
------------------------------------------------------------

EXEC sp_addtype @typename = intDateType, 
   @phystype = integer,
   @NULLtype = 'NULL',
   @owner = 'dbo'
GO

CREATE FUNCTION intDateType$convertToDatetime
(
   @dateTime   intDateType
) 
RETURNS datetime
AS
BEGIN
   RETURN ( dateadd(day,@datetime,'jan 1, 2001'))
END
GO

SELECT dbo.intDateType$convertToDatetime(1) as convertedValue
go

------------------------------------------------------------
--The Disadvantages of Variant
------------------------------------------------------------

DECLARE @varcharVariant sql_variant
SET @varcharVariant = '1234567890'
SELECT @varcharVariant AS varcharVariant, 
   SQL_VARIANT_PROPERTY(@varcharVariant,'BaseType') as baseType,
   SQL_VARIANT_PROPERTY(@varcharVariant,'MaxLength') as maxLength

------------------------------------------------------------
--timestamp (or rowversion)
------------------------------------------------------------

SET nocount on
CREATE TABLE testTimestamp
(
   value   varchar(20) NOT NULL,
   auto_rv   timestamp NOT NULL
)

INSERT INTO testTimestamp (value) values ('Insert')

SELECT value, auto_rv FROM testTimestamp
UPDATE testTimestamp
SET value = 'First Update'

SELECT value, auto_rv from testTimestamp
UPDATE testTimestamp
SET value = 'Last Update'

SELECT value, auto_rv FROM testTimestamp

------------------------------------------------------------
--uniqueidentifier
------------------------------------------------------------

DECLARE @guidVar uniqueidentifier
SET @guidVar = newid()

SELECT @guidVar as guidVar


CREATE TABLE guidPrimaryKey
(
   guidPrimaryKeyId uniqueidentifier NOT NULL 
   rowguidcol DEFAULT newId(),
   value varchar(10)
)

INSERT INTO guidPrimaryKey(value)
VALUES ('Test')


SELECT *
FROM guidPrimaryKey

------------------------------------------------------------
--table
------------------------------------------------------------

DECLARE @tableVar TABLE
( 
   id int IDENTITY, 
   value varchar(100)
)
INSERT INTO @tableVar (value) 
VALUES ('This is a cool test')

SELECT id, value
FROM @tableVar


CREATE FUNCTION table$testFunction
(
   @returnValue varchar(100)

)  
RETURNS @tableVar table 
( 
     value varchar(100)
)
AS
BEGIN
   INSERT INTO @tableVar (value) 
   VALUES (@returnValue)

   RETURN
END

SELECT *
FROM dbo.table$testFunction('testValue')

go

------------------------------------------------------------
--User-Defined Data Types
------------------------------------------------------------

EXEC sp_addtype @typename = serialNumber, 
   @phystype = 'varchar(12)',
   @NULLtype = 'not NULL',
   @owner = 'dbo'
GO

--create a type, call it SSN, varchar(11), the size of a social security 
--number including the dashes
EXEC sp_addtype @typename = 'SSN', 
   @phystype = 'varchar(11)',
   @NULLtype = 'not NULL'
GO

--create a rule, call it SSNRule, with this pattern 
CREATE RULE SSNRule AS 
   @value LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'
GO

--bind the rule to the exampleType
EXEC sp_bindrule 'SSNRule', 'SSN'
GO

--create a test table with the new data type.
CREATE TABLE testRule
(
   id int IDENTITY,
   socialSecurityNumber   SSN
)
GO

--insert values into the table
INSERT INTO testRule (socialSecurityNumber)
VALUES ('438-44-3343')
INSERT INTO testRule (socialSecurityNumber)
VALUES ('43B-43-2343')   --note the B instead of the 8 to cause an error
GO

------------------------------------------------------------
--Inconsistent Handling of Variables (user defined types)
------------------------------------------------------------

DECLARE @SSNVar SSN
SET @SSNVar = NULL
SELECT @SSNVar
go

DECLARE @SSNVar SSN
SET @SSNVar = 'Bill'
SELECT @SSNVar AS SSNVar

INSERT INTO testRule (socialSecurityNumber)
VALUES (@SSNVar)

go

------------------------------------------------------------
--Optional Data
------------------------------------------------------------

CREATE TABLE NULLTest
(
   NULLColumn varchar(10) NULL,
   notNULLColumn varchar(10) NOT NULL
)

go

EXECUTE sp_dboption @dbname = 'tempdb', @optname = 'ANSI NULL default'

go

--turn off default NULLs
SET ANSI_NULL_DFLT_ON OFF

--create test table
CREATE TABLE testNULL
(
   id   int
)

--check the values
EXEC sp_help testNULL

go

--change the setting to default not NULL
SET ANSI_NULL_DFLT_ON ON

--get rid of the table and recreate it
DROP TABLE testNULL
GO
CREATE TABLE testNULL
(
   id   int
)

EXEC sp_help testNULL
go

------------------------------------------------------------
--calculated columns
------------------------------------------------------------

CREATE TABLE calcColumns
(
   dateColumn   datetime,
   dateSecond   AS datepart(second,dateColumn), -- calculated column 
)

DECLARE @i int 
SET @i = 1
WHILE (@i < 1000)
BEGIN
   INSERT INTO calcColumns (dateColumn) VALUES (getdate())
   SET @i = @i + 1
END

SELECT dateSecond, max(dateColumn) as dateColumn, count(*) AS countStar
FROM calcColumns
GROUP BY dateSecond
ORDER BY dateSecond

go

CREATE TABLE testCalc
(
value varchar(10), 
valueCalc AS UPPER(value),
value2 varchar(10)
)

go

INSERT INTO testCalc
-- We should have (value, value2) here
VALUES ('test','test2')

go

SELECT * 
FROM  testCalc

go

------------------------------------------------------------
--concurrency control
------------------------------------------------------------
CREATE TABLE testOptimisticLock
(
   id int NOT NULL,
   value varchar(10) NOT NULL,
   autoTimestamp timestamp NOT NULL, --optimistic lock
   primary key (id)                  --adds a primary key on id column
)

go


INSERT INTO testOptimisticLock (id, value)
VALUES (1, 'Test1')

DECLARE @timestampHold timestamp
SELECT @timestampHold = autoTimestamp
FROM testOptimisticLock
WHERE value = 'Test1'

--first time will work
UPDATE testOptimisticLock
SET value = 'New Value'
WHERE id = 1 
   AND   autoTimestamp = @timestampHold 
IF @@rowcount = 0 
BEGIN
   raiserror 50000 'Row has been changed by another user'
END
SELECT   id, value FROM testOptimisticLock

--second time will fail
UPDATE testOptimisticLock
SET value = 'Second New Value'
WHERE id = 1 
   AND   autoTimestamp = @timestampHold 
IF @@rowcount = 0 
BEGIN
   raiserror 50000 'Row has been changed another user'
END
SELECT   id, value from testOptimisticLock

go

------------------------------------------------------------
--collation (sort order)
------------------------------------------------------------

SELECT serverproperty('collation')
SELECT databasepropertyex('master','collation')

SELECT *
FROM ::fn_helpcollations()

go

CREATE TABLE otherCollate
(
   id integer IDENTITY,
   name nvarchar(30) NOT NULL,
   frenchName nvarchar(30) COLLATE French_CI_AS_WS NULL,
   spanishName nvarchar(30) COLLATE Modern_Spanish_CI_AS_WS NULL
)

GO

CREATE TABLE collateTest
(
    name    VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
)
insert into collateTest(name)
values ('BOB')
insert into collateTest(name)
values ('bob')
GO
	
SELECT name
FROM collateTest
WHERE name = 'BOB'

SELECT name
FROM collateTest
WHERE name = 'BOB' COLLATE Latin1_General_BIN

SELECT name
FROM collateTest
WHERE name COLLATE Latin1_General_BIN = 'BOB' COLLATE Latin1_General_BIN

GO

------------------------------------------------------------
--basic index structure
------------------------------------------------------------

CREATE TABLE testIndex
(
   id int IDENTITY,
   firstName varchar(20),
   middleName varchar(20),
   lastName varchar(30)
)

CREATE INDEX XtestIndex ON testIndex(id)
CREATE INDEX XtestIndex1 ON testIndex(firstName)
CREATE INDEX XtestIndex2 ON testIndex(middleName)
CREATE INDEX XtestIndex3 ON testIndex(lastName)
CREATE INDEX XtestIndex4 ON testIndex(firstName,middleName,lastName)

go

DROP INDEX testIndex.Xtestindex
go
--drop indexes we created before (not in book)
drop index testIndex.XtestIndex1
drop index testIndex.XtestIndex2
drop index testIndex.XtestIndex3
drop index testIndex.XtestIndex4
go
CREATE UNIQUE INDEX XtestIndex1 ON testIndex(lastName)
CREATE UNIQUE INDEX XtestIndex2 ON testIndex(firstName,middleName,lastName)

go
INSERT  INTO testIndex (firstName, middleName, lastname)
VALUES ('Louis','Banks','Davidson')
INSERT INTO testIndex (firstName, middleName, lastname)
VALUES ('James','Banks','Davidson')


go

------------------------------------------------------------
--IGNORE_DUP_KEY
------------------------------------------------------------

--drop index from book not needed 
go
CREATE UNIQUE INDEX XtestIndex4 
   ON testIndex(firstName,middleName,lastName) 
   WITH ignore_dup_key
go
INSERT   INTO testIndex (firstName, middleName, lastname)
VALUES   ('Louis','Banks','Davidson')
INSERT   INTO testIndex (firstName, middleName, lastname)
VALUES   ('Louis','Banks','Davidson')
go

------------------------------------------------------------
--Primary Key
------------------------------------------------------------

CREATE TABLE nameTable
(
   id integer NOT NULL IDENTITY PRIMARY KEY NONCLUSTERED
)

--not from book
drop table nameTable
go
CREATE TABLE nameTable
(
   id integer NOT NULL IDENTITY,
   pkeyColumn1 integer NOT NULL,
   pkeyColumn2 integer NOT NULL,
   PRIMARY KEY NONCLUSTERED (id)
)
go

--not from book
drop table nameTable
go

CREATE TABLE nameTable
(
   id uniqueidentifier NOT NULL ROWGUIDCOL DEFAULT newid(),
   PRIMARY KEY NONCLUSTERED (id) 
)
go

------------------------------------------------------------
--Alternate Keys
------------------------------------------------------------

--not from book
drop table nameTable
go

CREATE TABLE nameTable
(
   id integer NOT NULL IDENTITY PRIMARY KEY NONCLUSTERED,
   firstName varchar(15) NOT NULL,
   lastName varchar(15) NOT NULL
)
CREATE UNIQUE INDEX XnameTable ON nameTable(firstName,lastName)
go

--not from book
drop table nameTable
go

CREATE TABLE nameTable
(
   id integer NOT NULL IDENTITY PRIMARY KEY,
   firstName varchar(15) NOT NULL,
   lastName varchar(15) NOT NULL,
   UNIQUE (firstName, lastName)
)
go

exec sp_helpconstraint 'nameTable'
go

------------------------------------------------------------
--Naming
------------------------------------------------------------

--not from book
drop table nameTable
go

CREATE TABLE nameTable
(
   id integer NOT NULL IDENTITY 
      CONSTRAINT PKnameTable PRIMARY KEY, 
   firstName varchar(15) NOT NULL CONSTRAINT AKnameTable_firstName UNIQUE,
   lastName varchar(15) NULL CONSTRAINT AKnameTable_lastName UNIQUE,
      CONSTRAINT AKnameTable_fullName UNIQUE (firstName, lastName) 
)
go


------------------------------------------------------------
--Foreign Keys
------------------------------------------------------------

CREATE TABLE parent
(
    parentId    int IDENTITY NOT NULL CONSTRAINT PKparent PRIMARY KEY,
    parentAttribute    varchar(20) NULL
)

CREATE TABLE child
(
    childId    int IDENTITY NOT NULL CONSTRAINT PKchild PRIMARY KEY,
    parentId    int NOT NULL,
    childAttribute    varchar(20)NOT NULL
)

go

ALTER TABLE child
   ADD CONSTRAINT child$has$parent 
        FOREIGN KEY (parentId) REFERENCES parent 

go

INSERT INTO parent(parentAttribute)
VALUES ('parent')

--get last identity value inserted in the current scope
DECLARE @parentId int
SELECT @parentId = scope_identity()

INSERT into child (parentId, childAttribute)
VALUES (@parentId, 'child')

DELETE FROM parent

go

------------------------------------------------------------
--cascading deletes
------------------------------------------------------------

--note that there is no alter constraint command
ALTER TABLE child
   DROP CONSTRAINT child$has$parent

ALTER TABLE child
   ADD CONSTRAINT child$has$parent FOREIGN KEY (parentId)
   REFERENCES parent
   ON DELETE CASCADE

SELECT * FROM parent
SELECT * FROM child
go

DELETE FROM parent
SELECT * FROM parent
SELECT * FROM child

go

------------------------------------------------------------
--New Descriptive Properties
------------------------------------------------------------

CREATE TABLE person
(
   personId int NOT NULL IDENTITY,
   firstName varchar(40) NOT NULL,
   lastName varchar(40) NOT NULL,
   socialSecurityNumber varchar(10) NOT NULL
)
go

--dbo.person table gui description
EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'Example of extended properties on the person table',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person'

--dbo.person.personId gui description
EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'primary key pointer to a person instance',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person',
   @level2type = 'column', @level2name = 'personId'

--dbo.person.firstName gui description
EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The person''s first name',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person',
   @level2type = 'column', @level2name = 'firstName'

--dbo.person.lastName gui description
EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The person''s last name',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person',
   @level2type = 'column', @level2name = 'lastName'

--dbo.person.socialSecurityNumber gui description
EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'descrip of sociSecNbr colmn',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person',
   @level2type = 'column', @level2name = 'socialSecurityNumber' 

go

--see if the property already exists
IF EXISTS ( SELECT *
   FROM ::FN_LISTEXTENDEDPROPERTY('MS_Description',
     'User', 'dbo',
     'table', 'person', 
     'Column', 'socialSecurityNumber') )
BEGIN
   --if the property already exists
   EXEC sp_updateextendedproperty @name = 'MS_Description', 
   @value = 'the person''s government id number',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person',
   @level2type = 'column', @level2name = 'socialSecurityNumber'
END
ELSE
BEGIN
   --otherwise create it.
   EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'the person''s government id number',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person',
   @level2type = 'column', @level2name = 'socialSecurityNumber'
END
go

exec sp_addextendedproperty   @name = 'Input Mask', 
   @value = '###-##-####',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'person',
   @level2type = 'column', @level2name = 'socialSecurityNumber'
go

