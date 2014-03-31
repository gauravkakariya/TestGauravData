@isTest
private class TestSchedulePointsCalculator {
         
         public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
         public static testMethod void testSchedulePointsCalculator(){
		          Test.startTest();
		          String jobId = System.schedule('testSchedulePointsCalculator',CRON_EXP, new SchedulePointsCalculator());
		          Test.stopTest();
	}
}