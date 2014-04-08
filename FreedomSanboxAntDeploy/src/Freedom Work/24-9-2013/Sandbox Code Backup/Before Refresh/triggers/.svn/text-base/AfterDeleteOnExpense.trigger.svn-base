trigger AfterDeleteOnExpense on Expense__c (after delete) 
{
	HandlerForAfterDeleteOnExpense objHandlerExpense = new HandlerForAfterDeleteOnExpense();
	objHandlerExpense.afterDeleteExpense(trigger.old);
}