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
private class UpdateExecutionTrackerTriggerTest {

    static testMethod void testETUpdatee() {
    	Account objAcc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',
                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband',RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); // Gaurav
                      //RecordTypeId=  '01220000000DnK3AAK');
		insert objAcc;                       
        Execution_Tracker__c objET = new Execution_Tracker__c(Entity_Name__c = objAcc.Id,Opportunity_Name__c = 'LumpSum',Suggested_Action_Amount__c=100);
        insert objET;
        objET.Actual_Action_Amount__c = 1;
        objET.Completion_Date__c = Date.today();
        update objET;
        try
        {
	        objET.Actual_Action_Amount__c = 2;
	        update objET;
	        //throw new GeneralException('You cannot Change this record as its Completion Date is already'); 
        }
        catch(Exception e)
		{
			Boolean expectedExceptionThrown = ( e.getMessage().contains(Label.CantChangeCompletionDateOneItIsFilled)) ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
		} 
    }
}