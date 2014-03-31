/*	
*   Test class for Helper code that is invoked for an ProductMasterHandler classes. 
*
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		17/01/2013		Initial Draft
*
*/


@isTest
public class ProductsDupeCheckTest 
{

     /* Test Method to check whether Product Master record is inserted properly
	 */
    public static testMethod void isValidateInsertPositiveTest() 
    {
		// Insert Product manufacturer record 
		Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Birla1', Short_Code__c='Birla1', Is_Active__c=true);
		insert PM1;
		
		Product_Master__c objProdRec = new Product_Master__c
										   (SIP_Allowed__c = 'Yes', 
										   Product_Manufacturer__c = PM1.Id, 
										   Is_Active__c = false, 
										   ProductType__c = 'Life Insurance', 
										   Product_Name__c = 'Birla sun life insurance', 
										   Currently_Recommended__c = 'No',
										   Fees_in_Advance_or_On_Service_Delivery__c = true);
			
		insert objProdRec;
		
		objProdRec.Is_Active__c = false;
		
		update objProdRec;
    }
	
}