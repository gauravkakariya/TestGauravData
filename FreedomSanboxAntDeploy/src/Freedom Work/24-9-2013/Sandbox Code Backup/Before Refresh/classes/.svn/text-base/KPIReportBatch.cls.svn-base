global class KPIReportBatch implements Database.Batchable<Sobject>
{
	public String query;
	public Date currentDate{set;get;}
	global Database.QueryLocator start(Database.BatchableContext info)
	{ 
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext info, List<User> scope)
	{
		if(scope != null && scope.size() > 0)
		{
			for(User objUser:scope)
			{
				KPIReportEvaluation objKPIReport = new KPIReportEvaluation(objUser.Id,currentDate);//objUser.Id
				objKPIReport.getKPIReports();
			}
		}
	}
	
	global void finish(Database.BatchableContext info)
	{
		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems 
      					  from AsyncApexJob where Id =:info.getJobId()];
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] toAddresses = new String[] {'tech@ffreedom.in'};
	   mail.setToAddresses(toAddresses);
	   mail.setSubject('KPI batch proccessed:' + a.Status);
	   mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +'batches with '+ a.NumberOfErrors + 'failures with Job id'+a.id);
	   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	 }

}