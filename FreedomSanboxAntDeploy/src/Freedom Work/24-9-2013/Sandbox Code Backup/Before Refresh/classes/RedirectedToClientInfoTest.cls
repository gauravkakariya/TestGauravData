/*
Revision History:

	Version     Version Author     Date        Comments
	1.0         --           	   --	  	   Initial Draft
	2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class RedirectedToClientInfoTest 
{

    static testMethod void myUnitTest() 
    {
         RedirectToClientInfo clientInfo=new RedirectToClientInfo();
         clientInfo.redirectTo();
    }

    static testMethod void myUnitTest1() 
    {
       	Contact con;
    	Account acc;
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	
    	List<User> standardUser = testData.initStandardUser();
	    
	    List<Account> lstAcc = new List<Account>(); 
	    System.runAs(standardUser[0])
	    {
	    	acc = testData.initializeAccount();
		    insert acc;
		   // con = testData.init_Contact(acc);
		    con = new Contact(FirstName='Parner Contact Test', LastName='Contact',AccountId= standardUser[0].ContactId);
		    insert con;
	    }
        
        Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      	insert goalProfile;
      	Goal__c goal = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
    	insert goal;
    	system.assertNotEquals(null,goal.id);
        goal.Goal_End_Year__c='2012';
        goal.Goal_End_Year__c='2017';
        upsert goal;
        
    }
    
    static testMethod void testRunAs() 
    {
        TestData_Ffreedom testData = new TestData_Ffreedom();
        ID ProfileID = [Select id from Profile where name = 'Customer Portal Manager Custom'].id;
        
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = testData.init_Contact(A1);
        insert C1;
 
       
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = profileid, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
		TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
		LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        
        test.startTest();
        
        System.runAs(u1){
        	
        	RedirectToClientInfo rtoClientInfo = new RedirectToClientInfo();
        	rtoClientInfo.redirectTo();
        }
        
        test.stopTest();
        
   }
    	
}