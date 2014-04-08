/*
	
	Revision History:
	
    Version     Version Author     Date         Comments
    1.0			Manasi			   15/06/2011	Issue ID :F0029 :BeforeInsertBeforeUpdateAccount trigger is created to assign value to 
    											Current_Age__c field. 
    											1)It will calculate age from birthdate if birthdate is not null
    											2)Else it will assign Age__c if Age__c is not null
    											3)Else it will assign value from label
									 
*/
trigger BeforeInsertBeforeUpdateAccount on Account (before insert, before update,after update,after insert) 
{
	System.debug('==========BeforeInsertBeforeUpdateAccount==========b4============>'+StaticMethodClass.isAccountUpsertFired);
	if(StaticMethodClass.isAccountUpsertFired)	/* Prajakta - 9-6-2013 */
	{
		System.debug('==========BeforeInsertBeforeUpdateAccount===========after===============>'+StaticMethodClass.isAccountUpsertFired);
		if(Trigger.isAfter && trigger.isInsert)
		{
			System.debug('====================================>'+trigger.newMap);
			System.debug('====================================>'+trigger.new);
			AccountHandler.updateGlobalAssumption(trigger.new,trigger.newMap,true);
		}
		
		if(trigger.isAfter && trigger.isUpdate)
		{
			for(Account objNewAcc : trigger.new){
				Account objOldAcc = trigger.oldMap.get(objNewAcc.Id);
				if(objOldAcc.OwnerId != objNewAcc.OwnerId){
				//	System.debug('=========Inside the BeforeInsertBeforeUpdateAccount ==============>');
					AccountHandler.updateGlobalAssumption(trigger.new,trigger.newMap,false); break;		
				}
			}
		}
		
		if((Trigger.isInsert && trigger.isBefore) || (trigger.isUpdate && trigger.isInsert))
		{
			 for(Integer j = 0; trigger.new.size()>j; j++)
			 {
			 	if(trigger.new[j].PersonBirthdate != null)
			 		trigger.new[j].Current_Age__c = system.today().year() - trigger.new[j].PersonBirthdate.year() + 1;
				else if(trigger.new[j].Age__c != null )
					trigger.new[j].Current_Age__c = trigger.new[j].Age__c;	 	
				else
					trigger.new[j].Current_Age__c = Decimal.valueOf(Label.Current_Age);
					
				if(trigger.new[j].Virtual_Partner__c != null){
					trigger.new[j].Related_To__c = 'Virtual Partner';
				}	
			}
			//AccountHandler.updateGlobalAssumption(trigger.new,trigger.newMap,false);
		}
		 
		if((trigger.isInsert && trigger.isBefore) || (trigger.isBefore && trigger.isUpdate))
		{
		 	// Entity Owner Check
		 	for(Account objNewAcc : trigger.new)
		 	{
		 		if(trigger.oldMap != null){
		 			
		 			Account objOldAcc = trigger.oldMap.get(objNewAcc.Id);
			 		if(objOldAcc.OwnerId != objNewAcc.OwnerId){
			 			AccountHandler.BeforeInsertBeforeUpdateAccount(trigger.new);
			 		}else if(objOldAcc.Virtual_Partner__c != objNewAcc.Virtual_Partner__c){
			 			AccountHandler.BeforeInsertBeforeUpdateAccount(trigger.new);
			 		}
		 		}
		 	}
		}
	}
}