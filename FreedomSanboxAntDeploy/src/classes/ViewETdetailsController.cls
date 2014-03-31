/* 
    Version     Version Author     Date          Comments
    1.0         Aditi         07/05/2013     Display Insurance and Mutual Fund and Insurance details on view link for Closed and Rejected Et records
*/
public with sharing class ViewETdetailsController 
{
	public Id executionTrackerId {get;set;}
	public Boolean isInsuracne {get;set;}
	public Boolean isOtherProducts {get;set;}
	
	public ViewETdetailsController(ApexPages.StandardController controller)
    {
     	executionTrackerId = controller.getId();
     	isInsuracne = false;
     	Execution_Tracker__c objET = [Select Id,Goal_Name__c, Agreed_Amount_Base_Amount__c,Suggested_Amount__c, Scheme_Name_Policy_Name__c, Owner__r.Name, Executed_Amount__c, ET_Status__c, 
     				Balance_Remaining__c, Executed_Product_Name__c,Agreed_Amount__c,Application_Status__c 
     				From Execution_Tracker__c 
     				where Id =: executionTrackerId];
       if(objET.Goal_Name__c != null && (objET.Goal_Name__c.equalsIgnoreCase('Life Insurance') || objET.Goal_Name__c.equalsIgnoreCase('General Insurance') || objET.Goal_Name__c.equalsIgnoreCase(Label.Surrender_Insurance)))
       {
       		isInsuracne = true;
       }
       else if(objET.Goal_Name__c != null && (objET.Goal_Name__c.equalsIgnoreCase('Loan') || objET.Goal_Name__c.equalsIgnoreCase('Fixed Deposit') || objET.Goal_Name__c.equalsIgnoreCase('Bond')))
       {
       		isOtherProducts = true;
       }
    }
    
    @isTest(SeeAllData=true)
	public static  void testViewETdetailsController()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Account objAccount = testData.initializeAccount();
	    insert objAccount;
	    
        Approve_Action_Plan__c objAAP1 = testData.init_ApproveActionPlan(objAccount.Id); 
	    insert objAAP1;
	    
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = testData.init_ExecutionTracker(objAccount.id,'Assigned to Operations', Label.Forms_Handed,objAAP1.Id,'Life Insurance','');
       	lstET.add(objET1);
       	Execution_Tracker__c objET2 = testData.init_ExecutionTracker(objAccount.id,'Assigned to Operations', 'Opened' ,objAAP1.Id,'Loan','');
       	lstET.add(objET2);
        insert lstET;
        
	   	ApexPages.StandardController std = new ApexPages.StandardController(objET1);
		ViewETdetailsController objViewETdetailsController = new ViewETdetailsController(std);
		
		ApexPages.StandardController std_1 = new ApexPages.StandardController(objET2);
		ViewETdetailsController objViewETdetailsController_1 = new ViewETdetailsController(std_1);
	}
}