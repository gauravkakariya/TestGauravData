/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 26/09/2013   1.Handler to trigger the Approval process for account
	
*/

public class LeadHandler 
{
	/* 1 records of Lead Team Member Allocation will be created at the time of new lead creation and PST is assigned to them */
    public void leadTeamMemberAllocation(List<Lead>LeadNewList)
    {
        List<Lead_Team_Member_Allocation__c> lstPTM = new List<Lead_Team_Member_Allocation__c>();
        set<Id> newLeads = new set<Id>();
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        
        for(Lead objLead : LeadNewList)
        {
        	if(objLead.Virtual_Partner__c != null)
            	newLeads.add(objLead.Virtual_Partner__c);
        }
        system.debug('----newLeads------'+newLeads);
        if(newLeads.size() != 0)
        {
	        mapIdToAccount = new map<Id, Account>([Select Id, PST_Team_Member__c, RecordTypeId, Business_Unit__c,Related_To__c ,OwnerId
	                                                                from Account 
	                                                                where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c
	                                                                and Id IN: newLeads]);
	        system.debug('----mapIdToAccount---'+mapIdToAccount);                                              
	        for (Lead objLead : LeadNewList) 
	        {
	            String EntityName = '';
	            if(objLead.LastName == null)
	                EntityName = objLead.FirstName;
	            else if(objLead.FirstName == null )
	                EntityName = objLead.LastName;
	            else if(objLead.LastName != null && objLead.FirstName != null)
	                EntityName = objLead.FirstName +' '+ objLead.LastName;
	            else 
	                EntityName = '';
	            
	            system.debug('----objLead------'+objLead);
	            Lead_Team_Member_Allocation__c objPTM1 = new Lead_Team_Member_Allocation__c();
	           /* if(mapIdToAccount.containsKey(objLead.Virtual_Partner__c)) 
				{
	            	objPTM1.Team_Member__c = mapIdToAccount.get(objLead.Virtual_Partner__c).PST_Team_Member__c;
				}*/
				objPTM1.Team_Member__c = objLead.PST_Team_Member__c;
	            objPTM1.Name = 'PST - ' + EntityName;
	            objPTM1.Lead__c = objLead.Id;
	            objPTM1.Allocation_Date__c = system.today();
	            objPTM1.Allocated_By__c = objLead.OwnerId;
	           
	            lstPTM.add(objPTM1);
	        }
	        system.debug('----lstPTM------'+lstPTM); 
	        insert lstPTM;
	    }
    }
    
    /* 1 record of Lead Team Member Allocation will be updated at the time of leads PST gets updated */
    public void leadTeamMemberUpdation(List<Lead>LeadNewList, Map<Id,Lead> oldMap)
    {
        map<Id,Id> mapLeadToOldTeamMember = new map<Id,Id>();
        map<Id,Id> mapLeadToNewTeamMember = new map<Id,Id>();
        set<Id> setofPST = new set<Id>(); 
        
        for (Lead objLead : LeadNewList) 
        {
            if(objLead.PST_Team_Member__c != oldMap.get(objLead.Id).PST_Team_Member__c)
            {
                mapLeadToOldTeamMember.put(objLead.Id,oldMap.get(objLead.Id).PST_Team_Member__c);
                mapLeadToNewTeamMember.put(objLead.Id,objLead.PST_Team_Member__c);
                system.debug('----mapLeadToOldTeamMember------'+mapLeadToOldTeamMember);
                system.debug('----mapLeadToNewTeamMember------'+mapLeadToNewTeamMember);
            }
        }
        
        if(mapLeadToNewTeamMember.values().size() != 0)
        {
            List<Lead_Team_Member_Allocation__c> lst = [Select p.Lead__c, p.OwnerId, p.Name, p.Id, p.Allocation_Date__c, p.Allocated_By__c,
            												p.Lead__r.OwnerId 
                                                            From Lead_Team_Member_Allocation__c p 
                                                            where p.Lead__c IN : mapLeadToNewTeamMember.keySet()
                                                            and p.Team_Member__c IN : mapLeadToOldTeamMember.values()];
            system.debug('----lst------'+lst); 
                                                           
            for(Lead_Team_Member_Allocation__c obj : lst)
            {
                // If team member of partner get changed, then assign the new ID of Team Member in Partner Team Member allocation object
                obj.Team_Member__c = mapLeadToNewTeamMember.get(obj.Lead__c);
                obj.Allocated_By__c = obj.Lead__r.OwnerId;
                obj.Allocation_Date__c = system.today();
                system.debug('----obj------'+obj);
            }       
            update lst;                                     
        }   
    }
    
