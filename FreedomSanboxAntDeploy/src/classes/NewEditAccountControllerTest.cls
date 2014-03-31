/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 
 */
@isTest
private class NewEditAccountControllerTest {
/*
   @isTest
    public static void businessUnitTest() 
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	
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
    											 
    	List<Business_Unit__c> lstBU = new List<Business_Unit__c>();
    	Business_Unit__c objBU1 = new Business_Unit__c(Short_Code__c ='BU1', Name = 'Business Unit 1');
    	Business_Unit__c objBU2 = new Business_Unit__c(Short_Code__c ='BU2', Name = 'Business Unit 2');
    	lstBU.add(objBU1);
    	lstBU.add(objBU2);
    	insert lstBU;
    	
    	
    	
    	List<Account> lstVirtualAcc = new List<Account>();
    	Account virtualAcc1 = testData.initVirtualAccount();
    	virtualAcc1.Business_Unit__c = objBU1.Id;
    	lstVirtualAcc.add(virtualAcc1);
    	
    	Account virtualAcc2 = testData.initVirtualAccount();
    	virtualAcc2.Business_Unit__c = objBU2.Id;
    	lstVirtualAcc.add(virtualAcc2);
    	insert lstVirtualAcc;
    	
    	Account objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
	    insert objAccount;
	    
		Test.startTest();   
		PageReference pageRef = Page.NewEditAccount;
	    pageRef.setRedirect(true);
	     
	    ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',objAccount.Id); 
	   
	    ApexPages.StandardController std = new ApexPages.StandardController(objAccount);        
        NewEditAccountController objNewEditAccountController	 = new NewEditAccountController(std);
       
        objNewEditAccountController.saveAccount();
        objNewEditAccountController.cancel();
       
        Test.stopTest();
    	
	   
	    objAccount.Business_Unit__c = objBU2.Id;
	    objAccount.Virtual_Partner__c = virtualAcc2.Id;
	    update objAccount;
	    
    }
   */ 
    public static User objUser1;
    public static User objUser2;
    public static Business_Unit__c objBU1;
    public static Business_Unit__c objBU2;
    public static Department__c objDept1;
    public static Department__c objDept2;
    public static Department__c objDept3;
    public static Department__c objDept4;
    public static Team_Member__c objTM1;
    public static Team_Member__c objTM2;
    public static Team_Member__c objTM3;
    public static Team_Member__c objTM4;
    
    public static Team_Member__c objPSTM1;
    public static Team_Member__c objMSTTM2;
    public static Team_Member__c objFPATM3;
    public static Team_Member__c objMST2TM4;
    
    public static Account virtualAcc1;
    public static Account virtualAcc2;
    
    public static TestData_Ffreedom testData;
    
