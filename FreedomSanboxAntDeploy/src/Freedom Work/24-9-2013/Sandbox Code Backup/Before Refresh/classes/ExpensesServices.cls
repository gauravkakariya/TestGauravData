/*

	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		ExpensesServices is service class for ExpenseVFPage
    2.0			Manasi			   20/07/2012	Case No: 00001717 : Change in function : getExpenseRecords
    											Commented original Code , as it was fetching records depending on Account Name.
												But in actual it should fetch record from account id. 
*/    
public class ExpensesServices
{
	public String parentId{get;set;}
    public DatabaseSOQL databaseSOQLObj {get; set;}
    
    private DatabaseDML databaseDMLObj {get; set;}
    
    public ExpensesServices()
    {
        databaseSOQLObj = new DatabaseSOQL();
        databaseDMLObj = new DatabaseDML();
    }
    
    /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001717      **/
	/** Date    : 20/7/2012 	**/
	/** Purpose : Commented original Code , as it was fetching records depending on Account Name.
					But in actual it should fetch record from account id. 
	/****************************************************/
    /*public List<expense__c> getExpenseRecords(String generalExpense,list<string>acctList)    
    {
        List<expense__c> expenseList1 = DatabaseSOQLObj.getExpense(generalExpense,acctList); 
         return expenseList1 ;
    }*/
    public List<expense__c> getExpenseRecords(String generalExpense,Id AccId)    
    {
    	List<Account> familyMembers = DatabaseSOQLObj.getFamilyDetails(AccId);
    	List<String> lstAccountId = new List<String>();
    	
    	for(Account objAccount : familyMembers)
    		lstAccountId.add(objAccount.Id);
    	
        List<expense__c> expenseList1 = DatabaseSOQLObj.getExpense(generalExpense,lstAccountId); 
        return expenseList1 ;
    }


    /**getOwnerItems() gets values of related Entities to be displayed in Owner picklist 
     Input Parameters: EntityId
     Returns: List of SelectOptions
    */    

    public List<SelectOption> getOwnerItems(String entityId) 
    {
        List<SelectOption> options = new List<SelectOption>();
        
        List<Account> EntityList = DatabaseSOQLObj.getFamilyDetails(entityId);
        for(Account TempAccount : EntityList )
        {
            options.add(new SelectOption(tempAccount.Id,tempAccount.Name));        
        }
        return options;
    }
    
     /** saveExpenses() saves records in expense
        Input Parameters: List of expense
     Returns: none
    */        
    public integer saveExpenses(List<expense__c> expense)
    {
       integer  errorFlag=0;
       list<expense__c> tempExpenseList = new list<expense__c>();
       if(expense != null){
       for(expense__c ex : expense)
       {
            if(ex.start_year__c != null&&ex.end_year__c == null)
            {
            	//formula to calculate end year
            }
            
            try
            {
               ExpenseBean.validate(ex);
               tempExpenseList.add(ex);
             }
             catch(ValidationException e)
             {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getmessage()) );
                 errorFlag=1;
             }
              
            }
       }
       
       if(tempExpenseList.size()!=0)
        {
           try
           {
               DatabaseDMLObj.upsertObject(tempExpenseList);
           }
           catch(Exception e)
           {
               system.debug(e.getMessage());
           } 
        }
        return errorFlag;
    }
    
     /**getAccountNames() gets related Entities 
     Input Parameters: EntityId
     Returns: List of Account Names
    */
    public List<String> getAccountNames(String EntityId)
    {
        DatabaseSOQL DatabaseSOQLObj = new DatabaseSOQL();
        List<String> AccountNameList = new List<String>();
        List<Account> AccountList = DatabaseSOQLObj.getFamilyDetails(EntityId);
        for(Account acc:Accountlist)
        {
           AccountNameList.add(acc.Name);
        }
         return AccountNameList;
    }
    
    /**
       getGeneralExpense function is used  to get general expense picklist values 
    */
    public List<string> getGeneralExpense()
    {
        List<string> options = new List<string>();
        Schema.DescribeFieldResult field = Schema.sObjectType.expense__c.fields.General_Expenses__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(p.getLabel());
        }
        return options;
    }
    
    /** getDBValues() gets records from database for expense__c 
     Input Parameters: List of Accounts
     Returns: List of AggregateResult
    */

    public List<expenseBean.GeneralExpensesClass> getDBValues(List<expenseBean.GeneralExpensesClass> SummaryTableList,string entity)
    {
       
     	List<AggregateResult> AggQueryResult = databaseSOQLObj.getMonthlyExpense(entity);
     
      	expenseBean.totalExpenses=0;
      	for(expenseBean.GeneralExpensesClass general:SummaryTableList)
        {
             for(AggregateResult ar:AggQueryResult )
             {
                 if(ar.get('generalexpense') == general.GeneralExpensesType)
                     general.AmountValue=(Double)ar.get('AmtSum');
             }
             expenseBean.totalExpenses=expenseBean.totalExpenses+ general.AmountValue;
         
        }
        return SummaryTableList;
    }
    
     /**
       getFrequencyValues function is used  to get frequency picklist values 
    */
    public List<SelectOption> getFrequencyValues()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.expense__c.fields.frequency__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getValue(),p.getLabel()));
        }
        return options;
    }

     /**
       initSummaryTableList function is used initialize summary table values
    */
     public List<expenseBean.GeneralExpensesClass> initSummaryTableList( List<String> AccountNameList,list<string> generalExpenseList)
    {
        List<expenseBean.GeneralExpensesClass> SummaryTableList= new List<expenseBean.GeneralExpensesClass>();
        for(string eType : generalExpenseList)
        {
             expenseBean.GeneralExpensesClass GeneralExpensesClassobj = new expenseBean.GeneralExpensesClass();
             GeneralExpensesClassObj.GeneralExpensesType= eType;
             GeneralExpensesClassObj.AmountValue=0.00;
             SummaryTableList.add(GeneralExpensesClassObj);
        } 
        return SummaryTableList;
    }
    
    public list<ExpenseType__c> getSubexpenses(String selGeneralExpense)
    {
        list<ExpenseType__c>subExpenseList = databaseSOQLObj.getSubexpenseList(selGeneralExpense);
        return subExpenseList;
    }
    
    /**
    This function is used to remove the records from database
    */
    public void removeRecord(list<expense__c> deleteList)
    {
	    try
	    {
          if(deleteList.size()!=0)
            databaseDMLObj.deleteRecords(deleteList);
	    }
        catch(Exception e){
            system.debug('======Service removeOwnerList Exception======'+e.getmessage());
        }    
    }
   
}