/*
	Revision History:
    Version     Version Author    Date          	Comments
    1.0			Gaurav			 09/1/2013		1. Wellness Lead Transfer Code
	2.0			Prajakta Sanap	 25/09/2013     1.Handler for TeamMemberTrigger
*/


//Commented by prajakta as seperate LeadTrigger is created.
trigger WellnessLeadTrigger on Lead (after update) 
{
     WellnessLeadHandler handler = new WellnessLeadHandler();  
     handler.onAfterUpdate(Trigger.new, Trigger.old);
     /*
     LeadHandler objLeadHandler = new LeadHandler();
     objLeadHandler.chatterPostGeneration(trigger.new, trigger.oldMap, trigger.newMap);
     */
}