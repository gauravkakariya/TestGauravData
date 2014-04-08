/* 
*  Test class for Controller class that acts as an extension of Standard Controller Product_Manufacturer_Master__c 
*  Contains the logic of inserting Data From a AddProductManufacturers VF Page
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Prajakta Sanap    02/01/3013      Initial Draft
*/

@isTest
private class Test_AddProductManufacturersController 
{
	
	/* When the page is initally loaded the page opens ups with 3 rows in the Product 
	 * Manufacturer table 
	 */
    public static testMethod void productManufacturersInitialPageLoadTest()
    {
    	//Create an instance of the AddProductManufacturers controller
        AddProductManufacturersController addPrdMfrController = 
        	new AddProductManufacturersController(
        		new ApexPages.StandardController(new Product_Manufacturer_Master__c()));
        	
        //Set the current page reference to the AddProductManufacturers page
        Test.setCurrentPageReference(Page.AddProductManufacturers);
        
        test.startTest();			//Begin test
        //System.assertEquals(addPrdMfrController.lstProductManufacturer.size(), 3);
        test.stopTest();			//End test
    }
    
    
    /* When data is product manufacturer records are entered and the Save button is clicked the
	 * records should be saved
     */
	public static testMethod void saveProductManufacturersRecordTest()
    {
		Pagereference addSaveProductManufacturers = Page.AddProductManufacturers;
	 	Test.setCurrentPage(addSaveProductManufacturers);
		
		//Product Manufacturer record  is not entered and save button is clicked
	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Manufacturer_Master__c());
	 		
	 	AddProductManufacturersController productMfrController = new AddProductManufacturersController(stdCtrl);
	    
	    // Insert Product Manufacturer record
		Product_Manufacturer_Master__c objProductRecord = new Product_Manufacturer_Master__c();
		objProductRecord = createProductManfRecord();
		//insert objProductRecord;
	    Product_Manufacturer_Master__c objProductRecord1 = new Product_Manufacturer_Master__c();
		objProductRecord1 = createProductManfRecord();
	    objProductRecord1.Name = 'AMC';
	    
		test.startTest();      //Begin Test
		
		AddProductManufacturersController.ProductManufacturer PM = new AddProductManufacturersController.ProductManufacturer(objProductRecord);
		productMfrController.lstProductManufacturer.add(PM);
		AddProductManufacturersController.ProductManufacturer PM1 = new AddProductManufacturersController.ProductManufacturer(objProductRecord1);
		productMfrController.lstProductManufacturer.add(PM1);
		
		productMfrController.saveProductManufacturer();
		
		//system.assert(productMfrController.objProductRecord.Name=='HDFC Life Insurance' && productMfrController.objProductRecord.Short_Code__c=='HDFC');
		
		test.stopTest();      //End Test
    }
        
    
    
    /* When data is product manufacturer records are entered and the Save button is clicked the
	 * records should be saved and the user should be navigated to the Product Manufacturer tab
     */
    public static testMethod void saveProductManufacturersRecordErrorTest()
    {
		Pagereference addSaveProductManufacturers = Page.AddProductManufacturers;
	 	Test.setCurrentPage(addSaveProductManufacturers);
		
		// Insert Product Manufacturer record list
		List<Product_Manufacturer_Master__c> productRecord = new List<Product_Manufacturer_Master__c>();
		
		Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='Birla', Short_Code__c='Birla', Is_Active__c=true);
		productRecord.add(PM1);
		Product_Manufacturer_Master__c PM2 = new Product_Manufacturer_Master__c(Name='HDFC', Short_Code__c='HDFC', Is_Active__c=false);
		productRecord.add(PM2);
		Product_Manufacturer_Master__c PM3 = new Product_Manufacturer_Master__c(Name='AMC', Short_Code__c='amc', Is_Active__c=false);
		productRecord.add(PM3);
		
		insert productRecord;

		ApexPages.currentPage().getParameters().put('id',productRecord[0].id);

	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Manufacturer_Master__c());
	 		
	 	AddProductManufacturersController productMfrController = new AddProductManufacturersController(stdCtrl);
	 	Pagereference savePage = productMfrController.saveProductManufacturer();
	 	
	 	List<Apexpages.Message> pageMsgList = Apexpages.getMessages();
	 	
	 	for(Product_Manufacturer_Master__c objPM : productRecord)
	 	{
	 		objPM.Name = 'Birla';
	 	}
	 	
	 	productMfrController.saveProductManufacturer();

        test.startTest();			//Begin test
        //system.assert(savePage == NULL);
        test.stopTest();			//End test
    }
    
    
     /* When the Cancel button is clicked the user shoudd be navigated back to the Product 
	  * Manufacturer tab 
	  */
	static testMethod void test_cancelProductManufacturerRecord()
	{
		Pagereference newAddProductManufacturers = Page.AddProductManufacturers;
	 	Test.setCurrentPage(newAddProductManufacturers);
	 	
	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Manufacturer_Master__c());
	 		
	 	AddProductManufacturersController productMfrController = new AddProductManufacturersController(stdCtrl);
	 	Pagereference cancelPage = productMfrController.cancelProductManufacturer();
	 	
	 	test.startTest();  //Begin Test
	 	//system.assertEquals(cancelPage.getUrl(), 
	 		//'/' + Product_Manufacturer_Master__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
	 	test.stopTest();    //End Test
	}
    
	
    /* When rows are added to the table and check box is selected to remove rows 
     */ 
    static testMethod void removeProductManufacturersRecordTest()
    {
		ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Manufacturer_Master__c());
		AddProductManufacturersController productMfrController = new AddProductManufacturersController(stdCtrl);
		
		test.startTest();   // start test
		//Remove the first record
		productMfrController.lstProductManufacturer[0].isRemove = true;
		productMfrController.lstProductManufacturer[1].isRemove = false;
		productMfrController.removeRows();
		productMfrController.saveProductManufacturer();
		
		// Check Whether there are 3 Product Manufacturer records
		//system.assert(productMfrController.lstProductManufacturer.size() == 3);
		
		test.stopTest();      //End Test
	}
    
    
    //Public Methods
	/* Populate and return a new instance of Product_Manufacturer_Master__c record */
	public static Product_Manufacturer_Master__c createProductManfRecord()
	{
		return new Product_Manufacturer_Master__c(Name = 'HDFC Life Insurance', 
												  Short_Code__c = 'HDFC',
												  Is_Active__c=true);
	}
    
    
    //Test Data Creation Methods
    //Populates and returns a list of Product Manufacturer records which are used as test data
    public static List<Product_Manufacturer_Master__c> createPrdMfrRecords(Integer pNoOfRecords)
    {
    	String productMfrName = 'Product Manufacturer';
    	String productMfrShortCode = 'PMR';
    	List<Product_Manufacturer_Master__c> productMfrList = 
    		new List<Product_Manufacturer_Master__c>();
    	
    	//Populate a list of Product Manufacturers
    	for(Integer index = 1; index <= pNoOfRecords; index++)
    	{
    		productMfrList.add(new Product_Manufacturer_Master__c(
								    				Name = productMfrName + index, 
								    				Short_Code__c = productMfrShortCode + 1, 
								    				Is_Active__c=true));
    			
    	}//for
    	
    	return productMfrList;
    }
    
}//Test_AddProductManufacturersController