global class CalculateReturnsforSummaryReport implements Database.Batchable<sObject>, Database.Stateful {
    global String query; 
    global Map<String, Double>  navMap = new Map<String, Double>();
    global Date curDate;
    public String email;
        
    global CalculateReturnsforSummaryReport(){
        for(Nav_Lookup__c nav: [select Scheme_Name__c, NAV__c, As_Of_Date__c from Nav_Lookup__c]){
            navMap.put(nav.Scheme_Name__c, nav.NAV__c);
            System.debug('Scheme Name'+nav.Scheme_Name__c);
            curDate = nav.As_Of_Date__c;
        }
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Portfolio_Report__c> updatePS = new List<Portfolio_Report__c>();
        for(sObject s: scope){
        	        
	            Portfolio_Report__c ps = (Portfolio_Report__c)s;
	            if(navMap.containsKey(ps.Scheme_Scrip_Name__c) && navMap.get(ps.Scheme_Scrip_Name__c) != null && ps.Units_Quanitity__c != null){
	            	System.debug('Id'+ ps.Id);
	            	ps.Current_Value__c = navMap.get(ps.Scheme_Scrip_Name__c)* ps.Units_Quanitity__c;
	                ps.Nav_p__c = navMap.get(ps.Scheme_Scrip_Name__c);
		            ps.Date__c = curDate; 
		            ps.Gain__c = ps.Current_Value__c - ps.Purchase_Amount__c;
		            System.debug('Gain='+ ps.Gain__c );
		            //Double avgDays = ps.Product__c/ps.Purchase_Amount__c;
		            System.debug('Purchase Amount='+ ps.Purchase_Amount__c);
		           // System.debug('avgDay='+ avgDays);
		            ps.Absolute_Ret__c = ps.Gain__c/ps.Purchase_Amount__c*100;
		            //Double d = (1+ps.Absolute_Ret__c/100);
		           // System.debug('d='+ d);
		            //ps.Annualized_Ret__c = (Math.pow(d,(365/avgDays))-1)*100;
		           // System.debug('Returns='+ ps.Annualized_Ret__c );
		            updatePS.add(ps);
	            }
	            else {
	            	System.debug('There is some error '+ps.Id+ 'Units'+ps.Units_Quanitity__c + 'Scheme Name'+ps.Scheme_Scrip_Name__c);
	            	
	            }
	            
           
            
        }
        update updatePS;
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
        mail.setSubject('Return Calculation for Portfolio Summary Report ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}