trigger BeforeInsertBeforeUpdateLead on Lead (before insert, before update) 
{
	/*For setting checkbox as true for all the partner lead.
   	/Date : 3/8/12 , Code Added By : Aditi */
   	List<Lead> lstLead = trigger.new;
   	
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
					 objLead.Related_To__c = 'Virtual Partner';
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
   		
   		Map<Id, Id> mapContactIdToEntityId = new Map<Id, Id>();
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
   		}
   	}
}