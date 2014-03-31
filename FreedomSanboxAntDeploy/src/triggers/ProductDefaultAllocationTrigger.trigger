/*
    Revision History:
    Version     Version Author    Date              Comments
    1.0         Prajakta Sanap   28/11/2013   1. Trigger for ProductDefaultAllocationHandler to check 
    											 When Default Product Allocation record is inserted for each Partner, 
    											 sequence will be inserted upto 3 records.
                                 
*/

trigger ProductDefaultAllocationTrigger on Product_Default_Allocation__c (after insert, before insert, before update) 
{
	ProductDefaultAllocationHandler objProductDefaultAllocationHandler = new ProductDefaultAllocationHandler();
	
	if(trigger.isAfter && trigger.isInsert)
    {
    	system.debug('-------after insert ProductDefaultAllocationHandler----------');
    	//objProductDefaultAllocationHandler.checkSequence(trigger.new);//, trigger.oldMap); 
    }
    
    if (trigger.isBefore && trigger.isInsert) 
    {
    	system.debug('-------before insert ProductDefaultAllocationHandler----------');
    	objProductDefaultAllocationHandler.DupeCheckforSequence(trigger.new);
    	objProductDefaultAllocationHandler.DupeCheckofProductForSamePartner(trigger.new);
    	//objProductDefaultAllocationHandler.checkSequence(trigger.new);//, trigger.oldMap);
    }
    
    if (trigger.isBefore && trigger.isUpdate) 
    {
    	system.debug('-------before update ProductDefaultAllocationHandler----------');
    	objProductDefaultAllocationHandler.DupeCheckforSequence(trigger.new);
    	objProductDefaultAllocationHandler.DupeCheckofProductForSamePartner(trigger.new);
    }
}