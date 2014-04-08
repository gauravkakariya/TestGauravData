trigger UpdateStatusChangeDate on Lead (before insert, before update) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		for(Lead l : Trigger.new)
			l.Status_Change_Date__c = System.today();
	}
	else if(trigger.isBefore && trigger.isUpdate)
	{
		for(Integer i=0; i < trigger.size; i++)
			if(Trigger.new[i].Status != Trigger.old[i].Status)
				Trigger.new[i].Status_Change_Date__c = System.today();
	}
}