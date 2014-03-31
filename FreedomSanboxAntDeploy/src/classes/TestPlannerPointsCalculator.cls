/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestPlannerPointsCalculator {
	
    static testMethod void testPlanCalculator() {
        Test.startTest();
        Test.setCurrentPage(Page.PlannerPointsCalculator);
        
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Management'];
        UserRole ur = [select Id, Name from UserRole where Name = 'Sr.Mgr.FP - GALAXY'];
        
        User user = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      			LocaleSidKey='en_US', ProfileId = objProfile.Id,TimeZoneSidKey='America/Los_Angeles', 
      			UserName='standarduser@testorgabc.com',UserRoleId = ur.Id);
        insert user;
        User u = [select Id from User where Id = :user.Id ];
        System.runas(u){
        	PlannersPointCalculator pl = new PlannersPointCalculator();
	        pl.setStartDate('08/01/2010');
	        pl.setEndDate('12/30/2010');
	        System.assertEquals('08/01/2010', pl.getStartDate());
	        System.assertEquals('12/30/2010', pl.getEndDate());
	        pl.getPlannerRoles();
        	pl.calculatePoints();
        	System.assertEquals(5.0, pl.getMonthsInBetween());
        }
        
        //UserRole ur1 = [select Id, Name from UserRole where Name = 'Fps[AMETHYST MUMBAI]'];
        User u1 = [select Id from User where Id = :user.Id ];
        System.runas(u1){
        	PlannersPointCalculator pl = new PlannersPointCalculator();
	        pl.setStartDate('08/01/2010');
	        pl.setEndDate('12/30/2010');
	        System.assertEquals('08/01/2010', pl.getStartDate());
	        System.assertEquals('12/30/2010', pl.getEndDate());
	        pl.getPlannerRoles();
        	pl.calculatePoints();
        	System.assertEquals(5.0, pl.getMonthsInBetween());
        }
        PlannersPointCalculator pl = new PlannersPointCalculator();
	        pl.setStartDate('08/01/2010');
	        pl.setEndDate('12/30/2010');
	        System.assertEquals('08/01/2010', pl.getStartDate());
	        System.assertEquals('12/30/2010', pl.getEndDate());
	        pl.getPlannerRoles();
        	pl.calculatePoints();
        	System.assertEquals(5.0, pl.getMonthsInBetween());
        
        Test.stopTest();
    }
}