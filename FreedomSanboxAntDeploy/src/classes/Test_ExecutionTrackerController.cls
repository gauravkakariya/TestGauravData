/* 
*  Test class for Controller class that displays Action Plan in read only mode as well as Execution Tracker functionality.
*  Contains the logic for storing ET records in database as well as Send email functionality
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi Satpute    07/01/2013      Initial Draft
*/

@isTest
private class Test_ExecutionTrackerController 
{
	/*
    static testMethod void testDataInsert() 
    {   
    	TestData_Ffreedom testData = new TestData_Ffreedom();
        List<Goal__c> lstGoal = new List<Goal__c>();
        List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
        List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
        List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
        List<Insurance__c> lstInsurance = new List<Insurance__c>();
        List<GoalInsuranceAssociation__c> lstGoalInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
        List<Account> lstAcc = new List<Account>();
        
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
         /*User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
                                    alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
                                    LastName = 'Test_Parent_Lname1' );

        insert userobj;*

        //BB USer
        //Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        //User partnerUser = [select Id from User where profileid =: prof.id and IsActive = true limit 1];
        /*Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        RecordType objRT = [Select Id from RecordType where Name = 'General' and SobjectType = 'Account'];
		Account objBusinessAccount = new Account(Name='Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,
									Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
									Gold_Growth_Rate__c=10,	Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60', 
									RecordTypeId = objRT.Id,Related_To__c ='Business Partner');
	    insert objBusinessAccount;
        Contact objContact = new Contact(FirstName='Parner Contact Test', 
    									LastName='Contact',
    									AccountId= objBusinessAccount.id);
    	insert objContact;
        
        User partnerUser = new User(email='partner-user@fakeemail1.com', profileid = prof.Id, UserName='test-userPartner@fakeemail1.com', 
                                    alias='tuser12', CommunityNickName='tuser12',TimeZoneSidKey='America/New_York', ContactId = objContact.Id,
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Partner_Fname1',
                                    LastName = 'Test_Partner_Lname1' );
        insert partnerUser;
        
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
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
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
        lstAcc.add(objBPAccount);
        insert lstAcc;
        lstAcc[1].Related_To__c = 'Business Partner';
        update lstAcc[1];*/    
        
