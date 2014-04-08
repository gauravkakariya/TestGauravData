/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     24/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class TestGenerateActionPlanAsHTML 
{

    static testMethod void TestGenerateActionPlan() 
    {
        Test.StartTest();
        TestData_Ffreedom testData = new TestData_Ffreedom();
		
        User user, user1;
        
        ID FPID = [ Select id from Profile where name = 'Financial Planner(Limited Access)'].id;
        ID SAID = [ select id from profile where name = 'System Administrator'].id;
        user = new User( Email='test-FP@fakeemail.com', profileid = FPID, userName='test-FP@fakeemail.com', Alias='Fuser1', CommunityNickname='Fuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'FP_Parent_Fname', LastName = 'FP_Parent_Lname', MobilePhone='55555');
        insert user;
        user1 = new User( Email='test-Admin@fakeemail.com', profileid = SAID, userName='test-Admin@fakeemail.com', Alias='Auser1', CommunityNickname='Auser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Admin_Parent_Fname', LastName = 'SA_Parent_Lname', MobilePhone='55555');
        insert user1;
        
        Account objacc = testData.initializeAccount();
        Database.Saveresult oSaveResult = Database.insert(objacc);
        Apexpages.currentPage().getParameters().put('entityId',oSaveResult.getId());
        GenerateActionPlanAsHTML Gplan= new GenerateActionPlanAsHTML();
        Gplan.Save();
        Gplan.sendEmail();
        Gplan.selectAccount();
        Gplan.sendEmail();
        Test.stopTest();
    }
}