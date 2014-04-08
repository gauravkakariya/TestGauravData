/* 
*   
*  This class used for add Product Name and calculate their payment amount .
*
*   Revision History:
*
*   Version         Author             Date          Description
*   1.0             Gaurav Kakariya    26/03/2013    Initial Draft
*/

public class PurchasedServicesController 
{
    public String entityId{get;set;}
    public String selectedProductName{get;set;}
    
    public String selectedTopUpGoals{get;set;}
    private String strSelectedValueAddedService{get;set;}
    public List<WrapperPurchaseOrder>  lstWrapperPurchaseOrder{get;set;}
    
    public List<SelectOption> options {get;set;}
    public List<SelectOption> serviceNameOptions{get;set;}
    public List<SelectOption> topUpGoalValueOptions{get;set;}
    
    public Product_Master__c objProductMaster{get;set;}
    public Product_Price_Book__c objPriceBook{get;set;}
    public Purchase_Order__c objProductOrder {get;set;}
    
    public Boolean isErrorMsg{get;set;}
    public Boolean isTopUpBlock{get;set;}
    public Boolean isAlreadyInserted{get;set;}
    
    public Double baseProudctPayableAmount {get;set;}
    
    //Goal Section Handling Variables
    public Double topUpGoalPrice {get;set;}
    public Double topUpGoalDiscount {get;set;}
    public Double topUpPayableAmount {get;set;}
    
