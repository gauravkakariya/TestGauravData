trigger AddParentForAsset on Asset__c (before insert, before update)
{
    //HandlerForParentForAsset objAsset = new HandlerForParentForAsset();

    if(Trigger.isInsert)
    {
        new HandlerForParentForAsset(trigger.old,trigger.new).beforeAssetInsert();
        //objAsset.beforeAssetInsert(trigger.new);
    }

    if(Trigger.isUpdate)
    {
        new HandlerForParentForAsset(trigger.old,trigger.new).beforeUpdateAsset();
        //objAsset.beforeUpdateAsset(trigger.new,trigger.old);
    }
}