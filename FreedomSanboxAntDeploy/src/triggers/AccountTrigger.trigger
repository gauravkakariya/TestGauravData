/*
    Revision History:
    Version     Version Author    Date              Comments
    2.0         Prajakta Sanap   29/08/2013   1. Trigger is Inactive. I have activated it for my use. Uncomment it for regular use.
                                 19/09/2013   2. Added code to trigger the approval process
*/

trigger AccountTrigger on Account (after update, after insert,before insert,  before update, before delete) 
{
    /*Prajakta - 29-08-2013*/
    if(trigger.isAfter && trigger.isUpdate)
    {
        //AccountRiskProfileHandler.checkRiskProfile(trigger.new, trigger.oldMap);
        
        StaticMethodClass.isAccountUpsertFired = false; /* Prajakta - 29-10-2013 - To avoid "Too Many SOQL" while making the Team Member change for the partner*/
        system.debug('----------after update -----partnerTeamMemberUpdation--------');
        //AccountRevenueHandler.updateField(trigger.new,trigger.oldMap);
        AccountApprovalSubmitHandler.allocationDetails(trigger.new, trigger.oldMap);
        AccountApprovalSubmitHandler.entityAllocationCount(trigger.new, trigger.oldMap);
        AccountApprovalSubmitHandler.partnerTeamMemberUpdation(trigger.new, trigger.oldMap);
        AccountApprovalSubmitHandler.assignTeamMemberToFamily(trigger.new, trigger.oldMap);
        AccountApprovalSubmitHandler.accountSharing(trigger.new, trigger.oldMap, trigger.newMap,trigger.isInsert); 
        
        //Commented on : 3/12/13 - Too Many SOQL issue while saving Entity
        /*//if(StaticMethodClass.isAccountSubmitHandlerFired)
        {
            //AccountApprovalSubmitHandler.allocationDetails(trigger.new, trigger.oldMap);
            //AccountApprovalSubmitHandler.entityAllocationCount(trigger.new, trigger.oldMap);
           AccountApprovalSubmitHandler.partnerTeamMemberUpdation(trigger.new, trigger.oldMap);
            AccountApprovalSubmitHandler.chatterPost(trigger.new, trigger.oldMap, trigger.newMap); 
            AccountApprovalSubmitHandler.entityAllocationCount(trigger.new, trigger.oldMap);
            AccountApprovalSubmitHandler.changeTeamMembersPartnerwise(trigger.new, trigger.oldMap, trigger.newMap);
            
            AccountApprovalSubmitHandler.allocationDetails(trigger.new, trigger.oldMap);
            system.debug('----------assignTeamMemberToFamily-------after------');
            AccountApprovalSubmitHandler.assignTeamMemberToFamily(trigger.new, trigger.oldMap); 
            //if(!Test.isRunningTest()){
            system.debug('----------accountSharing-------after------');
            AccountApprovalSubmitHandler.accountSharing(trigger.new, trigger.oldMap, trigger.newMap,trigger.isInsert); 
            //}
            //StaticMethodClass.isAccountSubmitHandlerFired = false;
        }*/
        
        /*Prajakta : 20-12-2013 :*/
        //AccountWorkflowHandler.entityStageChange(trigger.new, trigger.oldMap, trigger.newMap,trigger.isAfter);
        
        /*Needhi : 21-3-2014 */
       // AccountWorkflowHandler.createTaskForBirthdayAlert(trigger.new,trigger.oldMap);        
    }
    
    if(trigger.isBefore && trigger.isUpdate) 
    {
        /*if(!Test.isRunningTest()){
            system.debug('----------accountSharing-------isBefore------');
            AccountApprovalSubmitHandler.accountSharing(trigger.new, trigger.oldMap, trigger.newMap,trigger.isInsert);
        } 
        */
        //system.debug('----------isBefore-Update---aaaaaaaa--StaticMethodClass.isFlatCommissionUpateforPartner---'+StaticMethodClass.isFlatCommissionUpateforPartner);
        //error.DebugLog('---------isBefore-Update---aaaaaaaa----------------');
        system.debug('---------isBefore-Update---aaaaaaaa----------------');
        /*Prajakta : 19-09-2013 : Added to trigger the approval process*/
         //Added on : 3/12/13 - Too Many SOQL issue while saving Entity
        if(StaticMethodClass.isAccountSubmitHandlerFired)
        {
            
            AccountApprovalSubmitHandler.changeflatCommssionOnChangeOfPO(trigger.new, trigger.oldMap);
            AccountApprovalSubmitHandler.approvalSubmit(trigger.new,trigger.oldMap);
            system.debug('----------isBefore-----Update--------'); 
            AccountApprovalSubmitHandler.assignTeamMemberOnChangeOfPO(trigger.new, trigger.oldMap);
            AccountApprovalSubmitHandler.assignTeamMemberIfBlank(trigger.new, trigger.oldMap, trigger.newMap);
            //AccountApprovalSubmitHandler.assignTeamMemberToFamily(trigger.new, trigger.oldMap,trigger.isInsert);
            /*Aditi : 2-12-2013 : Uncommented the code and changed code so that it works for only Partners*/
            AccountApprovalSubmitHandler.changeOwnerAsPSTTeamMember(trigger.new,trigger.oldMap); 
            //AccountApprovalSubmitHandler.OnPartnerOwnerChangeUpdateEntity_Lead_Owner(trigger.newMap,trigger.oldMap);
            //StaticMethodClass.isAccountSubmitHandlerFired = false;
            
            AccountApprovalSubmitHandler.chatterPost(trigger.new, trigger.oldMap, trigger.newMap); 
            
            AccountApprovalSubmitHandler.changeTeamMembersPartnerwise(trigger.new, trigger.oldMap, trigger.newMap);
            
            //AccountApprovalSubmitHandler.allocationDetails(trigger.new, trigger.oldMap);
            system.debug('----------assignTeamMemberToFamily-------after------');
            
            //AccountApprovalSubmitHandler.assignTeamMemberToFamily(trigger.new, trigger.oldMap);
            //if(!Test.isRunningTest()){
            //system.debug('----------accountSharing-------after------');
            //AccountApprovalSubmitHandler.accountSharing(trigger.new, trigger.oldMap, trigger.newMap,trigger.isInsert); 
            
            /*Prajakta : 18-12-2013 :*/
            AccountWorkflowHandler.entityStageChange(trigger.new, trigger.oldMap, trigger.newMap,trigger.isAfter);

            StaticMethodClass.isAccountSubmitHandlerFired = false;
        }
    } 
     
    if(trigger.isBefore && trigger.isInsert) 
    {
        system.debug('----------assignTeamMember-----Insert--------');
        AccountApprovalSubmitHandler.assignTeamMember(trigger.new);
        AccountApprovalSubmitHandler.setEntityStatusAsPathfinder(trigger.new); 
        /*Aditi : 2-12-2013 : Added code so that while insert Owner should be set as PST selected PST member IN CASE OF Partners*/
        AccountApprovalSubmitHandler.changeOwnerAsPSTTeamMemberOnInsert(trigger.new);
        /*Prajakta : 18-12-2013 :*/
        AccountWorkflowHandler.entityStageChange(trigger.new, trigger.oldMap, trigger.newMap,trigger.isAfter);
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        system.debug('----------CreateProcessFlowTrackerHandler-------------');
        /*Needhi : 21-3-2014 */
        //AccountWorkflowHandler.createTaskForBirthdayAlert(trigger.new,null); 
        //code to create default set of Work FLow handler master and details records on creation of Entity - Gaurav
        CreateProcessFlowTrackerHandler objPFHandler = new CreateProcessFlowTrackerHandler();
       
        objPFHandler.createFlowTempateWithTracker(trigger.newMap);
        
        /*Prajakta : 19-09-2013 :*/
        AccountApprovalSubmitHandler.partnerTeamMemberAllocation(trigger.new);
        AccountApprovalSubmitHandler.entityAllocationCount(trigger.new, trigger.oldMap);
        system.debug('----------allocationDetails-------after insrt------');
        AccountApprovalSubmitHandler.allocationDetails(trigger.new, trigger.oldMap);
        if(!Test.isRunningTest()){
            AccountApprovalSubmitHandler.accountSharing(trigger.new, trigger.oldMap, trigger.newMap,trigger.isInsert);  
        }
        
        /*Prajakta : 18-12-2013 :*/
        AccountWorkflowHandler.newEntityCreation(trigger.new, trigger.newMap);
       
        
        
    } 
    
    if(trigger.isBefore && trigger.isDelete)
    {
        AccountApprovalSubmitHandler.partnerTeamMemberDeletion(trigger.old);
        
        /*Prajakta - Added from trigger UpdateEntityStage - 20-12-2013*/
        Set<Id> accountIdSet = new Set<Id>();
        for(Account objAccount: trigger.old)
        {
            accountIdSet.add(objAccount.Id);
        }
        BeforeDeleteOnAccountController.DeleteEntityRelatedRecords(accountIdSet);
    }  
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
    }
    */
}