/** 
Revision History:
 
*   Version     Version Author     Date         Comments
*   1.0         Manasi Ranade      19-06-2011   EmergencyFundGoal related test class
*/
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
private class BatchInsertDefaultEmergencyFundGoal_Test {
	static Account objAccTest;
	static Id idAccount; 
	static BatchInsertDefaultGlobalAssumption objBatchInsertDefaultGlobalAssumption =new BatchInsertDefaultGlobalAssumption();
	static BatchInsertDefaultEmergencyFundGoal objBatchInsertDefaultEmergencyFundGoal = new BatchInsertDefaultEmergencyFundGoal();
	static List<Goal__c> objGoalList;
	static Id goalId; 
    public static void createMissingEmergencyFundGoalsTestData()
	{	
		objAccTest = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active');
		upsert objAccTest;
		system.assertNotEquals(null,objAccTest.id);
		idAccount = objAccTest.id;
		objGoalList = [SELECT id FROM Goal__c 
	    				WHERE Goal_Type__c =: 'Emergency Fund' 
	    				  	and Entity__c =: objAccTest.id];
		//System.assert(objGoalList.size() == 1);
		delete objGoalList;
        
	}
	 static testMethod void BatchInsertDefaultEmergencyFundGoalTest()
	{	
		createMissingEmergencyFundGoalsTestData();
		Test.startTest();
		objBatchInsertDefaultEmergencyFundGoal.createMissingEmergencyFundGoals();
		objGoalList = [SELECT id FROM Goal__c 
	    				WHERE Goal_Type__c =: 'Emergency Fund' 
	    				  	and Entity__c =: objAccTest.id];
		//System.assert(objGoalList.size() == 1);
		Test.stopTest(); 
	}
}