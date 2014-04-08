/*
*   Handler code that is invoked for an ProductMasterTrigger.
*
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		15/01/2013		Initial Draft
*
*/

public with sharing class ProductMasterHandler 
{
	public void isBeforeInsert(List<Product_Master__c> lstNewPriceBook)
	{
		new ProductsDupeCheck().validate(lstNewPriceBook);
	}//isBeforeInsert ends
	
	public void isBeforeUpdate(List<Product_Master__c> lstNewPriceBook)
	{
		new ProductsDupeCheck().validate(lstNewPriceBook);
	}//isBeforeUpdate ends	
}