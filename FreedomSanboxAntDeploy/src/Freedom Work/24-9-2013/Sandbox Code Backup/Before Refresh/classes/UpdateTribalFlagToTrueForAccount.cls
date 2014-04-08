global class UpdateTribalFlagToTrueForAccount implements Database.Batchable<sObject>{
	global String query;
	public String email;
	
	global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<sObject> scope){
     	List<Account> updateAccounts = new List<Account>();
     	for(sObject s: scope){
     		Account acc = (Account)s;
     		if(!acc.Tribal_Activity_Flag__c){
     			acc.Tribal_Activity_Flag__c=True;
     			updateAccounts.add(acc); 
     		}
     	}
     	update updateAccounts;
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
        mail.setSubject(' Update Tribal Activity Flag For Account To True ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
    }
}