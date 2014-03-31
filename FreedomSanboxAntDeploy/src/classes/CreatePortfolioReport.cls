global class CreatePortfolioReport implements Database.Batchable<sObject>, Database.Stateful{
	public String query;
	global String email;
	Map<String, Purchase_Sales_Report__c[]> finalPurchaseMap = new Map<String, Purchase_Sales_Report__c[]>();
	Map<String, Double> purchaseUnits = new Map<String, Double>();
	
	global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	 Map<String, Double> salesUnitsMap = new Map<String, Double>();
    	 Map<String, Purchase_Sales_Report__c[]> purchaseMap = new Map<String, Purchase_Sales_Report__c[]>();
    	 for(sObject s: scope){
    	 	Purchase_Sales_Report__c ps = (Purchase_Sales_Report__c)s;
    	 	
		 	if(!purchaseMap.isEmpty() && purchaseMap.containsKey(ps.Unique_Name__c)){
		 		purchaseMap.get(ps.Unique_Name__c).add(ps);
		 	}
		 	else{
		 		List<Purchase_Sales_Report__c> newList = new List<Purchase_Sales_Report__c>();
		 		newList.add(ps);
		 		purchaseMap.put(ps.Unique_Name__c, newList);
		 	}
	    	 
    	 	
    	 } 
    	 //Get all Sales Units from Portfolio Report
    	 for(Temp_Purchase_Report__c pr:[select UniqueName__c, Sales_Units__c from Temp_Purchase_Report__c where UniqueName__c IN :purchaseMap.keySet()]){
    	 	salesUnitsMap.put(pr.UniqueName__c, pr.Sales_Units__c);
    	 	
    	 }
    	 for(String s: purchaseMap.keySet()){
    	 	Double salesUnits = 0;
    	 	if(salesUnitsMap.containsKey(s) && salesUnitsMap.get(s) != null){
    	 	 	salesUnits = Math.abs(salesUnitsMap.get(s));
    	 	}
    	 	if(salesUnits != 0){
	    	 	for(Purchase_Sales_Report__c ps:purchaseMap.get(s)){
	    	 		//If sales units is i.e. no sales history, add it to the final purchase list
    	 			// If there exist no purchase Units for the unique name, add the units to the purchase Map
    	 			if(purchaseUnits.isEmpty() || !purchaseUnits.containsKey(s)){
    	 				if(ps.Units__c != null){
	    	 				purchaseUnits.put(s,ps.Units__c);
	    	 			}
    	 			}
    	 			//Check if purchaseUnits exist for the UniqueName, if not add the UniqueName 
    	 			//and purchase Units to the purchaseUnits Map
	    	 		if(purchaseUnits.containsKey(s)){ 
	    	 			//if purchase units exist and equals the Sales Units, this means they are new purchases and needs to 
	    	 			//added to the final map
	    	 			if(purchaseUnits.get(s) > salesUnits || purchaseUnits.get(s) == -1){
	    	 				if(purchaseUnits.get(s) > salesUnits){
	    	 					ps.Units__c = purchaseUnits.get(s)-salesUnits;
	    	 					ps.Product__c = ps.Days__c * ps.Units__c;
	    	 					purchaseUnits.put(s,-1);
	    	 				}
	    	 				
	    	 				if(!finalPurchaseMap.isEmpty() && finalPurchaseMap.containsKey(ps.Unique_Name__c)){
			    	 			finalPurchaseMap.get(ps.Unique_Name__c).add(ps);
				    	 	}
				    	 	else{
				    	 		List<Purchase_Sales_Report__c> newList = new List<Purchase_Sales_Report__c>();
				    	 		newList.add(ps);
				    	 		finalPurchaseMap.put(ps.Unique_Name__c, newList);
				    	 	}
	    	 			}
	    	 			// If purchase units are less, add the units to the purchase units map
	    	 			else if(purchaseUnits.get(s) < salesUnits){
	    	 				if(ps.Units__c != null){
	    	 					purchaseUnits.put(s,(purchaseUnits.get(s)+ps.Units__c));
	    	 				}
	    	 			}
	    	 			else if(purchaseUnits.get(s) == salesUnits){
	    	 				purchaseUnits.put(s,-1);
	    	 			}
	    	 		}
	    	 	}
	    	 }	
	    	 else{
	    	 	System.debug('UniqueName'+s);
	    	 	if(!finalPurchaseMap.isEmpty() && finalPurchaseMap.containsKey(s)){
    	 			finalPurchaseMap.get(s).addAll(purchaseMap.get(s));
	    	 	}
	    	 	else{
	    	 		List<Purchase_Sales_Report__c> newList = new List<Purchase_Sales_Report__c>();
	    	 		newList.addAll(purchaseMap.get(s));
	    	 		finalPurchaseMap.put(s, newList);
	    	 	}
	    	 }
	    	 
    	 }
    	 System.debug('Purchase Map size'+purchaseMap.size());
    	 
    }
    
    global void finish(Database.BatchableContext BC){
    	Map<String, Double> salesUnits = new Map<String, Double>();
    	Map<String, Double> purchaseUnits = new Map<String, Double>();
    	Map<String, Portfolio_Report__c> portfolioMap = new Map<String, Portfolio_Report__c>();
    	List<Temp_Purchase_Report__c> purchaseList = new List<Temp_Purchase_Report__c>();
    	/*for(String uniqueName: salesMap.keySet()){
  			Double units = 0;
  			Double purchaseAmount = 0;
  			for(Purchase_Sales_Report__c ps:salesMap.get(uniqueName)){
  				
  				if(ps.Units__c != null){
  					units += ps.Units__c;
  				}
  			}
  			salesUnits.put(uniqueName, units);
  		}
  		System.debug('Sales Map'+salesMap.size());
  		for(String uniqueName: purchaseMap.keySet()){
  			
  	        Double units;
  			if(salesUnits.containsKey(uniqueName)){
  				units = Math.abs(salesUnits.get(uniqueName));
  			}
  			Double pUnits = 0;
  			Double product = 0;
  			Double portUnits = 0;
  			Double portAmount = 0;
  			Double divReinvAmount = 0;
  			Double divAmount = 0;
  			Double stpAmount = 0;
  			Boolean entityFlag = true;
  			Id entity;
  			String folio;
  			String assetClass;
  			String schemeName;
  			for(Purchase_Sales_Report__c ps:purchaseMap.get(uniqueName)){
  				
  				if(units != null && pUnits != units){
  					if(ps.Units__c != null){
  						pUnits += ps.Units__c;
  					}
  					
  				}
  				else{
  					
  					if(ps.Units__c != null){
  						portUnits += ps.Units__c;
  					}
  					if(ps.Amount__c != null && ps.Type__c != null){
  						
  						if(ps.Type__c.equalsIgnoreCase('NOR') || ps.Type__c.equalsIgnoreCase('SIP')){
  							portAmount += ps.Amount__c;
  						}
  						else if(ps.Type__c.equalsIgnoreCase('DIR')){
  							divReinvAmount += ps.Amount__c;
  						}
  						else if(ps.Type__c.equalsIgnoreCase('STI') || ps.Type__c.equalsIgnoreCase('SWI')){
  							stpAmount += ps.Amount__c;
  						}
  						else if(ps.Type__c.equalsIgnoreCase('DVP')){
  							divAmount += ps.Amount__c;
  						}
  					}
  					if(ps.Product__c != null){
  						product += ps.Product__c;
  					}
  					if(entityFlag){
	  					entity = ps.Entity__c;
	  					folio = ps.Folio_Number__c;
	  					assetClass = ps.Asset_Class__c;
	  					entityFlag = false;
	  					schemeName = ps.Scheme_Name__c;
  					}
  					System.debug('Create Port Units'+portUnits+'Amount'+portAmount+'Product'+product);
  				}
  				
  			}*/
  			for(String uniqueName: finalPurchaseMap.keySet()){
	  			Double pUnits = 0;
	  			Double product = 0;
	  			Double portUnits = 0;
	  			Double portAmount = 0;
	  			Double divReinvAmount = 0;
	  			Double divAmount = 0;
	  			Double stpAmount = 0;
	  			Boolean entityFlag = true;
	  			Id entity;
	  			String folio;
	  			String assetClass;
	  			String schemeName;
	  			for(Purchase_Sales_Report__c ps:finalPurchaseMap.get(uniqueName)){
  				
  					if(ps.Units__c != null){
  						portUnits += ps.Units__c;
  					}
  					if(ps.Amount__c != null && ps.Type__c != null){
  						
  						if(ps.Type__c.equalsIgnoreCase('NOR') || ps.Type__c.equalsIgnoreCase('SIP')){
  							portAmount += ps.Amount__c;
  						}
  						else if(ps.Type__c.equalsIgnoreCase('DIR')){
  							divReinvAmount += ps.Amount__c;
  						}
  						else if(ps.Type__c.equalsIgnoreCase('STI') || ps.Type__c.equalsIgnoreCase('SWI')){
  							stpAmount += ps.Amount__c;
  						}
  						else if(ps.Type__c.equalsIgnoreCase('DVP')){
  							divAmount += ps.Amount__c;
  						}
  					}
  					if(ps.Product__c != null){
  						product += ps.Product__c;
  					}
  					if(entityFlag){
	  					entity = ps.Entity__c;
	  					folio = ps.Folio_Number__c;
	  					assetClass = ps.Asset_Class__c;
	  					entityFlag = false;
	  					schemeName = ps.Scheme_Name__c;
  					}
  					System.debug('Create Port Units'+portUnits+'Amount'+portAmount+'Product'+product);
  				}
  				if(portUnits != 0 && product != 0 && (portAmount != 0 || divAmount !=0 || divReinvAmount !=0 || divAmount != 0) ){
	  				Temp_Purchase_Report__c pr = new Temp_Purchase_Report__c(Entity__c= entity, 
	  																		 Folio_Number__c = folio, 
	  																		 Asset_Class__c = assetClass,
	  																		 UniqueName__c = uniqueName, 
	  																		 Purchase_Amount__c= portAmount, 
	  																		 Units_Quanitity__c = portUnits, 
	  																		 Product__c = product,
	  																		 Dividend_Reinvested__c = divReinvAmount,
	  																		 Dividend__c = divAmount,
	  																		 STP_Switch__c = stpAmount,
	  																		 Scheme_Scrip_Name__c = schemeName);
	  				purchaseList.add(pr);
  				}
  				
  			}
  			
  		//}
  		System.debug('Purchase List'+purchaseList.size());
  		
  		upsert purchaseList UniqueName__c;
  		  		
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
        mail.setSubject('Create Portfolio Report ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  		
    }
}