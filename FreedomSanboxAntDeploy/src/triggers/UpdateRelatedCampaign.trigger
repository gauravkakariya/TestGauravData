trigger UpdateRelatedCampaign on Account (after update) 
{
	system.debug('-----UpdateRelatedCampaign------b4---'+StaticMethodClass.isAccountUpsertFired);
	//if(StaticMethodClass.isAccountUpsertFired)
	{
		system.debug('-----UpdateRelatedCampaign------after---'+StaticMethodClass.isAccountUpsertFired);
	  Map<Id,Double> bookedRevenueMap = new Map<Id,Double>();
	  Map<Id, Id[]> campaignContactMap = new Map<Id, Id[]>();
	  Map<Id, Id> accountExt = new Map<Id, Id>();
	  Map<Id, Double> entityIds = new Map<Id, Double>();
	  List<Campaign> updateCampaign = new List<Campaign>();
	  List<Id> campaignMembers = new List<Id>();
	  List<Id> contactIds = new List<Id>();
	  Map<Id, String> campaignTypeMap = new Map<Id, String>();
	  for(Account act: Trigger.new) {
	
	    entityIds.put(act.Id, act.ARPP_Generated__c);
	  }
	  for(Contact cn:[select Id, AccountId from Contact where 
	            AccountId IN :entityIds.keySet()and IsPersonAccount = true]) {
	              
	    System.debug('booked Revenue'+entityIds.get(cn.AccountId));
	    bookedRevenueMap.put(cn.Id, entityIds.get(cn.AccountId));
	  }
	  
	  for(Campaign cmp: [select Id, Type from Campaign where Type = 'Seminar / Conference']){
	      campaignTypeMap.put(cmp.Id, cmp.Type);
	  }
  
	  for(CampaignMember cmp: [select CampaignId, ContactId from CampaignMember where 
	                ContactId IN :bookedRevenueMap.keySet() and CampaignId NOT IN :campaignTypeMap.keySet()]) {
	      if(!campaignContactMap.isEmpty() && campaignContactMap.containsKey(cmp.CampaignId)){
	        List<Id> existingList = campaignContactMap.get(cmp.CampaignId);
	        existingList.add(cmp.ContactId);
	        campaignContactMap.put(cmp.CampaignId, existingList);
	      }
	      else {
	        List<Id> newContacts = new List<Id>();
	        newContacts.add(cmp.ContactId);
	        campaignContactMap.put(cmp.CampaignId, newContacts);
	      }
	      campaignMembers.add(cmp.Id);        
	  }
	  boolean isContactCreated = false;
	  for(CampaignMember cmp: [select CampaignId, ContactId from CampaignMember where 
	                CampaignId IN :campaignContactMap.keySet() and Id NOT IN :campaignMembers]) {
	      if(!campaignContactMap.isEmpty() && campaignContactMap.containsKey(cmp.CampaignId)){
	        List<Id> existingList = campaignContactMap.get(cmp.CampaignId);
	        existingList.add(cmp.ContactId);
	        campaignContactMap.put(cmp.CampaignId, existingList);
	      }
	      else {
	        List<Id> newContacts = new List<Id>();
	        newContacts.add(cmp.ContactId);
	        campaignContactMap.put(cmp.CampaignId, newContacts);
	      } 
	      contactIds.add(cmp.ContactId);       
	      isContactCreated = true;
	  }
	   List<Contact> lstCon = new List<Contact>();
	  if(isContactCreated)
	  lstCon = [select Id, Account.ARPP_Generated__c from Contact where Id IN :contactIds];
	  if(lstCon.size() > 0 )
	  {
	  	for(Contact c: lstCon){
	    	    bookedRevenueMap.put(c.Id, c.Account.ARPP_Generated__c);
	  	}
	  }
	  for(Campaign camp: [select Id, Revenue_Generated__c from Campaign 
	            where Id IN :campaignContactMap.keySet()]) {
	    Double d = 0;
	    for(Id con: campaignContactMap.get(camp.Id)) {
	      if(bookedRevenueMap.get(con)!= null){
	        d += bookedRevenueMap.get(con);
	      }
	    }
	    camp.Revenue_Generated__c = d;
	    updateCampaign.add(camp);
	  }
	  
	  update updateCampaign;
	}
}