    public Double topUpGoalBasePrice {get;set;}
    public Double topUpGoalBaseDiscount{get;set;}
    //Constructor
    public PurchasedServicesController()
    {
        isErrorMsg = false;
        isAlreadyInserted = false;
        entityId = ApexPages.currentPage().getParameters().get('entityid');
        baseProudctPayableAmount = 0;
        topUpGoalPrice = 0;
        topUpGoalDiscount = 0;
        topUpPayableAmount = 0;
        lstWrapperPurchaseOrder = new List<WrapperPurchaseOrder>();
        selectedTopUpGoals = '0';
        objPriceBook = new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0);
        objProductMaster = new Product_Master__c(No_of_Goals_Allowed__c = 0);
        objProductOrder = new Purchase_Order__c();
        topUpGoalBasePrice = TopUpGoal__c.getInstance('Top Up').Goal_Price__c;
        topUpGoalBaseDiscount = TopUpGoal__c.getInstance('Top Up').Discount__c;
        //topUpGoalDiscount = topUpGoalBaseDiscount;
        lstWrapperPurchaseOrder.add(new WrapperPurchaseOrder(new Product_Master__c(), new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0), 
                                        lstWrapperPurchaseOrder.size()));
        
        baseProductList();
        valueAddedServiceList();
        topUpCountList();
    }
    
    private void baseProductList()
    {
        options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        for(Product_Master__c objProductMaster : [Select Product_Name__c, ProductType__c From Product_Master__c Where ProductType__c ='Base Product' and Is_Active__c = true
                                                  order by Base_Product_Weightage__c ])
        {
            options.add(new SelectOption(objProductMaster.Product_Name__c,objProductMaster.Product_Name__c));
        }
        
    }
    
    private void valueAddedServiceList()
    {
        //Picklist Value for Servie Name in Value Added Service
        serviceNameOptions = new List<SelectOption>();
        serviceNameOptions.add(new SelectOption('None','--None--'));
        for(Product_Master__c objProductMaster : [Select Product_Name__c, ProductType__c From Product_Master__c Where ProductType__c ='Value Added Services' and Is_Active__c = true ])
        {
            serviceNameOptions.add(new SelectOption(objProductMaster.Product_Name__c,objProductMaster.Product_Name__c));
        }
        
    }
    
    private void topUpCountList()
    {
        //Picklist Value for Top Up Goals
        topUpGoalValueOptions = new List<SelectOption>();
        for(Integer counter = 0 ; counter < 5; counter ++)
        {
            topUpGoalValueOptions.add(new SelectOption(String.valueOf(counter),String.valueOf(counter)));
        }
    }
    
    
    private Order_Detail__c objOrderDetail;
    /*To save the new entered records*/
    public PageReference saveProduct()
    {
        Boolean isValidRetirementDiff;
    	try
    	{
        	isValidRetirementDiff = FreedomUtils.hasRetirement(entityId);
    	}
    	catch(Exception e)
    	{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please Enter Birthdate / Retirement Age on Entity Page'));
    		return Null;
    	}
        if(!isValidRetirementDiff && selectedProductName.equals('Early Planning for Retirement'))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Retirement year should be at least 7 years away for \'Early Planning for Retirement\''));
            return Null;
        }
        
        List<Purchase_Order__c> lstPurchaseOrder = new List<Purchase_Order__c>();
        Purchase_Order__c objPO = new Purchase_Order__c();
        
        if(selectedProductName == 'None')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please Select atleast one Base Service Product. '));
            return Null; 
        }
        Integer recCount = [Select count() From Purchase_Order__c Where Entity__c =: entityId limit 1];
        String strOrderNumber;
        
        if(recCount == 1)
        {
            String previousOrderNumber = [Select Order__c From Purchase_Order__c Where Entity__c =: entityId order By CreatedDate Desc limit 1].Order__c;
                                            
            List<String> lstOrderNumber = previousOrderNumber.split('/');
            Integer orderNumber = Integer.valueOf(lstOrderNumber[2]) + 1;
            
            strOrderNumber = 'FFP/' + String.valueOf(System.today().year() ).substring(2, 4) + '-' + 
                                             String.valueOf(System.today().year() + 1).substring(2, 4) + '/00' + orderNumber;
        }
        else
        {
            strOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + String.valueOf(System.today().year() + 1).substring(2, 4) + '/001';
        }
        
        createOrderDetail(strOrderNumber);
        System.debug('-------------objOrderDetail-------------------------'+objOrderDetail);
        objPO = new Purchase_Order__c(Order__c = strOrderNumber,
                                        Selected_Product__c = selectedProductName,
                                        Product_Master__c = objProductMaster.Id, 
                                        Entity__c = entityId, 
                                        Product_Type__c = objProductMaster.ProductType__c,
                                        Order_Datetime__c = DateTime.now(),
                                        Product_Price__c = objPriceBook.Price_value__c, 
                                        Discount__c = objPriceBook.Discount__c,
                                        Order_status__c = 'New', 
                                        Payable_Amount__c = objPriceBook.Price_value__c - objPriceBook.Discount__c,
                                        Service_Tax__c = objPriceBook.Service_Tax__c, 
                                        Sp_Education_Cess__c = objPriceBook.Sp_Education_Cess__c, 
                                        VAT__c = objPriceBook.VAT__c, 
                                        Education_Cess__c = objPriceBook.Education_Cess__c,
                                        Renewal_Grace_Days__c = objProductMaster.Renewal_Grace_Days__c, 
                                        Renewal_Period_In_Days__c = objProductMaster.Renewal_Period_In_Days__c,     
                                        Subscription_Period_In_Days__c = objProductMaster.Subscription_Period_In_Days__c,
                                        Is_Cancel__c = false,
                                        Order_Detail__c = objOrderDetail.Id);
        lstPurchaseOrder.add(objPO);
        
        if(selectedTopUpGoals != null && selectedTopUpGoals != '0') 
        { 
            objPO = new Purchase_Order__c(Order__c = strOrderNumber,
                                            Selected_Product__c = 'Top-Up Goals',
                                            Product_Master__c = objProductMaster.Id, 
                                            Entity__c = entityId, 
                                            Product_Type__c = 'Top-Up',
                                            Order_Datetime__c = DateTime.now(),
                                            Product_Price__c = (Integer.valueOf(selectedTopUpGoals) * topUpGoalBasePrice), 
                                            Discount__c = topUpGoalDiscount,
                                            Order_status__c = 'New', 
                                            Payable_Amount__c = (Integer.valueOf(selectedTopUpGoals) * topUpGoalBasePrice) - topUpGoalDiscount,
                                            Service_Tax__c = objPriceBook.Service_Tax__c, 
                                            Sp_Education_Cess__c = objPriceBook.Sp_Education_Cess__c, 
                                            VAT__c = objPriceBook.VAT__c, 
                                            Education_Cess__c = objPriceBook.Education_Cess__c,
                                            Is_Cancel__c = false,
                                            Order_Detail__c = objOrderDetail.Id);
                                            
            lstPurchaseOrder.add(objPO);
        }
        for(WrapperPurchaseOrder objWPO : lstWrapperPurchaseOrder)
        {
            if (objWPO.productMaster.Id == null)
                continue;
            if(objWPO.selectedServiceName != 'None')
            {
                objPO = new Purchase_Order__c(Order__c = strOrderNumber,
                                                Selected_Product__c = objWPO.selectedServiceName,
                                                Product_Master__c = objWPO.productMaster.Id, 
                                                Entity__c = entityId, 
                                                Product_Type__c = objWPO.productMaster.ProductType__c,
                                                Order_Datetime__c = DateTime.now(),
                                                Product_Price__c = objWPO.productPriceBook.Price_value__c,
                                                Description__c = objWPO.descriptionPurchaseOrder, 
                                                Discount__c = objWPO.productPriceBook.Discount__c,
                                                Order_status__c = 'New', 
                                                Payable_Amount__c = objWPO.productPriceBook.Price_value__c - objWPO.productPriceBook.Discount__c,
                                                Service_Tax__c = objWPO.productPriceBook.Service_Tax__c, 
                                                Sp_Education_Cess__c = objWPO.productPriceBook.Sp_Education_Cess__c, 
                                                VAT__c = objWPO.productPriceBook.VAT__c, 
                                                Education_Cess__c = objWPO.productPriceBook.Education_Cess__c,
                                                Is_Cancel__c = false,
                                                Order_Detail__c = objOrderDetail.Id);
                lstPurchaseOrder.add(objPO);
            }
        }
        
        if(!lstPurchaseOrder.isEmpty())
            insert  lstPurchaseOrder;
        //Get the Entity_Global_Assumption__c from Entity and Update that record with related Product Master record .                   
        Entity_Global_Assumption__c objEntityGlobalAssumption = [Select No_of_Goals__c, Gold_Growth_Rate__c, Goals_Allowed_List__c, Financial_Planing_Output_Report__c, 
                                                                                    Data_Collection_Analysis_Control__c, Account__c 
                                                                    From Entity_Global_Assumption__c 
                                                                    Where Account__c =: entityId];
        
        objEntityGlobalAssumption.No_of_Goals__c = objProductMaster.No_of_Goals_Allowed__c + Integer.valueOf(selectedTopUpGoals);
        objEntityGlobalAssumption.Goals_Allowed_List__c = objProductMaster.Goals_Allowed_List__c;
        objEntityGlobalAssumption.Data_Collection_Analysis_Control__c = objProductMaster.Data_Collection_Analysis_Control__c;
        objEntityGlobalAssumption.Financial_Planing_Output_Report__c = objProductMaster.Financial_Planing_Output_Report__c;
        
        update objEntityGlobalAssumption;
        //FreedomUtils.updateRenewalDate(entityId, FreedomUtils.FIRST_PURCHASE);
        FreedomUtils.updateOrderDetails(entityId);
        
        if(selectedProductName == 'Starter Financial Planning' || selectedProductName == 'Early Planning for Retirement')
           FreedomUtils.createRetirementGoal(entityId);
        //Redirect to Entity Detial page.
        PageReference pr = new PageReference('/' + entityId);
        return pr;
    }
    
    
    private void createOrderDetail(String strOrderNumber)
    {
        objOrderDetail = new Order_Detail__c(Order_Number__c = strOrderNumber, Account__c = entityId);
        insert objOrderDetail;
        System.debug('------------- funtion objOrderDetail-------------------------'+objOrderDetail);
    }
    //Getting Product Price
    public void productPrice()
    {
        if(selectedProductName == 'None')
        {
            isErrorMsg = false;
            isTopUpBlock = false;
            objPriceBook = new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0);
            objProductMaster.No_of_Goals_Allowed__c = 0;
            baseProudctPayableAmount = 0;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please select Product Name.'));
            return; 
        }   
          
        if(selectedProductName != 'None')
        {
            isErrorMsg = true;
            isTopUpBlock = false;
                                                                                    
            objProductMaster = [Select Product_Name__c, ProductType__c, Goals_Allowed_List__c, Financial_Planing_Output_Report__c, 
                                       Data_Collection_Analysis_Control__c,No_of_Goals_Allowed__c, IsTopupService__c, Renewal_Grace_Days__c, 
                                       Renewal_Period_In_Days__c,  Subscription_Period_In_Days__c,  
                                       (Select Price_value__c, Discount__c, Service_Tax__c, Sp_Education_Cess__c, VAT__c, Education_Cess__c From Product_Price_Books__r order by CreatedDate desc)  
                                    From Product_Master__c  
                                    Where Product_Name__c =: selectedProductName  order by Base_Product_Weightage__c limit 1];
            objPriceBook = objProductMaster.Product_Price_Books__r[0];
            isTopUpBlock = objProductMaster.IsTopupService__c;
            baseProudctPayableAmount = objPriceBook.Price_value__c - objPriceBook.Discount__c;
        }   
    } 
    
    //Getting Value Added Service
    public void valueAddedService()
    {
        Integer indexPosition = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
        strSelectedValueAddedService = lstWrapperPurchaseOrder[indexPosition].selectedServiceName;
        /*if(strSelectedValueAddedService == 'None')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please select Service Name.'));
            //return;
        }*/
        //If selected Service Name is other than 'None' then get the product price
        if(lstWrapperPurchaseOrder[indexPosition].selectedServiceName != 'None')
        {
            lstWrapperPurchaseOrder[indexPosition].productMaster = [Select Product_Name__c, ProductType__c, No_of_Goals_Allowed__c,
                                                                           (Select Price_value__c, Discount__c, Service_Tax__c, Sp_Education_Cess__c, VAT__c, Education_Cess__c
                                                                                From Product_Price_Books__r) 
                                                                           From Product_Master__c  
                                                                           Where Product_Name__c =:strSelectedValueAddedService And ProductType__c ='Value Added Services'];
            lstWrapperPurchaseOrder[indexPosition].productPriceBook = lstWrapperPurchaseOrder[indexPosition].productMaster.Product_Price_Books__r[0];
            lstWrapperPurchaseOrder[indexPosition].payableAmount = lstWrapperPurchaseOrder[indexPosition].productPriceBook.Price_value__c - 
                                                                    lstWrapperPurchaseOrder[indexPosition].productPriceBook.Discount__c;
        }
        else
        {
            lstWrapperPurchaseOrder[indexPosition].productPriceBook = new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0);
            lstWrapperPurchaseOrder[indexPosition].payableAmount = 0;
        }
        
    }   
    
    //To save Value Addded Services
    public void addValueAddedServices()
    {
        Boolean isNone = false;
        for(WrapperPurchaseOrder objWPO :  lstWrapperPurchaseOrder)
        {
            if(objWPO.selectedServiceName == 'None')
            {
                isNone = true;
                break;
            }
        }
        
        if(isNone)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please select Service Name.'));
            return ;
        }
        
        lstWrapperPurchaseOrder.add(new WrapperPurchaseOrder(new Product_Master__c() , new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0), lstWrapperPurchaseOrder.size()));
    }   

    /*To cancel the new entered records*/
    public PageReference cancelProduct()
    {
        PageReference pr = new PageReference('/' + entityId);
        return pr;
    }
    
    public void deleteService()
    {
        Integer indexPosition = Integer.valueOf(ApexPages.currentPage().getParameters().get('indexNumber'));
        lstWrapperPurchaseOrder.remove(indexPosition);
        
        for(Integer i = indexPosition; i < lstWrapperPurchaseOrder.size() ; i++)
        {
            lstWrapperPurchaseOrder[i].index -= 1; 
        }
    }
    //Wrapper Class
    public class WrapperPurchaseOrder
    {
        public Product_Master__c productMaster{get;set;}
        public Product_Price_Book__c productPriceBook{get;set;}
        public Double payableAmount {get;set;}
        public String selectedServiceName{get;set;}
        public String descriptionPurchaseOrder{get;set;}
        public Integer index {get;set;}     
        public WrapperPurchaseOrder(Product_Master__c pProductMaster, Product_Price_Book__c pProductPriceBook, Integer index)
        {  
            productMaster = pProductMaster;
            productPriceBook = pProductPriceBook;
            payableAmount = productPriceBook.Price_value__c - productPriceBook.Discount__c;
            this.index = index;
        }
        
    }
}