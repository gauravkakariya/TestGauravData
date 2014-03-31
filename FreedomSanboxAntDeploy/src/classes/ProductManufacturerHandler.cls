/*
*   Handler code that is invoked for an ProductManufacturerTrigger.
*
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		17/01/2013		Initial Draft
*
*/

public with sharing class ProductManufacturerHandler 
{
	public void isBeforeInsert(List<Product_Manufacturer_Master__c> lstProduct)
	{
		new productManufacturerDupeCheck().validate(lstProduct);
	}//isBeforeInsert ends
	
	public void isBeforeUpdate(List<Product_Manufacturer_Master__c> lstProduct)
	{
		new productManufacturerDupeCheck().validate(lstProduct);
	}//isBeforeUpdate ends	
}