/*
	Revision History:
    Version     Version Author    Date          	Comments
    1.0			Gaurav			 09/1/2013		1. Wellness Lead Transfer Code
	2.0			Prajakta Sanap	 25/09/2013     1.Handler for TeamMemberTrigger
*/

trigger LeadTrigger on Lead (after update, before insert, before update, after insert, before delete) 
{
	if (trigger.isAfter && trigger.isUpdate) 
    {
    	StaticMethodClass.isUpdateFired = false;
    	{
	    	system.debug('--------after update---------:');
	    	/*WellnessLeadHandler handler = new WellnessLeadHandler();  
			handler.onAfterUpdate(Trigger.new, Trigger.old);
			*/
			LeadHandler objLeadHandler = new LeadHandler();
		    objLeadHandler.chatterPostGeneration(trigger.new, trigger.oldMap, trigger.newMap);
		    objLeadHandler.leadTeamMemberUpdation(trigger.new, trigger.oldMap);
		    
		    //PathfinderLeadHandler objPathfinderLeadHandler = new PathfinderLeadHandler();
	    	//objPathfinderLeadHandler.convertLeadToEntity(trigger.new, trigger.oldMap);
    	}
    }
    
    if(trigger.isBefore && trigger.isInsert) 
    {
        system.debug('----------isBefore-----Insert--------');
        LeadHandler objLeadHandler = new LeadHandler();
        //objLeadHandler.assignTeamMember(trigger.new);
        objLeadHandler.assignPSTTeamMemberOnChangeOfPO(trigger.new, trigger.oldMap);
    }
    
    if (trigger.isAfter && trigger.isInsert) 
    {
		system.debug('--------isAfter isInsert---------:');
    	LeadHandler objLeadHandler = new LeadHandler();
    	
    	//if(!Test.isRunningTest())
    	{
        	system.debug('---------leadSharing-------after insert------');
        	objLeadHandler.leadSharing(trigger.new, trigger.oldMap, trigger.newMap,trigger.isInsert);  
        }
    	objLeadHandler.leadTeamMemberAllocation(trigger.new);
    	
    	//PathfinderLeadHandler objPathfinderLeadHandler = new PathfinderLeadHandler();
    	//objPathfinderLeadHandler.convertLeadToEntity(trigger.new, trigger.oldMap);
    }
    
    if (trigger.isBefore && trigger.isUpdate)
    {
    	system.debug('--------b4 isUpdate---------:');
    	
    	LeadHandler objLeadHandler = new LeadHandler();
    	//objLeadHandler.assignTeamMember(trigger.new);
    	objLeadHandler.assignPSTTeamMemberOnChangeOfPO(trigger.new, trigger.oldMap);
    	
    	//if(!Test.isRunningTest())
    	{
        	system.debug('---------leadSharing-------after------');
        	objLeadHandler.leadSharing(trigger.new, trigger.oldMap, trigger.newMap,trigger.isInsert);  
        }
    }
    
    if(trigger.isBefore && trigger.isDelete)
    {
    	LeadHandler objLeadHandler = new LeadHandler();
        objLeadHandler.LeadTeamMemberDeletion(trigger.old);
    }  
}