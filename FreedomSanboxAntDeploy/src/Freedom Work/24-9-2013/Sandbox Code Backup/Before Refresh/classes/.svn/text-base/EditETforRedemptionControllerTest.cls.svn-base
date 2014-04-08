/**
*  Test class for Controller class EditETforRedemptionController
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi/Prajakta    02/04/2013      Initial Draft
*/

public with sharing class EditETforRedemptionControllerTest 
{

    //test Method
	@isTest
	public static  void testEditETforRedemptionController()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		//Account objAccount = testData.initializeAccount();
	    //insert objAccount;
	    //Account objAccount = testData.initializeAccount();
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
    	
    	//Insert RecordType for Insurance record
    	List<InvestmentAsset__c> lstRecTypesInvestment = new List<InvestmentAsset__c>();
    	InvestmentAsset__c objInvestmentRecType = new InvestmentAsset__c(Name='Stocks', 
    											 RecordTypeId__c=RECORD_TYPE_INFO_INVESTMENTMAP.get('Stocks').getRecordTypeId());
    	
    	InvestmentAsset__c objInvestmentRecType1 = new InvestmentAsset__c(Name='Fixed Income', 
    											 RecordTypeId__c=RECORD_TYPE_INFO_INVESTMENTMAP.get('Fixed Income').getRecordTypeId());
    	InvestmentAsset__c objInvestmentRecType2 = new InvestmentAsset__c(Name='Gold and Silver', 
    											 RecordTypeId__c=RECORD_TYPE_INFO_INVESTMENTMAP.get('Gold and Silver').getRecordTypeId());
    											 
    	InvestmentAsset__c objInvestmentRecType3 = new InvestmentAsset__c(Name='Mutual Fund', 
    											 RecordTypeId__c=RECORD_TYPE_INFO_INVESTMENTMAP.get('Mutual Fund').getRecordTypeId());
    	lstRecTypesInvestment.add(objInvestmentRecType);										 
    	lstRecTypesInvestment.add(objInvestmentRecType1);
    	lstRecTypesInvestment.add(objInvestmentRecType2);	
    	lstRecTypesInvestment.add(objInvestmentRecType3);
    	
    	insert lstRecTypesInvestment;
    	
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
	    
	    Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=RECORD_TYPE_INFO_INVESTMENTMAP.get('Stocks').getRecordTypeId(),
	    												Maturity_Date__c = system.today());
	    insert inv;		
	    				
	    List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();										
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id,Investment_Asset__c = inv.Id);
	    lstAP.add(objAAP1);
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    lstAP.add(objAAP2);
        
        insert lstAP;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Lumpsum',Action__c = 'Redeem');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Application_Status__c = 'Closed', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Lumpsum',Action__c = 'Hold - COB');
        lstET.add(objET2);
        insert lstET;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        Apexpages.currentPage().getParameters().put('id', objAAP2.Id);
		Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
        EditETforRedemptionController objEETC1 = new EditETforRedemptionController(); 
      	objEETC1.assignTask();
      	objEETC1.getEntities();
      	objEETC1.updateExecutionTracker();
      	
      	ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        Apexpages.currentPage().getParameters().put('etid', objET1.Id);
        Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
		Apexpages.currentPage().getParameters().put('userType', 'opsTeam');
        EditETforRedemptionController objEETC2 = new EditETforRedemptionController(); 
      	objEETC2.assignTask();
      	objEETC2.getEntities();
      	objEETC2.updateExecutionTracker();
      	objEETC2.getApplicationStatus();
      	
      	ApexPages.currentPage().getParameters().put('eid',null);
        Apexpages.currentPage().getParameters().put('etid', objET1.Id);
        Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
		Apexpages.currentPage().getParameters().put('userType', 'opsTeam');
        EditETforRedemptionController objEETC3 = new EditETforRedemptionController(); 
      	objEETC3.getEntities();
        Test.stopTest();
	}
}