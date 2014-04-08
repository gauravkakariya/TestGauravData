/* Trigger is Inactive. I have activated it for my use. Uncomment it for regular use. - Prajakta*/

trigger AccountTrigger on Account (after update, after insert,before insert,  before update) 
{
    /*AccountHandler handler = new AccountHandler();
    //CreateEntityActionTask objCreateEntityActionTask = new CreateEntityActionTask();
    if(trigger.isBefore && trigger.isInsert)
    {
        handler.onBeforeInsert(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
    	// Handler method to create EntityActionTask records.
    	//objCreateEntityActionTask.onAfterInsertCreateEntityActionTask(trigger.newMap);
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
        
        system.debug('----------AccountRevenueHandler----before---------');
		AccountRevenueHandler.updateField(trigger.new,trigger.oldMap);
    }
    */
    
    /*Prajakta - 29-08-2013*/
    if(trigger.isAfter && trigger.isUpdate)
	{
		system.debug('----------AccountRevenueHandler-------------');
		AccountRevenueHandler.updateField(trigger.new,trigger.oldMap);
		
		/*Prajakta : 19-09-2013 : Added to trigger the approval process*/
		AccountApprovalSubmitHandler.approvalSubmit(trigger.new);
		AccountApprovalSubmitHandler.partnerTeamMemberUpdation(trigger.new, trigger.oldMap);
		AccountApprovalSubmitHandler.chatterPostGeneration(trigger.new, trigger.oldMap);
		AccountApprovalSubmitHandler.entityAllocationCount(trigger.new, trigger.oldMap);
	}
	
	if(trigger.isBefore && trigger.isUpdate)
    {
    	system.debug('----------assignTeamMember-----Update--------');
    	AccountApprovalSubmitHandler.assignTeamMember(trigger.new);
    }
    if(trigger.isBefore && trigger.isInsert)
    {
    	system.debug('----------assignTeamMember-----Insert--------');
    	ApexPages.StandardController sc = new ApexPages.standardController(new Account());
    	new CreateDepartmentController(sc).assignBusinessUnit(trigger.new);
    	AccountApprovalSubmitHandler.assignTeamMember(trigger.new);
    }
	
	if(trigger.isAfter && trigger.isInsert)
    {
    	system.debug('----------CreateProcessFlowTrackerHandler-------------');
    	//CreateProcessFlowTrackerHandler objPFHandler = new CreateProcessFlowTrackerHandler();
    	//objPFHandler.createFlowTempateWithTracker(trigger.newMap);
    	/*Prajakta : 19-09-2013 :*/
    	AccountApprovalSubmitHandler.partnerTeamMemberAllocation(trigger.new);
    	AccountApprovalSubmitHandler.entityAllocationCount(trigger.new, trigger.oldMap);
    }
}