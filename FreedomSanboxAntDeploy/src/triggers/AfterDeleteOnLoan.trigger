trigger AfterDeleteOnLoan on Loan__c (after delete) 
{
	HandlerForAfterDeleteOnLoan objHandlerLoan = new HandlerForAfterDeleteOnLoan();
	objHandlerLoan.afterDeleteLoan(trigger.old);
}