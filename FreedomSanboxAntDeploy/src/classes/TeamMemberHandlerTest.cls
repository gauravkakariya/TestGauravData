/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 01/10/2013   1. Test class TeamMemberHandler
	
*/

public with sharing class TeamMemberHandlerTest 
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
    public static Account virtualAcc1;
    public static TestData_Ffreedom testData;
    public static Partner_Team_Member_Allocation__c objPTMA;
    public static Account objAccount;
    
    @isTest
    public static void TestData() 
    {
    	testData = new TestData_Ffreedom();
    	
    	objUser1 = testData.initializeUser();
    	insert objUser1;
    	objUser2 = testData.initializeUser();
    	objUser2.UserName ='test-user@fakeemail.com';
    	objUser2.FirstName = 'Test_Parent_Fname2';
    	objUser2.LastName = 'Test_Parent_Lname3';
    	objUser2.CommunityNickname = 'tuser2';
    	objUser2.Alias = 'tuser12';
    	objUser2.email ='usertest-user@fakeemail1.com';
    	insert objUser2;
    	
    	objBU1 = testData.init_Business_Unit('BU1');
    	insert objBU1;
    	objBU2 = testData.init_Business_Unit('BU2');
    	insert objBU2;
    	
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
    	
    	List<Account> lstAcc = new List<Account>();
    	virtualAcc1 = testData.initVirtualAccount();
    	virtualAcc1.Business_Unit__c = objBU1.Id;
    	virtualAcc1.PST_Team_Member__c = objTM1.Id;
    	virtualAcc1.MST_Team_Member__c = objTM2.Id;
    	virtualAcc1.FPA_Team_Member__c = objTM3.Id;
    	virtualAcc1.OPS_Team_Member__c = objTM4.Id;
    	lstAcc.add(virtualAcc1);
    	
    	objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
    	lstAcc.add(objAccount);
    	
    	insert lstAcc;
    }

	@isTest
    public static void dupeCheckTest() 
    {
    	TestData();
    		    
	    List<Partner_Team_Member_Allocation__c> lst = new List<Partner_Team_Member_Allocation__c>();
	    Partner_Team_Member_Allocation__c objPTMA1 = new Partner_Team_Member_Allocation__c(Partner__c=virtualAcc1.Id, Name='Partner_Team_Member1', Team_Member__c=objTM1.Id);
	    Partner_Team_Member_Allocation__c objPTMA2 = new Partner_Team_Member_Allocation__c(Partner__c=virtualAcc1.Id, Name='Partner_Team_Member2', Team_Member__c=objTM2.Id);
	    Partner_Team_Member_Allocation__c objPTMA3 = new Partner_Team_Member_Allocation__c(Partner__c=virtualAcc1.Id, Name='Partner_Team_Member3', Team_Member__c=objTM3.Id);
	    Partner_Team_Member_Allocation__c objPTMA4 = new Partner_Team_Member_Allocation__c(Partner__c=virtualAcc1.Id, Name='Partner_Team_Member4', Team_Member__c=objTM4.Id);
	    
		List<Team_Member__c> lstTeamMember = new List<Team_Member__c>();	    
	    lstTeamMember.add(objTM1);
	    lstTeamMember.add(objTM2);
	    lstTeamMember.add(objTM3);
	    lstTeamMember.add(objTM4);
	    
	    
	    lst.add(objPTMA1);
	    lst.add(objPTMA2);
	    lst.add(objPTMA3);
	    lst.add(objPTMA4);
	    insert lst;
    	Test.startTest();
    	TeamMemberHandler objTeamMemberHandler = new TeamMemberHandler();
 
	    objTeamMemberHandler.partnerTeamMemberDeletion(lstTeamMember);

	    
	    //delete virtualAcc1;
	    Test.stopTest();
    }

/*	@isTest
    public static void dupeCheckTest() 
    {
    	TestData();
    	Test.startTest();
	    Team_Member__c objTM = new Team_Member__c();
	    objTM.Team_Member__c = objUser1.Id;
	    objTM.Department__c = objDept1.Id;
	    insert objTM;
	    Test.stopTest();
    }*/

	@isTest
    public static void PSTStatusCheckTest() 
    {
    	TestData();
    	Test.startTest();
    	try
    	{
		    objTM1.Status__c = 'Inactive';
		    update objTM1;
    	}
    	catch(Exception e)
		{
			System.Assert(e.getMessage().contains(Label.PST_Status_Change));
		}
	    Test.stopTest();
    }
    
    @isTest
    public static void MSTStatusCheckTest() 
    {
    	TestData();
    	
    	Test.startTest();
    	try
    	{
		    objTM2.Status__c = 'Inactive';
		    update objTM2;
    	}
    	catch(Exception e)
		{
			System.Assert(e.getMessage().contains(Label.MST_Status_change));
		}
	    Test.stopTest();
    }
    
    @isTest
    public static void FPAStatusCheckTest() 
    {
    	TestData();
    	Test.startTest();
    	try
    	{
		    objTM3.Status__c = 'Inactive';
		    update objTM3;
    	}
    	catch(Exception e)
		{
			System.Assert(e.getMessage().contains(Label.FPA_Status_Change));
		}
	    Test.stopTest();
    }
    
    @isTest
    public static void OPSStatusCheckTest() 
    {
    	TestData();
    	
    	Test.startTest();
    	try
    	{
		    objTM4.Status__c = 'Inactive';
		    update objTM4;
    	}
    	catch(Exception e)
		{
			System.Assert(e.getMessage().contains(Label.MST2_Status_change));
		}
	    Test.stopTest();
    }
}