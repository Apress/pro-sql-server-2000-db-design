CREATE PROCEDURE transaction$ins
(
    @accountId int,
    @number varchar(20),
    @date smalldatetime,
    @description varchar(1000),
    @amount money,
    @signature  varchar(100),
    @payeeId int,
    @transactionTypeId int,
    @new_transactionId int = NULL OUTPUT  --contains the new key 
                                                 --value for the identity
                                                 --primary key
) AS
   BEGIN

   --error handling parameters 
   DECLARE  @msg AS varchar(255),     -- used to preformat error messages
            @msgTag AS varchar(255),  -- used to hold the first part 
                                      -- of the message header
            @tranName AS sysname      -- to hold the name of the savepoint

   -- set up the error message tag and transaction tag 
   -- (nestlevel keeps it unique amongst calls to the procedure if nested)
   SET  @msgTag = '<' + object_name(@@procid) + ';TYPE=P'
   SET  @tranName = object_name(@@procid) + CAST(@@nestlevel AS VARCHAR(2))
   
   BEGIN TRANSACTION
   SAVE TRANSACTION @tranName 

   INSERT INTO [transaction](accountId, number, date, description, amount,
                           signature, payeeId, transactionTypeId  )
      VALUES(@accountId, @number, @date, @description, @amount, @signature,
             @payeeId, @transactionTypeId )

      -- check for an error
      IF (@@error!=0)
         BEGIN
         -- finish transaction first to minimize chance of transaction 
         -- being hung waiting on a message to complete
            ROLLBACK TRAN @tranName
            COMMIT TRAN
            SELECT @msg = 'There was a problem inserting a new row into ' + 
                          ' the transaction table.' + @msgTag + 
                          ';CALL=(INSERT transaction)>'
            RAISERROR 50000 @msg
            RETURN -100
         END

   -- scope_identity keeps us from getting any triggered identity values
   SET @new_transactionId=scope_identity()

   COMMIT TRAN

   END
go

CREATE PROCEDURE bank$upd
(
    @key_bankId int, -- key column that we will use as the key to the
                     -- update. Note that we cannot update the primary key
    @name varchar(384),
    @ts_timestamp timestamp -- optimistic lock 
)
AS
-- declare variable used for error handling in blocks
DECLARE @rowcount AS int,    -- holds the rowcount returned from dml calls
        @error AS int,        -- used to hold the error code after a dml 
        @msg AS varchar(255), -- used to preformat error messages
        @retval AS int,       -- general purpose variable for retrieving 
                           -- return values from stored procedure calls
        @tranname AS sysname,    -- used to hold the name of the transaction
        @msgTag AS varchar(255)  -- to hold the tags for the error message 

-- set up the error message tag
SET @msgTag = '<' + object_name(@@procid) + ';TYPE=P'
                  + ';keyvalue=' + '@key_bankId:' 
                  + CONVERT(varchar(10),@key_bankId) 

SET @tranName = object_name(@@procid) + CAST(@@nestlevel AS VARCHAR(2))

-- make sure that the user has passed in a timestamp value, as it will
-- be very wasteful if they have not
IF @ts_timeStamp IS NULL
   BEGIN
      SET @msg = 'The timestamp value must not be NULL' +
          @msgTag + '>'
          RAISERROR 50000 @msg
          RETURN -100
   END

BEGIN TRANSACTION
SAVE TRANSACTION @tranName 

UPDATE bank
SET name = @name
WHERE bankId = @key_bankId
   AND autoTimestamp = @ts_timeStamp

-- get the rowcount and error level for the error handling code
SELECT @rowcount = @@rowcount, @error = @@error

IF @error != 0  -- an error occurred outside of this procedure
   BEGIN
      ROLLBACK TRAN @tranName 
      COMMIT TRAN
      SELECT @msg = 'A problem occurred modifying the bank record.' + 
         @msgTag + ';CALL=(UPDATE bank)>'
      RAISERROR 50001 @msg
      RETURN -100
   END
   ELSE IF @rowcount <> 1  -- this must not be the primary key 
                           -- anymore or the record doesn't exist
   BEGIN
      IF (@rowcount = 0) 
         BEGIN
           -- if the record exists without the timestamp, it has been modified 
           -- by another user
           IF EXISTS (SELECT * FROM bank WHERE bankId = @key_bankId)
              BEGIN
                 SELECT @msg = 'The bank record has been modified' + 
                               ' by another user.'
              END
           ELSE    -- the primary key value did not exist
              BEGIN
                 SELECT @msg = 'The bank record does not exist.'
              END
         END
      ELSE         -- rowcount > 0, so too many records were modified
         BEGIN
            SELECT @msg = 'Too many records were modified.'
         END

   ROLLBACK TRAN @tranName 
   COMMIT TRAN
   SELECT @msg = @msg + @msgTag + ';CALL=(update bank)>'
   RAISERROR 50000 @msg
   RETURN -100

   END

COMMIT TRAN
RETURN 0
go

CREATE PROCEDURE payee$del
(
    @key_payeeId int,
    @ts_timeStamp timestamp = NULL  --optimistic lock
)
AS
--declare variable used for error handling in blocks
DECLARE @rowcount AS int,       -- holds the rowcount returned from dml calls
        @error AS int,          -- used to hold the error code after a dml 
        @msg AS varchar(255),   -- used to preformat error messages
        @retval AS int,         -- general purpose variable for retrieving 
                             -- return values from stored procedure calls
        @tranName AS sysname,   -- used to hold the name of the transaction
        @msgTag AS varchar(255) -- used to hold the tags for the error message 

