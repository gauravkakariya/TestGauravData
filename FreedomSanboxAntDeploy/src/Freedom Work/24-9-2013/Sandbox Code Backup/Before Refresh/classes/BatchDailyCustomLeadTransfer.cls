global class BatchDailyCustomLeadTransfer implements Database.Batchable<sObject>, Database.Stateful
{
	
	public List<Lead_Platform_User__c> lstLead = new List<Lead_Platform_User__c>();
	public List<Lead> lstStdLead = new List<Lead>();
	
	global Database.QueryLocator start (Database.BatchableContext BC) 
	{
		String query = 'Select Id, Ffreedom_Score__c, Appointment_Time__c, Age__c, Rating__c, Probability__c, Name__c, Lead_Status__c, Lead_Source__c From Lead_Platform_User__c  where IsTransferred__c = false';
		system.debug('***Query****'+query);
		return Database.getQueryLocator(query);			//passing the query string to the Database object.      
	}//close start method
	
	global void execute(Database.BatchableContext BC, list <Lead_Platform_User__c> scope)
	{
		system.debug('***scope****'+scope);
		lstLead = new List<Lead_Platform_User__c>();
		lstStdLead = new List<Lead>();
		for(Lead_Platform_User__c s : scope)
		{
			Lead newLead = new Lead();
			system.debug('==============In for loop'+s);
			s.Ffreedom_Score__c = 50;
			s.IsTransferred__c = true;
			lstLead.add(s);
			newLead.LastName = s.Name__c;
			newLead.Age__c = s.Age__c;
			newLead.Appointment_Time__c = s.Appointment_Time__c;
			newLead.Ffreedom_Score__c = s.Ffreedom_Score__c;
			newLead.Probability__c = s.Probability__c;
			newLead.Status = s.Lead_Status__c;
			newLead.LeadSource = s.Lead_Source__c;
			newLead.Rating = s.Rating__c;
			lstStdLead.add(newLead);
			system.debug('***SSSSSSSSSSs****'+lstStdLead);
		}
		update scope;
		insert lstStdLead;
	}
	
	global void finish(Database.BatchableContext BC)
	{
		AsyncApexJob a = [Select Id, CreatedDate, CompletedDate From AsyncApexJob where Id =:BC.getJobId()];
		Datetime StrtDate=a.CreatedDate;
		Datetime EndDate=a.CompletedDate;
				
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(new String[] {'tech@ffreedom.in'});
		mail.setSenderDisplayName('Lead Batch Processing');
		mail.setSubject('Daily Custom Lead Transfer to Standard Lead Job Complete');
		mail.setPlainTextBody('Batch Process has completed.' + ' Your batch jobs Start DateTime is '
							    + StrtDate + 'and End DateTime is ' + EndDate + ' Total Duration (in Hours) is  = '+(a.CompletedDate.hour()-a.CreatedDate.hour())
							    + '. Records updates successfully.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}