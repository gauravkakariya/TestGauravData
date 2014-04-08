/*
  Created By : Niket Chandane
  Created At : 24 June 2011
  Summary    : This trigger is fired when Entity Owner changes, then all the child entities 
         respective the Main entity follows the same Owner of Main entity.
  Issue      : F0062 (Enhancement).
*/
trigger UpdateEntityOwner on Account (after update, before insert,before update)
{
	System.debug('==========BeforeInsertBeforeUpdateAccount==========b4============>'+StaticMethodClass.isAccountUpsertFired);
  	if(trigger.isAfter && trigger.isUpdate && StaticMethodClass.isAccountUpsertFired)
  	{
  		System.debug('==========BeforeInsertBeforeUpdateAccount=========after========>'+StaticMethodClass.isAccountUpsertFired);
    	OnEntityOwnerChange objOnEntityOwnerChange = New OnEntityOwnerChange();
    	objOnEntityOwnerChange.UpdateEntityOwner(trigger.newMap);
  	}
  	else if(trigger.isBefore && trigger.isUpdate)
  	{
    	//Allow to update entity owner only if profile id is 'System Administrator'
    	OnEntityOwnerChange objOnEntityOwnerChange = New OnEntityOwnerChange();
    	objOnEntityOwnerChange.ChangeOfOwner(trigger.newMap,trigger.oldMap);
  	}
  	
  	/* Aditi - Updation of Entity owner of family memeber on insertion for Business partner only */
  	if(trigger.isBefore && trigger.isInsert)
  	{
  		OnEntityOwnerChange objOnEntityOwnerChange = New OnEntityOwnerChange();
  		objOnEntityOwnerChange.updateOwnerofFamilyMember(trigger.new);
  	}
}