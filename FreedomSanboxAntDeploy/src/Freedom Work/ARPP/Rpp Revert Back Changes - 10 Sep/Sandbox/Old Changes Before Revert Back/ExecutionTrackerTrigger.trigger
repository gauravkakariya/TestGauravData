/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Anupam/Aditi       28/12/12      Executon Tracker Trigger.
*/

trigger ExecutionTrackerTrigger on Execution_Tracker__c (before insert, after insert, before update, after update, before delete) 
{
    ExecutionTrackerHandler handler = new ExecutionTrackerHandler();
    ARPPCalculationHandler objARPPCalculationHandler = new ARPPCalculationHandler(); 
    Handle_Update_Trigger__c objHandleUpdateCustomSetting = Handle_Update_Trigger__c.getInstance('ARPP Calculation');       
    Boolean isExecute; 
    if(!Test.isRunningTest()) 
        isExecute = objHandleUpdateCustomSetting.Is_Execute__c; 
    else
        isExecute = true;
    
    /* Prajakta - 9-6-2013 */    
    StaticMethodClass.isAccountUpsertFired = false;
    //Commented on : 11/02/2013 : As per Jigar and Samir discussion with client : no need to send task,
    //Email and chatter notification is enough
    /*if(trigger.isInsert)
    {
        handler.onAfterInsert(trigger.new);
    }
    if((trigger.isAfter && trigger.isUpdate) || Test.isRunningTest()) 
    {
        if(!Test.isRunningTest())
            handler.onAfterUpdate(trigger.new, trigger.old); 
    }*/
    if(trigger.isBefore && trigger.isInsert)
    { 
        if(!Test.isRunningTest() && isExecute)
            objARPPCalculationHandler.onBeforeInsertForAddProductWithET(trigger.new);
    }
    if((trigger.isBefore && trigger.isUpdate) || Test.isRunningTest()) 
    {
        if(!Test.isRunningTest())
            handler.onBeforeUpdate(Trigger.new, trigger.old);
    }
    if(trigger.isAfter && trigger.isInsert ) 
    {
        new CreateRenewal_OnExecutionTrackerInsUp (trigger.old,trigger.new).execute();
        //if(!Test.isRunningTest() && isExecute)
            objARPPCalculationHandler.onAfterInsertAndUpdateForARPPCalculation(trigger.newMap, trigger.oldMap);
    }
    if(trigger.isAfter && trigger.isUpdate) 
    {
        new CreateRenewal_OnExecutionTrackerInsUp (trigger.old,trigger.new).execute();
        //if(!Test.isRunningTest()  && isExecute)
            objARPPCalculationHandler.onAfterInsertAndUpdateForARPPCalculation(trigger.newMap, trigger.oldMap);
    }
    if(trigger.isBefore && trigger.isDelete) 
    {
        if(!Test.isRunningTest()  && isExecute)
            objARPPCalculationHandler.onBeforeDeleteForARPPCalculation(trigger.oldMap);
    }
}