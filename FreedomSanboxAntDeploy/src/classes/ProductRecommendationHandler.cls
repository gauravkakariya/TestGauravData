/*
*   Handler code that is invoked for an ProductRecommendationTrigger.
*
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		16/01/2013		Initial Draft
*
*/

public with sharing class ProductRecommendationHandler 
{
	public void isBeforeInsert(List<Product_Recommendation_Master__c> lstProductRec)
	{
		new DupeCheckRecommendation().validate(lstProductRec);
		//new DupeCheckRecommendation().validateDates(lstProductRec);
	}//isBeforeInsert ends
	
	public void isBeforeUpdate(List<Product_Recommendation_Master__c> lstProductRec)
	{
		new DupeCheckRecommendation().validate(lstProductRec);
	}//isBeforeUpdate ends	
}