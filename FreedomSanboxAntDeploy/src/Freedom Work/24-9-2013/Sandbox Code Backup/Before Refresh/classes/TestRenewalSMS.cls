public class TestRenewalSMS 
{
	@isTest(SeeAllData = true)
    static void testSMSRenewal() 
    {
        List<Renewal__c> renewals1 = new List<Renewal__c>();
        List<Renewal__c> renewals2 = new List<Renewal__c>();
		List<Renewal__c> renewalList = new List<Renewal__c>();
		List<Renewal__c> updateList = new List<Renewal__c>();
		List<Account> accountList = new List<Account>();
		
		//Date renewalDate = System.today().addDays(15);
    	Account acc1 = new Account(FirstName='Test_Fname1',LastName='Test_Renewal_Lname1',PersonMobilePhone='9876543210',PersonEmail='abc@abc.com');
    	accountList.add(acc1);
    	
    	Account acc2 = new Account(FirstName='Test_Fname2',LastName='Test_Renewal_Lname2',PersonMobilePhone='9876543210',PersonEmail='abc@abc.com');
    	accountList.add(acc2);
    	
    	insert accountList;
    	 
    	Renewal__c ren1 = new Renewal__c(Entity__c=acc1.Id,Renewal_SMS_Sent__c=false);
		renewalList.add(ren1);
		Renewal__c ren2 = new Renewal__c(Entity__c=acc2.Id,Discontinuation_SMS_Sent__c =false);
		renewalList.add(ren2);
		
		insert renewalList;
		
		renewals1= [select Id,Renewal_SMS_Sent__c,Entity__c from Renewal__c where Entity__c=:acc1.Id];
		renewals1[0].Renewal_SMS_Sent__c=true;
		updateList.add(renewals1[0]);
		
		renewals2= [select Id,Discontinuation_SMS_Sent__c,Entity__c from Renewal__c where Entity__c =:acc2.Id];
		renewals2[0].Discontinuation_SMS_Sent__c =true;
		updateList.add(renewals2[0]);
		
		update updateList;
    }
}