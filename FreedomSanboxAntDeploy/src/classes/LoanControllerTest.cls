/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class LoanControllerTest 
{
    static Account account;
    static LoanController LoanTest;
    public static List<SelectOption> options;
    
    public static void setupData()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		account = testData.initializeAccount();
        //account=new Account(FirstName='ABC',LastName='DEF',RecordTypeId= RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);//Gaurav '01220000000DnK3AAK');
        upsert account;
        
        Loan__c loan1 = testData.init_Loan(account);
        /*Loan__c loan1=new Loan__c(Entity__c=account.id,EMI__c = 300,Loan_Type__c = 'Auto Loan' ,
                                Balance_No_of_Years__c =2);*/
        upsert loan1;
        System.assertNotEquals(null,loan1.id);
        
        Loan__c loan5 = testData.init_Loan(account);
        //Loan__c loan5=new Loan__c(Entity__c=account.id,EMI__c = 0,Loan_Type__c = '' ,
          ///                      Balance_No_of_Years__c =0,Financial_Institution__c ='',Principal_Amount_Outstanding__c=0,
             //                   Interest_Rate__c=4,Term_No_of_years__c=0,Prepayment_terms__c='',Fixed_Floating__c='');
        upsert loan5;
        System.assertNotEquals(null,loan5.id);
        ApexPages.currentPage().getParameters().put('EntityId',account.id);
        LoanTest=new LoanController();
      
        List<AggregateResult> liabilitiesList = new DatabaseSOQL().getLiabilitiesList(account.id);
        LiabilityBean.getSummary(liabilitiesList.get(0));
    }
    
    public static void setupDataNoLoan()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		account = testData.initializeAccount();
        //account=new Account(FirstName='ABC',LastName='DEF',RecordTypeId= RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);//Gaurav '01220000000DnK3AAK');
        upsert account;
        
        ApexPages.currentPage().getParameters().put('EntityId',account.id);
        LoanTest=new LoanController();
    }
    
    public static void setupDataNoLoanwithType()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		account = testData.initializeAccount();
        //account=new Account(FirstName='ABC',LastName='DEF',RecordTypeId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);//Gaurav '01220000000DnK3AAK');
        upsert account;
        ApexPages.currentPage().getParameters().put('EntityId',account.id);
        LoanTest=new LoanController();
    }
    
    public static testMethod void TestLoan()
    {
        Test.startTest();
        setupData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        Loan__c loan3 = testData.init_Loan(account);
            //Loan__c loan3=new Loan__c(Entity__c=account.id,EMI__c = 0,Loan_Type__c = 'Credit Card Loan' ,
             //                   Balance_No_of_Years__c =2);
        upsert loan3;
        System.assertNotEquals(null,loan3.id);
        LoanTest.loanSummaryForDataEntry[0].linkField ='Auto Loan';
        System.currentPageReference().getParameters().put('selectedLoanType','Auto Loan');
        LoanTest.showPopUp();
          LiabilityBean lbean=LoanTest.loanBean;
        LoanTest.closePopUp();
        LoanTest.getOwnerItems();
        LoanTest.addNewRow();
        LoanTest.Remove();
        LoanTest.Save();
        LoanTest.getOwnerItems();
        test.stopTest();
    }
    
    public static testMethod void TestCreditCardLoan()
    {
        Test.startTest();
        setupData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        Loan__c loan2 = testData.init_Loan(account);
         //Loan__c loan2=new Loan__c(Entity__c=account.id,EMI__c = 300, Balance_No_of_Years__c =2);
        upsert loan2;
        System.assertNotEquals(null,loan2.id);
        LoanTest.loanSummaryForDataEntry[0].linkField ='Credit Card Loan';
        System.currentPageReference().getParameters().put('selectedLoanType','Credit Card Loan');
        LoanTest.showPopUp();
          LiabilityBean lbean=LoanTest.loanBean;
        LoanTest.closePopUp();
        LoanTest.getOwnerItems();
       // LoanTest.checkOwnerChange();
        LoanTest.addNewRow();
        LoanTest.Remove();
        LoanTest.Save();
        LoanTest.getOwnerItems();
        test.stopTest();
    }
    
    public static testMethod void TestHomeLoan()
    {
        Test.startTest();
        setupData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        Loan__c loan4 = testData.init_Loan(account);
        // Loan__c loan4=new Loan__c(Entity__c=account.id,EMI__c = 200,Loan_Type__c = 'Credit Card Loan' ,
                       //         Balance_No_of_Years__c =null);
        upsert loan4;
        System.assertNotEquals(null,loan4.id);
        LoanTest.loanSummaryForDataEntry[0].linkField ='Home Loan';
         System.currentPageReference().getParameters().put('selectedLoanType','Home Loan');
        LoanTest.showPopUp();
        LoanTest.closePopUp();
        LoanTest.getOwnerItems();
      //  LoanTest.checkOwnerChange();
        LoanTest.addNewRow();
        LoanTest.Remove();
        LoanTest.Save();
        LoanTest.getOwnerItems();
        test.stopTest();
    }
    
    public static testMethod void TestNoLoanType()
    {
        Test.startTest();
        setupDataNoLoan();
        LoanTest.loanSummaryForDataEntry[0].linkField ='';
        LoanTest.showPopUp();
        LoanTest.closePopUp();
     
        test.stopTest();
    }
    
    public static testMethod void setupDataNoLoanType()
    {
        Test.startTest();
        setupDataNoLoanwithType();
        LoanTest.loanSummaryForDataEntry[0].linkField ='Auto Loan';
        //LoanTest.selectedLoanType='Auto Loan';
        LoanTest.loanBean = null;
        LoanTest.showPopUp();
        LoanTest.closePopUp();
        LoanTest.getOwnerItems();
      // LoanTest.checkOwnerChange();
        LoanTest.addNewRow();
        LoanTest.Remove();
        LoanTest.Save();
     
        test.stopTest();
    }
}