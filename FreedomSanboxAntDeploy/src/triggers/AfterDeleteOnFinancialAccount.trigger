trigger AfterDeleteOnFinancialAccount on Financial_Account__c (after delete) 
{
	HandlerForAfterDeleteOnFinancialAccount objHandlerFinancialAccount = new HandlerForAfterDeleteOnFinancialAccount();
	objHandlerFinancialAccount.afterDeleteFinancialAccount(trigger.old);
}