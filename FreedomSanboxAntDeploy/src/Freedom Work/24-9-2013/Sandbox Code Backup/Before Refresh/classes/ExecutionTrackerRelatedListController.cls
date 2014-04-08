public with sharing class ExecutionTrackerRelatedListController 
{
	 private DatabaseSOQL dbSOQLObj {get; set;}
	 public Id entityId {get;set;}
	 public List<Execution_Tracker__c> lstET {get;set;}
	 public Id rejectedTrackerId {get;set;}
	 
	 public ExecutionTrackerRelatedListController(ApexPages.StandardController controller)
     {
     	entityId = controller.getId();
     	dbSOQLObj = new DatabaseSOQL();
     	Set<Id> familyIdSet = new Set<Id>(); 
    	List<Account> lstAcc = dbSOQLObj.getFamilyMembers(entityId);
     
   	 	for(Account objAcc : lstAcc)
    	{
      		familyIdSet.add(objAcc.Id);
    	}
    	
     	lstET = [Select Id,Goal_Name__c, Agreed_Amount_Base_Amount__c,Suggested_Amount__c, Scheme_Name_Policy_Name__c, Owner__r.Name, Executed_Amount__c, ET_Status__c, 
     				Balance_Remaining__c, Executed_Product_Name__c,Agreed_Amount__c,Application_Status__c,Actual_Action_Amount__c  
     				From Execution_Tracker__c 
     				where Entity_Name__c IN: familyIdSet and (Application_Status__c = 'Rejected' or Application_Status__c = 'Closed')];
     	
     }
     public pagereference ViewRecords()
	 {
	 	pageReference pageRef = new pageReference('/'+rejectedTrackerId);
        return pageRef;
	 }
}