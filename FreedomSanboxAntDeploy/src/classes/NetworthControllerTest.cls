/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   29/06/2011	Added querrystring parameter 'entityId' in testData() function before creating object of
    											NetworthController class
	3.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.			    											
*/					  							

@isTest
private class NetworthControllerTest 
{
    static Account acc;
    static NetworthController netCon;
    static Investment_Asset__c inv,inv1,inv2;
    
    static void testData()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
		
        //acc=new Account(LastName='ABC',RecordTypeId= RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);// Gaurav '01220000000DnK3AAK');
    	upsert acc;
   
    	system.assertNotEquals(null,acc);
    
     	inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);
     	//inv = new   Investment_Asset__c(Entity__c=acc.id,Quantity__c =10,Current_Price__c=10000, RecordTypeId= InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);// Gaurav '01220000000HYx5AAG' );
     	insert inv;
     	system.assertNotEquals(null,inv.id);
     	
     	/*inv1 = new   Investment_Asset__c(Entity__c=acc.id,Quantity__c =10,Current_Price__c=10000, RecordTypeId= InvestmentAsset__c.getInstance('Gold').RecordTypeId__c);// Gaurav '01220000000HYx5AAG' );
     	insert inv1;
     	system.assertNotEquals(null,inv1.id);
     	*/
     	inv2 = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c);
     	//inv2 = new Investment_Asset__c(Entity__c=acc.id,Quantity__c =10,Face_Value__c=10000, RecordTypeId= InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c); // Gaurav '01220000000HYx3AAG' );
      	insert inv2;
     	system.assertNotEquals(null,inv2.id);
     	
     	Insurance__c  insurance = testData.initialize_Insurance(acc);
     	//Insurance__c  insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c ='Life Time',Surrender_Cash_Value__c=10000, RecordTypeId= InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c); // Gaurav '01220000000Do0vAAC' );
      	insert insurance;
     	system.assertNotEquals(null,insurance.id);
	     /** Eternus Solutions       **/
		 /** Author  : Manasi Ranade **/
		 /** Issue Id: F0065      	**/
		 /** Date    : 29/06/2011 	**/
		 /** Purpose : Added querrystring parameter 'entityId' before creating object of
	    			   NetworthController class.Commented previous code.
		/****************************************************/ 
      	Apexpages.currentPage().getParameters().put('entityId',acc.id);
    	
    	netCon=new NetworthController();
     	//Previous Code
     	//Apexpages.currentPage().getParameters().put('entityId',acc.id);
       	String chart=netCon.getNetworthChart;
       	netCon.Output();
       	List<SummaryBean.SummaryDetail> summaryList=netCon.getNetworthSummaryList;
       	Double networth =netCon.getTotalNetworth;
        netCon.getChartData();
    }
    
    static testMethod void networthTest1() 
    {
       	Test.startTest();
        testData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        
        inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
       	//inv=new   Investment_Asset__c(Entity__c=acc.id,Asset_Type__c='Equity',Units__c =10,Current_NAV__c=10000,
          //                                          RecordTypeId= InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);//Gaurav  '01220000000HYx4AAG' );
      	insert inv;
     	system.assertNotEquals(null,inv.id);
        test.stopTest();
    }
    
    static testMethod void networthTest2() 
    {
       	Test.startTest();
        testData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        
        inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
       // inv=new Investment_Asset__c(Entity__c=acc.id,Asset_Type__c='Debt',Units__c =10,Current_NAV__c=10000,
           //                                         RecordTypeId= InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c); //Gaurav '01220000000HYx4AAG' );
      	insert inv;
     	system.assertNotEquals(null,inv.id);
       
        test.stopTest();
    }
}