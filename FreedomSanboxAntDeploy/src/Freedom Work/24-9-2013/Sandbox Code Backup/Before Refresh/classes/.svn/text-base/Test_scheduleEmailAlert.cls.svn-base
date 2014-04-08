@isTest
private class Test_scheduleEmailAlert {
	
	/*public static testmethod void testSchedulerController()
	{
		Test.startTest();
			schedulerController objschedulerController = new schedulerController();
			objschedulerController.save();
		Test.stopTest();
	}*/
	public static testMethod void testScheduleEmailAlert()
	{
		Test.startTest();
		List<User> lstUser = [Select u.Id From User u];
		List<Lead> lstLead = new List<Lead>();
		Lead objLead = new Lead(LastName='ABC',Company='TestCompany');
		Insert objLead;
		lstLead.add(objLead);
		
		List<Account> lstAccount = new List<Account>();
		Account objAccount = new Account();
		objAccount.FirstName = 'FName';
		objAccount.LastName = 'LName';
		insert objAccount;
		lstAccount.add(objAccount);

		EmailFunctionality.SendNewsLetters(lstUser,lstLead,lstAccount);
		Test.stopTest();
	}
}
//////////////////////////////////////////
/*
@isTest
private class EmailFunctionalityTest {
	static testmethod void testEmailFunctionality(){
		test.startTest();
		List<Lead> lstLead = new List<Lead>();
		Lead objLead = New Lead(LastName='ABC',Company='TestCompany');
		insert objLead;
		lstLead.add(objLead);
		
		List<User> lstUser = [Select u.IsActive, u.Id From User u Where u.IsActive = True];
		
		Account objAcc = new Account();
		objAcc.FirstName = 'FName';
		objAcc.LastName = 'LName';
		insert objAcc;
		List<Account> lstAccount = New List<Account>();
		lstAccount.add(objAcc);
		EmailFunctionality.SendNewsLetters(lstUser,lstLead,lstAccount); // 76%
		List<String> lstString = EmailFunctionality.CreateMasterEmailList(lstUser, lstLead);
		
		test.stopTest();
	}

}
*/