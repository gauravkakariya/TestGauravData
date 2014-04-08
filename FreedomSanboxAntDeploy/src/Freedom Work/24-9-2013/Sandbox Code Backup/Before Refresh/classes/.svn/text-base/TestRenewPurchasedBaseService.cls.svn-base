/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest(seealldata= true)
private class TestRenewPurchasedBaseService {

       static testMethod void testRenewPurchasedBaseServiceController() 
       {
        
        Product_Manufacturer_Master__c objProductManufacturer = new Product_Manufacturer_Master__c(Name='HDFC Life Insurance1', Short_Code__c='HDFCLI', Is_Active__c=true);
		insert objProductManufacturer;
		
		//Insert Product Master record
		Product_Master__c objProductMaster = new Product_Master__c(Product_Manufacturer__c= objProductManufacturer.Id, 
															Is_Active__c=false, Product_Name__c='Starter Financial Planning1', ProductType__c='Base Product',
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
																		Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6,Renewal_price__c= 100);
		insert objPriceBook;	
		
		
		//Insert Product Price Book record
		Product_Price_Book__c objPriceBook1 = new Product_Price_Book__c(Product_code__c = objProductMaster1.Id, Price_value__c = 1500, Discount__c= 500,
																		Service_Tax__c = 2, Sp_Education_Cess__c = 4, VAT__c = 5, Education_Cess__c = 6);
		insert objPriceBook1;
		
		//Insert Entity record
		Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c	,Will__c = true); //RecTypes__c.getInstance('AccountClient').Record_Type_Value__c	
	    insert objAccount;
	    
	    
	    //Get the Entity_Global_Assumption__c from Entity and Update that record with related Product Master record .                   
        Entity_Global_Assumption__c objEntityGlobalAssumption = [Select No_of_Goals__c, Gold_Growth_Rate__c, Goals_Allowed_List__c, Financial_Planing_Output_Report__c, 
                                                                                    Data_Collection_Analysis_Control__c, Account__c 
                                                                    From Entity_Global_Assumption__c 
                                                                    Where Account__c =: objAccount.Id Limit 1];
         objEntityGlobalAssumption.No_of_Goals__c = 2;  
         update  objEntityGlobalAssumption;                                                 
	    
	    Purchase_Order__c  objPurchaseOrder = new Purchase_Order__c(Product_Master__c= objProductMaster.Id, 
	   	Entity__c= objAccount.Id, Is_Cancel__c= false,Product_Type__c='Base Product',
		Subscription_Period_In_Days__c = 365, Renewal_Period_In_Days__c = 365,
		Payable_Amount__c =0,Service_Tax__c=1,Sp_Education_Cess__c=1,VAT__c=1,Education_Cess__c=1,
		Renewal_Grace_Days__c = 30, Selected_Product__c = 'Starter Financial Planning1', Order_Status__c= 'New', Order__c ='FFP/12-13/001');
	   	insert objPurchaseOrder;
	    
	    Order_Detail__c objOrderDetail = new Order_Detail__c();
	   	objOrderDetail.Account__c = objAccount.Id;
	   	objOrderDetail.Order_Number__c = 'FFP/12-13/001';
	   	insert objOrderDetail; 
	   	
	   	
	    Renewal__c renewal = new Renewal__c(Entity__c = objAccount.Id, Renewal_Date__c = system.today());	
	   	insert renewal;
	   	
	   
		Test.startTest(); // Start  Test
    	PageReference pageRef = Page.RenewPurchasedBaseService;	
    	ApexPages.currentPage().getParameters().put('entityid', String.valueOf(objAccount.Id));
    	ApexPages.currentPage().getParameters().put('index', String.valueOf(1));
    	ApexPages.currentPage().getParameters().put('indexNumber', String.valueOf(1));
    	
    	RenewPurchasedBaseService objPurchasedServices = new RenewPurchasedBaseService();
    	RenewPurchasedBaseService.WrapperPurchaseOrder  objWrapperPurchaseOrder = new RenewPurchasedBaseService.WrapperPurchaseOrder(objProductMaster1, objPriceBook, 1);
    	objWrapperPurchaseOrder.selectedServiceName = 'Will1';
    	objPurchasedServices.lstWrapperPurchaseOrder.add(objWrapperPurchaseOrder);
    	objPurchasedServices.selectedTopUpGoals = '1';
    	objPurchasedServices.saveProduct();
    	
    	objPurchasedServices.valueAddedService();
    	objWrapperPurchaseOrder.selectedServiceName = 'None';
    	objPurchasedServices.addValueAddedServices();
    	objPurchasedServices.selectedProductName = 'None';
    	objPurchasedServices.deleteService();
    	objPurchasedServices.topUpGoalValue();
    	objPurchasedServices.cancelProduct();
    	
    	
    	Test.stopTest(); //End Test
    														
    }
}