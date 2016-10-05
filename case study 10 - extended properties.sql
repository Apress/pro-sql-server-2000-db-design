-----------------------------------------------------------------------
--  account extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'A banking relationship established to provide financial transactions - we likely will need to be able to deal with multiple banks',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'account'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a account record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'account',
   @level2type = 'column', @level2name = 'accountId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related bank record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'account',
   @level2type = 'column', @level2name = 'bankId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Alphanumeric "number" which is usually an alternate key value for a record in a table. An example is an account number.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'account',
   @level2type = 'column', @level2name = 'number'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'account',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  accountReconcile extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'used as a marker to note that the statement is cleared',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'accountReconcile'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a accountReconcile record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'accountReconcile',
   @level2type = 'column', @level2name = 'accountReconcileId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related statement record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'accountReconcile',
   @level2type = 'column', @level2name = 'statementId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The date and time that the account was reconciled',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'accountReconcile',
   @level2type = 'column', @level2name = 'reconcileDate'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'accountReconcile',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  address extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'postal address',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'address'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a address record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'address',
   @level2type = 'column', @level2name = 'addressId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related city record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'address',
   @level2type = 'column', @level2name = 'cityId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related zipCode record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'address',
   @level2type = 'column', @level2name = 'zipCodeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to store the unstructured address information.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'address',
   @level2type = 'column', @level2name = 'addressLine'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'address',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  addressType extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'domain of different types of addresses',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'addressType'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a addressType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'addressType',
   @level2type = 'column', @level2name = 'addressTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a addressType record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'addressType',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Brief, unstructured comments describing an instance of a table to further extend another user''s ability to tell addressType rows apart.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'addressType',
   @level2type = 'column', @level2name = 'description'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'addressType',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  bank extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'The organization that has the account that we will store our money',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'bank'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a bank record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'bank',
   @level2type = 'column', @level2name = 'bankId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a bank record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'bank',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'bank',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  city extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'Cities, which are located in states.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'city'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a city record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'city',
   @level2type = 'column', @level2name = 'cityId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related state record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'city',
   @level2type = 'column', @level2name = 'stateId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a city record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'city',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'city',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  payee extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'A person or company that we send money to',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payee'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a payee record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payee',
   @level2type = 'column', @level2name = 'payeeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a payee record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payee',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to disable a record without deleting it, like for historical purposes.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payee',
   @level2type = 'column', @level2name = 'disableDate'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payee',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  payeeAddress extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'associates a payee with an address',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeeAddress'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a payeeAddress record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeeAddress',
   @level2type = 'column', @level2name = 'payeeAddressId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related payee record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeeAddress',
   @level2type = 'column', @level2name = 'payeeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related address record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeeAddress',
   @level2type = 'column', @level2name = 'addressId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related addressType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeeAddress',
   @level2type = 'column', @level2name = 'addressTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeeAddress',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  payeePhoneNumber extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'associates a phone number with a payee',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeePhoneNumber'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a payeePhoneNumber record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeePhoneNumber',
   @level2type = 'column', @level2name = 'payeePhoneNumberId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related payee record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeePhoneNumber',
   @level2type = 'column', @level2name = 'payeeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related phoneNumber record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeePhoneNumber',
   @level2type = 'column', @level2name = 'phoneNumberId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related phoneNumberType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeePhoneNumber',
   @level2type = 'column', @level2name = 'phoneNumberTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'payeePhoneNumber',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  phoneNumber extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'telephone numbers',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a phoneNumber record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber',
   @level2type = 'column', @level2name = 'phoneNumberId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Dialing code that identifies the country being dialed.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber',
   @level2type = 'column', @level2name = 'countryCode'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Code that identifies a dialing region of a state.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber',
   @level2type = 'column', @level2name = 'areaCode'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The area dialing code that comes before the telephone number.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber',
   @level2type = 'column', @level2name = 'exchange'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The telephone number.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber',
   @level2type = 'column', @level2name = 'number'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'A string that allows a set of numbers that can be dialed after the connection has been made.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber',
   @level2type = 'column', @level2name = 'extension'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumber',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  phoneNumberType extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'domain of different types of phone numbers',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumberType'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a phoneNumberType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumberType',
   @level2type = 'column', @level2name = 'phoneNumberTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a phoneNumberType record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumberType',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Brief, unstructured comments describing an instance of a table to further extend another user''s ability to tell phoneNumberType rows apart.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumberType',
   @level2type = 'column', @level2name = 'description'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'phoneNumberType',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  state extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'American states',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'state'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a state record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'state',
   @level2type = 'column', @level2name = 'stateId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The two character state code that is recognized by the United States post office.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'state',
   @level2type = 'column', @level2name = 'code'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'state',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  statement extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'A document (paper or electronic) that comes from the bank once a calendar month that tells us everything that the bank thinks we have spent',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a statement record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'statementId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related account record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'accountId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related statementType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'statementTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The amount of money that was the accepted balance previously',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'previousBalance'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The date when the account was last balanced',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'previousBalanceDate'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The amount of money that the account should have in in it currently.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'currentBalance'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The date that the statement was created',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'date'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Total number of amounts subtracted from the account',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'totalDebits'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Generic domain for monetary amounts.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'totalCredits'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The end of the period that the statement is for',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'periodEndDate'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statement',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  statementItem extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'Items for a statement that represent transactions',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a statementItem record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'statementItemId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related statement record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'statementId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Date the item cleared the bank',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'date'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Alphanumeric "number" which identifies the item',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'number'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Description of the item',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'description'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The monetary value of the statementItem',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'amount'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related transactionType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'transactionTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementItem',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  statementType extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'domain of different statement type',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementType'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a statementType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementType',
   @level2type = 'column', @level2name = 'statementTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a statementType record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementType',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Brief, unstructured comments describing an instance of a table to further extend another user''s ability to tell statementType rows apart.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementType',
   @level2type = 'column', @level2name = 'description'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'statementType',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  transaction extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'A logical operation that puts in or takes out money from our account',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a transaction record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'transactionId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related account record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'accountId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Alphanumeric "number" which is usually an alternate key value for a record in a table. An example is an account number.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'number'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Default datetime values. Defaults to smalldatetime values since we will seldom need the precision of the datetime data type.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'date'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Brief, unstructured comments describing an instance of a table to further extend another user''s ability to tell transaction rows apart.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'description'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Generic domain for monetary amounts.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'amount'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Generic string values. We used this as the default where we did not know what the string was going to be used for. NOT NULL by default.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'signature'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related payee record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'payeeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related user record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'userId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related statementItem record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'statementItemId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related transactionType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'transactionTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transaction',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  transactionAllocation extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'used to have allocate parts of a transaction as to how it was used',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocation'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a transactionAllocation record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocation',
   @level2type = 'column', @level2name = 'transactionAllocationId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related transactionAllocationType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocation',
   @level2type = 'column', @level2name = 'transactionAllocationTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related transaction record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocation',
   @level2type = 'column', @level2name = 'transactionId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The amount of money to allocate with the transactionAllocation row',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocation',
   @level2type = 'column', @level2name = 'allocationAmount'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocation',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  transactionAllocationType extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'Different types of clasifications of transactions',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocationType'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a transactionAllocationType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocationType',
   @level2type = 'column', @level2name = 'transactionAllocationTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a transactionAllocationType record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocationType',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Brief, unstructured comments describing an instance of a table to further extend another user''s ability to tell transactionAllocationType rows apart.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocationType',
   @level2type = 'column', @level2name = 'description'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a transactionAllocationType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocationType',
   @level2type = 'column', @level2name = 'parentCheckUsageTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionAllocationType',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  transactionType extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'domain of possible transactions',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a transactionType record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType',
   @level2type = 'column', @level2name = 'transactionTypeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'The name that a transactionType record will be uniquely known as.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType',
   @level2type = 'column', @level2name = 'name'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Brief, unstructured comments describing an instance of a table to further extend another user''s ability to tell transactionType rows apart.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType',
   @level2type = 'column', @level2name = 'description'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to enforce rules on the transaction that force you to have a signature',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType',
   @level2type = 'column', @level2name = 'requiresSignatureFl'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to enforce rules on the transaction that force you to have a payee value',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType',
   @level2type = 'column', @level2name = 'requiresPayeeFl'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to enforce rules on the transaction that allow you to have a payee value',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType',
   @level2type = 'column', @level2name = 'allowPayeeFl'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'transactionType',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  user extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'system users that may make transactions',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'user'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a user record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'user',
   @level2type = 'column', @level2name = 'userId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to store the name of a user in the system.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'user',
   @level2type = 'column', @level2name = 'userName'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to store a person''s first name.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'user',
   @level2type = 'column', @level2name = 'firstName'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to store a person''s middle name.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'user',
   @level2type = 'column', @level2name = 'middleName'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Used to store a person''s last name.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'user',
   @level2type = 'column', @level2name = 'lastName'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'user',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  zipCode extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'Location code which is required in American addresses.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCode'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a zipCode record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCode',
   @level2type = 'column', @level2name = 'zipCodeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Five digit zip code that identifies a postal region that may span different cities, states, and may also simply identify a part of a city.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCode',
   @level2type = 'column', @level2name = 'zipCode'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCode',
   @level2type = 'column', @level2name = 'autoTimestamp'



-----------------------------------------------------------------------
--  zipCodeCityReference extended properties
-----------------------------------------------------------------------

EXEC sp_addextendedproperty @name = 'MS_Description',
   @value = 'used as a guide for allowing quick data entry by zip code.  Zip codes may span cities or even states.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCodeCityReference'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a row of a zipCodeCityReference record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCodeCityReference',
   @level2type = 'column', @level2name = 'zipCodeCityReferenceId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related city record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCodeCityReference',
   @level2type = 'column', @level2name = 'cityId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Auto generating identity column used as the pointer for a related zipCode record',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCodeCityReference',
   @level2type = 'column', @level2name = 'zipCodeId'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Bit flag that is used to point to the primary record of a group of cities for a zipCode',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCodeCityReference',
   @level2type = 'column', @level2name = 'primaryFl'

EXEC sp_addextendedproperty @name = 'MS_Description', 
   @value = 'Automatically incrementing optimistic locking value.',
   @level0type = 'User', @level0name = 'dbo', 
   @level1type = 'table', @level1name = 'zipCodeCityReference',
   @level2type = 'column', @level2name = 'autoTimestamp'





