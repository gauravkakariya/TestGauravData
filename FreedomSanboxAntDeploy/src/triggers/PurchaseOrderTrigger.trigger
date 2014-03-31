trigger PurchaseOrderTrigger on Purchase_Order__c (after insert, after update, after delete) 
{
	PurchaseOrderHandler objHandler = new PurchaseOrderHandler();
	if(trigger.isAfter && trigger.isInsert){
		objHandler.onAfterInsert(trigger.newMap);	
		objHandler.onAfterInsertUpdatePurchaseOrder(trigger.newMap);	
	}
	if(trigger.isAfter && trigger.isUpdate){
		
		objHandler.onAfterInsertUpdatePurchaseOrder(trigger.newMap);	
	}			
	if(trigger.isAfter && trigger.isDelete){
		
		objHandler.onAfterDeletePurchaseOrder(trigger.oldMap);	
	}
}