 /*       User objUser1 = testData.initializeUser();
    	insert objUser1;
    	
        Business_Unit__c objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	Business_Unit__c objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	Department__c objDept1 = testData.init_Department('PST', objBU1.Id);
    	Department__c objDept2 = testData.init_Department('MST', objBU1.Id);
    	Department__c objDept3 = testData.init_Department('FPA', objBU1.Id);
    	Department__c objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	Team_Member__c objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	Team_Member__c objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	Team_Member__c objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	Team_Member__c objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	insert lstTeam_Member;
    	List<Account> lstBPAcc = new List<Account>();
        Account objGeneralAccount = testData.init_GeneralAccount();
	    lstBPAcc.add(objGeneralAccount);
	    Account virtualPartner = testData.initVirtualAccount();
    	virtualPartner.Business_Unit__c = objBU1.Id;
    	virtualPartner.PST_Team_Member__c = objTM1.Id;
    	virtualPartner.MST_Team_Member__c = objTM2.Id;
    	virtualPartner.FPA_Team_Member__c = objTM3.Id;
    	virtualPartner.OPS_Team_Member__c = objTM4.Id;
	    lstBPAcc.add(virtualPartner);
	    insert lstBPAcc;
	    
	    Contact objBizContact = testData.init_BizContact(objGeneralAccount);
	    insert objBizContact; 
	    User partnerUser = testData.initBusinessUser(objBizContact);
	    insert partnerUser;           
        system.debug('--------partnerUser---ss-----'+partnerUser);
      	//List<Account> lstAcc = new List<Account>();
        Account objBPAccount = testData.initBusinessAccount(partnerUser);
        lstAcc.add(objBPAccount);
	    Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = objUser1.Id,Virtual_Partner__c =virtualPartner.Id,
                           PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
        objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
        lstAcc.add(objAccount);
        
	    insert lstAcc;
	     objBPAccount.Related_To__c = 'Business Partner';	           
        update objBPAccount;
        //Assets
        Asset__c objAsset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
        insert objAsset;
        Asset__c objAssetRecord = new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
        insert objAssetRecord;
        
        Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c='Abc');
        lstGoal.add(objEmergencyGoal);
        
        Goal__c objRetireGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Retirement',Description__c='Retirement');
        lstGoal.add(objRetireGoal);
        
        Goal__c objEducationGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
        lstGoal.add(objEducationGoal);
        insert lstGoal;
        
        GoalAssetAssociation__c objGoalAssetAssociation1 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEmergencyGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
        lstGoalAssetAssociation.add(objGoalAssetAssociation1);

        GoalAssetAssociation__c objGoalAssetAssociation2 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEducationGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
        lstGoalAssetAssociation.add(objGoalAssetAssociation2);
        
        //Investment Asset
        Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c,
                                                        Maturity_Date__c = system.today());
                                                            //RecordTypeId='01220000000HYx5AAG'
        lstInvestmentAsset.add(inv);
        Investment_Asset__c invest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(invest);
        
        Investment_Asset__c MFinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(MFinvest);
        Investment_Asset__c invest1 = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, Maturity_Date__c = system.today(),
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c,
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(invest1);
        
        
        Investment_Asset__c MFGoldinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000,Asset_Name__c='Kotak', 
                    RecordTypeId=InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c,Maturity_Date__c = system.today(),
                    Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(MFGoldinvest);  
         
        insert lstInvestmentAsset;


        GoalInvestmentAssetAssociation__c gasset1 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset1);
        GoalInvestmentAssetAssociation__c gasset22 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset22);
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
        
        Insurance__c lifeInsurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss');
        lstInsurance.add(lifeInsurance1);
        Insurance__c insurance2 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
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
        lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Opened'));
                                              
        lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Amount__c = 20000, Sum_Assured_Rs__c=2000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt', Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
                                              AP_Status__c = 'Opened'));                                      
        lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt', Item_Type__c = Label.Surrender_Insurance, Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
                                              AP_Status__c = 'Opened'));
        lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                                            Investment_Asset__c = invest.id,
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isExecutionTracker__c =true,AP_Status__c = 'Opened'));
                                                            
         lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Account__c=objAccount.id,
                                                            Investment_Asset__c = invest.id,
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isSIPexecutionTracker__c =true,AP_Status__c = 'Opened'));
                                                            
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'));
        
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'));
        
        //SIP Funds for Other Goals
        lstApproveActionPlan.add(new Approve_Action_Plan__c(Transaction_Type__c = 'New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened')); 
                                            
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'));
        
        //SIP Funds for Emergency Fund Goals
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEmergencyGoal.id,
                                            Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c = 'Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity',AP_Status__c = 'Opened')); 
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,
                                            Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                             Item_Type__c = 'SIP',
                                            Category__c='Equity',AP_Status__c = 'Opened')); 
        
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'General Insurance',
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened'));
                                            
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance1.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'Life Insurance',
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened'));
        
        lstApproveActionPlan.add( new Approve_Action_Plan__c (Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id,isWill__c = true,AP_Status__c = 'Opened'));
        //for Add new General Insurance
        lstApproveActionPlan.add(new Approve_Action_Plan__c (isInsuranceExecutionTracker__c=true, Product_Name__c='test SIP',Insured__c='aaa',Account__c=objAccount.id,
                                            Policy_Type__c='bbb',Fund__c='HDFC Top 200 Fund',Sum_Assured_Rs__c=400,Option__c='Growth',Premium_Amount_Rs__c=40, Item_Type__c = 'General Insurance',
                                            Category__c='Equity',AP_Status__c = 'Opened'));                                                                       
                                              
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
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true));
                                            
        lstApproveActionPlan.add(new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objBPAccount.id,Insurance__c = insurance1.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'Life Insurance',
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true));
        
        lstApproveActionPlan.add( new Approve_Action_Plan__c (Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objBPAccount.id,isWill__c = true));                                   
                                              
                    
                    
        Approve_Action_Plan__c objApGold = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
               Investment_Asset__c = MFGoldinvest.id,
                   Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                   Category__c='Equity',isGS_ExecutionTracker__c =true,isGSsip_ExecutionTracker__c = true,AP_Status__c = 'Opened');
                                                      
        lstApproveActionPlan.add(objApGold);
              
              
        Approve_Action_Plan__c objApGold1 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
               Investment_Asset__c = MFGoldinvest.id,isNewGoldSilver__c=true,
                   Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                   Category__c='Equity',isGS_ExecutionTracker__c =true,isGSsip_ExecutionTracker__c = true,AP_Status__c = 'Opened');                                   
                              
        lstApproveActionPlan.add(objApGold1);
        
        insert lstApproveActionPlan;
         
     /*  List<Execution_Tracker__c>   lstET = new List<Execution_Tracker__c>();
       Execution_Tracker__c objET1 = new Execution_Tracker__c(Approve_Action_Plan__c =objApGold.Id,Type__c ='SIP',Entity_Name__c = objAccount.Id,Application_Status__c = 'Opened',Is_Floating__c=false);
       lstET.add(objET1);
       Execution_Tracker__c objET2 = new Execution_Tracker__c(Approve_Action_Plan__c =objApGold1.Id,Type__c ='Lumpsum',Entity_Name__c = objAccount.Id,Application_Status__c = 'Opened',Is_Floating__c=false);
       lstET.add(objET2);
       
       insert lstET;
        */
        //Operations User
        // ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
/*         User userOps = new User( email='test-user@fakeemail.com', profileid = ProfileID, UserName='operationuser@fakeemail.com', 
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
        
        
        Entity_Global_Assumption__c ega = new Entity_Global_Assumption__c(Account__c=objAccount.id,Expected_Return_on_Investment__c=30,
                                                                   Gold_Growth_Rate__c=10,    /* Prajakta - FP changes - 01-04-2013 */
 /*                                                                    Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5,Stock_Growth_Rate__c=10);
        insert ega;  
        
        
        Test.startTest();
        Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
        //Apexpages.currentPage().getParameters().put('navigate', 'sidebar');
        Apexpages.currentPage().getParameters().put('navigate', null);
        ExecutionTrackerController objExecutionTracker = new ExecutionTrackerController();
        //objExecutionTracker.createExecutionTracker();
        objExecutionTracker.assignToOperations();
        
       
        Apexpages.currentPage().getParameters().put('entityId', objBPAccount.id);
        //Apexpages.currentPage().getParameters().put('navigate', 'sidebar');
        Apexpages.currentPage().getParameters().put('navigate', null);
       
       // objExecutionTracker.createExecutionTracker();
       objExecutionTracker.getSummarySIPFunds();
       
        Test.stopTest();
        
    /*  Apexpages.currentPage().getParameters().remove('navigate');
        Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
        ExecutionTrackerController objExecutionTracker2 = new ExecutionTrackerController();
        objExecutionTracker2.assignToOperations();*/
        /*ApprovedPlanBean objApprovedPlanBean = new ApprovedPlanBean();
        ExecutionTrackerService objExecutionTrackerService = new ExecutionTrackerService();
      
        
        objExecutionTracker.assignToOperations();
        objExecutionTrackerService.getWillExecTrackerDetails(objApprovedPlanBean);
      
        */
 /*   }
   
       static testMethod void testDataInsert1() 
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
        //Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        //User partnerUser = [select Id from User where profileid =: prof.id and IsActive = true limit 1];
        Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        RecordType objRT = [Select Id from RecordType where Name = 'General' and SobjectType = 'Account'];
		Account objBusinessAccount = new Account(Name='Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,
									Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
									Gold_Growth_Rate__c=10,	Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60', 
									RecordTypeId = objRT.Id,Related_To__c ='Business Partner');
	    insert objBusinessAccount;
        Contact objContact = new Contact(FirstName='Parner Contact Test', 
    									LastName='Contact',
    									AccountId= objBusinessAccount.id);
    	insert objContact;
        
        User partnerUser = new User(email='partner-user@fakeemail1.com', profileid = prof.Id, UserName='test-userPartner@fakeemail1.com', 
                                    alias='tuser12', CommunityNickName='tuser12',TimeZoneSidKey='America/New_York', ContactId = objContact.Id,
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Partner_Fname1',
                                    LastName = 'Test_Partner_Lname1' );
        insert partnerUser;
        
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
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
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
        lstAcc.add(objBPAccount);
        insert lstAcc;
        lstAcc[1].Related_To__c = 'Business Partner';
        update lstAcc[1];
        //Assets
        
        Asset__c objAsset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
        insert objAsset;
        Asset__c objAssetRecord = new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
        insert objAssetRecord;
        
        Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c='Abc');
        lstGoal.add(objEmergencyGoal);
        
        Goal__c objRetireGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Retirement',Description__c='Retirement');
        lstGoal.add(objRetireGoal);
        
        Goal__c objEducationGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
        lstGoal.add(objEducationGoal);
        insert lstGoal;
        
        GoalAssetAssociation__c objGoalAssetAssociation1 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEmergencyGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
        lstGoalAssetAssociation.add(objGoalAssetAssociation1);

        GoalAssetAssociation__c objGoalAssetAssociation2 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEducationGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
        lstGoalAssetAssociation.add(objGoalAssetAssociation2);
        
        //Investment Asset
        Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c,
                                                        Maturity_Date__c = system.today());
                                                            //RecordTypeId='01220000000HYx5AAG'
        lstInvestmentAsset.add(inv);
        Investment_Asset__c invest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(invest);
        
        Investment_Asset__c MFinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(MFinvest);
        Investment_Asset__c invest1 = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, Maturity_Date__c = system.today(),
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c,
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(invest1);
        
        
        Investment_Asset__c MFGoldinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000,Asset_Name__c='Kotak', 
                    RecordTypeId=InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c,Maturity_Date__c = system.today(),
                    Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(MFGoldinvest);  
         
        insert lstInvestmentAsset;


        GoalInvestmentAssetAssociation__c gasset1 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset1);
        GoalInvestmentAssetAssociation__c gasset22 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset22);
        GoalInvestmentAssetAssociation__c gasset33 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest1.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset33);
        insert lstGoalInvestmentAssetAssociation;
        
        
        //Insurance Assets 
        Insurance__c insurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss',
                                                    Nominee__c = objAccount.Id , Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(insurance);
        
        Insurance__c generalInsurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss',Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(generalInsurance);
        
        Insurance__c insurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss', Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(insurance1);
        
        Insurance__c lifeInsurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss', Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(lifeInsurance1);
        Insurance__c insurance2 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Endowment',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss' ,Action__c ='Liquidate (Align to goal)' );
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
        Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAP1);                                      
        Approve_Action_Plan__c objAP2 = new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Amount__c = 20000, Sum_Assured_Rs__c=2000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt', Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
                                              AP_Status__c = 'Opened');                                      
        
        lstApproveActionPlan.add(objAP2);
        Approve_Action_Plan__c objAP3 = new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt', Item_Type__c = Label.Surrender_Insurance, Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
                                              AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAP3);
        Approve_Action_Plan__c objAP4 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                                            Investment_Asset__c = invest.id,
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isExecutionTracker__c =true,AP_Status__c = 'Opened');
        
        lstApproveActionPlan.add(objAP4);
        Approve_Action_Plan__c objAP5 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened',Item_Type__c = 'SIP');
        
        lstApproveActionPlan.add(objAP5);
        Approve_Action_Plan__c objAP6 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened');
        
        //SIP Funds for Other Goals
        lstApproveActionPlan.add(objAP6);
        Approve_Action_Plan__c objAP7 = new Approve_Action_Plan__c(Transaction_Type__c = 'New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'); 
                                            
        lstApproveActionPlan.add(objAP7);
        Approve_Action_Plan__c objAP8 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened');
        
        //SIP Funds for Emergency Fund Goals
        lstApproveActionPlan.add(objAP8);
        Approve_Action_Plan__c objAP9 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEmergencyGoal.id,
                                            Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c = 'Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity',AP_Status__c = 'Opened'); 
        lstApproveActionPlan.add(objAP9);
        Approve_Action_Plan__c objAP10 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,
                                            Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                             Item_Type__c = 'SIP',
                                            Category__c='Equity',AP_Status__c = 'Opened'); 
        
        lstApproveActionPlan.add(objAP10);
        Approve_Action_Plan__c objAP11 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'General Insurance',
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened');
                                            
        lstApproveActionPlan.add(objAP11);
        Approve_Action_Plan__c objAP12 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance1.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'Life Insurance',
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened');
        
        lstApproveActionPlan.add(objAP12);
        Approve_Action_Plan__c objAP13 =  new Approve_Action_Plan__c (Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id,isWill__c = true,AP_Status__c = 'Opened');
        //for Add new General Insurance
        lstApproveActionPlan.add(objAP13);
        Approve_Action_Plan__c objAP14 = new Approve_Action_Plan__c (isInsuranceExecutionTracker__c=true, Product_Name__c='test SIP',Insured__c='aaa',Account__c=objAccount.id,
                                            Policy_Type__c='bbb',Fund__c='HDFC Top 200 Fund',Sum_Assured_Rs__c=400,Option__c='Growth',Premium_Amount_Rs__c=40, Item_Type__c = 'General Insurance',
                                            Category__c='Equity',AP_Status__c = 'Opened');                                                                       
        lstApproveActionPlan.add(objAP14);
        
        Approve_Action_Plan__c objApGold = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
               Investment_Asset__c = MFGoldinvest.id,
                   Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                   Category__c='Equity',isGS_ExecutionTracker__c =true,isGSsip_ExecutionTracker__c = true,AP_Status__c = 'Opened');
                                                      
        lstApproveActionPlan.add(objApGold);
              
              
        Approve_Action_Plan__c objApGold1 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
               Investment_Asset__c = MFGoldinvest.id,isNewGoldSilver__c=true,
                   Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                   Category__c='Equity',isGS_ExecutionTracker__c =true,isGSsip_ExecutionTracker__c = true,AP_Status__c = 'Opened');                                   
                              
        lstApproveActionPlan.add(objApGold1);
        
        insert lstApproveActionPlan;
         
     	List<Execution_Tracker__c>   lstET = new List<Execution_Tracker__c>();
       	Execution_Tracker__c objET1 = new Execution_Tracker__c(Approve_Action_Plan__c =objApGold.Id,Type__c ='SIP',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = '',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET1);
       	Execution_Tracker__c objET2 = new Execution_Tracker__c(Approve_Action_Plan__c =objApGold1.Id,Type__c ='Lumpsum',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = '',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET2);
       	Execution_Tracker__c objET3 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP2.Id,Type__c ='Life Insurance',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = '',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET3);
       	Execution_Tracker__c objET4 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP1.Id,Type__c ='Lumpsum',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET4);
       	Execution_Tracker__c objET5 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP3.Id,Type__c =Label.Surrender_Insurance,Entity_Name__c = objAccount.Id,
       								Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true);
       	lstET.add(objET5);
       	Execution_Tracker__c objET6 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP4.Id,Type__c ='Lumpsum',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true);
       	lstET.add(objET6);
       	Execution_Tracker__c objET7 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP5.Id,Type__c ='SIP',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true);
       	lstET.add(objET7);
       	insert lstET;
        
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
        
        
        Entity_Global_Assumption__c ega = new Entity_Global_Assumption__c(Account__c=objAccount.id,Expected_Return_on_Investment__c=30,
                                                                    Gold_Growth_Rate__c=10,    /* Prajakta - FP changes - 01-04-2013 */
 /*                                                                    Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5,Stock_Growth_Rate__c=10);
       insert ega;  
        
        
        Test.startTest();
       
        Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
        Apexpages.currentPage().getParameters().put('navigate', null);
        ExecutionTrackerController objExecutionTracker = new ExecutionTrackerController();
        //objExecutionTracker.initialization();
        objExecutionTracker.assignToOperations();
        objExecutionTracker.getLumpsumApproveActionPlans();
        PageReference closePopup = objExecutionTracker.closePopup();
        Test.stopTest();
        
    /*    Apexpages.currentPage().getParameters().remove('navigate');
        Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
        ExecutionTrackerController objExecutionTracker2 = new ExecutionTrackerController();
        objExecutionTracker2.assignToOperations();*/
        /*ApprovedPlanBean objApprovedPlanBean = new ApprovedPlanBean();
        ExecutionTrackerService objExecutionTrackerService = new ExecutionTrackerService();
      
        
        objExecutionTracker.assignToOperations();
        objExecutionTrackerService.getWillExecTrackerDetails(objApprovedPlanBean);
      
        */
 /*   }
   
 */  
       static testMethod void testDataInsert2() 
    {   
        List<Goal__c> lstGoal = new List<Goal__c>();
        List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
        List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
        List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
        List<Insurance__c> lstInsurance = new List<Insurance__c>();
        List<GoalInsuranceAssociation__c> lstGoalInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
        List<Account> lstAcc = new List<Account>();
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	
        TestData_Ffreedom testData = new TestData_Ffreedom();
    	
    	ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
        User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
                                    alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
                                    LastName = 'Test_Parent_Lname1' );

