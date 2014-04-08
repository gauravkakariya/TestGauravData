/*	
*   Test class for Helper code that is invoked for an PriceBookHandler classes. 
*   Dupes are checked for a given Product for a given price type and 
*   a given price category as there should exist only one active Pricebook 
*   record at a time.* 
*
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		08/01/2013		Initial Draft
*
*/


@isTest
private class ValidateActivePriceBookTest 
{
	/* Test Method to check whether record is inserted properly
	 */
    static testMethod void isValidateInsertPositiveTest() 
    {
		// Insert Product record 
		Product_Master__c objProduct = createProductRecord();
		insert objProduct;
		
		Product_Price_Book__c objPriceBook = new Product_Price_Book__c
												(Product_code__c = objProduct.id, 
												 Price_value__c = 30, 
												 Price_Category__c = 'One Time',
												 Price_type__c = 'fixed amount', 
												 Current_Status__c = 'Active',
												 Price_Start_date__c = system.today(), 
												 Price_End_date__c = system.today(),
												 Advance_Value__c = 10);
			
		test.startTest();      //Begin Test
		insert objPriceBook;
		
		system.assertEquals(objPriceBook.Price_type__c,'fixed amount');
		test.stopTest();      //End Test    	
    	
    }
    
    /* Test Method to check whether record is inserted is already present
     * and if yes then shows error message
	 */
    static testMethod void isValidateInsertNegativeTest() 
    {
		// Insert Product record 
		Product_Master__c objProduct = createProductRecord();
		insert objProduct;
		
		Product_Price_Book__c objPriceBook = new Product_Price_Book__c
												(Product_code__c = objProduct.id, 
												 Price_value__c = 30, 
												 Price_Category__c = 'One Time',
												 Price_type__c = 'fixed amount', 
												 Current_Status__c = 'Active',
												 Price_Start_date__c = system.today(), 
												 Price_End_date__c = system.today(),
												 Advance_Value__c = 10);
		insert objPriceBook;
		
		test.startTest();      //Begin Test
		
		try{
			Product_Price_Book__c objPriceBook1 = new Product_Price_Book__c
												(Product_code__c = objProduct.id, 
												 Price_value__c = 30, 
												 Price_Category__c = 'One Time',
												 Price_type__c = 'fixed amount', 
												 Current_Status__c = 'Active',
												 Price_Start_date__c = system.today(), 
												 Price_End_date__c = system.today(),
												 Advance_Value__c = 10);
			insert objPriceBook1;
		}
		catch(Exception e)
		{
			System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
			System.Assert(e.getMessage().contains(Label.Duplicate_PriceBook));
		}
		test.stopTest();      //End Test    	
    	
    }
    
    /* Test Method to check whether record is updated properly
	 */
    static testMethod void isValidateUpdatePositiveTest() 
    {
		// Insert Product record 
		Product_Master__c objProduct = createProductRecord();
		insert objProduct;
		
		List<Product_Price_Book__c> lstPricebook = new List<Product_Price_Book__c>();
		
		Product_Price_Book__c objPriceBook1 = new Product_Price_Book__c
												(Product_code__c = objProduct.id, 
												Price_value__c = 30, 
												Price_Category__c = 'One Time',
												Price_type__c = 'fixed amount', 
												Current_Status__c = 'Active',
												Price_Start_date__c = system.today(), 
												Price_End_date__c = system.today(),
												Advance_Value__c = 10);
		lstPricebook.add(objPriceBook1);
		
		Product_Price_Book__c objPriceBook2 = new Product_Price_Book__c
												(Product_code__c = objProduct.id, 
												Price_value__c = 30, 
												Price_Category__c = 'Upfront',
												Price_type__c = 'percentage of current investment value',
												Current_Status__c = 'Active',
												Price_Start_date__c = system.today(), 
												Price_End_date__c = system.today(),
												Advance_Value__c = 10);
		lstPricebook.add(objPriceBook2);
		
		test.startTest();      //Begin Test
		insert lstPricebook;
		Product_Price_Book__c objPrice = [Select Id,Price_Category__c,
												    Price_type__c,
												    Current_Status__c 
										  from Product_Price_Book__c
										  where Id =: objPriceBook1.Id];
		objPrice.Price_Category__c = 'Upfront';
		update objPrice;
		system.assertEquals(objPrice.Price_Category__c, 'Upfront');
		test.stopTest();      //End Test    	
    	
    }
    
