public with sharing class HandlerForAfterDeleteOnContact {
    
    public void afterDeleteContact(list<Contact> lstContact)
    {
        system.debug('************************81.1'+lstContact);
        SyncDeletedRecords__c objSDR = null;
        
         list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
         
        for(Contact objContact : lstContact)
        {
        	objSDR = new SyncDeletedRecords__c();
            objSDR.Sobject_ID__c = objContact.ID;
            objSDR.SObjectType__c = 'Contact';
            objSDR.Sync_DataTime__c  = objContact.LastModifiedDate;
            lstSDR.add(objSDR);
        }   
        insert lstSDR; 
    
    }
    @IsTest(seealldata = true)  
      public static void testCoverage() 
      {
      	 TestData_Ffreedom testData = new TestData_Ffreedom();
      	 Account parent = new Account();
          parent = testData.initializeAccount();
          insert parent;
          Account child = new Account(); 
          child = testData.init_FamilyMember(parent);
          child.Portal_Id__c = '1';
          insert child;
      	  
      	  Contact objContact = new Contact();
      	  objContact.LastName = 'test';
      	  insert objContact;
       
          test.startTest();
              delete objContact;
          test.stopTest();
       }

}