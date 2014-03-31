/*
*   Handler code that is invoked for an PriceBookTrigger.
*
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		08/01/2013		Initial Draft
*
*/

public with sharing class PriceBookHandler 
{
	public void isBeforeInsert(List<Product_Price_Book__c> lstNewPriceBook)
	{
		List<Product_Price_Book__c> lst = ValidateActivePriceBook.duplicateCheck(lstNewPriceBook);
		new ValidateActivePriceBook().validate(lst);
	}//isBeforeInsert ends
	
	public void isBeforeUpdate(List<Product_Price_Book__c> lstNewPriceBook)
	{
		List<Product_Price_Book__c> lst = ValidateActivePriceBook.duplicateCheck(lstNewPriceBook);
		new ValidateActivePriceBook().isValidatePricebook(lst);
	}//isBeforeUpdate ends	
}//PriceBookTrigger ends