/*
	Revision History:
    Version     Version Author    Date          Comments
	
*/

trigger BusinessUnitTrigger on Business_Unit__c (after insert, after update, before insert, before update) 
{
	BusinessUnitHandler objBusinessUnitHandler = new BusinessUnitHandler();
	
	if(trigger.isBefore && trigger.isInsert)
    {
    //	objBusinessUnitHandler.onBeforeInsertCheckActiveBusinessUnit(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isUpdate)
    {
    //	objBusinessUnitHandler.onBeforeInsertCheckActiveBusinessUnit(trigger.new);
    }
}