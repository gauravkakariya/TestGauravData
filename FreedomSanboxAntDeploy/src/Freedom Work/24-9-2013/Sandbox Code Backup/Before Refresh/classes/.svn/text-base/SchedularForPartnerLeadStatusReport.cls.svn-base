global class SchedularForPartnerLeadStatusReport implements Schedulable
{
	global void execute(SchedulableContext sc)
    {
        BatchPartnerLeadStatusReport objBatchPartnerLeadStatusReport = new BatchPartnerLeadStatusReport();
		Database.executeBatch(objBatchPartnerLeadStatusReport, 1); 
    }
}