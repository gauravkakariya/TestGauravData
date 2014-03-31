/* 
*  Test class for Controller class that acts as an extension of Standard Controller Product_Master__c 
*  Contains the logic of editing Data From a EditProducts VF Page
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Prajakta Sanap    04/01/2013      Initial Draft
*/



@isTest
private class Test_EditProductsController 
{
    /* When data i.e. product records are entered and the Save button is clicked the
	 * records should be saved and the user should be navigated to the Product Manufacturer tab
	 */
	public static testMethod void saveProductRecordTest()
    {
		//Product Manufacturer record  is not entered and save button is clicked
	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Master__c());
	 		
	 	EditProductsController productController = new EditProductsController(stdCtrl);
	    // Pass the id of product object 
		String Id = ApexPages.currentPage().getParameters().get('id');
		    				
		test.startTest();      //Begin Test
		productController.saveProduct();
		Pagereference savePage = productController.saveProduct();
		//system.assertEquals(savePage.getUrl(), '/' + Id);
		test.stopTest();      //End Test
    }
    
   
 	/* When the Cancel button is clicked the user should be navigated back to the Product tab 
  	 */
	static testMethod void test_cancelProductRecord()
	{
		Pagereference newAddProduct = Page.EditProducts;
	 	Test.setCurrentPage(newAddProduct);
	 	
	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 	EditProductsController productController = new EditProductsController(stdCtrl);

	 	// Pass the id of product object 
		String Id = ApexPages.currentPage().getParameters().get('id');
	 	
	 	test.startTest();  //Begin Test
	 	Pagereference cancelPage = productController.cancelProduct();
	 	system.assertEquals(cancelPage.getUrl(), '/' + Id);
	 	test.stopTest();    //End Test
	}
    
	/* To check if picklist values are inserted properly. 
  	 */
	static testMethod void test_picklist()
	{
	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 	EditProductsController productController = new EditProductsController(stdCtrl);
	 	
	 	test.startTest();  //Begin Test
		productController.getProductManufacturerName();
	 	//system.assertEquals(Product_Manufacturer__c, 'Birla');
	 	test.stopTest();    //End Test
	}
	
	
	/* When data is product records are entered and the Save button is clicked the
	 * records should display error if record of same product name already exists
     */
    public static testMethod void saveProductRecordErrorTest()
    {
		Pagereference editSaveProducts = Page.EditProducts;
	 	Test.setCurrentPage(editSaveProducts);
		
		// Insert Product Manufacturer record
		Product_Manufacturer_Master__c PM = new Product_Manufacturer_Master__c(Name='Birla1', Short_Code__c='Birla1', Is_Active__c=true);
		insert PM;
		
		List<Product_Master__c> lstProducts = new List<Product_Master__c>();
		
		Product_Master__c PM1 = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=PM.id, 
													  Is_Active__c=false, ProductType__c='Life Insurance', Product_Name__c='Birla life insurance', Currently_Recommended__c='No', 
													  Fees__c=5000,  Current_NAV__c=5, Fees_in_Advance_or_On_Service_Delivery__c=true);
		lstProducts.add(PM1);
		Product_Master__c PM2 = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=PM.id, 
													  Is_Active__c=true, ProductType__c='Life Insurance', Product_Name__c='Birla life insurance new year', Currently_Recommended__c='No', 
													  Fees__c=5000,  Current_NAV__c=5, Fees_in_Advance_or_On_Service_Delivery__c=true);
		lstProducts.add(PM2);
		Product_Master__c PM3 = new Product_Master__c(SIP_Allowed__c='No', Product_Manufacturer__c=PM.id, 
													  Is_Active__c=true, ProductType__c='Life Insurance', Product_Name__c='Kotak Mahindra', Currently_Recommended__c='No', 
													  Fees__c=5000,  Current_NAV__c=5, Fees_in_Advance_or_On_Service_Delivery__c=true);
		lstProducts.add(PM3);
		insert lstProducts; 
		
		ApexPages.currentPage().getParameters().put('id',lstProducts[0].id);

	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 		
	 	EditProductsController productController = new EditProductsController(stdCtrl);
	 	Pagereference savePage = productController.saveProduct();
	 	
	 	List<Apexpages.Message> pageMsgList = Apexpages.getMessages();
	 	
	 	productController.lstProductMaster[1].Product_Name__c='Birla life insurance';
	 	productController.saveProduct();

        test.startTest();			//Begin test
        //system.assertEquals(savePage.getUrl(), 
	 	//	'/' + Product_Manufacturer_Master__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
        //system.assert(savePage == NULL);
        test.stopTest();			//End test
    }
	
}