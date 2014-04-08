/* 
*  Controller class that acts as an extension of Standard Controller Product_Manufacturer_Master__c 
*  Contains the logic of inserting Data From a AddProductManufacturers VF Page
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Prajakta Sanap    25/12/2012      Initial Draft
*/

public class AddProductManufacturersController 
{
    public List<ProductManufacturer> lstProductManufacturer{get;set;}
    public String sObjectPrefix {get; set;}
    private Boolean isEditPage;

    //Inner class
    public class ProductManufacturer
    {
    	//isEditPage = false;
        public Boolean isRemove{get;set;}
        public Product_Manufacturer_Master__c objProductManufacturer{get;set;}
        
        public ProductManufacturer(Product_Manufacturer_Master__c objProductManufacturer)
        {
            this.isRemove = false;
            this.objProductManufacturer = objProductManufacturer;
        }
    }
    
    /*Constructor*/
    public AddProductManufacturersController(ApexPages.StandardController controller)
    {
        lstProductManufacturer = new List<ProductManufacturer>();
        for(Integer iCount = 0; iCount < 3 ; iCount ++)
        {
        	addRow();
        }//for
    }
    
    /*Add new blank row in the existing table*/
    public void addRow() 
    {
        lstProductManufacturer.add(new ProductManufacturer(new Product_Manufacturer_Master__c()));
    }
    
    /*To save the new entered records*/
    public PageReference saveProductManufacturer()
    {
        //List of records in the standard objects
		list<Product_Manufacturer_Master__c> lstSavePM = [Select Short_Code__c, Name, Is_Active__c From Product_Manufacturer_Master__c];
		
        //List of records inserted by VF page
        List<Product_Manufacturer_Master__c> lstNewProductManufacturer = new List<Product_Manufacturer_Master__c>();
        Boolean isRepeat = false; 
        Set<String> setKeyValue = new Set<String>();
        
        for(Product_Manufacturer_Master__c objProductManufacturerSet : lstSavePM)
        {
        	String strName = objProductManufacturerSet.Name.trim().toLowerCase();
        	setKeyValue.add(strName);
        }
        
        for(ProductManufacturer objPM : lstProductManufacturer)
        {
            Product_Manufacturer_Master__c objSaveProductManufacturer = new Product_Manufacturer_Master__c();
            objSaveProductManufacturer = objPM.objProductManufacturer;
            String strKey = objSaveProductManufacturer.Name;
            
            if(objSaveProductManufacturer.Name != null && objSaveProductManufacturer.Name != '')
            {
            	strKey = strKey.trim().toLowerCase();
            	//If set does not contain strKey, then insert record in the list
                if(!setKeyValue.contains(strKey))
                {
                    isRepeat = true;
                    lstNewProductManufacturer.add(objSaveProductManufacturer); 
                    setKeyValue.add(strKey);                     
                }
                else//otherwise display error message
                {   
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Product Manufacturer Name "'+ objSaveProductManufacturer.Name + '" Already Exists.'));
                    return null;
                }
               
            }
			else if((objSaveProductManufacturer.Name == null || objSaveProductManufacturer.Name == '') && 
					(objSaveProductManufacturer.Short_Code__c == null || objSaveProductManufacturer.Short_Code__c == ''))
            {
                continue;
            }
            else if(objSaveProductManufacturer.Name == null || objSaveProductManufacturer.Name == '')
            { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Fill_Product_Manufacturer));
                return null;
            }
        }
        
        //If single record is not inserted and clicked directly on the save button, then it will display error message
        if(lstNewProductManufacturer.isEmpty())
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Add_Product_Manufacturer));
        	return null;
        }
            
        //Insert all Product manufacturer records in DB
        if(!lstNewProductManufacturer.isEmpty())
            insert lstNewProductManufacturer;
        
        if(isRepeat)
        {
            //Fetching the Prefix of Object Product_Manufacturer_Master__c
            Schema.DescribeSObjectResult dsr = Product_Manufacturer_Master__c.SObjectType.getDescribe();
            
            //Redirect to the standard detail page of the Product Manufacturer.
            PageReference stdProductManufacturer = new PageReference('/' + dsr.getKeyPrefix() + '/o');//IsEditPage ? new PageReference('/apex/AddProducts') :
 												                
            return stdProductManufacturer;
        }   
        return null;
    }
    
    /*Function to remove selected rows from the table*/
    public void removeRows()
    {       
        //List of records which are selected to remove from table
        List<ProductManufacturer> lstPM = new List<ProductManufacturer>();
        if(lstProductManufacturer.size()  == 3)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.At_least_3_Product_Manufacturers));
            return ;
        }
        
        Integer removeRowCount = 0;
        //Added unselected records in the lstPM list
        for(ProductManufacturer objPM : lstProductManufacturer)
        {
            if(!objPM.isRemove)
                lstPM.add(objPM);
            else
                removeRowCount++;
        }
        Integer total = lstProductManufacturer.size() - removeRowCount;
        
        if(total <= 2)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.At_least_3_Product_Manufacturers));
            return;
        }
        
        //Cleared original list and added the new list in the original    
        lstProductManufacturer = new List<ProductManufacturer>();
        lstProductManufacturer.addAll(lstPM);
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