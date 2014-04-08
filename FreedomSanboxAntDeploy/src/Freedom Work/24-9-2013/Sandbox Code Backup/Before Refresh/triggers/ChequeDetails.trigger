trigger ChequeDetails on Cheque_Details__c (after insert, after update) 
{
	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
	{
	    Map<Id, List<Cheque_Details__c>> mapOrderDetailTolstChequeDetail = new Map<Id, List<Cheque_Details__c>>();
	    
	    List<Order_Detail__c> lstOrderDetails = new List<Order_Detail__c>();
	    Set<Id> setAccountId = new Set<Id>();
	    for(Cheque_Details__c objCD : Trigger.New)
	    {
	    	setAccountId.add(objCD.Account__c);
	    }
	    for(Cheque_Details__c objChequeDetails : [Select Id, Order_Detail__c, Amount_Received__c from Cheque_Details__c where Account__c IN: setAccountId])
	    {
	    	if(!mapOrderDetailTolstChequeDetail.containsKey(objChequeDetails.Order_Detail__c))
	        	mapOrderDetailTolstChequeDetail.put(objChequeDetails.Order_Detail__c, new List<Cheque_Details__c>{objChequeDetails});      
	        else
	           mapOrderDetailTolstChequeDetail.get(objChequeDetails.Order_Detail__c).add(objChequeDetails);  
	    }
	    
	    for(Order_Detail__c objOrderDetails : [Select Id,Paid_Amount__c From Order_Detail__c Where Id IN: mapOrderDetailTolstChequeDetail.keySet()])
	    {
	    	objOrderDetails.Paid_Amount__c = 0;
	    	for(Cheque_Details__c objCD : mapOrderDetailTolstChequeDetail.get(objOrderDetails.Id))
	    	{
		        objOrderDetails.Paid_Amount__c += objCD.Amount_Received__c; 
	    	}
	    	lstOrderDetails.add(objOrderDetails);
	    }
	    
	    update lstOrderDetails;
	}
}