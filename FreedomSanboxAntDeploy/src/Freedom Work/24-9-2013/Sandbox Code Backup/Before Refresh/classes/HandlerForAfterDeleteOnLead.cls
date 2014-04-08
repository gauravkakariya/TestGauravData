public with sharing class HandlerForAfterDeleteOnLead 
{
	public void afterDeleteLead(list<Lead> lstLead)
	{
		system.debug('************************81.1'+lstLead);
		SyncDeletedRecords__c objSDR = null;
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(Lead objLead : lstLead)
	    {
	    	objSDR = new SyncDeletedRecords__c();
	    	objSDR.Sobject_ID__c = objLead.ID;
	    	objSDR.Sync_DataTime__c  = objLead.Synched_Date_Time__c;
	    	objSDR.SObjectType__c = 'Lead';
	    	
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
      	  
      	  Lead objlead = new Lead();
      	  
      	  objlead.LastName = 'test';
      	 // objFinAccount.Account__c = child.id;
      	     insert objlead;
      	     
      	     
      	            test.startTest();
              delete objlead;
          test.stopTest();
      }
	
	
}