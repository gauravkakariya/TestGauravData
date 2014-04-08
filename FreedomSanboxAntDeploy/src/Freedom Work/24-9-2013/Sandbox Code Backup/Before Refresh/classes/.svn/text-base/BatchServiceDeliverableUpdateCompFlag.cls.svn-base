/**
 * @Author: Dipak Nikam
 * @since :26th Dec 2011
 * @Description: BatchServiceDeliverableUpdateCompFlag is Batchclass which is creatad for
 *				1)if the expiration date is greater than 31st March then it creates the new  ServiceDeliverable records. 
 * 				2)Get all records where end date is 31st March of that year and set the Completed flag to true	
 *  
 */




global class BatchServiceDeliverableUpdateCompFlag implements Database.Batchable<Sobject>
{
	public String query;
	public Date Datecurrent{set;get;}
	List<Service_Deliverables__c> lstServiceDeliverableToUpdate = new List<Service_Deliverables__c>();
	List<Service_Deliverables__c> lstNewServiceDeliverableToInsert = new List<Service_Deliverables__c>();
	public BatchServiceDeliverableUpdateCompFlag()
	{
		Datecurrent = System.today();
	}
	global Database.QueryLocator  start(Database.BatchableContext bc) 
	{
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, list<Service_Deliverables__c> lstScopeServDeliverables)
	{
		List<Database.Saveresult> lstSaveResult;
		System.debug('lstScopeServDeliverables======='+lstScopeServDeliverables);
		if(lstScopeServDeliverables != null && lstScopeServDeliverables.size() > 0)
		{
			Date startDateOfFinancialYear,endDateOfFinancialYear ;
			String 	strStartOfFinancialYear = Label.StartOfFinancialYear;
			String  strEndOfFinancialYear = Label.EndOfFinancialYear;
			Integer currentYear = Datecurrent.year();
			strStartOfFinancialYear = String.valueOf(currentYear)+'-' +strStartOfFinancialYear;
			strEndOfFinancialYear  = String.valueOf(currentYear + 1)+'-' +strEndOfFinancialYear;
			
			startDateOfFinancialYear = Date.valueOf(strStartOfFinancialYear);
			endDateOfFinancialYear  = Date.valueOf(strEndOfFinancialYear);
			
			for(Service_Deliverables__c objServiceDeliverable : lstScopeServDeliverables)
			{
				if(!objServiceDeliverable.Completed__c)
				{
					objServiceDeliverable.Completed__c = true;
					lstServiceDeliverableToUpdate.add(objServiceDeliverable);
					System.debug('=================lstServiceDeliverableToUpdate============'+lstServiceDeliverableToUpdate);
				}
				if(objServiceDeliverable.Expiration_Date__c  > endDateOfFinancialYear)
				{
					Service_Deliverables__c objServiceDeliverableClone =objServiceDeliverable.clone(false);
					objServiceDeliverableClone.Completed__c = false;
					objServiceDeliverableClone.Start_Date__c =  startDateOfFinancialYear;
					objServiceDeliverableClone.End_Date__c = endDateOfFinancialYear;
					lstNewServiceDeliverableToInsert.add(objServiceDeliverableClone);
				}
			}
		}
		if(lstServiceDeliverableToUpdate.size() > 0 )
		{
			lstSaveResult = Database.update(lstServiceDeliverableToUpdate);
		}
		if(lstNewServiceDeliverableToInsert.size() > 0)
		{
			lstSaveResult = Database.insert(lstNewServiceDeliverableToInsert);
		}
	}
	
	global void finish(Database.BatchableContext BC)
	{
		AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems 
      					  from AsyncApexJob where Id =:BC.getJobId()];
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   	String[] toAddresses = new String[] {'tech@ffreedom.in'};
	   	mail.setToAddresses(toAddresses);
	   	mail.setSubject('Service Deliverable job proccessed:' + apexJob.Status);
	   	mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems +'batches with '+ apexJob.NumberOfErrors + 'failures with Job id'+apexJob.id);
	  	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}