/*	
*   Test class for Helper code that is invoked for an ProductRecommendationHandler classes. 
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

@isTest
private class DupeCheckRecommendationTest 
{
    /* Test Method to check whether Product Recommendation record is inserted is already present
     * and if yes then shows error message
	 */
    static testMethod void isValidateInsertErrorTest() 
    {
    	// Insert Product manufacturer record 
		Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Birla11', Short_Code__c='Birla11', Is_Active__c=true);
		insert PM1;
		
		Product_Master__c objProdRec = new Product_Master__c
										   (SIP_Allowed__c = 'Yes', 
										   Product_Manufacturer__c = PM1.Id, 
										   Is_Active__c = false, 
										   ProductType__c = 'Life Insurance1', 
										   Product_Name__c = 'Birla sun life insurance1', 
										   Currently_Recommended__c = 'No',
										   Fees_in_Advance_or_On_Service_Delivery__c = true);
			
		insert objProdRec;
		
		Product_Recommendation_Master__c objPRM = new Product_Recommendation_Master__c
												(Product_code__c = objProdRec.id, 
												 Recommendation_Start_date__c = system.today(), 
												 Recommendation_End_date__c = system.today() + 3);
		
    	insert objPRM;
    }
    
   
}