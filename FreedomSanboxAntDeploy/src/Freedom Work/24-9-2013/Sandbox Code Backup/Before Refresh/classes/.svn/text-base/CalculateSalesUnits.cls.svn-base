global class CalculateSalesUnits implements Database.Batchable<sObject>, Database.Stateful {
	
	global String query;
	public String email;  
	Map<String, Double> salesUnits = new Map<String, Double>();
	Map<String, Id> entityMap = new Map<String, Id>();
	
	global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	
    	for(sObject s: scope){
    	 	Purchase_Sales_Report__c ps = (Purchase_Sales_Report__c)s;
    	 	if(ps.Units__c != null){
    	 		if(!salesUnits.isEmpty() && salesUnits.containsKey(ps.Unique_Name__c)){
	    	 		Double d = salesUnits.get(ps.Unique_Name__c) + ps.Units__c;
	    	 		salesUnits.put(ps.Unique_Name__c,d);
	    	 		
	    	 	}
	    	 	else{
	    	 		salesUnits.put(ps.Unique_Name__c,ps.Units__c);
	    	 		entityMap.put(ps.Unique_Name__c, ps.Entity__c);
	    	 	}
    	 	}
    	}
    	
    }
    
    global void finish(Database.BatchableContext BC){
    	List<Temp_Purchase_Report__c> portfolioList = new List<Temp_Purchase_Report__c>();
    	
    	for(String s: salesUnits.keySet()){
    		Temp_Purchase_Report__c  pr = new Temp_Purchase_Report__c(UniqueName__c = s, Sales_Units__c = salesUnits.get(s), Entity__c = entityMap.get(s));
    		portfolioList.add(pr);
    	}
    	upsert portfolioList UniqueName__c;
    	AsyncApexJob a = [Select Id, 
                                 Status,
                                 NumberOfErrors, 
                                 JobItemsProcessed,  
                                 TotalJobItems, 
                                 CreatedBy.Email 
                                 from AsyncApexJob 
                                 where Id =:BC.getJobId()];
        // Create and send an email with the results of the batch.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('tech@ffreedom.in');
        mail.setSenderDisplayName('Batch Processing');  
        mail.setSubject('Calculate Sales Units ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}