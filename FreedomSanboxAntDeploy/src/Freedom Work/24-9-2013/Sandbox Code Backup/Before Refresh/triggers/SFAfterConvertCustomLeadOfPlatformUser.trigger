trigger SFAfterConvertCustomLeadOfPlatformUser on Lead_Platform_User__c (after update)
{
    //List<Lead_Platform_User__c> lstLeadConvert = Trigger.new;
    //SFConvertLeadofPlatformUser.convertCustomLead(trigger.NewMap,Trigger.new,trigger.OldMap);
    SFConvertLeadofPlatformUser.main();
}