trigger AccountTrigger on Account (before insert, after insert, before update) 
{
    AccountHandler handler = new AccountHandler();
    CreateEntityActionTask objCreateEntityActionTask = new CreateEntityActionTask();
    if(trigger.isBefore && trigger.isInsert)
    {
        handler.onBeforeInsert(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
    	// Handler method to create EntityActionTask records.
    	objCreateEntityActionTask.onAfterInsertCreateEntityActionTask(trigger.newMap);
    }
    if (trigger.isBefore && trigger.isUpdate) 
    {
        list<Account> lstAccount = new list<Account>();
        Set<Id> setAccountId = new Set<Id> ();
        for(Account objAccount: trigger.new)
        {
            if(objAccount.Membership_End_Date__c != null && objAccount.Membership_End_Date__c != trigger.oldMap.get(objAccount.Id).Membership_End_Date__c)
            {
                lstAccount.add(objAccount);
                setAccountId.add(objAccount.Id);
            }
        }
    
        handler.executeOnBeforeUpdate(lstAccount, setAccountId);
    }
}