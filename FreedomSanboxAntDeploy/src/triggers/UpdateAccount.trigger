trigger UpdateAccount on Client_Details__c (after insert, after update) {
    Set<Id> entitySet = new Set<Id>();
    Set<Id> entityOwnerIdSet = new Set<Id>();
    List<Account> newAcc = new List<Account>();
    List<Account> updtList = new List<Account>();
    FamilyMemberInfoService fmservice = new FamilyMemberInfoService();
    Map<Id, Client_Details__c> mapCt = new Map<Id, Client_details__c>();
    Map<Id, Id> mapOwnerId = new Map<Id, Id>();

    if(trigger.isInsert){
        for(Integer i=0; i<trigger.new.size();i++){
            entityOwnerIdSet.add(trigger.new[i].Parent_Entity__c);
        }
        List<Account> accOwnerList = [Select Id, ownerId from Account where Id In: entityOwnerIdSet];
        for (Account acc: accOwnerList ){
            mapOwnerId.put(acc.Id,acc.ownerId);
        }
    }
    for(Integer i=0; i<trigger.new.size();i++){
        if(trigger.new[i].Entity__c!=null){
            entitySet.add(trigger.new[i].Entity__c);
            mapCt.put(trigger.new[i].Entity__c, trigger.new[i]);
        }else{
            Account accTmp = new Account();
            accTmp.FirstName = trigger.new[i].First_Name__c;
            accTmp.LastName = trigger.new[i].Last_Name__c;
            accTmp.Parent_Entity__c = trigger.new[i].Parent_Entity__c;
            if(mapOwnerId.get(trigger.new[i].Parent_Entity__c)!=null){
                accTmp.OwnerId = mapOwnerId.get(trigger.new[i].Parent_Entity__c);
            }
            accTmp.RecordTypeId = fmService.getPersonRecordType(Label.accountFamily).Record_Type_Value__c;
            newAcc.add(accTmp);
        }    
    }
    if(trigger.isInsert){
        if(newAcc.size()>0){
            insert newAcc;
        }
    }
    
    if(trigger.isUpdate){
        List<Account> accList = [Select FirstName, LastName,  Health_History_del__c from Account where Id In: entitySet];
        for (Account acc: accList){
            if(mapCt.get(acc.Id)!=null){
                Client_Details__c ct = mapCt.get(acc.Id);
                acc.FirstName = ct.First_Name__c;
                acc.LastName = ct.Last_Name__c;
                acc.BillingCity = ct.Billing_City__c;
                acc.BillingCountry = ct.Billing_Country__c;
                acc.BillingState = ct.Billing_State__c;
                acc.BillingStreet = ct.Billing_Street__c;
                acc.BillingPostalCode = ct.Billing_Zip_Postal_Code__c;
                acc.PersonBirthdate = ct.Date_Of_Birth__c;
                acc.PersonEmail = ct.Email__c;
                // ct.Employment_Information__c =  acc.
                acc.Gender__pc = ct.Gender__c;
                acc.Health_History_del__c = ct.Health_History__c;
                acc.PersonHomePhone = ct.Home_Phone__c;
                acc.PersonMailingCity = ct.Mailing_City__c;
                acc.PersonMailingCountry = ct.Mailing_Country__c;
                acc.PersonMailingState = ct.Mailing_State__c;
                acc.PersonMailingStreet = ct.Mailing_Street__c;
                acc.PersonMailingPostalCode = ct.Mailing_Zip_Postal_Code__c;
                acc.Marital_Status__pc = ct.Marital_Status__c;
                acc.Middle_Name__pc = ct.Middle_Name__c;
                acc.PersonMobilePhone = ct.Mobile__c;
                acc.PersonOtherCity = ct.Office_City__c;
                acc.PersonOtherCountry = ct.Office_Country__c;
                acc.PersonOtherState = ct.Office_State__c;
                acc.PersonOtherStreet = ct.Office_Street__c;
                acc.PersonOtherPostalCode = ct.Office_Zip_Postal_Code__c;
                acc.PAN_ID__pc = ct.Pan_Id__c;
                acc.Passport__pc = ct.Passport_Number__c;
                acc.Relationship_to_Entity__pc = ct.Relationship_to_Entity__c;
                acc.Will__c = ct.Will__c;
                // ct.Residential_Status__c =  acc.
                acc.Salutation = ct.Salutation__c;
                updtList.add(acc);
            }  
          
        }    
    
        if(updtList.size()>0){    
            update updtList;
        } 
    }   
}