    @isTest
    public static void TestData() 
    {
    	testData = new TestData_Ffreedom();
    	
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
    	
    	objUser1 = testData.initializeUser();
    	objUser1.UserName ='test-user@fakeemail.com';
    	objUser1.FirstName = 'Test_Parent_Fname2';
    	objUser1.LastName = 'Test_Parent_Lname3';
    	objUser1.CommunityNickname = 'tuser2';
    	objUser1.Alias = 'tuser12';
    	objUser1.email ='usertest-user@fakeemail1.com';
    	insert objUser1;
    	
    	objUser2 = testData.initializeUser();
    	objUser2.UserName ='test23-user@fakeemail.com';
    	objUser2.FirstName = 'Test_Parent_Fname23';
    	objUser2.LastName = 'Test_Parent_Lname23';
    	objUser2.CommunityNickname = 'tuser23';
    	objUser2.Alias = 'tuser123';
    	objUser2.email ='usertest-user@fakeemail123.com';
    	insert objUser2;
    	
    	objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	objDept1 = testData.init_Department('PST', objBU1.Id);
    	objDept2 = testData.init_Department('MST', objBU1.Id);
    	objDept3 = testData.init_Department('FPA', objBU1.Id);
    	objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	
    	objPSTM1 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	objMSTTM2 = testData.init_Team_Member(objUser2.Id, objDept2.Id);
    	objFPATM3 = testData.init_Team_Member(objUser2.Id, objDept3.Id);
    	objMST2TM4 = testData.init_Team_Member(objUser2.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	
    	lstTeam_Member.add(objPSTM1);
    	lstTeam_Member.add(objMSTTM2);
    	lstTeam_Member.add(objFPATM3);
    	lstTeam_Member.add(objMST2TM4);
    	
    	insert lstTeam_Member;
    	
    	List<Account> lstVirtualAcc = new List<Account>();
    	
    	virtualAcc1 =  new Account( Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(),
							    	Business_Unit__c = objBU1.Id,
							    	PST_Team_Member__c = objTM1.Id,
							    	MST_Team_Member__c = objTM2.Id,
							    	FPA_Team_Member__c = objTM3.Id,
							    	OPS_Team_Member__c = objTM4.Id);
    	
    	lstVirtualAcc.add(virtualAcc1);
    	insert lstVirtualAcc;
	    
	    Test.startTest();   
		PageReference pageRef = Page.NewEditAccount;
	    pageRef.setRedirect(true);
	     
	    ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',virtualAcc1.Id); 
	   
	    ApexPages.StandardController std = new ApexPages.StandardController(virtualAcc1);        
        NewEditAccountController objNewEditAccountController = new NewEditAccountController(std);
        
        objNewEditAccountController.accountObj.PST_Team_Member__c = objPSTM1.Id;
        objNewEditAccountController.accountObj.MST_Team_Member__c = objMSTTM2.Id;
        
        objNewEditAccountController.accountObj.FPA_Team_Member__c = objFPATM3.Id;
        objNewEditAccountController.accountObj.OPS_Team_Member__c = objMST2TM4.Id;
        
        
        //virtualAcc1.PST_Team_Member__c = objPSTM1.Id;
		//virtualAcc1.MST_Team_Member__c = objMSTTM2.Id;
		//virtualAcc1.FPA_Team_Member__c = objFPATM3.Id;
		//virtualAcc1.OPS_Team_Member__c = objMST2TM4.Id;
		objNewEditAccountController.getClientandLeadCount();
        objNewEditAccountController.saveAccount();
        objNewEditAccountController.cancel();
        
        NewEditAccountController objNewEditAccountController1 = new NewEditAccountController();
        objNewEditAccountController1.cancel();
        
        
        Test.stopTest();
        
	   
    }
    
    
      
    @isTest
    public static void clienteNTest() 
    {
    	testData = new TestData_Ffreedom();
    	
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
    	
    	
    	objUser1 = testData.initializeUser();
    	objUser1.UserName ='test-user@fakeemail.com';
    	objUser1.FirstName = 'Test_Parent_Fname2';
    	objUser1.LastName = 'Test_Parent_Lname3';
    	objUser1.CommunityNickname = 'tuser2';
    	objUser1.Alias = 'tuser12';
    	objUser1.email ='usertest-user@fakeemail1.com';
    	insert objUser1;
    	
    	objUser2 = testData.initializeUser();
    	objUser2.UserName ='test23-user@fakeemail.com';
    	objUser2.FirstName = 'Test_Parent_Fname23';
    	objUser2.LastName = 'Test_Parent_Lname23';
    	objUser2.CommunityNickname = 'tuser23';
    	objUser2.Alias = 'tuser123';
    	objUser2.email ='usertest-user@fakeemail123.com';
    	insert objUser2;
    	
    	objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	objDept1 = testData.init_Department('PST', objBU1.Id);
    	objDept2 = testData.init_Department('MST', objBU1.Id);
    	objDept3 = testData.init_Department('FPA', objBU1.Id);
    	objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	
    	objPSTM1 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	objMSTTM2 = testData.init_Team_Member(objUser2.Id, objDept2.Id);
    	objFPATM3 = testData.init_Team_Member(objUser2.Id, objDept3.Id);
    	objMST2TM4 = testData.init_Team_Member(objUser2.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	
    	lstTeam_Member.add(objPSTM1);
    	lstTeam_Member.add(objMSTTM2);
    	lstTeam_Member.add(objFPATM3);
    	lstTeam_Member.add(objMST2TM4);
    	
    	insert lstTeam_Member;
    	
    	List<Account> lstVirtualAcc = new List<Account>();
    	virtualAcc1 = virtualAcc1 =  new Account( Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(),
							    	Business_Unit__c = objBU1.Id,
							    	PST_Team_Member__c = objTM1.Id,
							    	MST_Team_Member__c = objTM2.Id,
							    	FPA_Team_Member__c = objTM3.Id,
							    	OPS_Team_Member__c = objTM4.Id);
    	
    	lstVirtualAcc.add(virtualAcc1);
    	insert lstVirtualAcc;
    	
    	
    	Account objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	///objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	insert objAccount;
    	
    	Account objFamilyMember = new Account(FirstName='PQR',LastName='XYZ',
    								Parent_Entity__c=objAccount.id,
	  								RecordTypeId=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
	  								
	  	insert objFamilyMember; 
	  	
	  								
    	Test.startTest();
    	
    	ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',objAccount.Id); 
	   
	    ApexPages.StandardController std1 = new ApexPages.StandardController(objAccount);        
        NewEditAccountController objNewEditAccountController2 = new NewEditAccountController(std1);
        objNewEditAccountController2.saveAccount();
    
    
    	ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',objFamilyMember.Id); 
	    
	    ApexPages.StandardController std2 = new ApexPages.StandardController(objFamilyMember);        
        NewEditAccountController objNewEditAccountController3 = new NewEditAccountController(std2);
        objNewEditAccountController3.saveAccount();
	    
    	Test.stopTest();
    	
    	system.assertNotEquals(objTM1.Id, objAccount.PST_Team_Member__c);
    }
    
     @isTest
    public static void influeNTest() 
    {
    	testData = new TestData_Ffreedom();
    	
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
    	
    	
    	objUser1 = testData.initializeUser();
    	objUser1.UserName ='test-user@fakeemail.com';
    	objUser1.FirstName = 'Test_Parent_Fname2';
    	objUser1.LastName = 'Test_Parent_Lname3';
    	objUser1.CommunityNickname = 'tuser2';
    	objUser1.Alias = 'tuser12';
    	objUser1.email ='usertest-user@fakeemail1.com';
    	insert objUser1;
    	
    	objUser2 = testData.initializeUser();
    	objUser2.UserName ='test23-user@fakeemail.com';
    	objUser2.FirstName = 'Test_Parent_Fname23';
    	objUser2.LastName = 'Test_Parent_Lname23';
    	objUser2.CommunityNickname = 'tuser23';
    	objUser2.Alias = 'tuser123';
    	objUser2.email ='usertest-user@fakeemail123.com';
    	insert objUser2;
    	
    	objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	objDept1 = testData.init_Department('PST', objBU1.Id);
    	objDept2 = testData.init_Department('MST', objBU1.Id);
    	objDept3 = testData.init_Department('FPA', objBU1.Id);
    	objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	
    	objPSTM1 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	objMSTTM2 = testData.init_Team_Member(objUser2.Id, objDept2.Id);
    	objFPATM3 = testData.init_Team_Member(objUser2.Id, objDept3.Id);
    	objMST2TM4 = testData.init_Team_Member(objUser2.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	
    	lstTeam_Member.add(objPSTM1);
    	lstTeam_Member.add(objMSTTM2);
    	lstTeam_Member.add(objFPATM3);
    	lstTeam_Member.add(objMST2TM4);
    	
    	insert lstTeam_Member;
    	
    	List<Account> lstVirtualAcc = new List<Account>();
    	virtualAcc1 = virtualAcc1 =  new Account( Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(),
							    	Business_Unit__c = objBU1.Id,
							    	PST_Team_Member__c = objTM1.Id,
							    	MST_Team_Member__c = objTM2.Id,
							    	FPA_Team_Member__c = objTM3.Id,
							    	OPS_Team_Member__c = objTM4.Id);
    	
    	lstVirtualAcc.add(virtualAcc1);
    	insert lstVirtualAcc;
    	
    	
    	Account objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	///objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	insert objAccount;
    	
    	Account objInfluencer = new Account(FirstName='PQR',LastName='XYZ',
    								Parent_Entity__c=objAccount.id,
	  								RecordTypeId=RECORD_TYPE_INFO_MAP.get('Influencers').getRecordTypeId());
	  								
	  	insert objInfluencer; 
	  	
	  								
    	Test.startTest();
    	
	    
	    ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Influencers').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',objInfluencer.Id); 
	    
	    ApexPages.StandardController std3 = new ApexPages.StandardController(objInfluencer);        
        NewEditAccountController objNewEditAccountController4 = new NewEditAccountController(std3);
        objNewEditAccountController4.saveAccount();
    	Test.stopTest();
    	
    	//system.assertNotEquals(objTM1.Id, objAccount.PST_Team_Member__c);
    }
    	
    	/*
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
    	
    	
    	ID ProfileID = [ Select Id from Profile where name = 'Financial Planner'].Id;
      	User objUser = new User(email='test-user@fakeemail15.com', profileid = ProfileID, UserName='test1-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser101',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname15',
      	 						    LastName = 'Test_Parent_Lname15' );

        insert objUser;
        
        Business_Unit__c objBusinessUnit = getBusinessUnit();
    	insert objBusinessUnit;
    	
    	//List<Department__c> lstDeparment = getDepartment(objBusinessUnit.Id);
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
     	Department__c objDeparment1 = new Department__c(Name = 'PSTDept1',Type_of_Department__c='PSTDep', Business_Unit__c = objBusinessUnit.Id );
     	Department__c objDeparment2 = new Department__c(Name = 'MSTDept1',Type_of_Department__c='MSTDept', Business_Unit__c = objBusinessUnit.Id  );
     	Department__c objDeparment3 = new Department__c(Name = 'MST2Dept1',Type_of_Department__c='MST2Dept', Business_Unit__c = objBusinessUnit.Id  );
        Department__c objDeparment4 = new Department__c(Name = 'FPADept1',Type_of_Department__c='FPADept', Business_Unit__c = objBusinessUnit.Id );
     	
     	lstDepartment.add(objDeparment1);
     	lstDepartment.add(objDeparment2);
     	lstDepartment.add(objDeparment3);
     	lstDepartment.add(objDeparment4);	
     	
        insert lstDepartment;
        
        List<Team_Member__c> lstTeamMember = new List<Team_Member__c>();
       	List<User>  lstUser = new List<User>();
     	
      	User objUser4 = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test12-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser31',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
      	 						    
      	User objUser1 = new User(email='test1-user@fakeemail2.com', profileid = ProfileID, UserName='test2-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser32',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname2',
      	 						    LastName = 'Test_Parent_Lname2' ); 	
      	 						    
      	User objUser2 = new User(email='test1-user@fakeemail3.com', profileid = ProfileID, UserName='test3-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser33',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname3',
      	 						    LastName = 'Test_Parent_Lname3' ); 	
      	 						    
      	User objUser3 = new User(email='test1-user@fakeemail4.com', profileid = ProfileID, UserName='test4-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser34',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname4',
      	 						    LastName = 'Test_Parent_Lname24' ); 	
      	 						     						     						    					    
        lstUser.add(objUser4);
        lstUser.add(objUser1);
        lstUser.add(objUser2);
        lstUser.add(objUser3); 
        
        insert lstUser;
        
     	Team_Member__c objTeamMember1 = new Team_Member__c(Department__c = objDeparment1.Id, Status__c= 'Active', Team_Member__c= objUser4.Id);
     	Team_Member__c objTeamMember2 = new Team_Member__c(Department__c = objDeparment2.Id, Status__c= 'Active',  Team_Member__c= objUser1.Id);
     	Team_Member__c objTeamMember3 = new Team_Member__c(Department__c = objDeparment3.Id, Status__c= 'Active',  Team_Member__c= objUser2.Id); //, Team_Member__c= objUser2.Id);
     	Team_Member__c objTeamMember4 = new Team_Member__c(Department__c = objDeparment4.Id, Status__c= 'Active',  Team_Member__c= objUser3.Id);//,Team_Member__c= objUser3.Id);
     	
     	lstTeamMember.add(objTeamMember1);
     	lstTeamMember.add(objTeamMember2);
     	lstTeamMember.add(objTeamMember3);
     	lstTeamMember.add(objTeamMember4);
     	
       // List<Team_Member__c> lstTeamMember = getTeamMember(lstDeparment[0].Id, lstDeparment[1].Id, lstDeparment[2].Id, lstDeparment[3].Id);
        insert lstTeamMember;
        
        
        List<Account> lstAccount = new List<Account>();  
         
    	//Insert Account record
    	Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(),
    								Business_Unit__c= objBusinessUnit.Id, 
			                        MST_Team_Member__c = objTeamMember2.id,
			                        FPA_Team_Member__c = objTeamMember4.id,
			                        OPS_Team_Member__c = objTeamMember3.id,
			                        PST_Team_Member__c = objTeamMember1.id);
    								
        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = objUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true, 
	                       
	                       Business_Unit__c= objBusinessUnit.Id, 
	                       MST_Team_Member__c = lstTeamMember[1].id,
	                       FPA_Team_Member__c = lstTeamMember[3].id,
	                       OPS_Team_Member__c = lstTeamMember[2].id,
	                       PST_Team_Member__c = lstTeamMember[0].id);
	    
	   lstAccount.add(objAccount1);
	   lstAccount.add(objGeneralAccount);               
	   //insert lstAccount;   
	    
	   Test.startTest();   
	   PageReference pageRef = Page.NewEditAccount;
       pageRef.setRedirect(true);
	     
	   ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId()); 
	   ApexPages.currentPage().getParameters().put('id',objAccount1.Id); 
	   
	   ApexPages.StandardController std = new ApexPages.StandardController(objAccount1);        
       NewEditAccountController objNewEditAccountController	 = new NewEditAccountController(std);
       
       objNewEditAccountController.saveAccount();
       objNewEditAccountController.cancel();
       
       Test.stopTest();
       
       
    }
    
     //Create Require Data for Account
     private static Account getAccount(){
    	
    	return new Account(LastName='Test LastName', 
    					   Entity_Status__c ='Active',
    					   Phone='123',
    					   Age__c = 23,
    					   PersonEmail = 'abc@gmail.com',
    					   Agreement_Received__c ='Yes',
    					   Category_Description__c ='Test');
     }	
     
     private static Business_Unit__c getBusinessUnit()
     {
     	Business_Unit__c objBusinessUnit = new Business_Unit__c(Name = 'BussinessUnit1', Short_Code__c= 'BU1',Business_Unit_Name__c='BussinessUnit1');
     	return objBusinessUnit;
     }
     
     private static List<Department__c> getDepartment(Id businessUnitId)
     {
     	List<Department__c> lstDepartment = new List<Department__c>();
     	Department__c objDeparment1 = new Department__c(Name = 'PSTDept1',Type_of_Department__c='PSTDep', Business_Unit__c = businessUnitId );
     	Department__c objDeparment2 = new Department__c(Name = 'MSTDept1',Type_of_Department__c='MSTDept', Business_Unit__c = businessUnitId );
     	Department__c objDeparment3 = new Department__c(Name = 'MST2Dept1',Type_of_Department__c='MST2Dept', Business_Unit__c = businessUnitId );
        Department__c objDeparment4 = new Department__c(Name = 'FPADept1',Type_of_Department__c='FPADept', Business_Unit__c = businessUnitId );
     	
     	lstDepartment.add(objDeparment1);
     	lstDepartment.add(objDeparment2);
     	lstDepartment.add(objDeparment3);
     	lstDepartment.add(objDeparment4);	
     	
     	return 	lstDepartment;
     				
     }
     
     private static List<Team_Member__c> getTeamMember(Id departmentPSTId, Id departmentMSTId, Id departmentMST2Id, Id departmentFPAId)
     {
     	List<Team_Member__c> lstTeamMember = new List<Team_Member__c>();
       	List<User>  lstUser = new List<User>();
     	ID ProfileID = [ Select Id from Profile where name = 'Financial Planner'].Id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test1-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser31',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
      	 						    
      	User objUser1 = new User(email='test1-user@fakeemail2.com', profileid = ProfileID, UserName='test2-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser32',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-4',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname2',
      	 						    LastName = 'Test_Parent_Lname2' ); 	
      	 						    
      	User objUser2 = new User(email='test1-user@fakeemail3.com', profileid = ProfileID, UserName='test3-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser33',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-3',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname3',
      	 						    LastName = 'Test_Parent_Lname3' ); 	
      	 						    
      	User objUser3 = new User(email='test1-user@fakeemail4.com', profileid = ProfileID, UserName='test4-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser34',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-2',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname4',
      	 						    LastName = 'Test_Parent_Lname24' ); 	
      	 						     						     						    					    
        lstUser.add(objUser);
        lstUser.add(objUser1);
        lstUser.add(objUser2);
        lstUser.add(objUser3); 
        
        //insert lstUser;
        
     	Team_Member__c objTeamMember1 = new Team_Member__c(Department__c = departmentPSTId, Status__c= 'Active' ,Team_Member__c= objUser.Id);
     	Team_Member__c objTeamMember2 = new Team_Member__c(Department__c = departmentMSTId, Status__c= 'Active' ,Team_Member__c= objUser1.Id);
     	Team_Member__c objTeamMember3 = new Team_Member__c(Department__c = departmentMST2Id, Status__c= 'Active', Team_Member__c= objUser2.Id);
     	Team_Member__c objTeamMember4 = new Team_Member__c(Department__c = departmentFPAId, Status__c= 'Active',Team_Member__c= objUser3.Id);
     	
     	lstTeamMember.add(objTeamMember1);
     	lstTeamMember.add(objTeamMember2);
     	lstTeamMember.add(objTeamMember3);
     	lstTeamMember.add(objTeamMember4);
     	
     	return lstTeamMember;
     }
     */
     
      @isTest
    public static void clientEntitiesForErrorTest() 
    {
    	testData = new TestData_Ffreedom();
    	
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
    	
    	
    	objUser1 = testData.initializeUser();
    	objUser1.UserName ='test-user@fakeemail.com';
    	objUser1.FirstName = 'Test_Parent_Fname2';
    	objUser1.LastName = 'Test_Parent_Lname3';
    	objUser1.CommunityNickname = 'tuser2';
    	objUser1.Alias = 'tuser12';
    	objUser1.email ='usertest-user@fakeemail1.com';
    	insert objUser1;
    	
    	objUser2 = testData.initializeUser();
    	objUser2.UserName ='test23-user@fakeemail.com';
    	objUser2.FirstName = 'Test_Parent_Fname23';
    	objUser2.LastName = 'Test_Parent_Lname23';
    	objUser2.CommunityNickname = 'tuser23';
    	objUser2.Alias = 'tuser123';
    	objUser2.email ='usertest-user@fakeemail123.com';
    	insert objUser2;
    	
    	objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	objDept1 = testData.init_Department('PST', objBU1.Id);
    	objDept2 = testData.init_Department('MST', objBU1.Id);
    	objDept3 = testData.init_Department('FPA', objBU1.Id);
    	objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	
    	objPSTM1 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	objMSTTM2 = testData.init_Team_Member(objUser2.Id, objDept2.Id);
    	objFPATM3 = testData.init_Team_Member(objUser2.Id, objDept3.Id);
    	objMST2TM4 = testData.init_Team_Member(objUser2.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	
    	lstTeam_Member.add(objPSTM1);
    	lstTeam_Member.add(objMSTTM2);
    	lstTeam_Member.add(objFPATM3);
    	lstTeam_Member.add(objMST2TM4);
    	
    	insert lstTeam_Member;
    	try{
    	
	    	List<Account> lstVirtualAcc = new List<Account>();
	    	virtualAcc1 = virtualAcc1 =  new Account( Name='Parner Account Test',
	    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(),
								    	Business_Unit__c = objBU1.Id,
								    	PST_Team_Member__c = objTM1.Id,
								    	MST_Team_Member__c = objTM2.Id,
								    	FPA_Team_Member__c = objTM3.Id,
								    	OPS_Team_Member__c = objTM4.Id);
	    	
	    	lstVirtualAcc.add(virtualAcc1);
	    	insert lstVirtualAcc;
	    	
	    	Account objAccount = testData.initializeAccount();
	    	objAccount.Business_Unit__c = objBU1.Id;
	    	objAccount.PST_Team_Member__c = objTM2.Id;
			objAccount.MST_Team_Member__c = objTM1.Id;
			objAccount.FPA_Team_Member__c = objTM3.Id;
			objAccount.OPS_Team_Member__c = objTM3.Id;
	    	insert objAccount;
	    	
	    	Account objFamilyMember = new Account(FirstName='PQR',LastName='XYZ',
								Parent_Entity__c=objAccount.id,
  								RecordTypeId=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
	  								
	  		insert objFamilyMember; 
	    	
    	Test.startTest();
    	
    	ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',objAccount.Id); 
	   
	    ApexPages.StandardController std1 = new ApexPages.StandardController(objAccount);        
        NewEditAccountController objNewEditAccountController2 = new NewEditAccountController(std1);
        objNewEditAccountController2.saveAccount();
    
    
    	ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',objFamilyMember.Id); 
	    
	    ApexPages.StandardController std2 = new ApexPages.StandardController(objFamilyMember);        
        NewEditAccountController objNewEditAccountController3 = new NewEditAccountController(std2);
        objNewEditAccountController3.saveAccount();
	    
    	Test.stopTest();
    	}
    	catch(Exception e)
    	{
    		
    	}
    }
    
     @isTest
    public static void clientEntityTest() 
    {
    	testData = new TestData_Ffreedom();
    	
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
    	
    	
    	objUser1 = testData.initializeUser();
    	objUser1.UserName ='test-user@fakeemail.com';
    	objUser1.FirstName = 'Test_Parent_Fname2';
    	objUser1.LastName = 'Test_Parent_Lname3';
    	objUser1.CommunityNickname = 'tuser2';
    	objUser1.Alias = 'tuser12';
    	objUser1.email ='usertest-user@fakeemail1.com';
    	insert objUser1;
    	
    	objUser2 = testData.initializeUser();
    	objUser2.UserName ='test23-user@fakeemail.com';
    	objUser2.FirstName = 'Test_Parent_Fname23';
    	objUser2.LastName = 'Test_Parent_Lname23';
    	objUser2.CommunityNickname = 'tuser23';
    	objUser2.Alias = 'tuser123';
    	objUser2.email ='usertest-user@fakeemail123.com';
    	insert objUser2;
    	
    	objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	objDept1 = testData.init_Department('PST', objBU1.Id);
    	objDept2 = testData.init_Department('MST', objBU1.Id);
    	objDept3 = testData.init_Department('FPA', objBU1.Id);
    	objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	
    	objPSTM1 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	objMSTTM2 = testData.init_Team_Member(objUser2.Id, objDept2.Id);
    	objFPATM3 = testData.init_Team_Member(objUser2.Id, objDept3.Id);
    	objMST2TM4 = testData.init_Team_Member(objUser2.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	
    	lstTeam_Member.add(objPSTM1);
    	lstTeam_Member.add(objMSTTM2);
    	lstTeam_Member.add(objFPATM3);
    	lstTeam_Member.add(objMST2TM4);
    	
    	insert lstTeam_Member;
    	
	  								
    	Test.startTest();
    	
    	ApexPages.currentPage().getParameters().put('RecordType',RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId()); 
	    ApexPages.currentPage().getParameters().put('id',null); 
	    
	    Account objAccount = new Account();
	   
	    ApexPages.StandardController std1 = new ApexPages.StandardController(objAccount);        
        NewEditAccountController objNewEditAccountController2 = new NewEditAccountController(std1);
        objNewEditAccountController2.saveAccount();
    
    
    	
	    
    	Test.stopTest();
    	
    	
    }
    
    
}