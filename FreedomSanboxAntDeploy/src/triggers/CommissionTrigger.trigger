trigger CommissionTrigger on Commission__c (before insert, before update, after insert , after update) 
{
	CommissionHandler handler = new CommissionHandler();
	
	if(trigger.isBefore && trigger.isInsert)
	{
		handler.onBeforeInsert(trigger.new);
	}
	else if(trigger.isBefore && trigger.isUpdate)
	{
		handler.onBeforeUpdate(trigger.oldMap,trigger.new); 
	}
	if(trigger.isAfter && trigger.isInsert)
	{
		handler.onAfterInsert(trigger.new); 
	}
	if(trigger.isAfter && trigger.isUpdate)
	{
		handler.onAfterInsert(trigger.new); 
	}
}