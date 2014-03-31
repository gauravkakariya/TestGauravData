public with sharing class HandlerForBeforeUpdateOnUser 
{
	public void beforeUpdateUser(List<User> lstNewUser, List<User> lstOldUser)
	{
		for(User objNewUser : lstNewUser)
		{
			for(User objOldUser : lstOldUser)
		    {
			   if(objOldUser.From_Portal__c == 1 && objNewUser.Synched_Date_Time__c >= objOldUser.LastModifiedDate )
			   {
				  objNewUser.From_Portal__c = 0;
				  objNewUser.IsSynched__c = true;
			   }
			   else if(objOldUser.From_Portal__c == 1 && objNewUser.Synched_Date_Time__c < objOldUser.LastModifiedDate )
			   {
				  objNewUser.From_Portal__c = 0;
				   objNewUser.IsSynched__c = false;  
			   }
			   else if(objNewUser.From_Portal__c == 0)
			   {
			   	 objNewUser.IsSynched__c = false;
			   }
			   
			   }
			
		   }
	}

		@IsTest(seealldata = true) 
	      public static void testCoverage1() 
	      { 
	      	
	      	  ID ProfileID = [ Select Id from Profile where Name = 'System Administrator'][0].id;	
	      		
	          User objUser = new User();
	          objUser.email='test-user@email.com';
	          objUser.UserName='test-user@email.com'; 
	          objUser.FirstName = 'Test';
	          objUser.LastName  = 'Test1';
	          objUser.profileid = profileid;
	          objUser.alias='tuser1';
	          objUser.CommunityNickName='tuser1';
	          objUser.TimeZoneSidKey='America/New_York';
	          objUser.From_Portal__c = 0;
	          objUser.LocaleSidKey='en_US';
	          objUser.IsSynched__c = true;
	          objUser.EmailEncodingKey='ISO-8859-1';
	         objUser.LanguageLocaleKey='en_US';
	          objUser.Portal_Id__c = '6';
	          objUser.LanguageLocaleKey='en_US';
	          
	          
	          User objUser1 = new User();
	          objUser1.email='test-user1234@email.com';
	          objUser1.UserName='test-user1234@email.com'; 
	          objUser1.FirstName = 'Test2';
	          objUser1.LastName  = 'Test3';
	          objUser1.profileid = profileid;
	          objUser1.alias='tuser12';
	          objUser1.CommunityNickName='tuser12';
	          objUser1.TimeZoneSidKey='America/New_York';
	          objUser1.From_Portal__c = 1;
	          objUser1.Synched_Date_Time__c = system.now(); 
	          objUser1.LocaleSidKey='en_US';
	          objUser1.IsSynched__c = true;
	          objUser1.EmailEncodingKey='ISO-8859-1';
	         objUser1.LanguageLocaleKey='en_US';
	          objUser1.Portal_Id__c = '6';
	          objUser1.LanguageLocaleKey='en_US';
	          
	          
	          test.startTest();
	              insert objUser;
	              objUser.LastName  = 'Test2';
	              update objUser;
	              insert objUser1;
	              objUser1.LastName  = 'Test3';
	              update objUser1;
	          test.stopTest();
	       }
}