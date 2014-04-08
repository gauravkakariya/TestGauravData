trigger AddParentForGoal on Goal__c (before insert,before update) 
{
    system.debug('------------------------------------------------------------------ trigger fired');
    HandlerForParentForGoal OBJgoal = new HandlerForParentForGoal();
    if(trigger.isInsert)
    {
        OBJgoal.beforeGoalInsert(Trigger.new);
    }
    if(trigger.isUpdate)
    {
        OBJgoal.beforeUpdateGoal(trigger.new,trigger.old);
    }
}