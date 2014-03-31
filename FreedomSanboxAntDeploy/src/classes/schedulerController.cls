public with sharing class schedulerController {
	public Pagereference save()
	{
		List<User> lstUser = [Select u.Id,u.Email From User u where u.IsActive =: true AND u.IsUnsubscribe__c = false ];
		List<Lead> lstLead = [Select l.Id,l.Email From Lead l where l.DoNotCall =: false AND l.IsUnsubscribe__c = false ];
		// To get Entity who are Infulencer
		List<Account> lstAccount = [Select a.PersonEmail, a.Id From Account a where a.IsUnsubscribe__c =: false AND a.RecordTypeId ='012200000005do3AAA'];
		EmailFunctionality.SendNewsLetters(lstUser,lstLead,lstAccount);
		
		/*String sch = '30 38 14 6 8 ?';
		scheduleEmailAlert email = new scheduleEmailAlert();
		system.schedule('News Letter Mass Emailer', sch, email);*/
		return null;
	}
	
}