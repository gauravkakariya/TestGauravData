@isTest
private class Test_CopyPlatformUserLeadDetails 
{
 /*   static testMethod void CopyPlatformUserLeadDetail() 
    {
    	test.startTest();

		//Need to comment below
		//====================================
    	Profile prof = [select id from profile where Name = 'Standard Platform User Custom' limit 1];
  	    ID PartnerProfileID =prof.id;
  	   
  	    User u11;
  	    {
    	    u11 = new User(Workstations__c = 'All', email='test-user@fakeemail.com',ProfileId = PartnerProfileID,UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
	        insert u11;
  	    }
  	    System.runAs(u11)
	    {
	  	 	Account partnerAcc=new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
	       	insert partnerAcc;
	  	 	List<Account> acc = [select id,Logo__c, Email_ID__c, Company_Address__c, Phone, Name from Account where RecordTypeId = :RecTypes__c.getInstance('General_Business').Record_Type_Value__c]; 
			//===============================
	    	list<Lead_Platform_User__c> lstLeads = 	new list<Lead_Platform_User__c>();
	    	Lead_Platform_User__c lead1 = new Lead_Platform_User__c(Virtual_Partner__c = acc[0].id,//Need to comment below 
	    								First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Converted', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
	    	insert lead1;
	    	lstLeads.add(lead1);
			lead1.Is_converted__c = true;
			upsert lead1;
			PlatformUserLeadDetailsController.hasAlreadyCreatedFollowUpTasks();
	    	PlatformUserLeadDetailsController.setAlreadyCreatedFollowUpTasks();
	    	
	    	list<Lead> Leadlst = new list<Lead>();
	    	Lead Lead_1 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898', Age__c = 23);
	    	insert Lead_1;
	    	Leadlst.add(Lead_1);
	  	}
	    test.stopTest();
    }
    
    static testMethod void CopyPlatformUserLeadDetailError() 
    {
    	test.startTest();
    	list<Lead_Platform_User__c> lstLeads = 	new list<Lead_Platform_User__c>();
    	Lead_Platform_User__c lead3 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Meeting Follow-up', Rating__c = 'Hot', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
    	insert lead3;
    	lstLeads.add(lead3);
    	
		try
        {
        	lead3.Do_Not_Call__c = true;
			lead3.Is_converted__c = false;
            upsert lead3;
        }
        catch(Exception e)
        {
        	Boolean expectedExceptionThrown =  e.getMessage().contains('My Error Message') ? true : false;
		//	System.AssertEquals(expectedExceptionThrown, true);
        }
		
		test.stopTest();
    }
    
    static testMethod void CopyPlatformUserLeadDetailUpdate()
    {
    	test.startTest();

		//Need to comment below
		//====================================	   
  	   Profile prof = [select id 
                      from profile 
                     where Name = 'Standard Platform User Custom' 
                     limit 1];
  	   ID PartnerProfileID =prof.id;
  	   User u1;
  	   u1 = new User(Workstations__c = 'All', email='test-user@fakeemail.com',ProfileId = PartnerProfileID,UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
       insert u1;
  	   System.runAs(u1)
		//====================================
  	   {
	    	list<Lead_Platform_User__c> lstLeads = 	new list<Lead_Platform_User__c>();
	    	Lead_Platform_User__c lead2 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Open', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
	    	insert lead2;
	    	lstLeads.add(lead2);
	    	lead2.Age__c = 44;
	    	/*Lead objRelatedStdLead = [select id from lead where Platform_User_Lead__c =: lead2.id];
	    	objRelatedStdLead.Age__c = 44;
	    	update objRelatedStdLead;*/
	   /* 	update lead2;
	
			PlatformUserLeadDetailsController.alreadyCreatedTasks = false;    	
	    	list<Lead> Leadlst1 = new list<Lead>();
	    	Lead Lead_11 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898', Age__c = 23);
	    	insert Lead_11;
	    	Leadlst1.add(Lead_11);
			Lead_11.Age__c = 34;
			update Lead_11;
			
			Lead_Platform_User__c lead22 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Converted', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
	    	insert lead22;
	    	lstLeads.add(lead22);
			//lead22.Is_converted__c = true;
			update lead22;
  	   }
  	   test.stopTest();
    }
    
    static testMethod void DeletePlatformUserLeadDetail()
    {
    	test.startTest();
    	list<Lead_Platform_User__c> lstLeads2 = new list<Lead_Platform_User__c>();
    	Lead_Platform_User__c lead3 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Open', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
    	insert lead3;
    	Lead_Platform_User__c lead4 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Open', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
    	insert lead4;
    	lstLeads2.add(lead3);
    	lstLeads2.add(lead4);
    	delete lead4;
    	test.stopTest();
    }*/
}