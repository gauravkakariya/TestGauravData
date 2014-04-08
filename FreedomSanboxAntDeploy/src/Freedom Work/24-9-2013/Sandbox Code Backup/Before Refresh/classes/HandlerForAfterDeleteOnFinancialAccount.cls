public with sharing class HandlerForAfterDeleteOnFinancialAccount 
{
	public void afterDeleteFinancialAccount(list<Financial_Account__c> lstFinancialAccount)
	{
		system.debug('************************81.1'+lstFinancialAccount);
		SyncDeletedRecords__c objSDR = null;
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(Financial_Account__c objFinancialAccount : lstFinancialAccount)
	    {
	    	objSDR = new SyncDeletedRecords__c();
	    	objSDR.Sobject_ID__c = objFinancialAccount.ID;
	    	objSDR.Sync_DataTime__c  = objFinancialAccount.Synched_Date_Time__c;
	    	objSDR.SObjectType__c = 'Financial_Account__c';
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
      	  
      	  Financial_Account__c objFinAccount = new Financial_Account__c();
      	  objFinAccount.Bank_Name__c = 'for test';
      	  objFinAccount.Account__c = child.id;
      	     insert objFinAccount;
      	  
      	  
       
          test.startTest();
              delete objFinAccount;
          test.stopTest();
       }
}