/*
    Revision History:
    Version     Version Author    Date              Comments
    1.0         Prajakta Sanap   23/12/2013   1. Test Class for AccountWorkflowHandlerHandler
                                 
*/

@isTest
public class AccountWorkflowHandlerTest
{
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
    public static TestData_Ffreedom testData;
    
    public static Product_Manufacturer_Master__c objPMM;
    public static Product_Master__c objProductMaster;
    public static Product_Default_Allocation__c objPDA;
    
        
    @isTest
    public static void TestData() 
    {
    	testData = new TestData_Ffreedom();
    	
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
    	lstVirtualAcc.add(virtualAcc1);
    	insert lstVirtualAcc;
    	
    }
    
    //@isTest
    public static void newEntityCreationTest() 
    {
    	
    	TestData();
    	
	    Test.startTest();
	    objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
    	objAccount.OwnerId = objUser1.Id;
	    insert objAccount;
	    //system.assertEquals('Data Collection', 'Data Collection');
	    Test.stopTest();
    }
    
    @isTest
    public static void entityStageChangeTest() 
    {
    	Test.startTest();
    	TestData();
    	
    	List<Account> lstAcc = new List<Account>();
    	
    	objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
    	objAccount.OwnerId = objUser1.Id;
    	objAccount.Data_Collection_Date__c = system.today().addDays(1);
    	
    	
    	//objAccount.Data_Collection_Date__c = null;
	    
	    //system.assertEquals(objAccount.Entity_Stage__c, 'Data Collection');
    	
    	//insert objAccount;
    	lstAcc.add(objAccount);
    	insert lstAcc;
	   
	    //insert objAccount;
	     system.debug('-----objAccount Insert------'+objAccount);
	    objAccount = [
	    	select id, LastName
	    		 , Data_Collection_Date__c
	          from Account
	          where id =: objAccount.id
	    ];
	    system.debug('-----objAccount------'+objAccount);
	    system.debug('--------1---------'+objAccount.Data_Collection_Date__c);
	    objAccount.Data_Collection_Date__c = system.today().addDays(3);
    
	    Map<Id,Account> mapIdToAccountOld = new Map<Id,Account> ();
	    mapIdToAccountOld.put(objAccount.Id, objAccount);
	    
	    update objAccount;
	    
	    Map<Id,Account> mapIdToAccountNew = new Map<Id,Account> ();
	    mapIdToAccountNew.put(objAccount.Id, objAccount);
	    
	    AccountWorkflowHandler.entityStageChange(lstAcc, mapIdToAccountOld, mapIdToAccountNew, true);
	    Test.stopTest();
    }
     
     @isTest
    public static void entityStageChangeforPlanWritingDateTest() 
    {
    	Test.startTest();
    	TestData();
    	
    	List<Account> lstAcc = new List<Account>();
    	
    	objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
    	objAccount.OwnerId = objUser1.Id;
    	objAccount.Data_Collection_Date__c = system.today().addDays(1);
    	objAccount.Plan_Writing_Date__c = system.today().addDays(2);
    	objAccount.Plan_Approved_Date__c = null;
    	objAccount.Action_Plan_Generation_Date__c = null;
    	
   
    	//insert objAccount;
    	lstAcc.add(objAccount);
    	insert lstAcc;
	   
	    //insert objAccount;
	    system.debug('-----objAccount Insert------'+objAccount);
	    
	    objAccount = [
	    	select id, LastName
	    		 , Data_Collection_Date__c,
	    		 Plan_Writing_Date__c
	          from Account
	          where id =: objAccount.id
	    ];
	    
	   
	    system.debug('--------1---------'+objAccount.Data_Collection_Date__c);
	   
	    objAccount.Data_Collection_Date__c = system.today().addDays(3);
        objAccount.Plan_Writing_Date__c = system.today().addDays(4);
        
	    Map<Id,Account> mapIdToAccountOld = new Map<Id,Account> ();
	    mapIdToAccountOld.put(objAccount.Id, objAccount);
	    
	    update objAccount;
	    
	    objAccount.Data_Collection_Date__c = system.today().addDays(1);
        objAccount.Plan_Writing_Date__c = system.today().addDays(2);
        
	    Map<Id,Account> mapIdToAccountNew = new Map<Id,Account> ();
	    mapIdToAccountNew.put(objAccount.Id, objAccount);
	    
	    AccountWorkflowHandler.entityStageChange(lstAcc, mapIdToAccountOld, mapIdToAccountNew, true);
	     
	    Test.stopTest();
    }
    
   
    @isTest
    public static void entityStageChangeforPlanApprovalDateTest() 
    {
    	Test.startTest();
    	TestData();
    	
    	List<Account> lstAcc = new List<Account>();
    	
    	objAccount = testData.initializeAccount();
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
    	objAccount.Action_Plan_Generation_Date__c = null;
    	
   
    	//insert objAccount;
    	lstAcc.add(objAccount);
    	insert lstAcc;
	   
	    //insert objAccount;
	    system.debug('-----objAccount Insert------'+objAccount);
	   	 objAccount = [
	    	select id, LastName
	    		 , Data_Collection_Date__c,Plan_Approved_Date__c,
	    		 Plan_Writing_Date__c
	          from Account
	          where id =: objAccount.id
	    ];
	    system.debug('--------1---------'+objAccount.Data_Collection_Date__c);
	    
	    Map<Id,Account> mapIdToAccountOld = new Map<Id,Account> ();
	    mapIdToAccountOld.put(objAccount.Id, objAccount);
	    
	    update objAccount;
	    objAccount.Data_Collection_Date__c = system.today().addDays(2);
	    objAccount.Plan_Writing_Date__c = system.today().addDays(4);
        objAccount.Plan_Approved_Date__c = system.today().addDays(8);
	    
	    
	    Map<Id,Account> mapIdToAccountNew = new Map<Id,Account> ();
	    mapIdToAccountNew.put(objAccount.Id, objAccount);
	    
	    AccountWorkflowHandler.entityStageChange(lstAcc, mapIdToAccountOld, mapIdToAccountNew, true);
	     
	    Test.stopTest();
    }
    
