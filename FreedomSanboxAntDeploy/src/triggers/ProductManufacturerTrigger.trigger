/*
*   Trigger that executes when any DML operations are performed on the standard Product Manufacturer object.
*
*   Revision History:
*
*	Version		   Author				Date			Description
*	1.0			Prajakta Sanap		 17/01/2013		   Initial Draft
*
*/

trigger ProductManufacturerTrigger on Product_Manufacturer_Master__c (before insert, before update) 
{
	ProductManufacturerHandler handler = new ProductManufacturerHandler();
	
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