public class CheckOpptyForLeadController {
	private final Lead ld;
	public Pagereference pr = null;
	
	    public CheckOpptyForLeadController(ApexPages.StandardController controller)
	    {
	        this.ld = (Lead)controller.getRecord();
	        checkForOppty();
	    }
	    
	    public PageReference checkForOppty(){
	    	List<Opportunity> opp = [select Id from Opportunity where Lead__c=:ld.Id];
	    	if(opp == null || opp.isEmpty()){
	    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is opportunity created for this Lead, so you cannot convert it')); 
	    	}
	    	else
	    	{
	    		String url='https://emea.salesforce.com/lead/leadconvert.jsp?retURL='+ld.Id+'&id='+ld.id;
	    		pr= new Pagereference(url);
	    	}
	    	return pr;
	    	
	    }
	    
}