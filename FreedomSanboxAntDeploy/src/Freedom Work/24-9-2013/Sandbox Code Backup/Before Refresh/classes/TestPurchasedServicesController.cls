/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 
 */
@isTest(seeAllData= true)
private class TestPurchasedServicesController {

    static testMethod void testPurchsedServicesController() {
        
        Product_Manufacturer_Master__c objProductManufacturer = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance1', Short_Code__c='HDFCLI', Is_Active__c=true);
        insert objProductManufacturer;
        
        //Insert Product Master record
        Product_Master__c objProductMaster = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=false, Product_Name__c='Starter Financial Planning', ProductType__c='Base Product',
                                                            Subscription_Period_In_Days__c = 365, No_of_Goals_Allowed__c = 3 ,Renewal_Period_In_Days__c = 365,Base_Product_Weightage__c=1,
                                                            Renewal_Grace_Days__c = 30);
        insert objProductMaster;
        
        //Insert Product Master record
        Product_Master__c objProductMaster1 = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=false, Product_Name__c='Will1', ProductType__c='Value Added Services',
                                                            Subscription_Period_In_Days__c = 365, Renewal_Period_In_Days__c = 365,Base_Product_Weightage__c=1,
                                                            Renewal_Grace_Days__c = 30);
        insert objProductMaster1;
        
        //Insert Product Price Book record
        Product_Price_Book__c objPriceBook = new Product_Price_Book__c(Product_code__c = objProductMaster.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6);
        insert objPriceBook;    
        
        
        //Insert Product Price Book record
        Product_Price_Book__c objPriceBook1 = new Product_Price_Book__c(Product_code__c = objProductMaster1.Id, Price_value__c = 1500, Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6);
        insert objPriceBook1;
        
        
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
                           PersonTitle='TestData', PersonBirthdate = system.today().addYears(- 25), PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb', Residential_Status_del__c='own',Retirement_Age__c='30',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c ,Will__c = true); 
        insert objAccount;
        ApexPages.currentPage().getParameters().put('entityid', String.valueOf(objAccount.Id));
        PurchasedServicesController objPurchasedServices1 = new PurchasedServicesController();
        objPurchasedServices1.selectedProductName = 'None';
        objPurchasedServices1.saveProduct();
        
        //Insert Entity record
        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
                           PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c ,Will__c = true);   
        insert objAccount1;
        
       
        Test.startTest(); 
        
        ApexPages.currentPage().getParameters().put('entityid', String.valueOf(objAccount1.Id));
        PurchasedServicesController objPurchasedServices = new PurchasedServicesController();
        objPurchasedServices.selectedProductName = 'None';
        objPurchasedServices.saveProduct();
        
        objPurchasedServices.selectedProductName = 'Starter Financial Planning';    
        objPurchasedServices.selectedTopUpGoals = '1';
        objPurchasedServices.productPrice(); 
        objPurchasedServices.addValueAddedServices();
        objPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'None';
        objPurchasedServices.addValueAddedServices();
        objPurchasedServices.cancelProduct();
        objPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'Will1';
        ApexPages.currentPage().getParameters().put('index', '0');
        objPurchasedServices.valueAddedService();
        objPurchasedServices.lstWrapperPurchaseOrder[0].selectedServiceName = 'None';
        ApexPages.currentPage().getParameters().put('index', '0');
        objPurchasedServices.valueAddedService();
        objPurchasedServices.saveProduct();
        objPurchasedServices.selectedProductName = 'None';
        objPurchasedServices.productPrice();
        ApexPages.currentPage().getParameters().put('indexNumber', '0');
        objPurchasedServices.deleteService();
        Test.stopTest();                                        
    }
    
    
}//end of PurchasedServicesControllerTest class