/* 
*  Controller class that acts as an extension of Standard Controller Product_Manufacturer_Master__c 
*  Contains the logic of inserting Data From a AddProductManufacturers VF Page
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Prajakta Sanap    27/12/2012      Initial Draft
*/

public class EditProductsController 
{
	public List<Product_Master__c> lstProductMaster{get;set;}
	public List<Product_Manufacturer_Master__c> lstProductManufacturer{get;set;}
	private Boolean isEditPage;
	public Product_Master__c objProductMaster{get;set;}
	public Product_Manufacturer_Master__c objProduct_Manufacturer_Master{get;set;}
	public String objId{get;set;}
	public Boolean isRemove{get;set;}
	public String earnFees{get;set;}
	
	/*Constructor*/
	public EditProductsController(ApexPages.StandardController controller)
	{
		isEditPage = false;
		lstProductMaster = new List<Product_Master__c>();
		lstProductMaster = [Select SIP_Allowed__c, 
									Product_Manufacturer__r.Name, 
									Is_Active__c, 
									ProductType__c, 
									Name, 
									Product_Name__c, 
									Currently_Recommended__c, 
									Fees__c,  
									Current_NAV__c, 
									Fees_in_Advance_or_On_Service_Delivery__c,
									Earn_One_Time_Fees__c,
									Earn_Upfront_Fees__c,
									Earn_Trail_Fees__c
									From Product_Master__c
									where Product_Manufacturer__r.Is_Active__c = true];
		lstProductManufacturer = new List<Product_Manufacturer_Master__c>();
		lstProductManufacturer = [Select Short_Code__c, 
										Name, 
										Is_Active__c 
										From Product_Manufacturer_Master__c 
										where Is_Active__c  = true 
										order by Name Asc];							
	}
	
	/*Save the updated records*/
	public PageReference saveProduct()
	{
		isEditPage = true;
		Boolean isRepeat = false; 
		Set<String> setKeyValue = new Set<String>();
		//List of records inserted by VF page
        List<Product_Master__c> lstNewProducts = new List<Product_Master__c>();
		for(Product_Master__c objProducts : lstProductMaster)
		{
			String strKey = objProducts.Product_Name__c;
			if(strKey != null)
			{
				strKey = strKey.trim().toLowerCase();
				//If SET does not contain strKey, then insert record in the list
				if(!setKeyValue.contains(strKey))
				{
					isRepeat = true;
					lstNewProducts.add(objProducts);						
				}
				else//otherwise display error message
				{	
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Product "'+ objProducts.Product_Name__c + '"Already Exists.'));
					return null;
				}
				setKeyValue.add(strKey);
			}//End of if
			
			if(objProducts.Earn_One_Time_Fees__c == true && (objProducts.Earn_Trail_Fees__c == true || objProducts.Earn_Upfront_Fees__c == true))
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Earn_Fees));
				return null;
			}
		}//Enf of for
		
		//Insert all Product manufacturer records in DB
		if(!lstNewProducts.isEmpty())
		{
			update lstNewProducts;
		}
		
		if(isRepeat)
		{
			String objId = Apexpages.currentPage().getParameters().get('id');
			
	        //Fetching the Prefix of Object Product_Master__c
	        Schema.DescribeSObjectResult dsr = Product_Master__c.SObjectType.getDescribe();
			//Redirect to the standard detail page of the Product Master.
			PageReference stdProductMaster = IsEditPage ? new PageReference('/' + objId) :  new PageReference('/' + dsr.getKeyPrefix() + '/o');
	 		stdProductMaster.setRedirect(true);
	    	return stdProductMaster;
		}
		return null;	
	}
	
	/*Cancels the operation and returns to the main Product Manufacturer Tab page*/
	public PageReference cancelProduct()
	{
		isEditPage = true;
		String objId = Apexpages.currentPage().getParameters().get('id');
		//Fetching the Prefix of Object Product_Master__c
		Schema.DescribeSObjectResult dsr = Product_Master__c.SObjectType.getDescribe();
		PageReference cancel = IsEditPage ? new PageReference('/' + objId) : new PageReference('/' + dsr.getKeyPrefix() + '/o');
	    cancel.setRedirect(true);
	    return cancel;
	}
	
	/*To get picklist values of Product_Manufacturer__r.Name*/
	public List<selectOption> getProductManufacturerName()
    {
      	List<selectOption> options = new List<selectOption>();
        for(Product_Manufacturer_Master__c objProductManufacturer : lstProductManufacturer) 
        {
            options.add(new selectOption(objProductManufacturer.Id, objProductManufacturer.Name));
        }
        return options;
    }
}