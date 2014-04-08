/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/


@isTest
private class TestWorkstationExtension {

    static testMethod void TestmethodforWorkstationExtension()
    {
        Test.StartTest();
	    
	    TestData_Ffreedom testData = new TestData_Ffreedom();
		User user = testData.initializeUser();
	    insert user;
	    
	    Workstation__c workstation = testData.init_workstation(user);
		insert workstation;
		
		ApexPages.StandardController sc =  new ApexPages.StandardController(workstation);
		WorkstationExtension objworkstationExtension = new WorkstationExtension(sc); 
		objworkstationExtension.Save();
		objworkstationExtension.Cancel();
		 Test.stopTest();
	}
}