/*
    Created By : Niket Chandane
    Created At : 24 June 2011
    Summary    : This Class is used for the "UpdateEntityOwner" trigger.
    Issue      : F0062 (Enhancement).
*/
public without sharing class OnEntityOwnerChange 
{
        
     public void UpdateEntityOwner(Map<Id,Account> mapUpdatedEntity)  
     {
         if(mapUpdatedEntity!= null && mapUpdatedEntity.size() >0)
        {
             List<Account> lstAccountToUpdate = New List<Account>();
            /** Eternus Solutions       **/
            /** Author  : Manasi Ranade **/
            /** Issue Id: F0061         **/
            /** Date    : 29/06/2011    **/
            /** Purpose : "UpdateEntityOwner" trigger was throwing an exception while changing owner of an Inactive entity.
                           So added condition 'Entity_Status__c = Active'in where clause while selecting an entity
            /****************************************************/ 
            /*
                    Author : Trupti
                    Date :11/17/2011
                    Purpose :Change owner of all entity there is no entity status field in child entity
                    Issue : FS0288 
            */ 
           system.debug('-mapUpdatedEntity.keySet()--'+mapUpdatedEntity.keySet());
           List<Account> lstAccount = [Select a.OwnerId,a.Parent_Entity__c,Related_To__c,Virtual_Partner__c,PST_Team_Member__c,
           								 MST_Team_Member__c,FPA_Team_Member__c,OPS_Team_Member__c
           								 From Account a where a.Parent_Entity__c In : mapUpdatedEntity.keySet()];
           System.debug('lstAccount ====================>'+lstAccount);
                                            
            if(lstAccount != null && lstAccount.size() > 0)
            {
                for(Account ObjAccount : lstAccount)
                {
                	System.debug('mapUpdatedEntity ====================>'+mapUpdatedEntity.ContainsKey(ObjAccount.Parent_Entity__c));
                    if(mapUpdatedEntity.ContainsKey(ObjAccount.Parent_Entity__c))
                    {
                    	/*
                        ObjAccount.OwnerId = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).OwnerId;
                        ObjAccount.Related_To__c = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).Related_To__c;
                        ObjAccount.Virtual_Partner__c = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).Virtual_Partner__c;
                        ObjAccount.PST_Team_Member__c = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).PST_Team_Member__c;
                        ObjAccount.MST_Team_Member__c = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).MST_Team_Member__c;
                        ObjAccount.FPA_Team_Member__c = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).FPA_Team_Member__c;
                        ObjAccount.OPS_Team_Member__c = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).OPS_Team_Member__c;
                        */
                        System.debug('ObjAccount ====================>'+ObjAccount);
                        lstAccountToUpdate.add(ObjAccount);
                    }
                 }
                if(lstAccountToUpdate != null && lstAccountToUpdate.size() > 0 )
                {
                   database.update(lstAccountToUpdate);
                }
            }
        }
    }
    /*********************************************UpdateEntityOwner Ends*************************************/
    
   /*****Code for Change Of Owner Before Update Trigger **********
    
    public void ChangeOfOwner(Map<Id,Account> NewMapEntity,MAp<Id,Account> mapOldEntities)
    {
    	 System_Admin__c objSystemAdmin = System_Admin__c.getInstance('System Administrator');
    	 List<Account> lstNewAccount = trigger.new;
    	 if(objSystemAdmin!= null && objSystemAdmin.System_Administrator_Id__c != null)
         {
         	for(Account objAccNew : lstNewAccount)
		    {
		     	Account objAccOld = mapOldEntities.get(objAccNew.Id);
		        if(objAccNew.OwnerId != objAccOld.OwnerId)
				{
                	if(Userinfo.getProfileId() != objSystemAdmin.System_Administrator_Id__c)
                	{
                		objAccNew.addError(Label.ErrorMsgForEntityOwnerChange);
                	}
		         }
		 	}
	     }
    }*/
    /*
		Author : Mahesh Hirugade
		Date :02 April 2012
		Purpose :	As requested by Haren access of changing entity owner are gine to Sunitha V
					Commented above code
		Case No : 00001574
    */
    public void ChangeOfOwner(Map<Id,Account> NewMapEntity,MAp<Id,Account> mapOldEntities)
    {
    	 System_Admin__c objSystemAdmin = System_Admin__c.getInstance('System Administrator');
    	 Compliance_Profile__c objComplainceProfile = Compliance_Profile__c.getInstance('Profile Id');
    	 
    	 //Sunitha_User_Id__c objSunithaUserId = Sunitha_User_Id__c.getInstance('Sunitha');
    	 List<Account> lstNewAccount = trigger.new;
    	 if(objSystemAdmin!= null && objSystemAdmin.System_Administrator_Id__c != null)
         {
         	for(Account objAccNew : lstNewAccount)
		    {
		     	Account objAccOld = mapOldEntities.get(objAccNew.Id);
		        if(objAccNew.OwnerId != objAccOld.OwnerId)
				{
                	if(Userinfo.getProfileId() != objSystemAdmin.System_Administrator_Id__c && Userinfo.getProfileId().substring(0, 15) != objComplainceProfile.Compliance_Profile_Id__c)// && Userinfo.getUserId() != objSunithaUserId.UserId__c)
                	{
                		objAccNew.addError(Label.ErrorMsgForEntityOwnerChange);
                	}
		        }
		 	}
	     }
    }
    
    /* Aditi - Updation of Entity owner of family memeber on insertion for Business partner only */
    /* Aditi Updated on : 12/6/13- Updation of Entity owner of family memeber on insertion for all types of Partners */
    /* Aditi Updated on : 24/9/13- Updation of Entity owner of Client Entity on insertion for all types of Partners */
    public void updateOwnerofPartnerRelatedEntities_FamilyMembers(List<Account> lstNewAccount)
    {
    	//Map<Id,User> mapIdToUser = new Map<Id,User>(); 
    	Id familyRecId = RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c;
    	Map<Id,Account> mapIdtoAccount = new Map<Id,Account>([Select Id, Name,Related_To__c,Channel_Manager__c, Virtual_Partner__c,
    									PST_Team_Member__c,MST_Team_Member__c,FPA_Team_Member__c,OPS_Team_Member__c,Business_Unit__c,
    								OwnerId, owner.name from Account where RecordType.Name = 'Client']);
		//mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User where isActive = true]);
    	Map<Id,Account> mapIdToPartnerAccount = new Map<Id,Account>([Select Id, Name,Related_To__c,Channel_Manager__c, OwnerId, owner.name 
    											from Account where RecordType.Name = 'General']);
    	system.debug('*****mapIdToPartnerAccount********'+mapIdToPartnerAccount.keySet());										
    	for(Account objAcc : lstNewAccount)
    	{
    		system.debug('*****objAcc********'+objAcc);
    		system.debug('****objAcc.RecordTypeId*****'+objAcc.RecordTypeId);
    		system.debug('****objAcc.RecordTypeId**GetInstance***'+RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
    		
    		//updateOwnerofFamilyMember same as its Parent Entity
    		if(objAcc.RecordTypeId == familyRecId)
    		{
	    		if(objAcc.Parent_Entity__c != null)
	    		{
	    			if(mapIdToAccount.containsKey(objAcc.Parent_Entity__c))
	    			{
	    				Account parentAcc = mapIdToAccount.get(objAcc.Parent_Entity__c);
	    				//if(parentAcc.Related_To__c == 'Business Partner')
	    				//{
	    					//if(mapIdToUser.containsKey(parentAcc.OwnerId))
	    					//{
    							objAcc.OwnerId = parentAcc.OwnerId;
    							objAcc.Related_To__c = parentAcc.Related_To__c;
    							objAcc.Virtual_Partner__c = parentAcc.Virtual_Partner__c;
    							objAcc.PST_Team_Member__c = parentAcc.PST_Team_Member__c;
				        		objAcc.MST_Team_Member__c = parentAcc.MST_Team_Member__c;
				        		objAcc.FPA_Team_Member__c = parentAcc.FPA_Team_Member__c;
				        		objAcc.OPS_Team_Member__c = parentAcc.OPS_Team_Member__c;
				        		objAcc.Business_Unit__c = parentAcc.Business_Unit__c;
	    						system.debug('--------objAcc------'+objAcc);
	    					//}
	    				//}
	    			}
	    		}
    		}
    		//updateOwnerofEntity same as its Partner Entity Owner
    		else if (objAcc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
    		{
    			if(objAcc.Virtual_Partner__c != null)
    			{
    				if(mapIdToPartnerAccount.containsKey(objAcc.Virtual_Partner__c))
    				{
    					Account objPartnerAcc = mapIdToPartnerAccount.get(objAcc.Virtual_Partner__c);
    					objAcc.OwnerId = objPartnerAcc.OwnerId;
    					objAcc.Related_To__c = objPartnerAcc.Related_To__c;
    					system.debug('------Else --objAcc------'+objAcc);
    				}
    			}
    		}
    	}
    }
    /* Aditi Added on : 24/9/13- ON Partner Entity Owner change - need to Update its corresponding Entities and Leads Owner also */
    /* Aditi Added on : 16/10/13- ON Partner Related To change - need to Update its corresponding Entities and Leads Related To also */
    public void OnPartnerOwnerChangeUpdateEntity_Lead_Owner(Map<Id,Account> mapIdToNewPartnerAcc,Map<Id,Account> mapIdToOldPartnerAcc)
    {
    	List<Account> updateList = new List<Account>();
    	List<Lead> updateLeadList = new List<Lead>();
    	
    	Map<Id,List<Account>> mapIdtoAccount = new Map<Id,List<Account>>(); 
    	Map<Id,List<Lead>> mapIdtoLead = new Map<Id,List<Lead>>(); 
    	List<Account> lstEntitiesToUpdate= new List<Account>();
    	Set<Id> setVirtualPartnerId = new Set<Id>();
    	
    	for(Account objAcc : mapIdToNewPartnerAcc.values())
    	{
    		if(objAcc.OwnerId != mapIdToOldPartnerAcc.get(objAcc.Id).OwnerId 
    			|| objAcc.Related_To__c != mapIdToOldPartnerAcc.get(objAcc.Id).Related_To__c
    			|| objAcc.PST_Team_Member__c != mapIdToOldPartnerAcc.get(objAcc.Id).PST_Team_Member__c)
    		{
    			setVirtualPartnerId.add(objAcc.Id);
    		}
    	}
    	
    	
    	lstEntitiesToUpdate = [Select Id, Related_To__c,Virtual_Partner__c, OwnerId, owner.name 
    							from Account where RecordType.Name = 'Client' 
    							and Virtual_Partner__c =: setVirtualPartnerId];// mapIdToNewPartnerAcc.keySet()];
    	List<Lead> lstLead = [Select Id, Related_To__c,Virtual_Partner__c, OwnerId 
    							from Lead where IsConverted = false 
    							and Virtual_Partner__c =: setVirtualPartnerId];// mapIdToNewPartnerAcc.keySet()];
    	for(Account objEntities : lstEntitiesToUpdate)
    	{
    		if(!mapIdToAccount.containsKey(objEntities.Virtual_Partner__c))
		    {
				
				List<Account> lst = new List<Account>();
				lst.add(objEntities);
				mapIdToAccount.put(objEntities.Virtual_Partner__c,lst);
			}
			else
			{
				mapIdToAccount.get(objEntities.Virtual_Partner__c).add(objEntities);
			}		
    	}
    	for(Lead objLead : lstLead)
    	{
    		if(!mapIdtoLead.containsKey(objLead.Virtual_Partner__c))
		    {
				
				List<Lead> lst = new List<Lead>();
				lst.add(objLead);
				mapIdtoLead.put(objLead.Virtual_Partner__c,lst);
			}
			else
			{
				mapIdtoLead.get(objLead.Virtual_Partner__c).add(objLead);
			}		
    	}
    	for(Account objPartnerAcc : mapIdToNewPartnerAcc.values())
    	{
    		Account OldPartnerAccount = new Account();
    		if(mapIdToOldPartnerAcc.containsKey(objPartnerAcc.Id))
    			OldPartnerAccount = mapIdToOldPartnerAcc.get(objPartnerAcc.Id);
    		
			if(mapIdToAccount.containsKey(objPartnerAcc.Id))
	    	{
				List<Account> lstPratnerRelatedEntities = mapIdToAccount.get(objPartnerAcc.Id);
				for(Account objEntitiesToBeUpdated : lstPratnerRelatedEntities)
				{
					if(OldPartnerAccount.OwnerId != objPartnerAcc.OwnerId)	
						objEntitiesToBeUpdated.OwnerId = objPartnerAcc.OwnerId;
					if(OldPartnerAccount.Related_To__c != objPartnerAcc.Related_To__c)
						objEntitiesToBeUpdated.Related_To__c = objPartnerAcc.Related_To__c;
						
					updateList.add(objEntitiesToBeUpdated);
				}
			}
			if(mapIdtoLead.containsKey(objPartnerAcc.Id))
			{
				List<Lead> lstPratnerRelatedLeads = mapIdtoLead.get(objPartnerAcc.Id);
				for(Lead objLeadsToBeUpdated : lstPratnerRelatedLeads)
				{
					if(OldPartnerAccount.OwnerId != objPartnerAcc.OwnerId)	
						objLeadsToBeUpdated.OwnerId = objPartnerAcc.OwnerId;
					if(OldPartnerAccount.Related_To__c != objPartnerAcc.Related_To__c)
						objLeadsToBeUpdated.Related_To__c = objPartnerAcc.Related_To__c;
					if(OldPartnerAccount.PST_Team_Member__c != objPartnerAcc.PST_Team_Member__c)
						objLeadsToBeUpdated.PST_Team_Member__c = objPartnerAcc.PST_Team_Member__c;
					updateLeadList.add(objLeadsToBeUpdated);
				}
			}
    	}
    	system.debug('------updateList----'+updateList.size());
    	system.debug('------updateLeadList----'+updateLeadList.size());
    	if(!updateList.isEmpty())
    		update updateList;
    	if(!updateLeadList.isEmpty())
    		update updateLeadList;	
    		
    }
}