public class TestSendRenewalSMS 
{
	@isTest(SeeAllData = true)
    static void testRenewalSMS() {

		List<Account> accounts = new List<Account>();
		List<Account> accountsList = new List<Account>();
		List<Account> updateList = new List<Account>();
		
		Date renewalDate = System.today().addDays(15);
    	Account acc1 = new Account(FirstName='Test_Fname1',LastName='Test_Renewal_Lname1',Renewal_Due_Date__c=renewalDate,Entity_Status__c='Active',
    									Renewal_SMS_Sent__c=false,PersonMobilePhone='9876543210');
		accountsList.add(acc1);
		Account acc2 = new Account(FirstName='Test_Fname2',LastName='Test_Renewal_Lname2',Renewal_Due_Date__c=renewalDate,Entity_Status__c='Active',
										Renewal_SMS_Sent__c=true,PersonMobilePhone='9876543210');
		accountsList.add(acc2);
		
		insert accountsList;
		
		accounts= [select Id,Renewal_SMS_Sent__c from Account where LastName = 'Test_Renewal_Lname1'];
		accounts[0].Renewal_SMS_Sent__c=true;
		updateList.add(accounts[0]);
		
		accounts= [select Id,Renewal_SMS_Sent__c from Account where LastName = 'Test_Renewal_Lname2'];
		accounts[0].Renewal_SMS_Sent__c=false;
		updateList.add(accounts[0]);
		
		update updateList;
	
		
    }
}