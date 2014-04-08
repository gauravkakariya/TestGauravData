@isTest
 private class TestPortalController
 {     
 		static testMethod void testPortal()
 		{
	 		try
			{
	          String id=  UserInfo.getUserId();
	          Test.startTest();
	          Test.setCurrentPage(Page.Portal_Family);
	          
	          List<Account> ChildEntitiesList=new List<Account>();
	          String addr;
	          
	           Account child = [select Id, Parent_Entity__c from Account where Parent_Entity__c != null and RecordTypeId !=:RecTypes__c.getInstance('General_Business').Record_Type_Value__c LIMIT 1];
	           Account act = [select Id, OwnerId, PersonContactId from Account where Id =:child.Parent_Entity__c and RecordTypeId !=:RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
	          
	           
	           Planner_Details__c planner_Info=new Planner_Details__c(Name='Technology Support',Description__c='Test_Planner_Description', OwnerId= act.OwnerId);
	           insert planner_Info;
	           
	           ID ProfileID = [ Select id from Profile where name = 'Customer Portal Standard - Custom'].id;
	           List<User> u1 = [select Id from User where contactid = :act.PersonContactId and isActive = true];
				User user;
				if(u1 == null || u1.isEmpty()){
					user = new User( email='test-user@fakeemail.com', contactid = act.PersonContactId, profileid = ProfileID, UserName='test-user@fakeemail.com', 
							alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
					
						insert user;
				}
				else{
					user= u1[0];
				}
				
			   AccountShare share1 = new AccountShare(UserOrGroupId=user.Id,AccountId=child.Id,AccountAccessLevel='Read',OpportunityAccessLevel = 'Edit');
			   insert share1; 
			   
			   System.runAs(user)
			   {
				   PortalController controller_Obj = new PortalController();
				   User u2 = controller_Obj.getCurrentUserDetails();
				   System.assertEquals(u2.AccountId, act.Id);
				   
			       Account testAcc=controller_Obj.getAccount();
			       System.assertNotEquals(testAcc, null);
			         
			       ChildEntitiesList= controller_Obj.getChildEntities();
			       	 
			        
			     //  User user= controller_Obj.getUserDetails();
		           Planner_Details__c plannerDetails=controller_Obj.getPlannerDescription();
		           String pic=plannerDetails.Name +'.jpg';
	               System.assertEquals(controller_Obj.getPlannerPic(),pic.replace(' ',''));
	               
			   }
	           Test.stopTest();
	 	 	}
	 	 	catch(Exception e)
	 		{
	 			system.debug('**e****'+e);
	 		}
 		}
 }