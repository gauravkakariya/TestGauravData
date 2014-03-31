/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     24/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class TestValidateWorkstation 
{

	static testMethod void TestWorkstationforValidation()
    {
		Test.StartTest();
	    User user;
	    TestData_Ffreedom testData = new TestData_Ffreedom();
	    user = testData.initializeUser();
	    insert user;
	    
	    Workstation__c workstation = new Workstation__c();
	    workstation = testData.init_workstation(user);
		insert workstation;
		
		List<Workstation__c> lstTestWorkstation = new List<Workstation__c>();
		lstTestWorkstation.add(workstation);
		
		ValidateWorkstation validateTest = new ValidateWorkstation();
		validateTest.PopulateAllMaps();
		validateTest.UpdateCurrentMap(lstTestWorkstation);
		validateTest.validateAllWorkstations(workstation);
		Test.stopTest();
	}
}