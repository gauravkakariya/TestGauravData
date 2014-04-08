global class  SchedularForPartnerEntityStatusReport implements Schedulable
{
	global void execute(SchedulableContext sc)
    {
        BatchPartnerEntityStatusReport objBatchPartnerEntityStatusReport = new BatchPartnerEntityStatusReport();
		Database.executeBatch(objBatchPartnerEntityStatusReport, 1); 
    }
}