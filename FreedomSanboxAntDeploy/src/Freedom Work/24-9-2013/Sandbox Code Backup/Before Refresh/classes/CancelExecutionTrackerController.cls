public with sharing class CancelExecutionTrackerController 
{
	public List<ExecutionTrackerDetail> lstExecutionTrackerDetail {get;set;}
	public Boolean isRender {get;set;}
	public Id entityId {get;set;}
	
	public class ExecutionTrackerDetail
	{
		public Boolean isCancel {get;set;}
		public Execution_Tracker__c objExectionTracker{get;set;}
		
		public ExecutionTrackerDetail(Execution_Tracker__c objExectionTracker)
		{
			this.isCancel = false;
			this.objExectionTracker = objExectionTracker;
		}
	}
	public CancelExecutionTrackerController()
	{
		lstExecutionTrackerDetail = new List<ExecutionTrackerDetail>();
		isRender = true;
		entityId = ApexPages.currentPage().getParameters().get('id');
		User objUser = [Select Id, ProfileId, Profile.Name from User where Id =: UserInfo.getUserId()];
		if(objUser.Profile.Name != 'Operations-Compliance')
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'You are not authorized to Cancel the Execution Tracker at this time. Please contact your Manager or System Administrator in order to do so.'));
		    isRender = false;
		    return;
		}
		
		for(Execution_Tracker__c objET : [Select Id, Name, Type__c, Target_Revenue__c, Remarks__c, Goal__r.Goal_Type__c, Executed_Amount__c, Booked_Revenue__c,
													 Agreed_Amount__c, Suggested_Amount__c  
										   From Execution_Tracker__c 
										   where Entity_Name__c =:entityId and ET_Status__c != 'Cancelled' ])
		{
			lstExecutionTrackerDetail.add(new ExecutionTrackerDetail(objET));
		}
		
		if(lstExecutionTrackerDetail.isEmpty())
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'There are no Open Execution Tracker records available to Cancel. Please click Back to return.'));
		    isRender = false;
		    return;
		}
	}
	
	public PageReference cancel()
	{
		return new PageReference('/' + entityId);
	}
	
	public PageReference saveET()
	{
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		
		for(ExecutionTrackerDetail objETD : lstExecutionTrackerDetail)
		{
			if(objETD.isCancel)
			{
				if(objETD.objExectionTracker.Remarks__c != null && objETD.objExectionTracker.Remarks__c.trim() !='')
				{
					objETD.objExectionTracker.ET_Status__c = 'Cancelled';
					lstET.add(objETD.objExectionTracker);
				}
				else
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please provide valid Cancellation Remarks to cancel the Execution Tracker'));
				    //isRender = false;
				    return null;
				}
			}
		}
		
		if(!lstET.isEmpty())
		{
			update lstET;
		}
		return new PageReference('/' + entityId);
	}
	
	//test Method
	@isTest
	public static  void testCancelExecutionTrackerController()
	{
		/*RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
	    insert objAccount;
	    
	    List<Goal__c> lstGoal = new List<Goal__c>();
	    Goal__c objGoal1 = new Goal__c(Entity__c = objAccount.id,Goal_Type__c='Emergency Fund');
      	lstGoal.add(objGoal1);
      	Goal__c objGoal2 = new Goal__c(Entity__c = objAccount.id, Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
        lstGoal.add(objGoal2);
        insert lstGoal;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', objAccount.id);
        CancelExecutionTrackerController objCETC = new CancelExecutionTrackerController(); 
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id, Goal__c = lstGoal[1].Id, ET_Status__c = 'Assigned to Operations'));
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id, Goal__c = lstGoal[0].Id, ET_Status__c = 'Assigned to Operations'));
        
        insert lstET;
        
        System.assertEquals('Assigned to Operations', lstET[0].ET_Status__c);
        CancelExecutionTrackerController objCETC1 = new CancelExecutionTrackerController();
         
        objCETC1.cancel();
        objCETC1.saveET();
        objCETC1.lstExecutionTrackerDetail[0].isCancel = true;
        objCETC1.saveET();
        
        objCETC1.lstExecutionTrackerDetail[0].objExectionTracker.Remarks__c = 'Test Cancelled';
        objCETC1.saveET();
        Test.stopTest();*/
	}
}