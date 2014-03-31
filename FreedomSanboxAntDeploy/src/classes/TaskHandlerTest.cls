/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
  *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TaskHandlerTest {


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
    
    public static Workflows_Tracker_Master__c objWorkflowMaster;
    
    public static TestData_Ffreedom testData;
    
    static testMethod void taskHandlerTest() {
        
        Test.startTest();
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
        
        testData = new TestData_Ffreedom();
       
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
       
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
        Workflows_Tracker_Details__c objWflowTracker1 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Subject__c= 'Meeting for Entity Details',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 1, Name='Meeting for Entity Details',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
        lstNewWFTrackerDetails.add(objWflowTracker1);
     
        Workflows_Tracker_Details__c objWflowTracker2 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 2,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 2, Name='Perform Welcome Call for Member',
                                                                 Subject__c= 'Perform Welcome Call for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker2);
        
        Workflows_Tracker_Details__c objWflowTracker3 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 3, Name='Send Welcome Mail and SMS to Member',
                                                                 Subject__c= 'Send Welcome Mail and SMS to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker3);
        
     
       
        
        /*
        Workflows_Tracker_Details__c objWflowTracker4 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Channel_Type__c='Both',
                                                                 Subject__c= 'Finalize Date for Data Collection for Member',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 4, Name='Finalize Date for Data Collection for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                     
        lstNewWFTrackerDetails.add(objWflowTracker4);
        
        
        Workflows_Tracker_Details__c objWflowTracker5 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -1,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Channel_Type__c='Both',
                                                                 Subject__c= 'Confirm Date for Data Collection for Member',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 5, Name='Confirm Date for Data Collection for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker5);
        
        
        Workflows_Tracker_Details__c objWflowTracker6 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Subject__c= 'Complete Data Collection',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 6, Name='Complete Data Collection',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker6);  
         
         
          Workflows_Tracker_Details__c objWflowTracker7 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 7, Name='Complete Data Collection Approve',
                                                                 Subject__c= 'Complete Data Collection Approve',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker6.Id );
        lstNewWFTrackerDetails.add(objWflowTracker7);   
                                                                 
        
        insert objWflowTracker7;
        
        */
         insert  lstNewWFTrackerDetails;
                                                 
       
       
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
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
     
        /*
        Task objTask1 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Meeting for Entity Details' );
        Task objTask2 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Perform Welcome Call for Member' );
        Task objTask3 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Send Welcome Mail and SMS to Member' );
        Task objTask4 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Data Collection Date').getRecordTypeId(),Subject= 'Finalize Date for Data Collection for Member' );
        Task objTask5 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Data Collection Date').getRecordTypeId(),Subject= 'Confirm Date for Data Collection for Member' );
        Task objTask6 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Data Collection Date').getRecordTypeId(),Subject= 'Complete Data Collection' );
        Task objTask7 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Data Collection Completion Approved').getRecordTypeId(),Subject= 'Complete Data Collection Approve' );
        Task objTask8 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Financial Plan Completion').getRecordTypeId(),Subject= 'Expected Financial Plan Completion Date' );
        Task objTask9 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Generate Financial Plan' );
        Task objTask10 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Partner Plan Presentation Date').getRecordTypeId(),Subject= 'Present and Approve FP Presentation to Partner' );
        Task objTask11 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Member Plan Presentation Date').getRecordTypeId(),Subject= 'Finalize date for Financial Plan Presentation to Member' );
        Task objTask12 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Member Plan Presentation Date').getRecordTypeId(),Subject= 'Confirm date for Financial Plan Presentation to Member' );
        Task objTask13 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Plan Presentation Rework Decide').getRecordTypeId(),Subject= 'Present Financial Plan to Member' );
        Task objTask14 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Revise Financial Plan for Rework' );
        Task objTask15 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Get Financial Plan Approval from Member' );
        Task objTask16 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Generate Action Plan' );
        Task objTask17 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Action Plan Disseminate').getRecordTypeId(),Subject= 'Disseminate Action Plan to Member post Feedback from Partner' );
        Task objTask18 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Activate Action Plan for Member' );
        Task objTask19 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Open Execution Tracker' );
        Task objTask20 = new Task(Status='In Progress', RecordTypeId= RECORD_TYPE_INFO_MAP_TASK.get('Automated Flows Master').getRecordTypeId(),Subject= 'Close Execution Tracker' );
        
        insert objWorkflowMaster1;
        
     */
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
  
     private static testMethod void tasksequence1Test() {
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
        taskHandlerTest();
      
        Task objTask1  = getTask( 'Meeting for Entity Details');
        objTask1.Status = 'Completed';
        objTask1.DataCollectionDate__c = Date.today();
        objTask1.Entity_Intereseted_in_FP_Status__c = 'Converted';
        update objTask1;
        
        Task objTask2  = getTask( 'Perform Welcome Call for Member');
        objTask2.Status = 'Completed';
        objTask2.DataCollectionDate__c = Date.today();
        update objTask2;
        
        Task objTask3  = getTask('Send Welcome Mail and SMS to Member');
        objTask3.Status = 'Completed';
        objTask3.DataCollectionDate__c = Date.today();
        update objTask3;
        
        
      }
     
    private static testMethod void tasksequence2Test() {
       
        Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
        Workflows_Tracker_Details__c objWflowTracker1 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Subject__c= 'Meeting for Entity Details',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 1, Name='Meeting for Entity Details',
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
        
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Meeting for Entity Details') != null)
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Meeting for Entity Details');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	       
	        Task objTask  = getTask( 'Meeting for Entity Details');
	        objTask.Status = 'Completed';
	        objTask.Entity_Intereseted_in_FP_Status__c = 'Not Interested in FP';
	        update objTask;
        
        }
        
        
        
        //objTask.Entity_Intereseted_in_FP_Status__c = 'Interested in FP';
        //update objTask;
    }
    
     private static testMethod void tasksequence22Test() {
       
        Test.startTest();
        
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
        
         objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        
       
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
        Workflows_Tracker_Details__c objWflowTracker1 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Subject__c= 'Meeting for Entity Details',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 1, Name='Meeting for Entity Details',
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
        
         if(getWflowTreackerDetailTest(objAccount1.Id, 'Meeting for Entity Details') != null)
	     {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Meeting for Entity Details');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	       
	        Task objTask  = getTask( 'Meeting for Entity Details');
	        objTask.Status = 'Completed';
	        objTask.Entity_Intereseted_in_FP_Status__c = 'Interested in FP';
	        update objTask;
	     }
        
        
    }
    
    
     private static testMethod void tasksequence3Test() 
     {
     	
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
       
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
        Workflows_Tracker_Details__c objWflowTracker3 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 3, Name='Send Welcome Mail and SMS to Member',
                                                                 Subject__c= 'Send Welcome Mail and SMS to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker3);
        
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
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Send Welcome Mail and SMS to Member') != null)
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Send Welcome Mail and SMS to Member');
	        
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Send Welcome Mail and SMS to Member');
	        
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
     private static testMethod void tasksequence4Test() 
     {
    
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
       
      
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
        Workflows_Tracker_Details__c objWflowTracker4 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Channel_Type__c='Both',
                                                                 Subject__c= 'Finalize Date for Data Collection for Member',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 4, Name='Finalize Date for Data Collection for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker4);
        
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
      
        
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Finalize Date for Data Collection for Member') != null)
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Finalize Date for Data Collection for Member');
	        
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Finalize Date for Data Collection for Member');
	        objTask3.DataCollectionDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
    	 }
     	
     }
     
      private static testMethod void tasksequence5Test() 
     {
     	
     	
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
    
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
         Workflows_Tracker_Details__c objWflowTracker5 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -1,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Channel_Type__c='Both',
                                                                 Subject__c= 'Confirm Date for Data Collection for Member',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 5, Name='Confirm Date for Data Collection for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker5);
        
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
      
        
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Confirm Date for Data Collection for Member') != null)
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Confirm Date for Data Collection for Member');
	        
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Confirm Date for Data Collection for Member');
	        objTask3.DataCollectionDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
        }   
        
     	
     }
     
     
       
      private static testMethod void tasksequence6Test() 
     {
     	
     
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
        Workflows_Tracker_Details__c objWflowTracker6 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Subject__c= 'Complete Data Collection',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 6, Name='Complete Data Collection',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker6);
        
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
      
       if(getWflowTreackerDetailTest(objAccount1.Id, 'Complete Data Collection') != null) 
       {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Complete Data Collection');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Complete Data Collection');
	        objTask3.DataCollectionDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
       } 
     	
     }
     
     
      private static testMethod void tasksequence7Test() 
     {
    
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       Workflows_Tracker_Details__c objWflowTracker6 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Related_Workflow_Details_Date__c='Data Collection Date',
                                                                 Subject__c= 'Complete Data Collection',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 6, Name='Complete Data Collection',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker6);  
            
         insert  lstNewWFTrackerDetails;
                                                 
        Workflows_Tracker_Details__c objWflowTracker7 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 7, Name='Complete Data Collection Approve',
                                                                 Subject__c= 'Complete Data Collection Approve',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker6.Id );
        lstNewWFTrackerDetails.add(objWflowTracker7);   
                                                                 
        
        insert objWflowTracker7;
        
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
      
        
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Complete Data Collection Approve') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Complete Data Collection Approve');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Complete Data Collection Approve');
	        objTask3.Data_Collection_Approved_Status__c = 'Accept';
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
      private static testMethod void tasksequence8Test() 
     {
     	
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       Workflows_Tracker_Details__c objWflowTracker6 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Subject__c= 'Complete Data Collection',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 6, Name='Complete Data Collection',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker6);  
            
         insert  lstNewWFTrackerDetails;
                                                 
        Workflows_Tracker_Details__c objWflowTracker8 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 1,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 8, Name='Expected Financial Plan Completion Date',
                                                                 Subject__c= 'Expected Financial Plan Completion Date',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker6.Id );
       
        
        insert objWflowTracker8;
                                                                 
        
       
        
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
      
       if(getWflowTreackerDetailTest(objAccount1.Id, 'Expected Financial Plan Completion Date') != null) 
       {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Expected Financial Plan Completion Date');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Expected Financial Plan Completion Date');
	        objTask3.ExpectedFinancialPlanGenerationDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
       }
        
     	
     }
     
       private static testMethod void tasksequence9Test() 
     {
     	
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
         objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       Workflows_Tracker_Details__c objWflowTracker6 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 10,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Subject__c= 'Complete Data Collection',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 6, Name='Complete Data Collection',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker6);  
            
         insert  lstNewWFTrackerDetails;
                                                 
        Workflows_Tracker_Details__c objWflowTracker9 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 1,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 9, Name='Generate Financial Plan',
                                                                 Subject__c= 'Generate Financial Plan',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker6.Id );
       
        
        insert objWflowTracker9;
                                                                 
        
       
        
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
      
        
         if(getWflowTreackerDetailTest(objAccount1.Id, 'Generate Financial Plan') != null) 
         {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Generate Financial Plan');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Generate Financial Plan');
	        objTask3.Status = 'Completed';
	        update objTask3;
         }
        
     	
     }
     
        private static testMethod void tasksequence10Test() 
     {
     	Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
        
     	 
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
      
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
        Workflows_Tracker_Details__c objWflowTracker8 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 10,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Subject__c= 'Expected Financial Plan Completion Date',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 8, Name='Expected Financial Plan Completion Date',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker8);  
            
         insert  lstNewWFTrackerDetails;
                                                 
        Workflows_Tracker_Details__c objWflowTracker9 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 1,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 9, Name='Present and Approve FP Presentation to Partner',
                                                                 Subject__c= 'Present and Approve FP Presentation to Partner',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker8.Id );
       
        
        insert objWflowTracker9;
                                                                 
        
       
        
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
      
        
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Present and Approve FP Presentation to Partner') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Present and Approve FP Presentation to Partner');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Present and Approve FP Presentation to Partner');
	        objTask3.PartnerFinancialPlanPresentationDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
     private static testMethod void tasksequence11Test() 
     {
     	Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
     	 
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
         objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
       
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
        Workflows_Tracker_Details__c objWflowTracker8 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 10,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Subject__c= 'Expected Financial Plan Completion Date',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 8, Name='Expected Financial Plan Completion Date',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker8);  
            
         insert  lstNewWFTrackerDetails;
                                                 
        Workflows_Tracker_Details__c objWflowTracker9 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 1,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 9, Name='Finalize date for Financial Plan Presentation to Member',
                                                                 Subject__c= 'Finalize date for Financial Plan Presentation to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker8.Id );
       
        
        insert objWflowTracker9;
                                                                 
        
       
        
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
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Finalize date for Financial Plan Presentation to Member') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Finalize date for Financial Plan Presentation to Member');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Finalize date for Financial Plan Presentation to Member');
	        objTask3.MemberFinancialPlanPresentationDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
      private static testMethod void tasksequence12Test() 
     {
     	  Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
     	 
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
       objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
       
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
                                                 
        Workflows_Tracker_Details__c objWflowTracker10 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -1,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c ='Plan Presentation Date',
                                                                 Task_Sequence__c= 10, Name='Confirm date for Financial Plan Presentation to Member',
                                                                 Subject__c= 'Confirm date for Financial Plan Presentation to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started'
                                                                 );
       
        
        insert objWflowTracker10;
                                                                 
        
       
        
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
      
        
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Confirm date for Financial Plan Presentation to Membe') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Confirm date for Financial Plan Presentation to Member');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Confirm date for Financial Plan Presentation to Member');
	        objTask3.MemberFinancialPlanPresentationDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
        }   
        
     	
     }
     
           private static testMethod void tasksequence13Test() 
     {
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
         objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
       
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       
                                                 
        Workflows_Tracker_Details__c objWflowTracker11 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 11, Name='Present Financial Plan to Member',
                                                                 Subject__c= 'Present Financial Plan to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker11;
                                                                 
        
       
        
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
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Present Financial Plan to Member') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Present Financial Plan to Member');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Present Financial Plan to Member');
	        objTask3.Plan_Presentation_Completion_Status__c = 'Rework Required';
	        objTask3.Status = 'Completed';
	        update objTask3;
        }  
        
     	
     }
     
      private static testMethod void tasksequence14Test() 
     {
     	Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
        
          
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
       
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       
         Workflows_Tracker_Details__c objWflowTracker11 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 11, Name='Present Financial Plan to Member',
                                                                 Subject__c= 'Present Financial Plan to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker11;
        
                                                 
        Workflows_Tracker_Details__c objWflowTracker12 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 5,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 12, Name='Revise Financial Plan for Rework',
                                                                 Subject__c= 'Revise Financial Plan for Rework',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker11.id);
       
        
        insert objWflowTracker12;
                                                                 
        
       
        
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
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Revise Financial Plan for Rework') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Revise Financial Plan for Rework');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Revise Financial Plan for Rework');
	        
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
      private static testMethod void tasksequence15Test() 
     {
     	
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       
         Workflows_Tracker_Details__c objWflowTracker11 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 11, Name='Present Financial Plan to Member',
                                                                 Subject__c= 'Present Financial Plan to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker11;
        
                                                 
        Workflows_Tracker_Details__c objWflowTracker13 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 7,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 13, Name='Get Financial Plan Approval from Member',
                                                                 Subject__c= 'Get Financial Plan Approval from Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker11.id);
       
        
        insert objWflowTracker13;
                                                                 
        
        
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
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Get Financial Plan Approval from Member') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Get Financial Plan Approval from Member');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Get Financial Plan Approval from Member');
	        
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
      private static testMethod void tasksequence16Test() 
     {
     	  Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
     	 
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
       
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
       
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
        
         Workflows_Tracker_Details__c objWflowTracker11 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 11, Name='Present Financial Plan to Member',
                                                                 Subject__c= 'Present Financial Plan to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker11;
         
               
        Workflows_Tracker_Details__c objWflowTracker13 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 7,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 13, Name='Get Financial Plan Approval from Member',
                                                                 Subject__c= 'Get Financial Plan Approval from Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker11.id);
       
        
        insert objWflowTracker13;
        
                                                 
        Workflows_Tracker_Details__c objWflowTracker14 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 5,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 14, Name='Generate Action Plan',
                                                                 Subject__c= 'Generate Action Plan',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker13.id);
       
        
        insert objWflowTracker14;
                                                                 
        
       
        
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
      
         if(getWflowTreackerDetailTest(objAccount1.Id, 'Generate Action Plan') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Generate Action Plan');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Generate Action Plan');
	        
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
        private static testMethod void tasksequence17Test() 
     {
     	
     	  Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
        
     	  
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
        
         Workflows_Tracker_Details__c objWflowTracker11 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 11, Name='Present Financial Plan to Member',
                                                                 Subject__c= 'Present Financial Plan to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker11;
         
               
        Workflows_Tracker_Details__c objWflowTracker13 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 7,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 13, Name='Get Financial Plan Approval from Member',
                                                                 Subject__c= 'Get Financial Plan Approval from Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker11.id);
       
        
        insert objWflowTracker13;
        
                                                 
        Workflows_Tracker_Details__c objWflowTracker14 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 5,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 14, Name='Generate Action Plan',
                                                                 Subject__c= 'Generate Action Plan',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker13.id);
       
        
        insert objWflowTracker14;
        
                                                 
        Workflows_Tracker_Details__c objWflowTracker15 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 2,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 15, Name='Disseminate Action Plan to Member post Feedback from Partner',
                                                                 Subject__c= 'Disseminate Action Plan to Member post Feedback from Partner',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker14.id);
       
        
        insert objWflowTracker15;
                                                                 
        
       
        
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
      
         if(getWflowTreackerDetailTest(objAccount1.Id, 'Disseminate Action Plan to Member post Feedback from Partner') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Disseminate Action Plan to Member post Feedback from Partner');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Disseminate Action Plan to Member post Feedback from Partner');
	        objTask3.ActionPlanSharingDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
        private static testMethod void tasksequence18Test() 
     {
     	
     	  Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
     	
       
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
      
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
          Workflows_Tracker_Details__c objWflowTracker11 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 11, Name='Present Financial Plan to Member',
                                                                 Subject__c= 'Present Financial Plan to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker11;
         
               
        Workflows_Tracker_Details__c objWflowTracker13 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 7,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 13, Name='Get Financial Plan Approval from Member',
                                                                 Subject__c= 'Get Financial Plan Approval from Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker11.id);
       
        
        insert objWflowTracker13;
        
                                                 
        Workflows_Tracker_Details__c objWflowTracker14 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 5,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 14, Name='Generate Action Plan',
                                                                 Subject__c= 'Generate Action Plan',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker13.id);
       
        
        insert objWflowTracker14;
        
                                                 
        Workflows_Tracker_Details__c objWflowTracker15 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 2,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 15, Name='Disseminate Action Plan to Member post Feedback from Partner',
                                                                 Subject__c= 'Disseminate Action Plan to Member post Feedback from Partner',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker14.id);
       
        
        insert objWflowTracker15;
                                                                 
                                                 
        Workflows_Tracker_Details__c objWflowTracker16 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 2,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 16, Name='Activate Action Plan for Member',
                                                                 Subject__c= 'Activate Action Plan for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker15.id);
       
        
        insert objWflowTracker16;
                                                                 
        
       
        
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
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Activate Action Plan for Member') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Activate Action Plan for Member');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Activate Action Plan for Member');
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
     
     
     private static testMethod void tasksequence20Test() 
     {
     	  Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
     	 
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
        objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
      
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
                                                                 
        Workflows_Tracker_Details__c objWflowTracker19 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 2,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 16, Name='Close Execution Tracker',
                                                                 Subject__c= 'Close Execution Tracker',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker19;
                                                                 
        
       
        
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
      
         if(getWflowTreackerDetailTest(objAccount1.Id, 'Close Execution Tracker') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Close Execution Tracker');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Close Execution Tracker');
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
    
     private static testMethod void tasksequence21Test() 
     {
     	Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
       
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
        testData = new TestData_Ffreedom();
        
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
        
       objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
      
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
                                                                 
        Workflows_Tracker_Details__c objWflowTracker19 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 2,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 16, Name='Open Execution Tracker',
                                                                 Subject__c= 'Open Execution Tracker',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' 
                                                                 );
       
        
        insert objWflowTracker19;
                                                                 
        
       
        
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
      
         if(getWflowTreackerDetailTest(objAccount1.Id, 'Open Execution Tracker') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Open Execution Tracker');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Open Execution Tracker');
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
  /*
      private static testMethod void fillmapTest() 
     {
     	  
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
                                                                 
        Workflows_Tracker_Details__c objWflowTracker1 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Subject__c= 'Meeting for Entity Details',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 1, Name='Meeting for Entity Details',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
        lstNewWFTrackerDetails.add(objWflowTracker1);
     /*   
        Workflows_Tracker_Details__c objWflowTracker2 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 2,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Task_Sequence__c= 2, Name='Perform Welcome Call for Member',
                                                                 Subject__c= 'Perform Welcome Call for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker2);
        
        Workflows_Tracker_Details__c objWflowTracker3 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -999,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 3, Name='Send Welcome Mail and SMS to Member',
                                                                 Subject__c= 'Send Welcome Mail and SMS to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker3);
        
     
       
        
        
        Workflows_Tracker_Details__c objWflowTracker4 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Channel_Type__c='Both',
                                                                 Subject__c= 'Finalize Date for Data Collection for Member',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 4, Name='Finalize Date for Data Collection for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                     
        lstNewWFTrackerDetails.add(objWflowTracker4);
        
        
        Workflows_Tracker_Details__c objWflowTracker5 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -1,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Channel_Type__c='Both',
                                                                 Subject__c= 'Confirm Date for Data Collection for Member',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 5, Name='Confirm Date for Data Collection for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker5);
        
        
        Workflows_Tracker_Details__c objWflowTracker6 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Subject__c= 'Complete Data Collection',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 6, Name='Complete Data Collection',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker6);  
         
          insert  lstNewWFTrackerDetails;
                                              
          Workflows_Tracker_Details__c objWflowTracker7 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 7, Name='Complete Data Collection Approve',
                                                                 Subject__c= 'Complete Data Collection Approve',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker6.Id );
        
        insert objWflowTracker7;
        
       */
 /*      
        insert  lstNewWFTrackerDetails;
         
        MAP<Id,Workflows_Tracker_Details__c> mapNewWFlowTrackerIdToWFlowTracker1 = new MAP<Id,Workflows_Tracker_Details__c> ();
        TaskHandler objnewTask = new TaskHandler();
        for(Workflows_Tracker_Details__c objWfDetail : lstNewWFTrackerDetails)
        {
         	mapNewWFlowTrackerIdToWFlowTracker1.put(objWfDetail.Id, objWfDetail);
        }
        system.debug('************mapNewWFlowTrackerIdToWF'+mapNewWFlowTrackerIdToWFlowTracker1);                                                         
        objnewTask.mapNewWFlowTrackerIdToWFlowTracker = mapNewWFlowTrackerIdToWFlowTracker1;
       
        
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
      
        
        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Meeting for Entity Details');
        objEntityWFlowtracker.Status__c= 'In Progress';
        
        //update objEntityWFlowtracker;
        
        List<Workflows_Tracker_Details__c> lstWFlowTrackerTracker = [Select Task_Sequence__c, 
												    							Task_Id__c, Subject__c, Status__c, 
														    					Related_Workflow_Details_Date__c, Priority__c,
														    					Event_Master__r.Escalation_Event_Master__c,Workflows_Tracker_Master__c,
														    					Workflows_Tracker_Master__r.Name, Parent_Workflows_Tracker_Details__r.Status__c,
																				Parent_Workflows_Tracker_Details__c, Name, Id, Event_Master__c, 
																				Due_Date__c, Department__c, Department__r.Business_Unit__c,Days_After__c, Comments__c, 
																				Channel_Type__c ,Workflows_Tracker_Master__r.Parent_Account__c
																		  From Workflows_Tracker_Details__c 
				                                      				      ];
		  system.debug('*******lstWFlowTrackerTrackerr'+lstWFlowTrackerTracker);		                                      				      
        mapNewWFlowTrackerIdToWFlowTracker1.put(objEntityWFlowtracker.Id, objEntityWFlowtracker);  
        system.debug('************objnewTask.mapNewWFlowTrackerIdToWFlowTracker'+objnewTask.mapNewWFlowTrackerIdToWFlowTracker);
        objnewTask.mapNewWFlowTrackerIdToWFlowTracker = mapNewWFlowTrackerIdToWFlowTracker1;  
        
        Task objTask3  = getTask('Meeting for Entity Details');
        objTask3.Entity_Intereseted_in_FP_Status__c = 'Converted';
        objTask3.Status = 'Completed';
        update objTask3;
        
     	
     }  
   */
   
      private static testMethod void tasksequenceDataCollectionConfirmSameDateTest() 
     {
     	
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
         objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
         Workflows_Tracker_Details__c objWflowTracker5 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -1,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Channel_Type__c='Both',
                                                                 Subject__c= 'Confirm Date for Data Collection for Member',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c='Entity Creation Date',
                                                                 Task_Sequence__c= 5, Name='Confirm Date for Data Collection for Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
        lstNewWFTrackerDetails.add(objWflowTracker5);
        
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
        objAccount1.DataCollectionDate__c= Date.today();
        insert objAccount1;
        
       
      
         if(getWflowTreackerDetailTest(objAccount1.Id, 'Confirm Date for Data Collection for Member') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Confirm Date for Data Collection for Member');
	        
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Confirm Date for Data Collection for Member');
	        objTask3.DataCollectionDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        Test.stopTest();
     	
     }
     
     private static testMethod void tasksequence7DataColectionRejectTest() 
     {
     	  
        Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
         objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
     
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
       Workflows_Tracker_Details__c objWflowTracker6 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c= 'High',
                                                                 Comments__c = 'TEST',
                                                                 Related_Workflow_Details_Date__c='Data Collection Date',
                                                                 Subject__c= 'Complete Data Collection',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 6, Name='Complete Data Collection',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' );
                                                                 
                                                                 
         lstNewWFTrackerDetails.add(objWflowTracker6);  
            
         insert  lstNewWFTrackerDetails;
                                                 
        Workflows_Tracker_Details__c objWflowTracker7 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= 3,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept3.id,
                                                                 Task_Sequence__c= 7, Name='Complete Data Collection Approve',
                                                                 Subject__c= 'Complete Data Collection Approve',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started' ,
                                                                 Parent_Workflows_Tracker_Details__c = objWflowTracker6.Id );
        lstNewWFTrackerDetails.add(objWflowTracker7);   
                                                                 
        
        insert objWflowTracker7;
                                                                 
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
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Complete Data Collection Approve') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Complete Data Collection Approve');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        Test.stopTest();
	        Task objTask3  = getTask('Complete Data Collection Approve');
	        objTask3.Data_Collection_Approved_Status__c = 'Reject';
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
        
     	
     }
     
     private static testMethod void tasksequenceDataCollectionConfirmSameMemberDateTest() 
     {
     	
     	Schema.DescribeSObjectResult DESCRIBE_RESULT_TASK = Task.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_TASK = DESCRIBE_RESULT_TASK.getRecordTypeInfosByName();
        
         Test.startTest();
        
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
        
         objWorkflowMaster = new Workflows_Tracker_Master__c(RecordTypeId = RECORD_TYPE_INFO_MAP_WFLOWMASTER.get('WFlowTemplate').getRecordTypeId(), Name='Entity Workflow Tracker Details', Tracker_Type__c='EntityWFlowTracker');
        insert objWorkflowMaster;
        
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WFLOWDETAIL = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFLOWDETAIL = DESCRIBE_RESULT_WFLOWDETAIL.getRecordTypeInfosByName();
        
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
               
                                                  
        Workflows_Tracker_Details__c objWflowTracker10 = 
                                new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
                                                                 Days_After__c= -1,
                                                                 Priority__c ='High',
                                                                 Department__c = objDept2.id,
                                                                 Related_Workflow_Details_Date__c ='Plan Presentation Date',
                                                                 Task_Sequence__c= 10, Name='Confirm date for Financial Plan Presentation to Member',
                                                                 Subject__c= 'Confirm date for Financial Plan Presentation to Member',
                                                                 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
                                                                 Status__c= 'Not Started'
                                                                 );
       
        
        insert objWflowTracker10;
                                                                 
        
       
        
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
        objAccount1.MemberFinancialPlanPresentationDate__c = Date.today();
        insert objAccount1;
      
        if(getWflowTreackerDetailTest(objAccount1.Id, 'Confirm date for Financial Plan Presentation to Member') != null) 
        {
	        Workflows_Tracker_Details__c objEntityWFlowtracker= getWflowTreackerDetailTest(objAccount1.Id, 'Confirm date for Financial Plan Presentation to Member');
	        objEntityWFlowtracker.Status__c= 'In Progress';
	        
	        update objEntityWFlowtracker;
	        
	        Task objTask3  = getTask('Confirm date for Financial Plan Presentation to Member');
	        objTask3.MemberFinancialPlanPresentationDate__c = Date.today();
	        objTask3.Status = 'Completed';
	        update objTask3;
        }
	        
        Test.stopTest();
     	
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
																			
		system.debug('***********lstEntityWDetails'+lstEntityWDetails);			
		if(!lstEntityWDetails.isEmpty())														
			return lstEntityWDetails[0];
		return null;		
																		
     }
   
}