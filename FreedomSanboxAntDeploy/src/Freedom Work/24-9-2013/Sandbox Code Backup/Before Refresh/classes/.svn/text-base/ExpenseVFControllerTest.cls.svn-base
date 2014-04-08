/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class ExpenseVFControllerTest 
{
	static Account parent;
    static Account child;
     
    static ExpenseVFPageController expenseCon;
	
	public static void setupData()
	{
	  	TestData_Ffreedom testData = new TestData_Ffreedom();
		parent = testData.initializeAccount();
	  	upsert parent;
	  	
	  	child = testData.init_FamilyMember(parent);
	    upsert child;
	    
	    Expense__c expense1 = testData.init_Expense(parent, 'Transportation');
	    upsert expense1;
	    System.assertNotEquals(null,expense1.id);
	    
	    Expense__c expense = testData.init_Expense(parent, 'Other'); 
	    upsert expense;
	    System.assertNotEquals(null,expense.id);
	    
	    Expense__c expense2 = testData.init_Expense(parent, 'Transportation');
	    upsert expense2;
	    System.assertNotEquals(null,expense2.id);
	    ApexPages.currentPage().getParameters().put('EntityId',parent.id);
	   
	    expenseCon=new ExpenseVFPageController();
	    
	}
 	
 	public static testMethod void TestExpense()
 	{
	 	Test.startTest();
	  	setupData();
	  	
	  	expenseCon.expenseBeanInstance.selGeneralExpense='Transportation';
	  	expenseCon.showPopUp();
	  	expenseCon.getFrequency();
	  	expenseCon.getOwnerItems();
	  	expenseCon.Save();
	  	expenseCon.closePopUp();
	  	test.stopTest();
	}
	
    public static testMethod void TestExpense1()
    {
	 	Test.startTest();
	  	setupData();
	  	expenseCon.expenseBeanInstance.selGeneralExpense='Other';
	  	expenseCon.showPopUp();
	  	expenseCon.getFrequency();
	  	expenseCon.getOwnerItems();
	  	expenseCon.Save();
	  	expenseCon.closePopUp();
	  	test.stopTest();
	}
	
	public static testMethod void TestExpense2()
	{
	 	Test.startTest();
	  	setupData();
	  	expenseCon.expenseBeanInstance.selGeneralExpense='Housing';
	  	expenseCon.showPopUp();
	  	expenseCon.getFrequency();
	  	expenseCon.getOwnerItems();
	  	expenseCon.Save();
	  	expenseCon.closePopUp();
	  	test.stopTest();
	}
}