trigger TriggerForAnyDmlOnAccount on Account (before delete, after insert, after update) 
{
   HandlerForAnyDMLOnAccount objHandlerAccount = new HandlerForAnyDMLOnAccount();
   if(Trigger.isDelete)
   objHandlerAccount.afterDeleteAccount(Trigger.old);
   else
   objHandlerAccount.afterInserORUpdateAccount(Trigger.new,Trigger.isInsert,Trigger.isUpdate);
}