trigger AfterDeleteOnEntityGlobalAssumption on Entity_Global_Assumption__c (after delete) 
{
    HandlerForAfterDeleteOnEntityGlobalAssum objHandlerEntityGlobalAssumption = new HandlerForAfterDeleteOnEntityGlobalAssum();
    objHandlerEntityGlobalAssumption.afterDeleteEntityGlobalAssumption(trigger.old);
}