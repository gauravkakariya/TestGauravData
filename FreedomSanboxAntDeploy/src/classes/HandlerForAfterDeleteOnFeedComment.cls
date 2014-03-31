public with sharing class HandlerForAfterDeleteOnFeedComment 
{
	public void afterDeleteFeedComment(list<FeedComment> lstFeedComment)
	{
		system.debug('************************81.1'+lstFeedComment);
		SyncDeletedRecords__c objSDR = null;
		
	     list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
	     
	    for(FeedComment objFeedComment : lstFeedComment)
	    {
	    	objSDR = new SyncDeletedRecords__c();
	    	objSDR.Sobject_ID__c = objFeedComment.ID;
	    	//objSDR.Sync_DataTime__c  = objFeedComment.
	    	objSDR.SObjectType__c = 'FeedComment';
	    	
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
      	  
      	  FeedItem objFeedItem = new FeedItem();
      	  objFeedItem.Title = 'for test';
      	    objFeedItem.Body = 'hello this is test';
      	    objFeedItem.ParentId = child.Id;
      	  insert objFeedItem;
      	  
      	  FeedComment objFeedComment = new FeedComment();
      	  objFeedComment.CommentBody = 'test';
      	  objFeedComment.FeedItemId = objFeedItem.Id;
      	  //objFeedComment.ParentId = child.Id ;
      	  insert objFeedComment;
       
          test.startTest();
              delete objFeedComment;
          test.stopTest();
       }
	
}