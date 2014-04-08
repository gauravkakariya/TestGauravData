@isTest(SeeAllData = true)
private class TestPurchaseOrder 
{
    static testMethod void myUnitTest() 
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
        insert lstPM;
        
         Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
                           PersonTitle='TestData',PersonBirthdate=system.today().addYears(-25),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c ,Will__c = true);   
        insert objAccount;
        
         String strNewOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + 
                                         String.valueOf(System.today().year() + 1).substring(2, 4) + '/001' ;   
        Order_Detail__c objOrderDetail = new Order_Detail__c(Order_Number__c = strNewOrderNumber, Account__c = objAccount.Id );
        insert objOrderDetail;
        
        Purchase_Order__c  objPurchaseOrder = new Purchase_Order__c(Product_Master__c= objProductMaster.Id, 
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
        insert objPurchaseOrder;
    }
}