/**
*  Test class for Controller class EditETforHoldCOBController
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi/Prajakta    02/04/2013      Initial Draft
*/

public with sharing class EditETforHoldCOBControllerTest 
{

   //test Method
	@isTest
	public static  void testEditETforHoldCOBController()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		//Account objAccount = testData.initializeAccount();
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
    	
     //Insert Account record
    	Account objBPAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objBPAccount;
    	
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
    									Entity_Status__c='Active', PersonTitle='TestData', Plan_Generation_Date__c=system.today(),
    									PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='9423230175',
				                       	Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', PAN_ID__pc='abcde4567M',
				                       	Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
				                       	PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',
				                       	Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
				                       	Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', 
				                       	Related_To__c ='Ffreedom',Email_Temp__c='abc@gmail.com',
				                       	Data_Collection_Date__c = date.today(),
				                       	RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true);
	    insert objAccount;
	    			
	    Approve_Action_Plan__c objAAP1 = testData.init_ApproveActionPlan(objAccount.Id);
	    insert objAAP1;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = testData.init_ExecutionTracker(objAccount.id,'Assigned to Operations','Opened',objAAP1.Id,'SIP','Hold');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = testData.init_ExecutionTracker(objAccount.id,'Assigned to Operations','Closed',objAAP1.Id,'Lumpsum','Hold - COB');
        lstET.add(objET2);
        insert lstET;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        Apexpages.currentPage().getParameters().put('id', objAAP1.Id);
		Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
        EditETforHoldCOBController objEETC1 = new EditETforHoldCOBController(); 
      	objEETC1.assignTask();
      	objEETC1.getEntities();
      	objEETC1.updateExecutionTracker();
      	
      	ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        Apexpages.currentPage().getParameters().put('etid', objET1.Id);
        Apexpages.currentPage().getParameters().put('type', 'GoalLumpsum');
		Apexpages.currentPage().getParameters().put('userType', 'opsTeam');
        EditETforHoldCOBController objEETC2 = new EditETforHoldCOBController(); 
      	objEETC2.assignTask();
      	objEETC2.getEntities();
      	objEETC2.updateExecutionTracker();
      	objEETC2.getApplicationStatus();
      	
      	ApexPages.currentPage().getParameters().put('eid',null);
        Apexpages.currentPage().getParameters().put('etid', objET1.Id);
        Apexpages.currentPage().getParameters().put('type', 'GoalLumpsum');
		Apexpages.currentPage().getParameters().put('userType', 'opsTeam');
        EditETforHoldCOBController objEETC3 = new EditETforHoldCOBController(); 
      	objEETC3.getEntities();
        Test.stopTest();
	}
}