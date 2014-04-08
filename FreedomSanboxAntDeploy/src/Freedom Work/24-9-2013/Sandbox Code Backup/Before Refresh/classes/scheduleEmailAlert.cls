global class scheduleEmailAlert implements Schedulable
{
	global void execute(SchedulableContext SC)
	{
		List<User> lstUser = [Select u.Id,u.Email From User u where u.IsActive =: true AND u.IsUnsubscribe__c = false];
		List<Lead> lstLead = [Select l.Id,l.Email From Lead l where l.DoNotCall =: false AND l.IsUnsubscribe__c = false];
		// To get Entity who are Infulencer
		List<Account> lstAccount = [Select a.PersonEmail, a.Id From Account a where a.IsUnsubscribe__c =: false AND a.RecordTypeId =: InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c]; // Gaurav '012200000005do3AAA'];
		EmailFunctionality.SendNewsLetters(lstUser,lstLead,lstAccount);
	}
}