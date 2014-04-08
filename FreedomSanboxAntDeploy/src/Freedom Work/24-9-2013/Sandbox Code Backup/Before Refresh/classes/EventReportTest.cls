@isTest
private class EventReportTest {
	/*Test Method start*/
	static testMethod void EventTrackingReport()
	{
		Test.startTest();
		datetime dtRangeDate = datetime.newInstance(2008, 12, 1);
		EventReport objEventReport = new EventReport();
		objEventReport.objEvent.StartDateTime = dtRangeDate;
		objEventReport.objEvent.EndDateTime = Datetime.now();
		objEventReport.Init();
		Test.stopTest();
	}
	static testMethod void testInit() 
    {
		test.startTest();
		
		 UserRole ur = [select Id, Name from UserRole where Name = 'Sr.Mgr.FP - GALAXY'];
		 ID ProfileID = [ Select id from Profile where name = 'System Administrator'].id;
		 User objuser = new User( email='test-user@fakeemail.com',profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1'
		 					, CommunityNickName='tuser1',TimeZoneSidKey='America/New_York'
		 					, LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US'
		 					, FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname', UserRoleId = ur.Id);
         insert objuser;
         system.runAs(objuser)
         {
         	
         	List<User_Role_Name__c> lstDetail=new List<User_Role_Name__c>();
         	User_Role_Name__c detail=new User_Role_Name__c(Name=ur.Name);
         	lstDetail.add(detail);
         	insert lstDetail;
         	
         	List<Detail_Role__c> lstDetailRoles = new List<Detail_Role__c> ();
         	 Detail_Role__c detailRole=new Detail_Role__c(Name='abc',Master_Role__c = detail.id );
         	 lstDetailRoles.add(detailRole);
         	 insert lstDetailRoles;
         		 Account objAccount = new Account(FirstName='Fname2',LastName='Lname2');
	        insert objAccount;
	     
         	 List<Event> objEvent= new List<Event>(); 
			Event testEvent = new Event(Event_Category__c='Meeting'
										,Event_Place__c='Test Place',Description='test'
										,Event_Status__c ='Complete',Completion_Date__c = System.Today()
										,Subject = 'Meeting',StartDateTime = System.now()
										,EndDateTime = System.now().addMinutes(30),WhatId = objAccount.Id
										,OwnerId = objuser.Id);
			objEvent.add(testEvent);
			Event testEvent1 = new Event(Event_Category__c='Meeting',Event_Place__c='Test Place',Description='test',Event_Status__c ='Complete',Completion_Date__c = System.Today(), OwnerId =objuser.Id, Subject = 'Meeting',StartDateTime = System.now(),EndDateTime = System.now().addMinutes(30),WhatId = objAccount.Id);
			objEvent.add(testEvent1);
			insert objEvent;
			
			EventReport objEventReport = new EventReport();
         	objEventReport.nameofUser = objuser.id;
		  
			List<SelectOption> lstSelectopt = objEventReport.getAllUsers();
			objEventReport.nameofUser = objuser.id;
			objEventReport.AssignManager();
			objEventReport.init();
			
			
			objEventReport.ViewAll();
        }
		test.stopTest();
    }
}