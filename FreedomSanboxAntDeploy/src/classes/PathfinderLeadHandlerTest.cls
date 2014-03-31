/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 07/10/2013   1. Test class PathfinderLeadHandler
	
*/

public with sharing class PathfinderLeadHandlerTest 
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
    public static TestData_Ffreedom testData;
    
    @isTest
    public static void TestData() 
    {
    	testData = new TestData_Ffreedom();
    	
    	List<User> lstUser = new List<User>();
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
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	insert lstTeam_Member;
    	
    	List<Account> lstVirtualAcc = new List<Account>();
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
	    
	    //system.assertNotEquals(0, [Select Id from Partner_Team_Member_Allocation__c where Partner__c =: lstVirtualAcc[0].Id].size());
    }
    	
    @isTest
    public static void partnerTeamMemberAllocationTest() 
    {
    	TestData();
    	
    	Lead objLead = testData.init_Lead();
    	objLead.Business_Unit__c = objBU1.Id;
    	objLead.Virtual_Partner__c = virtualAcc1.Id;
    	objLead.PST_Team_Member__c = objTM1.Id;
	    insert objLead;
	    
	    Test.startTest();
	    objLead.is_Pathfinder__c = true;
	    update objLead;
	    Test.stopTest();
    	
    }
    
    @isTest
    public static void PathfinderTest() 
    {
    	TestData();
    	
    	Test.startTest();
    	Lead objLead = testData.init_Lead();
    	objLead.Business_Unit__c = objBU1.Id;
    	objLead.Virtual_Partner__c = virtualAcc1.Id;
    	objLead.PST_Team_Member__c = objTM1.Id;
	    objLead.is_Pathfinder__c = true;
	    insert objLead;
	    Test.stopTest();
    	
    }
    
    @isTest
    public static void LeadHandlerTest() 
    {
    	TestData();
    	List<Lead>  lstLead = new List<Lead>();
    	Lead objLead = testData.init_Lead();
    	objLead.Business_Unit__c = objBU1.Id;
    	objLead.Virtual_Partner__c = virtualAcc1.Id;
    	objLead.PST_Team_Member__c = objTM1.Id;
    	lstLead.add(objLead);
	    insert lstLead;
	     
	    Test.startTest();
	 	objLead.Business_Unit__c = objBU2.Id;
    	objLead.Virtual_Partner__c = virtualAcc2.Id;
    	objLead.PST_Team_Member__c = objTM12.Id;
	    update lstLead; 
	    
	    delete  lstLead; 
	    Test.stopTest();
    	
    }
    
}