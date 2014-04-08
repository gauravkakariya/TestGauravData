global class CalculateInsuranceNextDueDates implements Database.Batchable<sObject> {
	global String query;
	public String email;

	global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	 List<Insurance__c> updateInsurance = new List<Insurance__c>();
    	 for(sObject s: scope){
            Insurance__c insurance = (Insurance__c)s;
            
            if(insurance.Premium_Frequency__c != null && insurance.Premium_Due_date__c != null){
	            if(insurance.Premium_Frequency__c == Label.Annually && System.today() >= insurance.Premium_Due_date__c){
	            	Integer insuranceDay = insurance.Premium_Due_date__c.day();
	            	Integer insuranceMonth = insurance.Premium_Due_date__c.month();
	            	Integer currentYear = System.today().year();
	            	Date newDueDate = date.newInstance(currentYear, insuranceMonth, insuranceDay);
	            
	            	if(System.today()>= newDueDate){
	            		insurance.Premium_Due_date__c = insurance.Premium_Due_date__c.addYears(1);
	            	}
	            	else{
	            		insurance.Premium_Due_date__c = newDueDate;
	            	}
	            	
	            	updateInsurance.add(insurance);
	            }
            }            
    	 }	
    	 update updateInsurance;
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
        mail.setSubject('Calculate next due date for Insurances  ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
    }

	
}