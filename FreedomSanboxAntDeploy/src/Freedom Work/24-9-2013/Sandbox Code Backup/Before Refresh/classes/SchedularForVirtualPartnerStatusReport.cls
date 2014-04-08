global class SchedularForVirtualPartnerStatusReport implements Schedulable 
{
	global void execute(SchedulableContext sc)
    {
        BatchVirtualPartnerStatusReport objBatchVirtualPartnerStatusReport = new BatchVirtualPartnerStatusReport();
		Database.executeBatch(objBatchVirtualPartnerStatusReport, 1); 
    }
}