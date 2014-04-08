trigger AddParentForExpense on Expense__c (before insert, before update ) 
{
    
    HandlerForParentForExpense OBJexpense = new HandlerForParentForExpense();
    if(trigger.isInsert)
    {
      OBJexpense.beforeExpenseInsert(trigger.new);
    }
    if(trigger.isUpdate)
    {
        OBJexpense.beforeUpdateExpense(trigger.new,trigger.old); 
    }
}