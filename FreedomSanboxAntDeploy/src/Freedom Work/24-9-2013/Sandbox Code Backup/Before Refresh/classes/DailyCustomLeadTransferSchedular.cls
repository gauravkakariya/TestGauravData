global class DailyCustomLeadTransferSchedular implements Schedulable 
{
	global void execute(SchedulableContext SC)
	{
		BatchDailyCustomLeadTransfer BatchLead = new BatchDailyCustomLeadTransfer();
		Database.executeBatch(BatchLead);
	}
}