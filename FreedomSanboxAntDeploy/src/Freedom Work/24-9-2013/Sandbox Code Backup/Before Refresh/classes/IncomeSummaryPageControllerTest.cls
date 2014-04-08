@isTest
private class IncomeSummaryPageControllerTest
{
    public static IncomeSummaryPageController incomeTest;
    public static DatabaseDML dbDML;
    public static DatabaseSOQL dbSOQL;
    public static Account account;
    public static Income__c income;
    public static List<SelectOption> options;

    public static void setupData()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	account = testData.initializeAccount();
        upsert account;
        System.assertNotEquals(null,account);
        income= new Income__c();
        ApexPages.currentPage().getParameters().put('entityId',account.Id);
        incomeTest= new IncomeSummaryPageController();
        
    }
   
    public static testMethod void setupBusinessIncomeData()
    {
        Test.startTest();
        setupData();
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	Income__c income1 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Business Income').RecordTypeId__c);
        upsert income1; 
        System.assertNotEquals(null,income1.id);
        Income__c income2 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Business Income').RecordTypeId__c);
        upsert income2;
        System.assertNotEquals(null,income2.id);
        
        incomeTest.bean.selRecordTypeName='Business Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Business Income').RecordTypeId__c;//Prajakta//'01220000000HYzaAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
      
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
       // System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
   
  public static testMethod  void setupSalaryIncomeData()
  {
        Test.startTest();
        setupData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        Income__c income1 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Salary Income').RecordTypeId__c);
        upsert income1;
        System.assertNotEquals(null,income1.id);
        Income__c income2 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Salary Income').RecordTypeId__c);
        upsert income2;
        System.assertNotEquals(null,income2.id);
        
        incomeTest.bean.selRecordTypeName='Salary Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Salary Income').RecordTypeId__c; //Prajakta//'01220000000HYzeAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
       
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
       // System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
    public static testMethod  void setupOtherIncomeData()
    {
        Test.startTest();
        setupData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
       
		//Income__c income1 = new Income__c(Entity__c = account.Id,Income_Amount__c=null,Income_Growth_Rate__c=null,Start_Year__c=null,End_Year__c=null,RecordTypeId='01220000000HYzbAAG');
        Income__c income1 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Other Income').RecordTypeId__c);
        upsert income1;
        System.assertNotEquals(null,income1.id);
        
        //Income__c income2 = new Income__c(Entity__c = account.Id,Income_Amount__c=300,Income_Growth_Rate__c=2,Start_Year__c=null,End_Year__c=null,Employer__c=null,Business_Name__c=null,Income_Type__c=null,Property_Name__c=null,Beneficiary__c=null,RecordTypeId='01220000000HYzbAAG');
        Income__c income2 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Other Income').RecordTypeId__c);
        upsert income2;
        System.assertNotEquals(null,income2.id);
        
        incomeTest.bean.selRecordTypeName='Other Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Other Income').RecordTypeId__c; //Prajakta//'01220000000HYzbAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
       
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
    }
    
    public static testMethod  void setupPensionIncomeData()
    {
        Test.startTest();
        setupData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        
        Income__c income1 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Pension Income').RecordTypeId__c);
        upsert income1;
        System.assertNotEquals(null,income1.id);
        Income__c income2 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Pension Income').RecordTypeId__c);
        upsert income2;
        System.assertNotEquals(null,income2.id);
        
        incomeTest.bean.selRecordTypeName='Pension Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Pension Income').RecordTypeId__c; //Prajakta//'01220000000HYzcAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
     
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
    }
    
    public static testMethod  void setupRentalIncomeData()
    {
        Test.startTest();
        setupData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
        
        Income__c income1 = testData.init_income(account, IncomeRecTypes__c.getInstance ('Rental Income').RecordTypeId__c);
        upsert income1;
        System.assertNotEquals(null,income1.id);
        Income__c income2 = new Income__c(Entity__c = account.Id,Income_Amount__c=300,Income_Growth_Rate__c=2,Start_Year__c=null,End_Year__c=null,Employer__c=null,
        					Business_Name__c=null,Income_Type__c=null,Property_Name__c=null,Beneficiary__c=null,
        					RecordTypeId=IncomeRecTypes__c.getInstance ('Rental Income').RecordTypeId__c); //Prajakta//'01220000000HYzdAAG');
        upsert income2;
        System.assertNotEquals(null,income2.id);
        
        incomeTest.bean.selRecordTypeName='Rental Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Rental Income').RecordTypeId__c; //Prajakta//'01220000000HYzdAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
        
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
        //System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
    ///////
     public static testMethod void setupBusinessIncomeDataEmpty(){
        Test.startTest();
        setupData();
       
        
        incomeTest.bean.selRecordTypeName='Business Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Business Income').RecordTypeId__c; //Prajakta//'01220000000HYzaAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
      
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
        //System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
  public static testMethod  void setupSalaryIncomeDataEmpty(){
        Test.startTest();
        setupData();
        
        incomeTest.bean.selRecordTypeName='Salary Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Salary Income').RecordTypeId__c; //Prajakta//'01220000000HYzeAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
       
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
       // System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
    public static testMethod  void setupOtherIncomeDataEmpty(){
        Test.startTest();
        setupData();
        
        
        incomeTest.bean.selRecordTypeName='Other Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Other Income').RecordTypeId__c; //Prajakta//'01220000000HYzbAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
       
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
        //System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
    public static testMethod  void setupPensionIncomeDataEmpty(){
        Test.startTest();
        setupData();
       
        
        incomeTest.bean.selRecordTypeName='Pension Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Pension Income').RecordTypeId__c; //Prajakta//'01220000000HYzcAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
     
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
        //System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
    public static testMethod  void setupRentalIncomeDataEmpty(){
        Test.startTest();
        setupData();
         
        
        incomeTest.bean.selRecordTypeName='Rental Income';
        incomeTest.bean.selRecordTypeId=IncomeRecTypes__c.getInstance ('Rental Income').RecordTypeId__c; //Prajakta//'01220000000HYzdAAG';
        incomeTest.bean.incomeList=new List<Income__c>();
        
        incomeTest.showPopUp();
        incomeTest.closePopUp();
        incomeTest.getOwnerItems();
       // System.assertNotEquals(null,options);
        options=incomeTest.getFrequency();
        System.assertNotEquals(null,options);
        incomeTest.save();
        incomeTest.remove();
        incomeTest.addNewRow();
        test.stopTest();
        //incomeTest.bean.AccountList=new list<Account>();
        //incomeController.bean.incomeList.add(income);
    }
}