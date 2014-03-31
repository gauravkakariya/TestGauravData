public class ExpenseController 
{
    private List<expenseWrapper> expenseList = new List<expenseWrapper>();
    private String generalExpense = null;
    private static Id entityId = System.currentPageReference().getParameters().get('entityId');
     
    public String currentExpense {get; set;}
   
    public String getGeneralExpense()
    {
        return this.generalExpense;
    }
        
    public void setGeneralExpense(String generalExpense)
    {
            this.generalExpense = generalExpense;
    }
        
        
    public void showSubExpenses()
    {
        String counter = System.currentPageReference().getParameters().get('count');
        if(counter != null) 
        {
            for(expenseWrapper e : this.expenseList) 
            {
                if(e.count == Integer.valueOf(counter)) 
                {
                    List<SelectOption> newOptions = new List<SelectOption>();
                    newOptions.add(new SelectOption('None','None'));
                    if(e.exp.General_Expenses__c!= null && !e.exp.General_Expenses__c.contains('None')) 
                    {
                        for(Expense_Det__c subExp : [select Name from Expense_Det__c where General_Expense__c= :e.exp.General_Expenses__c]) 
                        {
                                newOptions.add(new SelectOption(subExp.Name,subExp.Name));
                                System.debug('new expense '+subExp.Name);
                        }
                    }
                    e.subExpenses = newOptions;
                //expenseList[e.counter]= 
                }       
            } 
        }   
    }
         
    public Id getEntityId()
    {
        return System.currentPageReference().getParameters().get('entityId');
    }
     
        
  	public List<expenseWrapper> getExpenseList()
  	{
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('None','None'));
      
      if(expenseList.isEmpty())
      {
          for(Integer i=0; i<5; i++)
          {
              Expense__c newExpense  = new Expense__c(Entity_Name__c=entityId);
              expenseList.add(new expenseWrapper(i, newExpense, options));
          }
      }
        
      return expenseList;
  	}
       
      
    public void addMoreRows()
    {
        Integer len = this.expenseList.size();
        List<SelectOption> newOptions = new List<SelectOption>();
        newOptions.add(new SelectOption('None','None'));
        
        for(Integer i = 1; i <= 3; i++)
        {
            expenseWrapper newExpense  = new expenseWrapper();
            newExpense.count = len+i;
            newExpense.subExpenses = newOptions;
            newExpense.exp  = new Expense__c(Entity_Name__c=entityId);
            this.expenseList.add(newExpense);
        }
             
    }
        
    public PageReference saveExpenses()
    {
       List<Expense__c> finalList = new List<Expense__c>();
       for(expenseWrapper ex: this.expenseList)
           if(ex.exp.General_Expenses__c != null && ex.exp.General_Expenses__c != '--None--')
               finalList.add(ex.exp);
       
       if(!finalList.isEmpty())
       	insert finalList;
       	
       PageReference pr = new PageReference('/'+entityId);
       pr.setRedirect(true);
       return pr;
        
    }
       
    public PageReference cancel()
    {
    	PageReference pr = new PageReference('/'+entityId);
        pr.setRedirect(true);
        return pr;
    }
 
    public class expenseWrapper 
    {
        public Integer count {get;set;}
        public Expense__c exp {get;set;}
        public List<SelectOption> subExpenses {get;set;}
        
        public expenseWrapper(Integer rowCount, Expense__c exp, List<SelectOption> subExpenses)
        {
            this.count = rowCount;
            this.exp = exp;
            this.subExpenses = subExpenses;
        }
        public expenseWrapper()
        {
        	//Do nothing constructior.
        }
   }
}