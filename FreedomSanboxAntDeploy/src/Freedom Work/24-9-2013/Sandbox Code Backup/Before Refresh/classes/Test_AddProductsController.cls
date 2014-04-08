/* 
*  Test class for Controller class that acts as an extension of Standard Controller Product_Master__c 
*  Contains the logic of inserting Data From a AddProducts VF Page
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Prajakta Sanap    02/01/2013      Initial Draft
*/

@isTest(SeeAllData = true)
private class Test_AddProductsController 
{
	/* When the page is initally loaded the page opens ups with 3 rows in the Product 
	 * Manufacturer table 
	 */ 
    static Map<String, Id> mapProductRecordToId  = new Map<String, Id>();
    
    public static void init()
    {
    	for(RecordType objRT : [Select Name, Id From RecordType Where SObjectType = 'Product_Master__c'])
    	{
    		mapProductRecordToId.put(objRT.Name, objRT.Id);
    	}
    }
    
    public static testMethod void testAddProductController()
    {
    	init();
    	//Create an instance of the AddProducts controller
    	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Ffreedom Product Services'));
    	AddProductsController productController = new AddProductsController(new ApexPages.StandardController(new Product_Master__c()));
        
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance', Short_Code__c='HDFCLI', Is_Active__c=true);
		insert PM1;
		
        productController.objProductMaster.Base_Product_Weightage__c = 10;
        productController.objProductMaster.Is_Active__c = true;
        productController.objProductMaster.Product_Manufacturer__c = PM1.Id;
        productController.objProductMaster.Subscription_Period_In_Days__c = 365;
        productController.objProductMaster.Renewal_Grace_Days__c = 20;
        productController.objProductMaster.Renewal_Period_In_Days__c = 10;
        productController.objProductMaster.Product_Name__c ='Risk1';
        productController.saveProduct();  
        
       Test.setCurrentPageReference(Page.AddProducts);
         	
        	
        ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Value Added Services'));
    	 AddProductsController productController1 = new AddProductsController
        	(new ApexPages.StandardController(new Product_Master__c()));
        
        productController1.objProductMasterForValueAddedServices.Product_Manufacturer__c = PM1.Id;
        productController1.objProductMasterForValueAddedServices.Subscription_Period_In_Days__c = 365;
        productController1.objProductMasterForValueAddedServices.Renewal_Grace_Days__c = 20;
        productController1.objProductMasterForValueAddedServices.Renewal_Period_In_Days__c = 10;
        productController1.objProductMasterForValueAddedServices.Product_Name__c ='Will1';
        
        productController1.saveProduct();  	
    	
    }
    
    public static testMethod void productsInitialPageLoadTest()
    {
    	init();
    	//Create an instance of the AddProducts controller
    	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
    	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('General Insurance'));
        AddProductsController productController = new AddProductsController
        	(new ApexPages.StandardController(new Product_Master__c()));
        	
        //Set the current page reference to the AddProductManufacturers page
        Test.setCurrentPageReference(Page.AddProducts);
        
