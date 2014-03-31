/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 01/10/2013   1. Test class Handler to trigger the Approval process for account
	
*/

public with sharing class AccountApprovalSubmitHandlerTest 
{
    public static User objUser1;
    public static User objUser2;
    public static Business_Unit__c objBU1;
    public static Business_Unit__c objBU2;
    public static Department__c objDept1;
    public static Department__c objDept2;
    public static Department__c objDept3;
    public static Department__c objDept4;
    
    public static Team_Member__c objTM1;
    public static Team_Member__c objTM2;
    public static Team_Member__c objTM3;
    public static Team_Member__c objTM4;
    public static Team_Member__c objTM11;
    public static Team_Member__c objTM21;
    public static Team_Member__c objTM31;
    public static Team_Member__c objTM41;
    
    public static Department__c objDept12;
    public static Department__c objDept22;
    public static Department__c objDept32;
    public static Department__c objDept42;
    public static Team_Member__c objTM12;
    public static Team_Member__c objTM22;
    public static Team_Member__c objTM32;
    public static Team_Member__c objTM42;
    public static Account virtualAcc1;
    public static Account virtualAcc2;
    public static Account objAccount;
    public static TestData_Ffreedom testData;
    public static List<Account> lstVirtualAcc;
    public static Map<Id,Account> mapIdToOldPartnerAcc;
    public static Map<Id,Account> mapIdToNewPartnerAcc;
    
    @isTest
    public static void TestData() 
    {
    	testData = new TestData_Ffreedom();
    	
    	List<User> lstUser = new List<User>();
    	mapIdToOldPartnerAcc = new Map<Id,Account>();
    	objUser1 = testData.initializeUser();
    	lstUser.add(objUser1);
    	//insert objUser1;
    	objUser2 = testData.initializeUser();
    	objUser2.UserName ='test-user@fakeemail.com';
    	objUser2.FirstName = 'Test_Parent_Fname2';
    	objUser2.LastName = 'Test_Parent_Lname3';
    	objUser2.CommunityNickname = 'tuser2';
    	objUser2.Alias = 'tuser12';
    	objUser2.email ='usertest-user@fakeemail1.com';
    	lstUser.add(objUser2);
    	insert lstUser;
    	
    	List<Business_Unit__c> lstBU = new List<Business_Unit__c>();
    	objBU1 = testData.init_Business_Unit('BU1');
    	lstBU.add(objBU1);
    	//insert objBU1;
    	objBU2 = testData.init_Business_Unit('BU2');
    	lstBU.add(objBU2);
    	insert lstBU;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	objDept1 = testData.init_Department('PST', objBU1.Id);
    	objDept2 = testData.init_Department('MST', objBU1.Id);
    	objDept3 = testData.init_Department('FPA', objBU1.Id);
    	objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	objTM11 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	objTM21 = testData.init_Team_Member(objUser2.Id, objDept2.Id);
    	objTM31 = testData.init_Team_Member(objUser2.Id, objDept3.Id);
    	objTM41 = testData.init_Team_Member(objUser2.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	lstTeam_Member.add(objTM11);
    	lstTeam_Member.add(objTM21);
    	lstTeam_Member.add(objTM31);
    	lstTeam_Member.add(objTM41);
    	insert lstTeam_Member;
    	
    	lstVirtualAcc = new List<Account>();
    	virtualAcc1 = testData.initVirtualAccount();
    	virtualAcc1.Business_Unit__c = objBU1.Id;
    	virtualAcc1.PST_Team_Member__c = objTM1.Id;
    	virtualAcc1.MST_Team_Member__c = objTM2.Id;
    	virtualAcc1.FPA_Team_Member__c = objTM3.Id;
    	virtualAcc1.OPS_Team_Member__c = objTM4.Id;
    	lstVirtualAcc.add(virtualAcc1);
    	
    	//------------------------------------------------------------------
    	
    	List<Department__c> lstDepartment2 = new List<Department__c>();
    	objDept12 = testData.init_Department('PST', objBU2.Id);
    	objDept22 = testData.init_Department('MST', objBU2.Id);
    	objDept32 = testData.init_Department('FPA', objBU2.Id);
    	objDept42 = testData.init_Department('MST2 (Operations)', objBU2.Id);
    	
    	lstDepartment2.add(objDept12);
    	lstDepartment2.add(objDept22);
    	lstDepartment2.add(objDept32);
    	lstDepartment2.add(objDept42);
    	insert lstDepartment2;
    	
    	List<Team_Member__c> lstTeam_Member2 = new List<Team_Member__c>();
    	objTM12 = testData.init_Team_Member(objUser1.Id, objDept12.Id);
    	objTM22 = testData.init_Team_Member(objUser1.Id, objDept22.Id);
    	objTM32 = testData.init_Team_Member(objUser1.Id, objDept32.Id);
    	objTM42 = testData.init_Team_Member(objUser1.Id, objDept42.Id);
    	
    	lstTeam_Member2.add(objTM12);
    	lstTeam_Member2.add(objTM22);
    	lstTeam_Member2.add(objTM32);
    	lstTeam_Member2.add(objTM42);
    	insert lstTeam_Member2;
    	
    	virtualAcc2 = testData.initVirtualAccount();
    	virtualAcc2.Business_Unit__c = objBU2.Id;
    	virtualAcc2.PST_Team_Member__c = objTM12.Id;
    	virtualAcc2.MST_Team_Member__c = objTM22.Id;
    	virtualAcc2.FPA_Team_Member__c = objTM32.Id;
    	virtualAcc2.OPS_Team_Member__c = objTM42.Id;
    	lstVirtualAcc.add(virtualAcc2);
    	insert lstVirtualAcc;
    	mapIdToOldPartnerAcc.put(lstVirtualAcc[0].Id,lstVirtualAcc[0]);
    	mapIdToOldPartnerAcc.put(lstVirtualAcc[1].Id,lstVirtualAcc[1]);
    	
    
    	objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
    	objAccount.OwnerId = objUser1.Id;
	    insert objAccount;
    }
    
   /* @isTest
    public static void approvalSubmitTest() 
    {
    	TestData();
    	Test.startTest();
	    objAccount.PST_Team_Member__c = objTM12.Id;
	    update objAccount;
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(objAccount.Id);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        // Verify the result
        System.assert(result.isSuccess());
    	System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
	    
	    Test.stopTest();
    }
    */
    @isTest
    public static void businessUnitTest() 
    {
    	TestData();
    	
	    Test.startTest();
	    objAccount.Business_Unit__c = objBU2.Id;
	    objAccount.Virtual_Partner__c = virtualAcc2.Id;
	    objAccount.PST_Team_Member__c = objTM12.Id;
    	objAccount.MST_Team_Member__c = objTM22.Id;
    	objAccount.FPA_Team_Member__c = objTM32.Id;
    	objAccount.OPS_Team_Member__c = objTM42.Id;
	    update objAccount;
	    Test.stopTest();
    }
    
    @isTest
    public static void setEntityStatusAsPathfinderTest()
    {
    	TestData();
    	
	    Test.startTest();
	    objAccount.Is_Pathfinder__c = true;
	    update objAccount;
	    Test.stopTest();
	    
	    system.assertNotEquals('Member', objAccount.Category__c);
    }
    
    @isTest
    public static void changeTeamMembersPartnerwiseTest()
    {
    	TestData();
    	Test.startTest();
    	mapIdToNewPartnerAcc = new Map<Id,Account>();
    	/*virtualAcc1.Business_Unit__c = objBU1.Id;
    	virtualAcc1.PST_Team_Member__c = objTM1.Id;
    	virtualAcc1.MST_Team_Member__c = objTM2.Id;
    	virtualAcc1.FPA_Team_Member__c = objTM3.Id;
    	virtualAcc1.OPS_Team_Member__c = objTM4.Id;
    	system.debug('-------virtualAcc1----after------'+virtualAcc1);
	    update virtualAcc1;
    	mapIdToOldPartnerAcc.put(virtualAcc1.Id,virtualAcc1);*/
    	lstVirtualAcc[0].Business_Unit__c = objBU1.Id;
    	lstVirtualAcc[0].PST_Team_Member__c = objTM11.Id;
    	lstVirtualAcc[0].MST_Team_Member__c = objTM21.Id;
    	lstVirtualAcc[0].FPA_Team_Member__c = objTM31.Id;
    	lstVirtualAcc[0].OPS_Team_Member__c = objTM41.Id;
	    //update lstVirtualAcc[0];
		system.debug('-------lstVirtualAcc[0----------'+lstVirtualAcc[0]);
	    mapIdToNewPartnerAcc.put(lstVirtualAcc[0].Id,lstVirtualAcc[0]);
    	AccountApprovalSubmitHandler.changeTeamMembersPartnerwise(lstVirtualAcc, mapIdToOldPartnerAcc, mapIdToNewPartnerAcc);
    	
	    Test.stopTest();
	    
	    system.assertNotEquals(objAccount.PST_Team_Member__c, virtualAcc1.PST_Team_Member__c);
    }
    
    @isTest
    public static void assignTeamMemberToFamily()
    {
    	TestData();
    	Test.startTest();
    	Account objAcc = testData.init_FamilyMember(objAccount);
    	//objAcc.Business_Unit__c = objBU1.Id;
    	//objAcc.Virtual_Partner__c = virtualAcc1.Id;
	    insert objAcc;
	    //objAcc.PST_Team_Member__c = objTM11.Id;
	    //objAcc.MST_Team_Member__c = objTM21.Id;
	    //lstAccounts.add(objAcc);
	    objAccount.OwnerId = objUser2.Id;
	    objAccount.PST_Team_Member__c = objTM11.Id;
	    objAccount.MST_Team_Member__c = objTM21.Id;
	    update objAccount;
	    
	    objAcc.PST_Team_Member__c = objTM1.Id;
	    update objAcc;
	    Test.stopTest();
    }
    
    @isTest
    public static void partnerTeamMemberAllocationTest() 
    {
    	TestData();
    	
    	Team_Member__c objTM111 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	
    	Test.startTest();
	    virtualAcc1.PST_Team_Member__c = objTM111.Id;
	    //update virtualAcc1;
	    Test.stopTest();
    	
    }
    
    @isTest
    public static void partnerTeamMemberDeletionTest() 
    {
    	TestData();
    	Team_Member__c objTM111 = testData.init_Team_Member(objUser2.Id, objDept1.Id);
    	Test.startTest();
	    objAccount.PST_Team_Member__c = objTM111.Id;
	    delete objAccount;
	    Test.stopTest();
    	
    }
    
    @isTest
    public static void assignTeamMemberTest() 
    {
    	TestData();
    	
    	Account objAcc = testData.initializeAccount();
    	objAcc.Business_Unit__c = objBU1.Id;
    	objAcc.Virtual_Partner__c = virtualAcc1.Id;
    	objAcc.PAN_ID__pc = 'ABDCF3456D';
    	
    	Test.startTest();
    	insert objAcc;
    	Test.stopTest();
    	
    	system.assertNotEquals(objTM1.Id, objAcc.PST_Team_Member__c);
    }
    
    @isTest
    public static void entityAllocationCountTest() 
    {
    	TestData();
    	
    	Account objAcc = testData.initializeAccount();
    	objAcc.Business_Unit__c = objBU1.Id;
    	objAcc.Virtual_Partner__c = virtualAcc1.Id;
    	objAcc.PAN_ID__pc = 'ABDCF3456D';
    	
    	Test.startTest();
    	insert objAcc;
    	Test.stopTest();
    	
    	system.assertNotEquals(2, objTM1.Entity_Allocation_Count__c);
    }
    
    
    @isTest
    public static void accountSharingTest() 
    {
    	TestData();
    	
    	//Account objAcc = testData.initializeAccount();
    	AccountShare share = new AccountShare(UserOrGroupId = objUser2.Id, OpportunityAccessLevel = 'Read', 
    											CaseAccessLevel='Read', AccountId=objAccount.Id, AccountAccessLevel='Edit');
    	Test.startTest();
    	insert share;
    	Test.stopTest();										
    }
    
    @isTest
    public static void assignTeamMemberOnChangeOfPOTest() 
    {
    	Test.startTest();
    	TestData();
    	objAccount.PST_Team_Member__c = objTM11.Id;
    	update objAccount;
    	List<Event_Master__c> lstEM = [Select e.Task_Event_Master__c, e.Name, e.Event_Id__c, e.Escalation_Event_Master__c 
        									From Event_Master__c e
        									where isActive__c = true and Name =: Label.PST_Team_Member_Change limit 1];
        //insert lstEM;									
    	
    	Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
        objNotificationQueue.Partner_Id__c = virtualAcc1.Id;
        objNotificationQueue.Member_Id__c = objAccount.Id;
        objNotificationQueue.Event__c = lstEM[0].Id;
        objNotificationQueue.Channel_Type__c = 'Email';
    	insert objNotificationQueue;
    	Test.stopTest();
    	
    	//system.assertNotEquals(objAccount.PST_Team_Member__c,virtualAcc1.PST_Team_Member__c);
    }
    
    @isTest
    public static void assignTeamMemberIfBlankTest() 
    {
    	TestData();
    	
    	objAccount.PST_Team_Member__c = null;
    	Test.startTest();
    	update objAccount;
    	Test.stopTest();
    	
    	system.assertNotEquals(objAccount.PST_Team_Member__c,virtualAcc1.PST_Team_Member__c);
    }
     @isTest
    public static void changeOwnerasPSTMemberTest() 
    {
    	TestData();
    	
    	virtualAcc1.Business_Unit__c = objBU1.Id;
    	virtualAcc1.OwnerId = objUser2.Id;
    	virtualAcc1.PST_Team_Member__c = objTM11.Id;
    	Test.startTest();
    	update virtualAcc1;
    	Test.stopTest();
    	
    	//system.assertEquals(objAccount.PST_Team_Member__c,objAccount.Id);
    }
    
    @isTest
    public static void chatterPostFirstNameTest()
    {
    	TestData();
    	Test.startTest();
    	virtualAcc1.Email_ID__c = 'a@gmail.com';
    	update virtualAcc1;
    	objAccount.FirstName = null;
    	objAccount.PST_Team_Member__c = objTM11.Id;
    	objAccount.MST_Team_Member__c = objTM21.Id;
    	objAccount.FPA_Team_Member__c = objTM31.Id;
    	objAccount.OPS_Team_Member__c = objTM41.Id;
    	update objAccount;
    	
	    Test.stopTest();
    }
   
    @isTest
    public static void chatterPostNewAccTest()
    {
    	TestData();
    	
    	Test.startTest();
    	objAccount.PST_Team_Member__c = null;
    	objAccount.MST_Team_Member__c = null;
    	objAccount.FPA_Team_Member__c = null;
    	objAccount.OPS_Team_Member__c = null;
    	update objAccount;
    	objAccount.PST_Team_Member__c = objTM11.Id;
    	objAccount.MST_Team_Member__c = objTM21.Id;
    	objAccount.FPA_Team_Member__c = objTM31.Id;
    	objAccount.OPS_Team_Member__c = objTM41.Id;
    	update objAccount;
    	
	    Test.stopTest();
    }
    
}