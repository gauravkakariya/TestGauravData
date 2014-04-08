@isTest
private class TestSMSScheduler
{
	static testMethod void myUnitTest() 
    {
    	Test.startTest();
    	String CRON_EXP = '0 16 17 * * ?';
    	String jobId = System.schedule('SMS testJob',CRON_EXP , new SendSmsScheduler());
   		// Get the information from the CronTrigger API object 
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		// Verify the expressions are the same 
    	System.assertEquals(CRON_EXP, ct.CronExpression);
		// Verify the job has not run 
    	System.assertEquals(0, ct.TimesTriggered);
       	Test.stopTest();
    }
}