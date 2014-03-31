/*
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         Persistent         NA  		  	Initial Draft
    2.0			Manasi Ranade	   20/06/2011	1)Uncommented code from cashFlowTest1() function after resolving null pointer exception from NewCashFlowControllerTest test class.
    											2)Issue was related to birthdate field in NewCashFlowService class in function : getCashFlowProjection().
    											3)Birthdate was used for calculation of age of that entity.
    											4)So replaced birthdate by Current_Age__c.
   2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.	 											
*/ 
		
@isTest
private class NewCashFlowControllerTest 
{
    static Account acc;
    static NewCashFlowController netCashCon;
    static Investment_Asset__c inv;
   	static NewCashFlowService objService;
   	
    static void testData()
    {
        TestData_Ffreedom testData = new TestData_Ffreedom();
    	acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null,acc);
    
    	Insurance__c  insurance = testData.initialize_Insurance(acc);
      	insert insurance;
     	system.assertNotEquals(null,insurance.id);
     	
      	//Income__c income = testData.init_income(acc, IncomeRecTypes__c.getInstance('Salary Income').RecordTypeId__c);
      	Income__c income=new Income__c(Entity__c=acc.id,start_year__c='1990',end_year__c='2020',Frequency__c='Monthly',Income_Growth_Rate__c=5,Income_Amount__c=50000,RecordTypeId=IncomeRecTypes__c.getInstance('Salary Income').RecordTypeId__c); // Samir'01220000000HYze');
      	insert income;
      	system.assertNotEquals(null,income.id);
      	
      	Expense__c expense = testData.init_Expense(acc, 'Utilities');
      	insert expense;
      	
      	Loan__c loan = testData.init_Loan(acc);
      	insert loan;
      	system.assertNotEquals(null,loan.id);

	    Apexpages.currentPage().getParameters().put('entityId',acc.id);
      	netCashCon = new NewCashFlowController();
      	objService = new NewCashFlowService();
    
       	String chart = netCashCon.getCashFlowChart;
       	netCashCon.projection();
       	netCashCon.setAction();
       	netCashCon.newCashFlow();
   	   	netCashCon.save();
       	List<String> yearList = netCashCon.getYearList;
       	Double netCash = netCashCon.netCash;
        netCashCon.getChartData();
        List <double> differenceList = netCashCon.cashFlowBean.getDifference;
        Double  getMonthlyDifference = netCashCon.cashFlowBean.getMonthlyDifference;
       	Double getFirstYearDifference = netCashCon.cashFlowBean.getFirstYearDifference;
    }
    
    static testMethod void cashFlowTest1() 
    {
       Test.startTest();
       	/** Eternus Solutions       **/
		/** Author  : Manasi Ranade	**/
		/** Issue Id: F0056     	**/
		/** Date    : 20/06/2011 	**/
		/** Purpose : Uncommented code after resolving null pointer exception**/
		/****************************************************/  
       testData();
        test.stopTest();
    }
    
}