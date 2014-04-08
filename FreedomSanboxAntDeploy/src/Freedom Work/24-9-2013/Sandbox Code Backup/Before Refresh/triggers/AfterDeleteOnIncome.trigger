trigger AfterDeleteOnIncome on Income__c (after delete) 
{
	HandlerForAfterDeleteOnIncome objHandlerIncome = new HandlerForAfterDeleteOnIncome();
	objHandlerIncome.afterDeleteIncome(trigger.old);
}