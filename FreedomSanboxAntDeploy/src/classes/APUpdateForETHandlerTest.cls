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
	    List<Investment_Asset__c> lstInv = new List<Investment_Asset__c>();
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest);												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest1);
	    insert lstInv;
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
    	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Lumpsum_Action__c='STP To',Account__c = objAccount.id, isExecutionTracker__c=false, AP_Status__c = 'Opened', 
  										  isSipExecutionTracker__c=false,Investment_Asset__c = objInvest.id,SIP_Action__c = 'Continue',SIP_Action_Amount__c=2000);
      	lstAP.add(objAP1);
      	Approve_Action_Plan__c objAP2 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Lumpsum_Action__c='STP To',Account__c = objAccount.id, isExecutionTracker__c=false, AP_Status__c = 'Opened', 
  										  isSipExecutionTracker__c=false,Investment_Asset__c = objInvest1.id,SIP_Action__c = 'Continue',SIP_Action_Amount__c=2000);
      	lstAP.add(objAP2);
  	  	Approve_Action_Plan__c objAP3 = new Approve_Action_Plan__c(Amount__c = 20000,Period_in_Months__c = 22,Item_Type__c = 'Fixed Deposit',Goal_Type__c = 'Test',
  	  									  Product_Name__c ='Regular Deposits',Account__c = objAccount.id, isAddOnExecutionTracker__c=true, AP_Status__c = 'Opened', 
  	  									  Insured__c ='Tarak Lad');
      	lstAP.add(objAP3);
  	  	Approve_Action_Plan__c objAP4 = new Approve_Action_Plan__c(Amount__c = 20000,Period_in_Months__c = 22,Item_Type__c = 'Loan',Goal_Type__c = 'Test',
  	  									  Product_Name__c ='HDFC - Personal Loan',Account__c = objAccount.id, isAddOnExecutionTracker__c=true, AP_Status__c = 'Opened', 
  	  									  Insured__c ='Tarak Lad',Loan_Type__c = 'Personal Loan');
      	lstAP.add(objAP4);
  	  	Approve_Action_Plan__c objAP5 = new Approve_Action_Plan__c(Amount__c = 20000,Period_in_Months__c = 22,Item_Type__c = 'Bond',Goal_Type__c = 'Test',
  	  									  Product_Name__c ='Tax Free bond Dec 2013 - I',Account__c = objAccount.id, isAddOnExecutionTracker__c=true, AP_Status__c = 'Opened', 
  	  									  Insured__c ='Tarak Lad',Bond_Type__c = 'Bond type');
      	lstAP.add(objAP5);
      	insert lstAP;
      	Execution_Tracker__c objET2 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	lstET.add(objET2);
      	Execution_Tracker__c objET4 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP2.id,Owner__c = workObjId);
      	lstET.add(objET4);
      	
      	Execution_Tracker__c objET5 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Loan', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP3.id,Owner__c = workObjId);
      	lstET.add(objET5);
      	Execution_Tracker__c objET6 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Fixed Deposit', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP4.id,Owner__c = workObjId);
      	lstET.add(objET6);
      	Execution_Tracker__c objET7 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Bond', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP5.id,Owner__c = workObjId);
      	lstET.add(objET7);
      	objAP1.isExecutionTracker__c = true;
      	objAP1.Action_Amount__c = 3000;
      	objAP1.Lumpsum_Action__c='STP From';
      	objAP1.SIP_Action__c = 'Stop';
      	objAP1.SIP_Action_Amount__c = 3000;
      	update objAP1;
      	test.stopTest();
    }
    
    public static testMethod void testAP1_1()
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
	    List<Investment_Asset__c> lstInv = new List<Investment_Asset__c>();
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest);												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest1);
	    insert lstInv;
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
    	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Lumpsum_Action__c='STP To',Account__c = objAccount.id, isExecutionTracker__c=false, AP_Status__c = 'Opened', 
  										  isSipExecutionTracker__c=false,Investment_Asset__c = objInvest.id,SIP_Action__c = 'Continue',SIP_Action_Amount__c=2000);
      	lstAP.add(objAP1);
      	insert lstAP;
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	lstET.add(objET1);
      	insert lstET;
      	objAP1.isSipExecutionTracker__c = true;
      	objAP1.Action_Amount__c = 3000;
      	objAP1.Lumpsum_Action__c='STP From';
      	objAP1.SIP_Action__c = 'Stop';
      	objAP1.SIP_Action_Amount__c = 3000;
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
  										  Category__c='Debt', Lumpsum_Action__c='STP To',Account__c = objAccount.id, isGSsip_ExecutionTracker__c=false, AP_Status__c = 'Opened', 
  										  isGS_ExecutionTracker__c=false,Investment_Asset__c = objInvest1.id,SIP_Action__c = 'Continue',SIP_Action_Amount__c=2000);
      	insert objAP1;
      	Execution_Tracker__c objET2 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	insert objET2;
      	Execution_Tracker__c objET4 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	insert objET4;
      	objAP1.isGS_ExecutionTracker__c = true;
      	objAP1.Action_Amount__c = 3000;
      	objAP1.Lumpsum_Action__c='STP From';
      	objAP1.SIP_Action__c = 'Stop';
      	objAP1.SIP_Action_Amount__c = 3000;
      	update objAP1;
      	test.stopTest();
    }
    public static testMethod void testAP2_1()
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
  										  Category__c='Debt', Lumpsum_Action__c='STP To',Account__c = objAccount.id, isGSsip_ExecutionTracker__c=false, AP_Status__c = 'Opened', 
  										  isGS_ExecutionTracker__c=false,Investment_Asset__c = objInvest1.id,SIP_Action__c = 'Continue',SIP_Action_Amount__c=2000);
      	insert objAP1;
      	
      	Execution_Tracker__c objET3 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	insert objET3;
      	objAP1.isGSsip_ExecutionTracker__c = true;
      	objAP1.Action_Amount__c = 3000;
      	objAP1.Lumpsum_Action__c='STP From';
      	objAP1.SIP_Action__c = 'Stop';
      	objAP1.SIP_Action_Amount__c = 3000;
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
		List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
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
      	lstAP.add(objAP);
      	//update objAP;
    	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isSIPexecutionTracker__c=true, Item_Type__c = 'SIP');
      	insert objAP1;
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id);
      	insert objET1;
      	objAP1.isSIPexecutionTracker__c = false;
      	//update objAP1;
      	lstAP.add(objAP1);
      	update lstAP;
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
		List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isLumpsumExecTracker__c=false, Item_Type__c = 'Lumpsum',Product_Name__c = 'BSL Savings');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Lumpsum', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isLumpsumExecTracker__c = true;
      	objAP.Product_Name__c = 'Pramerica Ultra Short Term';
      	objAP.Amount__c = 30000;
      	objAP.Transaction_Type__c = 'Lumpsum';
      	objAP.Installments__c = 33;
      	objAP.Category__c = 'Gold';
      	objAP.Option__c = 'Dividend';
      	objAP.Remarks__c = 'test';
      	objAP.Fund__c = 'ddd';
      	objAP.Amount_Per_Installment__c = 100;
      	lstAP.add(objAP);
      	//update objAP;
      	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isSIPexecutionTracker__c=false, Item_Type__c = 'SIP',Product_Name__c = 'BSL Savings');
      	insert objAP1;
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'SIP', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id);
      	insert objET1;
      	objAP1.isSIPexecutionTracker__c = true;
      	objAP1.Product_Name__c = 'Pramerica Ultra Short Term';
      	objAP1.Amount__c = 30000;
      	objAP1.Transaction_Type__c = 'Lumpsum';
      	objAP1.Installments__c = 33;
      	objAP1.Category__c = 'Gold';
      	objAP1.Option__c = 'Dividend';
      	objAP1.Remarks__c = 'test';
      	lstAP.add(objAP1);
  		update lstAP;
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
		Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
      	Insurance__c insurance1 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId(),Policy_Number__c = 'sss');
	    insert insurance1;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', Insurance__c = insurance1.Id,
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'Surrender Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Surrender Insurance', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = true;
      	update objAP;
      	
      	test.stopTest();
      	
    }
     public static testMethod void testAP6_1()
    {
    	
    	//testData();
	    test.startTest();
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
		Account objAccount = new Account(FirstName='Test Freedom', LastName='Test Freedom',Adjustment_Factor__c='2', OwnerId = userobj.Id,
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
		Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
      	Insurance__c insurance1 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId(),Policy_Number__c = 'sss');
	    insert insurance1;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', Insurance__c = insurance1.Id,
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'Surrender Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Surrender Insurance', Entity_Name__c = objAccount.id,
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
    
  public static testMethod void testAP8()
    {
    	
    	//testData();
	    test.startTest();
	    ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
		insert userobj;
	    TestData_Ffreedom testData = new TestData_Ffreedom();
	    Account objGeneralAccount = testData.init_GeneralAccount();
	    objGeneralAccount.Channel_Manager__c = userobj.Id;
	    insert objGeneralAccount;
	    Contact objBizContact = testData.init_BizContact(objGeneralAccount);
	    insert objBizContact; 
	    User partnerUser = testData.initBusinessUser(objBizContact);
	    insert partnerUser;           
        system.debug('--------partnerUser---ss-----'+partnerUser);
      	
        Account objBPAccount = testData.initBusinessAccount(partnerUser);
        insert objBPAccount;
        objBPAccount.Related_To__c = 'Business Partner';
        update objBPAccount;
	    	    
	    Goal__c objEmergencyGoal = new Goal__c(Entity__c=objBPAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	insert objEmergencyGoal;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objBPAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
      	Insurance__c insurance1 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objBPAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId(),Policy_Number__c = 'sss');
	    insert insurance1;
      	Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objBPAccount.id, AP_Status__c = 'Opened',Insurance__c =  insurance1.Id,
  										  isInsuranceExecutionTracker__c=true, Item_Type__c = 'Surrender Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Surrender Insurance', Entity_Name__c = objBPAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = false;
      	update objAP;
      	
      	test.stopTest();
    }
     /* 
    
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
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'Life Insurance');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Life Insurance', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = true;
      	update objAP;
      	
      	test.stopTest();
    }*/
    
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
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', Sum_Assured_Rs__c = 10000,Policy_Type__c = 'Critical Illness',
  										  isInsuranceExecutionTracker__c=true, Item_Type__c = 'General Insurance',Insured__c = objAccount.Name,
  										  Premium_Amount_Rs__c = 10000,Product_Name__c = 'Bajaj Allianz Health Guard');
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'General Insurance', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP.id);
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = false;
      	objAP.Sum_Assured_Rs__c = 20000;
      	objAP.Insured__c = 'Test';
      	objAP.Policy_Type__c = 'Medical';
      	objAP.Product_Name__c = 'Bajaj Allianz Critical Illness';
      	objAP.Premium_Amount_Rs__c = 20000;
      	update objAP;
      	
      	test.stopTest();
    }
    
    public static testMethod void testAP11()
    {
    	
    	//testData();
	    test.startTest();
	    
	    Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
	    Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
    	//Insert Life Insurace Product record
        Product_Master__c objProduct2 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Axis Life Insurance', ProductType__c='Life Insurance'
                                                            ,Policy_Type__c='Term Life');
        insert  objProduct2; 
	    
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
      	
      	Insurance__c insurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId(),Policy_Number__c = 'sss');
	    insert insurance1;
	    
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
      	/*Approve_Action_Plan__c objAP = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test LI',  Amount__c = 20000,Goal__c = objEmergencyGoal.id,
  										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
  										  Category__c='Debt', Account__c = objAccount.id, AP_Status__c = 'Opened', 
  										  isInsuranceExecutionTracker__c=false, Item_Type__c = 'Life Insurance');
  		*/								  
  		Approve_Action_Plan__c objAP= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,Premium_Amount_Rs__c = 10000,
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened'); 								  
      	insert objAP;
      	Execution_Tracker__c objET = new Execution_Tracker__c(Approve_Action_Plan__c = objAP.id,Agreed_Amount__c =3000, Executed_Amount__c=100, 
      																Entity_Name__c = objAccount.Id, Type__c='Life Insurance', 
      																ET_Status__c='Assigned to Operations', Executed_Product_Name__c='Axis Life Insurance');
      		
      	insert objET;
      	objAP.isInsuranceExecutionTracker__c = false;
      	objAP.Sum_Assured_Rs__c = 20000;
      	objAP.Policy_Name__c = 'ICICI Lombard Health Protect Plus';
      	objAP.Premium_Amount_Rs__c = 20000;
      	objAP.Tenure_of_Insurance__c =12;
      	update objAP;
      	
      	test.stopTest();
    }
    public static testMethod void testAP12()
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
	    List<Investment_Asset__c> lstInv = new List<Investment_Asset__c>();
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest);												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest1);
	    insert lstInv;
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
  	  	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Amount__c = 20000,Period_in_Months__c = 22,Item_Type__c = 'Fixed Deposit',Goal_Type__c = 'Test',
  	  									  Product_Name__c ='Regular Deposits',Account__c = objAccount.id, isAddOnExecutionTracker__c=false, AP_Status__c = 'Opened', 
  	  									  Insured__c ='Tarak Lad');
      	lstAP.add(objAP1);
  	  	insert lstAP;
      	
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Fixed Deposit', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	lstET.add(objET1);
      	insert lstET;
      	objAP1.isAddOnExecutionTracker__c = true;
      	objAP1.Amount__c = 3000;
      	objAP1.Product_Name__c='Mahindra Finance Commulative';
      	objAP1.Period_in_Months__c = 36;
      	objAP1.Goal_Type__c = 'Test1';
      	objAP1.Insured__c = 'Sangita Lad';
      	update objAP1;
      	test.stopTest();
    }
    	public static testMethod void testAP13()
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
	    List<Investment_Asset__c> lstInv = new List<Investment_Asset__c>();
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest);												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest1);
	    insert lstInv;
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
    	
  	  	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Amount__c = 20000,Period_in_Months__c = 22,Item_Type__c = 'Bond',Goal_Type__c = 'Test',
  	  									  Product_Name__c ='Tax Free bond Dec 2013 - I',Account__c = objAccount.id, isAddOnExecutionTracker__c=false, AP_Status__c = 'Opened', 
  	  									  Insured__c ='Tarak Lad',Bond_Type__c = 'Bond type');
      	lstAP.add(objAP1);
      	insert lstAP;
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Bond', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	lstET.add(objET1);
      	insert lstET;
      	objAP1.isAddOnExecutionTracker__c = true;
      	objAP1.Amount__c = 3000;
      	objAP1.Product_Name__c='Tax Free bond Dec 2013 - II';
      	objAP1.Goal_Type__c = 'Test1';
      	objAP1.Bond_Type__c = 'Test1';
      	objAP1.Insured__c = 'Sangita Lad';
      	update objAP1;
      	test.stopTest();
    }
    	public static testMethod void testAP14()
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
	    List<Investment_Asset__c> lstInv = new List<Investment_Asset__c>();
	    Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest);												
	    Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',
	    												RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
	    lstInv.add(objInvest1);
	    insert lstInv;
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = userobj.Id,
															   		Financial_Planner__c = userobj.Id,
															   		Operations__c = userobj.Id);
		insert objWorkstation;
		Id workObjId = objWorkstation.Member_Engagement__c;
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
    	
  	  	Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Amount__c = 20000,Period_in_Months__c = 22,Item_Type__c = 'Loan',Goal_Type__c = 'Test',
  	  									  Product_Name__c ='HDFC - Personal Loan',Account__c = objAccount.id, isAddOnExecutionTracker__c=false, AP_Status__c = 'Opened', 
  	  									  Insured__c ='Tarak Lad',Loan_Type__c = 'Personal Loan');
      	lstAP.add(objAP1);
  	  	
      	insert lstAP;
      	
      	
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
  										  Option__c = 'Growth', Agreed_Amount__c = 2000,Type__c = 'Loan', Entity_Name__c = objAccount.id,
  										  Approve_Action_Plan__c = objAP1.id,Owner__c = workObjId);
      	lstET.add(objET1);
      	insert lstET;
      	objAP1.isAddOnExecutionTracker__c = true;
      	objAP1.Amount__c = 3000;
      	objAP1.Product_Name__c='Axis - Commercial Purchase';
      	objAP1.Goal_Type__c = 'Test1';
      	objAP1.Loan_Type__c = 'Home Loan';
      	objAP1.Insured__c = 'Sangita Lad';
      	update objAP1;
      	test.stopTest();
    }
    
}