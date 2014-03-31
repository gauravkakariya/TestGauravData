/* 
*  Controller class that acts as an extension of Standard Controller Product_Manufacturer_Master__c 
*  Contains the logic of inserting Data From a AddProductManufacturers VF Page
*
*   Revision History:
*
*   Version         Author             Date          Description
*   1.0         Prajakta Sanap      27/12/2012      Initial Draft
*/

public class AddProductsController 
{
    public List<ProductMaster> lstProductMaster{get;set;}
    public Map<String, Product_Master__c> mapStringToProduct{get;set;}  
    public List<Product_Manufacturer_Master__c> lstProductManufacturer{get;set;}
    public String earnFees{get;set;}
    
    public Boolean isFreedomPrdoductService{get;set;}
    public Boolean isValueAddedService{get;set;}
    public Boolean isOtherProduct{get;set;}
    
    public Product_Master__c objProductMaster {get;set;}
    public Product_Master__c objProductMasterForValueAddedServices {get;set;}
    public String strSelectOption {get;set;}
    private RecordType objRecordType;
    
    //Inner class
    public class ProductMaster
    {
        public Boolean isRemove{get;set;}
        public String strSelectOption {get;set;}
        public Product_Master__c objProductMaster{get;set;}
        
        public ProductMaster(Product_Master__c objProductMaster)
        {
            this.isRemove = false;
            this.objProductMaster = objProductMaster;
        }
    }
    
    /*Constructor*/
    Id recordTypeId;
    public AddProductsController(ApexPages.StandardController controller)
    {
        //Get the Record Type Id and Name of Product_Master__c Object
        Map<Id, RecordType> mapIdToRecordType = new Map<Id, RecordType>([Select Id, Name  From RecordType Where SobjectType = 'Product_Master__c']);
            
        objProductMaster = new Product_Master__c();
        objProductMasterForValueAddedServices = new Product_Master__c();                                                                 
        objRecordType = new RecordType();
        
        objRecordType =  mapIdToRecordType.get(ApexPages.currentPage().getParameters().get('RecordType')); 
        System.debug('------------RecordType----------'+ApexPages.currentPage().getParameters().get('RecordType')) ;
        recordTypeId = Id.valueOf(ApexPages.currentPage().getParameters().get('RecordType'));
        //Compare RecordType Name With Ffreedom Product Services
        if(objRecordType.Name.compareTo('Ffreedom Product Services') == 0)
        {
            isFreedomPrdoductService = true;
            isValueAddedService = false; 
            isOtherProduct = false;
        }   
        else if(objRecordType.Name.compareTo('Value Added Services') == 0) 
        {
            isFreedomPrdoductService = false;
            isValueAddedService = true;
            isOtherProduct = false;
        }
        else
        {   
            isFreedomPrdoductService = false;
            isValueAddedService = false;
            isOtherProduct = true;                                                       
            lstProductMaster = new List<ProductMaster>();
            lstProductManufacturer = new List<Product_Manufacturer_Master__c>();
            lstProductManufacturer = [Select Short_Code__c, Name, Is_Active__c From Product_Manufacturer_Master__c where Is_Active__c  = true order by Name Asc];
            for(Integer iCount = 0; iCount < 3 ;iCount ++)
            {
                addRow();
            } 
        }   
    }
    
