public class TestBatchForRenewalProcess 
{ 
	
	@isTest(SeeAllData = true)
    static void BatchForRenewalProcessTest()
    {
      
      ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
      system.debug('*******ProfileID*****'+ProfileID);
      List<User> lstUser = new List<User>();
      User user1,user2,user;
      
      user1 = new User( email='test-user@TLemail.com', profileid = ProfileID, UserName='test-user@feemail.com', alias='tuser1', CommunityNickName='tuser3',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Y_Fname', LastName = 'ManagerLname' );
      lstUser.add(user1);
        
      user2 = new User( email='test-user@TLemail.com', profileid = ProfileID, UserName='test-user@email.com', alias='tuser1', CommunityNickName='tuser2',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Z_Fname', LastName = 'MemberEngagementLname' );
      lstUser.add(user2);
      
	  user = new User( email='test-user@fakeemail.com', profileid = ProfileID,ManagerId=user1.Id , UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
      lstUser.add(user);
      insert lstUser;
      
      Workstation__c objWorkstation = new Workstation__c();
      objWorkstation.Financial_Planner__c = user.Id;
      objWorkstation.Manager__c = user1.Id;
      objWorkstation.Member_Engagement__c = user2.Id;
      insert objWorkstation;
      
      
      Account acc1 = new Account();
      acc1.LastName ='Test';
      acc1.FirstName='Test';
      acc1.Age__c=22;
       // Commented on 01Mar 2012 : because Cheque_Received_Date__c will be removed from Account object 
      //acc1.Cheque_Received_Date__c = Date.newInstance(2010, 12, 1);
      acc1.Entity_Status__c = 'Active';
      system.debug('*****User Id*******'+user.Id);
      acc1.OwnerId = user.Id;
      acc1.PersonEmail  = 'test.test@eternussolutions.com';
      acc1.PersonMobilePhone = '1223131100';
      insert acc1;
      String strNewOrderNumber = 'FFP/' + String.valueOf(System.today().year()).substring(2, 4) + '-' + 
                                         String.valueOf(System.today().year() + 1).substring(2, 4) + '/001' ; 
                                           
	   Order_Detail__c objOrderDetail = new Order_Detail__c(Order_Number__c = strNewOrderNumber, Account__c = acc1.Id );
       insert objOrderDetail;
        
      //Account account = [select Id,LastName from Account where LastName='Test_Renewal_Lname1'];
      Cheque_Details__c objchq = new Cheque_Details__c(Account__c = acc1.Id, Installment__c = '1st',
      								Cheque_Date__c = Date.today(),Cheque_No__c = 'Ch0012',Amount_Received__c = 1200,
      								Order_Detail__c = objOrderDetail.Id,Cheque_Status__c = 'Deposited');
      insert objchq;
        
      Id idaccount =user.Id;
      Renewal__c ren1 = new Renewal__c();
      ren1.Cheque_Received_Date__c = Date.newInstance(2011, 12, 1);
      ren1.Has_Opted_for_Renewal__c = 'Yes';
      //ren1.IsCompleted__c = false;
      ren1.Entity__c = acc1.Id; 
      ren1.Renewal_Date__c = Date.newInstance(2011, 12, 20);
      insert ren1;
      
      //Commented on 01Mar 2012 : because Cheque_Received_Date__c will be removed from Account object 
      //Account acc = new Account(FirstName='Test_Fname1',LastName='Test_Renewal_Lname1',Cheque_Received_Date__c= Date.newInstance(2010, 12, 1),PersonMobilePhone='9876543210',PersonEmail='tech@ffreedom.in',Entity_Status__c='Active',OwnerId = idaccount);
      //Account acc = new Account(FirstName='Test_Fname1',LastName='Test_Renewal_Lname1',PersonMobilePhone='9876543210',PersonEmail='tech@ffreedom.in',Entity_Status__c='Active',OwnerId = idaccount);
      //insert acc;
        
      //Cheque_Details__c objchq1 = new Cheque_Details__c(Account__c = acc.Id, Installment__c = '1st',Cheque_Date__c = Date.today(),Cheque_No__c = 'Ch0013',Amount_Received__c = 1200,Cheque_Status__c = 'Deposited');
      //insert objchq1;
        
      //Renewal__c renewal = new Renewal__c();
      //renewal.Entity__c = acc.Id; 
      //renewal.Renewal_Date__c = Date.newInstance(2011, 12, 1);
      //upsert renewal;
        
      //Renewal__c renewal2 = new Renewal__c();
      //renewal2.Entity__c = acc.Id; 
      //renewal2.Renewal_Date__c = Date.newInstance(2011, 12, 1);
      // upsert renewal2;
        
      /*  Execution_Tracker__c objExecution = new Execution_Tracker__c();
        objExecution.Entity_Name__c =acc1.Id;
        objExecution.Opportunity_Name__c = 'SIP';
        objExecution.Completion_Date__c =Date.newInstance(2010, 12, 1); 
        insert  objExecution; 
        */
      Execution_Tracker__c objExecution1 = new Execution_Tracker__c();
      objExecution1.Entity_Name__c =acc1.Id;
      objExecution1.Opportunity_Name__c = 'SIP';
      objExecution1.Completion_Date__c =Date.newInstance(2010, 12, 1); 
      insert  objExecution1;
      
      String []lstCCAddress = new String[]{'tech@ffreedom.in'};
      Id templateId = [ Select e.Name, e.Id From EmailTemplate e where Name = 'Renewal Template With Atleast One Execution'].Id;
      Renewal__c objRenewal = [Select id ,Entity__c,Entity_Name__c,Mobile__c From Renewal__c where id =:ren1.Id];
      
      Account acct= [Select Id, PersonContactId from Account where Id =:acc1.Id]; 
      BatchForRenewalProcess objBatch = new BatchForRenewalProcess();
      objBatch.query = 'Select r.Id,r.Renewal_SMS_Sent__c, r.IsCompleted__c,r.Renewal_Date__c ,r.Entity_Name__c,r.Mobile__c,r.Has_Opted_for_Renewal__c, r.Expected_Amount__c, r.Entity__r.Entity_Status__c, r.Entity__r.OwnerId, r.Entity__c, r.Discount__c, r.Discontinuation_SMS_Sent__c, r.CreatedDate, r.Cheque_Received_Date__c,r.Entity__r.Email_Temp__c, r.Entity__r.PersonEmail,r.Entity__r.PersonContactId ' +
            'FROM Renewal__c r where Id=\'' + ren1.Id +'\''+' limit 2';
      Test.startTest();
      objBatch.todaysDate = Date.newInstance(2011,11,20);
      database.executebatch(objBatch);
      objBatch.todaysDate = Date.newInstance(2011,12,5);
      database.executebatch(objBatch);
      Task objTask =  objBatch.createMultipleTask(acc1.OwnerId,objRenewal);
      objBatch.sendEmailFunctionality(lstCCAddress, templateId, acct.PersonContactId);
      Test.stopTest();
    }
}