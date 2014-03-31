global class SchedularForBusinessPartnerStatusReport implements Schedulable 
{ 
	global void execute(SchedulableContext sc)
    {
        BatchBusinessPartnerStatusReport objBatchBusinessPartnerStatusReport = new BatchBusinessPartnerStatusReport();
		Database.executeBatch(objBatchBusinessPartnerStatusReport, 1); 
    }
}