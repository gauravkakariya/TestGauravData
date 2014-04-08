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
private class TestBatchPointCalculator {
        // TO DO: implement unit test
     static testMethod void testBatchPointsCalculator() { 
    	
        Test.startTest();
    	List<User> lstUser = [Select u.IsActive,u.Name, u.Id From User u Where u.IsActive = True and u.Profile.Name = 'System Administrator'];
		
		Account objAccount = new Account(LastName = 'Test Account');
		insert objAccount;
    	Database.Batchablecontext BC;
    	Planner_Points__c objPlannerPoint = new Planner_Points__c(Month__c = System.today());
    	insert objPlannerPoint;
    	Related_Entity_Points__c objRelatedEntityPoint = new Related_Entity_Points__c(Entity_Name__c = objAccount.Id, Planner_Points__c = objPlannerPoint.Id);
    	insert objRelatedEntityPoint;
    	BatchPointsCalculator objBatchPointsCalculator = new BatchPointsCalculator();
    	objBatchPointsCalculator.setParentId.add(objPlannerPoint.Id);
    	objBatchPointsCalculator.query='SELECT ID, Name  FROM User';
    	Database.executeBatch(objBatchPointsCalculator,1);
    	objBatchPointsCalculator.execute(BC, lstUser);
    	objBatchPointsCalculator.finish(BC);
    	Test.stopTest();
	}
	
}