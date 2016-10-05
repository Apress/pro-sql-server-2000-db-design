ALTER TABLE account 
       ADD CONSTRAINT bank$offers$account FOREIGN KEY (bankId)
               REFERENCES bank


ALTER TABLE accountReconcile 
       ADD CONSTRAINT statement$is_used_to_reconcile__account_via$accountReconcile FOREIGN KEY (statementId)
               REFERENCES statement


ALTER TABLE address 
       ADD CONSTRAINT city$identifies_location_of$address FOREIGN KEY (cityId)
               REFERENCES city


ALTER TABLE address 
       ADD CONSTRAINT zipCode$identifies_mailing_region_of$address FOREIGN KEY (zipCodeId)
               REFERENCES zipCode


ALTER TABLE city 
       ADD CONSTRAINT state$identifies_location_of$city FOREIGN KEY (stateId)
               REFERENCES state


ALTER TABLE payeeAddress 
       ADD CONSTRAINT addressType$describes_type_of$payeeAddress FOREIGN KEY (addressTypeId)
               REFERENCES addressType


ALTER TABLE payeeAddress 
       ADD CONSTRAINT address$is_mapped_to_a__payee_via$payeeAddress FOREIGN KEY (addressId)
               REFERENCES address


ALTER TABLE payeeAddress 
       ADD CONSTRAINT payee$is_mapped_to_an_address_via$payeeAddress FOREIGN KEY (payeeId)
               REFERENCES payee


ALTER TABLE payeePhoneNumber 
       ADD CONSTRAINT phoneNumberType$describes_type_of$payeePhoneNumber FOREIGN KEY (phoneNumberTypeId)
               REFERENCES phoneNumberType


ALTER TABLE payeePhoneNumber 
       ADD CONSTRAINT payee$is_mapped_to_a__phoneNumber_via$payeePhoneNumber FOREIGN KEY (payeeId)
               REFERENCES payee


ALTER TABLE payeePhoneNumber 
       ADD CONSTRAINT phoneNumber$is_mapped_to_a_payee_via$payeePhoneNumber FOREIGN KEY (phoneNumberId)
               REFERENCES phoneNumber

ALTER TABLE statement 
       ADD CONSTRAINT account$is_kept_up_to_date_with_records_in$statement FOREIGN KEY (accountId)
               REFERENCES account

ALTER TABLE statement 
       ADD CONSTRAINT statementType$classifies$statement FOREIGN KEY (statementTypeId)
               REFERENCES statementType

ALTER TABLE statementItem 
       ADD CONSTRAINT transactionType$classifies$statementItem FOREIGN KEY (transactionTypeId)
               REFERENCES transactionType

ALTER TABLE statementItem 
       ADD CONSTRAINT statement$has_items_in$statementItem FOREIGN KEY (statementId)
               REFERENCES statement

ALTER TABLE [transaction]
       ADD CONSTRAINT transactionType$classifies$transaction FOREIGN KEY (transactionTypeId)
               REFERENCES transactionType

ALTER TABLE [transaction] 
       ADD CONSTRAINT payee$is_issued_funds_via$transaction FOREIGN KEY (payeeId)
               REFERENCES payee

ALTER TABLE [transaction] 
       ADD CONSTRAINT user$modifies_the_account_balance_via_issing$transaction FOREIGN KEY (userId)
               REFERENCES [user]

ALTER TABLE [transaction] 
       ADD CONSTRAINT statementItem$is_used_to__reconcile$transaction FOREIGN KEY (statementItemId)
               REFERENCES statementItem

ALTER TABLE [transaction] 
       ADD CONSTRAINT account$transfers_funds_by_entering$transaction FOREIGN KEY (accountId)
               REFERENCES account


ALTER TABLE transactionAllocation 
       ADD CONSTRAINT transaction$has_allocation_information_stored_in$transactionAllocation FOREIGN KEY (transactionId)
               REFERENCES [transaction] 


ALTER TABLE transactionAllocation 
       ADD CONSTRAINT transactionAllocationType$categorizes_a_check_via$transactionAllocation FOREIGN KEY (transactionAllocationTypeId)
               REFERENCES transactionAllocationType


ALTER TABLE transactionAllocationType 
       ADD CONSTRAINT transactionAllocationType$is_a$transactionAllocationType FOREIGN KEY (parentCheckUsageTypeId)
               REFERENCES transactionAllocationType


ALTER TABLE zipCodeCityReference 
       ADD CONSTRAINT city$is_mapped_to_possible_zipCodes_via$zipCodeCityReference FOREIGN KEY (cityId)
               REFERENCES city

ALTER TABLE zipCodeCityReference 
       ADD CONSTRAINT zipCode$is_mapped_to_possible__cities_via$zipCodeCityReference FOREIGN KEY (zipCodeId)
               REFERENCES zipCode

