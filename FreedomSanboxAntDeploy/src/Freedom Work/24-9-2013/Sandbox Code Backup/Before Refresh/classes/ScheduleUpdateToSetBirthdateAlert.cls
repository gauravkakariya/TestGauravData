/*
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         Mahesh			   29/12/2011	Initial Draft : 
    											The schedular will get all the entities from query and will pass these entities to Batch class.
    											Batch class in turn resets ToSetBirthdateAlert flag on entity. Schedular will schedule on 1st Jan. of every year. 
*/
global class ScheduleUpdateToSetBirthdateAlert implements Schedulable{

	global void execute(SchedulableContext sc)
	{
		try
		{
			String query = 'Select Id, PersonBirthdate, To_set_Birthdate_Alert__c, Entity_Status__c From Account where Entity_Status__c = \'Active\'';
			BatchUpdateToSetBirthdateAler objBatch = new BatchUpdateToSetBirthdateAler(query);
			Database.executeBatch(objBatch);
		}
		catch(Exception e)
		{
			System.debug('=== Exception ===' + e);
		}
	}
	public static testMethod void TestScheduleUpdateToSetBirthdateAlert()
	{
		List<Account> lstAccount = new List<Account>();
		for(Integer i = 0; i<20; i++){
			lstAccount.add(new Account(FirstName='Test Account - ' + String.valueOf(i), LastName='Test_Lname', Entity_Status__c='Active'));
		}
		Insert lstAccount;

		test.startTest();
		BatchUpdateToSetBirthdateAler.isRunningTest = true;
		SchedulableContext sc;
		ScheduleUpdateToSetBirthdateAlert objScheduler = new ScheduleUpdateToSetBirthdateAlert();
		objScheduler.execute(sc);
		test.stopTest();
	}
}