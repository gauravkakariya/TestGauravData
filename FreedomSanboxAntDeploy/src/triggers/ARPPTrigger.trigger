trigger ARPPTrigger on ARPP_Detail__c (after delete, after insert, after update) 
{
    ARPPHandler handler = new ARPPHandler();
    
    if(trigger.isAfter && trigger.isInsert)
    {
        handler.onAfterInsertUpdateDeteteCalculateRevenueSum(trigger.newMap);
    }
    else if(trigger.isAfter && trigger.isUpdate)
    {
        handler.onAfterInsertUpdateDeteteCalculateRevenueSum(trigger.newMap); 
    }
    else if(trigger.isAfter && trigger.isDelete)
    {
        handler.onAfterInsertUpdateDeteteCalculateRevenueSum(trigger.OldMap); 
    }
}