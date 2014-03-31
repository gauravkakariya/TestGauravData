public class TestExecutionTrackerViewRecordController 
{
	@isTest(SeeAllData=true)
    static  void testExecutionTrackerViewRecordController() 
    {
        RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
	    insert objAccount;
	    
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP1;
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP2;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations',Is_Floating__c = false, 
        									Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Lumpsum'));
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'SIP'));
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Life Insurance'));
        
        insert lstET;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('eid', lstET[0].Id);
		Apexpages.currentPage().getParameters().put('type', 'Lumpsum');
		Apexpages.currentPage().getParameters().put('type', 'Life Insurance');
		ExecutionTrackerViewRecordController obj = new ExecutionTrackerViewRecordController();
		obj.updateExecutionTracker();
    }
}