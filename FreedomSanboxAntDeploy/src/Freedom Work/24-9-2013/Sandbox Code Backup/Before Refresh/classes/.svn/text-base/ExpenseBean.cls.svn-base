/**
@Description:ExpenseBean is bean class for ExpenseVFPage
*/

public class ExpenseBean
{
    public List<String> accountNameList{get;set;}
    public String entityId{get; set;}
    public list<expense__c>expenseList{get;set;}
    public list<GeneralExpensesClass> generalExpensesList{get;set;}
    public list<string> generalExpenseStringList{get;set;}
    public List<AggregateResult> aggQueryResult {get; set;}
    public string selGeneralExpense{get;set;}
    public Boolean displayPopUp{get; set;}
    public static double totalExpenses{get;set;}
    
    public ExpenseBean()
    {
    	//Do nothing constructor.
    }
    
    public class GeneralExpensesClass
    {
        public String GeneralExpensesType{get; set;}
        public Double AmountValue{get; set;}
    }
    
    /**
     @description isRowEmpty function is used to check whether record is empty before saving that record
    */
    public  integer isRowEmpty(expense__c record)
    {
	     Integer flag=0;
	     if( record.start_year__c==null  && record.end_year__c==null  && ( record.current_expenses__c==null )
	     	      && (record.Expense_Growth_Rate__c==null)&& record.Essential__c==false)
	     {
	         if(record.id!=null)
	               flag=2;
	         else
	             flag=1;
	     }
	     else
	           flag=0;
	    return flag;
    }
    
    /**
    @description  validate function to validate whether record is meeting all the requirements
    */
    public static void  validate(expense__c expenseInstance) 
    {
      if((expenseInstance.current_expenses__c == null) || expenseInstance.current_expenses__c <0)                     
                  throw new ValidationException(Label.CurrentExpenseValidation);  
                                                         
      if(expenseInstance.frequency__c==null)
           throw new ValidationException(Label.FrequencyValidation); 
                                                   
      if(expenseInstance.start_year__c!=null && expenseInstance.end_year__c!=null && expenseInstance.start_year__c>expenseInstance.end_year__c )       
            throw new ValidationException(Label.EndYearValidation);     
   }
   
}