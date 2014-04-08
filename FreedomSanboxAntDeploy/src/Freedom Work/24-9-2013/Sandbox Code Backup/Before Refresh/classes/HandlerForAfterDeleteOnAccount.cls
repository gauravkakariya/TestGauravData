public with sharing class HandlerForAfterDeleteOnAccount 
{
	public void afterDeleteAccount(list<Account> lstAccount)
	{
		system.debug('************************81.1'+lstAccount);
		SyncDeletedRecords__c objSDR = null;
		
	    list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(Account objAccount : lstAccount)
	    {
	    	objSDR = new SyncDeletedRecords__c();
	    	objSDR.Sobject_ID__c = objAccount.ID;
	    	objSDR.Sync_DataTime__c  = objAccount.Synched_Date_Time__c;
	    	objSDR.SObjectType__c = 'Account';
	    	
	    	lstSDR.add(objSDR);
	    } 
	    if(!lstSDR.isEmpty())	
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
      	  
       
          test.startTest();
          system.debug('**Debug Account='+ child);
          delete child;
          delete parent;
              
          test.stopTest();
       }
}