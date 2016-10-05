CREATE TRIGGER transaction$insteadOfInsert 
ON [transaction]
INSTEAD OF INSERT
AS
------------------------------------------------------------------------------
-- Purpose : Trigger on the insert that fires for any insert DML 
-- : * formats the date column without time
------------------------------------------------------------------------------
BEGIN
   DECLARE @rowsAffected int,    -- stores the number of rows affected 
   @errNumber int,               -- used to hold the error number after DML
   @msg varchar(255),            -- used to hold the error message
   @errSeverity varchar(20),
   @triggerName sysname

   SET @rowsAffected = @@rowcount
   SET @triggerName = object_name(@@procid) --used for messages

   --no need to continue on if no rows affected
   IF @rowsAffected = 0 RETURN 

   --perform the insert that we are building the trigger instead of
   INSERT INTO [transaction] (accountId, number, date, description, 
                            amount, signature, payeeId, 
                            transactionTypeId)
   SELECT accountId, number, dbo.date$removeTime(date) AS date, 
          description, amount, signature, payeeId, transactionTypeId
   FROM INSERTED

   SET @errNumber = @@error
   IF @errNumber <> 0
   begin
      SET @msg = 'Error: ' + CAST(@errNumber AS varchar(10)) + 
                         ' occurred during the insert of the rows into ' +
                         ' the transaction table.'
      RAISERROR 50000 @msg
      ROLLBACK TRANSACTION
      RETURN 
    END
END


GO

CREATE TRIGGER address$afterInsert
ON address 
AFTER UPDATE
AS
------------------------------------------------------------------------------
-- Purpose : Trigger on the <action> that fires for any <action> DML 
------------------------------------------------------------------------------
BEGIN
   DECLARE @rowsAffected int, -- stores the number of rows affected 
   @errNumber int, -- used to hold the error number after DML
   @msg varchar(255), -- used to hold the error message
   @errSeverity varchar(20),
   @triggerName sysname

   SET @rowsAffected = @@rowcount
   SET @triggerName = object_name(@@procid) --used for messages

   --no need to continue on if no rows affected
   IF @rowsAffected = 0 RETURN 

   DECLARE @numberOfRows int
   SELECT @numberOfRows = (SELECT count(*) 
                           FROM INSERTED
                                   JOIN zipCodeCityReference AS zcr 
                                        ON zcr.cityId = INSERTED.cityId and 
                                           zcr.zipCodeId = INSERTED.zipCodeId) 
   IF @numberOfRows <> @rowsAffected
   BEGIN
      SET @msg = CASE WHEN @rowsAffected = 1 
                      THEN 'The row you inserted has ' + 
                           'an invalid cityId and zipCodeId pair.'
                      ELSE 'One of the rows you were trying to insert ' +
                           'has an invalid cityId and zipCodeId pair.'
   		 END
   END
   RAISERROR 50000 @msg
   ROLLBACK TRANSACTION
   RETURN 
END

GO

CREATE TRIGGER transactionAllocation$afterInsert 
ON transactionAllocation
AFTER INSERT AS
------------------------------------------------------------------------------
-- Purpose : Trigger on the insert that fires for any insert DML 
-- : * protects against allocations that are greater than 100%
------------------------------------------------------------------------------
BEGIN
   DECLARE @rowsAffected int,    -- stores the number of rows affected 
   @errNumber int,               -- used to hold the error number after DML
   @msg varchar(255),            -- used to hold the error message
   @errSeverity varchar(20),
   @triggerName sysname

   SET @rowsAffected = @@rowcount
   SET @triggerName = object_name(@@procid) --used for messages

   -- no need to continue on if no rows affected
   IF @rowsAffected = 0 RETURN 

   -- get the total fo all transactionAllocations that are affected by our 
   -- insert and get all transactions affected

   IF EXISTS ( 
      SELECT * FROM ( 
         SELECT transactionId, sum(allocationAmount) AS amountTotal
         FROM transactionAllocation
						--note this transactionId expands our
                               --query to look at all allocations that
                               --are for any transaction who's
                               --allocation we have touched		    
         WHERE transactionId IN (SELECT transactionId fROM INSERTED)
         GROUP BY transactionId ) AS allocAmounts
         
      -- join to the transaction to get the amount of 
      -- the transaction
      JOIN [transaction]
         ON allocAmounts.transactionId = [transaction].transactionId

      -- check to make sure that the transaction amount is not greater 
      -- than the allocation amount
      WHERE [transaction].amount > allocAmounts.amountTotal ) 
      BEGIN
         SET @msg = CASE WHEN @rowsAffected = 1 
                         THEN 'The row you inserted has' +
                              'made the transaction exceed its transaction. '
                         ELSE 'One of the rows you were trying to insert ' +
                              'has made the transaction exceed its ' + 
                              'transaction.'
                    END
      END
   RAISERROR 50000 @msg
   ROLLBACK TRANSACTION
   RETURN 
END

GO

