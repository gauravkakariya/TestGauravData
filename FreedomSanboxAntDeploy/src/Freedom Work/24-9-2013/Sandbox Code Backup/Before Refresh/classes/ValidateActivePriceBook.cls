/*
*   Helper code that is invoked for an PriceBookHandler classes. 
*   Dupes are checked for a given Product for a given price type and 
*   a given price category as there should exist only one active Pricebook 
*   record at a time.
*   
*   Revision History:
*
*	Version		Author				Date			Description
*	1.0			Prajakta Sanap		08/01/2013		Initial Draft
*
*/

public with sharing class ValidateActivePriceBook 
{
	public static boolean isTestMode = false;
	public Map<String, Product_Price_Book__c> priceBookMap{get;set;}
	public List<Product_Price_Book__c> lstPriceBook{get;set;}
	
	/* Function to fill the map */
	public void fillMapPriceBook()
	{
		// Map of PriceBook as a value with combination of Product Code, 
		// Price Category and Price Type as a key
		priceBookMap = new Map<String, Product_Price_Book__c>(); 
		
		// List of all existing price book
		lstPriceBook = [Select Product_code__c, 
							   Price_type__c, 
							   Price_Category__c,
							   Current_status__c 
						From Product_Price_Book__c
						where Current_status__c = 'Active'];
		
		// Filled map with all existing priceBook records
		for(Product_Price_Book__c objPriceBook : lstPriceBook)
		{
			//combination of Product Code, Price Category and Price Type as a key
			String strKey = objPriceBook.Product_code__c + 
							objPriceBook.Price_type__c + 
							objPriceBook.Price_Category__c +
							objPriceBook.Current_status__c;
			/*if(strKey != null)
			{
				if(priceBookMap.containsKey(strKey))
				{
					//objPriceBook.addError(Label.Duplicate_PriceBook);
	            } 
			}//end if*/
			priceBookMap.put(strKey,objPriceBook);
		}//for end
	}

	/* Function to check if inserted record is already present */
	public void validate(List<Product_Price_Book__c> lstNewPriceBook)
	{
		fillMapPriceBook();
		
		//For newly inserted records checked if records is already present 
		//else displayed error message  
		for(Product_Price_Book__c objPriceBook : lstNewPriceBook)
		{
			system.debug('lstNewPriceBook---------------'+lstNewPriceBook);
			//combination of Product Code, Price Category and Price Type as a key
			String strKey = objPriceBook.Product_code__c + 
							objPriceBook.Price_type__c + 
							objPriceBook.Price_Category__c +
							objPriceBook.Current_status__c;
			system.debug('strKey---------------'+strKey);
			if(strKey != null)
			{
				if(priceBookMap.containsKey(strKey))
				{
					system.debug('objPriceBook---------------'+objPriceBook);
					objPriceBook.addError(Label.Duplicate_PriceBook);
	            } 
			}//end if
		}//For end
	}//validate end
	
	/* Function to check duplicates for the records to be inserted */
	public static List<Product_Price_Book__c> duplicateCheck(List<Product_Price_Book__c> lstNewPriceBook)
	{
		
		// Map of PriceBook as a value with combination of Product Code, 
		// Price Category and Price Type as a key
		Map<String, Product_Price_Book__c> priceBookMap = new Map<String, Product_Price_Book__c>(); 
		
		for(Product_Price_Book__c objPriceBook : lstNewPriceBook)
		{
			
			//combination of Product Code, Price Category and Price Type as a key
			String strKey = objPriceBook.Product_code__c + 
							objPriceBook.Price_type__c + 
							objPriceBook.Price_Category__c +
							objPriceBook.Current_status__c;

			if(strKey != null)
			{
				if(priceBookMap.containsKey(strKey))
				{
					system.debug('objPriceBook---------------'+objPriceBook);
					objPriceBook.addError(Label.Duplicate_PriceBook);
	            } 
	            else
					priceBookMap.put(strKey,objPriceBook);
			}//end if
			
		}//for end
		
		List<Product_Price_Book__c> PBlist = new List<Product_Price_Book__c>();
		PBlist.addAll(priceBookMap.values());
		system.debug('PBlist---------------'+PBlist);
		return PBList;
	}
		
		
		
	
	/* Function to check if record to be updated is already present */
	public void isValidatePricebook(List<Product_Price_Book__c> lstNewPriceBook)
	{
		fillMapPriceBook();
		
		// For newly inserted records checked if records is already present 
		// else displayed error message 
		for(Product_Price_Book__c objPriceBook : lstNewPriceBook)
		{
			//combination of Product Code, Price Category and Price Type as a key
			String strKey = objPriceBook.Product_code__c + 
							objPriceBook.Price_type__c + 
							objPriceBook.Price_Category__c +
							objPriceBook.Current_status__c;
							
			if(strKey != null)
			{
				if(priceBookMap.containsKey(strKey))
				{
					objPriceBook.addError(Label.Duplicate_PriceBook);
	            } 
			}//end if
		}//For end
	}
}//ValidateActivePriceBook end