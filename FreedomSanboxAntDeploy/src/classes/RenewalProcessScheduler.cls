global class RenewalProcessScheduler implements Schedulable
{
	public Date todaysDate {set;get;}
	public RenewalProcessScheduler()
	{
		todaysDate = System.today();
	} 
	
	global void execute(SchedulableContext SC)
    {
    	String strQuery = '';
    	strQuery = 'Select Renewal_SMS_Sent__c, IsCompleted__c, Renewal_Date__c, Mobile__c, Entity_Name__c,'+
    					' Has_Opted_for_Renewal__c, Expected_Amount__c, Entity__r.Entity_Status__c, Entity__r.OwnerId, Entity__c, Discount__c,'+
    					' Discontinuation_SMS_Sent__c, CreatedDate, Cheque_Received_Date__c, Entity__r.Email_Temp__c, Entity__r.PersonEmail,'+
    					'Entity__r.PersonContactId From Renewal__c r where IsCompleted__c = false';
    	//strQuery = 'Select r.Renewal_SMS_Sent__c, r.IsCompleted__c,r.Renewal_Date__c ,r.Mobile__c,r.Entity_Name__c,r.Has_Opted_for_Renewal__c, r.Expected_Amount__c, r.Entity__r.Entity_Status__c, r.Entity__r.OwnerId, r.Entity__c, r.Discount__c, r.Discontinuation_SMS_Sent__c, r.CreatedDate, r.Cheque_Received_Date__c,r.Entity__r.Email_Temp__c, r.Entity__r.PersonEmail,r.Entity__r.PersonContactId From Renewal__c r where IsCompleted__c = false';
        BatchForRenewalProcess objBatchForRenewalProcess = new BatchForRenewalProcess();
        //objBatchForRenewalProcess.todaysDate = todaysDate; 
     //  /* Setty: SMS Magic uninstall 19/09/2012
        objBatchForRenewalProcess.query = strQuery;
         database.executebatch(objBatchForRenewalProcess,10);
      //  End:setty */
    }
}