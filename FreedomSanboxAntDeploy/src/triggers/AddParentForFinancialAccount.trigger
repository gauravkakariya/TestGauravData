trigger AddParentForFinancialAccount on Financial_Account__c (before insert,before update) 
{
    HandlerForParentForFinancialAccount OBJfinancialAccount = new HandlerForParentForFinancialAccount();

    if(Trigger.isInsert)
    {
       OBJfinancialAccount.beforeFinancailAccountInsert(Trigger.new);
       
    }
    if(Trigger.isUpdate)
    {
        OBJfinancialAccount.beforeUpdateFinancialAccount(trigger.new,trigger.old);
    }
    
}