        insert userobj;

    	
        Business_Unit__c objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	Business_Unit__c objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	Department__c objDept1 = testData.init_Department('PST', objBU1.Id);
    	Department__c objDept2 = testData.init_Department('MST', objBU1.Id);
    	Department__c objDept3 = testData.init_Department('FPA', objBU1.Id);
    	Department__c objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	Team_Member__c objTM1 = testData.init_Team_Member(userobj.Id, objDept1.Id);
    	Team_Member__c objTM2 = testData.init_Team_Member(userobj.Id, objDept2.Id);
    	Team_Member__c objTM3 = testData.init_Team_Member(userobj.Id, objDept3.Id);
    	Team_Member__c objTM4 = testData.init_Team_Member(userobj.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	insert lstTeam_Member;
        
        //BB USer
        //Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        //User partnerUser = [select Id from User where profileid =: prof.id and IsActive = true limit 1];
        Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        RecordType objRT = [Select Id from RecordType where Name = 'General' and SobjectType = 'Account'];
		Account objBusinessAccount = new Account(Name='Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,
									Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
									Gold_Growth_Rate__c=10,	Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60', 
									RecordTypeId = objRT.Id,Related_To__c ='Business Partner');
	    insert objBusinessAccount;
        Contact objContact = new Contact(FirstName='Parner Contact Test', 
    									LastName='Contact',
    									AccountId= objBusinessAccount.id);
    	insert objContact;
        
        User partnerUser = new User(email='partner-user@fakeemail1.com', profileid = prof.Id, UserName='test-userPartner@fakeemail1.com', 
                                    alias='tuser12', CommunityNickName='tuser12',TimeZoneSidKey='America/New_York', ContactId = objContact.Id,
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Partner_Fname1',
                                    LastName = 'Test_Partner_Lname1' );
        insert partnerUser;
        
      
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = userobj.Id,
                           PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true, OPS_Team_Member__c= objTM4.id);
        lstAcc.add(objAccount);
        
        
        
