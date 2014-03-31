/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class test_Sandbox {

    @isTest
    public static void entityStageChangeTest() 
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
    	
    	//Insert Account record
    	Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert objGeneralAccount;							
    	
    	AccountWorkflowHandlerTest.TestData();
    	
    	Account objAccount = AccountWorkflowHandlerTest.testData.initializeAccount();
    	objAccount.Business_Unit__c = AccountWorkflowHandlerTest.objBU1.Id;
    	objAccount.Virtual_Partner__c = AccountWorkflowHandlerTest.virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = AccountWorkflowHandlerTest.objTM1.Id;
    	objAccount.MST_Team_Member__c = AccountWorkflowHandlerTest.objTM2.Id;
    	objAccount.FPA_Team_Member__c = AccountWorkflowHandlerTest.objTM3.Id;
    	objAccount.OPS_Team_Member__c = AccountWorkflowHandlerTest.objTM4.Id;
    	objAccount.OwnerId = AccountWorkflowHandlerTest.objUser1.Id;
    	objAccount.Data_Collection_Date__c = system.today() + 1;
    	//objAccount.Data_Collection_Date__c = null;
	    
	    //system.assertEquals(objAccount.Entity_Stage__c, 'Data Collection');
    	
	    Test.startTest();
	    insert objAccount;
	    objAccount = [
	    	select id
	    		 , Data_Collection_Date__c
	          from Account
	          where id =: objAccount.id
	    ];
	    system.debug('-----objAccount------'+objAccount);
	    system.debug('--------1---------'+objAccount.Data_Collection_Date__c);
	    objAccount.Data_Collection_Date__c = system.today() + 3;
	    update objAccount;
	    objAccount = [
	    	select id
	    		 , Data_Collection_Date__c
	          from Account
	          where id =: objAccount.id
	    ];
	    system.debug('-------2---------'+objAccount.Data_Collection_Date__c);
	    /*
	    objAccount.Plan_Writing_Date__c = system.today() + 2;
	    update objAccount;
	    objAccount.Plan_Approved_Date__c = system.today() + 3;
	    update objAccount;
	    objAccount.Action_Plan_Generation_Date__c = system.today() + 4;
	    update objAccount;
	    objAccount.IsExecutionTrackerGenerated__c = true;
	    update objAccount;
	    objAccount.First_Execution_Completion_Date__c = objAccount.Action_Plan_Generation_Date__c;
	    update objAccount;
	    */
	    //system.assertEquals(objAccount.Entity_Stage__c, 'Plan Writing');
	    Test.stopTest();
    }
}