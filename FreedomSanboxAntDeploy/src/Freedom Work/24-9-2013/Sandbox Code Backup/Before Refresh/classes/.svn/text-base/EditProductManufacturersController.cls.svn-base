/* 
*  Controller class that acts as an extension of Standard Controller Product_Manufacturer_Master__c 
*  Contains the logic of editing Data From a EditProductManufacturers VF Page
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Prajakta Sanap    27/12/2012      Initial Draft
*/

public class EditProductManufacturersController 
{
	public List<Product_Manufacturer_Master__c> lstProductManufacturer{get;set;}
	public Boolean isRemove{get;set;}
	
	/*Constructor*/
	public EditProductManufacturersController(ApexPages.StandardController controller)
	{
		lstProductManufacturer = new List<Product_Manufacturer_Master__c>();
		lstProductManufacturer = [Select Short_Code__c, Name, Is_Active__c From Product_Manufacturer_Master__c];
	}
	
	/*To Save the updated records*/
	public PageReference saveProductManufacturer()
	{
        //List of records inserted by VF page
        List<Product_Manufacturer_Master__c> lstNewProductManufacturer = new List<Product_Manufacturer_Master__c>();
		
		Boolean isRepeat = false; 
		Set<String> setKeyValue = new Set<String>();
		
		for(Product_Manufacturer_Master__c objProductManufacturer : lstProductManufacturer)
		{
			String strName = objProductManufacturer.Name.trim().toLowerCase();
			if(strName != '')
			{
				//If set does not contain strKey, then insert record in the list
				if(!setKeyValue.contains(strName.trim().toLowerCase()))
				{
					isRepeat = true;
					lstNewProductManufacturer.add(objProductManufacturer);						
				}
				else//otherwise display error message
				{	
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The Product "'+ objProductManufacturer.Name + '"Already Exists.'));
					return null;
				}
				setKeyValue.add(strName);
			}//End of if
		}//Enf of for
		
		//Insert all Product manufacturer records in DB
		if(!lstNewProductManufacturer.isEmpty())
		{
			update lstNewProductManufacturer;
		}
        
        if(isRepeat)
        {
	        //Fetching the Prefix of Object Product_Manufacturer_Master__c
			Schema.DescribeSObjectResult dsr = Product_Manufacturer_Master__c.SObjectType.getDescribe();   
			 
			//Redirect to the standard detail page of the Product Manufacturer.
	    	return new Pagereference('/' + dsr.getKeyPrefix() + '/o');
        }
        return null;
	}
	
	/*Cancels the operation and returns to the main Product Manufacturer Tab page*/
	public PageReference cancelProductManufacturer()
	{
		//Fetching the Prefix of Object Product_Manufacturer_Master__c
		Schema.DescribeSObjectResult dsr = Product_Manufacturer_Master__c.SObjectType.getDescribe();
		PageReference cancel = new PageReference('/' + dsr.getKeyPrefix() + '/o');
	    cancel.setRedirect(true);
	    return cancel;
	}
	
}