trigger ActionPlanTrigger on Approve_Action_Plan__c (after insert, after update, before delete) 
{
    ARPPCalculationHandler handler = new ARPPCalculationHandler();    
    if((trigger.isAfter && trigger.isInsert))
    {
        handler.onAfterInsertForARPPCalculation(trigger.newMap, trigger.oldMap);
        if(!Test.isRunningTest())
            handler.onAfterInsertForARPPWithRunningSIPandLumpsum(trigger.newMap);
    }
    
    //else if(trigger.isAfter && trigger.isUpdate && ARPPCalculationHandler.isRecursive == false)
    //    handler.onAfterInsertForARPPCalculation(trigger.newMap, trigger.oldMap);
    
    if(trigger.isBefore && trigger.isDelete)
        handler.onBeforeDeleteForARPPCalculation(trigger.oldMap);
}