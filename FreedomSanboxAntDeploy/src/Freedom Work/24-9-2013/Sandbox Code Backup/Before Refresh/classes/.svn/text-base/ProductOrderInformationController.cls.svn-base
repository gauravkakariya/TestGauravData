public class ProductOrderInformationController 
{
    public List<PurchaseOrderDetail> lstPurchaseOrderDetail {get;set;}
    public Id entityId {get;set;}
    public Purchase_Order__c objPurchaseOrder{get;set;}
    public Double totalPaybleAmount{get;set;}
    public Boolean isEditPurchasedOrder {get;set;}
    //public Boolean isRenewal{get;set;}
    public Boolean isRenewalAndPurchaseServices{get;set;}
    public ProductOrderInformationController(ApexPages.StandardController controller)
    {
        entityId = controller.getId();
        //isRenewal = FreedomUtils.hasRenewalPeriod(entityId);
        try
        {
            Purchase_Order__c objPO = [Select Product_Master__r.IsRenewalAllowed__c from Purchase_Order__c where Entity__c =: entityId and Product_Type__c = 'Base Product'
                                                and Is_Cancel__c = false];
            isRenewalAndPurchaseServices = objPO.Product_Master__r.IsRenewalAllowed__c;
            /*Boolean isCheck = [Select Is_Renew__c from Renewal__c where Entity__c =: entityId order by CreatedDate limit  1].Is_Renew__c;
            if(isRenewal && isCheck)
            {
                isRenewal = !isCheck;
            }*/
        }
        catch(Exception e)
        {
            isRenewalAndPurchaseServices = true;
        }
        createPurchaseOrderDetail();
    }
    
    private void createPurchaseOrderDetail()
    {
        totalPaybleAmount = 0;
        Set<String> setOrder = new Set<String>();
        objPurchaseOrder = new Purchase_Order__c();
        lstPurchaseOrderDetail = new List<PurchaseOrderDetail>();
        isEditPurchasedOrder = false;
        
        for(Purchase_Order__c objPurchaseOrder : [Select Id, Order__c, VAT__c, Education_Cess__c,Sp_Education_Cess__c, Service_Tax__c, Product_Type__c, Product_Price__c, 
                                                         Product_Master__c, Is_Cancel__c, Discount__c,Renewal_Grace_Days__c, Renewal_Period_In_Days__c,     
                                                         Subscription_Period_In_Days__c,Total_Tax__c, 
                                                         Selected_Product__c, Entity__c,  Payable_Amount__c, Product_Master__r.Product_Name__c , Order_Status__c
                                                    From Purchase_Order__c
                                                    Where Entity__c =: entityId and Is_Cancel__c = false order by CreatedDate])
        { 
            if(!setOrder.contains(objPurchaseOrder.Order__c))
            {
                lstPurchaseOrderDetail.add(new PurchaseOrderDetail(objPurchaseOrder.Order__c, objPurchaseOrder.Order_status__c, objPurchaseOrder));
                setOrder.add(objPurchaseOrder.Order__c);
            }
            else
            {
                lstPurchaseOrderDetail.add(new PurchaseOrderDetail('', '', objPurchaseOrder));
            }
            
            if(!objPurchaseOrder.Is_Cancel__c)
                totalPaybleAmount += objPurchaseOrder.Payable_Amount__c;
        }
        try
        {
            objPurchaseOrder = [Select Product_Master__c, Is_Cancel__c, Discount__c,Renewal_Grace_Days__c, Renewal_Period_In_Days__c,   
                                   Subscription_Period_In_Days__c
                              From Purchase_Order__c
                              Where Entity__c =: entityId And  Is_Cancel__c = false and Product_Type__c = 'Base Product' order by CreatedDate];
            isEditPurchasedOrder = true;
        }
        catch(Exception e)
        {
            System.debug('------------------'+e);
        }
        
    }
    
    public class PurchaseOrderDetail
    {
        public String purchaseOrder {get;set;}
        public String orderStatus {get;set;}
        public Purchase_Order__c objPurchaseOrder{get;set;}
        
        public PurchaseOrderDetail(String purchaseOrder, String orderStatus, Purchase_Order__c objPurchaseOrder)
        {
            this.purchaseOrder = purchaseOrder;
            this.orderStatus = orderStatus;
            this.objPurchaseOrder = objPurchaseOrder;
        }
    }
    
    @isTest(SeeAllData = true)
    public static void testProductOrderInformationController()
    {
        Product_Manufacturer_Master__c PM1 = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance1', Short_Code__c='HDFCLI', Is_Active__c=true);
        insert PM1;
        
        // Insert Product record
        Product_Master__c objProduct = new Product_Master__c(Product_Manufacturer__c=PM1.Id, 
                                                            Is_Active__c=false, Product_Name__c='Risk Plan', ProductType__c='Base Product',
                                                            Subscription_Period_In_Days__c = 365, Renewal_Period_In_Days__c = 365,
                                                            Renewal_Grace_Days__c = 30);
        insert objProduct;                                                      
        Product_Price_Book__c objPriceBook = new Product_Price_Book__c(Product_code__c = objProduct.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6);
        insert objPriceBook;    
        
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
                           PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);    
        insert objAccount;  
        
        ApexPages.StandardController std = new ApexPages.StandardController(objAccount);        
        ProductOrderInformationController objPIC = new ProductOrderInformationController(std);  
        
        Purchase_Order__c objPO = new Purchase_Order__c(Order__c = 'FFP/001', VAT__c = 4, Education_Cess__c = 5,Sp_Education_Cess__c = 6, Service_Tax__c = 7, 
                                                         Product_Type__c = 'Base Product', Product_Price__c = 1500, 
                                                         Product_Master__c = objProduct.Id, Is_Cancel__c = false, Discount__c = 500, 
                                                         Renewal_Grace_Days__c = 30, Renewal_Period_In_Days__c = 365,   
                                                         Subscription_Period_In_Days__c = 365,
                                                         Selected_Product__c = 'Risk Plan', Entity__c = objAccount.Id, Payable_Amount__c = 1000, Order_Status__c = 'New');
        insert objPO;   
        
        Purchase_Order__c objPO1 = new Purchase_Order__c(Order__c = 'FFP/001', VAT__c = 4, Education_Cess__c = 5,Sp_Education_Cess__c = 6, Service_Tax__c = 7, 
                                                         Product_Type__c = 'Base Product 1', Product_Price__c = 1500, 
                                                         Product_Master__c = objProduct.Id, Is_Cancel__c = false, Discount__c = 500, 
                                                         Renewal_Grace_Days__c = 30, Renewal_Period_In_Days__c = 365,   
                                                         Subscription_Period_In_Days__c = 365,
                                                         Selected_Product__c = 'Risk Plan 1', Entity__c = objAccount.Id, Payable_Amount__c = 1000, Order_Status__c = 'New');
        insert objPO1;
        
        ProductOrderInformationController objPIC1 = new ProductOrderInformationController(std); 
    }
}