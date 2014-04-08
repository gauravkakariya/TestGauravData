trigger TaskTrigger on Task (after update) 
{
	TaskHandler objTaskHandler = new TaskHandler();
	
	if(trigger.isAfter && trigger.isUpdate)
		objTaskHandler.onAfterUpdateToCreateNotificaitonQueue(trigger.oldMap, trigger.newMap);
}