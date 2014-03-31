@isTest
private class Test_UpdateAccount4PortalUser {

    static testMethod void TestUpdateAccount() {
         
         ID profileid = [ Select id from Profile where name = 'Customer Portal Standard - Custom'].id;
         Test.startTest();
         Account act = new Account(PersonEmail='tech@ffreedom.in',FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
         insert act;
         
         List<Account> contactIds=[select PersonContactId from Account where FirstName='Test_Parent_Fname' LIMIT 1 ];
		 User u1 = new User( email='test-user@fakeemail.com', contactid = contactIds[0].PersonContactId, profileid = profileid, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
		 insert u1; 
         User newUser= [select Email,Username,FirstName,LastName,Phone,MobilePhone,Fax,Title,Street,City,State,PostalCode from User where Email= 'test-user@fakeemail.com' LIMIT 1];
         System.assertEquals(newUser.FirstName, 'Test_Parent_Fname');
        
         System.runAs(newUser){
         newUser.Email='tech@ffreedom.in';	
         newUser.Phone= '1111111111';
         newUser.FirstName='firstName';
         newUser.LastName='lastName';
         newUser.MobilePhone='2222221111';
         newUser.Fax='333333';
         newUser.Title='Mrs.';
         newUser.Street='someStreet';
         newUser.City='someCity';
         newUser.State='someState';
         newUser.PostalCode='400053';  
         update newUser;
         }
        
       Test.stopTest();
    }
}