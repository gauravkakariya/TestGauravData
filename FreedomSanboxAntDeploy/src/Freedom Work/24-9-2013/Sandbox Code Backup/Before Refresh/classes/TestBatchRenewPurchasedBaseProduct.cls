@isTest(seealldata= true)
public class TestBatchRenewPurchasedBaseProduct 
{
    public static testMethod void BatchRenewPurchasedBaseProductTest() 
    {
        
        //Insert Entity record
        Account acc = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
                           PersonTitle='TestData',PersonBirthdate=system.today().addYears(-25),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c ,Will__c = true);   
        insert acc;

        Product_Manufacturer_Master__c objProductManufacturer = new Product_Manufacturer_Master__c(Name='Freedom', Short_Code__c='HDFCLI', Is_Active__c = true);
        insert objProductManufacturer;
        
        //Insert Product Master record
        Product_Master__c objProductMaster = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
                                                            Is_Active__c=true, Product_Name__c='Starter Financial Planning1', 
                                                            ProductType__c='Base Product',
                                                            IsRenewalAllowed__c = true,
                                                            Subscription_Period_In_Days__c = 0, No_of_Goals_Allowed__c = 3,
                                                            Renewal_Period_In_Days__c = 365,
                                                            Base_Product_Weightage__c = 1,
                                                            Renewal_Grace_Days__c = 30, 
                                                            Goals_Allowed_List__c ='Marriage;Other', 
                                                            Data_Collection_Analysis_Control__c= 'Introduction1', 
                                                            Financial_Planing_Output_Report__c= 'Introduction1');
        
        insert objProductMaster;
       
        //Insert Product Price Book record
        Product_Price_Book__c objPriceBook = new Product_Price_Book__c(Product_code__c = objProductMaster.Id, Price_value__c = 1500, 
                                                                        Discount__c= 500,
                                                                        Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, 
                                                                        Education_Cess__c = 6, Renewal_price__c = 1500);
                                                                        
        insert objPriceBook;    
                                                                    
        String strNewOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + 
                                         String.valueOf(System.today().year() + 1).substring(2, 4) + '/001' ;   
                                         
        Order_Detail__c objOrderDetail = new Order_Detail__c(Order_Number__c = strNewOrderNumber, Account__c = acc.Id, 
                                                             Payable_Amount__c = 3000);
        insert objOrderDetail;
        
        Purchase_Order__c  objPurchaseOrder = new Purchase_Order__c(Product_Master__c= objProductMaster.Id, 
                                                                        Entity__c= acc.Id, 
                                                                        Is_Cancel__c= false,
                                                                        Product_Type__c='Base Product',
                                                                        Selected_Product__c = 'Starter Financial Planning1', 
                                                                        Order_Status__c= 'New', 
                                                                        Order__c = strNewOrderNumber,
                                                                        Subscription_Period_In_Days__c = 0, 
                                                                        Renewal_Period_In_Days__c = 365,
                                                                        Renewal_Grace_Days__c = 30,
                                                                        Product_Price__c = 3998,
                                                                        Discount__c = 100,
                                                                        Payable_Amount__c = 3898, Order_Detail__c = objOrderDetail.Id);
        insert objPurchaseOrder;
       
       
       Cheque_Details__c chqDtls =  new Cheque_Details__c(Account__c = acc.Id,Installment__c = '1st',
                                        Cheque_Status__c = 'Deposited',Cheque_No__c = 'C1234',Cheque_Date__c = Date.Today(),
                                        Amount_Received__c = 1000,Order_Detail__c= objOrderDetail.Id);
       insert chqDtls; 
       
       Test.startTest();
       String CRON_EXP = '0 0 0 3 9 ? 2022';
       //Actual cron string String CRON_EXP = '0 0 21 * * ?'
       String jobId = System.schedule('TestBatchRenewPurchasedBaseProduct',CRON_EXP, new SchedulerBatchRenewPurchasedBaseProduct());
       //BatchRenewPurchasedBaseProduct objBatchRenewPurchasedBaseProduct = new BatchRenewPurchasedBaseProduct();
       //Database.executeBatch(objBatchRenewPurchasedBaseProduct);
       Test.stopTest();
    }
}