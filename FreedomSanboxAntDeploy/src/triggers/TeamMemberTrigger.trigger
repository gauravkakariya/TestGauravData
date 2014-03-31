/*
	Revision History:
    Version     Version Author    Date          Comments
	2.0			Prajakta Sanap	 25/09/2013   1.Trigger for Team Member
*/


trigger TeamMemberTrigger on Team_Member__c (before insert, before update, before delete) 
{
	TeamMemberHandler objTeamMemberHandler = new TeamMemberHandler();
	
    if (trigger.isBefore && trigger.isInsert) 
    {
    	objTeamMemberHandler.DupeCheckforUserAndDepartment(trigger.new);
    }
    
    if (trigger.isBefore && trigger.isUpdate) 
    {
    	objTeamMemberHandler.DupeCheckforUserAndDepartment(trigger.new);
    	objTeamMemberHandler.StatusCheckforTest(trigger.new, trigger.oldMap, trigger.newMap);
    }
    
    if (trigger.isBefore && trigger.isDelete) 
    {
    	objTeamMemberHandler.partnerTeamMemberDeletion(trigger.old);
    }
}