     @isTest
    public static void entityStageChangeforActionplanGenerationDateTest() 
    {
    	Test.startTest();
    	TestData();
    	
    	List<Account> lstAcc = new List<Account>();
    	
    	objAccount = testData.initializeAccount();
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
    	
   
    	//insert objAccount;
    	lstAcc.add(objAccount);
    	insert lstAcc;
	   
	    //insert objAccount;
	    system.debug('-----objAccount Insert------'+objAccount);
	   	 objAccount = [
	    	select id, LastName
	    		 , Data_Collection_Date__c,Plan_Approved_Date__c,
	    		 Plan_Writing_Date__c,IsExecutionTrackerGenerated__c,
	    		 Action_Plan_Generation_Date__c
	          from Account
	          where id =: objAccount.id
	    ];
	    system.debug('--------1---------'+objAccount.Data_Collection_Date__c);
	    
	    Map<Id,Account> mapIdToAccountOld = new Map<Id,Account> ();
	    mapIdToAccountOld.put(objAccount.Id, objAccount);
	    
	    update objAccount;
	    objAccount.Data_Collection_Date__c = system.today().addDays(2);
	    objAccount.Plan_Writing_Date__c = system.today().addDays(4);
        objAccount.Plan_Approved_Date__c = system.today().addDays(8);
	    
	    
	    Map<Id,Account> mapIdToAccountNew = new Map<Id,Account> ();
	    mapIdToAccountNew.put(objAccount.Id, objAccount);
	    
	    AccountWorkflowHandler.entityStageChange(lstAcc, mapIdToAccountOld, mapIdToAccountNew, true);
	     
	    Test.stopTest();
    }
    
    /*Needhi 21-3-2014*/
  /*   @isTest
    public static void createTaskForBirthdayAlertTest(){
    	
    	Test.startTest();
    	TestData();
    	system.debug('***********test case***********');
    					                       	
    	List<Account> lstAcc = new List<Account>();
    	/*
    	objAccount = testData.initializeAccount();
    	system.debug('******test class********'+objAccount);
    	
    	*/
    	
    /*	Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
    									Entity_Status__c='Active', PersonTitle='TestData', Plan_Generation_Date__c=system.today(),
    									PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='9423230175',
				                       	Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', PAN_ID__pc='abcde4567M',
				                       	Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
				                       	PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',
				                       	Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
				                       	Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', 
				                       	Related_To__c ='Ffreedom',Email_Temp__c='abc@gmail.com',
				                       	Data_Collection_Date__c = date.today(), Finametrica_Score__c = null,
				                       	RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
				                       	
				                       	
		objAccount1.Business_Unit__c = objBU1.Id;
    	objAccount1.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount1.PST_Team_Member__c = objTM1.Id;
    	objAccount1.MST_Team_Member__c = objTM2.Id;
    	objAccount1.FPA_Team_Member__c = objTM3.Id;
    	objAccount1.OPS_Team_Member__c = objTM4.Id;
    	objAccount1.OwnerId = objUser1.Id;		                       	
    	objAccount1.Data_Collection_Date__c = system.today().addDays(1);
    	objAccount1.Plan_Writing_Date__c = system.today().addDays(3);
    	objAccount1.Plan_Approved_Date__c = system.today().addDays(7);
    	objAccount1.Action_Plan_Generation_Date__c = system.today().addDays(9);
    	objAccount1.IsExecutionTrackerGenerated__c = true;
    	
    	system.debug('******test class********'+objAccount1);
    	//objAccount.PersonBirthdate = Date.today();
    	system.debug('******test class********'+objAccount1.Birthday_This_Year__pc );
    	
    	lstAcc.add(objAccount1);
    	insert lstAcc;
    	
    	
    	
    	//AccountWorkflowHandler.createTaskForBirthdayAlert(lstAcc, null);
    	
    	List<Task> objTask = [Select t.WhatId, t.Subject_Category__c, t.Subject, t.OwnerId, t.Id From Task t Where Owner.Id =: objAccount1.Id];
    	system.assertEquals(objTask.size(),1);
    	
    	//objAccount.PersonBirthdate = Date.valueof(23-01-1990);
    	//update objAccount; 
    	//List<Task> objTask1 = [Select t.WhatId, t.Subject_Category__c, t.Subject, t.OwnerId, t.Id From Task t Where Owner.Id =: objAccount.Id];
    	//system.assertEquals(objTask1.size(),1);
    	Test.stopTest();
     	
    }
    */
}