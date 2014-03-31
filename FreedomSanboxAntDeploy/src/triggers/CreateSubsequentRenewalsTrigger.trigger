/*
  
  Revision History:
  
    Version     Version Author     Date        Comments
    1.0         --                --         Initial Draft
    2.0     Manasi Ranade    28/12/2011   Issue Id : FS0386 :
                            Code to create a new Service Deliverables record of type ‘Ongoing Member’ whenever cheque received date  is added
    3.0     Mahesh Hirugade 29/03/2012   Issue Id : FS0386 :
							Removed field update from "Continuation Membership" workflow and code to update Renewal_SMS_Sent__c field here. The issue was, this trigger
							was getting fired twice(1. After update renewal on entity 2. By Workflow) and two subsequent records were created
*/
trigger CreateSubsequentRenewalsTrigger on Renewal__c (after update,before update) {
    //Service Deliverables
    //String strStartOfFinancialYear = Label.StartOfFinancialYear,strEndOfFinancialYear = Label.EndOfFinancialYear;
    //List<Service_Deliverables__c> serviceDeliverableLst = new List<Service_Deliverables__c>();
    //ServiceDeliverablesCreation objServiceDeliverablesCreation = new ServiceDeliverablesCreation();
    if(Trigger.isAfter)
    {
		system.debug('Ren============>');
		List<Renewal__c> renewalList = new List<Renewal__c>();
		Integer i = 0;

		for(Renewal__c ren:Trigger.new)
		{
	        Renewal__c beforeUpdateRen= Trigger.oldMap.get(ren.Id);
	        
	        if(ren.Cheque_Received_Date__c!=null && beforeUpdateRen.Cheque_Received_Date__c==null)
			{
				Renewal__c newRen = new Renewal__c(Entity__c=beforeUpdateRen.Entity__c,Renewal_Date__c=ren.Renewal_Date__c.addYears(1));
				renewalList.add(newRen);
				system.debug('*************ren Records :' + renewalList+'**** i:' + i);
				i++;
				//Service Deliverables
				//serviceDeliverableLst.add(objServiceDeliverablesCreation.createServiceDeliverables(ren.Cheque_Received_Date__c,ren.Entity__c,strStartOfFinancialYear,strEndOfFinancialYear,Label.OngoingMemberRecType));
			} 
		}
		insert renewalList;
	}
    
    if(Trigger.isBefore)
    {
      for(Renewal__c ren:Trigger.new)
	    {
	      Renewal__c beforeUpdateRen = Trigger.oldMap.get(ren.Id);
	        if(beforeUpdateRen.Cheque_Received_Date__c == null && ren.Cheque_Received_Date__c != null)
	        {
	        	//Removed field update from "Continuation Membership" workflow and updated Renewal_SMS_Sent__c field here
	        	if(ren.Has_Opted_for_Renewal__c == 'Yes')
	        	{
	        		ren.Renewal_SMS_Sent__c = true;
	        	}
	            ren.IsCompleted__c = true;
	        } 
	    }
    }
    
    //insert serviceDeliverableLst;
}