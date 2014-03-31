/*
	Revision History:
    Version     Version Author    Date          	Comments
    1.0			Prajakta Sanap	 08/10/2013     1.When status of WorkflowsTrackerDetails changes from "In progress" to "Completed", Task gets created
*/


trigger WorkflowsTrackerDetailsTrigger on Workflows_Tracker_Details__c (after insert, after update)
{
	WorkflowsTrackerDetailsHandler objWorkflowsTrackerDetailsHandler = new WorkflowsTrackerDetailsHandler();
	
	
	
	if (trigger.isAfter && trigger.isUpdate) 
    {
    	system.debug('--------after update---------:');
    	objWorkflowsTrackerDetailsHandler.createTaskOnStatusChange(trigger.new, trigger.oldMap,trigger.newMap);
    	objWorkflowsTrackerDetailsHandler.changeStatusOnTaskCompletion(trigger.new, trigger.oldMap);
    }
    if (trigger.isAfter && trigger.isInsert) 
    {
    	system.debug('--------after insert---------:');
    	//objWorkflowsTrackerDetailsHandler.createTaskOnStatusChange(trigger.new, trigger.newMap);
    }
}