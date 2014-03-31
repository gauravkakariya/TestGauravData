@isTest(seealldata= true)
private class TestEditPurchasedServicesController 
{
    static testMethod void testEditPurchsedServicesController() 
    {
        Product_Manufacturer_Master__c objProductManufacturer = new Product_Manufacturer_Master__c(Name='Freedom', Short_Code__c='HDFCLI', Is_Active__c = true);
        insert objProductManufacturer;
        
        //Insert Product Master record
        List<Product_Master__c> lstPM = new List<Product_Master__c>();
        Product_Master__c objProductMaster = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=false, Product_Name__c='Starter Financial Planning1', ProductType__c='Base Product',
                                                            Subscription_Period_In_Days__c = 365, No_of_Goals_Allowed__c = 3 ,Renewal_Period_In_Days__c = 365,Base_Product_Weightage__c=1,
                                                            Renewal_Grace_Days__c = 30, Goals_Allowed_List__c ='Marriage;Other', Data_Collection_Analysis_Control__c= 'Introduction1', Financial_Planing_Output_Report__c= 'Introduction1');
                                                            
        lstPM.add(objProductMaster);
        
        //Insert Product Master record
        Product_Master__c objProductMaster1 = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=false, Product_Name__c='Risk Planning1', ProductType__c='Base Product',
                                                            Subscription_Period_In_Days__c = 365, No_of_Goals_Allowed__c = 3 ,Renewal_Period_In_Days__c = 365,Base_Product_Weightage__c=2,
                                                            Renewal_Grace_Days__c = 30,Goals_Allowed_List__c ='Marriage;Other', Data_Collection_Analysis_Control__c= 'Introduction1', Financial_Planing_Output_Report__c= 'Introduction1');
                                                            
        lstPM.add(objProductMaster1);
        
        //Insert Product Master record
        Product_Master__c objProductMaster2 = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=false, Product_Name__c='Will1', ProductType__c='Value Added Services',
                                                            Subscription_Period_In_Days__c = 365, Renewal_Period_In_Days__c = 365,Base_Product_Weightage__c=1,
                                                            Renewal_Grace_Days__c = 30,Goals_Allowed_List__c ='Marriage;Other', Data_Collection_Analysis_Control__c= 'Introduction1', Financial_Planing_Output_Report__c= 'Introduction1');
        lstPM.add(objProductMaster2);
        
        Product_Master__c objProductMaster3 = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=false, Product_Name__c='Tax Planning1', ProductType__c='Value Added Services',
                                                            Subscription_Period_In_Days__c = 365, Renewal_Period_In_Days__c = 365,Base_Product_Weightage__c=1,
                                                            Renewal_Grace_Days__c = 30,Goals_Allowed_List__c ='Marriage;Other', Data_Collection_Analysis_Control__c= 'Introduction1', Financial_Planing_Output_Report__c= 'Introduction1');
        lstPM.add(objProductMaster3);
        insert lstPM;
        
        List<Product_Price_Book__c> lstPPB = new List<Product_Price_Book__c>();
        //Insert Product Price Book record
        Product_Price_Book__c objPriceBook = new Product_Price_Book__c(Product_code__c = objProductMaster.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6,Flat_Commission__c =1010);
        lstPPB.add(objPriceBook);   
        
        
        
        //Insert Product Price Book record
        Product_Price_Book__c objPriceBook1 = new Product_Price_Book__c(Product_code__c = objProductMaster1.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6,Flat_Commission__c =1010);
        lstPPB.add(objPriceBook1);
        
        //Insert Product Price Book record
        Product_Price_Book__c objPriceBook2 = new Product_Price_Book__c(Product_code__c = objProductMaster2.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6,Flat_Commission__c =1010);
        lstPPB.add(objPriceBook2);  
        
        Product_Price_Book__c objPriceBook3 = new Product_Price_Book__c(Product_code__c = objProductMaster3.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6, Flat_Commission__c =1030);
        lstPPB.add(objPriceBook3);  
        
        insert lstPPB;
        
        Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId = RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
    	insert 	objGeneralAccount;
        
        //Insert Entity record
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',Virtual_Partner__c = objGeneralAccount.Id,
                           PersonTitle='TestData',PersonBirthdate=system.today().addYears(-25),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c ,Will__c = true);   
        insert objAccount;
        
       Entity_Global_Assumption__c objGA = [select Id, No_of_Goals__c from Entity_Global_Assumption__c where Account__c =: objAccount.Id limit 1];
       objGA.No_of_Goals__c = 2;
       update objGA;
        
        String strNewOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + 
                                         String.valueOf(System.today().year() + 1).substring(2, 4) + '/001' ;   
        Order_Detail__c objOrderDetail = new Order_Detail__c(Order_Number__c = strNewOrderNumber, Account__c = objAccount.Id );
        insert objOrderDetail;
        
        list<Purchase_Order__c> lstPO = new List<Purchase_Order__c>();
        
        Purchase_Order__c  objPurchaseOrder = new Purchase_Order__c(Product_Master__c= objProductMaster2.Id, 
                                                                        Entity__c= objAccount.Id, 
                                                                        Is_Cancel__c= false,
                                                                        Product_Type__c='Base Product',
                                                                        Selected_Product__c = 'Starter Financial Planning1', 
                                                                        Order_Status__c= 'New', 
                                                                        Order__c = strNewOrderNumber,
                                                                        Subscription_Period_In_Days__c = 365, 
                                                                        Renewal_Period_In_Days__c = 365,
                                                                        Renewal_Grace_Days__c = 30,
                                                                        Product_Price__c = 3998,
                                                                        Discount__c = 100,
                                                                        Payable_Amount__c = 3898, Order_Detail__c = objOrderDetail.Id);
        lstPO.add(objPurchaseOrder);
        
        Purchase_Order__c  objPurchaseOrder1 = new Purchase_Order__c(Product_Master__c= objProductMaster.Id, 
                                                                        Entity__c= objAccount.Id, 
                                                                        Is_Cancel__c= false,
                                                                        Product_Type__c='Value Added Services',
                                                                        Selected_Product__c = 'Will1', 
                                                                        Order_Status__c= 'New', 
                                                                        Order__c = strNewOrderNumber,
                                                                        Subscription_Period_In_Days__c = 365, 
                                                                        Renewal_Period_In_Days__c = 365,
                                                                        Renewal_Grace_Days__c = 30,
                                                                        Product_Price__c = 3998,
                                                                        Discount__c = 100,
                                                                        Payable_Amount__c = 3898, Order_Detail__c = objOrderDetail.Id);
       lstPO.add(objPurchaseOrder1);
        
        Purchase_Order__c  objPurchaseOrder2 = new Purchase_Order__c(Product_Master__c= objProductMaster.Id, 
                                                            Entity__c= objAccount.Id, Is_Cancel__c= false,Product_Type__c='Top-Up',
                                                            Subscription_Period_In_Days__c = 365, Renewal_Period_In_Days__c = 365,
                                                            Renewal_Grace_Days__c = 30, Selected_Product__c = 'top up', Order_Status__c= 'New', 
                                                            Order__c = strNewOrderNumber,
                                                            Product_Price__c = 3998,
                                                            Discount__c = 100,
                                                            Payable_Amount__c = 3898, Order_Detail__c = objOrderDetail.Id);
        lstPO.add(objPurchaseOrder2);
        insert lstPO;
        
        Test.startTest();
       
        ApexPages.currentPage().getParameters().put('entityid', String.valueOf(objAccount.Id));
        EditPurchasedServicesController objEditPurchasedServices = new EditPurchasedServicesController();
        
        ApexPages.currentPage().getParameters().put('baseproductName', 'Starter Financial Planning1');
        ApexPages.currentPage().getParameters().put('baseproductName', 'Risk Planning1');
        objEditPurchasedServices.baseProductPrice();
        objEditPurchasedServices.saveProduct();
       
        objEditPurchasedServices.addValueAddedServices();
        ApexPages.currentPage().getParameters().put('index', '0');
        objEditPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'Tax Planning1';
        objEditPurchasedServices.valueAddedService();
        objEditPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'None';
        objEditPurchasedServices.addValueAddedServices();
        ApexPages.currentPage().getParameters().put('indexNumber', '0');
        objEditPurchasedServices.deleteService();
        Test.stopTest();
        /*objEditPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'Will1';
        ApexPages.currentPage().getParameters().put('index', '0');
        objEditPurchasedServices.valueAddedService();
        objEditPurchasedServices.saveProduct();*/
                                                        
    }
    /*
    static testMethod void testEditPurchsedServicesController1() 
    {
        Product_Manufacturer_Master__c objProductManufacturer = new Product_Manufacturer_Master__c(Name='Freedom', Short_Code__c='HDFCLI', Is_Active__c = true);
        insert objProductManufacturer;
        
        //Insert Product Master record
        List<Product_Master__c> lstPM = new List<Product_Master__c>();
      
        //Insert Product Master record
        Product_Master__c objProductMaster2 = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=false, Product_Name__c='Will1', ProductType__c='Value Added Services',
                                                            Subscription_Period_In_Days__c = 365, Renewal_Period_In_Days__c = 365,Base_Product_Weightage__c=1,
                                                            Renewal_Grace_Days__c = 30,Goals_Allowed_List__c ='Marriage;Other', Data_Collection_Analysis_Control__c= 'Introduction1', Financial_Planing_Output_Report__c= 'Introduction1');
        lstPM.add(objProductMaster2);
     
        insert lstPM;
        
        List<Product_Price_Book__c> lstPPB = new List<Product_Price_Book__c>();
        //Insert Product Price Book record
               
        Product_Price_Book__c objPriceBook3 = new Product_Price_Book__c(Product_code__c = objProductMaster2.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6, Flat_Commission__c =1030);
        lstPPB.add(objPriceBook3);  
        
        insert lstPPB;
        
        Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId = RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
    	insert 	objGeneralAccount;
        
        //Insert Entity record
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',Virtual_Partner__c = objGeneralAccount.Id,
                           PersonTitle='TestData',PersonBirthdate=system.today().addYears(-25),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c ,Will__c = true);   
        insert objAccount;
        
       Entity_Global_Assumption__c objGA = [select Id, No_of_Goals__c from Entity_Global_Assumption__c where Account__c =: objAccount.Id limit 1];
       objGA.No_of_Goals__c = 2;
       update objGA;
        
        String strNewOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + 
                                         String.valueOf(System.today().year() + 1).substring(2, 4) + '/001' ;   
        Order_Detail__c objOrderDetail = new Order_Detail__c(Order_Number__c = strNewOrderNumber, Account__c = objAccount.Id );
        insert objOrderDetail;
        
        Purchase_Order__c  objPurchaseOrder = new Purchase_Order__c(Product_Master__c= objProductMaster2.Id, 
                                                                        Entity__c= objAccount.Id, 
                                                                        Is_Cancel__c= false,
                                                                        Product_Type__c='Value Added Services',
                                                                        Selected_Product__c = 'Will1', 
                                                                        Order_Status__c= 'New', 
                                                                        Order__c = strNewOrderNumber,
                                                                        Subscription_Period_In_Days__c = 365, 
                                                                        Renewal_Period_In_Days__c = 365,
                                                                        Renewal_Grace_Days__c = 30,
                                                                        Product_Price__c = 3998,
                                                                        Discount__c = 100,
                                                                        Payable_Amount__c = 3898, Order_Detail__c = objOrderDetail.Id);
        insert objPurchaseOrder;
        
       
        
        ApexPages.currentPage().getParameters().put('entityid', String.valueOf(objAccount.Id));
        EditPurchasedServicesController objEditPurchasedServices = new EditPurchasedServicesController();
        
      
        //ApexPages.currentPage().getParameters().put('baseproductName', 'Starter Financial Planning1');
        //objEditPurchasedServices.baseProductPrice();
        objEditPurchasedServices.addValueAddedServices();
        ApexPages.currentPage().getParameters().put('index', '0');
        objEditPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'Will1';
        objEditPurchasedServices.valueAddedService();
        objEditPurchasedServices.saveProduct();
       
        /*objEditPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'Will1';
        ApexPages.currentPage().getParameters().put('index', '0');
        objEditPurchasedServices.valueAddedService();
        objEditPurchasedServices.saveProduct();
                                                        
	}
	*/
}