-- set up the error message tag
SET     @msgTag = '<' + object_name(@@procid) + ';TYPE=P'
                   + ';keyvalue=' + '@key_payeeId:' 
                   + convert(VARCHAR(10),@key_payeeId) 

SET     @tranName = object_name(@@procid) + CAST(@@nestlevel as varchar(2))

BEGIN TRANSACTION
SAVE TRANSACTION @tranName

DELETE payee
WHERE  payeeId = @key_payeeId 
   AND @ts_timeStamp = autoTimestamp

-- get the rowcount and error level for the error handling code
SELECT @rowcount = @@rowcount, @error = @@error

IF @error != 0  -- an error occurred outside of this procedure
   BEGIN
      SELECT @msg = 'A problem occurred removing the payee record.'  + 
             @msgTag + 'call=(delete payee)>'
      ROLLBACK TRAN @tranName
      COMMIT TRAN
      RAISERROR 50000 @msg
      RETURN -100
   END
ELSE IF @rowcount > 1  -- this must not be the primary key anymore or the 
                       -- record doesn't exist
   BEGIN
      SELECT @msg = 'Too many payee records were deleted. ' + 
             @msgTag + ';call=(delete payee)>'

         ROLLBACK TRAN @tranName
         COMMIT TRAN
         RAISERROR 50000 @msg

         RETURN -100

   END
ELSE IF @rowcount = 0 
   BEGIN
      IF EXISTS (SELECT * FROM payee WHERE payeeId = @key_payeeId)
         BEGIN
            SELECT @msg = 'The payee record has been modified' + 
                          ' by another user.' + ';call=(delete payee)>'

            ROLLBACK TRAN @tranName
            COMMIT tran
            RAISERROR 50000 @msg
            RETURN -100

         END
      ELSE
         BEGIN
            SELECT @msg = 'The payee record you tried to delete' +
                          ' does not exist.' + @msgTag + 
                          ';call=(delete payee)>'
               RAISERROR 50000 @msg
                  -- it depends on the needs of the system whether or not you
                  -- should actually implement this error or even if
                  -- if we should quit here, and return a negative value. 
                  -- If you were trying to remove something
                  -- and it doesn't exist, is that bad?
         END
   END

COMMIT TRAN
RETURN 0
GO

CREATE PROCEDURE account$list
(
 @accountId int = NULL,        -- primary key to retrieve single row
 @number  varchar(20) = '%', -- like match on account.name
 @bankId  int = NULL,
 @bankName  varchar(20) = '%'
)
AS

-- as the count messages have been known to be a problem for clients
SET NOCOUNT ON

-- default the @number parm to '%' if the passed value is NULL
IF @number IS NULL SELECT @number = '%'

-- select all of the fields (less the timestamp) from the table for viewing. 
SELECT account.accountId, account.bankId, account.number,
          bank.name AS bankName
FROM dbo.account AS account
JOIN dbo.bank AS bank
   ON account.bankId = bank.bankId
WHERE (account.accountId = @accountId OR @accountId IS NULL)
  AND (account.number Like @number)
  AND (account.bankId = @bankId OR @bankId IS NULL)
  AND (bank.NAME LIKE @bankName)
ORDER BY account.number

RETURN 0

go

CREATE PROCEDURE transactionType$domainFill

AS

   BEGIN

   -- all domain fill procedures return the same field names, so that the 
   -- user can code them the same way using a generic object
   SELECT transactionTypeId AS ID, transactionType.NAME AS description
   FROM transactionType
   ORDER BY transactionType.NAME

END

Go


--the procedure in the book was based on a previous iteration of the data model.  
--this version has changed slightly to represent the additonal changes
CREATE PROCEDURE account$getAccountInformation 
(
   @accountId int
) AS 

--  Note that because we built our transaction table using a reserved word, 
--  we have to use bracketed names in our query. 

SELECT account.Number as accountNumber, 
       statement.DATE as statementDate,        --  if this value is NULL then no statements 
                              --  ever received
       accountReconcile.reconcileDATE, --  if this value is NULL, then the account 
                              --  has never been reconciled
   SUM([transaction].AMOUNT) AS accountBalance,
   SUM(CASE WHEN [transaction].AMOUNT > 0 
      THEN [transaction].AMOUNT 
      ELSE 0 
   END) AS totalCredits,
   SUM(CASE WHEN [transaction].AMOUNT < 0 
   THEN [transaction].AMOUNT 
   ELSE 0 
   END) AS totalDebits,
   SUM(CASE 
   WHEN [transaction].statementItemId IS NOT NULL 
      THEN [transaction].Amount 
      ELSE 0 END) AS unreconciledTotal
FROM  dbo.account AS account
--  accounts may have no transactions yet
   LEFT OUTER JOIN dbo.[transaction] AS [transaction]
      --  transaction may not have been reconciled yet
      LEFT OUTER JOIN statementItem AS statementItem
         ON [transaction].statementItemId = 
                                       statementItem.statementItemId
      ON account.accountId = [transaction].accountId
      --  account may never have recieved a statement
   LEFT OUTER JOIN dbo.statement AS statement
      LEFT OUTER JOIN dbo.accountReconcile AS accountReconcile
         ON statement.statementId = accountReconcile.statementId
      ON account.accountId = [transaction].accountId
WHERE account.accountId = @accountId
GROUP BY account.number, statement.DATE, accountReconcile.reconcileDATE
go

