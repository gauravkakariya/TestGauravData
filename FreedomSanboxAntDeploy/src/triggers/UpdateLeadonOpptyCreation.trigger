trigger UpdateLeadonOpptyCreation on Opportunity (after insert) {
	List<Id> updateLeadIds = new List<Id>();
	List<Lead> updateLeads = new List<Lead>();
	for(Opportunity opp:Trigger.new){
		updateLeadIds.add(opp.Lead__c);
	}
	
	for(Lead l: [select Id, Status from Lead where Id IN :updateLeadIds and IsConverted != true]){
		l.Status = 'Opportunity Received';
		updateLeads.add(l);
	}
	
	update updateLeads;
}