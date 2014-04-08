/*  Test class for ARPPCalcualtionHandler class that calculate ARPP Calcualtion using 
	Action plan and Execution tracker
*  
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Gaurav             30/5/2013        Initial Draft
*/

@isTest
private class TestARPPCalculationHandler 
{

    static testMethod void ARPPCalculationHandlerTest() 
    {
       
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INVESTMENT = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
    	
    	
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
    	
    	//Insert Custom Setting record
    	List<InvestmentAsset__c> lstInvestmentAssetRecTypes = new List<InvestmentAsset__c>();
    	
    	InvestmentAsset__c objInvestMentAsset = new InvestmentAsset__c(Name='Mutual Fund',RecordTypeId__c=RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId());
    	
    	lstInvestmentAssetRecTypes.Add(objInvestMentAsset);
    	
    	insert lstInvestmentAssetRecTypes; 
    	
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', 
    											RecordTypeId__c=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    							
    	insert 	objInsuranceRecType;
    	
    	
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', 
        																		Is_Active__c=true);
        insert PM1;
        
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        List<Commission__c> lstCommssion = new List<Commission__c>();
        
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
        
       List<ARPP_Detail__c>	lstARPPDetails = new List<ARPP_Detail__c>();
       
      
        						
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );

        insert objUser;
        
        //Insert smagicbasic SMS Template record 
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    						
        //Insert Account record
    	Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objGeneralAccount;
    																	
        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = objUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true );
	                      
	                       
        insert objAccount1;
        
        Insurance__c insurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount1.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId(),Policy_Number__c = 'sss');
	    insert insurance1;
	    						
        List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
        Investment_Asset__c objInvest = new Investment_Asset__c(Entity__c=objAccount1.id, Scheme_Name_Text__c='Axis SIP Fund',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId = RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId(), Maturity_Date__c = system.today());
      														
        lstInvestmentAsset.add(objInvest);
        
        Investment_Asset__c objInvest1 = new Investment_Asset__c(Entity__c=objAccount1.id, Scheme_Name_Text__c='Axis SIP Fund',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId(), Maturity_Date__c = system.today());
      														
      	Investment_Asset__c objInvest2 = new Investment_Asset__c(Entity__c=objAccount1.id, Scheme_Name_Text__c='Axis Lumpsum Fund',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId(), Maturity_Date__c = system.today());
      																											
      	lstInvestmentAsset.add(objInvest1);
      	lstInvestmentAsset.add(objInvest2);	
      													
        insert lstInvestmentAsset;
        
        
         //Select a.isSIPexecutionTracker__c, a.isExecutionTracker__c, a.Scheme_Name__c, a.SIP_Action__c, a.SIP_Action_Amount__c, a.Lumpsum_Action__c, 
		//a.Investment_Asset__c, a.Action_Amount__c From Approve_Action_Plan__c a  where Investment_Asset__c!=null
      	//Insert Approve Action Plan Record
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
      	
      	Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(isSIPexecutionTracker__c=true,isExecutionTracker__c =true, 
      											Remarks__c='test SIP', Amount__c = 20000,Lumpsum_Action__c='Hold',
      										  	Amount_Per_Installment__c = 200,  SIP_Action__c='Continue',Investment_Asset__c = objInvest2.Id,
      										  	Scheme_Name__c='Axis SIP Fund',Installments__c = 20, SIP_Action_Amount__c = 2000,
      										  	Action_Amount__c =1000,
      										  	Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP4);
       
       
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=true,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Hold',Investment_Asset__c = objInvest.Id,
      										  Scheme_Name__c='Axis Lumpsum Fund1',Installments__c = 20,
      										  Action_Amount__c =1000,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP5);
       
       
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=true,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Switch In',Investment_Asset__c = objInvest1.Id,
      										  Scheme_Name__c='Axis SIP Fund',Installments__c = 20,
      										  Action_Amount__c =1000,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP6);									  
      										  
      										  
      										  
      	
        Approve_Action_Plan__c objAAP = new Approve_Action_Plan__c(Transaction_Type__c='STP To', Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  
      										  Product_Name__c ='Axis Lumpsum Fund1' ,Installments__c = 20, Action_Amount__c = 2000,
      										  Item_Type__c = 'Lumpsum', Account__c = objAccount1.id, isLumpsumExecTracker__c=true,AP_Status__c = 'Opened');
      										  							  
        lstApproveActionPlan.add(objAAP);			
        
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',
        								    Account__c=objAccount1.id,
        								    Product_Name__c= 'Axis SIP Fund',
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',
     										Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAP1);		
      	
      	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000,Suggested_Cover__c =1000000,
      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
      										  Action_Amount__c = 1000,	Insurance__c = insurance1.Id,
      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , Sum_Assured_Rs__c = 10000,  
      										  Item_Type__c = 'Life Insurance', Account__c = objAccount1.id, isInsuranceExecutionTracker__c =true,
      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
      										  
      	lstApproveActionPlan.add(objAAP2);		
      				
      				
      	Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip',
      										Product_Name__c = 'Bajaj General Insurance',
      										Policy_Type__c = 'Critical Illness',
      										Tenure_of_Insurance__c = 5,
      										Sum_Assured_Rs__c = 10000, 
      										Account__c=objAccount1.id,
     										Amount__c=10000,Amount_Per_Installment__c=400,Installments__c=40, Item_Type__c = 'General Insurance',
     										isInsuranceExecutionTracker__c = true, Premium_Amount_Rs__c = 1000);
     										
     	lstApproveActionPlan.add(objAAP3);
     	
     	insert lstApproveActionPlan;	
     	
     	Map<Id,Approve_Action_Plan__c> mapIdToAAP = new Map<Id,Approve_Action_Plan__c> ();
     	for(Approve_Action_Plan__c objAAPlan: lstApproveActionPlan)
     	{
     		mapIdToAAP.put(objAAPlan.Id, objAAPlan);
     	}     	 
     	 
     	ARPPCalculationHandler objARPPHandler = new ARPPCalculationHandler();
     	objARPPHandler.onAfterInsertForARPPWithRunningSIPandLumpsum(mapIdToAAP);
     	
      	//Insert Execution Tracker Record
      	List<Execution_Tracker__c> lstExecutionTracker = new List<Execution_Tracker__c>();
      	Execution_Tracker__c objMET1 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP2.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='Life Insurance', 
      																ET_Status__c='Assigned to Operations');
      	
      	
      	Execution_Tracker__c objMET2 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP3.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='General Insurance', 
      																ET_Status__c='Assigned to Operations');
      																
      	Execution_Tracker__c objMET3 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP1.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='SIP', 
      																ET_Status__c='Assigned to Operations');	
      																
      	Execution_Tracker__c objMET4 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='Lumpsum', 
      																ET_Status__c='Assigned to Operations');																														
      	lstExecutionTracker.add(objMET1);
      	lstExecutionTracker.add(objMET2);
      	lstExecutionTracker.add(objMET3);
      	lstExecutionTracker.add(objMET4);														
      	insert lstExecutionTracker;
      	
         ARPP_Detail__c objARPP = new ARPP_Detail__c(Entity__c = objAccount1.Id,Approve_Action_Plan__c = objAAP1.id,
       												Product__c= objProduct.Id, Type__c = 'SIP', Commission__c = null,
       												Actual_Commission__c = null,
       												Action_Plan_Amount__c = 1000,Execution_Tracker_Actual_Product__c= objProduct.Id);
       												
       insert objARPP;											
        
        
        //Insert Commission record
        Commission__c objCommission = new Commission__c(Product__c = objProduct.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);
        	
           
        Commission__c objCommission1 = new Commission__c(Product__c = objProduct1.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        
        Commission__c objCommission2 = new Commission__c(Product__c = objProduct2.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        
        Commission__c objCommission3 = new Commission__c(Product__c = objProduct3.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission);
        lstCommssion.add(objCommission1);
        lstCommssion.add(objCommission2);
        lstCommssion.add(objCommission3);
        									
        insert lstCommssion;		
        
      	objMET1.Agreed_Amount__c= 3000;
      	update objMET1;
      	
      	delete lstApproveActionPlan;
      	delete objMET1;
    }
}