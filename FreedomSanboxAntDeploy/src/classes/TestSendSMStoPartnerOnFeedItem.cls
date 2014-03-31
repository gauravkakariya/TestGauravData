/**
 
 */
@isTest(SeeAlldata = true)
private class TestSendSMStoPartnerOnFeedItem {
    static testMethod void myUnitTest() {
     Test.startTest();
     Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
     Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
     
     List<Account> lstAccount = new List<Account>();
     
    //Insert Account record
     Account objGeneralAccount = new Account(Name='Parner Account Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,
     Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
     Gold_Growth_Rate__c=10, Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60',
     RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(), Related_To__c='Virtual Partner',
     Alternate_Mobile__c = '4563215632');
     insert  objGeneralAccount;
     
	Account objVirtualAccount1 = new Account(LastName='Test BP',Adjustment_Factor__c='2',PAN_ID__pc='abcde4567M',
    PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463754637',
    Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',Email_Temp__c='abc@gmail.com',
    Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
    Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', 
    Plan_Generation_Date__c=system.today(),
    RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = false,
	Expected_Return_on_Investment__c= 1000,
    Income_Growth_Rate__c=0,
    Inflation_Rate__c=1,
    Number_Of_Months__c=1,
     Default_Retirement_Age__c ='60',
     Default_Estimated_Life_Expectancy__c='60',
     Stock_Growth_Rate__c=10,
     Gold_Growth_Rate__c=10,
     Company_Name__c ='Test Abc',
     Gold__c=10,Debt__c=10,
     Entity_Status__c= 'Active',
     Description ='test',
     Virtual_Partner__c = objGeneralAccount.Id);
     
  	 lstAccount.add(objVirtualAccount1);               
  	 insert lstAccount;
  		
  		System.debug('Account ================>'+[Select id,Virtual_Partner__c from Account where Id =: lstAccount[0].Id]);
  		
  		FeedItem objFeedItem = new FeedItem();
  		objFeedItem.Body = 'Testing Body';
  		objFeedItem.ParentId = objVirtualAccount1.Id;
  		objFeedItem.Type = FeedItemTrigger.TEXTPOST;
  		insert objFeedItem;
  		
  		Lead objLead = new Lead();
  		objLead.Virtual_Partner__c = objGeneralAccount.Id;
  		objLead.LastName = 'LastName';
  		objLead.MobilePhone = '4569852365';
  		insert objLead;
  		
  		FeedItem objFeedItem2 = new FeedItem();
  		objFeedItem2.Body = 'Testing Body';
  		objFeedItem2.ParentId = objLead.Id;
  		objFeedItem2.Type = FeedItemTrigger.TEXTPOST;
  		insert objFeedItem2;
  		
  		FeedComment objFeedComment = new FeedComment(CommentType='TextComment', CommentBody ='Test',FeedItemId = objFeedItem.Id);
  		insert objFeedComment;
  		
  		FeedComment objFeedComment2 = new FeedComment(CommentType='TextComment', CommentBody ='Test',FeedItemId = objFeedItem2.Id);
  		insert objFeedComment2;
  		
  		Test.stopTest();
    }
}