public with sharing class HandlerForAfterDeleteOnFeedItem 
{
	public void afterDeleteFeedItem(list<FeedItem> lstFeedItem)
	{
		system.debug('************************81.1'+lstFeedItem);
		SyncDeletedRecords__c objSDR = null;
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(FeedItem objFeedItem : lstFeedItem)
	    {
	    	objSDR = new SyncDeletedRecords__c();
	    	objSDR.Sobject_ID__c = objFeedItem.ID;
	    	//objSDR.Sync_DataTime__c  = objFeedItem.Synched_Date_Time__c;
	    	objSDR.SObjectType__c = 'FeedItem';
	    	lstSDR.add(objSDR);
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
      	  
      	  FeedItem objFeedItem = new FeedItem();
      	  objFeedItem.Title = 'for test';
      	    objFeedItem.Body = 'hello this is test';
      	    objFeedItem.ParentId = child.Id;
      	  insert objFeedItem;
      	  
      	 
       
          test.startTest();
              delete objFeedItem;
          test.stopTest();
       }
}