/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CreateProcessFlowTrackerHandlerTest {

    static testMethod void createProcessFlowTest() {
    	
        Test.startTest();
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
    															 Related_Workflow_Details_Date__c='Entity Creation Date',
    	 														 Task_Sequence__c= 1, Name='Meeting for Entity Details',
    	 														 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
    	 														 Status__c= 'Not Started' );
    	lstNewWFTrackerDetails.add(objWflowTracker1);
    	
    	Workflows_Tracker_Details__c objWflowTracker2 = 
    							new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
    															 Days_After__c= 2,
    															 Related_Workflow_Details_Date__c='Entity Creation Date',
    	 														 Task_Sequence__c= 2, Name='Perform Welcome Call for Member',
    	 														 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
    	 														 Status__c= 'Not Started' );
    	 														 
    	lstNewWFTrackerDetails.add(objWflowTracker2);
    	
    	Workflows_Tracker_Details__c objWflowTracker3 = 
    							new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
    															 Days_After__c= 3,
    															 Related_Workflow_Details_Date__c='Entity Creation Date',
    	 														 Task_Sequence__c= 3, Name='Send Welcome Mail and SMS to Member',
    	 														 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
    	 														 Status__c= 'Not Started' );
    	 														 
    	lstNewWFTrackerDetails.add(objWflowTracker3);
    	
    	
    	
    	Workflows_Tracker_Details__c objWflowTracker4 = 
    							new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
    															 Days_After__c= 3,
    															 Related_Workflow_Details_Date__c='Entity Creation Date',
    	 														 Task_Sequence__c= 4, Name='Finalize Date for Data Collection for Member',
    	 														 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
    	 														 Status__c= 'Not Started' );
    	 															 
    	lstNewWFTrackerDetails.add(objWflowTracker4);
    	
    	
    	Workflows_Tracker_Details__c objWflowTracker5 = 
    							new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
    															 Days_After__c= 3,
    															 Related_Workflow_Details_Date__c='Entity Creation Date',
    	 														 Task_Sequence__c= 5, Name='Confirm Date for Data Collection for Member',
    	 														 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
    	 														 Status__c= 'Not Started' );
    	 														 
    	lstNewWFTrackerDetails.add(objWflowTracker5);
    	
    	
    	Workflows_Tracker_Details__c objWflowTracker6 = 
    							new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
    															 Days_After__c= 3,
    															 Related_Workflow_Details_Date__c='Entity Creation Date',
    	 														 Task_Sequence__c= 6, Name='Complete Data Collection',
    	 														 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
    	 														 Status__c= 'Not Started' );
    	 														 
    	 														 
    	 lstNewWFTrackerDetails.add(objWflowTracker6);	
    	 	
    	 insert  lstNewWFTrackerDetails;
    	 										 
    	Workflows_Tracker_Details__c objWflowTracker7 = 
    							new Workflows_Tracker_Details__c(RecordTypeId=RECORD_TYPE_INFO_MAP_WFLOWDETAIL.get('WFlowTemplate').getRecordTypeId(),
    															 Days_After__c= 3,
    															 Related_Workflow_Details_Date__c='Entity Creation Date',
    	 														 Task_Sequence__c= 7, Name='Complete Data Collection Approve',
    	 														 Workflows_Tracker_Master__c = objWorkflowMaster.Id, 
    	 														 Status__c= 'Not Started' ,
    	 														 Parent_Workflows_Tracker_Details__c = objWflowTracker6.Id );
    	 														 
    	lstNewWFTrackerDetails.add(objWflowTracker7);	
    	 														 
    										 														 														  														  														  														 
    	
    	insert objWflowTracker7;
    	
    	
	    List<Account> lstAccount = new List<Account>();
	    
    	//Insert Account record
    	Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', 
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true);
	                       
	    lstAccount.add(objAccount1);
	    lstAccount.add(objGeneralAccount);               
		insert lstAccount;
		
		
		
		 Test.stopTest();
    }
}