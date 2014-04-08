global class SchedulerToServiceDeliverableRecords implements Schedulable
{
	global void execute(SchedulableContext SC)
	{
		String strQuery = 'Select a.RecordType.Name, a.Id, a.Entity_Status__c, a.CreatedDate From Account a';
        BatchCreateServiceDeliverable  objBatchDailyServiceDeliverableUpdate =  new BatchCreateServiceDeliverable();
        objBatchDailyServiceDeliverableUpdate.query = strQuery;
        Database.executeBatch(objBatchDailyServiceDeliverableUpdate,10); 
	} 
}