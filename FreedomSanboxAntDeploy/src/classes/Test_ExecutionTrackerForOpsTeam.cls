/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Anupam          14/01/13         Test Class of Executon Tracker controller for operation Team Member.
*/


public with sharing class Test_ExecutionTrackerForOpsTeam 
{
    @isTest(SeeAllData=true)
    public static  void testExecutionTrackerForOpsTeamController()
    {
        RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
        Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
                           PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                           Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
        insert objAccount;
        
        Goal__c goal = new Goal__c(Entity__c = objAccount.id, Goal_Type__c = 'Emergency Fund');
        insert goal;
        
        List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
        Investment_Asset__c invest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
                                                            RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,Maturity_Date__c = system.today(),
                                                            Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        lstInvestmentAsset.add(invest);
        
        insert lstInvestmentAsset;
        
        List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
        
        GoalInvestmentAssetAssociation__c gasset1 = new GoalInvestmentAssetAssociation__c(Investment_Asset__c=invest.id,Goal__c=goal.id,allocated__c=45);
        lstGoalInvestmentAssetAssociation.add(gasset1);
        
        insert lstGoalInvestmentAssetAssociation;
        
         
        List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
        Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
        lstApproveActionPlan.add(objAAP1);
        
        Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
        lstApproveActionPlan.add(objAAP2);
        
        Approve_Action_Plan__c objAAP3 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=goal.id,Account__c=objAccount.id,
                                                            Investment_Asset__c = invest.id,
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isExecutionTracker__c =true,AP_Status__c = 'Closed');
        lstApproveActionPlan.add(objAAP3);
         Approve_Action_Plan__c objAAP4 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=goal.id,Account__c=objAccount.id,
                                                            Item_Type__c=Label.Surrender_Insurance,
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isExecutionTracker__c =true,AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAAP4);
        Approve_Action_Plan__c objAAP5 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=goal.id,Account__c=objAccount.id,
                                                            Item_Type__c= 'Loan',
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isAddOnExecutionTracker__c =true,AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAAP5);
        Approve_Action_Plan__c objAAP6 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=goal.id,Account__c=objAccount.id,
                                                            Item_Type__c= 'Fixed Deposit',
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isAddOnExecutionTracker__c =true,AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAAP6);
        Approve_Action_Plan__c objAAP7 = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Goal__c=goal.id,Account__c=objAccount.id,
                                                            Item_Type__c= 'Bond',
                                                            Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
                                                            Category__c='Equity',isAddOnExecutionTracker__c =true,AP_Status__c = 'Opened');
        lstApproveActionPlan.add(objAAP7);
        insert lstApproveActionPlan;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations',Is_Floating__c = false, Sum_Assured__c = 500,
                                            Agreed_Installments__c = 10,Transaction_Type__c = 'Hold', isAssignedToOps__c = true ,Total_Remaining_Balance__c = 1000,
                                            
                                            Application_Status__c = Label.Forms_Handed, Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Lumpsum',Goal__c = goal.Id,
                                            Scheme_Name_Policy_Name__c = 'Test Scheme', Agreed_Amount__c = 1000, Suggested_Amount__c = 1000, Executed_Amount__c=0));
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false, Sum_Assured__c = 500,
                                            Application_Status__c = Label.Forms_Handed,Total_Remaining_Balance__c = 1000, Approve_Action_Plan__c = objAAP1.Id, Type__c = 'SIP', isAssignedToOps__c = true ,
                                            Scheme_Name_Policy_Name__c = 'Test Scheme1', Agreed_Amount__c = 1001, Suggested_Amount__c = 1000, Executed_Amount__c=0));
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', isAssignedToOps__c = true , Is_Floating__c = false, Sum_Assured__c = 500,
                                            Application_Status__c = Label.Forms_Handed,Total_Remaining_Balance__c = 1000, Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Life Insurance',
                                            Scheme_Name_Policy_Name__c = 'Test Scheme2', Agreed_Amount__c = 1002, Suggested_Amount__c = 1000, Executed_Amount__c=0));
                                            
         lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false, Sum_Assured__c = 500,
                                            Application_Status__c = Label.Forms_Handed,Total_Remaining_Balance__c = 1000, Approve_Action_Plan__c = objAAP3.Id, Type__c = 'SIP', isAssignedToOps__c = true ,
                                            Scheme_Name_Policy_Name__c = 'Test Scheme1', Agreed_Amount__c = 1001, Suggested_Amount__c = 1000, Executed_Amount__c=0));           
         lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false, Sum_Assured__c = 500,
                                            Application_Status__c = Label.Forms_Handed,Total_Remaining_Balance__c = 1000, Approve_Action_Plan__c = objAAP4.Id, Type__c = Label.Surrender_Insurance, isAssignedToOps__c = true ,
                                            Scheme_Name_Policy_Name__c = 'Test Scheme1', Agreed_Amount__c = 1001, Suggested_Amount__c = 1000, Executed_Amount__c=0));                                                                        
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false, Sum_Assured__c = 500,
                                            Application_Status__c ='Opened', Approve_Action_Plan__c = objAAP5.Id, Type__c = 'Loan', isAssignedToOps__c = true ,
                                            Scheme_Name_Policy_Name__c = 'Test Scheme1', Agreed_Amount__c = 1001, Suggested_Amount__c = 1000, Executed_Amount__c=0)); 
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false, Sum_Assured__c = 500,
                                            Application_Status__c ='Opened', Approve_Action_Plan__c = objAAP6.Id, Type__c = 'Fixed Deposit', isAssignedToOps__c = true ,
                                            Scheme_Name_Policy_Name__c = 'Test Scheme1', Agreed_Amount__c = 1001, Suggested_Amount__c = 1000, Executed_Amount__c=0)); 
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false, Sum_Assured__c = 500,
                                            Application_Status__c ='Opened', Approve_Action_Plan__c = objAAP7.Id, Type__c = 'Bond', isAssignedToOps__c = true ,
                                            Scheme_Name_Policy_Name__c = 'Test Scheme1', Agreed_Amount__c = 1001, Suggested_Amount__c = 1000, Executed_Amount__c=0));                                                                         
        insert lstET;
        
        //objET .Application_Status__c = 'Closed';
        //objET .Executed_Amount__c=10;
        //objET .Total_Remaining_Balance__c = 1001;
        
        //Execution_Tracker__c objET = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false, Sum_Assured__c = 500,
        //                                    Application_Status__c = 'Closed', Approve_Action_Plan__c = objAAP3.Id, Type__c = 'SIP', isAssignedToOps__c = true ,
        //                                    Scheme_Name_Policy_Name__c = 'Test Scheme1', Agreed_Amount__c = 1001, Suggested_Amount__c = 1000, Executed_Amount__c=10);                                   
        
        
        Test.startTest();
        ApexPages.StandardController std = new ApexPages.StandardController(objAccount);
        ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        
        ExecutionTrackerForOpsTeamController objETC = new ExecutionTrackerForOpsTeamController(std); 
        objETC.cancel();
        objETC.getApplicationStatus();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].executedAmount = null;
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].applicationStatus = Label.Forms_Provided;
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].executedAmount = null;
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].applicationStatus = Label.Forms_Handed;
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].executedAmount = 120;
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].applicationStatus = 'Processed';
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].executedAmount = 0;
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].applicationStatus = 'Processed';
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].applicationStatus = 'Rejected';
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[1].lstExecutionTrackerDetail[0].applicationStatus = 'Closed';
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].executedAmount = 1001;
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].executedAmount = 120;
        objETC.updateExecutionTracker();
        
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].executedAmount = 12;
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].applicationStatus = 'Closed';
        objETC.lstExecutionTrackerGroupDetail[0].lstExecutionTrackerDetail[0].balanceRemaining = 1001;
        objETC.updateExecutionTracker();
        
        ExecutionTrackerRelatedListController objETRelatedList = new ExecutionTrackerRelatedListController(std);
        objETRelatedList.ViewRecords();
        
        Apexpages.currentPage().getParameters().put('apid', objAAP1.Id);
        Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
        RelatedExecutionTrackerController objRETC1 = new RelatedExecutionTrackerController(); 
        
        Apexpages.currentPage().getParameters().put('apid', objAAP2.Id);
        Apexpages.currentPage().getParameters().put('type', 'Life Insurance');
        RelatedExecutionTrackerController objRETC2 = new RelatedExecutionTrackerController(); 
        
        Apexpages.currentPage().getParameters().put('apid', objAAP4.Id);
        Apexpages.currentPage().getParameters().put('type', Label.Surrender_Insurance);
        RelatedExecutionTrackerController objRETC3 = new RelatedExecutionTrackerController(); 
        
        Apexpages.currentPage().getParameters().put('apid', objAAP5.Id);
        Apexpages.currentPage().getParameters().put('type', 'Loan');
        RelatedExecutionTrackerController objRETC4 = new RelatedExecutionTrackerController(); 
        
        Test.stopTest();
    }
}