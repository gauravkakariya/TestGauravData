global class CalculateSipNextDueDates implements Database.Batchable<sObject>{
	global String query;
	public String email;  

	global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	 List<SIP_Tracker__c > updateSip = new List<SIP_Tracker__c >();
    	 for(sObject s: scope){
            SIP_Tracker__c  sip = (SIP_Tracker__c )s;
            
            if(sip.Frequency__c !=null && sip.Due_Date__c!=null){
	            if(sip.Frequency__c==Label.Daily && System.today()>=sip.Due_Date__c ){
	            	sip.Due_Date__c = System.today().addDays(1);
	            	updateSip.add(sip);
	            }
	            else if(sip.Frequency__c==Label.Monthly && System.today() >= sip.Due_Date__c ){
	            	Integer sipDay = sip.Due_Date__c.day();
	            	
	            	Integer currentMonth = System.today().month();
	            	Integer currentYear = System.today().year();
	            	Date newDueDate = Date.newInstance(currentYear,currentMonth,sipDay);
	            	if(System.today()>=newDueDate){
	            		sip.Due_Date__c = newDueDate.addMonths(1);
	            	}
	            	else{
	            		sip.Due_Date__c = newDueDate;
	            	}
	            	
	            	updateSip.add(sip);
	            }
	            else if(sip.Frequency__c==Label.Weekly && System.today() >= sip.Due_Date__c ){
	            	sip.Due_Date__c = sip.Due_Date__c.addDays(7);
	            	updateSip.add(sip); 
	            }
	            else if(sip.Frequency__c==Label.Quarterly && System.today() >= sip.Due_Date__c ){
	            	sip.Due_Date__c = sip.Due_Date__c.addMonths(3);
	            	updateSip.add(sip);
	            }
            }
    	 }	
    	 update updateSip;
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
        // Create and send an email with the results of the batch.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('tech@ffreedom.in');
        mail.setSenderDisplayName('Batch Processing');  
        mail.setSubject('Calculate next due date for SIP  ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
    }
}