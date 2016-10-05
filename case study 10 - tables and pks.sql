
CREATE TABLE account (
       accountId            int IDENTITY,
       bankId               int NOT NULL,
       number               varchar(20) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE account
       ADD CONSTRAINT PKaccount PRIMARY KEY (accountId)
go


CREATE TABLE accountReconcile (
       accountReconcileId   int IDENTITY,
       statementId          int NOT NULL,
       reconcileDate        smalldatetime NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE accountReconcile
       ADD CONSTRAINT PKaccountReconcile PRIMARY KEY (
              accountReconcileId)
go


CREATE TABLE address (
       addressId            int IDENTITY,
       cityId               int NOT NULL,
       zipCodeId            int NOT NULL,
       addressLine          varchar(2000) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE address
       ADD CONSTRAINT PKaddress PRIMARY KEY (addressId)
go


CREATE TABLE addressType (
       addressTypeId        int IDENTITY,
       name                 varchar(60) NOT NULL,
       description          varchar(100) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE addressType
       ADD CONSTRAINT PKaddressType PRIMARY KEY (addressTypeId)
go


CREATE TABLE bank (
       bankId               int IDENTITY,
       name                 varchar(60) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE bank
       ADD CONSTRAINT PKbank PRIMARY KEY (bankId)
go


CREATE TABLE city (
       cityId               int IDENTITY,
       stateId              int NOT NULL,
       name                 varchar(60) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE city
       ADD CONSTRAINT PKcity PRIMARY KEY (cityId)
go


CREATE TABLE payee (
       payeeId              int IDENTITY,
       name                 varchar(60) NULL,
       disableDate          smalldatetime NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE payee
       ADD CONSTRAINT PKpayee PRIMARY KEY (payeeId)
go


CREATE TABLE payeeAddress (
       payeeAddressId       int IDENTITY,
       payeeId              int NOT NULL,
       addressId            int NOT NULL,
       addressTypeId        int NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE payeeAddress
       ADD CONSTRAINT PKpayeeAddress PRIMARY KEY (payeeAddressId)
go


CREATE TABLE payeePhoneNumber (
       payeePhoneNumberId   int IDENTITY,
       payeeId              int NOT NULL,
       phoneNumberId        int NOT NULL,
       phoneNumberTypeId    int NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE payeePhoneNumber
       ADD CONSTRAINT PKpayeePhoneNumber PRIMARY KEY (
              payeePhoneNumberId)
go


CREATE TABLE phoneNumber (
       phoneNumberId        int IDENTITY,
       countryCode          char(1) NOT NULL,
       areaCode             varchar(3) NOT NULL,
       exchange             char(5) NOT NULL,
       number               char(4) NOT NULL,
       extension            varchar(20) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE phoneNumber
       ADD CONSTRAINT PKphoneNumber PRIMARY KEY (phoneNumberId)
go


CREATE TABLE phoneNumberType (
       phoneNumberTypeId    int IDENTITY,
       name                 varchar(60) NOT NULL,
       description          varchar(100) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE phoneNumberType
       ADD CONSTRAINT PKphoneNumberType PRIMARY KEY (
              phoneNumberTypeId)
go


CREATE TABLE state (
       stateId              int IDENTITY,
       code                 char(2) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE state
       ADD CONSTRAINT PKstate PRIMARY KEY (stateId)
go


CREATE TABLE statement (
       statementId          int IDENTITY,
       accountId            int NOT NULL,
       statementTypeId      int NOT NULL,
       previousBalance      money NOT NULL,
       previousBalanceDate  smalldatetime NOT NULL,
       currentBalance       money NOT NULL,
       date                 smalldatetime NOT NULL,
       totalDebits          money NOT NULL,
       totalCredits         money NOT NULL,
       periodEndDate        smalldatetime NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE statement
       ADD CONSTRAINT PKstatement PRIMARY KEY (statementId)
go


CREATE TABLE statementItem (
       statementItemId      int IDENTITY,
       statementId          int NOT NULL,
       date                 smalldatetime NOT NULL,
       number               varchar(20) NOT NULL,
       description          varchar(100) NOT NULL,
       amount               money NOT NULL,
       transactionTypeId    int NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE statementItem
       ADD CONSTRAINT PKstatementItem PRIMARY KEY (statementItemId)
go


CREATE TABLE statementType (
       statementTypeId      int IDENTITY,
       name                 varchar(60) NOT NULL,
       description          varchar(100) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE statementType
       ADD CONSTRAINT PKstatementType PRIMARY KEY (statementTypeId)
go


CREATE TABLE [transaction] (
       transactionId        int NOT NULL,
       accountId            int NOT NULL,
       number               varchar(20) NOT NULL,
       date                 smalldatetime NOT NULL,
       description          varchar(1000) NOT NULL,
       amount               money NOT NULL,
       signature            varchar(20) NOT NULL,
       payeeId              int NULL,
       userId               int NULL,
       statementItemId      int NULL,
       transactionTypeId    int NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE [transaction]
       ADD CONSTRAINT PKtransaction PRIMARY KEY (transactionId)
go


CREATE TABLE transactionAllocation (
       transactionAllocationId int IDENTITY,
       transactionAllocationTypeId int NOT NULL,
       transactionId        int NOT NULL,
       allocationAmount     money NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE transactionAllocation
       ADD CONSTRAINT PKtransactionAllocation PRIMARY KEY (
              transactionAllocationId)
go


CREATE TABLE transactionAllocationType (
       transactionAllocationTypeId int NOT NULL,
       name                 varchar(60) NOT NULL,
       description          varchar(100) NOT NULL,
       parentCheckUsageTypeId int NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE transactionAllocationType
       ADD CONSTRAINT PKtransactionAllocationType PRIMARY KEY (
              transactionAllocationTypeId)
go


CREATE TABLE transactionType (
       transactionTypeId    int IDENTITY,
       name                 varchar(60) NOT NULL,
       description          varchar(100) NOT NULL,
       requiresSignatureFl  bit,
       requiresPayeeFl      bit,
       allowPayeeFl        bit,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE transactionType
       ADD CONSTRAINT PKtransactionType PRIMARY KEY (
              transactionTypeId)
go


CREATE TABLE [user] (
       userId               int IDENTITY,
       userName             sysname NOT NULL,
       firstName            varchar(20) NOT NULL,
       middleName           varchar(60) NOT NULL,
       lastName             varchar(60) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE [user]
       ADD CONSTRAINT PKuser PRIMARY KEY (userId)
go


CREATE TABLE zipCode (
       zipCodeId            int IDENTITY,
       zipCode              char(5) NOT NULL,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE zipCode
       ADD CONSTRAINT PKzipCode PRIMARY KEY (zipCodeId)
go


CREATE TABLE zipCodeCityReference (
       zipCodeCityReferenceId int IDENTITY,
       cityId               int NULL,
       zipCodeId            int NOT NULL,
       primaryFl            bit,
       autoTimestamp        timestamp NOT NULL
)
go


ALTER TABLE zipCodeCityReference
       ADD CONSTRAINT PKzipCodeCityReference PRIMARY KEY (
              zipCodeCityReferenceId)
go



