global class CalculateReturnsforDetailReport implements Database.Batchable<sObject> {
    public String query;
    Map<String, Double>  navMap = new Map<String, Double>();
    Date curDate;
    public String email;
        
    global CalculateReturnsforDetailReport(){
        for(Nav_Lookup__c nav: [select Scheme_Name__c, NAV__c, As_Of_Date__c from Nav_Lookup__c]){
            navMap.put(nav.Scheme_Name__c, nav.NAV__c);
            curDate = nav.As_Of_Date__c;
        }
        //email = email;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Purchase_Sales_Report__c> updatePS = new List<Purchase_Sales_Report__c>();
        
       /* for(sObject s: scope){
            Purchase_Sales_Report__c ps = (Purchase_Sales_Report__c)s;
            if(navMap.containsKey(ps.Scheme_Name__c) && navMap.get(ps.Scheme_Name__c) != null && ps.Units__c != null){       	
	            	System.debug('ps.Units__c'+ps.Units__c+'ps.Id'+ps.Id);
		            ps.Current_Value__c = navMap.get(ps.Scheme_Name__c)* ps.Units__c;
		            System.debug('Current Value'+ps.Current_Value__c+'ps.Id'+ps.Id);
		            ps.Current_Date__c = curDate;
		            ps.NAV__c = navMap.get(ps.Scheme_Name__c);
		            ps.Net_Gain__c = ps.Current_Value__c - ps.Amount__c;
		            System.debug('ps.Net_Gain__c'+ps.Net_Gain__c);
		           
		            ps.Days__c = ps.NAV_Date__c.daysBetween(curDate);
		            
		            if(ps.Transaction__c == 'Sales'){
		                ps.Product__c = 0;
		            }
		            else if(ps.Days__c != 0){
		                ps.Product__c = ps.Days__c * ps.Amount__c;
		                Double avgDays = ps.Product__c/ps.Amount__c;
			            ps.Absolute_Return__c = ps.Net_Gain__c/ps.Amount__c*100;
			            Double d = (1+ps.Absolute_Return__c/100);
			            
			            //Decimal dm = Decimal.valueOf((Math.pow(d,(365/avgDays))-1)*100).setScale(2);
			            //System.debug('Decimal value'+dm);
			            Double dm = (Math.pow(d,(365/avgDays))-1)*100;
			            System.debug('value'+dm.format());
			            
			            String validateDouble = dm.format();
			            if(validateDouble.indexOf('.') != -1 && validateDouble.indexOf('.') < 15){
			            	ps.Annualized_Return__c = dm;
			            }
			            
		            }
            	
	            updatePS.add(ps);
            }
        }
        update updatePS;*/
        
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
        mail.setSubject('Detailed Portfolio Report Update ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}