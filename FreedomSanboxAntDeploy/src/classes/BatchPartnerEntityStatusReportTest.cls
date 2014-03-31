public class BatchPartnerEntityStatusReportTest 
{
    public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
	@isTest
	public static void testBatchBusinessPartnerStatusReport() 
	{
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	//Insert RecordType record
    	List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
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
    	
    	//Insert smagicbasic SMS Template record 
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	
		
		
		ID profileID = [Select id from Profile where name = 'Financial Planner'].id;
		UserRole ur1 = [select Id, Name from UserRole where Name = 'RESEARCH'];
      	User objUser = new User(email='aditi.satpute@eternussolutions.com', profileid = profileID, UserName='test1-user@fakeemail1.com', 
      	 							alias='tuser11',TimeZoneSidKey='America/New_York',userroleid = ur1.id,
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname11',
      	 						    LastName = 'Test_Parent_Lname11' );
        insert objUser;
        
             
        //Insert Account record
    	Account objBPAccount = new Account(Name='Parner Account Test', Channel_Manager__c= objUser.Id, OwnerId = objUser.Id,
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objBPAccount;
    	
    	objBPAccount.Related_To__c = 'Business Partner';
	    update objBPAccount;
	    
    	Contact objContact = new Contact(FirstName = 'aaa',LastName = 'bbb', AccountId=objBPAccount.id);
		insert objContact;
    	
        Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        UserRole ur = [select Id, Name from UserRole where Name = 'Abhishek Shah Partner User'];
        system.debug('****ur**'+ur);
	   	User objUser1 = new User(email='aditi.satpute@eternussolutions.com', profileid = prof.Id,IsActive = true, ContactId = objContact.id, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser1', TimeZoneSidKey='America/New_York',//userroleid = ur.id,
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
	    insert objUser1;
	    
		//RecordType objRT = [Select Id from RecordType where Name = 'General' and SobjectType = 'Account'];
		
		Lead Lead_11 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',Email = 'aa@gmail.com', LeadSource = 'Web', MobilePhone = '9898989898', Age__c = 23
	    	                        ,Related_To__c = 'Business Partner', OwnerId= objUser1.Id);
	    	                        
	    insert Lead_11;  
	                   
	    Campaign cmp1 = new Campaign(Name = 'Just Dial');
        insert cmp1;	        
	    CampaignMember campMem = new CampaignMember(CampaignId = cmp1.Id, LeadId=Lead_11.Id);	  
	   	insert campMem; 
	   	
    	
		/*
		Account objBPAccount = new Account(Name ='Test BP',Adjustment_Factor__c='2', OwnerId = objUser.Id,
	                       Estimated_Life_EndYear__c=2041,Related_To__c ='Business Partner',Email_ID__c = 'aditi.satpute@eternussolutions.com',
	                       RecordTypeId =RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
 		insert objBPAccount;
 		*/
	   
	     
		Test.startTest();
		
		BatchBusinessPartnerStatusReport objbatchProcess =new BatchBusinessPartnerStatusReport();
        Database.executeBatch(objbatchProcess);
        
		Test.stopTest();
		String jobId = System.schedule('testBatchPartnerStatusReport',CRON_EXP, new SchedularForBusinessPartnerStatusReport());
	}
	
	@isTest
	public static void testBatchVirtualPartnerStatusReport() 
	{
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	//Insert RecordType record
    	List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
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
    	
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	
		Test.startTest();
		ID profileID1 = [Select id from Profile where name = 'Financial Planner'].id;
      	User objUser1 = new User(Email='aditi.satpute@eternussolutions.com', profileid = profileID1, UserName='test1-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser11',TimeZoneSidKey='America/New_York',
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname11',
      	 						    LastName = 'Test_Parent_Lname11' );
        insert objUser1; 
		ID profileID = [Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(Email='aditi.satpute@eternussolutions.com', profileid = profileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York',ManagerId = objUser1.Id,
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser; 
		//RecordType objRT = [Select Id from RecordType where Name = 'General' and SobjectType = 'Account'];
		//RecordType objRT1 = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		
		 //Insert Account record
    	Account objBPAccount1 = new Account(Name='Parner Account Test', Channel_Manager__c= objUser.Id, OwnerId = objUser.Id,
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objBPAccount1;
    	
		List<Account> lstAcc = new List<Account>();
    	Account objBPAccount = new Account(Name ='Test BP',Adjustment_Factor__c='2', OwnerId = objUser.Id,Channel_Manager__c= objUser.Id,
	                       Estimated_Life_EndYear__c=2041,Related_To__c ='Virtual Partner',Email_ID__c = 'aditi.satpute@eternussolutions.com',
	                       RecordTypeId = RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
 		lstAcc.add(objBPAccount);
 		insert lstAcc;
	    objBPAccount.Related_To__c = 'Virtual Partner';
	    update objBPAccount; 
	    
       	Account clientEntity = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',
       														Virtual_Partner__c = objBPAccount.Id,RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Tribal_Activity_Flag__c=False);
    	insert clientEntity;
		Lead Lead_11 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',Email = 'aa@gmail.com', LeadSource = 'Web', MobilePhone = '9898989898', Age__c = 23,
	    	                        Virtual_Partner__c = objBPAccount.id );
	    insert Lead_11;                 
	    Campaign cmp1 = new Campaign(Name = 'Just Dial');
        insert cmp1;	        
	    CampaignMember campMem = new CampaignMember(CampaignId = cmp1.Id, LeadId=Lead_11.Id);	  
	   	insert campMem;      
		
		BatchVirtualPartnerStatusReport objbatchProcess =new BatchVirtualPartnerStatusReport();
        Database.executeBatch(objbatchProcess);
        Test.stopTest();
        String jobId = System.schedule('testBatchPartnerLeadStatusReport',CRON_EXP, new SchedularForVirtualPartnerStatusReport());
	}
	
}