/*
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		ExpenseVFPageController is controller for ExpenseVFPage
    2.0			Manasi			   20/07/2012	Case No: 00001717 : Passed Entity Id to the getExpenseRecords function 
*/ 

public class ExpenseVFPageController
{
    public expensesServices expensesServicesInstance{get; set;}
    public expenseBean expenseBeanInstance{get; set;} 
    public list<ExpenseType__c>expenseSubType{get;set;}
    public list<Expense__c>expenseDisplayList{get;set;}
    public list<Expense__c>expenseDisplayPageList{get;set;}
    //Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
    
    public ExpenseVFPageController()
    {
    	//Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
        ExpenseDisplayList = new list<Expense__c>();
        expenseDisplayPageList = new list<Expense__c>();
        expensesServicesInstance = new ExpensesServices ();
        expenseBeanInstance = new ExpenseBean();
        expenseBean.totalExpenses = 0;
        
        expenseBeanInstance.EntityId = ApexPages.currentPage().getParameters().get('EntityId');
        expensesServicesInstance.parentId =  expenseBeanInstance.EntityId;
        expenseBeanInstance.generalExpenseStringList = expensesServicesInstance.getGeneralExpense();
        expenseBeanInstance.AccountNameList = expensesServicesInstance.getAccountNames(expenseBeanInstance.EntityId);
        expenseBeanInstance.GeneralExpensesList = expensesServicesInstance.initSummaryTableList(expenseBeanInstance.AccountNameList,expenseBeanInstance.generalExpenseStringList);
        expenseBeanInstance.GeneralExpensesList = expensesServicesInstance.getDBValues(expenseBeanInstance.GeneralExpensesList,expenseBeanInstance.EntityId); 
       
        //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
        User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
        if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
        {
        	isDisplaySaveButton = false;
        }
      // expenseBeanInstance.GeneralExpensesList= expensesServicesInstance.populateSummaryTableList( expenseBeanInstance.AggQueryResult, expenseBeanInstance.GeneralExpensesList);
    }
    
    /**
    showPopUp function is used to show pop up when user clicks on any general expense 
    */
    public void showPopUp()
    {
        list<String> availableRecords = new list<String>();
        list<Expense__c>otherExpenseList = new list<Expense__c>();
        expenseBeanInstance.displayPopUp = true;
        
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: 00001717      **/
		/** Date    : 20/7/2012 	**/
		/** Purpose : Passed Entity Id to the getExpenseRecords function
		/****************************************************/
        expenseBeanInstance.expenseList = expensesServicesInstance.getExpenseRecords(expenseBeanInstance.selGeneralExpense,expenseBeanInstance.EntityId);
        ExpenseSubType = expensesServicesInstance.getSubexpenses(expenseBeanInstance.selGeneralExpense);
        
        //[select subexpense__c from ExpenseType__c  where general_expense__c=:expenseBeanInstance.selGeneralExpense];
        ExpenseDisplayList = new list<expense__c>();
        expenseDisplayPageList = new list<expense__c>();
        
        Integer flag = 0;
        String  subexpense;
   
        for(expense__c e:expenseBeanInstance.expenseList)
        {
            ExpenseDisplayList.add(e) ;
            subexpense=e.sub_expenses__c;
           
           	for(string s:availableRecords)
           	{
               if(subexpense==s)
                   flag=1;
           	}
          	if(flag==0)
               availableRecords.add(subexpense);
        }
        
        for(ExpenseType__c s:ExpenseSubType)
        {
           	if(availableRecords.size()!=0)
           	{
               	for(string s1:availableRecords)
               	{
                   if(s.subexpense__c!=s1)
                       flag=1;
                   else
                   {
                       flag=0;
                       break;
                   }
                }
                if(flag==1)
                {
                   Expense__c e1=new Expense__c();
                   e1.general_expenses__c=expenseBeanInstance.selGeneralExpense;
                   e1.sub_expenses__c=s.subexpense__c;
                   e1.entity_name__c=expenseBeanInstance.EntityId;
                   e1.start_year__c=null;
                   e1.end_year__c=null;
                   e1.frequency__c='';
                   e1.current_expenses__c=null;
                   e1.Expense_Growth_Rate__c=null;
                   ExpenseDisplayList.add(e1) ;
               	}
           	}
           	else
           	{
                   Expense__c e1=new Expense__c();
                   e1.general_expenses__c=expenseBeanInstance.selGeneralExpense;
                   e1.sub_expenses__c=s.subexpense__c;
                   e1.entity_name__c=expenseBeanInstance.EntityId;
                   e1.start_year__c=null;
                   e1.end_year__c=null;
                   e1.frequency__c='';
                   e1.current_expenses__c=null;
                   e1.Expense_Growth_Rate__c=null;
                   ExpenseDisplayList.add(e1) ;
           	}
        }
        
        for(Expense__c exp:ExpenseDisplayList )
        {
           if(exp.Sub_Expenses__c.contains('Other')||exp.Sub_Expenses__c.contains('other'))
               otherExpenseList.add(exp);
           else
           expenseDisplayPageList.add(exp);
       	}
       
       //this for loop adds other expenses at last in list
       	for(expense__c otherexp:otherExpenseList)
       	{ 
           expenseDisplayPageList.add(otherexp);
       	}
       
    }
    
    public void closePopUp()
    {
        expenseBeanInstance.GeneralExpensesList= expensesServicesInstance.getDBValues( expenseBeanInstance.GeneralExpensesList,expenseBeanInstance.EntityId);
        expenseBeanInstance.displayPopUp=false;
    }
     
    public List<SelectOption> getFrequency() 
    {
          return expensesServicesInstance.getFrequencyValues();    
    }

    // getOwnerItems() populates values of Owner picklist  
    public List<SelectOption> getOwnerItems() 
    {
        List<SelectOption> options = expensesServicesInstance.getOwnerItems(expenseBeanInstance.EntityId);    
        return options;
    }
    
    /**
    This function is used to save the record in expense__c object 
    */
    public pageReference Save() 
    {
        list<Expense__c> saveList = new list<Expense__c>();
        list<Expense__c> deleteList = new list<Expense__c>();
        system.debug('ExpenseDisplayList************'+ExpenseDisplayList);
        for(Expense__c record:ExpenseDisplayList)
        {
            if(expenseBeanInstance.isRowEmpty(record) == 0)
                saveList.add(record);
            else if(expenseBeanInstance.isRowEmpty(record) == 2)
                deleteList.add(record);
        } 
        system.debug('saveList*********************'+saveList);
        expensesServicesInstance.removeRecord(deleteList);
        Integer errorFlag = expensesServicesInstance.saveExpenses(saveList); 
       
        if(errorFlag != 1)
        {
            expenseBeanInstance.GeneralExpensesList = expensesServicesInstance.initSummaryTableList( expenseBeanInstance.AccountNameList,expenseBeanInstance.generalExpenseStringList);
            expenseBeanInstance.GeneralExpensesList = expensesServicesInstance.getDBValues( expenseBeanInstance.GeneralExpensesList,expenseBeanInstance.EntityId);
            expenseBeanInstance.displayPopUp = false; 
        }
        return null;
    }

}