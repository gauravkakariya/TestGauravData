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
    	
    	//Create  RecordType custom setting records
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
    	InvestmentAsset__c objInvestMentAsset = new InvestmentAsset__c(Name = 'Mutual Fund', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId());
    	insert objInvestMentAsset; 
    	
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    	insert 	objInsuranceRecType;
    	
    	
    	/*
    		Insert Product Master record
    	*/
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        
        //Insert SIP Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c = PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c = 'Axis SIP Fund', ProductType__c = 'Mutual Fund', Investment_Type__c = 'SIP');
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
        
        //Insert Loan Product record
        Product_Master__c objProduct4 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Test Loan', ProductType__c='Loan'
                                                            );
        lstProductMaster.add(objProduct4); 
        
        
         //Insert Loan Product record
        Product_Master__c objProduct5 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Test FD', ProductType__c='Fixed Deposit'
                                                            );
        lstProductMaster.add(objProduct5); 
        
        
         //Insert Loan Product record
        Product_Master__c objProduct6 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Test Bond', ProductType__c='Bond'
                                                            );
        lstProductMaster.add(objProduct6);  
        
        insert lstProductMaster;
        
        //Insert Commission record
        List<Commission__c> lstCommssion = new List<Commission__c>();
        Commission__c objCommission = new Commission__c(Product__c = objProduct.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);
        lstCommssion.add(objCommission);	
           
        Commission__c objCommission1 = new Commission__c(Product__c = objProduct1.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission1);
        Commission__c objCommission2 = new Commission__c(Product__c = objProduct2.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission2);
        
        Commission__c objCommission3 = new Commission__c(Product__c = objProduct3.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission3);
        
        
        Commission__c objCommission4 = new Commission__c(Product__c = objProduct4.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 0, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission4);
        
        
        Commission__c objCommission5 = new Commission__c(Product__c = objProduct5.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Min_Months__c = 1, Max_Months__c = 10,
        												Trail_Commission__c = 0, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission5);
        
        
        Commission__c objCommission6 = new Commission__c(Product__c = objProduct6.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 0, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission6);
        									
        insert lstCommssion;		
        
        Map<Id,Product_Master__c> mapIdToProductMaster = new Map<Id,Product_Master__c> ();
     	for(Product_Master__c objPM : lstProductMaster)
     	{
     		mapIdToProductMaster.put(objPM.Id, objPM);
     	}     	 
     	
        						
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser;
        
        /*	
        	Insert smagicbasic SMS Template record. This code is not related to funtionality.
        */ 
        
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
        
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
      	
      	//Action plan record for Current running Lumpsum/SIP
      	Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Hold',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP4);
       
       
        Approve_Action_Plan__c objAAP44 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'STP From',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP44);
        Approve_Action_Plan__c objAAP11 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Redeem',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP11);
        
     	Approve_Action_Plan__c objAAP22 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
  											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
  											Lumpsum_Action__c = 'STP From',
  										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
  										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Stop', 
  										  	Account__c = objAccount1.id, 
  										  	AP_Status__c = 'Opened');	
    	lstApproveActionPlan.add(objAAP22);
    	
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, Scheme_Name__c = 'Axis Lumpsum Fund1', Investment_Asset__c = objInvest.Id,
        										  Product__c = objProduct1.Id, Amount__c = 20000,
      										     Lumpsum_Action__c = 'Switch In', Action_Amount__c =1000,  
      										  	 SIP_Action_Amount__c =1000, SIP_Action__c = 'Continue',
      										     Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP5);
       
       
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=false,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Switch In',Investment_Asset__c = objInvest1.Id,
      										  Scheme_Name__c='Axis SIP Fund',Installments__c = 20,
      										  Action_Amount__c =1000,Product__c = objProduct.Id,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP6);									  
      										  
      										  
      										  
      	
        Approve_Action_Plan__c objAAP = new Approve_Action_Plan__c(isLumpsumExecTracker__c = true, Amount__c = 20000,
      										      Amount_Per_Installment__c = 200, Product_Name__c ='Axis Lumpsum Fund1',Product__c = objProduct1.Id,
      										      Installments__c = 20, Action_Amount__c = 2000,Investment_Asset__c = objInvest1.Id,
      										      Item_Type__c = 'Lumpsum', Account__c = objAccount1.id, AP_Status__c = 'Opened');
      										  							  
        lstApproveActionPlan.add(objAAP);			
        
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip',
			        								    isExecutionTracker__c = false, isSIPexecutionTracker__c = true,
			        								    Product_Name__c= 'Axis SIP Fund', Product__c = objProduct.Id,
			     										Amount__c=10000, Amount_Per_Installment__c = 400,
			     										Option__c = 'Growth', Installments__c = 40, 
			     										Item_Type__c = 'SIP', Category__c='Equity', 
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAP1);		
      	
      	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , 
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount1.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
      										  
      	lstApproveActionPlan.add(objAAP2);		
      				
      				
      	Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c ( Product_Name__c = 'Bajaj General Insurance',
				      										Policy_Type__c = 'Critical Illness',
				      										Product__c = objProduct3.Id,
				      										Sum_Assured_Rs__c = 10000, 
				      										Account__c = objAccount1.id,
				     										Amount__c = 10000,  Item_Type__c = 'General Insurance',
				     										isInsuranceExecutionTracker__c = true, Premium_Amount_Rs__c = 500);
     										
     	lstApproveActionPlan.add(objAAP3);
     	
     	
     	Approve_Action_Plan__c objAAPLoan = new Approve_Action_Plan__c (
			        								    isExecutionTracker__c = false, isaddonexecutionTracker__c = true,
			        								    Product_Name__c= 'Test Loan', Product__c = objProduct4.Id,
			     										Amount__c=10000,
			     										Item_Type__c = 'Fixed Deposit',
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAPLoan);	
      	
      	
      	Approve_Action_Plan__c objAAPFD = new Approve_Action_Plan__c (
			        								    isExecutionTracker__c = false, isaddonexecutionTracker__c = true,
			        								    Product_Name__c= 'Test FD', Product__c = objProduct5.Id,
			     										Amount__c=10000,
			     										Item_Type__c = 'Fixed Deposit',
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAPFD);	
      	
      	
      	
      	Approve_Action_Plan__c objAAPBond = new Approve_Action_Plan__c (
			        								    isExecutionTracker__c = false, isaddonexecutionTracker__c = true,
			        								    Product_Name__c= 'Test Bond', Product__c = objProduct6.Id,
			     										Amount__c=10000,
			     										Item_Type__c = 'Bond',
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAPBond);	
      	
      	
     	
     	insert lstApproveActionPlan;
     	
        List<Execution_Tracker__c> lstExecutionTracker = new List<Execution_Tracker__c>();
      	Execution_Tracker__c objMET1 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAPLoan.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='Loan', 
      																ET_Status__c='Assigned to Operations');
      																
      	insert 	objMET1;
      	
      	
      	
      															
     	
     /*	List<Approve_Action_Plan__c> lstUpdateAAP = new List<Approve_Action_Plan__c>();
     	objAAP4.Lumpsum_Action__c = 'Redeem';
     	lstUpdateAAP.add(objAAP4);
     	
     	objAAP44.isExecutionTracker__c = false;
     	lstUpdateAAP.add(objAAP44);
     	
     	objAAP3.Premium_Amount_Rs__c = 5000;
     	lstUpdateAAP.add(objAAP3);
     	
     	objAAP2.Premium_Amount_Rs__c = 5000;
     	lstUpdateAAP.add(objAAP2);
     	
     	update lstUpdateAAP;
     	
     	lstUpdateAAP = new List<Approve_Action_Plan__c>();
     	
     	objAAP.Amount__c = 5500;
     	lstUpdateAAP.add(objAAP); 
     	objAAP1.Amount__c = 5500;
     	lstUpdateAAP.add(objAAP1); 
     	
     	objAAP3.isInsuranceExecutionTracker__c = false;
     	lstUpdateAAP.add(objAAP3);
     	
     	objAAP44.isExecutionTracker__c = true;
     	lstUpdateAAP.add(objAAP44); 
     	
     	objAAP4.Lumpsum_Action__c = 'Switch In';
     	lstUpdateAAP.add(objAAP4);
     	
     	objAAP11.Lumpsum_Action__c = 'Hold';
     	lstUpdateAAP.add(objAAP11);
     	
     	objAAP22.SIP_Action__c = 'Hold';
     	lstUpdateAAP.add(objAAP22);
     	
     	update lstUpdateAAP;
     	lstUpdateAAP = new List<Approve_Action_Plan__c>();
     	
     	objAAP3.Product__c = null;
     	lstUpdateAAP.add(objAAP3);
     	
     	objAAP4.Product__c = null;
     	lstUpdateAAP.add(objAAP4);
     	
     	objAAP5.Product__c = null;
     	lstUpdateAAP.add(objAAP5);
     	
     	objAAP6.Product__c = null;
     	lstUpdateAAP.add(objAAP6);
     	
     	objAAP.Product__c = null;
     	lstUpdateAAP.add(objAAP);
     	
     	update lstUpdateAAP;
     	*/
     	/*List<Approve_Action_Plan__c> lstUpdateActionPlan = new List<Approve_Action_Plan__c>();
     	
     	objAAP.isSIPexecutionTracker__c = true;
     	
     	objAAP1.isLumpsumExecTracker__c = true;
     	objAAP2.isInsuranceExecutionTracker__c = true;
     	objAAP3.isInsuranceExecutionTracker__c = true;
     	objAAP4.isSIPexecutionTracker__c = true;
     	
     	objAAP5.Lumpsum_Action__c = 'Switch Out';
     	objAAP6.Lumpsum_Action__c = 'Switch Out';
     	//objAAP5.isLumpsumExecTracker__c = true;
     	//objAAP6.isLumpsumExecTracker__c = true;
     	
     	lstUpdateActionPlan.add(objAAP);
     	lstUpdateActionPlan.add(objAAP1);
     	lstUpdateActionPlan.add(objAAP2);
     	lstUpdateActionPlan.add(objAAP3);
     	lstUpdateActionPlan.add(objAAP4);
     	lstUpdateActionPlan.add(objAAP5);
     	lstUpdateActionPlan.add(objAAP6);
     	
     	
     	update lstUpdateActionPlan;
     	
     	lstUpdateActionPlan.clear();
     	
     	objAAP5.Lumpsum_Action__c = 'Switch In';
     	objAAP6.Lumpsum_Action__c = 'Switch In';
     	objAAP5.isLumpsumExecTracker__c = true;
     	objAAP6.isLumpsumExecTracker__c = true;
     	lstUpdateActionPlan.add(objAAP5);
     	lstUpdateActionPlan.add(objAAP6);*/
     	
     		
     	/*
     	Map<Id,Approve_Action_Plan__c> mapIdToAAP = new Map<Id,Approve_Action_Plan__c> ();
     	for(Approve_Action_Plan__c objAAPlan: lstApproveActionPlan)
     	{
     		mapIdToAAP.put(objAAPlan.Id, objAAPlan);
     	}     	 
     	 */
     	//ARPPCalculationHandler objARPPHandler = new ARPPCalculationHandler();
     	//objARPPHandler.onAfterInsertForARPPWithRunningSIPandLumpsum(mapIdToAAP);
     	
      	//Insert Execution Tracker Record
      	/*
      	
      	Execution_Tracker__c objMET1 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP2.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='Life Insurance', 
      																ET_Status__c='Assigned to Operations');
      	
      	
      	Execution_Tracker__c objMET2 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP3.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='General Insurance', 
      																ET_Status__c='Assigned to Operations');
      																
      	Execution_Tracker__c objMET3 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP1.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='SIP', 
      																ET_Status__c='Assigned to Operations');	
      		
      	List<Execution_Tracker__c> lstExecutionTracker = new List<Execution_Tracker__c>();														
      	Execution_Tracker__c objMET4 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='Lumpsum', 
      																ET_Status__c='Assigned to Operations');																														
      	//lstExecutionTracker.add(objMET1);
      	//lstExecutionTracker.add(objMET2);
      	//lstExecutionTracker.add(objMET3);
      	lstExecutionTracker.add(objMET4);														
      	insert lstExecutionTracker;
      	
      	//objMET1.Agreed_Amount__c= 3000;
      	//update objMET1;
      	*/
      	delete lstApproveActionPlan;
      	//delete objMET1;
    }
    
    static testMethod void ARPPUpdateCalculationHandlerTest() 
    {
        Test.startTest();
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INVESTMENT = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
    	//Create  RecordType custom setting records
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
    	InvestmentAsset__c objInvestMentAsset = new InvestmentAsset__c(Name = 'Mutual Fund', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId());
    	insert objInvestMentAsset; 
    	
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    	insert 	objInsuranceRecType;
    	
    	
    	/*
    		Insert Product Master record
    	*/
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        
        //Insert SIP Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c = PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c = 'Axis SIP Fund', ProductType__c = 'Mutual Fund', Investment_Type__c = 'SIP');
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
        
        
         //Insert Loan Product record
        Product_Master__c objProduct4 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Test Loan', ProductType__c='Loan'
                                                            );
        lstProductMaster.add(objProduct4); 
        
        
         //Insert Loan Product record
        Product_Master__c objProduct5 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Test FD', ProductType__c='Fixed Deposit'
                                                            );
        lstProductMaster.add(objProduct5); 
        
        
         //Insert Loan Product record
        Product_Master__c objProduct6 = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c='Test Bond', ProductType__c='Bond'
                                                            );
        lstProductMaster.add(objProduct6);  
        
        insert lstProductMaster;
        
        //Insert Commission record
        List<Commission__c> lstCommssion = new List<Commission__c>();
        Commission__c objCommission = new Commission__c(Product__c = objProduct.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);
        lstCommssion.add(objCommission);	
           
        Commission__c objCommission1 = new Commission__c(Product__c = objProduct1.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission1);
        Commission__c objCommission2 = new Commission__c(Product__c = objProduct2.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission2);
        
        Commission__c objCommission3 = new Commission__c(Product__c = objProduct3.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission3);
        
        
        
        Commission__c objCommission4 = new Commission__c(Product__c = objProduct4.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 0, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission4);
        
        
        Commission__c objCommission5 = new Commission__c(Product__c = objProduct5.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Min_Months__c = 1, Max_Months__c = 10,
        												Trail_Commission__c = 0, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission5);
        
        
        Commission__c objCommission6 = new Commission__c(Product__c = objProduct6.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 0, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission6);
        									
        insert lstCommssion;		
        
        Map<Id,Product_Master__c> mapIdToProductMaster = new Map<Id,Product_Master__c> ();
     	for(Product_Master__c objPM : lstProductMaster)
     	{
     		mapIdToProductMaster.put(objPM.Id, objPM);
     	}     	 
     	
        						
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser;
        
        /*	
        	Insert smagicbasic SMS Template record. This code is not related to funtionality.
        */ 
        
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
        
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
      	
      	//Action plan record for Current running Lumpsum/SIP
      	Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Hold',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP4);
       
       
        Approve_Action_Plan__c objAAP44 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'STP From',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP44);
        Approve_Action_Plan__c objAAP11 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Redeem',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP11);
        
     	Approve_Action_Plan__c objAAP22 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
  											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
  											Lumpsum_Action__c = 'STP From',
  										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
  										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Stop', 
  										  	Account__c = objAccount1.id, 
  										  	AP_Status__c = 'Opened');	
    	lstApproveActionPlan.add(objAAP22);
    	
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, Scheme_Name__c = 'Axis Lumpsum Fund1', Investment_Asset__c = objInvest.Id,
        										  Product__c = objProduct1.Id, Amount__c = 20000,
      										     Lumpsum_Action__c = 'Switch In', Action_Amount__c =1000,  
      										  	 SIP_Action_Amount__c =1000, SIP_Action__c = 'Continue',
      										     Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP5);
       
       
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=false,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Switch In',Investment_Asset__c = objInvest1.Id,
      										  Scheme_Name__c='Axis SIP Fund',Installments__c = 20,
      										  Action_Amount__c =1000,Product__c = objProduct.Id,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP6);									  
      										  
      										  
      										  
      	
        Approve_Action_Plan__c objAAP = new Approve_Action_Plan__c(isLumpsumExecTracker__c = true, Amount__c = 20000,
      										      Amount_Per_Installment__c = 200, Product_Name__c ='Axis Lumpsum Fund1',Product__c = objProduct1.Id,
      										      Installments__c = 20, Action_Amount__c = 2000,
      										      Item_Type__c = 'Lumpsum', Account__c = objAccount1.id, AP_Status__c = 'Opened');
      										  							  
        lstApproveActionPlan.add(objAAP);			
        
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip',
			        								    isExecutionTracker__c = false, isSIPexecutionTracker__c = true,
			        								    Product_Name__c= 'Axis SIP Fund', Product__c = objProduct.Id,
			     										Amount__c=10000, Amount_Per_Installment__c = 400,
			     										Option__c = 'Growth', Installments__c = 40, 
			     										Item_Type__c = 'SIP', Category__c='Equity', 
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAP1);		
      	
      	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , 
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount1.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
      										  
      	lstApproveActionPlan.add(objAAP2);		
      				
      				
      	Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c ( Product_Name__c = 'Bajaj General Insurance',
				      										Policy_Type__c = 'Critical Illness',
				      										Product__c = objProduct3.Id,
				      										Sum_Assured_Rs__c = 10000, 
				      										Account__c = objAccount1.id,
				     										Amount__c = 10000,  Item_Type__c = 'General Insurance',
				     										isInsuranceExecutionTracker__c = true, Premium_Amount_Rs__c = 500);
     										
     	lstApproveActionPlan.add(objAAP3);
     	
     	
     	
     	Approve_Action_Plan__c objAAPLoan = new Approve_Action_Plan__c (
			        								    isaddonexecutionTracker__c = true,
			        								    Product_Name__c= 'Test Loan', Product__c = objProduct4.Id,
			     										Amount__c=10000,
			     										Item_Type__c = 'Loan',
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAPLoan);	
      	
      	
      	Approve_Action_Plan__c objAAPFD = new Approve_Action_Plan__c (
			        								    isaddonexecutionTracker__c = true,
			        								    Product_Name__c= 'Test FD', Product__c = objProduct5.Id,
			     										Amount__c=10000,
			     										Item_Type__c = 'Fixed Deposit',
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAPFD);	
      	
      	
      	
      	Approve_Action_Plan__c objAAPBond = new Approve_Action_Plan__c (
			        								    isaddonexecutionTracker__c = true,
			        								    Product_Name__c= 'Test Bond', Product__c = objProduct6.Id,
			     										Amount__c=10000,
			     										Item_Type__c = 'Bond',
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAPBond);	
      	
      	
     	
     	insert lstApproveActionPlan;
     	
    	List<Approve_Action_Plan__c> lstUpdateAAP = new List<Approve_Action_Plan__c>();
     	objAAP4.Lumpsum_Action__c = 'Redeem';
     	lstUpdateAAP.add(objAAP4);
     	
     	objAAP44.isExecutionTracker__c = false;
     	lstUpdateAAP.add(objAAP44);
     	
     	objAAP3.Premium_Amount_Rs__c = 5000;
     	lstUpdateAAP.add(objAAP3);
     	
     	objAAP2.Premium_Amount_Rs__c = 5000;
     	lstUpdateAAP.add(objAAP2);
     	
     	objAAPBond.isAddOnExecutionTracker__c= false;
     	lstUpdateAAP.add(objAAPBond);
     	
     	objAAP.isLumpsumExecTracker__c= false;
     	lstUpdateAAP.add(objAAP);
     	
     	objAAP5.isSIPexecutionTracker__c = false;
     	lstUpdateAAP.add(objAAP5);
     	
     	objAAPLoan.Amount__c = 2000;
     	lstUpdateAAP.add(objAAPLoan);
     	
     	objAAPFD.Amount__c = 2000;
     	lstUpdateAAP.add(objAAPFD);
     	
     	
     	update lstUpdateAAP;
     	Test.stopTest();
    }
    static testMethod void ARPPUpdateCalculationHandlerTest1() 
    {
        Test.startTest();
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INVESTMENT = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
    	//Create  RecordType custom setting records
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
    	InvestmentAsset__c objInvestMentAsset = new InvestmentAsset__c(Name = 'Mutual Fund', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId());
    	insert objInvestMentAsset; 
    	
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    	insert 	objInsuranceRecType;
    	
    	
    	/*
    		Insert Product Master record
    	*/
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        
        //Insert SIP Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c = PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c = 'Axis SIP Fund', ProductType__c = 'Mutual Fund', Investment_Type__c = 'SIP');
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
        
        //Insert Commission record
        List<Commission__c> lstCommssion = new List<Commission__c>();
        Commission__c objCommission = new Commission__c(Product__c = objProduct.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);
        lstCommssion.add(objCommission);	
           
        Commission__c objCommission1 = new Commission__c(Product__c = objProduct1.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission1);
        Commission__c objCommission2 = new Commission__c(Product__c = objProduct2.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission2);
        
        Commission__c objCommission3 = new Commission__c(Product__c = objProduct3.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission3);
        									
        insert lstCommssion;		
        
        Map<Id,Product_Master__c> mapIdToProductMaster = new Map<Id,Product_Master__c> ();
     	for(Product_Master__c objPM : lstProductMaster)
     	{
     		mapIdToProductMaster.put(objPM.Id, objPM);
     	}     	 
     	
        						
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser;
        
        /*	
        	Insert smagicbasic SMS Template record. This code is not related to funtionality.
        */ 
        
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
        
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
      	
      	//Action plan record for Current running Lumpsum/SIP
      	Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Hold',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP4);
       
       
        Approve_Action_Plan__c objAAP44 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'STP From',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP44);
        Approve_Action_Plan__c objAAP11 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Redeem',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP11);
        
     	Approve_Action_Plan__c objAAP22 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
  											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
  											Lumpsum_Action__c = 'STP From',
  										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
  										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Stop', 
  										  	Account__c = objAccount1.id, 
  										  	AP_Status__c = 'Opened');	
    	lstApproveActionPlan.add(objAAP22);
    	
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, Scheme_Name__c = 'Axis Lumpsum Fund1', Investment_Asset__c = objInvest.Id,
        										  Product__c = objProduct1.Id, Amount__c = 20000,
      										     Lumpsum_Action__c = 'Switch In', Action_Amount__c =1000,  
      										  	 SIP_Action_Amount__c =1000, SIP_Action__c = 'Continue',
      										     Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP5);
       
       
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=false,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Switch In',Investment_Asset__c = objInvest1.Id,
      										  Scheme_Name__c='Axis SIP Fund',Installments__c = 20,
      										  Action_Amount__c =1000,Product__c = objProduct.Id,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP6);									  
      										  
      										  
      										  
      	
        Approve_Action_Plan__c objAAP = new Approve_Action_Plan__c(isLumpsumExecTracker__c = true, Amount__c = 20000,
      										      Amount_Per_Installment__c = 200, Product_Name__c ='Axis Lumpsum Fund1',Product__c = objProduct1.Id,
      										      Installments__c = 20, Action_Amount__c = 2000,
      										      Item_Type__c = 'Lumpsum', Account__c = objAccount1.id, AP_Status__c = 'Opened');
      										  							  
        lstApproveActionPlan.add(objAAP);			
        
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip',
			        								    isExecutionTracker__c = false, isSIPexecutionTracker__c = true,
			        								    Product_Name__c= 'Axis SIP Fund', Product__c = objProduct.Id,
			     										Amount__c=10000, Amount_Per_Installment__c = 400,
			     										Option__c = 'Growth', Installments__c = 40, 
			     										Item_Type__c = 'SIP', Category__c='Equity', 
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAP1);		
      	
      	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , 
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount1.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
      										  
      	lstApproveActionPlan.add(objAAP2);		
      				
      				
      	Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c ( Product_Name__c = 'Bajaj General Insurance',
				      										Policy_Type__c = 'Critical Illness',
				      										Product__c = objProduct3.Id,
				      										Sum_Assured_Rs__c = 10000, 
				      										Account__c = objAccount1.id,
				     										Amount__c = 10000,  Item_Type__c = 'General Insurance',
				     										isInsuranceExecutionTracker__c = true, Premium_Amount_Rs__c = 500);
     										
     	lstApproveActionPlan.add(objAAP3);
     	
     	insert lstApproveActionPlan;
     	
    	List<Approve_Action_Plan__c> lstUpdateAAP = new List<Approve_Action_Plan__c>();
     	
     	objAAP.Amount__c = 5500;
     	lstUpdateAAP.add(objAAP); 
     	objAAP1.Amount__c = 5500;
     	lstUpdateAAP.add(objAAP1); 
     	
     	objAAP3.isInsuranceExecutionTracker__c = false;
     	lstUpdateAAP.add(objAAP3);
     	
     	objAAP44.isExecutionTracker__c = true;
     	lstUpdateAAP.add(objAAP44); 
     	
     	objAAP4.Lumpsum_Action__c = 'Switch In';
     	lstUpdateAAP.add(objAAP4);
     	
     	objAAP11.Lumpsum_Action__c = 'Hold';
     	lstUpdateAAP.add(objAAP11);
     	
     	objAAP22.SIP_Action__c = 'Hold';
     	lstUpdateAAP.add(objAAP22);
     
     	
     	update lstUpdateAAP;
     	
     	Test.stopTest();
      	
    
    }
    static testMethod void ARPPUpdateCalculationHandlerTest2() 
    {
       
        Test.startTest();
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INVESTMENT = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
    	//Create  RecordType custom setting records
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
    	InvestmentAsset__c objInvestMentAsset = new InvestmentAsset__c(Name = 'Mutual Fund', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId());
    	insert objInvestMentAsset; 
    	
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    	insert 	objInsuranceRecType;
    	
    	
    	/*
    		Insert Product Master record
    	*/
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        
        //Insert SIP Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c = PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c = 'Axis SIP Fund', ProductType__c = 'Mutual Fund', Investment_Type__c = 'SIP');
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
        
        //Insert Commission record
        List<Commission__c> lstCommssion = new List<Commission__c>();
        Commission__c objCommission = new Commission__c(Product__c = objProduct.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);
        lstCommssion.add(objCommission);	
           
        Commission__c objCommission1 = new Commission__c(Product__c = objProduct1.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission1);
        Commission__c objCommission2 = new Commission__c(Product__c = objProduct2.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission2);
        
        Commission__c objCommission3 = new Commission__c(Product__c = objProduct3.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission3);
        									
        insert lstCommssion;		
        
        Map<Id,Product_Master__c> mapIdToProductMaster = new Map<Id,Product_Master__c> ();
     	for(Product_Master__c objPM : lstProductMaster)
     	{
     		mapIdToProductMaster.put(objPM.Id, objPM);
     	}     	 
     	
        						
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser;
        
        /*	
        	Insert smagicbasic SMS Template record. This code is not related to funtionality.
        */ 
        
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
        
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
      	
      	//Action plan record for Current running Lumpsum/SIP
      	Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Hold',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP4);
       
       
        Approve_Action_Plan__c objAAP44 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'STP From',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP44);
        Approve_Action_Plan__c objAAP11 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Redeem',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP11);
        
     	Approve_Action_Plan__c objAAP22 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
  											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
  											Lumpsum_Action__c = 'STP From',
  										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
  										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Stop', 
  										  	Account__c = objAccount1.id, 
  										  	AP_Status__c = 'Opened');	
    	lstApproveActionPlan.add(objAAP22);
    	
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, Scheme_Name__c = 'Axis Lumpsum Fund1', Investment_Asset__c = objInvest.Id,
        										  Product__c = objProduct1.Id, Amount__c = 20000,
      										     Lumpsum_Action__c = 'Switch In', Action_Amount__c =1000,  
      										  	 SIP_Action_Amount__c =1000, SIP_Action__c = 'Continue',
      										     Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP5);
       
       
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=false,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Switch In',Investment_Asset__c = objInvest1.Id,
      										  Scheme_Name__c='Axis SIP Fund',Installments__c = 20,
      										  Action_Amount__c =1000,Product__c = objProduct.Id,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP6);									  
      										  
      										  
      										  
      	
        Approve_Action_Plan__c objAAP = new Approve_Action_Plan__c(isLumpsumExecTracker__c = true, Amount__c = 20000,
      										      Amount_Per_Installment__c = 200, Product_Name__c ='Axis Lumpsum Fund1',Product__c = objProduct1.Id,
      										      Installments__c = 20, Action_Amount__c = 2000,
      										      Item_Type__c = 'Lumpsum', Account__c = objAccount1.id, AP_Status__c = 'Opened');
      										  							  
        lstApproveActionPlan.add(objAAP);			
        
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip',
			        								    isExecutionTracker__c = false, isSIPexecutionTracker__c = true,
			        								    Product_Name__c= 'Axis SIP Fund', Product__c = objProduct.Id,
			     										Amount__c=10000, Amount_Per_Installment__c = 400,
			     										Option__c = 'Growth', Installments__c = 40, 
			     										Item_Type__c = 'SIP', Category__c='Equity', 
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAP1);		
      	
      	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , 
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount1.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
      										  
      	lstApproveActionPlan.add(objAAP2);		
      				
      				
      	Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c ( Product_Name__c = 'Bajaj General Insurance',
				      										Policy_Type__c = 'Critical Illness',
				      										Product__c = objProduct3.Id,
				      										Sum_Assured_Rs__c = 10000, 
				      										Account__c = objAccount1.id,
				     										Amount__c = 10000,  Item_Type__c = 'General Insurance',
				     										isInsuranceExecutionTracker__c = true, Premium_Amount_Rs__c = 500);
     										
     	lstApproveActionPlan.add(objAAP3);
     	
     	insert lstApproveActionPlan;
     	
    	List<Approve_Action_Plan__c> lstUpdateAAP = new List<Approve_Action_Plan__c>();
     
     	objAAP3.Product__c = null;
     	lstUpdateAAP.add(objAAP3);
     	
     	objAAP4.Product__c = null;
     	lstUpdateAAP.add(objAAP4);
     	
     	objAAP5.Product__c = null;
     	lstUpdateAAP.add(objAAP5);
     	
     	objAAP6.Product__c = null;
     	lstUpdateAAP.add(objAAP6);
     	
     	objAAP.Product__c = null;
     	lstUpdateAAP.add(objAAP);
     	
     	update lstUpdateAAP;
     	
     	Test.stopTest();
      	
    
    }
     static testMethod void ARPPUpdateCalculationHandlerTest2_1() 
    {
       
        Test.startTest();
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INVESTMENT = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
    	//Create  RecordType custom setting records
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
    	InvestmentAsset__c objInvestMentAsset = new InvestmentAsset__c(Name = 'Mutual Fund', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId());
    	insert objInvestMentAsset; 
    	
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    	insert 	objInsuranceRecType;
    	
    	
    	/*
    		Insert Product Master record
    	*/
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        
        //Insert SIP Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c = PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c = 'Axis SIP Fund', ProductType__c = 'Mutual Fund', Investment_Type__c = 'SIP');
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
        
        //Insert Commission record
        List<Commission__c> lstCommssion = new List<Commission__c>();
        Commission__c objCommission = new Commission__c(Product__c = objProduct.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);
        lstCommssion.add(objCommission);	
           
        Commission__c objCommission1 = new Commission__c(Product__c = objProduct1.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission1);
        Commission__c objCommission2 = new Commission__c(Product__c = objProduct2.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission2);
        
        Commission__c objCommission3 = new Commission__c(Product__c = objProduct3.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission3);
        									
        insert lstCommssion;		
        
        Map<Id,Product_Master__c> mapIdToProductMaster = new Map<Id,Product_Master__c> ();
     	for(Product_Master__c objPM : lstProductMaster)
     	{
     		mapIdToProductMaster.put(objPM.Id, objPM);
     	}     	 
     	
        						
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser;
        
        /*	
        	Insert smagicbasic SMS Template record. This code is not related to funtionality.
        */ 
        
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
        
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
      	
      	//Action plan record for Current running Lumpsum/SIP
      	Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Hold',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP4);
       
       
        Approve_Action_Plan__c objAAP44 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'STP From',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP44);
        Approve_Action_Plan__c objAAP11 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Redeem',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP11);
        
     	Approve_Action_Plan__c objAAP22 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
  											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
  											Lumpsum_Action__c = 'STP From',
  										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
  										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Stop', 
  										  	Account__c = objAccount1.id, 
  										  	AP_Status__c = 'Opened');	
    	lstApproveActionPlan.add(objAAP22);
    	
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, Scheme_Name__c = 'Axis Lumpsum Fund1', Investment_Asset__c = objInvest.Id,
        										  Product__c = objProduct1.Id, Amount__c = 20000,
      										     Lumpsum_Action__c = 'Switch In', Action_Amount__c =1000,  
      										  	 SIP_Action_Amount__c =1000, SIP_Action__c = 'Continue',
      										     Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP5);
       
       
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=false,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Switch In',Investment_Asset__c = objInvest1.Id,
      										  Scheme_Name__c='Axis SIP Fund',Installments__c = 20,
      										  Action_Amount__c =1000,Product__c = objProduct.Id,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP6);									  
      										  
      										  
      										  
      	
        Approve_Action_Plan__c objAAP = new Approve_Action_Plan__c(isLumpsumExecTracker__c = true, Amount__c = 20000,
      										      Amount_Per_Installment__c = 200, Product_Name__c ='Axis Lumpsum Fund1',Product__c = objProduct1.Id,
      										      Installments__c = 20, Action_Amount__c = 2000,
      										      Item_Type__c = 'Lumpsum', Account__c = objAccount1.id, AP_Status__c = 'Opened');
      										  							  
        lstApproveActionPlan.add(objAAP);			
        
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip',
			        								    isExecutionTracker__c = false, isSIPexecutionTracker__c = true,
			        								    Product_Name__c= 'Axis SIP Fund', Product__c = objProduct.Id,
			     										Amount__c=10000, Amount_Per_Installment__c = 400,
			     										Option__c = 'Growth', Installments__c = 40, 
			     										Item_Type__c = 'SIP', Category__c='Equity', 
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAP1);		
      	
      	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , 
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount1.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
      										  
      	lstApproveActionPlan.add(objAAP2);		
      				
      				
      	Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c ( Product_Name__c = 'Bajaj General Insurance',
				      										Policy_Type__c = 'Critical Illness',
				      										Product__c = objProduct3.Id,
				      										Sum_Assured_Rs__c = 10000, 
				      										Account__c = objAccount1.id,
				     										Amount__c = 10000,  Item_Type__c = 'General Insurance',
				     										isInsuranceExecutionTracker__c = true, Premium_Amount_Rs__c = 500);
     										
     	lstApproveActionPlan.add(objAAP3);
     	
     	insert lstApproveActionPlan;
     	
     	delete lstApproveActionPlan[0];
     	
     	Test.stopTest();
      	
    
    }
    static testMethod void ARPPCalculationHandlerForDeleleActionPlanTest() 
    {
    	Test.startTest();
       
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INVESTMENT = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
    	//Create  RecordType custom setting records
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
    	InvestmentAsset__c objInvestMentAsset = new InvestmentAsset__c(Name = 'Mutual Fund', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INVESTMENT.get('Mutual Fund').getRecordTypeId());
    	insert objInvestMentAsset; 
    	
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', RecordTypeId__c = RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    	insert 	objInsuranceRecType;
    	
    	
    	/*
    		Insert Product Master record
    	*/
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Axis1', Short_Code__c='Axis1', Is_Active__c = true);
        insert PM1;
        
        List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
        
        //Insert SIP Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c = PM1.Id, 
                                                            Is_Active__c=true, Product_Name__c = 'Axis SIP Fund', ProductType__c = 'Mutual Fund', Investment_Type__c = 'SIP');
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
        
        //Insert Commission record
        List<Commission__c> lstCommssion = new List<Commission__c>();
        Commission__c objCommission = new Commission__c(Product__c = objProduct.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);
        lstCommssion.add(objCommission);	
           
        Commission__c objCommission1 = new Commission__c(Product__c = objProduct1.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission1);
        Commission__c objCommission2 = new Commission__c(Product__c = objProduct2.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);	
        lstCommssion.add(objCommission2);
        
        Commission__c objCommission3 = new Commission__c(Product__c = objProduct3.Id, Active__c = true,
        												Max_Year_Value__c = 10, Min_Year_Value__c = 0 ,
        												Trail_Commission__c = 10, Upfront_Commission__c = 20);																									
        lstCommssion.add(objCommission3);
        									
        insert lstCommssion;		
        
        Map<Id,Product_Master__c> mapIdToProductMaster = new Map<Id,Product_Master__c> ();
     	for(Product_Master__c objPM : lstProductMaster)
     	{
     		mapIdToProductMaster.put(objPM.Id, objPM);
     	}     	 
     	
        						
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser;
        
        /*	
        	Insert smagicbasic SMS Template record. This code is not related to funtionality.
        */ 
        
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
        
        
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
      	
      	//Action plan record for Current running Lumpsum/SIP
      	Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Hold',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP4);
       
       
        Approve_Action_Plan__c objAAP44 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'STP From',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP44);
        Approve_Action_Plan__c objAAP11 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
      											Scheme_Name__c = 'Axis SIP Fund', Product__c = objProduct.Id, Amount__c = 20000, Action_Amount__c =1000, 
      											Lumpsum_Action__c = 'Redeem',
      										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
      										  	SIP_Action_Amount__c = 2000, SIP_Action__c='Continue', 
      										  	Account__c = objAccount1.id, 
      										  	AP_Status__c = 'Opened');	
        lstApproveActionPlan.add(objAAP11);
        
     	Approve_Action_Plan__c objAAP22 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, 
  											Scheme_Name__c = 'Axis Lumpsum Fund', Product__c = objProduct1.Id, Amount__c = 20000, Action_Amount__c =1000, 
  											Lumpsum_Action__c = 'STP From',
  										  	Amount_Per_Installment__c = 200, Investment_Asset__c = objInvest2.Id,
  										  	SIP_Action_Amount__c = 2000,
  										  	Account__c = objAccount1.id, 
  										  	AP_Status__c = 'Opened');	
    	lstApproveActionPlan.add(objAAP22);
    	
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(isSIPexecutionTracker__c = true, isExecutionTracker__c = true, Scheme_Name__c = 'Axis Lumpsum Fund1', Investment_Asset__c = objInvest.Id,
        										  Product__c = objProduct1.Id, Amount__c = 20000,
      										     Lumpsum_Action__c = 'Switch In', Action_Amount__c =1000,  
      										  	 SIP_Action_Amount__c =1000, SIP_Action__c = 'Continue',
      										     Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP5);
       
       
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(isLumpsumExecTracker__c=false,isExecutionTracker__c =true, Remarks__c='test Lumpsum', Amount__c = 20000,
      										  Amount_Per_Installment__c = 200,  Lumpsum_Action__c='Switch In',Investment_Asset__c = objInvest1.Id,
      										  Scheme_Name__c='Axis SIP Fund',Installments__c = 20,
      										  Action_Amount__c =1000,Product__c = objProduct.Id,
      										  Account__c = objAccount1.id, AP_Status__c = 'Opened');	
      										  								
        lstApproveActionPlan.add(objAAP6);									  
      										  
      										  
      										  
      	
        Approve_Action_Plan__c objAAP = new Approve_Action_Plan__c(isLumpsumExecTracker__c = true, Amount__c = 20000,
      										      Amount_Per_Installment__c = 200, Product_Name__c ='Axis Lumpsum Fund1',Product__c = objProduct1.Id,
      										      Installments__c = 20, Action_Amount__c = 2000,
      										      Item_Type__c = 'Lumpsum', Account__c = objAccount1.id, AP_Status__c = 'Opened');
      										  							  
        lstApproveActionPlan.add(objAAP);			
        
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip',
			        								    isExecutionTracker__c = false, isSIPexecutionTracker__c = true,
			        								    Product_Name__c= 'Axis SIP Fund', Product__c = objProduct.Id,
			     										Amount__c=10000, Amount_Per_Installment__c = 400,
			     										Option__c = 'Growth', Installments__c = 40, 
			     										Item_Type__c = 'SIP', Category__c='Equity', 
			     										Account__c = objAccount1.id, AP_Status__c = 'Opened');	
     															  
      	lstApproveActionPlan.add(objAAP1);		
      	
      	
      	Approve_Action_Plan__c objAAP2= new Approve_Action_Plan__c(Amount__c = 20000, Suggested_Cover__c =1000000, Sum_Assured_Rs__c = 10000,  
			      										  Policy_Name__c = 'Axis Life Insurance', Amount_Per_Installment__c = 200, Installments__c = 20, 
			      										  Insurance__c = insurance1.Id, 
			      										  Product__c = objProduct2.Id,
			      										  Policy_Type__c = 'Term Life', Tenure_of_Insurance__c = 5 , 
			      										  Item_Type__c = 'Life Insurance', Account__c = objAccount1.id, isInsuranceExecutionTracker__c = true,
			      										  AP_Status__c = 'Opened', Premium_Amount_Rs__c = 1000);
      										  
      	lstApproveActionPlan.add(objAAP2);		
      				
      				
      	Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c ( Product_Name__c = 'Bajaj General Insurance',
				      										Policy_Type__c = 'Critical Illness',
				      										Product__c = objProduct3.Id,
				      										Sum_Assured_Rs__c = 10000, 
				      										Account__c = objAccount1.id,
				     										Amount__c = 10000,  Item_Type__c = 'General Insurance',
				     										isInsuranceExecutionTracker__c = true, Premium_Amount_Rs__c = 500);
     										
     	lstApproveActionPlan.add(objAAP3);
     	
     	insert lstApproveActionPlan;
     	
     	
     	/*List<Approve_Action_Plan__c> lstUpdateActionPlan = new List<Approve_Action_Plan__c>();
     	
     	objAAP.isSIPexecutionTracker__c = true;
     	
     	objAAP1.isLumpsumExecTracker__c = true;
     	objAAP2.isInsuranceExecutionTracker__c = true;
     	objAAP3.isInsuranceExecutionTracker__c = true;
     	objAAP4.isSIPexecutionTracker__c = true;
     	
     	objAAP5.Lumpsum_Action__c = 'Switch Out';
     	objAAP6.Lumpsum_Action__c = 'Switch Out';
     	//objAAP5.isLumpsumExecTracker__c = true;
     	//objAAP6.isLumpsumExecTracker__c = true;
     	
     	lstUpdateActionPlan.add(objAAP);
     	lstUpdateActionPlan.add(objAAP1);
     	lstUpdateActionPlan.add(objAAP2);
     	lstUpdateActionPlan.add(objAAP3);
     	lstUpdateActionPlan.add(objAAP4);
     	lstUpdateActionPlan.add(objAAP5);
     	lstUpdateActionPlan.add(objAAP6);
     	
     	
     	update lstUpdateActionPlan;
     	
     	lstUpdateActionPlan.clear();
     	
     	objAAP5.Lumpsum_Action__c = 'Switch In';
     	objAAP6.Lumpsum_Action__c = 'Switch In';
     	objAAP5.isLumpsumExecTracker__c = true;
     	objAAP6.isLumpsumExecTracker__c = true;
     	lstUpdateActionPlan.add(objAAP5);
     	lstUpdateActionPlan.add(objAAP6);*/
     	
     	//objARPPHandler.onAfterInsertForARPPWithRunningSIPandLumpsum(mapIdToAAP);
     	
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
      																
      	Execution_Tracker__c objMET4 = new Execution_Tracker__c(Approve_Action_Plan__c = objAAP22.id,Agreed_Amount__c =3000, Executed_Amount__c=100, Application_Status__c='Closed',
      																Entity_Name__c = objAccount1.Id, Type__c='Lumpsum', 
      																ET_Status__c='Assigned to Operations');																														
      	lstExecutionTracker.add(objMET1);
      	lstExecutionTracker.add(objMET2);
      	lstExecutionTracker.add(objMET3);
      	lstExecutionTracker.add(objMET4);														
      	insert lstExecutionTracker;
      	
      	objMET4.Agreed_Amount__c= 3100;
      	update objMET1;
      	
      	delete objMET1;
      	Test.stopTest();
    }
    
}