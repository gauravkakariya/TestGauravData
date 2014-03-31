trigger AddParentForInsurance on Insurance__c (before insert,before update) {
    system.debug('------------------------------------------------------------------ trigger fired');
    HandlerForParentForInsurance OBJinsurance = new HandlerForParentForInsurance();
    if(trigger.isInsert)
    {
        OBJinsurance.beforeInsuranceInsert(Trigger.new);
    }
    if(trigger.isUpdate)
    {
        OBJinsurance.beforeUpdateInsurance(trigger.new,trigger.old);
    }
}