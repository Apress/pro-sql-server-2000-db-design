CREATE FUNCTION string$checkEntered
(
   @value varchar(8000)    --longest varchar value
)
RETURNS bit
AS
--used to check to see if a varchar value passed in is empty
--note: additional function required for unicode if desired
BEGIN
   DECLARE @returnVal bit --just returns yes or no

   --do an RTRIM, COALESCED to a '' if it is NULL, surround by *, and compare 

   IF ( '*' + COALESCE(RTRIM(@value),'') + '*') <> '**' 
      SET @returnVal = 1 --not empty
   ELSE
      SET @returnVal = 0 --empty

   RETURN @returnVal
END
GO
 
-- empty condition
IF dbo.string$checkEntered('') = 0
   SELECT 'Empty'
ELSE
   SELECT 'Not Empty'

-- not empty condition
IF dbo.string$checkEntered('Any text will do') = 0
   SELECT 'Empty'
ELSE
   SELECT 'Not Empty'
GO

ALTER TABLE account 
       ADD CONSTRAINT chk$account$number$string$notEmpty 
             Check (dbo.string$checkEntered(number) = 1)


ALTER TABLE address 
       ADD CONSTRAINT chk$address$addressLine$string$notEmpty 
             Check (dbo.string$checkEntered(addressLine) = 1)

ALTER TABLE addressType 
       ADD CONSTRAINT chk$addressType$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)
				
ALTER TABLE addressType 
       ADD CONSTRAINT chk$addressType$description$string$notEmpty 
             Check (dbo.string$checkEntered(description) = 1)

ALTER TABLE bank 
       ADD CONSTRAINT chk$bank$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)


ALTER TABLE city 
       ADD CONSTRAINT chk$city$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)

ALTER TABLE payee 
       ADD CONSTRAINT chk$payee$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)

ALTER TABLE phoneNumber 
       ADD CONSTRAINT chk$phoneNumber$countryCode$string$notEmpty 
             Check (dbo.string$checkEntered(countryCode) = 1)
				
ALTER TABLE phoneNumber 
       ADD CONSTRAINT chk$phoneNumber$areaCode$string$notEmpty 
             Check (dbo.string$checkEntered(areaCode) = 1)
				
ALTER TABLE phoneNumber 
       ADD CONSTRAINT chk$phoneNumber$exchange$string$notEmpty 
             Check (dbo.string$checkEntered(exchange) = 1)

ALTER TABLE phoneNumber 
       ADD CONSTRAINT chk$phoneNumber$number$string$notEmpty 
             Check (dbo.string$checkEntered(number) = 1)

ALTER TABLE phoneNumberType 
       ADD CONSTRAINT chk$phoneNumberType$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)

				
ALTER TABLE phoneNumberType 
       ADD CONSTRAINT chk$phoneNumberType$description$string$notEmpty 
             Check (dbo.string$checkEntered(description) = 1)

ALTER TABLE state 
       ADD CONSTRAINT chk$state$code$string$notEmpty 
             Check (dbo.string$checkEntered(code) = 1)

ALTER TABLE statementItem 
       ADD CONSTRAINT chk$statementItem$number$string$notEmpty 
             Check (dbo.string$checkEntered(number) = 1)
				
ALTER TABLE statementItem 
       ADD CONSTRAINT chk$statementItem$description$string$notEmpty 
             Check (dbo.string$checkEntered(description) = 1)

ALTER TABLE statementType 
       ADD CONSTRAINT chk$statementType$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)
				
ALTER TABLE statementType 
       ADD CONSTRAINT chk$statementType$description$string$notEmpty 
             Check (dbo.string$checkEntered(description) = 1)

ALTER TABLE [transaction]
       ADD CONSTRAINT chk$transaction$number$string$notEmpty 
             Check (dbo.string$checkEntered(number) = 1)
				
ALTER TABLE [transaction] 
       ADD CONSTRAINT chk$transaction$description$string$notEmpty 
             Check (dbo.string$checkEntered(description) = 1)
				
ALTER TABLE [transaction] 
       ADD CONSTRAINT chk$transaction$signature$string$notEmpty 
             Check (dbo.string$checkEntered(signature) = 1)
ALTER TABLE transactionAllocationType 
       ADD CONSTRAINT chk$transactionAllocationType$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)

