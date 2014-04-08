/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     24/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class TestExpenseController 
{
	
	public static testMethod void testExpense()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Account act = testData.initializeAccount();
		//Account act = [select Id from Account limit 1];
		Pagereference pr = Page.Expense;
		pr.getParameters().put('entityId',act.Id);
		Test.setCurrentPage(pr);
		ExpenseController expCont = new ExpenseController();
		List<ExpenseController.expenseWrapper> wrapperList = expCont.getExpenseList();
		Expense__c expense= wrapperList[0].exp;
		//Expense__c expense = exp.getExp();
		expense.General_Expenses__c = 'HOUSING';
		System.currentPageReference().getParameters().put('count', '0');
		expCont.showSubExpenses();
		expCont.addMoreRows();
		expCont.saveExpenses();
		expCont.cancel();
	}

}