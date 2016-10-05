
ALTER TABLE transactionType
ADD CONSTRAINT dfltTransactionType$requiresSignatureFl$bit$false 
DEFAULT 0 FOR requiresSignatureFl

ALTER TABLE transactionType
ADD CONSTRAINT dfltTransactionType$requiresPayeeFl$bit$false 
DEFAULT 0 FOR requiresPayeeFl

ALTER TABLE transactionType
ADD CONSTRAINT dfltTransactionType$allowPayeeFl$bit$true
DEFAULT 1 FOR allowPayeeFl



ALTER TABLE phoneNumber
ADD CONSTRAINT dfltPhoneNumber$countryCode$string$charNumberOne
DEFAULT '1' FOR countryCode

ALTER TABLE phoneNumber
ADD CONSTRAINT dfltPhoneNumber$areaCode$string$localAreaCode
DEFAULT '615' FOR areaCode
