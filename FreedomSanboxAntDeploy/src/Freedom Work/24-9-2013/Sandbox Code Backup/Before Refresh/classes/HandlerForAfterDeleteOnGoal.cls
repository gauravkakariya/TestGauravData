public with sharing class HandlerForAfterDeleteOnGoal 
{
	public void afterDeleteGoal(list<Goal__c> lstGoal)
	{
		system.debug('************************81.1'+lstGoal);
		SyncDeletedRecords__c objSDR = null;
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(Goal__c objGoal : lstGoal)
	    {
	    	objSDR = new SyncDeletedRecords__c();
	    	objSDR.Sobject_ID__c = objGoal.ID;
	    	objSDR.Sync_DataTime__c  = objGoal.Synched_Date_Time__c;
	    	objSDR.SObjectType__c = 'Goal__c';
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
      	  
      	  Goal__c objGoal = new Goal__c();
      	  objGoal.Entity__c = child.id;
      	  objGoal.Accumulated_Amount__c = 21256454;
      	 // objFinAccount.Account__c = child.id;
      	     insert objGoal;
      	  
      	  
       
          test.startTest();
              delete objGoal;
          test.stopTest();
       }
}