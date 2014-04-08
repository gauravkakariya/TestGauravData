/**
 * This class contains unit tests for validating the behavior of SendSMStoPartnerOnFeedComment class
 * and triggers.

*/
@isTest(seeAllData=true)
private class TestSendSMStoPartnerOnFeedComment {

    static testMethod void SendSMStoPartnerOnFeedCommentTest()
    {
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	/*List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
    	RecTypes__c objRecType = new RecTypes__c(Name='General_Business', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
    	RecTypes__c objRecType1 = new RecTypes__c(Name='AccountFamily', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
    	RecTypes__c objRecType2 = new RecTypes__c(Name='AccountClient', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
    	
    	lstRecTypes.add(objRecType);										 
    	lstRecTypes.add(objRecType1);
    	lstRecTypes.add(objRecType2);	
    	insert lstRecTypes;
    	*/
    	/*FeedCommentTrigger__c objFeedCommentTrigger = new FeedCommentTrigger__c(Name='FeedCommentTrigger',
																			    	SendSMStoPartnerOnFeedComment__c=true,
																			    	SendSMStoPartnerOnFeedItem__c =true);
    	insert objFeedCommentTrigger;
    	*/
    	List<Account> lstAccount = new List<Account>();
    	
    	//Insert smagicbasic SMS Template record 
    	/*List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Chatter Comment', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Chatter Comment Lead', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	*/
    	//Insert Account record
    	Account objGeneralAccount = new Account(Name='Parner Account Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,
									Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
									Gold_Growth_Rate__c=10,	Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60', 
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(), Related_To__c='Ffreedom');
    	insert  objGeneralAccount;						
    	
    	Account objVirtualAccount = new Account(Name='Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,Alternate_Mobile__c='1234567890',
									Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
									Gold_Growth_Rate__c=10,	Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60', 
									RecordTypeId = RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(),Related_To__c ='Virtual Partner');
    	
       
 		insert objVirtualAccount;
         Account objVirtualAccount1 = new Account(LastName='Test BP',Adjustment_Factor__c='2',PAN_ID__pc='abcde4567M',
		                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463754637',
		                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',Email_Temp__c='abc@gmail.com',
		                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
		                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Virtual Partner', 
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
		                       virtual_partner__c = objVirtualAccount.Id);
		insert  objVirtualAccount1;                 
		lstAccount.add(objVirtualAccount);                               
	    lstAccount.add(objVirtualAccount1);               
		//insert lstAccount;
		
		Lead objLead = new Lead(FirstName='FirstName', LastName='LastName',
    							Occupation__c='Student',Location__c='Agra',
    							MobilePhone='9876543210', Street='S.V.Road',
    							City='Agra',PostalCode='400053',
    							State='MahaRashtra',Country='india',
    							Email='rupesh@gmail.com',
    							Company='TestCompany',Status='Open',LeadSource='Web',
    							virtual_partner__c = objVirtualAccount.Id);
		insert objLead; 
		
		FeedItem objFeedItem = new FeedItem(Type='TextPost',Body='Test',ParentId = objVirtualAccount1.Id);
		insert objFeedItem;
		FeedComment objFeedComment = new FeedComment(CommentType='TextComment', CommentBody ='Test',FeedItemId=objFeedItem.Id);
		insert objFeedComment;
		FeedItem objFeedItemLead = new FeedItem(Type='TextPost',Body='Test',ParentId = objLead.Id);
		insert objFeedItemLead;
		FeedComment objFeedCommentLead = new FeedComment(CommentType='TextComment', CommentBody ='Test',FeedItemId=objFeedItem.Id);
		insert objFeedCommentLead;
        
    }
}