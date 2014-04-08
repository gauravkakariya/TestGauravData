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
@isTest
private class EntityCashFlowDetailsTest {

	static Account acc;
	static Account FamilyMember;
	static TestData_Ffreedom testData;
	public static void testData_WithFamilymembers()
	{
		testData = new TestData_Ffreedom();
    	acc = testData.initializeAccount();
        insert acc;
        system.assertNotEquals(null,acc);
    
        FamilyMember = testData.init_FamilyMember(acc);
        insert FamilyMember;
       	system.assertNotEquals(null,FamilyMember);
    	List<Income__c> lstIncome = new List<Income__c>();
    	//Income__c income = testData.init_income(acc, IncomeRecTypes__c.getInstance('Salary Income').RecordTypeId__c);
      	Income__c income=new Income__c(Entity__c=acc.id,start_year__c='1990',end_year__c='2020',Frequency__c='Monthly',Income_Growth_Rate__c=5,Income_Amount__c=50000,RecordTypeId=IncomeRecTypes__c.getInstance('Salary Income').RecordTypeId__c); // Samir'01220000000HYze');
      	lstIncome.add(income);
      	Income__c familyIncome=new Income__c(Entity__c=FamilyMember.id,start_year__c='1990',end_year__c='2020',Frequency__c='Monthly',Income_Growth_Rate__c=5,Income_Amount__c=50000,RecordTypeId=IncomeRecTypes__c.getInstance('Salary Income').RecordTypeId__c); // Samir'01220000000HYze');
      	lstIncome.add(familyIncome);
      	insert lstIncome;
      	system.assertNotEquals(null,income.id);
      	
	}
    static testMethod void testEntityCashFlowDetails_WithFamilymembersData_Expense() 
    {
        testData_WithFamilymembers();
    	List<Expense__c> lstExpense = new List<Expense__c>();
      	Expense__c expense = testData.init_Expense(acc, 'Utilities');
      	lstExpense.add(expense);
      	Expense__c familyExpense = testData.init_Expense(FamilyMember, 'Utilities');
      	lstExpense.add(familyExpense);
      	insert lstExpense;
      	system.assertNotEquals(null,expense.id);
      	
      	EntityCashFlowDetails objEntityCashFlowDetails = new EntityCashFlowDetails();
    }
    /*static testMethod void testEntityCashFlowDetails_WithFamilymembersData_Insuracne() 
    {
    	testData_WithFamilymembers();
    	List<Insurance__c> lstInsurance = new List<Insurance__c>();
    	
    	Insurance__c insurance = testData.initialize_Insurance(acc);
    	lstInsurance.add(insurance);
    	Insurance__c familyInsurance = testData.initialize_Insurance(FamilyMember);
    	lstInsurance.add(familyInsurance);
      	insert lstInsurance;
     	system.assertNotEquals(null,insurance.id);
     	
     	EntityCashFlowDetails objEntityCashFlowDetails = new EntityCashFlowDetails();
     	
    }
    static testMethod void testEntityCashFlowDetails_WithFamilymembersData_Loan() 
    {
    	testData_WithFamilymembers();
    	List<Loan__c> lstLoan = new List<Loan__c>();
    	
    	Loan__c loan = new  Loan__c(Principal_Amount_Outstanding__c=1000000,
								Entity__c=acc.id,EMI__c = 20000);//testData.init_Loan(acc);
      	lstLoan.add(loan);
      	Loan__c familyLoan = new  Loan__c(Principal_Amount_Outstanding__c=1000000,
								Entity__c=FamilyMember.id,EMI__c = 20000);//testData.init_Loan(FamilyMember);
  		lstLoan.add(familyLoan);
      	insert lstLoan;
      	system.assertNotEquals(null,loan.id);
      	
      	EntityCashFlowDetails objEntityCashFlowDetails = new EntityCashFlowDetails();
    	
    }*/
    public static void testData_OnlyFamilymembers()
	{
		testData = new TestData_Ffreedom();
    	 acc = testData.initializeAccount();
        insert acc;
        system.assertNotEquals(null,acc);
    
        FamilyMember = testData.init_FamilyMember(acc);
        insert FamilyMember;
       	system.assertNotEquals(null,FamilyMember);
    	List<Income__c> lstIncome = new List<Income__c>();
    	//Income__c income = testData.init_income(acc, IncomeRecTypes__c.getInstance('Salary Income').RecordTypeId__c);
      	Income__c familyIncome=new Income__c(Entity__c=FamilyMember.id,start_year__c='1990',end_year__c='2020',Frequency__c='Monthly',Income_Growth_Rate__c=5,Income_Amount__c=50000,RecordTypeId=IncomeRecTypes__c.getInstance('Salary Income').RecordTypeId__c); // Samir'01220000000HYze');
      	lstIncome.add(familyIncome);
      	insert lstIncome;
      	system.assertNotEquals(null,familyIncome.id);
	}
    
    static testMethod void testEntityCashFlowDetails_OnlyFamilymembersData_Expense() 
    {
    	testData_OnlyFamilymembers();
    	List<Expense__c> lstExpense = new List<Expense__c>();
    	      	   	
      	Expense__c familyExpense = testData.init_Expense(FamilyMember, 'Utilities');
      	lstExpense.add(familyExpense);
      	insert lstExpense;
      	system.assertNotEquals(null,familyExpense.id);
      	
      	EntityCashFlowDetails objEntityCashFlowDetails = new EntityCashFlowDetails();
    }
   /* static testMethod void testEntityCashFlowDetails_OnlyFamilymembersData_Insurance() 
    {
    	testData_OnlyFamilymembers();
    	List<Insurance__c> lstInsurance = new List<Insurance__c>();

    	Insurance__c familyInsurance = testData.initialize_Insurance(FamilyMember);
    	lstInsurance.add(familyInsurance);
      	insert lstInsurance;
     	system.assertNotEquals(null,familyInsurance.id);
     	
     	EntityCashFlowDetails objEntityCashFlowDetails = new EntityCashFlowDetails();
    	
    }
    static testMethod void testEntityCashFlowDetails_OnlyFamilymembersData_Loan() 
    {
    	testData_OnlyFamilymembers();
    	List<Loan__c> lstLoan = new List<Loan__c>();
    	
      	Loan__c familyLoan = new  Loan__c(Principal_Amount_Outstanding__c=1000000,
								Entity__c=FamilyMember.id,EMI__c = 20000);//testData.init_Loan(FamilyMember);
  		lstLoan.add(familyLoan);
      	insert lstLoan;
      	system.assertNotEquals(null,familyLoan.id);
      	
      	EntityCashFlowDetails objEntityCashFlowDetails = new EntityCashFlowDetails();
    }*/
    
}