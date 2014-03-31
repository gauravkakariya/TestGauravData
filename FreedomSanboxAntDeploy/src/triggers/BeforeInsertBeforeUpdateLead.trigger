trigger BeforeInsertBeforeUpdateLead on Lead (before insert, before update) 
{
	/*For setting checkbox as true for all the partner lead.
   	/Date : 3/8/12 , Code Added By : Aditi */
   	List<Lead> lstLead = trigger.new;
   	Map<Id, List<Lead>> mapEntityIdTolstLead = new Map<Id, List<Lead>>();
   	for(Lead objLead : trigger.new)
   	{
   		if(!mapEntityIdTolstLead.containsKey(objLead.Virtual_Partner__c))
   		{
   			mapEntityIdTolstLead.put(objLead.Virtual_Partner__c, new List<Lead>{objLead});
   			
   		}
   		else
   		{
  			mapEntityIdTolstLead.get(objLead.Virtual_Partner__c).add(objLead);
   		}
   	}
   	system.debug('------------mapEntityIdTolstLead----------'+mapEntityIdTolstLead);
   	
   	Map<String, Id> mapEntityNameToId = new Map<String, Id>();
   	Map<Id,Account> mapIdToAccount = new Map<Id,Account>();
   	
   	Set<Id> PartnerOwnerId = new Set<Id>();
   	for(Account objAccount : [select Id, Name, OwnerId, Owner.Name,Related_To__c from Account where Id IN: mapEntityIdTolstLead.keySet()])
   	{
   		mapEntityNameToId.put(objAccount.Owner.Name, objAccount.Id);
   		mapIdToAccount.put(objAccount.Id,objAccount);
   		PartnerOwnerId.add(objAccount.OwnerId);
   		system.debug('------------PartnerOwnerId----------'+PartnerOwnerId);
   	}	
   		
   	if(lstLead != null && lstLead.size()>0)
   	{
    	List<User> user = [select Id, Name, ProfileId, ContactId, Profile.Name from User where Id =: lstLead[0].OwnerId];
		if(user != null && user.size()>0)
		{
			for(Lead objLead : lstLead)
			{
		        if(user[0].ContactId!=null)
			 	{
					objLead.IsLeadCreatedByPartner__c = true;
					//need to comment below statement
					objLead.Related_To__c = 'Business Partner';
				}
				//need to comment below else block
				else if(objLead.Virtual_Partner__c != null)
			 	{
			 		if(mapIdToAccount.containsKey(objLead.Virtual_Partner__c))
			 		{
			 			if(mapIdToAccount.get(objLead.Virtual_Partner__c).Related_To__c == 'Ffreedom')
			 			{
			 				objLead.Related_To__c = 'Ffreedom';
			 			}
					 	else
					 	{
					 		objLead.Related_To__c = 'Virtual Partner';
					 	}
			 		}
				}
				else
				{
					objLead.IsLeadCreatedByPartner__c = false;
					//need to comment below statement
					objLead.Related_To__c = 'Ffreedom';
				}
		            
			}	
		}
   	}
   	
   	if(trigger.isBefore && trigger.isInsert)
   	{
   		
   		
   		/*Map<Id, Id> mapContactIdToEntityId = new Map<Id, Id>();
   		for(Account objAccount : [select Id, Name, OwnerId, Related_To__c, (Select Id from contacts) from Account where Id IN: mapEntityIdTolstLead.keySet() and Related_To__c =: 'Business Partner'])
   		{
   			for(Contact objContact : objAccount.Contacts)
   			{
   				mapContactIdToEntityId.put(objContact.Id, objAccount.Id);
   			}
   		}
   		
   		for(User objUser : [Select Id, Name, ContactId from User where ContactId IN: mapContactIdToEntityId.keySet()])
   		{
   			for(Lead objLead : mapEntityIdTolstLead.get(mapContactIdToEntityId.get(objUser.ContactId)))
   			{
   				objLead.OwnerId = objUser.Id;
   			}
   		}*/
   		
   		
   		for(User objUser : [Select Id, Name, ManagerId from User where Id IN: PartnerOwnerId])
   		{
   			system.debug('------------objUser----------'+objUser.Name);
   			for(Lead objLead : mapEntityIdTolstLead.get(mapEntityNameToId.get(objUser.Name)))
   			{
   				system.debug('------------objLead----------'+objLead);
   				if(String.valueOf(objUser.Id).contains(Label.Technology_Support_Id))//00520000001MO8DAAW
   				{
   					objLead.OwnerId = UserInfo.getUserId();
   					system.debug('------------objLead.OwnerId---insert------------'+objLead.OwnerId);
   				}
   				else
   				{
   					objLead.OwnerId = objUser.Id;
   					system.debug('------------objLead.OwnerId---insert--else----------'+objLead.OwnerId);
   				}
   			}
   		}
   	}
   	
   	if(trigger.isBefore && trigger.isUpdate)
   	{
   		for(Lead objLead : lstLead)
		{
   			if(trigger.oldMap.get(objLead.Id).Virtual_Partner__c != trigger.newMap.get(objLead.Id).Virtual_Partner__c)
   			{
   				if(trigger.newMap.get(objLead.Id).Virtual_Partner__c != null 
   					&& mapIdToAccount.get(trigger.newMap.get(objLead.Id).Virtual_Partner__c) != null
   					&& (!String.valueOf(mapIdToAccount.get(trigger.newMap.get(objLead.Id).Virtual_Partner__c).OwnerId).contains(Label.Technology_Support_Id)))
   				{
   					objLead.OwnerId = mapIdToAccount.get(trigger.newMap.get(objLead.Id).Virtual_Partner__c).OwnerId;
   					system.debug('------------objLead.OwnerId---------------'+objLead.OwnerId);
   				}
   			}
		}
   	}
}