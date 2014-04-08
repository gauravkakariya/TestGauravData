trigger PurchaseOrderTrigger on Purchase_Order__c (after insert, after update) 
{
	PurchaseOrderHandler objHandler = new PurchaseOrderHandler();
	if(trigger.isAfter && trigger.isInsert)
		objHandler.onAfterInsert(trigger.newMap);		
	
}