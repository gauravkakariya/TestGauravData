/*
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         Mahesh			   29/12/2011	Initial Draft : 
    											This batch class is to RESET ToSetBirthdateAlert flag of all the entities and will be executed by ScheduleUpdateToSetBirthdateAlert.
    											It will query all the active entities and first set ToSetBirthdateAlert flag to FALSE and again set it to TRUE
    											ScheduleUpdateToSetBirthdateAlert will schedule on 1st Jan. of every year so that workflow of Birthday Alert will send birthday alert
    											for new year.
*/
global class BatchUpdateToSetBirthdateAler implements Database.Batchable<Sobject>{
	
	global String query = '';
	global static Boolean isRunningTest = false;
	public List<Account> lstAccountToUpdate;  
	public BatchUpdateToSetBirthdateAler(String q)
	{
		query = q;	
		lstAccountToUpdate = new List<Account>(); 
	}
	global Database.Querylocator start(Database.BatchableContext BC)
	{
		if(isRunningTest)
			return Database.getQueryLocator(query + ' limit 190');
		else
			return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, List<Account> scope)
	{
		updateToSetBirthdateAlertFlag(scope, false);
		updateToSetBirthdateAlertFlag(scope, true);
	}
	
	private void updateToSetBirthdateAlertFlag(List<Account> lstAccount, Boolean flag)
	{
		List<Database.Saveresult> lstSaveresult = new List<Database.Saveresult>();
		for(Account objAccount : lstAccount)
		{
			objAccount.To_set_Birthdate_Alert__c = flag;
		}
		lstSaveresult = Database.update(lstAccount, false);
	}
	
	global void finish(Database.BatchableContext BC)
	{
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
						  FROM AsyncApexJob WHERE Id =:BC.getJobId()];
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'tech@ffreedom.in'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Batch to Update ToSetBirthdateAlert flag' + a.Status);
		mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}