/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     24/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/


@isTest
private class TestUpdateTempEmail 
{
    static testMethod void TestUpdateTempEmail() 
    {
        Test.startTest();
        TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
        insert acc;
        acc.Email_Temp__c = 'abc@ffreedom.in';
        
        acc.PersonEmail='abc@ffreedom.in';
        System.assertEquals(acc.Email_Temp__c, acc.PersonEmail);
        update acc;
        
        Test.stopTest();
    }
}