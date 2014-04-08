public with sharing class RenewPurchasedBaseService 
{
    public String entityId{get;set;}
    
    public String selectedProductName{get;set;}
    public String selectedTopUpGoals{get;set;}
    private String strSelectedValueAddedService{get;set;}
    
    public List<SelectOption> options {get;set;}
    public List<SelectOption> serviceNameOptions{get;set;}
    public List<SelectOption> topUpGoalValueOptions{get;set;}
    
    public List<WrapperPurchaseOrder>  lstWrapperPurchaseOrder{get;set;}
    public List<Purchase_Order__c> lstPurchaseOrderForBaseProduct{get;set;}
    
    public Boolean isTopUpBlock{get;set;}
    
    public Purchase_Order__c objProductOrder {get;set;}
    
    //Goal Section Handling Variables
    public Double topUpGoalPrice {get;set;}
    public Double topUpGoalDiscount {get;set;}
    public Double topUpPayableAmount {get;set;}
    
    public Double topUpGoalBasePrice {get;set;}
    public Double topUpGoalBaseDiscount{get;set;}
    
    public Double baseRenewalPrice {get;set;}
    
    private final static String BASE_PRODUCT = 'Base Product';
    //Constructor
    public RenewPurchasedBaseService()
    {
        entityId = ApexPages.currentPage().getParameters().get('entityid');
        
        topUpGoalPrice = 0;
        topUpGoalDiscount = 0;
        topUpPayableAmount = 0;
        selectedTopUpGoals = '0';
        lstWrapperPurchaseOrder = new List<WrapperPurchaseOrder>();
        objProductOrder = new Purchase_Order__c();
        
        topUpGoalBasePrice = TopUpGoal__c.getInstance('Top Up').Goal_Price__c;
        topUpGoalBaseDiscount = TopUpGoal__c.getInstance('Top Up').Discount__c;
        //topUpGoalDiscount = topUpGoalBaseDiscount;
        
        lstPurchaseOrderForBaseProduct = getPurchaseOrderByEntityId(EntityId, BASE_PRODUCT);
        
        if(!lstPurchaseOrderForBaseProduct.IsEmpty())
        {
            isTopUpBlock = lstPurchaseOrderForBaseProduct[0].Product_Master__r.IsTopupService__c;
            lstPurchaseOrderForBaseProduct[0].Discount__c = 0;
            baseRenewalPrice = [select Renewal_price__c from Product_Price_Book__c where Product_code__c =: lstPurchaseOrderForBaseProduct[0].Product_Master__c order by CreatedDate desc].Renewal_price__c;
        }
        
        lstWrapperPurchaseOrder.add(new WrapperPurchaseOrder(new Product_Master__c(), new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0), 
                                        lstWrapperPurchaseOrder.size()));
        
        topUpCountList();
        valueAddedServiceList();
    }
    
    private List<Purchase_Order__c> getPurchaseOrderByEntityId(String entityId, String productType)
    {
        try
        {
            return [Select Id, Name, Service_Tax__c, Product_Type__c, Product_Price__c, Product_Master__c, Is_Cancel__c, Order_Status__c, Order__c,  
                        Discount__c,Entity__c,Payable_Amount__c, Selected_Product__c, Product_Master__r.No_of_Goals_Allowed__c,Product_Master__r.Product_Name__c,
                        Renewal_Grace_Days__c, Renewal_Period_In_Days__c, Subscription_Period_In_Days__c, Product_Master__r.IsTopupService__c   
                        From Purchase_Order__c 
                        Where Entity__c =: entityId 
                            And Is_Cancel__c= false 
                            And Product_Type__c =: productType];
        }
        catch(Exception Ex)
        {
            Error.logError(''+Ex.getMessage());
            return null;
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
    
    public void deleteService()
    {
        Integer indexPosition = Integer.valueOf(ApexPages.currentPage().getParameters().get('indexNumber'));
        lstWrapperPurchaseOrder.remove(indexPosition);
        
        for(Integer i = indexPosition; i < lstWrapperPurchaseOrder.size() ; i++)
        {
            lstWrapperPurchaseOrder[i].index -= 1; 
        }
    }
    
    /*To save the new entered records*/
    public PageReference saveProduct()
    {
        /*
        Boolean isDuplicate = false;
        Set<String> setValueAddedService = new Set<String>();
      
          
        //Checking if duplicate Value Added Service 
        for(WrapperPurchaseOrder objWrapperPurchaseOrder : lstWrapperPurchaseOrder)
        {
            if(!setValueAddedService.contains(objWrapperPurchaseOrder.selectedServiceName))
            setValueAddedService.add(objWrapperPurchaseOrder.selectedServiceName);
            else
            {
                isDuplicate = true;
                break;
            }
        
        }
        if(isDuplicate)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Service Name cannot be duplicate.'));
            return Null;
        }
        
        */
        List<Purchase_Order__c> lstPurchaseOrder = new List<Purchase_Order__c>();
        Purchase_Order__c objPO = new Purchase_Order__c();
        
        Integer recCount = [Select count() From Purchase_Order__c Where Entity__c =: entityId limit 1];
        String strOrderNumber;
        
        if(recCount == 1)
        {
            String previousOrderNumber = [Select Order__c From Purchase_Order__c Where Entity__c =: entityId order By CreatedDate Desc limit 1].Order__c;
                                            
            List<String> lstOrderNumber = previousOrderNumber.split('/');
            Integer orderNumber = Integer.valueOf(lstOrderNumber[2]) + 1;
            
            strOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + 
                                             String.valueOf(System.today().year() + 1).substring(2, 4) + '/00' + orderNumber;
        }
        else
        {
            strOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + String.valueOf(System.today().year() + 1).substring(2, 4) + '/001';
        }
        
        for(Purchase_Order__c obj : [select Is_Cancel__c from Purchase_Order__c where Entity__c =: entityId])
        {
            obj.Is_Cancel__c = true;
            lstPurchaseOrder.add(obj);
        }
        
        if(!lstPurchaseOrder.isEmpty())
        {
            update lstPurchaseOrder;
        }
        
        
        Order_Detail__c objOrderDetail = new Order_Detail__c(Order_Number__c = strOrderNumber, Account__c = entityId);
        insert objOrderDetail;
        
        lstPurchaseOrder = new List<Purchase_Order__c>();
        
        objPO = new Purchase_Order__c(Order__c = strOrderNumber,
                                        Selected_Product__c = lstPurchaseOrderForBaseProduct[0].Selected_Product__c,
                                        Product_Master__c = lstPurchaseOrderForBaseProduct[0].Product_Master__c, 
                                        Entity__c = entityId, 
                                        Product_Type__c = lstPurchaseOrderForBaseProduct[0].Product_Type__c,
                                        Order_Datetime__c = DateTime.now(),
                                        Product_Price__c = baseRenewalPrice, 
                                        Discount__c = lstPurchaseOrderForBaseProduct[0].Discount__c,
                                        Order_status__c = 'New', 
                                        Payable_Amount__c = baseRenewalPrice - lstPurchaseOrderForBaseProduct[0].Discount__c,
                                        Service_Tax__c = lstPurchaseOrderForBaseProduct[0].Service_Tax__c, 
                                        Sp_Education_Cess__c = lstPurchaseOrderForBaseProduct[0].Sp_Education_Cess__c, 
                                        VAT__c = lstPurchaseOrderForBaseProduct[0].VAT__c, 
                                        Education_Cess__c = lstPurchaseOrderForBaseProduct[0].Education_Cess__c,
                                        Renewal_Grace_Days__c = lstPurchaseOrderForBaseProduct[0].Renewal_Grace_Days__c, 
                                        Renewal_Period_In_Days__c = lstPurchaseOrderForBaseProduct[0].Renewal_Period_In_Days__c,    
                                        Subscription_Period_In_Days__c = lstPurchaseOrderForBaseProduct[0].Subscription_Period_In_Days__c,
                                        Is_Cancel__c = false,
                                        Order_Detail__c = objOrderDetail.Id);
        lstPurchaseOrder.add(objPO);
        
        if(selectedTopUpGoals != null && selectedTopUpGoals != '0') 
        {
            objPO = new Purchase_Order__c(Order__c = strOrderNumber,
                                            Selected_Product__c = 'Top-Up Goals',
                                            Product_Master__c = lstPurchaseOrderForBaseProduct[0].Product_Master__c, 
                                            Entity__c = entityId, 
                                            Product_Type__c = 'Top-Up',
                                            Order_Datetime__c = DateTime.now(),
                                            Product_Price__c = (Integer.valueOf(selectedTopUpGoals) * topUpGoalBasePrice), 
                                            Discount__c = topUpGoalDiscount,
                                            Order_status__c = 'New', 
                                            Payable_Amount__c = (Integer.valueOf(selectedTopUpGoals) * topUpGoalBasePrice) - topUpGoalDiscount,
                                            
                                            Service_Tax__c = lstPurchaseOrderForBaseProduct[0].Service_Tax__c, 
                                            Sp_Education_Cess__c = lstPurchaseOrderForBaseProduct[0].Sp_Education_Cess__c, 
                                            VAT__c = lstPurchaseOrderForBaseProduct[0].VAT__c, 
                                            Education_Cess__c = lstPurchaseOrderForBaseProduct[0].Education_Cess__c,
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
                                                Discount__c = objWPO.productPriceBook.Discount__c,
                                                Description__c = objWPO.descriptionPurchaseOrder,
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
        
        insert  lstPurchaseOrder;
        //Get the Entity_Global_Assumption__c from Entity and Update that record with related Product Master record .                   
        Entity_Global_Assumption__c objEntityGlobalAssumption = [Select No_of_Goals__c, Gold_Growth_Rate__c, Goals_Allowed_List__c, Financial_Planing_Output_Report__c, 
                                                                                    Data_Collection_Analysis_Control__c, Account__c 
                                                                    From Entity_Global_Assumption__c 
                                                                    Where Account__c =: entityId Limit 1];
        
        system.debug('**objEntityGlobalAssumption'+objEntityGlobalAssumption);
        objEntityGlobalAssumption.No_of_Goals__c += Integer.valueOf(selectedTopUpGoals);
        
        update objEntityGlobalAssumption;
        FreedomUtils.updateRenewalDate(entityId, FreedomUtils.RENEW_PURCHASE);
        FreedomUtils.updateOrderDetails(entityId);
        
        Renewal__c objRenewal = [Select Id, Is_Renew__c from Renewal__c where Entity__c =:entityId order by CreatedDate limit 1];
        objRenewal.Is_Renew__c = true;
        update objRenewal;
        //Redirect to Entity Detial page.
        PageReference pr = new PageReference('/' + entityId);
        return pr;
    }
    
    
    
    //Getting Value Added Service
    public void valueAddedService()
    {
        Integer indexPosition = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
        strSelectedValueAddedService = lstWrapperPurchaseOrder[indexPosition].selectedServiceName;
        /*if(strSelectedValueAddedService == 'None')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please select Service Name.'));
            return;
        }*/
        //If selected Service Name is other than 'None' then get the product price
        if(lstWrapperPurchaseOrder[indexPosition].selectedServiceName != 'None')
        {
            lstWrapperPurchaseOrder[indexPosition].productMaster = [Select Product_Name__c, ProductType__c, No_of_Goals_Allowed__c,
                                                                           (Select Price_value__c, Discount__c, Service_Tax__c, Sp_Education_Cess__c, VAT__c, Education_Cess__c
                                                                                From Product_Price_Books__r order by CreatedDate desc) 
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
    
    public void topUpGoalValue()
    {
        
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