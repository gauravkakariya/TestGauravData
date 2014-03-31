/*
  Created By : Niket Chandane
  Created At : 24 June 2011
  Summary    : This trigger is fired when Entity Owner changes, then all the child entities 
         respective the Main entity follows the same Owner of Main entity.
  Issue      : F0062 (Enhancement).
*/
trigger UpdateEntityOwner on Account (after update, before insert,before update)
{
	System.debug('==========UpdateEntity_Lead_Owner==========b4============>'+StaticMethodClass.isAccountUpsertFired);
  	if(trigger.isAfter && trigger.isUpdate) // && StaticMethodClass.isAccountUpsertFired) //Prajakta - 27-12-2013
  	{
  		OnEntityOwnerChange objOnEntityOwnerChange = New OnEntityOwnerChange();
  		if(StaticMethodClass.isAccountUpsertFired)
  		{
    		objOnEntityOwnerChange.UpdateEntityOwner(trigger.newMap);
  		}
		System.debug('==========UpdateEntity_Lead_Owner=========after========>'+StaticMethodClass.isAccountUpsertFired);
    	objOnEntityOwnerChange.OnPartnerOwnerChangeUpdateEntity_Lead_Owner(trigger.newMap,trigger.oldMap);
  	}
  	if(trigger.isBefore && trigger.isUpdate) 
  	{
    	//Allow to update entity owner only if profile id is 'System Administrator'
    	OnEntityOwnerChange objOnEntityOwnerChange = New OnEntityOwnerChange();
    	objOnEntityOwnerChange.ChangeOfOwner(trigger.newMap,trigger.oldMap);
  	}
  	
  	/* Aditi - Updation of Entity owner of family member and Client Entity on insertion */
  	if(trigger.isBefore && trigger.isInsert)
  	{
  		OnEntityOwnerChange objOnEntityOwnerChange = New OnEntityOwnerChange();
  		objOnEntityOwnerChange.updateOwnerofPartnerRelatedEntities_FamilyMembers(trigger.new);
  	}
}