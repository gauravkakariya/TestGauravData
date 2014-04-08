trigger OrderDetailTrigger on Order_Detail__c (after insert) 
{
    OrderDetailHandler objHandler = new OrderDetailHandler();
    objHandler.onAfterInsert(trigger.newMap);
}