trigger AfterUpdateAfterConvertCustomLead on Lead_Platform_User__c (after update)
{
    //List<Lead_Platform_User__c> lstLeadConvert = Trigger.new;
    ConvertLeadofPlatformUser.convertCustomLead(trigger.NewMap,Trigger.new,trigger.OldMap);
}