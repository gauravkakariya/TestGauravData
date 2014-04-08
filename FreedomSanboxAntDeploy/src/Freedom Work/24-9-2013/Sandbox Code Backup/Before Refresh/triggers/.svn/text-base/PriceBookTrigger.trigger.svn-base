/*
*   Trigger that executes when any DML operations are performed on the standard PriceBook object.
*
*   Revision History:
*
*	Version		   Author				Date			Description
*	1.0			Prajakta Sanap		 08/01/2013		   Initial Draft
*
*/

trigger PriceBookTrigger on Product_Price_Book__c (before insert, before update) 
{
	PriceBookHandler handler = new PriceBookHandler();
	
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
		{
			handler.isBeforeInsert(Trigger.new);
		}
		if(Trigger.isUpdate)
		{
			handler.isBeforeUpdate(Trigger.new);
		}
	}
}//PriceBookTrigger ends