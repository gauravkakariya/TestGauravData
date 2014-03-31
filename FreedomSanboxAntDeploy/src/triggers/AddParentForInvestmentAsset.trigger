trigger AddParentForInvestmentAsset on Investment_Asset__c (before insert,before update) {
    
    HandlerForParentForInvestmentAsset OBJinvestmentAsset = new HandlerForParentForInvestmentAsset();
    if(trigger.isInsert)
    {
        system.debug('------------------------------------------------------------------ trigger fired');
        OBJinvestmentAsset.beforeInvestmentAssetInsert(Trigger.new); 
    }
    if(Trigger.isUpdate)
    {
        OBJinvestmentAsset.beforeUpdateInvestmentAsset(trigger.new,trigger.old);
    }
}