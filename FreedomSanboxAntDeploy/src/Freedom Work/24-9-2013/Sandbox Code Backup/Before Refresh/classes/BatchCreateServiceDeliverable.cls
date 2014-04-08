global class BatchCreateServiceDeliverable implements Database.Batchable<Sobject>
{
	/*public static testMethod void testBatchService() 
	{
        Test.StartTest();
        String strQuery = 'Select a.RecordType.Name, a.Id, a.Entity_Status__c, a.CreatedDate From Account a';
        BatchCreateServiceDeliverable  objBatchDailyServiceDeliverableUpdate =  new BatchCreateServiceDeliverable();
        objBatchDailyServiceDeliverableUpdate.query = strQuery;
        objBatchDailyServiceDeliverableUpdate.isTest = true;
        //Database.executeBatch(objBatchDailyServiceDeliverableUpdate,10); 
        Test.stopTest();
	}*/
	
	List<Database.Saveresult>lstSaveResult;
	public String query;
	public Boolean isTest {set; get;}
	public BatchCreateServiceDeliverable()
	{
		isTest = false;
	} 
	
   global Database.QueryLocator  start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Account> lstScope)
    {
    	System.debug('lstScope======='+lstScope+'====lstScope size==='+lstScope.size());
    	List<Service_Deliverables__c> lstServiceDeliverableToUpdate = new List<Service_Deliverables__c>();
    	
    	String strRecordTypeNew =Label.NewMemberRecType; 
    	String strRecordTypeOngoing =Label.OngoingMemberRecType; 
    	
    	if(lstScope != null && lstScope.size() > 0)
    	{
    		ServiceDeliverablesCreation objService = new ServiceDeliverablesCreation();
    		Date currentDate  = System.today();
    		Integer numberOfDays; 
    		for(Account acc : lstScope)
    		{
    			if(acc.RecordType.Name =='Client' && acc.Entity_Status__c == 'Active')
    			{
	    			Service_Deliverables__c objServiceDeliverable = new Service_Deliverables__c();
	    			Date createdDate = acc.CreatedDate.Date();
	    		  	numberOfDays = createdDate.daysBetween(currentDate);
	    		  	System.debug('numberOfDays======='+numberOfDays);
	    		  	if(numberOfDays > 365)
	    		  	{
	    		  		objServiceDeliverable = objService.createServiceDeliverables(createdDate, acc.Id, Label.StartOfFinancialYear, Label.EndOfFinancialYear, strRecordTypeOngoing);
	    		  		lstServiceDeliverableToUpdate.add(objServiceDeliverable);
	    		  	}
	    		  	else
	    		  	{
	    		  		objServiceDeliverable = objService.createServiceDeliverables(createdDate, acc.Id, Label.StartOfFinancialYear, Label.EndOfFinancialYear, strRecordTypeNew);
	                    lstServiceDeliverableToUpdate.add(objServiceDeliverable);
	    		  	}
    			}
    		}
    		
    		if( lstServiceDeliverableToUpdate != null &&  lstServiceDeliverableToUpdate.size() > 0 )
    		{
    			 lstSaveResult = Database.insert(lstServiceDeliverableToUpdate);
    			if(lstSaveResult != null && lstSaveResult.size() > 0)
    			{
    				for(Database.Saveresult objSaveresult : lstSaveResult)
    				{
    					System.debug('objSaveresult==========='+objSaveresult.getId());
    				}
    			}
    		}	
    	}
    }
    
    global void finish(Database.BatchableContext BC)
    {
    	AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems 
                                 from AsyncApexJob where Id =:BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'tech@ffreedom.in'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Daily Service Deliverable Update job proccessed:' + apexJob.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems +'batches with '+ apexJob.NumberOfErrors + 'failures with Job id'+apexJob.id);
        mail.setHtmlBody('HtmlBody id '+lstSaveResult+'<br/> Size is'+lstSaveResult.size());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}