/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0			Manasi			   27/05/2011  Issue ID : F0061 :
    										   A.Created new class.
											   B.It implements Batchable interface.
											   C.Execute methode calculates current age and updates the entity
*/				
global class UpdateCurrentAgeFormBirthdateOfEntity implements Database.Batchable<sObject>
{
	global String query;
	public String email;
	global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
    }
	
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{
    		List<Account> updateCurrentAgeOfEntities = new List<Account>();
    		Integer iCurrentYear = System.today().year();
    		Integer iBirthYear = 0;
    		Integer iCurrentAge = 0; 
    		for(sObject obj: scope)
			{
				Account acc = (Account)obj;
				if(acc.PersonBirthdate != null)// && acc.Entity_Status__c != null && acc.Entity_Status__c != '' && acc.Entity_Status__c == 'Active')
				{
					Date dtBirthDate = acc.PersonBirthdate;
					iBirthYear = dtBirthDate.year();
					iCurrentAge = (iCurrentYear - iBirthYear) + 1;
					acc.Current_Age__c = iCurrentAge;
					updateCurrentAgeOfEntities.add(acc);
				}
			}
			update updateCurrentAgeOfEntities;
    }
     global void finish(Database.BatchableContext BC)
     {
     	AsyncApexJob a = [Select Id, 
                                 Status,
                                 NumberOfErrors, 
                                 JobItemsProcessed,  
                                 TotalJobItems, 
                                 CreatedBy.Email 
                                 from AsyncApexJob 
                                 where Id =:BC.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('tech@ffreedom.in');
        mail.setSenderDisplayName('Batch Processing');  
        mail.setSubject(' Update Current Age ' + a.Status);
        mail.setPlainTextBody('The batch apex job processed ' + a.TotalJobItems +   ' batches with ' + a.NumberofErrors + ' failures.');
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
}