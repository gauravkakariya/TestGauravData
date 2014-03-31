/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 27/09/2013   1. Test class 
	
*/
@isTest
public class LeadHandlerTest 
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
    
   @isTest(seeAlldata=true) 
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
    	
    	List<Account> lstVirtualAcc = new List<Account>();
    	virtualAcc1 = testData.initVirtualAccount();
    	virtualAcc1.Business_Unit__c = objBU1.Id;
    	virtualAcc1.PST_Team_Member__c = objTM1.Id;
    	virtualAcc1.MST_Team_Member__c = objTM2.Id;
    	virtualAcc1.FPA_Team_Member__c = objTM3.Id;
    	virtualAcc1.OPS_Team_Member__c = objTM4.Id;
    	lstVirtualAcc.add(virtualAcc1);
    	insert lstVirtualAcc;
	    
	    system.assertNotEquals(0, [Select Id from Partner_Team_Member_Allocation__c where Partner__c =: lstVirtualAcc[0].Id].size());
    }
    	
    /*    	
    @isTest
    public static void partnerTeamMemberAllocationTest() 
    {
    	TestData();
    	
    	Lead objLead = testData.init_Lead();
    	objLead.Business_Unit__c = objBU1.Id;
    	objLead.Virtual_Partner__c = virtualAcc1.Id;
	    insert objLead;
	    
	    Test.startTest();
	    objLead.Business_Unit__c = objBU2.Id;
	    objLead.Virtual_Partner__c = objBU2.Id;
	    update objLead;
	    Test.stopTest();
    }*/
}