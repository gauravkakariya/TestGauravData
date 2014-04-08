/* 
*  Test class for Controller class that displays Action Plan as well as Execution Tracker functionality.
*  Contains the logic for storing ET records in database as well as Send email functionality
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi/Anupam    07/01/2013      Initial Draft
*/
@isTest
private class ActionPlanControllerTest 
{ 
	static Account objAccount;
	static Goal__c objEmergencyGoal1;
	static Goal__c objEducationGoal1;
	static Goal__c objEmergencyGoal;
	static Goal__c objEducationGoal;
	static Investment_Asset__c MFinvest1;
	static Investment_Asset__c MFinvest;
	static Insurance__c lifeInsurance1;
	static Insurance__c insurance2;
	public static void testData()
	{
		List<Goal__c> lstGoal = new List<Goal__c>();
    	List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
    	List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
   		List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
    	List<Insurance__c> lstInsurance = new List<Insurance__c>();
    	List<GoalInsuranceAssociation__c> lstGoalInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
    	List<Account> lstAcc = new List<Account>();
    	
    	ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );

        insert userobj;

		//BB USer
		Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        User partnerUser = [select Id from User where profileid =: prof.id and IsActive = true limit 1];
        
    	objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    lstAcc.add(objAccount);
	    
	    Account objBPAccount = new Account(LastName='Test BP',Adjustment_Factor__c='2', OwnerId = partnerUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Business Partner',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = false);
	    lstAcc.add(objBPAccount);
	    insert lstAcc;
	    lstAcc[1].Related_To__c = 'Business Partner';
	    update lstAcc[1];
	    //Assets
	    
	    RecordType objRecType = [Select Name, Id From RecordType  where Name = 'GeneralInsurancePlanning'];
	    //insert objRecType;
	    
	    Remarks__c objRemarks = new Remarks__c(Entity__c=objAccount.id,Remark__c='aaa',RecordTypeId  = objRecType.Id);
	    insert objRemarks;
		RecordType objRecType1 = [Select Name, Id From RecordType  where Name = 'LifeInsurancePlanning'];
	    //insert objRecType;
	    
	    Remarks__c objRemarks1 = new Remarks__c(Entity__c=objAccount.id,Remark__c='aaa',RecordTypeId  = objRecType1.Id);
	    insert objRemarks1;
		
    	Asset__c objAsset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
      	insert objAsset;
      	Asset__c objAssetRecord = new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c,Current_Value__c = 200);
      	insert objAssetRecord;
      	Asset__c objAssetRecord1 = new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c,Current_Value__c = 200);
      	insert objAssetRecord1;
      	
      	objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	lstGoal.add(objEmergencyGoal);
      	
  	    objEducationGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
      	lstGoal.add(objEducationGoal);
      	
        objEmergencyGoal1 = new Goal__c(Entity__c=objBPAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	lstGoal.add(objEmergencyGoal1);
      	
  	    objEducationGoal1 = new Goal__c(Entity__c=objBPAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
      	lstGoal.add(objEducationGoal1);
      	
      	
      	insert lstGoal;
      	
      	GoalSIPAmount__c objSIPAmount1 = new GoalSIPAmount__c(Goal__c = objEducationGoal.id,Goal_Year__c = system.today().year(),isNewSIP__c = true,
      									SIP_Gold__c=50,SIP_Equity__c=50,SIP_Debt__c=100);
      	insert objSIPAmount1;
      	
      	GoalSIPAmount__c objSIPAmount2 = new GoalSIPAmount__c(Goal__c = objEmergencyGoal.id,Goal_Year__c = system.today().year(),isNewSIP__c = true,
      									SIP_Gold__c=50,SIP_Equity__c=50,SIP_Debt__c=100);
      	insert objSIPAmount2;
      	
      	GoalAssetAssociation__c objGoalAssetAssociation1 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEmergencyGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
      	lstGoalAssetAssociation.add(objGoalAssetAssociation1);

		GoalAssetAssociation__c objGoalAssetAssociation2 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEducationGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
      	lstGoalAssetAssociation.add(objGoalAssetAssociation2);
      	GoalAssetAssociation__c objGoalAssetAssociation3 = new GoalAssetAssociation__c(Asset__c=objAssetRecord.id,Goal__c=objEducationGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
      	lstGoalAssetAssociation.add(objGoalAssetAssociation3);
      	
      	
      	insert lstGoalAssetAssociation;
      	//Investment Asset
	    Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
        													//RecordTypeId='01220000000HYx5AAG'
      	lstInvestmentAsset.add(inv);
      	Investment_Asset__c invest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(invest);
      	MFinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(MFinvest);
      	MFinvest1 = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(MFinvest1);
      	Investment_Asset__c invest1 = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, Maturity_Date__c = system.today(),
      														RecordTypeId=InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c,
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(invest1);
      	insert lstInvestmentAsset;


      	GoalInvestmentAssetAssociation__c gasset1 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset1);
      	GoalInvestmentAssetAssociation__c gasset22 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset22);
  	 	GoalInvestmentAssetAssociation__c gasset2 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=MFinvest1.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset2);
      	GoalInvestmentAssetAssociation__c gasset33 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest1.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset33);
      	insert lstGoalInvestmentAssetAssociation;
      	
      	
      	//Insurance Assets 
      	Insurance__c insurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss',
	    											Nominee__c = objAccount.Id);
	    lstInsurance.add(insurance);
	    
	    Insurance__c generalInsurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(generalInsurance);
	    
	    Insurance__c insurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(insurance1);
	    
	    lifeInsurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(lifeInsurance1);
	    insurance2 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Endowment',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(insurance2);
		insert lstInsurance;
      	
      	GoalInsuranceAssociation__c goalInsurance = new GoalInsuranceAssociation__c(Insurance__c=insurance.id,Goal__c=objEmergencyGoal.id,Allocated__c=30);
      	lstGoalInsuranceAssociation.add(goalInsurance);
      	GoalInsuranceAssociation__c goalInsurance1 = new GoalInsuranceAssociation__c(Insurance__c=insurance1.id,Goal__c=objEducationGoal.id,Allocated__c=30);
      	lstGoalInsuranceAssociation.add(goalInsurance1);
      	GoalInsuranceAssociation__c goalInsurance2 = new GoalInsuranceAssociation__c(Insurance__c=insurance2.id,Goal__c=objEducationGoal.id,Allocated__c=30);
      	lstGoalInsuranceAssociation.add(goalInsurance2);
      	insert lstGoalInsuranceAssociation;
      	
      	
      	
      	//Approve Action Plan Records
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new list<Approve_Action_Plan__c>();
      	
      	Approve_Action_Plan__c objAp = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c=true,AP_Status__c = 'Opened');
      										  
      	lstApproveActionPlan.add(objAp);
      	lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id,Lumpsum_Equity__c=20,Lumpsum_Debt__c=20,
      										  Lumpsum_Gold__c=20,AP_Status__c = 'Opened'));
  									  
      	lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Sum_Assured_Rs__c = 10000 ,Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt', Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
      										  AP_Status__c = 'Opened'));									  
		
		lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
															Investment_Asset__c = invest.id,isNewMutualFund__c = true,
				     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
				     										Category__c='Equity',isExecutionTracker__c =true,AP_Status__c = 'Opened'));
		lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
															Investment_Asset__c = invest.id,
				     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
				     										Category__c='Equity',isExecutionTracker__c =true,AP_Status__c = 'Opened'));
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
     										Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'));
     	
     	lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',
     										Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'));
   		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',
     										Category__c='Equity',Investment_Asset__c = invest.id ,isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'));
		
		//SIP Funds for Other Goals
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEducationGoal.id,
											Account__c=objAccount.id,Product_Name__c='aaaa',Amount__c=10000,Option__c = 'Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',Category__c='Equity',AP_Status__c = 'Opened'));  
     										
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEducationGoal.id,
											Account__c=objAccount.id,Product_Name__c='aaaa',Amount__c=10000,Option__c = 'Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',Category__c='Equity',AP_Status__c = 'Opened')); 
		
		//SIP Funds for Emergency Fund Goals
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEmergencyGoal.id,
											Account__c=objAccount.id,Product_Name__c='aaaa',Amount__c=10000,Option__c = 'Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',Category__c='Equity',AP_Status__c = 'Opened')); 
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEmergencyGoal.id,
											Account__c=objAccount.id,Product_Name__c='aaaa',Amount__c=10000,Option__c = 'Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',Category__c='Equity',AP_Status__c = 'Opened')); 
		
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Sum_Assured_Rs__c = 10000, Installments__c=40, Item_Type__c = 'General Insurance',
     										Category__c='Equity', isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened'));
     										
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance1.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Sum_Assured_Rs__c = 10000,Installments__c=40, Item_Type__c = 'Life Insurance',
     										Category__c='Equity', Suggested_Cover__c=1000,isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened'));
     										
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'Life Insurance',
     										Category__c='Equity',Sum_Assured_Rs__c=100, isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened'));
     										
      	lstApproveActionPlan.add( new Approve_Action_Plan__c (Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id,isWill__c = true,AP_Status__c = 'Opened'));
      	//for Add new General Insurance
 		lstApproveActionPlan.add(new Approve_Action_Plan__c (isInsuranceExecutionTracker__c=true, Product_Name__c='test SIP',Insured__c='aaa',Account__c=objAccount.id,
     										Policy_Type__c='bbb',Fund__c='HDFC Top 200 Fund',Sum_Assured_Rs__c=400,Option__c='Growth',Premium_Amount_Rs__c=40, Item_Type__c = 'General Insurance',
     										Category__c='Equity',AP_Status__c = 'Opened',InsuranceRemark__c = 'aaa'));																		  
  		lstApproveActionPlan.add(new Approve_Action_Plan__c (isInsuranceExecutionTracker__c=true, Product_Name__c='test SIP',Insured__c='aaa',Account__c=objAccount.id,
     										Policy_Type__c='bbb',Fund__c='HDFC Top 200 Fund',Sum_Assured_Rs__c=400,Option__c='Growth',Premium_Amount_Rs__c=40, Item_Type__c = 'Recommended Insurance',
     										Category__c='Equity',AP_Status__c = 'Opened',InsuranceRemark__c = 'aaa'));																		  
      							  
      	//BP records
      	lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEmergencyGoal.id,
											Account__c=objBPAccount.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c = 'Growth',Installments__c=40, 
     										Item_Type__c = 'SIP',
     										Category__c='Equity',AP_Status__c = 'Opened')); 
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,
											Account__c=objBPAccount.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
     										 Item_Type__c = 'SIP',
     										Category__c='Equity')); 
		
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objBPAccount.id,Insurance__c = insurance.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'General Insurance',
     										Category__c='Equity', isInsuranceExecutionTracker__c = true, Sum_Assured_Rs__c = 10000));
     										
		lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objBPAccount.id,Insurance__c = insurance1.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Sum_Assured_Rs__c = 10000,Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'Life Insurance',
     										Category__c='Equity', isInsuranceExecutionTracker__c = true));
		
      	lstApproveActionPlan.add( new Approve_Action_Plan__c (Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objBPAccount.id,isWill__c = true));									  
  		lstApproveActionPlan.add( new Approve_Action_Plan__c (Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 20000,Sum_Assured_Rs__c = 10000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Recommended Insurance', Account__c = objBPAccount.id,isInsuranceExecutionTracker__c = true));														  
      	
     	insert lstApproveActionPlan;
      	
      	Execution_Tracker__c objET = new Execution_Tracker__c(Approve_Action_Plan__c =objAp.Id,Entity_Name__c = objAccount.Id,Application_Status__c = 'Processed',Is_Floating__c=false);
      	insert objET;
      	//Operations User
      	// ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	 User userOps = new User( email='test-user@fakeemail.com', profileid = ProfileID, UserName='operationuser@fakeemail.com', 
      	 							alias='opsuser1', CommunityNickName='opsuser',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'OpsFirstName',
      	 						    LastName = 'OpsLastName' );
         insert userOps;
      	
      	//WorkStation
      	System.debug('------------- objAccount.OwnerId test---------------'+ objAccount.OwnerId);
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = objAccount.OwnerId,
															   		Financial_Planner__c = objAccount.OwnerId,
															   		Operations__c = userOps.Id);
		insert objWorkstation;
      	
      	
      	Entity_Global_Assumption__c	ega = new Entity_Global_Assumption__c(Account__c=objAccount.id,Expected_Return_on_Investment__c=30,
      																Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5,
      																Gold_Growth_Rate__c=10,	   /* Prajakta - FP changes - 01-04-2013 */
      																Stock_Growth_Rate__c=10);
       	insert ega;  
      	
	}
	
	public static testMethod void testActionPlanController()
	{
    	testData();
		Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId', objEducationGoal1.id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest1.Id);
	     Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',lifeInsurance1.Id);
	    ActionPlanController actionPlan = new ActionPlanController();
	    //objExecutionTracker.createExecutionTracker();
	    actionPlan.showExecutionTracker();
	    actionPlan.getExecutionTracker();
	    Test.stopTest();
	}
	
	
	public static testMethod void testActionPlanController4()
	{
    	testData();
		Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId', objEducationGoal1.id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest1.Id);
	     Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',lifeInsurance1.Id);
	    ActionPlanController actionPlan = new ActionPlanController();
	    //objExecutionTracker.createExecutionTracker();
	    actionPlan.getSummarySIPFunds();
	    actionPlan.addNewLumpsumFund();
	    actionPlan.addNewSIPFund();
	    actionPlan.addCurrentMutualFundRow();
	    Test.stopTest();
	}
	
	public static testMethod void testActionPlanControllerGenerateAP()
	{
    	testData();
		Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId', objEducationGoal1.id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest1.Id);
	     Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',lifeInsurance1.Id);
	    ActionPlanController actionPlan = new ActionPlanController();
	    //objExecutionTracker.createExecutionTracker();
	    actionPlan.generateNewAP();
	    Test.stopTest();
	}
	
	public static testMethod void testActionPlanControllerClone()
	{
    	testData();
		Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId', objEducationGoal1.id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest1.Id);
	     Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',lifeInsurance1.Id);
	    ActionPlanController actionPlan = new ActionPlanController();
	    //objExecutionTracker.createExecutionTracker();
	    //actionPlan.cloneActionPlan();
	    Test.stopTest();
	}
	
	public static testMethod void testActionPlanController3()
	{
    	testData();
		Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId', objEducationGoal1.id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal1.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest1.Id);
	     Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',lifeInsurance1.Id);
	    ActionPlanController actionPlan = new ActionPlanController();
	    //objExecutionTracker.createExecutionTracker();
	    actionPlan.actionPlanPDF();
	    actionPlan.saveActionPlanPDF();
	    Test.stopTest();
	}
	
	public static testMethod void testActionPlanController1()
	{
		testData1();
		Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId', objEducationGoal.id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest1.Id);
	    Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',lifeInsurance1.Id);
	    ActionPlanController actionPlan = new ActionPlanController();
	    actionPlan.removeNewGIrecords();
	    actionPlan.addNewLifeInsuranceRow();
	    actionPlan.makeRequiredOnSTPFrom();
	    actionPlan.showPreview();
	    actionPlan.showActionPlan();
	    actionPlan.removeInsuranceId = lifeInsurance1.Id;
	    //actionPlan.removeLifeInsuracneRow();
	    actionPlan.removeInvestmentId = MFinvest1.Id;
	    actionPlan.upsertData();
	    Test.stopTest();
	}
	
	public static void testData1()
	{
		List<Goal__c> lstGoal = new List<Goal__c>();
    	List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
    	List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
   		List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
    	List<Insurance__c> lstInsurance = new List<Insurance__c>();
    	List<GoalInsuranceAssociation__c> lstGoalInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
    	List<Account> lstAcc = new List<Account>();
    	
    	ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );

        insert userobj;

		//BB USer
		Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        User partnerUser = [select Id from User where profileid =: prof.id and IsActive = true limit 1];
        
    	objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    lstAcc.add(objAccount);
	    insert lstAcc;
	    
	  /*  Account objBPAccount = new Account(LastName='Test BP',Adjustment_Factor__c='2', OwnerId = partnerUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Business Partner',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = false);
	    lstAcc.add(objBPAccount);
	    insert lstAcc;
	    lstAcc[1].Related_To__c = 'Business Partner';
	    update lstAcc[1];*/
	    //Assets
	    
	     RecordType objRecType = [Select Name, Id From RecordType  where Name = 'GeneralInsurancePlanning'];
	    //insert objRecType;
	    
	    Remarks__c objRemarks = new Remarks__c(Entity__c=objAccount.id,Remark__c='aaa',RecordTypeId  = objRecType.Id);
	    insert objRemarks;
		 RecordType objRecType1 = [Select Name, Id From RecordType  where Name = 'LifeInsurancePlanning'];
	    //insert objRecType;
	    
	    Remarks__c objRemarks1 = new Remarks__c(Entity__c=objAccount.id,Remark__c='aaa',RecordTypeId  = objRecType1.Id);
	    insert objRemarks1;
		
	    
    	Asset__c objAsset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
      	insert objAsset;
      	Asset__c objAssetRecord = new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c,Current_Value__c = 200);
      	insert objAssetRecord;
      	Asset__c objAssetRecord1 = new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c,Current_Value__c = 200);
      	insert objAssetRecord1;
      	
      	objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	lstGoal.add(objEmergencyGoal);
      	
  	    objEducationGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
      	lstGoal.add(objEducationGoal);
      	
    /*  	objEmergencyGoal1 = new Goal__c(Entity__c=objBPAccount.id,Goal_Type__c='Emergency Fund',Description__c = 'Emergency Fund');
      	lstGoal.add(objEmergencyGoal1);
      	
  	    objEducationGoal1 = new Goal__c(Entity__c=objBPAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
      	lstGoal.add(objEducationGoal1);
      	
      	*/
      	insert lstGoal;
      	
      	GoalSIPAmount__c objSIPAmount1 = new GoalSIPAmount__c(Goal__c = objEducationGoal.id,Goal_Year__c = system.today().year(),isNewSIP__c = true,
      									SIP_Gold__c=50,SIP_Equity__c=50,SIP_Debt__c=100);
      	insert objSIPAmount1;
      	
      	GoalSIPAmount__c objSIPAmount2 = new GoalSIPAmount__c(Goal__c = objEmergencyGoal.id,Goal_Year__c = system.today().year(),isNewSIP__c = true,
      									SIP_Gold__c=50,SIP_Equity__c=50,SIP_Debt__c=100);
      	insert objSIPAmount2;
      	
      	GoalAssetAssociation__c objGoalAssetAssociation1 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEmergencyGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
      	lstGoalAssetAssociation.add(objGoalAssetAssociation1);

		GoalAssetAssociation__c objGoalAssetAssociation2 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEducationGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
      	lstGoalAssetAssociation.add(objGoalAssetAssociation2);
      	GoalAssetAssociation__c objGoalAssetAssociation3 = new GoalAssetAssociation__c(Asset__c=objAssetRecord.id,Goal__c=objEducationGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
      	lstGoalAssetAssociation.add(objGoalAssetAssociation3);
      	
      	
      	insert lstGoalAssetAssociation;
      	//Investment Asset
	    Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c,
	    												Maturity_Date__c = system.today());
        													//RecordTypeId='01220000000HYx5AAG'
      	lstInvestmentAsset.add(inv);
      	Investment_Asset__c invest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(invest);
      	MFinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(MFinvest);
      	MFinvest1 = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(MFinvest1);
      	Investment_Asset__c invest1 = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, Maturity_Date__c = system.today(),
      														RecordTypeId=InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c,
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
      	lstInvestmentAsset.add(invest1);
      	insert lstInvestmentAsset;


      	GoalInvestmentAssetAssociation__c gasset1 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset1);
      	GoalInvestmentAssetAssociation__c gasset22 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset22);
  	 	GoalInvestmentAssetAssociation__c gasset2 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=MFinvest1.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset2);
      	GoalInvestmentAssetAssociation__c gasset33 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest1.id,Goal__c=objEducationGoal.id,allocated__c=45);
      	lstGoalInvestmentAssetAssociation.add(gasset33);
      	insert lstGoalInvestmentAssetAssociation;
      	
      	
      	//Insurance Assets 
      	Insurance__c insurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss',
	    											Nominee__c = objAccount.Id);
	    lstInsurance.add(insurance);
	    
	    Insurance__c generalInsurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(generalInsurance);
	    
	    Insurance__c insurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(insurance1);
	    
	    lifeInsurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(lifeInsurance1);
	    insurance2 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Endowment',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    lstInsurance.add(insurance2);
		insert lstInsurance;
      	
      	GoalInsuranceAssociation__c goalInsurance = new GoalInsuranceAssociation__c(Insurance__c=insurance.id,Goal__c=objEmergencyGoal.id,Allocated__c=30);
      	lstGoalInsuranceAssociation.add(goalInsurance);
      	GoalInsuranceAssociation__c goalInsurance1 = new GoalInsuranceAssociation__c(Insurance__c=insurance1.id,Goal__c=objEducationGoal.id,Allocated__c=30);
      	lstGoalInsuranceAssociation.add(goalInsurance1);
      	GoalInsuranceAssociation__c goalInsurance2 = new GoalInsuranceAssociation__c(Insurance__c=insurance2.id,Goal__c=objEducationGoal.id,Allocated__c=30);
      	lstGoalInsuranceAssociation.add(goalInsurance2);
      	insert lstGoalInsuranceAssociation;
      	
      	
      	
      	//Approve Action Plan Records
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new list<Approve_Action_Plan__c>();
      	
      	Approve_Action_Plan__c objAp = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Closed');
      										  
      	lstApproveActionPlan.add(objAp);
      	lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id,Lumpsum_Equity__c=20,Lumpsum_Debt__c=20,
      										  Lumpsum_Gold__c=20,AP_Status__c = 'Closed'));
  									  
      	lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt', Sum_Assured_Rs__c = 10000,Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
      										  AP_Status__c = 'Closed'));	
      	insert 	lstApproveActionPlan;							  
    	Execution_Tracker__c objET = new Execution_Tracker__c(Entity_Name__c = objAccount.Id,Application_Status__c = 'Processed',Is_Floating__c = false);
      	insert objET;
      	Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.Id,Application_Status__c = 'Opened',Is_Floating__c = false);
      	insert objET1;
      	Entity_Global_Assumption__c	ega = new Entity_Global_Assumption__c(Account__c=objAccount.id,Expected_Return_on_Investment__c=30,
      																	Gold_Growth_Rate__c=10,	   /* Prajakta - FP changes - 01-04-2013 */
      																Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5,Stock_Growth_Rate__c=10);
       	insert ega;  
      										  
	}
	
	public static testMethod void testActionPlanController2()
	{
    	testData1();
     	Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest.Id);
	    Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',insurance2.Id);
	    
	    
	    ActionPlanController actionPlan = new ActionPlanController();
	    actionPlan.saveActionPlan();
	    pageReference p1 = actionPlan.addNewSuggLump();
	    pageReference p2 = actionPlan.addNewSIPFund();
	    pageReference p3 = actionPlan.addNewSuggSIP();
	    pageReference p5 = actionPlan.RemoveRecordLump();
	    actionPlan.RemoveRecordSIP();
	    actionPlan.addNewLifeInsuranceRow();
	    
	    List<selectOption> getSchemeNames = actionPlan.getSchemeNames();
	    List<selectOption> getSipActions = actionPlan.getSipActions();
	    List<selectOption> getSugLumpActions = actionPlan.getSugLumpActions();
	    List<selectOption> getLumpActions = actionPlan.getLumpActions();
	    List<selectOption> getAssetClass = actionPlan.getAssetClass();
	    List<selectOption> getEntities = actionPlan.getEntities();
	   	system.debug('*****limits*1****'+limits.getQueries());
	    
	    Test.stopTest();
	}
	
	public static testMethod void testActionPlanController5()
	{
    	testData1();
     	Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEmergencyGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEmergencyGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest.Id);
	    Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',insurance2.Id);
	    
	    ActionPlanController actionPlan = new ActionPlanController();
	    List<selectOption> getSIPTransactionType = actionPlan.getSIPTransactionType();
	    List<selectOption> getLumpsumTransactionType = actionPlan.getLumpsumTransactionType();
	    List<selectOption> getExecutionTracker = actionPlan.getExecutionTracker();
	    List<selectOption> getOptions = actionPlan.getOptions();
	    pageReference p6 = actionPlan.SummaryActionPlanPage();
	    pageReference p7 = actionPlan.actionPlanPDF();
	    pageReference p8 = actionPlan.sendEmail();
	    pageReference p9 = actionPlan.addNewGeneralInsurance();
	    
	   	system.debug('*****limits*1****'+limits.getQueries());
	    
	    Test.stopTest();
	}
	
	public static testMethod void testARPPLumpsumFunds()
	{
    	objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', //OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount;
	    
	 	List<Approve_Action_Plan__c> lstApproveActionPlan = new list<Approve_Action_Plan__c>();
	 	objEducationGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
        insert objEducationGoal;
        
      	Approve_Action_Plan__c objAp = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Opened');
      										  
      	lstApproveActionPlan.add(objAp);
      	//insert lstApproveActionPlan;
  		Approve_Action_Plan__c objAp1 = new Approve_Action_Plan__c(Transaction_Type__c='STP From', Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 0,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Opened');
      										  
      	lstApproveActionPlan.add(objAp1);
      	Approve_Action_Plan__c objAp2 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 0,
      										  Product_Name__c  = '',Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Opened');
      										  
      	lstApproveActionPlan.add(objAp2);
      	
      	
      	
        Approve_Action_Plan__c objAp3 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 0,
      										  Product_Name__c  = '',Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'SIP', Account__c = objAccount.id, isSIPexecutionTracker__c =true,AP_Status__c = 'Opened');
      										  
      	lstApproveActionPlan.add(objAp3);
      	insert lstApproveActionPlan;
      	
      	Approve_Action_Plan__c objAp4 = new Approve_Action_Plan__c(Transaction_Type__c='STP From', Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 2000,
      										  Product_Name__c  = 'Axis Equity Fund',Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Opened');
      	
     	insert objAp4;
     	Test.startTest();
        
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEducationGoal.Id);
	    Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal.Id);
	    //Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest.Id);
	   // Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',insurance2.Id);
	    
	    ActionPlanController actionPlan = new ActionPlanController();
	    List<selectOption> getSIPTransactionType = actionPlan.getSIPTransactionType();
	    List<selectOption> getLumpsumTransactionType = actionPlan.getLumpsumTransactionType();
	    List<selectOption> getExecutionTracker = actionPlan.getExecutionTracker();
	    pageReference p9 = actionPlan.addNewLumpsumFund();
	    
	    actionPlan.saveActionPlan();
	    Test.stopTest();
	    
	}
	
	
	/*public static testMethod void testARPPInsurance()
	{
		
    	objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', //OwnerId = userobj.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
	    insert objAccount;
	    
	 	List<Approve_Action_Plan__c> lstApproveActionPlan = new list<Approve_Action_Plan__c>();
	 	
	 	objEducationGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
        insert objEducationGoal;
                             
      	Approve_Action_Plan__c objAp = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Policy_Type__c = 'Medical',Item_Type__c = 'General Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,AP_Status__c = 'Opened');
      										  
      	lstApproveActionPlan.add(objAp);
      	
        Approve_Action_Plan__c objAp1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEducationGoal.id, Amount__c = 20000,
      										  Fund__c = 'HDFC Top 200 Fund',Policy_Name__c  = 'Equity Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
      										  Policy_Type__c = 'Term Life',Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,AP_Status__c = 'Opened');
      										  
      	lstApproveActionPlan.add(objAp1);
      	
      	insert lstApproveActionPlan;
  	   	
      	lifeInsurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    insert lifeInsurance1;										
      
       	Insurance__c generalInsurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
	    											Insurance_Company__c='ICICI',Policy_Type__c='Medical',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
	    											RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
	    insert generalInsurance;			
     	Test.startTest();
        
	    Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
	    Apexpages.currentPage().getParameters().put('navigate', '');
	    Apexpages.currentPage().getParameters().put('addNewGoalId',objEducationGoal.Id);
	    //Apexpages.currentPage().getParameters().put('addNewLumpsumGoalId',objEducationGoal.Id);
	    //Apexpages.currentPage().getParameters().put('addNewInvestId',MFinvest.Id);
	    //Apexpages.currentPage().getParameters().put('addNewLifeInsuranceId',lifeInsurance1.Id);
	    
	    ActionPlanController actionPlan = new ActionPlanController();
	    pageReference p9 = actionPlan.addNewGeneralInsurance();
	    
	  	actionPlan.beanObj.lstLifeInsurance =actionPlan.beanObj.mapIdToLifeInsuranceInnerClass.get(lifeInsurance1.id);
	    actionPlan.beanObj.lstLifeInsurance[0].policyName='BSLI Protector Plus Plan';
	    actionPlan.beanObj.lstLifeInsurance[0].policyType='Term Life';
	    actionPlan.beanObj.lstLifeInsurance[0].sumAssured = 1000;
	     
	    actionPlan.beanObj.lstGeneralInsurance[0].productName = '';
	    actionPlan.beanObj.lstGeneralInsurance[0].policyType='Medical';
	    actionPlan.beanObj.lstGeneralInsurance[0].sumAssured = 1000;
	     
	    system.debug('************lst'+ actionPlan.beanObj.lstGeneralInsurance[0].productName);
	     
	/*    actionPlan.beanObj.lstNewGeneralInsurance[0].policyType = 'Medical';
	    ApexPages.currentPage().getParameters().put('index', '0');
	    actionPlan.getInsurance();
	     
	    actionPlan.beanObj.lstNewGeneralInsurance[1].policyType = 'Disability';
	    ApexPages.currentPage().getParameters().put('index', '1');
	    actionPlan.getInsurance();
	    
	    actionPlan.beanObj.lstNewGeneralInsurance[0].policyType = 'Top Up';
	    ApexPages.currentPage().getParameters().put('index', '0');
	    actionPlan.getInsurance();
	    actionPlan.beanObj.lstNewGeneralInsurance[1].policyType = 'Critical Illness';
	    ApexPages.currentPage().getParameters().put('index', '1');
	    actionPlan.getInsurance();
	    
	    actionPlan.beanObj.lstNewGeneralInsurance[0].policyType = 'Personal Accident';
	    ApexPages.currentPage().getParameters().put('index', '0');
	    actionPlan.getInsurance();
	    
	    actionPlan.beanObj.lstNewGeneralInsurance[1].policyType = 'Vehicle';
	    ApexPages.currentPage().getParameters().put('index', '1');
	    actionPlan.getInsurance();
	    
	    actionPlan.beanObj.lstNewGeneralInsurance[1].policyType = 'Householders';
	    ApexPages.currentPage().getParameters().put('index', '1');
	    actionPlan.getInsurance();*/
	 //   actionPlan.saveActionPlan();
	    
	  //  Test.stopTest();
	    
	//}
}