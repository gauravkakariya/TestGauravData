/*
*   Trigger that executes when any DML operations are performed on the standard Product Recommendation object.
*
*   Revision History:
*
*	Version		   Author				Date			Description
*	1.0			Prajakta Sanap		 16/01/2013		   Initial Draft
*
*/

trigger ProductRecommendationTrigger on Product_Recommendation_Master__c (before insert, before update) 
{
	ProductRecommendationHandler handler = new ProductRecommendationHandler();
	
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