        test.startTest();			//Begin test
        System.assertEquals(productController.lstProductMaster.size(), 3);
        test.stopTest();			//End test
    }
    
     /* When data i.e. product records are entered without product type field and the Save button is clicked, the
	 * error message should get displayed to enter the product type.
	 */
	public static testMethod void saveProductRecord_ProductTypeErrorTest()
    {
    	init();
    	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
    	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
		//Product Manufacturer record  is not entered and save button is clicked
	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Master__c());
	 		
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	    
	    Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance', Short_Code__c='HDFCLI', Is_Active__c=true);
		insert PM1;
		
		// Insert Product record
		Product_Master__c objProduct = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=PM1.Id, 
			Is_Active__c=false, Product_Name__c='Birla sun life insurance123', 
			Currently_Recommended__c='No',Fees_in_Advance_or_On_Service_Delivery__c=false,
			RecordTypeId=mapProductRecordToId.get('Life Insurance'));
	    
		//insert objProduct;
		    				
		test.startTest();      //Begin Test
		AddProductsController.ProductMaster PM = new AddProductsController.ProductMaster(objProduct);
		productController.lstProductMaster.add(PM);
		productController.saveProduct();
		Pagereference savePage = productController.saveProduct();
		//system.assertEquals(savePage.getUrl(), 
		//	'/' + Product_Master__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
		test.stopTest();      //End Test
    }
    
    /* When data i.e. product records are entered and the Save button is clicked the
	 * records should be saved and the user should be navigated to the Product Manufacturer tab
	 */
	 public static testMethod void saveProductRecordTest()
    {
    	init();
    	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
    	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
		//Product Manufacturer record  is not entered and save button is clicked
	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Master__c());
	 		
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	    
	    Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance1', Short_Code__c='HDFCLI', Is_Active__c=true);
		insert PM1;
		
		// Insert Product record
		Product_Master__c objProduct = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=PM1.Id, 
			Is_Active__c=false, Product_Name__c='Birla sun life insurance321', ProductType__c='Life Insurance',
			Currently_Recommended__c='No',Fees_in_Advance_or_On_Service_Delivery__c=false,
			RecordTypeId=mapProductRecordToId.get('Life Insurance'));
	    
		//insert objProduct;
		    				
		test.startTest();      //Begin Test
		AddProductsController.ProductMaster PM = new AddProductsController.ProductMaster(objProduct);
		productController.lstProductMaster.add(PM);
		productController.saveProduct();
		Pagereference savePage = productController.saveProduct();
		//system.assertEquals(savePage.getUrl(), 
		//	'/' + Product_Master__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
		test.stopTest();      //End Test
    }
	 
	public static testMethod void saveProductRecord1Test()
    {
		init();
		ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
		ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
		//Product Manufacturer record  is not entered and save button is clicked
	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Master__c());
	 		
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	    
	    List<Product_Manufacturer_Master__c> lstProductManufacturer = new List<Product_Manufacturer_Master__c>();
	    Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance11', Short_Code__c='HDFCLI', Is_Active__c=true);
		lstProductManufacturer.add(PM1);
		Product_Manufacturer_Master__c PM2 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance1111', Short_Code__c='HDFCLI1', Is_Active__c=true);
		lstProductManufacturer.add(PM2);
		
		
		insert lstProductManufacturer;
		
		List<Product_Master__c> lstProductMaster = new List<Product_Master__c>();
		// Insert Product record
		Product_Master__c objProduct = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=lstProductManufacturer[0].Id, 
			Is_Active__c=false, ProductType__c='Life Insurance', Product_Name__c='Birla sun life insurance1', 
			Currently_Recommended__c='No',Fees_in_Advance_or_On_Service_Delivery__c=false,
			RecordTypeId=mapProductRecordToId.get('Life Insurance'));
	    lstProductMaster.add(objProduct);
	    
	    Product_Master__c objProduct1 = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=lstProductManufacturer[0].Id, 
			Is_Active__c=false, ProductType__c='Life Insurance1', Product_Name__c='Birla sun life insurance2', 
			Currently_Recommended__c='No',Fees_in_Advance_or_On_Service_Delivery__c=false,
			RecordTypeId=mapProductRecordToId.get('Life Insurance'));
	     lstProductMaster.add(objProduct1);
	     
	     Product_Master__c objProduct2 = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=lstProductManufacturer[0].Id, 
			Is_Active__c=false, ProductType__c='Life Insurance1', Product_Name__c='Birla sun2', 
			Currently_Recommended__c='No',Fees_in_Advance_or_On_Service_Delivery__c=false,
			RecordTypeId=mapProductRecordToId.get('Life Insurance'));
		  lstProductMaster.add(objProduct2);	
		
		 Product_Master__c objProduct3 = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=lstProductManufacturer[0].Id, 
			Is_Active__c=false, ProductType__c='Life Insurance1', Product_Name__c='Birla sun life insurance3', 
			Currently_Recommended__c='No',Fees_in_Advance_or_On_Service_Delivery__c=false,
			RecordTypeId=mapProductRecordToId.get('Life Insurance'));
		 lstProductMaster.add(objProduct3);			
		//objProduct1.Product_Name__c = 'HDFC Top 200';
				
		test.startTest();      //Begin Test
		
		system.debug('==============lstProductManufacturer'+lstProductManufacturer.size());
		//if(!lstProductManufacturer.isEmpty())
		//{
			
			insert lstProductMaster;
			//insert objProduct1;
			system.debug('==============objProduct'+objProduct);
			//AddProductsController.ProductMaster PM = new AddProductsController.ProductMaster(objProduct);
			//productController.lstProductMaster.add(PM);
			system.debug('==============lstProductManufacturer'+lstProductManufacturer);
		//AddProductsController.ProductMaster PM11 = new AddProductsController.ProductMaster(objProduct1);
		//productController.lstProductMaster.add(PM11);
			productController.removeRows();
			//productController.saveProduct();
		//}
		Pagereference savePage = productController.saveProduct();
		//system.assertEquals(savePage.getUrl(), 
		//	'/' + Product_Master__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
		test.stopTest();      //End Test
    }
    
    /* When any of the Product Manufacturer is Inactive is not present then
	 * error message should get displayed and Page should be navigated 
	 * to the AddProductManufacturer Page.
	 */
	public static testMethod void productManufacturerEmptyTest()
    {
    	init();
    	
    	Pagereference newAddProduct = Page.AddProducts;
	 	Test.setCurrentPage(newAddProduct);
	 	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
	 	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	 	
	 	// Insert Product Manufacturer record list
		List<Product_Manufacturer_Master__c> productRecord = new List<Product_Manufacturer_Master__c>();
	 	
	
		test.startTest();      //Begin Test
		try
		{
			productController.lstProductManufacturer = new List<Product_Manufacturer_Master__c>();
			productController.saveProduct();
			
		}
		catch(Exception e)
		{
			System.Assert(e.getMessage().contains(Label.Add_Product_Manufacturer));
		}
		
		//system.assertEquals(savePage.getUrl(), 
		//	'/' + Product_Master__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
		test.stopTest();      //End Test
	 	
    }
    
    /* When data i.e. product records are entered with Currently Recommended field as YEs and the Save button is clicked, the
	 * error message should get displayed to enter it on Product Detail page.
	 */
	public static testMethod void saveProductRecord_CurrentlyRecommendedErrorTest()
    {
    	init();
    	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
    	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
		//Product Manufacturer record  is not entered and save button is clicked
	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Master__c());
	 		
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	    
	     Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance5', Short_Code__c='HDFCLI', Is_Active__c=true);
		insert PM1;
		
		// Insert Product record
		Product_Master__c objProduct = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=PM1.Id, 
			Is_Active__c=false, Product_Name__c='Birla sun life insurance6', ProductType__c='Life Insurance1',
			Fees_in_Advance_or_On_Service_Delivery__c=false,Earn_One_Time_Fees__c = true,Earn_Trail_Fees__c = true,
			RecordTypeId=mapProductRecordToId.get('Life Insurance'));
	    
		test.startTest();      //Begin Test
		try
		{
			//insert objProduct;
			/*objProduct.Earn_One_Time_Fees__c = true;
			objProduct.Earn_Trail_Fees__c = true;
			update objProduct;*/
			AddProductsController.ProductMaster PM = new AddProductsController.ProductMaster(objProduct);
			productController.lstProductMaster.add(PM);
			productController.saveProduct();
			Pagereference savePage = productController.saveProduct();
		}
		catch(Exception e)
		{
			//System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
			system.debug('==============Error========'+e);
		}
		test.stopTest();      //End Test
    }
   
    
    /* When data i.e. product records are entered with Currently Recommended field as YEs and the Save button is clicked, the
	 * error message should get displayed to enter it on Product Detail page.
	 */
	public static testMethod void saveProductRecord_CurrentlyRecommendedErrorTest1()
    {
    	init();
    	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
    	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
		//Product Manufacturer record  is not entered and save button is clicked
	 	ApexPages.StandardController stdCtrl = 
	 		new ApexPages.standardController(new Product_Master__c());
	 		
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	    
	     Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance7', Short_Code__c='HDFCLI', Is_Active__c=true);
		insert PM1;
		
		// Insert Product record
		Product_Master__c objProduct = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=PM1.Id, 
			Is_Active__c=false, Product_Name__c='Birla sun life insurance77', ProductType__c='Life Insurance1',
			Fees_in_Advance_or_On_Service_Delivery__c=false, RecordTypeId=mapProductRecordToId.get('Other Product'));
	    
		test.startTest();      //Begin Test
		try
		{
			//insert objProduct;
			AddProductsController.ProductMaster PM = new AddProductsController.ProductMaster(objProduct);
			productController.lstProductMaster.add(PM);
			productController.saveProduct();
			Pagereference savePage = productController.saveProduct();
		}
		catch(Exception e)
		{
			//System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
			system.debug('==============Error========'+e);
		}
		test.stopTest();      //End Test
    }
   
    
    /* When rows are added to the table and check box is selected to remoce rows 
     */ 
    static testMethod void removeProductManufacturersRecordTest()
    {
    	init();
    	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
    	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
		ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 	AddProductsController productController = new AddProductsController(stdCtrl);
		
		test.startTest();   // start test
		//Remove the first record
		productController.lstProductMaster[0].isRemove = true;
		productController.lstProductMaster[1].isRemove = false;
		productController.removeRows();
		productController.saveProduct();
		
		// Check Whether there are 3 Product Manufacturer records
		system.assert(productController.lstProductMaster.size() == 3);
		
		test.stopTest();      //End Test
		
	}
    
    /* When the Cancel button is clicked the user should be navigated back to the Product tab 
  	 */
	static testMethod void test_cancelProductRecord()
	{
		init();
		
		Pagereference newAddProduct = Page.AddProducts;
	 	Test.setCurrentPage(newAddProduct);
	 	//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
	 	ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 	AddProductsController productController = new AddProductsController(stdCtrl);

	 	test.startTest();  //Begin Test
	 	Pagereference cancelPage = productController.cancelProduct();
	 	//system.assertEquals(cancelPage.getUrl(), 
	 	//	'/' + Product_Master__c.SObjectType.getDescribe().getKeyPrefix() + '/o');
	 	test.stopTest();    //End Test
	}
    
	/* To check if picklist values are inserted properly. 
  	 */
	static testMethod void test_picklist()
	{
		init();
		//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
		ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	 	
	 	test.startTest();  //Begin Test
		productController.getProdManName();
	 	//system.assertEquals(Product_Manufacturer__c, 'Birla');
	 	test.stopTest();    //End Test
	}
 
 
 	/* To increase test coverage
  	 */
	static testMethod void test_insertproductmaster()
	{
		init();
		//ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Other Product'));
		ApexPages.currentPage().getParameters().put('RecordType', mapProductRecordToId.get('Life Insurance'));
	 	ApexPages.StandardController stdCtrl = new ApexPages.standardController(new Product_Master__c());
	 	AddProductsController productController = new AddProductsController(stdCtrl);
	 	
	 	Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insuranc777e', Short_Code__c='HDFCLI', Is_Active__c=true);
		insert PM1;
		
		// Insert Product record
		Product_Master__c objProduct = new Product_Master__c(SIP_Allowed__c='Yes', Product_Manufacturer__c=PM1.Id, 
										Is_Active__c=false, Product_Name__c='Birla sun life insuran777ce', 
										Currently_Recommended__c='No',Fees_in_Advance_or_On_Service_Delivery__c=false,
										RecordTypeId=mapProductRecordToId.get('Life Insurance') );
							
		insert objProduct;			
							
		Product_Recommendation_Master__c productRecommendation = new Product_Recommendation_Master__c(Product_Code__c = objProduct.Id);
		
		productRecommendation.Recommendation_Start_date__c = Date.today();
		productRecommendation.Recommendation_End_date__c = Date.today().addDays(2);
		productRecommendation.Current_Status__c = 'Active';
		insert productRecommendation;
		
		objProduct.Currently_Recommended__c = 'Yes';
		update objProduct;
		
	 	test.startTest();  //Begin Test
		productController.saveProduct();
	 	//system.assertEquals(Product_Manufacturer__c, 'Birla');
	 	test.stopTest();    //End Test
	}
}