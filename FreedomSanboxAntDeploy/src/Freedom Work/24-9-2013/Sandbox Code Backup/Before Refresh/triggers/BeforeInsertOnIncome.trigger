trigger BeforeInsertOnIncome on Income__c (before insert,before update)
{
    HandlerForBeforeInsertOnIncome objIncome = new HandlerForBeforeInsertOnIncome();
    
    if(Trigger.isInsert)
    {
        objIncome.beforeIncomeInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate)
    {
        objIncome.beforeUpdateIncome(trigger.new,trigger.old);
    }
}