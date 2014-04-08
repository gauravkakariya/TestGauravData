/*
*   Helper code that is invoked for an ProductMasterHandler classes. 
*   Dupes are checked for a given Product Name, Product Type and  
*   Product Manufacturer Name should be same as there should exist only one 
*   record at a time.
*   
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		15/01/2013		Initial Draft
*
*/

public with sharing class DupeCheckProducts 
{
	/* Function to check duplicates for the records to be inserted */
	public void validate(List<Product_Master__c> lstNewPriceBook)
	{
		/* To define Uniqueness
	        CustomUniqueKey__c = mark as Unique (79)     
	    */
	    for(Product_Master__c objProd  : lstNewPriceBook)
	    {
	        objProd.CustomUniqueKey__c = objProd.Product_Name__c + objProd.ProductType__c + objProd.Product_Manufacturer__c;  
	    }
	}
}