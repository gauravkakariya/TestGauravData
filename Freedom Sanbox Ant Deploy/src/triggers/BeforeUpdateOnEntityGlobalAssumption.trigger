trigger BeforeUpdateOnEntityGlobalAssumption on Entity_Global_Assumption__c (before update)
{
    HandlerForBeforeUpdateOnEntityGlobalAssu objEntityAssumption = new HandlerForBeforeUpdateOnEntityGlobalAssu();
    objEntityAssumption.beforeUpdateEntityGlobalAssumption(trigger.new, trigger.old);
}