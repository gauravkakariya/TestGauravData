trigger CopyPlatformUserLeadDetails on Lead_Platform_User__c (after insert, after update,before delete,before insert) 
{
    if(Trigger.isInsert && Trigger.isAfter)
    {
        PlatformUserLeadDetailsController.CopyPlatformUserLeadDetail(trigger.new);
    }
    if(Trigger.isUpdate)
    {
        PlatformUserLeadDetailsController.CopyPlatformUserLeadDetailUpdate(trigger.new,trigger.oldMap);
    }
    if(Trigger.isDelete)
    {
        PlatformUserLeadDetailsController.DeletePlatformUserLeadDetail(trigger.old);
    }
    //need to comment below part
    //=====================================================================================================
    if(Trigger.isInsert && Trigger.isBefore)
    {
        List<Lead_Platform_User__c> lstCustLead = trigger.new;
        for(Lead_Platform_User__c objCustLead : lstCustLead)
        {
                if(objCustLead.Virtual_Partner__c != null)
                {
                    objCustLead.Related_To__c = 'Virtual Partner';
                }
        }
    }
    //=====================================================================================================
}