        Account objBPAccount = new Account(LastName='Test BP',Adjustment_Factor__c='2', OwnerId = partnerUser.Id,
                           PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                           Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Business Partner',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
        lstAcc.add(objBPAccount);
        insert lstAcc;
        lstAcc[1].Related_To__c = 'Business Partner';
        update lstAcc[1];
        //Assets
        Asset__c objAsset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
        insert objAsset;
        Asset__c objAssetRecord = new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=objAccount.id,action__c='yes',Asset_Types__c='Gold', 
                              RecordTypeId = AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c,Current_Value__c = 200);
        insert objAssetRecord;
        
        Goal__c objEmergencyGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Emergency Fund',Description__c='Abc');
        lstGoal.add(objEmergencyGoal);
        
        Goal__c objRetireGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Retirement',Description__c='Retirement');
        lstGoal.add(objRetireGoal);
        
        Goal__c objEducationGoal = new Goal__c(Entity__c=objAccount.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
        lstGoal.add(objEducationGoal);
        insert lstGoal;
        
        GoalAssetAssociation__c objGoalAssetAssociation1 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEmergencyGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
        lstGoalAssetAssociation.add(objGoalAssetAssociation1);

        GoalAssetAssociation__c objGoalAssetAssociation2 = new GoalAssetAssociation__c(Asset__c=objAsset.id,Goal__c=objEducationGoal.id,Allocated__c=30,Allocation__c=4000,GoalYearValue__c=45000);
        lstGoalAssetAssociation.add(objGoalAssetAssociation2);
        
        //Investment Asset
        Investment_Asset__c inv = new Investment_Asset__c(Entity__c=objAccount.id,action__c='yes',RecordTypeId=InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c,
                                                        Maturity_Date__c = system.today());
                                                            //RecordTypeId='01220000000HYx5AAG'
        lstInvestmentAsset.add(inv);
        Investment_Asset__c invest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(invest);
        
        Investment_Asset__c MFinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(MFinvest);
        Investment_Asset__c invest1 = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, Maturity_Date__c = system.today(),
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c,
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(invest1);
        
        
        Investment_Asset__c MFGoldinvest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000,Asset_Name__c='Kotak', 
                    RecordTypeId=InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c,Maturity_Date__c = system.today(),
                    Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(MFGoldinvest);  
         
        insert lstInvestmentAsset;


        GoalInvestmentAssetAssociation__c gasset1 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset1);
        GoalInvestmentAssetAssociation__c gasset22 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset22);
        GoalInvestmentAssetAssociation__c gasset33 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest1.id,Goal__c=objEducationGoal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset33);
        insert lstGoalInvestmentAssetAssociation;
        
        
        //Insurance Assets 
        Insurance__c insurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss',
                                                    Nominee__c = objAccount.Id , Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(insurance);
        
        Insurance__c generalInsurance = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c,Policy_Number__c = 'sss',Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(generalInsurance);
        
        Insurance__c insurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss', Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(insurance1);
        
        Insurance__c lifeInsurance1 = new Insurance__c(Flag__c = 'Analysis',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'One Time Premium',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss', Action__c ='Liquidate (Align to goal)');
        lstInsurance.add(lifeInsurance1);
        Insurance__c insurance2 = new Insurance__c(Flag__c = 'Data Entry',Entity__c=objAccount.id, Suggested_Cover_General_Insurance__c=45665,Premium_Frequency__c = 'Annually',
                                                    Insurance_Company__c='ICICI',Policy_Type__c='Endowment',Premium_Amount_Rs__c=2351,Commencement_Date__c = system.today(),
                                                    RecordTypeId=InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,Policy_Number__c = 'sss' ,Action__c ='Liquidate (Align to goal)' );
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
        Approve_Action_Plan__c objAP1 = new Approve_Action_Plan__c(Transaction_Type__c='STP', Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id, isLumpsumExecTracker__c =true,AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAP1);                                      
        Approve_Action_Plan__c objAP2 = new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Amount__c = 20000, Sum_Assured_Rs__c=2000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt', Item_Type__c = 'Life Insurance', Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
                                              AP_Status__c = 'Opened');                                      
        
        lstApproveActionPlan.add(objAP2);
        Approve_Action_Plan__c objAP3 = new Approve_Action_Plan__c(Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt', Item_Type__c = Label.Surrender_Insurance, Account__c = objAccount.id, isInsuranceExecutionTracker__c =true,
                                              AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAP3);
        Approve_Action_Plan__c objAP4 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                                            Investment_Asset__c = invest.id,
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isExecutionTracker__c =true,AP_Status__c = 'Opened');
        
        lstApproveActionPlan.add(objAP4);
        Approve_Action_Plan__c objAP5 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened',Item_Type__c = 'SIP');
        
        lstApproveActionPlan.add(objAP5);
        Approve_Action_Plan__c objAP6 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened');
        
        //SIP Funds for Other Goals
        lstApproveActionPlan.add(objAP6);
        Approve_Action_Plan__c objAP7 = new Approve_Action_Plan__c(Transaction_Type__c = 'New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened'); 
                                            
        lstApproveActionPlan.add(objAP7);
        Approve_Action_Plan__c objAP8 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity', isSIPexecutionTracker__c = true,AP_Status__c = 'Opened');
        
        //SIP Funds for Emergency Fund Goals
        lstApproveActionPlan.add(objAP8);
        Approve_Action_Plan__c objAP9 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c = objEmergencyGoal.id,
                                            Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c = 'Growth',Installments__c=40, 
                                            Item_Type__c = 'SIP',
                                            Category__c='Equity',AP_Status__c = 'Opened'); 
        lstApproveActionPlan.add(objAP9);
        Approve_Action_Plan__c objAP10 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,
                                            Account__c=objAccount.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                             Item_Type__c = 'SIP',
                                            Category__c='Equity',AP_Status__c = 'Opened'); 
        
        lstApproveActionPlan.add(objAP10);
        Approve_Action_Plan__c objAP11 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'General Insurance',
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened');
                                            
        lstApproveActionPlan.add(objAP11);
        Approve_Action_Plan__c objAP12 = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEducationGoal.id,Account__c=objAccount.id,Insurance__c = insurance1.id,
                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'Life Insurance',
                                            Category__c='Equity', isInsuranceExecutionTracker__c = true,AP_Status__c = 'Opened');
        
        lstApproveActionPlan.add(objAP12);
        Approve_Action_Plan__c objAP13 =  new Approve_Action_Plan__c (Transaction_Type__c='STP',Remarks__c='test Lumpsum', Goal__c = objEmergencyGoal.id, Amount__c = 20000,
                                              Fund__c = 'HDFC Top 200 Fund', Amount_Per_Installment__c = 200, Option__c = 'Growth', Installments__c = 20, Action_Amount__c = 2000,
                                              Category__c='Debt',Item_Type__c = 'Lumpsum', Account__c = objAccount.id,isWill__c = true,AP_Status__c = 'Opened');
        //for Add new General Insurance
        lstApproveActionPlan.add(objAP13);
        Approve_Action_Plan__c objAP14 = new Approve_Action_Plan__c (isInsuranceExecutionTracker__c=true, Product_Name__c='test SIP',Insured__c='aaa',Account__c=objAccount.id,
                                            Policy_Type__c='bbb',Fund__c='HDFC Top 200 Fund',Sum_Assured_Rs__c=400,Option__c='Growth',Premium_Amount_Rs__c=40, Item_Type__c = 'General Insurance',
                                            Category__c='Equity',AP_Status__c = 'Opened');                                                                       
        lstApproveActionPlan.add(objAP14);
        
        Approve_Action_Plan__c objApGold = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
               Investment_Asset__c = MFGoldinvest.id,
                   Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                   Category__c='Equity',isGS_ExecutionTracker__c =true,isGSsip_ExecutionTracker__c = true,AP_Status__c = 'Opened');
                                                      
        lstApproveActionPlan.add(objApGold);
              
              
        Approve_Action_Plan__c objApGold1 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=objEmergencyGoal.id,Account__c=objAccount.id,
               Investment_Asset__c = MFGoldinvest.id,isNewGoldSilver__c=true,
                   Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                   Category__c='Equity',isGS_ExecutionTracker__c =true,isGSsip_ExecutionTracker__c = true,AP_Status__c = 'Opened');                                   
                              
        lstApproveActionPlan.add(objApGold1);
        
        insert lstApproveActionPlan;
         
     	List<Execution_Tracker__c>   lstET = new List<Execution_Tracker__c>();
       	Execution_Tracker__c objET1 = new Execution_Tracker__c(Approve_Action_Plan__c =objApGold.Id,Type__c ='SIP',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = '',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET1);
       	Execution_Tracker__c objET2 = new Execution_Tracker__c(Approve_Action_Plan__c =objApGold1.Id,Type__c ='Lumpsum',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = '',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET2);
       	Execution_Tracker__c objET3 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP2.Id,Type__c ='Life Insurance',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = '',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET3);
       	Execution_Tracker__c objET4 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP1.Id,Type__c ='Lumpsum',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true,isAssignedToOps__c=true);
       	lstET.add(objET4);
       	Execution_Tracker__c objET5 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP3.Id,Type__c =Label.Surrender_Insurance,Entity_Name__c = objAccount.Id,
       								Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true);
       	lstET.add(objET5);
       	Execution_Tracker__c objET6 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP4.Id,Type__c ='Lumpsum',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true);
       	lstET.add(objET6);
       	Execution_Tracker__c objET7 = new Execution_Tracker__c(Approve_Action_Plan__c =objAP5.Id,Type__c ='SIP',Entity_Name__c = objAccount.Id,
       								Agreed_Amount__c=100,Application_Status__c = 'Opened',Is_Floating__c=false,AssignToOps__c = true);
       	lstET.add(objET7);
       	insert lstET;
        
        //Operations User
        // ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
         User userOps = new User( email='test-user@fakeemail.com', profileid = ProfileID, UserName='operationuser@fakeemail.com', 
                                    alias='opsuser1', CommunityNickName='opsuser',TimeZoneSidKey='America/New_York', 
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'OpsFirstName',
                                    LastName = 'OpsLastName' );
         insert userOps;
        
      
        
        Entity_Global_Assumption__c ega = new Entity_Global_Assumption__c(Account__c=objAccount.id,Expected_Return_on_Investment__c=30,
                                                                    Gold_Growth_Rate__c=10,    /* Prajakta - FP changes - 01-04-2013 */
                                                                    Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5,Stock_Growth_Rate__c=10);
        insert ega;  
        
        
        Test.startTest();
       
        Apexpages.currentPage().getParameters().put('entityId', objAccount.id);
        Apexpages.currentPage().getParameters().put('navigate', null);
        ExecutionTrackerController objExecutionTracker = new ExecutionTrackerController();
      
        objExecutionTracker.initialization();
        objExecutionTracker.assignToOperations();
        lstApproveActionPlan = objExecutionTracker.lstSIPApproveActionPlan;
    	Map<String, ApprovedPlanBean.SIPFunds> mapStringToSIP = new Map<String, ApprovedPlanBean.SIPFunds>();
    	mapStringToSIP = objExecutionTracker.mapStringToSIPFunds;
    	
    	Map<String,List<ApprovedPlanBean.SIPFunds>> mapSIPFundsAlreadyExist = new Map<String,List<ApprovedPlanBean.SIPFunds>>();
    	mapSIPFundsAlreadyExist= objExecutionTracker.mapSIPFundsAlreadyExists;
    	
    	Map<String,List<Approve_Action_Plan__c>> mapLumpsumFundsAlreadyExist = new Map<String,List<Approve_Action_Plan__c>>();
    	mapLumpsumFundsAlreadyExist= objExecutionTracker.mapLumpsumFundsAlreadyExists;
    	
        PageReference closePopup = objExecutionTracker.closePopup();
        Test.stopTest();
        
    /*    Apexpages.currentPage().getParameters().remove('navigate');
        Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
        ExecutionTrackerController objExecutionTracker2 = new ExecutionTrackerController();
        objExecutionTracker2.assignToOperations();*/
        /*ApprovedPlanBean objApprovedPlanBean = new ApprovedPlanBean();
        ExecutionTrackerService objExecutionTrackerService = new ExecutionTrackerService();
      
        
        objExecutionTracker.assignToOperations();
        objExecutionTrackerService.getWillExecTrackerDetails(objApprovedPlanBean);
      }
        */
    }
        
}