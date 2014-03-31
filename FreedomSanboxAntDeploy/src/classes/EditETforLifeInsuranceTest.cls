/**
*  Test class for Controller class EditETforLifeInsurance
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi/Prajakta    02/04/2013      Initial Draft
*/

@isTest
private class EditETforLifeInsuranceTest 
{
    //test Method
	@isTest
	public static  void testEditETforLifeInsurance()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		//Account objAccount = testData.initializeAccount();
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
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
    	
    	
    	Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
    	//Insert Life Insurace Product record
        Product_Master__c objProduct2 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Axis Life Insurance', ProductType__c='Life Insurance'
                                                            ,Policy_Type__c='Term Life');
        insert  objProduct2; 
                                                         
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
	    
	    Insurance__c insurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId(),Policy_Number__c = 'sss');
	    insert insurance1;
	    
	    List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
	    
	    Approve_Action_Plan__c objAAP1 = testData.init_ApproveActionPlan(objAccount.Id);
	    //insert objAAP1;
        
        	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , 
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
        lstApproveActionPlan.add(objAAP1);										  
      	lstApproveActionPlan.add(objAAP2);	
      	
      	insert lstApproveActionPlan;
      				
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = testData.init_ExecutionTracker(objAccount.id,'Assigned to Operations','Opened',objAAP1.Id,'Life Insurance','');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = testData.init_ExecutionTracker(objAccount.id,'Assigned to Operations','Closed',objAAP1.Id,'Life Insurance','');
        lstET.add(objET2);
        
        Execution_Tracker__c objMET1 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP2.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount.Id, Type__c='Life Insurance', 
      																ET_Status__c='Assigned to Operations', Executed_Product_Name__c='Axis Life Insurance');
      	lstET.add(objMET1);															
        insert lstET;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        ApexPages.currentPage().getParameters().put('etid', objET1.id);
        Apexpages.currentPage().getParameters().put('id', objAAP1.Id);
		Apexpages.currentPage().getParameters().put('type', 'Life Insurance');
        EditETforLifeInsurance objEETC1 = new EditETforLifeInsurance(); 
      	objEETC1.assignTask();
      	objEETC1.getEntities();
      	objEETC1.updateExecutionTracker();
      	
      	ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        ApexPages.currentPage().getParameters().put('etid', objET1.id);
        Apexpages.currentPage().getParameters().put('id', objAAP1.Id);
		Apexpages.currentPage().getParameters().put('type', 'other');
        EditETforLifeInsurance objEETC2 = new EditETforLifeInsurance(); 
      	objEETC2.assignTask();
      	objEETC2.getEntities();
      	objEETC2.updateExecutionTracker();
      	objEETC2.getApplicationStatus();
      	
      	
      	ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        ApexPages.currentPage().getParameters().put('etid', objMET1.id);
        Apexpages.currentPage().getParameters().put('id', objAAP2.Id);
		Apexpages.currentPage().getParameters().put('type', 'Life Insurance');
        EditETforLifeInsurance objEETC3 = new EditETforLifeInsurance(); 
      	objEETC3.assignTask();
      	objEETC3.getEntities();
      	objEETC3.updateExecutionTracker();
      	
        Test.stopTest();
	}
}