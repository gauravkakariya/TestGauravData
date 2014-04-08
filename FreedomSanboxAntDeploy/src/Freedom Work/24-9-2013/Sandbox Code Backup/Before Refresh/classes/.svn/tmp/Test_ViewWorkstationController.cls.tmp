/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class Test_ViewWorkstationController 
{
	static testMethod void myUnitTest() 
	{
    	Test.startTest();
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	
    	User user = testData.initializeUser();
        insert user;
        
        Workstation__c workstation = testData.init_workstation(user);
	    insert workstation;
	    ApexPages.currentPage().getParameters().put('wid',workstation.id);
        ViewWorkstationController controller = new ViewWorkstationController();
        controller.Wid = workstation.Id;
        controller.Init();
        Pagereference close = controller.close();
        Pagereference createworkstation = controller.CreateWorkstation();
        Pagereference edit = controller.Edit();
        Test.stopTest();
    }
}