    /* Test Method to check whether record if updated record is already present
	*/ 
    static testMethod void isValidateUpdateNegativeTest()
    {
		// Insert Product record 
		Product_Master__c objProduct = createProductRecord();
		insert objProduct;
		
		List<Product_Price_Book__c> lstPricebook = new List<Product_Price_Book__c>();
		
		Product_Price_Book__c objPriceBook1 = new Product_Price_Book__c
												 (Product_code__c  = objProduct.id, 
												  Price_value__c = 30, 
												  Price_Category__c = 'One Time',
												  Price_type__c = 'Fixed Amount', 
												  Current_Status__c = 'Active',
												  Price_Start_date__c = system.today(), 
												  Price_End_date__c = system.today(),
												  Advance_Value__c = 10);
		lstPricebook.add(objPriceBook1);
		
		Product_Price_Book__c objPriceBook2 = new Product_Price_Book__c
												 (Product_code__c = objProduct.id, 
												  Price_value__c = 30, 
												  Price_Category__c = 'Upfront',
												  Price_type__c = 'Percentage of Current Investment Value',
												  Current_Status__c = 'Active',
												  Price_Start_date__c = system.today(), 
												  Price_End_date__c = system.today(),
												  Advance_Value__c = 10);
		lstPricebook.add(objPriceBook2);
		
		Product_Price_Book__c objPriceBook3 = new Product_Price_Book__c
												 (Product_code__c = objProduct.id, 
												  Price_value__c = 30, 
												  Price_Category__c = 'Upfront',
												  Price_type__c = 'Percentage of Investment Amount',
												  Current_Status__c = 'Active',
												  Price_Start_date__c = system.today(), 
												  Price_End_date__c = system.today(),
												  Advance_Value__c = 10);
		lstPricebook.add(objPriceBook3);
		
		test.startTest();      //Begin Test
		insert lstPricebook;
		try
		{
			Product_Price_Book__c objPrice = [Select Id,Price_Category__c,
													Price_type__c,
													Current_Status__c 
										  from Product_Price_Book__c
										  where Id =: objPriceBook3.Id];
			objPrice.Price_type__c = 'Percentage of Current Investment Value';
			update objPrice;
		}
		catch(Exception e)
		{
			System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
			System.Assert(e.getMessage().contains(Label.Duplicate_PriceBook));
		}
		
		test.stopTest();      //End Test    	
    	
    }
    
    //Public Methods
	//Populate and return a new instance of Product_Master__c record 
	public static Product_Master__c createProductRecord()
	{
    	// Insert Product Manufacturer record list
		List<Product_Manufacturer_Master__c> productRecord = new List<Product_Manufacturer_Master__c>();
		
		Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c
												(Name = 'Birla1', 
												 Short_Code__c = 'Birla1', 
												 Is_Active__c = true);
		productRecord.add(PM1);
		Product_Manufacturer_Master__c PM2 = new Product_Manufacturer_Master__c
												(Name = 'HDFC1', 
												 Short_Code__c = 'HDFC1', 
												 Is_Active__c = false);
		productRecord.add(PM2);
    	insert productRecord; 
    	
    	productRecord = [Select Id, Name
					     From Product_Manufacturer_Master__c  
					     where Name =:'Birla'];
		
		Product_Master__c objProduct = new Product_Master__c();
		if(productRecord != Null && productRecord.size() > 0)
		{			             
			objProduct = new Product_Master__c(SIP_Allowed__c = 'Yes', 
											   Product_Manufacturer__c = productRecord[0].Id, 
											   Is_Active__c = false, 
											   ProductType__c = 'Life Insurance', 
											   Product_Name__c = 'Birla sun life insurance', 
											   Currently_Recommended__c = 'No',
											   Fees_in_Advance_or_On_Service_Delivery__c = true);
		}
		return objProduct;
	}
	
	/* Test Method to check wheather record is inserted properly
	 */
    static testMethod void isValidateInsertPositiveBulkTest() 
    {
		List<Product_Price_Book__c> lstPricebook = createPricebookRecord(5);
		system.debug('lstPricebook..................'+lstPricebook)	;	
			
		test.startTest();      //Begin Test
		//insert lstPricebook;
		try
		{
			insert lstPricebook;
		}
		catch(Exception e)
		{
			system.assertEquals(lstPricebook[0].Price_Category__c, 'Upfront');
			System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
		//	System.Assert(e.getMessage().contains(Label.Duplicate_PriceBook));
		}
		test.stopTest();      //End Test    	
    	
    }
	
	//Populate and return a new instance of Pricebook record 
	public static List<Product_Price_Book__c> createPricebookRecord(Integer pNoOfRecords)
	{
		// Insert Product record 
		Product_Master__c objProduct = createProductRecord();
		insert objProduct;
		
    	List<Product_Price_Book__c> pricebookList = new List<Product_Price_Book__c>();
    	
    	//Populate a list of Product Manufacturers
    	for(Integer index = 1; index <= pNoOfRecords; index++)
    	{
    		pricebookList.add(new Product_Price_Book__c
								 (Product_code__c = objProduct.id, 
								  Price_value__c = 30, 
								  Price_Category__c = 'Upfront',
								  Price_type__c = 'Percentage of Investment Amount',
								  Current_Status__c = 'Active',
								  Price_Start_date__c = system.today(), 
								  Price_End_date__c = system.today()));
    			
    	}//for
    	
    	return pricebookList;
	}
}