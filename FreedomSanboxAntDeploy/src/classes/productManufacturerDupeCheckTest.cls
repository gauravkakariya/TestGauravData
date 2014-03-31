/*	
*   Helper code that is invoked for an ProductManufacturerHandler classes. 
*   Dupes are checked for a given Product Manufacturer Name and Short Code 
*   should  not be same as there should exist only one 
*   record at a time.
*
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		16/01/2013		Initial Draft
*
*/


@isTest
private class productManufacturerDupeCheckTest 
{

	/* Test Method to check whether Product Master record is inserted properly
	 */
    static testMethod void isValidateInsertTest() 
    {
		// Insert Product manufacturer record 
		Product_Manufacturer_Master__c objProductManufacturer = createProductManfRecord();
		
		test.startTest();      //Begin Test
		insert objProductManufacturer;
		
		system.assertEquals(objProductManufacturer.Name,'HDFC Life Insurance');
		test.stopTest();      //End Test    	
    	
    }
    
    /* Test Method to check whether Product Master record is inserted properly
	 */
    static testMethod void isValidateInsertErrorTest() 
    {
		// Insert Product manufacturer record 
		Product_Manufacturer_Master__c objProductManufacturer = createProductManfRecord();
		
		test.startTest();      //Begin Test
		try
		{
			insert objProductManufacturer;
			Product_Manufacturer_Master__c objProductManufacturer1 = 
							new Product_Manufacturer_Master__c(Name = 'HDFC Life Insurance', 
															  Short_Code__c = 'HDFC',
															  Is_Active__c=true);
			insert objProductManufacturer1;
		}
		catch(Exception e)
		{
			System.Assert(e.getMessage().contains('DUPLICATE_VALUE'));
		}
		test.stopTest();      //End Test    	
    	
    }
    
    /* Test Method to check whether Product Master record is updated properly
	 */
    static testMethod void isValidateUpdatedTest() 
    {
		// Insert Product manufacturer record 
		Product_Manufacturer_Master__c objProductManufacturer = createProductManfRecord();
		
		test.startTest();      //Begin Test
		insert objProductManufacturer;
		objProductManufacturer.Name = 'HDFC TOP 200';
		update objProductManufacturer;
		system.assertEquals(objProductManufacturer.Name,'HDFC TOP 200');
		test.stopTest();      //End Test    	
    }
    
	 /* Test Method to check whether record if updated record is already present
	*/ 
    static testMethod void isValidateUpdateErrorTest()
    {
		List<Product_Manufacturer_Master__c> lstProductMan = new List<Product_Manufacturer_Master__c>();
		
		Product_Manufacturer_Master__c objProductManufacturer1 = 
							new Product_Manufacturer_Master__c(Name = 'HDFC Life Insurance', 
															  Short_Code__c = 'HDFC',
															  Is_Active__c=true);
		lstProductMan.add(objProductManufacturer1);
		
		Product_Manufacturer_Master__c objProductManufacturer2 = 
							new Product_Manufacturer_Master__c(Name = 'HDFC Life Insurance1', 
															  Short_Code__c = 'AMC',
															  Is_Active__c=true);
		lstProductMan.add(objProductManufacturer2);
		
		Product_Manufacturer_Master__c objProductManufacturer3 = 
							new Product_Manufacturer_Master__c(Name = 'HDFC Life Insurance11', 
															  Short_Code__c = 'HDFC',
															  Is_Active__c=true);
		lstProductMan.add(objProductManufacturer3);
		
		test.startTest();      //Begin Test
		
		try
		{
			insert lstProductMan;
			Product_Manufacturer_Master__c objProd = [Select Id,Name,
														Short_Code__c,
														Is_Active__c
										  from Product_Manufacturer_Master__c
										  where Id =: objProductManufacturer3.Id];
			objProd.Name = 'HDFC Life Insurance1';
			update objProd;
		}
		catch(Exception e)
		{
			System.Assert(e.getMessage().contains('DUPLICATE_VALUE'));
		}
		
		test.stopTest();      //End Test    	
    	
    }
    
    /* Test Method to check whether record is inserted properly in bulk
	 */
    static testMethod void isValidateInsertBulkTest() 
    {
		List<Product_Manufacturer_Master__c> prodManufacturerList = createPrdMfrRecords(5);
		system.debug('prodManufacturerList..................'+prodManufacturerList)	;	
			
		test.startTest();      //Begin Test
		try
		{
			insert prodManufacturerList;
		}
		catch(Exception e)
		{
			system.assertEquals(prodManufacturerList[0].Name,'HDFC Life Insurance');
			System.Assert(e.getMessage().contains('DUPLICATE_VALUE'));
		}
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
    	List<Product_Manufacturer_Master__c> productMfrList = 
    		new List<Product_Manufacturer_Master__c>();
    	
    	//Populate a list of Product Manufacturers
    	for(Integer index = 1; index <= pNoOfRecords; index++)
    	{
    		productMfrList.add(new Product_Manufacturer_Master__c(
								    				Name = 'HDFC Life Insurance', 
								    				Short_Code__c = 'HDFC', 
								    				Is_Active__c=true));
    			
    	}//for
    	
    	return productMfrList;
    }
}