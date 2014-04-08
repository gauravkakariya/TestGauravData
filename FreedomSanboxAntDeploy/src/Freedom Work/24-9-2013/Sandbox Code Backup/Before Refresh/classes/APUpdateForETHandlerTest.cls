/*
	Test class for APUpdateForETHandler Handler class of ActionPlanTrigger
 */
 
@isTest
private class APUpdateForETHandlerTest
{
	
    public static testMethod void testAP()
    {
    	
    	//testData();
	    test.startTest();
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest;												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest1;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, isExecutionTracker__c=true,AP_Status__c = 'Opened', 
  										  isSipExecutionTracker__c=true,Investment_Asset__c = objInvest.id);
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isExecutionTracker__c = false;
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET1;
      	objAP.isSipExecutionTracker__c = false;
      	update objAP;
      	test.stopTest();
      	
    }
    
    public static testMethod void testAP1()
    {
    	test.startTest();
    	ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest;												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest1;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		
    	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, isExecutionTracker__c=false, AP_Status__c = 'Opened', 
  										  isSipExecutionTracker__c=false,Investment_Asset__c = objInvest1.id);
      	insert objAP1;
      	Execution_Tracker__c objET2 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	insert objET2;
      	objAP1.isExecutionTracker__c = true;
      	Execution_Tracker__c objET3 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	insert objET3;
      	objAP1.isSipExecutionTracker__c = true;
      	update objAP1;
      	test.stopTest();
    }
    
    public static testMethod void testAP2()
    {
    	test.startTest();
    	ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest;												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest1;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		
    	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, isGSsip_ExecutionTracker__c=false, AP_Status__c = 'Opened', 
  										  isGS_ExecutionTracker__c=false,Investment_Asset__c = objInvest1.id);
      	insert objAP1;
      	Execution_Tracker__c objET2 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	insert objET2;
      	objAP1.isGS_ExecutionTracker__c = true;
      	Execution_Tracker__c objET3 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	insert objET3;
      	objAP1.isGSsip_ExecutionTracker__c = true;
      	update objAP1;
      	test.stopTest();
    }
    
    public static testMethod void testAP3()
    {
    	
    	//testData();
	    test.startTest();
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest;												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    insert objInvest1;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, isGSsip_ExecutionTracker__c=true,AP_Status__c = 'Opened', 
  										  isGS_ExecutionTracker__c=true,Investment_Asset__c = objInvest.id);
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isGS_ExecutionTracker__c = false;
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET1;
      	objAP.isGSsip_ExecutionTracker__c = false;
      	update objAP;
      	test.stopTest();
      	
    }
    
    public static testMethod void testAP4()
    {
    	
    	//testData();
	    test.startTest();
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
	    	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isLumpsumExecTracker__c=true, Item_Type__c = 'Lumpsum');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isLumpsumExecTracker__c = false;
      	update objAP;
      	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isSIPexecutionTracker__c=true, Item_Type__c = 'SIP');
      	insert objAP1;
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id);
      	insert objET1;
      	objAP.isSIPexecutionTracker__c = false;
      	update objAP1;
      	test.stopTest();
      	
    }
    
    public static testMethod void testAP5()
    {
    	
    	//testData();
	    test.startTest();
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
	    	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isLumpsumExecTracker__c=false, Item_Type__c = 'Lumpsum');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isLumpsumExecTracker__c = true;
      	update objAP;
      	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isSIPexecutionTracker__c=false, Item_Type__c = 'SIP');
      	insert objAP1;
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id);
      	insert objET1;
      	objAP.isSIPexecutionTracker__c = true;
      	update objAP1;
      	test.stopTest();
      	
    }
    
    public static testMethod void testAP6()
    {
    	
    	//testData();
	    test.startTest();
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
	    //WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'Life Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Life Insurance', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = true;
      	update objAP;
      	
      	test.stopTest();
      	
    }
    
    public static testMethod void testAP7()
    {
    	
    	//testData();
	    test.startTest();
	    
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'Recommended Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Recommended Insurance', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = true;
      	update objAP;
      	
      	test.stopTest();
    }
    
    public static testMethod void testAP8()
    {
    	
    	//testData();
	    test.startTest();
	    
	    //BB USer
		Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        User partnerUser = [select Id from User where profileid =: prof.id and IsActive = true limit 1];
        //insert partnerUser;
        
	    Account objBPAccount = new Account(LastName='Test BP',Adjustment_Factor__c='2', OwnerId = partnerUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Business Partner',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = false);
	    insert objBPAccount;
	    	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objBPAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objBPAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = partnerUser.Id,
															   		Financial_Planner__c = partnerUser.Id,
															   		Operations__c = partnerUser.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objBPAccount.id, AP_Status__c = 'Opened', 
  										  isInsuranceExecutionTracker__c=true, Item_Type__c = 'Recommended Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Recommended Insurance', Entity_Name__c = objBPAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = false;
      	update objAP;
      	
      	test.stopTest();
    }
    
    
    public static testMethod void testAP9()
    {
    	
    	//testData();
	    test.startTest();
	    
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', FirstName='abc', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'Recommended Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Recommended Insurance', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = true;
      	update objAP;
      	
      	test.stopTest();
    }
    
    public static testMethod void testAP10()
    {
    	
    	//testData();
	    test.startTest();
	    
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(LastName='Test Freedom', FirstName='abc', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount; 
	    	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'General Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'General Insurance', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = true;
      	update objAP;
      	
      	test.stopTest();
    }
}