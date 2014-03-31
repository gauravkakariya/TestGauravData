/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 
 */
@isTest
private class NewEditLeadControllerTest 
{
	public static User objUser1;
    public static Business_Unit__c objBU1;
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
    
    @isTest
    public static void TestData() 
    {
    	testData = new TestData_Ffreedom();
    	
    	List<User> lstUser = new List<User>();
    	objUser1 = testData.initializeUser();
    	lstUser.add(objUser1);
    	insert lstUser;
    	
    	List<Business_Unit__c> lstBU = new List<Business_Unit__c>();
    	objBU1 = testData.init_Business_Unit('BU1');
    	lstBU.add(objBU1);
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
    	
    }
    	
    static testMethod void newEditLeadTest() 
    {
    	
    	TestData();
    	
    	Lead objLead = testData.init_Lead();
    	//objLead.Business_Unit__c = objBU1.Id;
    	objLead.Virtual_Partner__c = virtualAcc1.Id;
    	//objLead.PST_Team_Member__c = objTM1.Id;
	    insert objLead;
    	
    	Test.startTest();
    	
    	PageReference pageRef = Page.NewEditLead;
    	pageRef.setRedirect(true); 
    	
    	ApexPages.currentPage().getParameters().put('id',objLead.Id); 
    	
    	ApexPages.StandardController std = new ApexPages.StandardController(objLead);        
        NewEditLeadController objNewEditLeadController	 = new NewEditLeadController(std);
    	
    	objNewEditLeadController.saveLead();
    	objNewEditLeadController.cancel();
    	
    	NewEditLeadController objNewEditLeadController1 = new NewEditLeadController();
    	objNewEditLeadController.cancel();
    	
        Test.stopTest();
        
    }
    
    
     //Create Require Data for Lead 
    private static Lead getLead(){
    	
    	return new Lead(LastName='Test Last',  
					    FirstName ='Test First',
					    MobilePhone='12345',
					    Email = 'abc@gmail.com',
					    Age__c = 45,
					    Occupation__c ='Test Occupation',
					    LeadSource = Label.Lead_Source_Web);
    }
    	
     private static Business_Unit__c getBusinessUnit()
     {
     	Business_Unit__c objBusinessUnit = new Business_Unit__c(Name = 'BussinessUnit1', Short_Code__c= 'BU1',Business_Unit_Name__c='BussinessUnit1');
     	return objBusinessUnit;
     }
     
     private static Department__c geTDepartment(Id businessUnitId)
     {
     	Department__c objDeparment = new Department__c(Name = 'PSTDept1',Type_of_Department__c='PSTDep', Business_Unit__c = businessUnitId );
     	return objDeparment;
     }
     
     private static Team_Member__c geTeamMember(Id departmentId)
     {
     	ID ProfileID = [ Select Id from Profile where name = 'Financial Planner'].Id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );

        insert objUser;
        
     	Team_Member__c objTeamMember = new Team_Member__c(Department__c = departmentId, Status__c= 'Active', Team_Member__c= objUser.Id);
     	return objTeamMember;
     }
     
}