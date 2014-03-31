trigger TaskTrigger on Task (after update,before update) 
{
	TaskHandler objTaskHandler = new TaskHandler();
	
	if(trigger.isBefore && trigger.isUpdate){
		system.debug('test');
		objTaskHandler.onBeforeUpdatePopulateCompletionDate(trigger.oldMap,trigger.newMap);
	} 
	
	if(trigger.isAfter && trigger.isUpdate)
	{
		//objTaskHandler.onAfterUpdateToWFlowTrackerDetails(trigger.oldMap, trigger.newMap);
		objTaskHandler.onAfterUpdateTaskToUpdateAccount(trigger.oldMap, trigger.newMap);
	}	
	
	
}