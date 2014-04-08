/**
*  Test class for Controller class EditETforSurrenderLifeInsuranceTest
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi/Prajakta    05/04/2013      Initial Draft
*/

public with sharing class EditETforSurrenderLifeInsuranceTest 
{
	//test Method
	@isTest
	public static  void testEditETforSurrenderLifeInsurance()
	{
		
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_INVESTMENTMAP = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
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
    	
	    
		//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463732345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId =  RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
	    insert objAccount;
	    
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP1;
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP2;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Recommended Insurance');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Application_Status__c = 'Closed', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Recommended Insurance');
        lstET.add(objET2);
        insert lstET;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        ApexPages.currentPage().getParameters().put('etid', objET1.id);
        Apexpages.currentPage().getParameters().put('id', objAAP2.Id);
		Apexpages.currentPage().getParameters().put('type', 'Recommended Insurance');
        EditETforSurrenderLifeInsurance objEETC1 = new EditETforSurrenderLifeInsurance(); 
      	objEETC1.assignTask();
      	objEETC1.getEntities();
      	objEETC1.updateExecutionTracker();
      	
      	ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        ApexPages.currentPage().getParameters().put('etid', objET1.id);
        Apexpages.currentPage().getParameters().put('id', objAAP2.Id);
		Apexpages.currentPage().getParameters().put('type', 'other');
        EditETforSurrenderLifeInsurance objEETC2 = new EditETforSurrenderLifeInsurance(); 
      	objEETC2.assignTask();
      	objEETC2.getEntities();
      	objEETC2.updateExecutionTracker();
      	objEETC2.getApplicationStatus();
        Test.stopTest();
	}
}