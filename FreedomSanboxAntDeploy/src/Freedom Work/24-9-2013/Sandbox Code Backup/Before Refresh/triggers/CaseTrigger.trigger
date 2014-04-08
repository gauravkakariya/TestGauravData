trigger CaseTrigger on Case (before insert, after insert) 
{
	CaseTriggerHandler handler = new CaseTriggerHandler();
	if(Trigger.isBefore)
	{
		//updatating Assigned Owner Manager Id of Assinged user @Case internal Record Type@:Setty 26/10/2012
		handler.onBeforeInsert(Trigger.new);
	}
	if(Trigger.isAfter)
	{
		//Sharing Record To Assigned user @Case internal Record Type@:Setty 26/10/2012
		handler.onAfterInsert(Trigger.new);
	}
}