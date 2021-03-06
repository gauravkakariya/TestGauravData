public with sharing class HandlerForAfterDeleteOnInsurance 
{
	public void afterDeleteInsurance(list<Insurance__c> lstInsurance)
	{
		
		SyncDeletedRecords__c objSDR = null;
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(Insurance__c objInsurance : lstInsurance)
	    {
	    	objSDR = new SyncDeletedRecords__c();
	    	objSDR.Sobject_ID__c = objInsurance.ID;
	        objSDR.SObjectType__c = 'Insurance__c';
	    	objSDR.Sync_DataTime__c  = objInsurance.Synched_Date_Time__c;
	    	
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
      	  
      	  Insurance__c objInsurance = new Insurance__c();
      	  objInsurance.Entity__c = child.id;
      	  objInsurance.Company_Name__c = 'test company';
      	 // objFinAccount.Account__c = child.id;
      	     insert objInsurance;
      	     
      	     
      	            test.startTest();
              delete objInsurance;
          test.stopTest();
      }
}