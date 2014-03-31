/*
	Revision History:
    Version     Version Author    Date          Comments
	2.0			Prajakta Sanap	 25/09/2013   1.Handler for TeamMemberTrigger
*/

public with sharing class TeamMemberHandler 
{
	/* Function to check for duplicate allocation to same user to same department */
	public void DupeCheckforUserAndDepartment(List<Team_Member__c> newList)
	{
		for(Team_Member__c objTeam : newList)
		{
			if(objTeam.Team_Member__c != null)
			{	
				objTeam.CustomUniqueKey__c = objTeam.Team_Member__c + ' ' + objTeam.Department__c;
				system.debug('-------objTeam.CustomUniqueKey__c----------'+objTeam.CustomUniqueKey__c);
			}
		}
	}
	
	/* Function to check if Team Member record is made inactive or suspended if it's used somewhere */
	public void StatusCheckforTest(List<Team_Member__c> newList, map<Id,Team_Member__c> oldMap, map<Id,Team_Member__c> newMap)
	{
		set<Id> teamMemberIdSet = new set<Id>();
		
		for(Team_Member__c objTeam : newList)
		{
			if(objTeam.Status__c != oldMap.get(objTeam.Id).Status__c)
			{
				teamMemberIdSet.add(objTeam.Id);
			}
		}
		
		if(teamMemberIdSet.size() != 0)
		{
			List<Team_Member__c> lstTeamMember = [Select Team_Member__c, Status__c, Name, Id, Entity_Allocation_Count__c, Partner_Allocation_Count__c,
													(Select Id, RecordTypeId, LastModifiedDate From Accounts2__r),
													(Select Id, RecordTypeId, LastModifiedDate From Accounts1__r),
													(Select Id, RecordTypeId, LastModifiedDate From Accounts__r),
													(Select Id, RecordTypeId, LastModifiedDate From Accounts3__r)
													From Team_Member__c where Id IN : teamMemberIdSet];
			system.debug('-------lstTeamMember----------'+lstTeamMember);
			
			for(Team_Member__c objTeam : lstTeamMember)
			{
				if(objTeam.Accounts2__r.size() > 0) //PST
					newMap.get(objTeam.id).addError(Label.PST_Status_Change);
				if(objTeam.Accounts1__r.size() > 0)
					newMap.get(objTeam.id).addError(Label.MST_Status_change);
				if(objTeam.Accounts__r.size() > 0)
					newMap.get(objTeam.id).addError(Label.FPA_Status_Change);
				if(objTeam.Accounts3__r.size() > 0)
					newMap.get(objTeam.id).addError(Label.MST2_Status_change);
			}										
		}
	}
	
	/* 3 records of Partner Team Member Allocation will be deleted if related team member is deleted */
	public void partnerTeamMemberDeletion(List<Team_Member__c> oldList)
	{
		List<Partner_Team_Member_Allocation__c> lst = [Select p.Partner__c, p.Name, p.Id, p.Allocation_Date__c, p.Allocated_By__c,p.Team_Member__c 
														From Partner_Team_Member_Allocation__c p 
														where p.Team_Member__c IN : oldList];
		system.debug('----lst----'+lst);
		if(lst.size() > 0)
			delete lst;
	}
	
}