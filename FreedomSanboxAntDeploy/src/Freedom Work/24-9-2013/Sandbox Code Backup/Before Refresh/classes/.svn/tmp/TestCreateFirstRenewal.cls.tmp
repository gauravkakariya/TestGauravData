@isTest
private class TestCreateFirstRenewal 
{
    static testMethod void TestingCreateFirstRenewal() 
    {
    	List<Account> accountList = new List<Account>(); 
    	
    	/* Commented statements on 05Mar 2012 : because Cheque_Received_Date__c,Amount_Received__c,Amount_2nd_Installment__c will be removed from Account object */
        //Account acc1 = new Account(FirstName='Fname1',LastName='Lname1',Cheque_Received_Date__c=todaysDate);
        TestData_Ffreedom testData = new TestData_Ffreedom();
        Account acc1 = testData.initializeAccount();
        accountList.add(acc1);
        Account acc2 = testData.initializeAccount();
        acc2.PAN_ID__pc = 'aaaaasds12';
        accountList.add(acc2);
        
        insert accountList;
       
       
       /* Commented statements on 05Mar 2012 : because Cheque_Received_Date__c,Amount_Received__c,Amount_2nd_Installment__c will be removed from Account object */
       /*Account account2 = [select Id,LastName from Account where LastName= 'Lname2'];
       account2.Cheque_Received_Date__c=todaysDate.addYears(1);
       update account2;*/
       
    }
}