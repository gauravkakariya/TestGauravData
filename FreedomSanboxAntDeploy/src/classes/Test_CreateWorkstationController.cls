public class Test_CreateWorkstationController 
{
	@isTest(SeeAllData = true)
    static void myUnitTest() 
    {
    	  Test.startTest();
          ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
          User user = new User( email='test-user@fakeemail.com', profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', 
          					CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',
          					LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
          insert user;
          
    	  Workstation__c workstation = new Workstation__c();
    	  workstation.Financial_Planner__c = user.Id;
    	  workstation.Compliance__c = user.Id;
    	  workstation.Business_Developer__c = user.Id;
    	  workstation.Tech__c = user.Id;
    	  workstation.Manager__c = user.Id;
    	  workstation.Member_Engagement__c = user.Id;
    	  workstation.Location__c='pune';
    	  insert workstation;
    	  
          List<Workstation__c> lstworkstation = new  List<Workstation__c> ();
          List<User>  lstuser = new List <User>();
          lstworkstation.add(workstation);
          lstuser.add(user);
          CreateWorkstationController controller = new CreateWorkstationController();
          controller.Init();
          controller.lstFinancialPlanners = lstuser;
          controller.lstWorkstations = lstworkstation;
          //controller.Init();
          List<SelectOption> getfinancialplanner = controller.getFinancialPlanners();
          List<SelectOption> getbusinessdeveloper = controller.getBusinessDeveloper();
          List<SelectOption> getcompliance = controller.getCompliance();
          List<SelectOption> gettech = controller.getTech();
          List<SelectOption> getmemberengagement =  controller.getMemberEngagement();
          controller.getAdvosor();
          controller.Addrow();
          controller.AssignManager();
          Pagereference pagesave = controller.Save();
          controller.Remove();
          Pagereference pageclose = controller.Close();
          Pagereference viewworkstation = controller.ViewWorkstation();
          Test.stopTest();
          
          
    }
    static testMethod void UnitTest() {
    	
    	  Test.startTest();
    	  User user;
          ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
          user = new User( email='test-user@fakeemail.com', profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', 
          					CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',
          					LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
          insert user;
          
    	  Workstation__c workstation = new Workstation__c();
    	  workstation.Financial_Planner__c = user.Id;
    	  workstation.Compliance__c = user.Id;
    	  workstation.Business_Developer__c = user.Id;
    	  workstation.Tech__c = user.Id;
    	 // workstation.Manager__c = user.Id;
    	  workstation.Member_Engagement__c = user.Id;
    	  workstation.Location__c='pune';
    	  insert workstation;
    	  
          List<Workstation__c> lstworkstation = new  List<Workstation__c> ();
          List<User>  lstuser = new List <User>();
          lstworkstation.add(workstation);
          lstuser.add(user);
          
          CreateWorkstationController controller = new CreateWorkstationController();
          controller.Init();
          controller.lstFinancialPlanners = lstuser;
          controller.lstWorkstations = lstworkstation;
          //controller.Init();
          List<SelectOption> getfinancialplanner = controller.getFinancialPlanners();
          List<SelectOption> getbusinessdeveloper = controller.getBusinessDeveloper();
          List<SelectOption> getcompliance = controller.getCompliance();
          List<SelectOption> gettech = controller.getTech();
          List<SelectOption> getmemberengagement =  controller.getMemberEngagement();
          controller.Addrow();
          controller.AssignManager();
          Pagereference pagesave = controller.Save();
          controller.Remove();
          Pagereference pageclose = controller.Close();
          Pagereference viewworkstation = controller.ViewWorkstation();
          Test.stopTest();
    }
}