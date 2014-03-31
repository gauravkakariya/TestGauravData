@isTest
private class TestUploadDocument {

    public static TestData_Ffreedom testData;
	public static User objUser1;
	public static Business_Unit__c objBU1;
    public static Department__c objDept1;
    public static Department__c objDept2;
    public static Department__c objDept3;
    public static Department__c objDept4;
    
    public static Team_Member__c objTM1;
    public static Team_Member__c objTM2;
    public static Team_Member__c objTM3;
    public static Team_Member__c objTM4;
    
    public static Account virtualAcc1;
    public static Account objAccount;
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
        
    	
    	List<User> lstUser = new List<User>();
    	objUser1 = testData.initializeUser();
    	lstUser.add(objUser1);
    	insert lstUser;
    	
    	List<Business_Unit__c> lstBU = new List<Business_Unit__c>();
    	objBU1 = testData.init_Business_Unit('BU1');
    	lstBU.add(objBU1);
    	insert lstBU;
    	
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
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	insert lstTeam_Member;
    	
    	List<Account> lstVirtualAcc = new List<Account>();
    	virtualAcc1 = testData.initVirtualAccount();
    	virtualAcc1.Business_Unit__c = objBU1.Id;
    	virtualAcc1.PST_Team_Member__c = objTM1.Id;
    	virtualAcc1.MST_Team_Member__c = objTM2.Id;
    	virtualAcc1.FPA_Team_Member__c = objTM3.Id;
    	virtualAcc1.OPS_Team_Member__c = objTM4.Id;
    	virtualAcc1.Related_To__c = 'Ffreedom';
    	lstVirtualAcc.add(virtualAcc1);
    	insert lstVirtualAcc;
    	
    	Event_Master__c event = new Event_Master__c();
    	event.Name= Label.Happy_Birthday_To_Client;
    	insert event;    	
    }

    static testMethod void myUnitTest() {
    	
    	Test.startTest();
    	TestData();
    	system.debug('***********test case***********');
    					                       	
    	List<Account> lstAcc = new List<Account>();    	
    	objAccount = testData.initializeAccount();
    	system.debug('******test class********'+objAccount);
    	
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
    	objAccount.OwnerId = objUser1.Id;		                       	
    	objAccount.Data_Collection_Date__c = system.today().addDays(1);
    	objAccount.Plan_Writing_Date__c = system.today().addDays(3);
    	objAccount.Plan_Approved_Date__c = system.today().addDays(7);
    	objAccount.Action_Plan_Generation_Date__c = system.today().addDays(9);
    	objAccount.IsExecutionTrackerGenerated__c = true;
    	
    	system.debug('******test class********'+objAccount);
    	lstAcc.add(objAccount);
    	insert lstAcc;
    	
        //Test.StartTest();
		//Account acc=new Account(Name='Acme Inc');
        //insert acc;
        //system.debug('*******acc*******'+acc);
        ApexPages.currentPage().getParameters().put('EntityId', objAccount.id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objAccount);
        UploadDocumentController controller1=new UploadDocumentController(sc);
         
        UploadDocumentController controller=new UploadDocumentController();
 		controller.objAccount = objAccount;
 		
        Attachment attch = new Attachment();        
        attch.Name = 'TestClassAttachment';
        attch.Body = Blob.valueOf('TestClassAttachment body');
        controller.attachment = attch;
        controller.upload();
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:objAccount.id];
        System.assertEquals(1, attachments.size());
		
		Attachment attch1 = new Attachment();
		controller.attachment = attch1;
        controller.upload();
        
        List<Attachment> attachments1=[select id, name from Attachment where parent.id=:objAccount.id];
        System.assertEquals(1, attachments1.size());
        
		controller.cancel();
		Test.StopTest();
    }
}