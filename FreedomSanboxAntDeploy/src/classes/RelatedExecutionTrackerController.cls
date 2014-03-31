/* 
    Version     Version Author     Date          Comments
    1.0         Aditi         28/04/2013     Display Closed and Rejected ET records on Entity detail page
*/
public class RelatedExecutionTrackerController 
{
	public List<Execution_Tracker__c> lstExecutionTracker {get;set;}
	private String strApproveActionPlanId;
	private String strType;
	public Boolean displayInsuranceFields {get;set;}
	public Boolean displayOtherProductsFields {get;set;}
	
	public RelatedExecutionTrackerController()
	{
		displayInsuranceFields = false;
		displayOtherProductsFields = false;	
		strApproveActionPlanId = Apexpages.currentPage().getParameters().get('apid');
		strType = Apexpages.currentPage().getParameters().get('type');
		Execution_Tracker__c objET = new Execution_Tracker__c();
		system.debug('***strType****'+strType);
		
		/*if(strType == 'Lumpsum' || strType == 'SIP')
			objET = [Select Id from Execution_Tracker__c where ParentExecutionTracker__c = null and Approve_Action_Plan__c =:strApproveActionPlanId
			      	  					and Type__c =: strType limit 1];
		else 
			objET = [Select Id from Execution_Tracker__c where ParentExecutionTracker__c = null and Approve_Action_Plan__c =:strApproveActionPlanId];
			 system.debug('***objET****'+objET);*/
			
		lstExecutionTracker = [Select Id,Name,CreatedDate, Executed_Product_Name__c, Agreed_Amount_Base_Amount__c,Balance_Remaining__c,Total_Remaining_Balance__c,
								Agreed_Amount__c,Type__c,Actual_Action_Amount__c,ET_Status__c, Owner__c,
								Suggested_Amount__c, Executed_Amount__c, Application_Status__c,Sum_Assured__c 
								from Execution_Tracker__c where Approve_Action_Plan__c =:strApproveActionPlanId and Type__c =: strType
								//and (ParentExecutionTracker__c =: objET.Id 
								//OR Id =: objET.Id) 
								order by CreatedDate];
	   
	    system.debug('-lstExecutionTracker--'+lstExecutionTracker);
	    if(strType == Label.Surrender_Insurance)
	    	displayInsuranceFields = true;
	    if(strType == 'Loan' || strType == 'Fixed Deposit' || strType == 'Bond')
	    	displayOtherProductsFields = true;	
		/*if(strType == 'Lumpsum' || strType == 'SIP')
			objET = [Select Id from Execution_Tracker__c where ParentExecutionTracker__c = null and Approve_Action_Plan__c =:strApproveActionPlanId
			      	  					and Type__c =: strType limit 1];
		else 
			objET = [Select Id from Execution_Tracker__c where ParentExecutionTracker__c = null and Approve_Action_Plan__c =:strApproveActionPlanId];
			      	  					
			      	  					 
		lstExecutionTracker = [Select Name, Executed_Product_Name__c, Agreed_Amount_Base_Amount__c,Balance_Remaining__c,Agreed_Amount__c,Type__c,Actual_Action_Amount__c,
								Suggested_Amount__c, Executed_Amount__c, Application_Status__c,Sum_Assured__c,
								ET_Status__c, Owner__c from Execution_Tracker__c where 	ParentExecutionTracker__c =: objET.Id 
								OR Id =: objET.Id order by createdDate];*/
	}
}