ALTER TABLE transactionAllocationType 
       ADD CONSTRAINT chk$transactionAllocationType$description$string$notEmpty 
             Check (dbo.string$checkEntered(description) = 1)

ALTER TABLE transactionType 
       ADD CONSTRAINT chk$transactionType$name$string$notEmpty 
             Check (dbo.string$checkEntered(name) = 1)

ALTER TABLE transactionType 
       ADD CONSTRAINT chk$transactionType$description$string$notEmpty 
             Check (dbo.string$checkEntered(description) = 1)

ALTER TABLE [user]
       ADD CONSTRAINT chk$user$userName$string$notEmpty 
             Check (dbo.string$checkEntered(userName) = 1)

ALTER TABLE [user] 
       ADD CONSTRAINT chk$user$firstName$string$notEmpty 
             Check (dbo.string$checkEntered(firstName) = 1)

ALTER TABLE [user] 
       ADD CONSTRAINT chk$user$lastName$string$notEmpty 
             Check (dbo.string$checkEntered(lastName) = 1)

ALTER TABLE zipCode 
       ADD CONSTRAINT chk$zipCode$zipCode$string$notEmpty 
             Check (dbo.string$checkEntered(zipCode) = 1)

GO

CREATE FUNCTION date$rangeCheck
(
   @dateValue datetime,           -- first date value
   @dateToCompareAgainst datetime -- pass in date to compare to
)
RETURNS int
AS
BEGIN
   DECLARE @returnVal int 
   IF @dateValue > @dateToCompareAgainst
   BEGIN
      SET @returnVal = 1              -- date is in the future
      END
   ELSE IF @dateValue < @dateToCompareAgainst
   BEGIN
      SET @returnVal = -1             -- date in is the past
   END
   ELSE
      SET @returnVal = 0              -- dates are the same
   RETURN @returnVal
END
GO

--empty condition
SELECT dbo.date$rangeCheck('1/1/1989',getdate()) as [should be -1]
SELECT dbo.date$rangeCheck(getdate(),getdate()) as [should be 0]
SELECT dbo.date$rangeCheck('1/1/2020',getdate()) as [should be 1] 
GO


CREATE FUNCTION date$removeTime
(
   @date datetime 
)
RETURNS datetime AS
BEGIN 
   SET @date = CAST(datePart(month,@date) as varchar(2)) + '/' + 
               CAST(datePart(day,@date) as varchar(2)) + '/' + 
               CAST(datePart(year,@date) as varchar(4)) 
   RETURN @date
END
GO


ALTER TABLE [transaction]
	ADD CONSTRAINT chkTransaction$date$date$notFuture
		--0 is equal, -1 means in the past, 1 means in the future
		CHECK (dbo.date$rangeCheck(date,dbo.date$removeTime(getdate())) > 0)
GO

--slight change from the book.  Had to add it as null then alter to not null
ALTER TABLE transactionType 
ADD minimumAmount money NULL 

ALTER TABLE transactionType 
ALTER COLUMN minimumAmount money NOT NULL 

ALTER TABLE transactionType 
ADD maximumAmount money NULL

ALTER TABLE transactionType 
ALTER COLUMN maximumAmount money NOT NULL

--simple check constraint to make certaint that min is less than max
ALTER TABLE transactionType
	ADD CONSTRAINT chkTransactionType$minAndMaxRangeCheck
		CHECK (minimumAmount <= maximumAmount)
GO


--note that I forgot the RETURN clause in this function in the book
CREATE FUNCTION transactionType$validateAmountInRange
(
   @transactionTypeId int,
   @amount money
)
RETURNS bit 
AS
BEGIN
   --1 means within range, 0 out of range
   DECLARE @returnValue bit
   IF EXISTS ( select *
      FROM transactionType
      WHERE @amount NOT BETWEEN minimumAmount AND maximumAmount
         AND transactionTypeId = @transactionTypeId)
      BEGIN
         SET @returnValue = 0
      END
   ELSE
      SET @returnValue = 1

   RETURN @returnValue
END

GO

ALTER TABLE [transaction]
	ADD CONSTRAINT chkTransaction$amountProperForTransactionType
		CHECK (dbo.transactionType$validateAmountInRange(transactionTypeId, amount) = 1 )

GO

