global class CreateSummaryReport implements Database.Batchable<sObject>, Database.Stateful {
    global String query; 
    global Map<String, Portfolio_Report__c>  existingPortMap = new Map<String, Portfolio_Report__c>();
    global Map<String, Double> purchaseAmountMap = new Map<String, Double>();
    global Map<String, Double> productMap = new Map<String, Double>();
    global Map<String, Double> unitsMap = new Map<String, Double>();
    global Map<String, Purchase_Sales_Report__c> otherDetailsMap = new Map<String, Purchase_Sales_Report__c>();
    global String email;
    
    global CreateSummaryReport(){
        /*for(Portfolio_Report__c por: [Select Gain__c, 
                                            Units_Quanitity__c,
                                            Scheme_Scrip_Name__c, 
                                            Purchase_Amount__c, 
                                            Portfolio_Type__c, 
                                            Folio_Number__c, 
                                            Current_Value__c,
                                            Absolute_Ret__c,
                                            Annualized_Ret__c, 
                                            UniqueName__c,
                                            Dividend_Reivestment__c,
                                            Transaction_Type__c,
                                            Nav_p__c
                                            From Portfolio_Report__c] ){
           existingPortMap.put(por.UniqueName__c, por);
            
        }*/
        //email = email;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
       
     /*   for(sObject s: scope){
            Purchase_Sales_Report__c ps = (Purchase_Sales_Report__c)s;
            if(purchaseAmountMap.containsKey(ps.Unique_Name__c)){
            	if(ps.Amount__c != null){
	        		Double d = ps.Amount__c + purchaseAmountMap.get(ps.Unique_Name__c);
	                purchaseAmountMap.put(ps.Unique_Name__c, d);
            	}
            	                
            }
            else {
                   if(ps.Amount__c == null)
                   {
                   		ps.Amount__c = 0;
                   }
                purchaseAmountMap.put(ps.Unique_Name__c, ps.Amount__c);
            }
            if(productMap.containsKey(ps.Unique_Name__c)){
            	if(ps.Product__c != null) {
	                Double d = ps.Product__c + productMap.get(ps.Unique_Name__c);
	                productMap.put(ps.Unique_Name__c, d);
            	}
                
            }
            else {
                  if(ps.Product__c == null)
                  {
                  	ps.Product__c = 0;
                  }
                productMap.put(ps.Unique_Name__c, ps.Product__c);
            }
            if(unitsMap.containsKey(ps.Unique_Name__c)){
            	if(ps.Units__c != null){
	                Double d = ps.Units__c + unitsMap.get(ps.Unique_Name__c);
	                unitsMap.put(ps.Unique_Name__c, d);
	                System.debug('Units'+d);
            	}
                
            }
            else {
                  if(ps.Units__c == null)
                  {
                  	ps.Units__c = 0;
                  }
                unitsMap.put(ps.Unique_Name__c, ps.Units__c);
            }
            if(!otherDetailsMap.containsKey(ps.Unique_Name__c)){
                otherDetailsMap.put(ps.Unique_Name__c, ps);
            }
        }
        for(Portfolio_Report__c por: [Select Gain__c, 
                                            Units_Quanitity__c,
                                            Scheme_Scrip_Name__c, 
                                            Purchase_Amount__c, 
                                            Portfolio_Type__c, 
                                            Folio_Number__c, 
                                            Current_Value__c,
                                            Absolute_Ret__c,
                                            Annualized_Ret__c, 
                                            UniqueName__c,
                                            Dividend_Reivestment__c,
                                            Transaction_Type__c,
                                            Nav_p__c,
                                            Asset_Class__c
                                            From Portfolio_Report__c 
                                            where UniqueName__c IN :otherDetailsMap.keySet()
                                            and UniqueName__c NOT IN :existingPortMap.keySet()] ){
            existingPortMap.put(por.UniqueName__c, por);
         }*/
        
    }
    global void finish(Database.BatchableContext BC){
      /*  List<Portfolio_Report__c> updateList = new List<Portfolio_Report__c>();
        List<Portfolio_Report__c> newList = new List<Portfolio_Report__c>();
        
        for(String s: purchaseAmountMap.keySet()){
            if(existingPortMap.containsKey(s)){
                Portfolio_Report__c pr = existingPortMap.get(s);
                pr.Purchase_Amount__c = purchaseAmountMap.get(s);
                pr.Product__c = productMap.get(s);
                pr.Units_Quanitity__c = unitsMap.get(s);
                pr.Transaction_Type__c = otherDetailsMap.get(s).Type__c;
                System.debug('port'+pr);
                updateList.add(pr);
            }
            else if(unitsMap.get(s) != null && unitsMap.get(s) != 0){
	                Portfolio_Report__c pr = new Portfolio_Report__c(UniqueName__c=s, 
	                                                                 Scheme_Scrip_Name__c=otherDetailsMap.get(s).Scheme_Name__c,
	                                                                 Folio_Number__c = otherDetailsMap.get(s).Folio_Number__c,
	                                                                 Entity__c = otherDetailsMap.get(s).Entity__c,
	                                                                 Product__c = productMap.get(s),
	                                                                 Transaction_Type__c = otherDetailsMap.get(s).Type__c,
	                                                                 Units_Quanitity__c = unitsMap.get(s),
	                                                                 Asset_Class__c = otherDetailsMap.get(s).Asset_Class__c,
	                                                                 Purchase_Amount__c = purchaseAmountMap.get(s));
	                System.debug('port'+pr);
	                newList.add(pr);
            }
        }
        
        insert newList;
        update updateList;
        
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
        mail.setSubject('Create Summary Report Update ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
    }
}