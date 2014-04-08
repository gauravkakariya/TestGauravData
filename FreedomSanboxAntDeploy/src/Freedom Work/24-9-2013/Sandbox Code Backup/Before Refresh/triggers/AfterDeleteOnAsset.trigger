trigger AfterDeleteOnAsset on Asset__c (after delete) 
{
	HandlerForAfterDeleteOnAsset objHandlerAsset = new HandlerForAfterDeleteOnAsset();
	objHandlerAsset.afterDeleteAsset(trigger.old);
}