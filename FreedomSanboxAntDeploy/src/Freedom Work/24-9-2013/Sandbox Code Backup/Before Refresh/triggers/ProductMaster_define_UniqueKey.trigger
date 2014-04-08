/*
*   Trigger that executes when any DML operations are performed on the standard PriceBook object.
*
*   Revision History:
*
*	Version		   Author				Date			Description
*	1.0			Prajakta Sanap		 15/01/2013		   Initial Draft
*
*/

trigger ProductMaster_define_UniqueKey on Product_Master__c (before insert, before update) 
{
    ProductMasterHandler handler = new ProductMasterHandler();
	
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
}