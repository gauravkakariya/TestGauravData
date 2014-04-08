@isTest
private class TestRenewalProcessScheduler 
{

    static testMethod void RenewalProcessSchedulerTest()
    {
        Test.startTest();
        RenewalProcessScheduler m = new RenewalProcessScheduler();
		String sch = '0  53 14   *  * ?';
		system.schedule('Test Renewal Job', sch, m); 
        Test.stopTest();
    }
}