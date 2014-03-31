trigger UpdateLeadOpptoAccount on Lead (after update) {
	Map<Lead, Id> leadAccountMap = new Map<Lead, Id>();
	List<Opportunity> oppList = new List<Opportunity>();
	List<Id> delOppList = new List<Id>();
	for(Integer i=0; i< Trigger.size; i++){
		if(Trigger.new[i].IsConverted && Trigger.new[i].IsConverted != Trigger.old[i].IsConverted){
			leadAccountMap.put(Trigger.new[i], Trigger.new[i].ConvertedAccountId);
			if(Trigger.new[i].ConvertedOpportunityId != null){
				delOppList.add(Trigger.new[i].ConvertedOpportunityId);
			}
		}
	}
	
	/*for(Opportunity opp: [select Id, 
								 AccountId, 
								 Lead__c,
								 StageName,
								 Probability
								 from Opportunity
								 where Lead__c IN :leadAccountMap.keySet()]){
		opp.AccountId = leadAccountMap.get(opp.Lead__c);
		opp.StageName = 'Converted';
		opp.Probability= 100;
		oppList.add(opp);
								 	
	 } 
	 */
	 /* Created new Custom Button for Lead Conversion (Comment Following 2 lines) 
	 			        Eternus Solutions
                        Author  : Pravin Patil
                        Issue Id: FS0127
                        Date    : 24/08/2011
                        Purpose : Lead Conversion Error */
	 
	// delete [select Id from Opportunity where ID IN :delOppList];
	 
	// update oppList;

}