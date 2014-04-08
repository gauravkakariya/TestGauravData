trigger UpdateCampaign on CampaignMember (after insert, before delete) {

	Map<Id,Id> campaignContact = new Map<Id, Id>();
	Map<Id,Id> campaignMem = new Map<Id, Id>();
	Map<Id,Double> bookedRevenueMap = new Map<Id,Double>(); 
	Map<Id,Campaign> updateCampaigns = new Map<Id,Campaign>();
	Map<Id, Campaign> campaignDetails = new Map<Id, Campaign>();
	if(Trigger.isInsert){
		for(CampaignMember cmp: Trigger.new){
		    campaignContact.put(cmp.Id, cmp.ContactId);
		    campaignMem.put(cmp.Id, cmp.CampaignId);
		    
		}
	}
	else{
		for(Integer i=0; i<Trigger.size; i++){
			campaignContact.put(Trigger.old[i].Id, Trigger.old[i].ContactId);
			 campaignMem.put(Trigger.old[i].Id, Trigger.old[i].CampaignId);
		}
	}	
	for(Contact c: [select Id, Account.ARPP_Generated__c from Contact where Id IN :campaignContact.values()]){         
	    bookedRevenueMap.put(c.Id, c.Account.ARPP_Generated__c);   
	} 
	
	for(Campaign cmp: [select Id, Revenue_Generated__c from Campaign where Id IN :campaignMem.values()]){
		campaignDetails.put(cmp.Id, cmp);
	}
	
	if(Trigger.isInsert){
		for(CampaignMember cmp: Trigger.new){
		    if(bookedRevenueMap.get(cmp.ContactId) != null){
			   Campaign camp;
		    	if(!updateCampaigns.containsKey(campaignMem.get(cmp.Id)) ){
			        camp = campaignDetails.get(campaignMem.get(cmp.Id)); 
		    	}
		    	else
		    	{
		    		camp = updateCampaigns.get(campaignMem.get(cmp.Id)); 
		    	}
			    if(camp.Revenue_Generated__c != null){
		            camp.Revenue_Generated__c = camp.Revenue_Generated__c+bookedRevenueMap.get(cmp.ContactId);
		        }
		        else {
		            camp.Revenue_Generated__c = bookedRevenueMap.get(cmp.ContactId);
		
		        }
		        updateCampaigns.put(camp.Id, camp);
		    }
		}
	}
	else {
		 for(Integer i=0; i<Trigger.size; i++){
			if(bookedRevenueMap.get(Trigger.old[i].ContactId) != null){
				Campaign camp;
			    if(!updateCampaigns.containsKey(campaignMem.get(Trigger.old[i].Id)) ){
			        camp = campaignDetails.get(campaignMem.get(Trigger.old[i].Id)); 
		    	}
		    	else
		    	{
		    		camp = updateCampaigns.get(campaignMem.get(Trigger.old[i].Id)); 
		    	}	 
			   if(camp.Revenue_Generated__c != null){
			   	    System.debug('Camp Generated'+bookedRevenueMap.get(Trigger.old[i].ContactId));
		            camp.Revenue_Generated__c = camp.Revenue_Generated__c - bookedRevenueMap.get(Trigger.old[i].ContactId);
		        }
	            updateCampaigns.put(camp.Id, camp);
			}
		}
	}

	update updateCampaigns.values();
}