trigger InsertUpdateDeleteOnTask on Task (after insert, before delete, after Update)
{
    system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDDTrigger.new:'+Trigger.new);
    
    if(!InsertUpdateDeleteOnTaskHelperClass.hasAlreadyCreatedFollowUpTasks())
    {
        if(Trigger.isAfter && Trigger.isInsert)
        {
            system.debug('dxxxxxxxxxxxxxxx InsertTrigger.new:'+Trigger.new);
            InsertUpdateDeleteOnTaskHelperClass.insertDuplicateTask(Trigger.new);
        }
    }
    if(!InsertUpdateDeleteOnTaskHelperClass.hasAlreadyUpdatedFollowUpTasks())
    {
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            InsertUpdateDeleteOnTaskHelperClass.UpdateDuplicateTask(Trigger.new);
        }
    }
    system.debug('Trigger.isBefore====>'+Trigger.isBefore+'ZZZZZZZZZZZ=Trigger.isDelete==>'+Trigger.isDelete);
    if(!InsertUpdateDeleteOnTaskHelperClass.hasAlreadyDeletedFollowUpTasks())
    {
        if(Trigger.isBefore && Trigger.isDelete)
        {
            InsertUpdateDeleteOnTaskHelperClass.DeleteDuplicateTask(Trigger.oldMap);
        }
    }
}