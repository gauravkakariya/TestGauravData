trigger InsertUpdateDeleteOnEvent on Event (after insert, after update, before delete) 
{
	if(!InsertUpdateDeleteOnEventHelperClass.hasAlreadyCreatedFollowUpEvents())
	{
		if(Trigger.isAfter && Trigger.isInsert)
		{
			InsertUpdateDeleteOnEventHelperClass.insertDuplicateEvent(Trigger.new);
		}
	}
	if(!InsertUpdateDeleteOnEventHelperClass.hasAlreadyUpdatedFollowUpEvents())
	{
		if(Trigger.isAfter && Trigger.isUpdate)
		{
			InsertUpdateDeleteOnEventHelperClass.UpdateDuplicateEvent(Trigger.new);
		}
	}
	system.debug('Trigger.isBefore====>'+Trigger.isBefore+'ZZZZZZZZZZZ=Trigger.isDelete==>'+Trigger.isDelete);
	if(!InsertUpdateDeleteOnEventHelperClass.hasAlreadyDeletedFollowUpEvents())
	{
		if(Trigger.isBefore && Trigger.isDelete)
		{
			InsertUpdateDeleteOnEventHelperClass.DeleteDuplicateEvent(Trigger.oldMap);
		}
	}
}