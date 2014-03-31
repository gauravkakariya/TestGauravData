/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     25/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class TestUpdateEmailAddressOnRenewal 
{

    static testMethod void testUpdateEmail() 
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
        insert acc;
        Renewal__c renewal = testData.init_Renewal(acc);
        insert renewal;
        //Renewal__c ren = [select email__c,Id from Renewal__c where Entity__c =:acc.Id];
        //System.assertEquals(ren.email__c,acc.PersonEmail);
    }
}