/*
*   Helper code that is invoked for an ProductRecommendationHandler classes. 
*   Dupes are checked for a given Product Recommendation Start Date and  
*   Recommendation Start Date and Statos should be same as there should exist only one 
*   record at a time.
*   
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		16/01/2013		Initial Draft
*
*/


public with sharing class DupeCheckRecommendation 
{
    /* Function to check duplicates for the records to be inserted */
	public void validate(List<Product_Recommendation_Master__c> lstProductRec)
	{
		/* To define Uniqueness
         * CustomUniqueKey__c = mark as Unique (50)     
         */
		for(Product_Recommendation_Master__c objProd  : lstProductRec)
		{
	        objProd.CustomUniqueKey__c = objProd.Product_Code__c +
	        							 String.valueOf(objProd.Recommendation_Start_date__c) + 
	        							 String.valueOf(objProd.Recommendation_End_date__c);
	    }
	}
}