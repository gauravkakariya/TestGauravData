/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class BatchTaskEscalationTest {

    public static User objUser1;
    public static User objUser2;
    public static Business_Unit__c objBU1;
    public static Business_Unit__c objBU2;
    public static Department__c objDept1;
    public static Department__c objDept2;
    public static Department__c objDept3;
    public static Department__c objDept4;
    public static Team_Member__c objTM1;
    public static Team_Member__c objTM2;
    public static Team_Member__c objTM3;
    public static Team_Member__c objTM4;
    
    public static Team_Member__c objPSTM1;
    public static Team_Member__c objMSTTM2;
    public static Team_Member__c objFPATM3;
    public static Team_Member__c objMST2TM4;
    
    public static Account objGeneralAccount;
    public static Account objAccount1;
    
    public static TestData_Ffreedom testData;
    
    static testMethod void BatchTaskEscalationUnitTest() {
        	
        Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
        testData = new TestData_Ffreedom();
        
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
        
        
        objUser1 = testData.initializeUser();
        objUser1.UserName ='test-user@fakeemail.com';
        objUser1.FirstName = 'Test_Parent_Fname2';
        objUser1.LastName = 'Test_Parent_Lname3';
        objUser1.CommunityNickname = 'tuser2';
        objUser1.Alias = 'tuser12';
        objUser1.email ='usertest-user@fakeemail1.com';
        insert objUser1;
        
        objUser2 = testData.initializeUser();
        objUser2.UserName ='test23-user@fakeemail.com';
        objUser2.FirstName = 'Test_Parent_Fname23';
        objUser2.LastName = 'Test_Parent_Lname23';
        objUser2.CommunityNickname = 'tuser23';
        objUser2.Alias = 'tuser123';
        objUser2.email ='usertest-user@fakeemail123.com';
        insert objUser2;
        
        objBU1 = testData.init_Business_Unit('BU1');
        insert objBU1;
        objBU2 = testData.init_Business_Unit('BU2');
        insert objBU2;
        
        List<Department__c> lstDepartment = new List<Department__c>();
        objDept1 = testData.init_Department('PST', objBU1.Id);
        objDept2 = testData.init_Department('MST', objBU1.Id);
        objDept3 = testData.init_Department('FPA', objBU1.Id);
        objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
        
        lstDepartment.add(objDept1);
        lstDepartment.add(objDept2);
        lstDepartment.add(objDept3);
        lstDepartment.add(objDept4);
        insert lstDepartment;
        
        List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
        objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
        objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
        objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
        objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
        
        objPSTM1 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
        objMSTTM2 = testData.init_Team_Member(objUser2.Id, objDept2.Id);
        objFPATM3 = testData.init_Team_Member(objUser2.Id, objDept3.Id);
        objMST2TM4 = testData.init_Team_Member(objUser2.Id, objDept4.Id);
        
        lstTeam_Member.add(objTM1);
        lstTeam_Member.add(objTM2);
        lstTeam_Member.add(objTM3);
        lstTeam_Member.add(objTM4);
        
        lstTeam_Member.add(objPSTM1);
        lstTeam_Member.add(objMSTTM2);
        lstTeam_Member.add(objFPATM3);
        lstTeam_Member.add(objMST2TM4);
        
        insert lstTeam_Member;
        
     
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWMASTER = Workflows_Tracker_Master__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWMASTER = DESCRIBE_RESULT_WFLOWMASTER.getRecordTypeInfosByName();
        
        Workflows_Tracker_Master__c objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        
       Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
       Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        
       Event_Master__c objEventTask = new Event_Master__c(isActive__c= true, Escalated_To__c= 'Manager',Name='Perform Welcome Call for Member Task');
       insert objEventTask; 
          
       Event_Master__c objEventEscalate = new Event_Master__c(isActive__c= true, Escalated_To__c= 'Manager',Name='Perform Welcome Call for Member Escalation');
       insert objEventEscalate; 
        
        
       Event_Master__c objEvent = new Event_Master__c(isActive__c= true, Escalated_To__c= 'Manager',Escalation_Event_Master__c=objEventEscalate.Id,  
        												Name='Perform Welcome Call for Member',
        												Task_Event_Master__c = objEventTask.Id);
       insert objEvent; 
       
       List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       
       Workflows_Tracker_Details__c objWflowTracker1 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Subject__c= 'Perform Welcome Call for Member',
                                                                 Comments__c = 'TEST',
                                                                 Event_Master__c= objEvent.id,
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 2, Name='Perform Welcome Call for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
        lstNewWFTrackerDetails.add(objWflowTracker1);
        
        insert lstNewWFTrackerDetails; 
       
       
      
         
        List<Account> lstAccount = new List<Account>();
        objGeneralAccount =  new Account( Name='Parner Account Test',
                                    RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId(),
                                    Business_Unit__c = objBU1.Id,
                                    PST_Team_Member__c = objTM1.Id,
                                    MST_Team_Member__c = objTM2.Id,
                                    FPA_Team_Member__c = objTM3.Id,
                                    OPS_Team_Member__c = objTM4.Id);
        
        lstAccount.add(objGeneralAccount);
        insert lstAccount;
        
        
        objAccount1 = testData.initializeAccount();
        objAccount1.Business_Unit__c = objBU1.Id;
        objAccount1.Virtual_Partner__c = objGeneralAccount.Id;
        objAccount1.PST_Team_Member__c = objTM1.Id;
        objAccount1.MST_Team_Member__c = objTM2.Id;
        objAccount1.FPA_Team_Member__c = objTM3.Id;
        objAccount1.OPS_Team_Member__c = objTM4.Id;
        
        insert objAccount1;
      
        
        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Perform Welcome Call for Member');
        objEntityWFlowtracker.Status__c= 'In Progress';
        
        update objEntityWFlowtracker;
        
        Task objTask3  = getTask('Perform Welcome Call for Member');
        objTask3.ActivityDate = Date.today().addDays(-1);
        objTask3.status = 'In Progress';
        	
        update objTask3;
        
       Test.startTest();
       String CRON_EXP = '0 04 02 * * ?';
       String jobId = System.schedule('BatchTaskEscalationTest',CRON_EXP, new TaskEscalationScheduler());
       Test.stopTest();
		
    }
    
     private static Task getTask(String strSubject)
    {
    	system.debug('***********'+strSubject);
        List<Task> lstTask = [Select WhatId, 
                            Subject_Category__c, Subject, Status, Description,
                            RecordTypeId, Priority, Plan_Presentation_Completion_Status__c, 
                            PartnerFinancialPlanPresentationDate__c, MemberFinancialPlanPresentationDate__c, 
                            Id, FinancialPlanGenerationDate__c, FinancialPlanCompletionDate__c,ExpectedFinancialPlanGenerationDate__c, 
                            ExecutionTrackerOpenedDate__c, Event_Status__c, Entity_Intereseted_in_FP_Status__c, 
                            Data_Collection_Approved_Status__c, DataCollectionDate__c, ActivityDate, 
                            ActionPlanSharingDate__c 
                        From Task
                        Where Subject =: strSubject];
                        
         return lstTask[0] ;           
        
    }
   
   
     private static Workflows_Tracker_Details__c getWflowTreackerDetailTest(Id AccountId, String strSubject) 
     {  
    	 List<Workflows_Tracker_Details__c > lstEntityWDetails = [Select Workflows_Tracker_Master__c, Task_Sequence__c, Task_Id__c, Subject__c, Status__c, 
																			Related_Workflow_Details_Date__c, Priority__c, Parent_Workflows_Tracker_Details__c, Comments__c,
																			Name, Id, Event_Master__c, Due_Date__c, Department__c, Channel_Type__c, Days_After__c,
																			Workflows_Tracker_Master__r.Parent_Account__c, Department__r.Type_of_Department__c,//Is_Partner_Task_Owner__c,
																			Workflows_Tracker_Master__r.Parent_Account__r.Virtual_Partner__c,
																			Workflows_Tracker_Master__r.Parent_Account__r.Business_Unit__c 
																			From Workflows_Tracker_Details__c 
																			Where Workflows_Tracker_Master__r.Parent_Account__c =: AccountId 
																			and Subject__c=: strSubject ];
		return lstEntityWDetails[0];															
     }
     
     
}