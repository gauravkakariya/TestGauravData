/**
*  Test class for Controller class EditETforSTPController
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi/Prajakta    02/04/2013      Initial Draft
*/
 
public with sharing class EditETforSTPControllerTest {

    //test Method
	@isTest
	public static  void testEditETforSTPController()
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
    	
	    
		//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463732345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
	    insert objAccount;
	    
	    
	    Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=RECORD_TYPE_INFO_INVESTMENTMAP.get('Stocks').getRecordTypeId(),
	    												Maturity_Date__c = system.today());
	    insert inv;		
	    Investment_Asset__c inv1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=RECORD_TYPE_INFO_INVESTMENTMAP.get('Mutual Fund').getRecordTypeId(),
	    												Maturity_Date__c = system.today());
	    insert inv1;	
	    				
	    List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();										
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id,Investment_Asset__c = inv1.Id);
	    lstAP.add(objAAP1);
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    lstAP.add(objAAP2);
        
        insert lstAP;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Total_Remaining_Balance__c = 200,Agreed_Amount__c = 202,Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Lumpsum',Action__c = 'STP To');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Total_Remaining_Balance__c = 200,Agreed_Amount__c = 202,Application_Status__c = 'Closed', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Lumpsum',Action__c = 'Lumpsum');
        lstET.add(objET2);
        insert lstET;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        Apexpages.currentPage().getParameters().put('id', objAAP2.Id);
		Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
        EditETforSTPController objEETC1 = new EditETforSTPController(); 
      	objEETC1.assignTask();
      	objEETC1.getEntities();
      	objEETC1.updateExecutionTracker();
      	
      	ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        Apexpages.currentPage().getParameters().put('etid', objET1.Id);
        Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
		Apexpages.currentPage().getParameters().put('userType', 'opsTeam');
        EditETforSTPController objEETC2 = new EditETforSTPController(); 
      	objEETC2.assignTask();
      	objEETC2.getEntities();
      	objEETC2.updateExecutionTracker();
      	objEETC2.getApplicationStatus();
      	
      	ApexPages.currentPage().getParameters().put('eid',null);
        Apexpages.currentPage().getParameters().put('etid', objET1.Id);
        Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
		Apexpages.currentPage().getParameters().put('userType', 'opsTeam');
        EditETforSTPController objEETC3 = new EditETforSTPController(); 
      	objEETC3.getEntities();
      	
      	
      	try
      	{
      		ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        	Apexpages.currentPage().getParameters().put('id', objAAP1.Id);
			Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
        	EditETforSTPController objEETC4 = new EditETforSTPController(); 
        	objEETC4.getEntities();
      		objEETC4.updateExecutionTracker();
      	}
      	catch(Exception e)
      	{
      		
      	}
      	
        Test.stopTest();
	}
	@isTest
	public static  void testEditETforSTPController1()
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
    	
	    
		//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463732345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
	    insert objAccount;
	    
	    
	    Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=RECORD_TYPE_INFO_INVESTMENTMAP.get('Stocks').getRecordTypeId(),
	    												Maturity_Date__c = system.today());
	    insert inv;		
	    Investment_Asset__c inv1 = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=RECORD_TYPE_INFO_INVESTMENTMAP.get('Mutual Fund').getRecordTypeId(),
	    												Maturity_Date__c = system.today());
	    insert inv1;	
	    				
	    List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();										
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id,Investment_Asset__c = inv1.Id);
	    lstAP.add(objAAP1);
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    lstAP.add(objAAP2);
        
        insert lstAP;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Total_Remaining_Balance__c = 200,Agreed_Amount__c = 202,Executed_Product_Name__c = 'Axis Lumpsum Fund1',
        									Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Lumpsum',Action__c = 'STP To');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Total_Remaining_Balance__c = 200,Agreed_Amount__c = 202,Application_Status__c = 'Closed', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Lumpsum',Action__c = 'Lumpsum');
        lstET.add(objET2);
        insert lstET;
        
         Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', 
        																		Is_Active__c=true);
        insert PM1;
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        //Insert SIP Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Axis SIP Fund', ProductType__c='Mutual Fund'
                                                            ,Investment_Type__c='SIP');
        lstProductMaster.add(objProduct);   
        
        //Insert Lumpsum Product record
        Product_Master__c objProduct1 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Axis Lumpsum Fund1', ProductType__c='Mutual Fund'
                                                            ,Investment_Type__c='Lumpsum');
        lstProductMaster.add(objProduct1);   
        
        
        //Insert Life Insurace Product record
        Product_Master__c objProduct2 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Axis Life Insurance', ProductType__c='Life Insurance'
                                                            ,Policy_Type__c='Term Life');
        lstProductMaster.add(objProduct2);  
        
         
        //Insert General Insurace Product record
        Product_Master__c objProduct3 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Bajaj General Insurance', ProductType__c='General Insurance'
                                                            ,Policy_Type__c='Critical Illness');
        lstProductMaster.add(objProduct3);  
        
        insert lstProductMaster;
        
         ARPP_Detail__c objARPP = new ARPP_Detail__c(Entity__c = objAccount.Id,Approve_Action_Plan__c = objAAP1.id,
       												Product__c= objProduct.Id, Type__c = 'Lumpsum', Commission__c = null,
       												Actual_Commission__c = null,Remark__c = 'Product Detail is not Found',
       												ET_Remark__c = 'Actual Product Commision not found',
       												Execution_Tracker__c = objET1.Id,
       												Action_Plan_Amount__c = 1000,Execution_Tracker_Actual_Product__c= null);
       												
        insert objARPP;			
        
        Test.startTest();
      	try
      	{
      		ApexPages.currentPage().getParameters().put('eid', objAccount.id);
	        Apexpages.currentPage().getParameters().put('etid', objET1.Id);
	        Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
			Apexpages.currentPage().getParameters().put('userType', 'opsTeam');
	        EditETforSTPController objEETC2 = new EditETforSTPController(); 
	      	objEETC2.updateARPPDetail();
	      	//objEETC2.getApplicationStatus();
      	}
      	catch(Exception e)
      	{
      		
      	}
      	
        Test.stopTest();
	}
}