    /*Add new blank row in the existing table*/
    public void addRow() 
    {
        lstProductMaster.add(new ProductMaster(new Product_Master__c()));
    }
    
    
    /*To save the new entered records*/
    public PageReference saveProduct()
    {
        //Verifying the if Record Type is Ffreedom Product Services then Insert Record. 
        if(isFreedomPrdoductService)
        {
            try
            {
                objProductMaster.ProductType__c = strSelectOption;
                objProductMaster.RecordTypeId = recordTypeId;
                insert objProductMaster;
                //Fetching the Prefix of Object Product_Master__c
                Schema.DescribeSObjectResult dsr = Product_Master__c.SObjectType.getDescribe();
                PageReference cancel = new PageReference('/' + dsr.getKeyPrefix() + '/o');
                cancel.setRedirect(true);
                return cancel;                  
                
            }
            catch(Exception ex)
            {
                return null;
            }
            
        }
        else if(isValueAddedService)
        {
            try
            {
                objProductMasterForValueAddedServices.ProductType__c = strSelectOption;
                objProductMasterForValueAddedServices.RecordTypeId = recordTypeId;
                insert objProductMasterForValueAddedServices;
                //Fetching the Prefix of Object Product_Master__c
                Schema.DescribeSObjectResult dsr = Product_Master__c.SObjectType.getDescribe();
                PageReference cancel = new PageReference('/' + dsr.getKeyPrefix() + '/o');
                cancel.setRedirect(true);
                return cancel;                  
                
            }
            catch(Exception ex)
            {
                return null;
            }
            
        }
        else
        {
            //List of records in the standard objects
            List<Product_Master__c> lstSaveProduct = [Select SIP_Allowed__c,
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
                                                            From Product_Master__c];
            //List of records inserted by VF page
            List<Product_Master__c> lstNewProduct = new List<Product_Master__c>();
            Boolean isRepeat = false;
            
            //Created set of String for product Manufacturer name
            Set<String> setKeyValue = new Set<String>();
            system.debug('--------------lstSaveProduct---'+lstSaveProduct);
            for(Product_Master__c objProductMasterSet : lstSaveProduct)
            {
                String strName = objProductMasterSet.Product_Name__c.trim().toLowerCase();
                setKeyValue.add(strName);
            }
            
            if(lstProductManufacturer.size() > 0)
            {
                for(ProductMaster objSaveProductMaster : lstProductMaster)
                {
                    Product_Master__c productMaster = objSaveProductMaster.objProductMaster;
                    
                    productMaster.ProductType__c = objSaveProductMaster.strSelectOption;
                    productMaster.RecordTypeId = recordTypeId;
                    String strKey = productMaster.Product_Name__c;
                    
                    if(productMaster.Product_Name__c != null && productMaster.Product_Name__c != '')
                    {
                        if(productMaster.ProductType__c != null && productMaster.ProductType__c != '')
                        {
                            if(!productMaster.Currently_Recommended__c.equals('Yes'))// || productMaster.Currently_Recommended__c == null)
                            {
                                strKey = strKey.trim().toLowerCase();
                                //If set does not contain strKey, then insert record in the list
                                if(!setKeyValue.contains(strKey))
                                {
                                    isRepeat = true;
                                    lstNewProduct.add(productMaster);
                                    setKeyValue.add(strKey);
                                }
                                else//otherwise display error message
                                {   
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Product "'+ productMaster.Product_Name__c + '" Already Exists.'));
                                    return null;
                                }
                            }
                            else
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Currently_Recommended_Cannot_Be_Yes));
                                return null;
                            }
                        }
                        else
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Add_Product_Type));
                            return null;
                        }
                    }
                    else if((productMaster.Product_Name__c == null || productMaster.Product_Name__c == '') && 
                            (productMaster.ProductType__c == null || productMaster.ProductType__c == ''))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Add_one_record));
                        continue;
                    }
                    else if(productMaster.Product_Name__c == null || productMaster.Product_Name__c == '')
                    { 
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Fill_Product_Name));
                        return null;
                    }
                    if(productMaster.Earn_One_Time_Fees__c == true && (productMaster.Earn_Trail_Fees__c == true || productMaster.Earn_Upfront_Fees__c == true))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Earn_Fees));
                        return null;
                    }
                }
            }
            else
            {
                String err = ' Click <font size="3" face="Arial" color="red"><a href="' + Page.AddProductManufacturers.getURL() + '">here</a></font>';
                ApexPages.Message msgErr = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Add_Product_Manufacturer + err + Label.to_Add_Product_Manufactuer);
                ApexPages.addmessage(msgErr);
            }
            //Insert all Product Master records in DB
            if(!lstNewProduct.isEmpty())
            {
                insert lstNewProduct;
            }
            
            if(isRepeat)
            {
                //Fetching the Prefix of Object Product_Master__c
                Schema.DescribeSObjectResult dsr = Product_Master__c.SObjectType.getDescribe();
                //Redirect to the standard detail page of the Product Master.
                Pagereference stdProductMaster = new Pagereference('/' + dsr.getKeyPrefix() + '/o');
                return stdProductMaster;
            }
        }//else 
        return null;    
    }
    
    /*Function to remove selected rows from the table*/
    public void removeRows()
    {       
        //List of records which are selected to remove from table
        List<ProductMaster> lstPM = new List<ProductMaster>();
        if(lstProductMaster.size()  == 3)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.At_least_3_products));
            return ;
        }
            
        //Added unselected records in the above list
        Integer removeRowCount = 0;
        for(ProductMaster productMaster : lstProductMaster)
        {
            if(!productMaster.isRemove)
                lstPM.add(productMaster);
            else
                removeRowCount++;
        }
          
        Integer total = lstProductMaster.size() - removeRowCount;
        if(total <= 2)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.At_least_3_products));
            return;
        }
        //Cleared original list and added the new list in the original
        lstProductMaster = new List<ProductMaster>();
        lstProductMaster.addAll(lstPM);
    }   
    
    /*Cancels the operation and returns to the main Product Master Tab page*/
    public PageReference cancelProduct()
    {
        //Fetching the Prefix of Object Product_Master__c
        Schema.DescribeSObjectResult dsr = Product_Master__c.SObjectType.getDescribe();
        PageReference cancel = new PageReference('/' + dsr.getKeyPrefix() + '/o');
        cancel.setRedirect(true);
        return cancel;
    }
    
    /*To get picklist values of Product_Manufacturer__r.Name*/
    public List<selectOption> getProdManName()
    {
        List<selectOption> options = new List<selectOption>();
        for(Product_Manufacturer_Master__c objProductManufacturer : lstProductManufacturer) 
        {
            options.add(new selectOption(objProductManufacturer.Id, objProductManufacturer.Name));
        }
        return options;
    }
    
    
}