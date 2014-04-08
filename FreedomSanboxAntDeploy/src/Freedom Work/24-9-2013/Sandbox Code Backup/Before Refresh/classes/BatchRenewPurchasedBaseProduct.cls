global  class BatchRenewPurchasedBaseProduct implements Database.Batchable<Sobject>
{
    global Database.QueryLocator  start(Database.BatchableContext bc)
    {
        Date todayDate = System.today();
        String strQuery = 'Select Renewal_Date__c, Entity__c from Renewal__c where Renewal_Date__c =: todayDate';
        return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext BC, list<Renewal__c> lstRenewal)
    {
    	try
    	{	
    	
	        Set<Id> setAccountId = new Set<Id>();
	        Set<String> setProductName = new Set<String>();
	        Map<String, Product_Master__c> mapIdToProductDetail = new Map<String, Product_Master__c>([Select Product_Name__c, ProductType__c, Goals_Allowed_List__c, 
	                                                                                                                Financial_Planing_Output_Report__c, 
	                                                                                                                Data_Collection_Analysis_Control__c,
	                                                                                                                No_of_Goals_Allowed__c, IsTopupService__c, 
	                                                                                                                Renewal_Grace_Days__c, 
	                                                                                                                Renewal_Period_In_Days__c,  
	                                                                                                                Subscription_Period_In_Days__c,  
	                                                                                                                (Select Price_value__c, Discount__c, Service_Tax__c,Renewal_price__c, 
	                                                                                                                        Sp_Education_Cess__c, VAT__c, Education_Cess__c 
	                                                                                                                        From Product_Price_Books__r 
	                                                                                                                        order by CreatedDate desc)  
	                                                                                                          From Product_Master__c  
	                                                                                                          Where Is_Active__c = true 
	                                                                                                          		and ProductType__c = 'Base Product' 
	                                                                                                       		and IsRenewalAllowed__c = true order by Base_Product_Weightage__c]);   
	        
	        
	        for(Product_Master__c objPO :  mapIdToProductDetail.values())
	        {
	        	setProductName.add(objPO.Product_Name__c);
	        }
	        System.debug('-------------mapIdToProductDetail--------------'+mapIdToProductDetail.size());
	        for(Renewal__c objRenewal : lstRenewal)
	        {
	            setAccountId.add(objRenewal.Entity__c);
	        }
	        System.debug('-------------lstRenewal--------------'+lstRenewal.size());
	        Map<String, Schema.SObjectField> mapFieldNameToFieldDescribe = Purchase_Order__c.sObjectType.getDescribe().fields.getMap();
	        String strFields = 'Select ';
	        for(String field : mapFieldNameToFieldDescribe.keySet())
	        {
	            strFields += field +', ';
	        }
	        
	        strFields = strFields.substring(0, strFields.length() - 2);
	        strFields += ' From Purchase_Order__c where Product_Type__c = \'Base Product\' and Is_Cancel__c = false and Entity__c =: setAccountId';
	        List<Purchase_Order__c> lstPurchaseOrder = Database.query(strFields);
	        
	        system.debug('***lstPurchaseOrder*'+lstPurchaseOrder); 
	                                           
	        List<Order_Detail__c> lstOrderDetail = new List<Order_Detail__c>();
	        Map<Id, Order_Detail__c> mapEntityIdToOrderDetail = new Map<Id, Order_Detail__c>();
	        System.debug('-------------lstPurchaseOrder--------------'+lstPurchaseOrder.size());
	        for(Purchase_Order__c objPO : lstPurchaseOrder)
	        {
	        	if(setProductName.contains(objPO.Selected_Product__c))
	        	{
		            List<String> lstOrderNumber = objPO.Order__c.split('/');
		            Integer orderNumber = Integer.valueOf(lstOrderNumber[2]) + 1;
		            
		            String strOrderNumber = 'FFP/' + String.valueOf(System.today().year() ).substring(2, 4) + '-' + 
		                                                 String.valueOf(System.today().year() + 1).substring(2, 4) + '/00' + orderNumber;
		            
		            system.debug('***mapProductNameToP*'+mapIdToProductDetail.get(objPO.Product_Master__c).Product_Price_Books__r[0]);                                     
		            Product_Price_Book__c objPriceBook = mapIdToProductDetail.get(objPO.Product_Master__c).Product_Price_Books__r[0];
		                                                
		            Order_Detail__c objOrderDetail = new Order_Detail__c(Payable_Amount__c = objPriceBook.Renewal_price__c - objPriceBook.Discount__c, Order_Number__c = strOrderNumber, 
		                                                Account__c = objPO.Entity__c);
		            mapEntityIdToOrderDetail.put(objPO.Entity__c, objOrderDetail);
	        	}
	        } 
	         
	        if(!mapEntityIdToOrderDetail.values().isEmpty())
	        	insert mapEntityIdToOrderDetail.values();
	        
	        System.debug('-------------mapEntityIdToOrderDetail--------------'+mapEntityIdToOrderDetail.size());
	        List<Purchase_Order__c> lstPO = new List<Purchase_Order__c>();
	        Map<Id,Decimal> mapEntityIdToSubscriptionDays = new  Map<Id,Decimal>();
	        List<Renewal__c> lstRenewalUpdate = new List<Renewal__c>(); 
	    
	        for(Purchase_Order__c objPO : lstPurchaseOrder)
	        {
	        	if(setProductName.contains(objPO.Selected_Product__c))
	        	{
		            Order_Detail__c objOD = mapEntityIdToOrderDetail.get(objPO.Entity__c);
		            
		            Product_Price_Book__c objPriceBook = mapIdToProductDetail.get(objPO.Product_Master__c).Product_Price_Books__r[0];      
		                                                     
		            Purchase_Order__c objPurchaseOrder = objPO.clone();
		            objPurchaseOrder.Order__c = objOD.Order_Number__c;
		            objPurchaseOrder.Order_Datetime__c = DateTime.now();
		            objPurchaseOrder.Product_Price__c = objPriceBook.Renewal_price__c;
		            objPurchaseOrder.Discount__c = objPriceBook.Discount__c; 
		            objPurchaseOrder.Payable_Amount__c = objOD.Payable_Amount__c;
		            objPurchaseOrder.Service_Tax__c = objPriceBook.Service_Tax__c;
		            objPurchaseOrder.VAT__c = objPriceBook.VAT__c;
		            objPurchaseOrder.Education_Cess__c = objPriceBook.Education_Cess__c;
		            objPurchaseOrder.Sp_Education_Cess__c = objPriceBook.Sp_Education_Cess__c;
		            objPurchaseOrder.Order_status__c = 'New';
		            objPurchaseOrder.Order_Detail__c = objOD.Id;
		            
		            lstPO.add(objPurchaseOrder);
		            mapEntityIdToSubscriptionDays.put(objPurchaseOrder.Entity__c, mapIdToProductDetail.get(objPO.Product_Master__c).Subscription_Period_In_Days__c);
		            objPO.Is_Cancel__c = true;
	        	}
	        }
	        
	        insert lstPO;
	        update lstPurchaseOrder;  
	        
	        for(Renewal__c objRenewal : lstRenewal)
	        {
	        	if(mapEntityIdToSubscriptionDays.containsKey(objRenewal.Entity__c))
	        	{
		            objRenewal.Renewal_Date__c= objRenewal.Renewal_Date__c.addDays(Integer.valueOf(mapEntityIdToSubscriptionDays.get(objRenewal.Entity__c)));
		            lstRenewalUpdate.add(objRenewal);
	        	}
	        }
	      
	       if(!lstRenewalUpdate.isEmpty()) 
	           update lstRenewalUpdate;
    	}
    	catch(Exception ex)
    	{
    		sendMessage('Renew Purchased Base Service Exception', ex.getMessage());
    	}      
    }
    
    global void finish(Database.BatchableContext BC)
    {
    	AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems 
      					  from AsyncApexJob where Id =:BC.getJobId()];
      	String subject = 'Renew Purchased Base Service' + apexJob.Status;
      	String textBody = 'The batch Apex job processed ' + apexJob.TotalJobItems +' batches with '+apexJob.NumberOfErrors + ' failures with Job id '+apexJob.id;				  
	  	sendMessage(subject, textBody);
    }
    
    private void sendMessage(String subject , String textBody)
    {
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   	String[] toAddresses = new String[] {'tech@ffreedom.in'};
	   	mail.setToAddresses(toAddresses);
	   	mail.setSubject(subject);
	   	mail.setPlainTextBody(textBody);
	  	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
    }
}