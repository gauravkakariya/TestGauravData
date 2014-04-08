global class UpdateTribalFlagToFalseForLead implements Database.Batchable<sObject>{
	global String query;
	public String email;
	
	global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
    }
    
     
    global void execute(Database.BatchableContext BC, List<sObject> scope){
     	List<Lead> updateLeads = new List<Lead>();
     	for(sObject s: scope){
     		Lead lead = (Lead)s;
     		if(lead.Tribal_Activity_Flag__c ){
     			lead.Tribal_Activity_Flag__c=False;
     			updateLeads.add(lead); 
     		}
     	}
     	update updateLeads;
    }
     
    global void finish(Database.BatchableContext BC){
      	AsyncApexJob a = [Select Id, 
                                 Status,
                                 NumberOfErrors, 
                                 JobItemsProcessed,  
                                 TotalJobItems, 
                                 CreatedBy.Email 
                                 from AsyncApexJob 
                                 where Id =:BC.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('tech@ffreedom.in');
        mail.setSenderDisplayName('Batch Processing');  
        mail.setSubject(' Update Tribal Activity Flag For Lead To False ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
    }
}