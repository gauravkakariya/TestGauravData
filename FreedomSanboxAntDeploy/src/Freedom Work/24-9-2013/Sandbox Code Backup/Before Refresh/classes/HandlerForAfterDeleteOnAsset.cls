public with sharing class HandlerForAfterDeleteOnAsset 
{
	public void afterDeleteAsset(list<Asset__c> lstAsset)
	{
		system.debug('************************81.1'+lstAsset);
		SyncDeletedRecords__c objSDR = null;
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(Asset__c objAsset : lstAsset)
	    {
	    	objSDR = new SyncDeletedRecords__c(); 
	    	objSDR.Sobject_ID__c = objAsset.ID;
	    	objSDR.Sync_DataTime__c  = objAsset.Synched_Date_Time__c;
	    	 objSDR.SObjectType__c = 'Asset__c';
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
      	  
          Asset__c objAsset = new Asset__c();
          objAsset.Account_Number__c = '126583';
          objAsset.Bank_Name__c = 'test Icici';
          objAsset.Entity__c = child.id;
          insert objAsset;
             
          test.startTest();
              delete objAsset;
          test.stopTest();
       }
	
}