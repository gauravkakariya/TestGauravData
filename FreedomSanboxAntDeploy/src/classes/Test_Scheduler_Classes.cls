/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   30/06/2011	Issue id : F0061 : 
    											Created test method testScheduleUpdateCurrentAgeFormBirthdate() 
    											for ScheduleUpdateCurrentAgeFormBirthdate class.
*/		
@isTest
private class Test_Scheduler_Classes {
	public static String CRON_EXP = '0 0 0 3 9 ? 2022';
	
	//This is the test method for ScheduleSummaryReport class
	public static testMethod void testScheduleSummary() {
		Test.startTest();
		String jobId = System.schedule('testScheduleSummary',CRON_EXP, new ScheduleSummaryReport());
		Test.stopTest();
		
	}
	
	// This is the test method for ScheduleDetailedReport class
	public static testMethod void testScheduleDetailedReport() {
		Test.startTest();
		String jobId = System.schedule('testScheduleDetailedReport',CRON_EXP, new ScheduleDetailedReport());
		Test.stopTest();
		
	}
  	
  	// This is the test method for scheduleEmailAlert class
	public static testMethod void testscheduleEmailAlert(){
		Test.startTest();
		String jobId = System.schedule('testscheduleEmailAlert',CRON_EXP, new scheduleEmailAlert());
		Test.stopTest();
	}
    // This is the test method for ScheduleSummaryReturnCalculation class
    public static testMethod void testScheduleSummaryReturnCalculation() {
    	Test.startTest();
		String jobId = System.schedule('testScheduleSummaryReturnCalculation',CRON_EXP, new ScheduleSummaryReturnCalculation());
		Test.stopTest();
    }
    
    // This is the test method for SchedulePortfolioReport class
    public static testMethod void testSchedulePortfolioReport() {
    	Test.startTest();
		String jobId = System.schedule('testSchedulePortfolioReport',CRON_EXP, new SchedulePortfolioReport());
		Test.stopTest();
    }
    
    	// This is the test method for SchedulePointsCalculation class
	public static testMethod void testSchedulePointsCalculation(){
		Test.startTest();
		String jobId = System.schedule('testSchedulePointsCalculation',CRON_EXP, new SchedulePointsCalculation());
		Test.stopTest();
	}
   
     // This is the test method for ScheduleSalesUnits class
    public static testMethod void testScheduleSalesUnits() {
    	Test.startTest();
		String jobId = System.schedule('testSchedulePFReport',CRON_EXP, new ScheduleSalesUnits());
		Test.stopTest();
    }
    // This is the test method for ScheduleSipDueDateUpdates class
    public static testMethod void testScheduleSipDueDateUpdates() {
    	Test.startTest();
		String jobId = System.schedule('testScheduleSip',CRON_EXP, new ScheduleSipDueDateUpdates());
		Test.stopTest();
        
    } 
    
    // This is the test method for ScheduleInsuranceDueDatesUpdate class
    public static testMethod void testScheduleInsuranceDueDatesUpdate() {
		Test.startTest();
		String jobId = System.schedule('testScheduleDetailedReport',CRON_EXP, new ScheduleInsuranceDueDatesUpdate());
		Test.stopTest();
		
	}
	
	// This is the test method for ScheduleUpdateTribalFlagToTrueForAccount class
	public static testMethod void testScheduleUpdateTribalFlagToTrueForAccount(){
		Test.startTest();
		String jobId = System.schedule('testScheduleUpdateTribalFlagToTrueForAccount',CRON_EXP, new ScheduleUpdateTribalFlagToTrueForAccount());
		Test.stopTest();
	}
	
	// This is the test method for ScheduleUpdateTribalFlagFalseForAccount class
	public static testMethod void testScheduleUpdateTribalFlagFalseForAccount(){
		Test.startTest();
		String jobId = System.schedule('testScheduleUpdateTribalFlagFalseForAccount',CRON_EXP, new ScheduleUpdateTribalFlagFalseForAccount());
		Test.stopTest();
	}
	
	// This is the test method for ScheduleUpdateTribalFlagToFalseForLead class
	public static testMethod void testScheduleUpdateTribalFlagToFalseForLead(){
		Test.startTest();
		String jobId = System.schedule('testScheduleUpdateTribalFlagToFalseForLead',CRON_EXP, new ScheduleUpdateTribalFlagToFalseForLead());
		Test.stopTest();
	}
	
	// This is the test method for ScheduleUpdateTribalFlagToTrueForLead class
	public static testMethod void testScheduleUpdateTribalFlagToTrueForLead(){
		Test.startTest();
		String jobId = System.schedule('testScheduleUpdateTribalFlagToTrueForLead',CRON_EXP, new ScheduleUpdateTribalFlagToTrueForLead());
		Test.stopTest();
	}
	/** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: F0061      	**/
	/** Date    : 30/06/2011 	**/
	/** Purpose : Created test method testScheduleUpdateCurrentAgeFormBirthdate() for ScheduleUpdateCurrentAgeFormBirthdate class.
	/****************************************************/ 
	public static testMethod void testScheduleUpdateCurrentAgeFormBirthdate(){
		Test.startTest();
		String jobId = System.schedule('testScheduleUpdateCurrentAgeFormBirthdate',CRON_EXP, new ScheduleUpdateCurrentAgeFormBirthdate());
		Test.stopTest();
	}
	
}