    /* 1 records of Lead Team Member Allocation will be deleted if related lead is deleted */
    public void LeadTeamMemberDeletion(List<Lead>leadOldList)
    {
        List<Lead_Team_Member_Allocation__c> lst = [Select Lead__c, OwnerId, Name, Id, Allocation_Date__c, Allocated_By__c, Team_Member__c 
                                                            From Lead_Team_Member_Allocation__c
                                                            where Lead__c IN : leadOldList];
        system.debug('----lst----'+lst);
        if(lst.size() > 0)
            delete lst;
    }
	
	
	/* When new Lead is created, PST of its selected Practice owners will get assigned to corresponding entity*/
    public void assignPSTTeamMemberOnChangeOfPO(List<Lead>NewList, map<Id,Lead> OldMap)
    {
    	  system.debug('---assignTeamMemberOnChangeOfPO=- lead-');
        List<Lead> lstLead = new List<Lead>();
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        set<Id> virtualPartnerIdSet = new set<Id>();
        
        for(Lead objLead : NewList)
        {
        	//Lead oldLead = OldMap.get(objLead.Id);
        	//system.debug('---oldLead--------=--'+oldLead);
            if(objLead.Virtual_Partner__c != null)
            {
                virtualPartnerIdSet.add(objLead.Virtual_Partner__c);
            }
        }
         system.debug('---virtualPartnerIdSet----'+virtualPartnerIdSet);
        if(virtualPartnerIdSet.size() != 0)
        {
            mapIdToAccount = new map<Id, Account>([Select Id, PST_Team_Member__c, RecordTypeId, Business_Unit__c,Related_To__c ,OwnerId
                                                                from Account 
                                                                where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c
                                                                and Id IN: virtualPartnerIdSet]);
            system.debug('----mapIdToAccount---'+mapIdToAccount);
            for (Lead objLead : NewList) 
            {
                system.debug('----objLead in NewList----'+objLead);
                if(mapIdToAccount.containsKey(objLead.Virtual_Partner__c)) 
                {
                	system.debug('----mapIdToAccount--inner-------'+mapIdToAccount);
                	if(OldMap != null && objLead.Virtual_Partner__c != OldMap.get(objLead.Id).Virtual_Partner__c)
                	{
            			objLead.Business_Unit__c = mapIdToAccount.get(objLead.Virtual_Partner__c).Business_Unit__c;
            			system.debug('------------objLead.Business_Unit__c----------------'+objLead.Business_Unit__c);
            			objLead.PST_Team_Member__c = mapIdToAccount.get(objLead.Virtual_Partner__c).PST_Team_Member__c;
                    	system.debug('----objLead.PST_Team_Member__c-----'+objLead.PST_Team_Member__c);
            		}
            		else 
            		{
	            		if(objLead.Business_Unit__c == null)
	                	{
	                		objLead.Business_Unit__c = mapIdToAccount.get(objLead.Virtual_Partner__c).Business_Unit__c;
	                        system.debug('----Business_Unit__c----'+objLead.Business_Unit__c);
	                	}
                		if(objLead.PST_Team_Member__c == null)
		                {
	                        objLead.PST_Team_Member__c = mapIdToAccount.get(objLead.Virtual_Partner__c).PST_Team_Member__c;
	                        system.debug('----map--PST---'+mapIdToAccount.get(objLead.Virtual_Partner__c).PST_Team_Member__c);
	                    }
            		}
                }
                lstLead.add(objLead);
                system.debug('----lstLead-----'+lstLead);
            }
            
        }
    }
    
    
    /* When PST Team Member is changes, its corresponding Entity owner gets changed.
       Sharing rules should be applied accordingly to that particular user.*/
    public static Boolean excutedShare = false;
    public void leadSharing(List<Lead>accountNewList,map<Id,Lead> accountOldMap,map<Id,Lead> accountNewMap,Boolean isInsertAcc)
    {
    	//map<Id,Id> accountTONewOwner = new map<Id,Id>();
        map<String, set<String>> mapIdToSetOfUser = new map<String, set<String>>();
        set<Id> newCreatedAccId = new set<Id>();
        system.debug('----accountNewList--leadSharing---'+accountNewList);
        
        for(Lead acc : accountNewList)
        {
        	if(!isInsertAcc)
    		{
        		if(accountOldMap != null && !accountOldMap.isEmpty()/* && (accountOldMap.get(acc.Id).Virtual_Partner__c != acc.Virtual_Partner__c || 
	        		acc.PST_Team_Member__c != accountOldMap.get(acc.Id).PST_Team_Member__c)*/)
        		{
	        		newCreatedAccId.add(acc.Id);
	        		//accountTONewOwner.put(acc.Id,acc.ownerId);
        		}
    		}
    		else
    		{
    			newCreatedAccId.add(acc.Id);
    		}
        }
        system.debug('----newCreatedAccId--accountSharing---'+newCreatedAccId);
    	if(newCreatedAccId.size() != 0)
    	{
    		map<string, set<string>> mapAccIdToSetUsersExisting = new map<string, set<string>>();
    		
    		List<LeadShare> lstAccountShare = [Select Id, UserOrGroupId, LeadId 
    												from LeadShare 
    												where LeadId IN : newCreatedAccId];
    		system.debug('----lstAccountShare---'+lstAccountShare);										
    		for(LeadShare accInst :  lstAccountShare)
    		{
    			if(!mapAccIdToSetUsersExisting.containskey(accInst.LeadId))
    			{
    				set<String> setUserId = new set<String>();
    				setUserId.add(accInst.UserOrGroupId);
    				mapAccIdToSetUsersExisting.put(accInst.LeadId,setUserId);
    			}
    			else
    			{
    				mapAccIdToSetUsersExisting.get(accInst.LeadId).add(accInst.UserOrGroupId);
    			}
    		}
    		
			List<Lead> lstUserIdAcc = [Select Id, PST_Team_Member__c, PST_Team_Member__r.Team_Member__c,ownerId
                                       from Lead where Id IN: newCreatedAccId];
            
            system.debug('----lstUserIdAcc---'+lstUserIdAcc);                          
			for (Lead acc : lstUserIdAcc) 
            {
            	system.debug('----acc.OwnerId--->'+acc.OwnerId);
            	set<String> setUserId = new set<String>();
            	//if (accountTONewOwner.containsKey(acc.id) && accountTONewOwner.get(acc.id) != acc.PST_Team_Member__r.Team_Member__c) 
            	setUserId.add(acc.PST_Team_Member__r.Team_Member__c);
            	
            	if(!mapIdToSetOfUser.containsKey(acc.Id))
            	{
            		mapIdToSetOfUser.put(acc.Id,setUserId);
            		system.debug('----setUserId----'+setUserId);
            	}
            }    
            system.debug('----mapIdToSetOfUser----'+mapIdToSetOfUser);     
    		Set<Id> setOfCommonUserId = new Set<Id>();
    		
	    	List<LeadShare> shares = new List<LeadShare>();
			for (Id accId : mapIdToSetOfUser.KeySet()) 
			{  
				system.debug('----accId-----'+accId);
	     		LeadShare share = new LeadShare();
	    		
	    		share.LeadId = accId;
	    		share.LeadAccessLevel = 'Edit';
			    //Set the portal user Id to share the accounts with
			    if(mapIdToSetOfUser.containsKey(accId))
			    {
			    	set<String> setOfUserId = mapIdToSetOfUser.get(accId);  
				    for(String userId : setOfUserId)
				    {
				    	if(!mapAccIdToSetUsersExisting.get(accId).contains(userId))
				    	{
				    		LeadShare shareAcc = new LeadShare();
					    	shareAcc = share.clone();
					    	shareAcc.UserOrGroupId = userId;
					    	system.debug('----shareAcc-----'+shareAcc);
					    	if(shareAcc.UserOrGroupId != null)
					    	{
					    		shares.add(shareAcc);	
					    	}
				    	}
				    	else
				    	{
				    		setOfCommonUserId.add(userId);
				    	}
				    	system.debug('--Lead--sharesoooo inside----'+shares);
				    }
			    }
			    system.debug('--Lead--sharesooooooo----'+shares); 
			}
			
			List<LeadShare> lstAccountShareToDelete = [Select Id, UserOrGroupId, LeadId 
    												from LeadShare 
    												where LeadId IN : newCreatedAccId AND rowCause = 'Manual' and UserOrGroupId NOT IN: setOfCommonUserId];
    		if(!lstAccountShareToDelete.isEmpty())
    			delete lstAccountShareToDelete;										
			if(!shares.isEmpty())
				insert shares;
    	}
    	system.debug('----excutedShare---lead-------->'+excutedShare); 
    }
    
	
	/* Post chatter on change of Practice Owner and Biz unit */
	public void chatterPostGeneration(List<Lead>newList,map<Id,Lead> oldMap, map<Id,Lead> newMap)
	{
		set<Id> updatedLeads = new set<Id>();
		set<Id> businessUnitIdSet = new set<Id>();
		List<FeedItem> lstFeedItem = new List<FeedItem>();
		
		for(Lead objLead : newList)
		{
			if(objLead.Business_Unit__c != oldMap.get(objLead.Id).Business_Unit__c)
			{
				businessUnitIdSet.add(objLead.Business_Unit__c);
				businessUnitIdSet.add(oldMap.get(objLead.Id).Business_Unit__c);
				updatedLeads.add(objLead.Id);
			}
		}
		
		Map <Id,Business_Unit__c> mapBusinessUnit = new Map <Id,Business_Unit__c>();	
		if(businessUnitIdSet.size() != 0)
		{
			mapBusinessUnit = new map<Id,Business_Unit__c>([Select Name, Id From Business_Unit__c where Id IN: businessUnitIdSet]);
			
			for(Id objLeadId : updatedLeads)
			{
				system.debug('--------oldMap--------'+oldMap.get(objLeadId));
				system.debug('--------oldMap--1------'+mapBusinessUnit.get(oldMap.get(objLeadId).Business_Unit__c));
				if(oldMap.get(objLeadId).Business_Unit__c != null
					&& mapBusinessUnit.get(oldMap.get(objLeadId).Business_Unit__c) != null
					&& mapBusinessUnit.get(oldMap.get(objLeadId).Business_Unit__c).Name != null 
					&& newMap.get(objLeadId).Business_Unit__c != null
					&& mapBusinessUnit.get(newMap.get(objLeadId).Business_Unit__c) != null
					&& mapBusinessUnit.get(newMap.get(objLeadId).Business_Unit__c).Name != null)
				{	
					system.debug('--------innnnnn--1------');
					String oldBusinessUnitName = mapBusinessUnit.get(oldMap.get(objLeadId).Business_Unit__c).Name;
					system.debug('--------oldBusinessUnitName--1------'+oldBusinessUnitName);
					String newBusinessUnitName = mapBusinessUnit.get(newMap.get(objLeadId).Business_Unit__c).Name;
				
	        		// Post the chatter for members and partners 
	        		FeedItem post = new FeedItem();
	                post.ParentId = objLeadId;
	                post.Body = 'Business Unit has been changed from "' + oldBusinessUnitName +'" To "'+ newBusinessUnitName + '" .';
	                lstFeedItem.add(post);
	        	}
	        	else if(oldMap.get(objLeadId).Business_Unit__c == null
	        		&& newMap.get(objLeadId).Business_Unit__c != null
	        		&& mapBusinessUnit.get(newMap.get(objLeadId).Business_Unit__c) != null
					&& mapBusinessUnit.get(newMap.get(objLeadId).Business_Unit__c).Name != null)
	        	{
	        		String oldBusinessUnitName = ' - ';
					String newBusinessUnitName = mapBusinessUnit.get(newMap.get(objLeadId).Business_Unit__c).Name;
				
	        		// Post the chatter for members and partners 
	        		FeedItem post = new FeedItem();
	                post.ParentId = objLeadId;
	                post.Body = 'Business Unit has been changed from "' + oldBusinessUnitName +'" To "'+ newBusinessUnitName + '" .';
	                lstFeedItem.add(post);
	        	}
			}
			//insert lstFeedItem;
		}
		//-----------------------------------------------------------------------------------------------------------------------------
		set<Id> updatedOwnerLeads = new set<Id>();
		set<Id> partnerIdSet = new set<Id>();
		
		for(Lead objLead : newList)
		{
			if(objLead.Virtual_Partner__c != oldMap.get(objLead.Id).Virtual_Partner__c)
			{
				partnerIdSet.add(objLead.Virtual_Partner__c);
				partnerIdSet.add(oldMap.get(objLead.Id).Virtual_Partner__c);
				updatedOwnerLeads.add(objLead.Id);
			}
		}
		
		Map <Id,Account> mapIdToPartner;		
		if(partnerIdSet.size() != 0)
		{
			mapIdToPartner = new map<Id,Account>([Select Name, Id, Virtual_Partner__c From Account where Id IN: partnerIdSet]);
			for(Id objLeadId : updatedOwnerLeads)
			{
				if(oldMap.get(objLeadId).Virtual_Partner__c != null
					&& mapIdToPartner.get(oldMap.get(objLeadId).Virtual_Partner__c) != null
					&& mapIdToPartner.get(oldMap.get(objLeadId).Virtual_Partner__c).Name != null 
					&& newMap.get(objLeadId).Virtual_Partner__c != null
					&& mapIdToPartner.get(newMap.get(objLeadId).Virtual_Partner__c) != null
					&& mapIdToPartner.get(newMap.get(objLeadId).Virtual_Partner__c).Name != null)
				{
					String oldPartnerName = mapIdToPartner.get(oldMap.get(objLeadId).Virtual_Partner__c).Name;
					String newPartnerName = mapIdToPartner.get(newMap.get(objLeadId).Virtual_Partner__c).Name;
				
	        		// Post the chatter for members and partners 
	        		FeedItem post = new FeedItem();
	                post.ParentId = objLeadId;
	                post.Body = 'Practice Owner(Partner) has been changed from "' + oldPartnerName +'" To "'+ newPartnerName + '" .';
	                lstFeedItem.add(post);
	        	}
	        	else if(oldMap.get(objLeadId).Virtual_Partner__c == null
	        		&& newMap.get(objLeadId).Virtual_Partner__c != null
	        		&& mapIdToPartner.get(newMap.get(objLeadId).Virtual_Partner__c) != null
					&& mapIdToPartner.get(newMap.get(objLeadId).Virtual_Partner__c).Name != null)
	        	{
	        		String oldPartnerName = ' - ';
					String newPartnerName = mapIdToPartner.get(newMap.get(objLeadId).Virtual_Partner__c).Name;
				
	        		// Post the chatter for members and partners 
	        		FeedItem post = new FeedItem();
	                post.ParentId = objLeadId;
	                post.Body = 'Practice Owner(Partner) has been changed from "' + oldPartnerName +'" To "'+ newPartnerName + '" .';
	                lstFeedItem.add(post);
	        	}
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------
		set<Id> updatedPSTLeads = new set<Id>();
		set<Id> teamMemberIdSet = new set<Id>();
		
		for(Lead objLead : newList)
		{
			if(objLead.PST_Team_Member__c != oldMap.get(objLead.Id).PST_Team_Member__c)
			{
				teamMemberIdSet.add(objLead.PST_Team_Member__c);
				teamMemberIdSet.add(oldMap.get(objLead.Id).PST_Team_Member__c);
				updatedPSTLeads.add(objLead.Id);
			}
		}
		system.debug('---------teamMemberIdSet----------'+teamMemberIdSet);
		system.debug('---------updatedPSTLeads----------'+updatedPSTLeads);
		Map <Id,Team_Member__c> mapIdToTM = new Map <Id,Team_Member__c>();		
		if(teamMemberIdSet.size() != 0)
		{
			mapIdToTM = new map<Id,Team_Member__c>([Select Name, Id From Team_Member__c where Id IN: teamMemberIdSet]);
			for(Id objLeadId : updatedPSTLeads)
			{
				if(oldMap.get(objLeadId).PST_Team_Member__c != null
					&& mapIdToTM.get(oldMap.get(objLeadId).PST_Team_Member__c) != null
					&& mapIdToTM.get(oldMap.get(objLeadId).PST_Team_Member__c).Name != null 
					&& newMap.get(objLeadId).Virtual_Partner__c != null
					&& mapIdToTM.get(newMap.get(objLeadId).PST_Team_Member__c) != null
					&& mapIdToTM.get(newMap.get(objLeadId).PST_Team_Member__c).Name != null)
				{
					String oldPartnerName = mapIdToTM.get(oldMap.get(objLeadId).PST_Team_Member__c).Name;
					String newPartnerName = mapIdToTM.get(newMap.get(objLeadId).PST_Team_Member__c).Name;
					system.debug('---------newPartnerName----if------'+newPartnerName);
	        		// Post the chatter for members and partners 
	        		FeedItem post = new FeedItem();
	                post.ParentId = objLeadId;
	                post.Body = 'PST (Practice Success Team) has been changed from "' + oldPartnerName +'" To "'+ newPartnerName + '" .';
	                lstFeedItem.add(post);
	        	}
	        	else if(oldMap.get(objLeadId).PST_Team_Member__c == null
	        		&& newMap.get(objLeadId).PST_Team_Member__c != null
	        		&& mapIdToTM.get(newMap.get(objLeadId).PST_Team_Member__c) != null
					&& mapIdToTM.get(newMap.get(objLeadId).PST_Team_Member__c).Name != null)
	        	{
	        		String oldPartnerName = ' - ';
					String newPartnerName = mapIdToTM.get(newMap.get(objLeadId).PST_Team_Member__c).Name;
					system.debug('---------newPartnerName----------'+newPartnerName);
	        		// Post the chatter for members and partners 
	        		FeedItem post = new FeedItem();
	                post.ParentId = objLeadId;
	                post.Body = 'PST (Practice Success Team) has been changed from "' + oldPartnerName +'" To "'+ newPartnerName + '" .';
	                lstFeedItem.add(post);
	        	}
			}
			system.debug('---------lstFeedItem----aa------'+lstFeedItem);
		}
		
		if(lstFeedItem.size() != 0)
			insert lstFeedItem;
		system.debug('---------lstFeedItem----------'+lstFeedItem.size());
	}
	
		/* When new entity/Member is created, PST, MST & FPA of its selected Practice owners will get assigned to corresponding entity
    public void assignTeamMember(List<Lead>LeadNewList)
    {
        List<Lead> lstAccount = new List<Lead>();
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        
        set<Id> virtualPartnerIdSet = new set<Id>();
        for(Lead objLead : LeadNewList)
        {
            if(objLead.Virtual_Partner__c != null)
            {
                virtualPartnerIdSet.add(objLead.Virtual_Partner__c);
            }
        }
        system.debug('----virtualPartnerIdSet----'+virtualPartnerIdSet);
        
        if(virtualPartnerIdSet.size() != 0)
        {
            mapIdToAccount = new map<Id, Account>([Select Id, PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c,
                                                                OPS_Team_Member__c, RecordTypeId, Business_Unit__c
                                                                from Account 
                                                                where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c
                                                                and Id IN: virtualPartnerIdSet]);
            system.debug('----mapIdToAccount----'+mapIdToAccount);
            for (Lead objLead : LeadNewList) 
            {
                system.debug('----in LeadNewList----'+objLead);
                system.debug('----mapIdToAccount--VP--'+mapIdToAccount.containsKey(objLead.Virtual_Partner__c));
	            if(mapIdToAccount.containsKey(objLead.Virtual_Partner__c))
                {    
                	system.debug('----mapIdToAccount--BU--'+mapIdToAccount.get(objLead.Virtual_Partner__c).Business_Unit__c);
	                if(objLead.Business_Unit__c == null)
	                {
                        objLead.Business_Unit__c = mapIdToAccount.get(objLead.Virtual_Partner__c).Business_Unit__c;
                        system.debug('----Business_Unit__c----'+objLead.Business_Unit__c);
                    }
	                if(objLead.PST_Team_Member__c == null)
	                {
                        objLead.PST_Team_Member__c = mapIdToAccount.get(objLead.Virtual_Partner__c).PST_Team_Member__c;
                        system.debug('----map--PST---'+mapIdToAccount.get(objLead.Virtual_Partner__c).PST_Team_Member__c);
                    }
                }
                lstAccount.add(objLead);
                system.debug('----lstAccount-----'+lstAccount);
            }
        }
    }*/
}