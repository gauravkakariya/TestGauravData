public class ChequeDetailController 
{
    public  String entityId{get;set;}
    public Cheque_Details__c objChequeDetail {get;set;}
    public List<SelectOption> productOrderOptions{get;set;}
    public String orderNumber {get;set;}
    public String entityName{get;set;}
    public Boolean isRender{get;set;}
    public ChequeDetailController() 
    {
        isRender = false;
        entityId = ApexPages.currentPage().getParameters().get('entityid');
        objChequeDetail = new Cheque_Details__c();
        objChequeDetail.Account__c = entityId;
        productOrderOptions = new List<SelectOption>();
        //Select Order_Number__c, Installment__c, Cheque_Status__c, Cheque_No__c, Cheque_Date__c, Amount_Received__c, Account__c From Cheque_Details__c
        for(Order_Detail__c objOD : [Select Order_Number__c,(Select Id From Purchase_Orders__r where Is_Cancel__c = false) from Order_Detail__c 
                                            where Account__c =: entityId and Balance_Amount__c > 0])
        {
            if(objOD.Purchase_Orders__r.size() > 0)
                productOrderOptions.add(new SelectOption(objOD.Order_Number__c,objOD.Order_Number__c));
        }
        
        if(productOrderOptions.isEmpty())
        {
            isRender = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Purchase Order is not available. Please create Purchase Order.'));
            return; 
        }
    }
    
    public PageReference saveDetail()
    {
    	try
    	{
	        
	        Order_Detail__c objOrderDetail = [Select Payable_Amount__c, Paid_Amount__c From Order_Detail__c  Where Account__c =: entityId And Order_Number__c =:orderNumber];
	        Double balaceAmount = objOrderDetail.Payable_Amount__c - objOrderDetail.Paid_Amount__c;
	        objOrderDetail.Paid_Amount__c += objChequeDetail.Amount_Received__c;
	        
	        if(objOrderDetail.Paid_Amount__c > objOrderDetail.Payable_Amount__c)
	        {
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Cheque Amount should not  greater than Order Balance Amount (Rs. ' + balaceAmount + ').'));
	        	return null;
	        }
	        update objOrderDetail;         
	       
	        objChequeDetail.Order_Number__c = orderNumber;
	        insert objChequeDetail; 
	          
	        PageReference pr = new PageReference('/' + entityId);
	        return pr;
    	}
    	catch(Exception e)
    	{
    		if(e.getMessage().contains('DUPLICATE_VALUE'))
    		{
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Cheque No already entered.'));
    		}
    		else
    		{
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,e.getMessage()));
    		}
	        return null; 
	        
    	}
    }
    
    /*To cancel the new entered records*/
    public PageReference cancelDetail()
    {
        PageReference pr = new PageReference('/' + entityId);
        return pr;
    }
}