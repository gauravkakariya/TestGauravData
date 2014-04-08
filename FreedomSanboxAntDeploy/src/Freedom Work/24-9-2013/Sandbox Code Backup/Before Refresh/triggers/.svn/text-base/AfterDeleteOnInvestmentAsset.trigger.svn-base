trigger AfterDeleteOnInvestmentAsset on Investment_Asset__c (after delete) 
{
	HandlerForAfterDeleteOnInvestmentAsset objHandlerInvestment = new HandlerForAfterDeleteOnInvestmentAsset();
	objHandlerInvestment.afterDeleteInvestment(trigger.old);
}