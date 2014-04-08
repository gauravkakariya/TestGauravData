public with sharing class HandlerForAfterDeleteOnEntityGlobalAssum 
{
	public void afterDeleteEntityGlobalAssumption(list<Entity_Global_Assumption__c> lstEntityGlobalAssumption)
	{
		system.debug('************************81.1'+lstEntityGlobalAssumption);
		SyncDeletedRecords__c objSDR = new SyncDeletedRecords__c();
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(Entity_Global_Assumption__c objEntityGlobalAssumption : lstEntityGlobalAssumption)
	    {
	    	objSDR.Sobject_ID__c = objEntityGlobalAssumption.ID;
	    	objSDR.Sync_DataTime__c  = objEntityGlobalAssumption.Synched_Date_Time__c;
	    	objSDR.SObjectType__c = 'Entity_Global_Assumption__c';
	    } 	
	    insert objSDR;
	
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
      	  
      	  Entity_Global_Assumption__c objEntityGA = new Entity_Global_Assumption__c();
      	  objEntityGA.Name = 'test';
      	  objEntityGA.Account__c = child.Id;
      	  insert objEntityGA;
       
          test.startTest();
              delete objEntityGA;
          test.stopTest();
       }

}