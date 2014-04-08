/*
*   Helper code that is invoked for an ProductManufacturerHandler classes. 
*   Dupes are checked for a given Product Manufacturer Name and Short Code 
*   should  not be same as there should exist only one 
*   record at a time.
*   
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		17/01/2013		Initial Draft
*
*/

public with sharing class productManufacturerDupeCheck 
{
	 /* Function to check duplicates for the records to be inserted */
	public void validate(List<Product_Manufacturer_Master__c> lstProduct)
	{
		/* To define Uniqueness
         * CustomUniqueKey__c = mark as Unique (150)     
         */
		for(Product_Manufacturer_Master__c objProd  : lstProduct)
		{
	        objProd.CustomUniqueKey__c = objProd.Name + objProd.Short_Code__c;
	    }
	}
}