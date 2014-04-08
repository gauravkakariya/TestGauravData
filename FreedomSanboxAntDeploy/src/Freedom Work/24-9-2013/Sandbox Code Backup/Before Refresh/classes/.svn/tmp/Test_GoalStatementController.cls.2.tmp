/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/


@isTest
private class Test_GoalStatementController {

    static testMethod void testGoalStatement() {
          
          Test.startTest();
          List<Goal__c> allGoals = new List<Goal__c>();
          List<Portfolio_Report__c> allPortfolios = new List<Portfolio_Report__c>();
          List<GoalIAULIPAssociation__c> gList = new List<GoalIAULIPAssociation__c>();
          //Deployement
          //Account act = [select Id, PersonContactId from Account where Parent_Entity__c = null LIMIT 1];
          
		TestData_Ffreedom testData = new TestData_Ffreedom();
		//User objUser = testData.initializeUser();
        Account act = testData.initializeAccount(); 
      	insert act;
      
        Goal__c gl=new Goal__c(Entity__c=act.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
        insert gl;
          
        Goal__c goal1 = testData.initializeGoal(act,'Marriage');
        allGoals.add(goal1);
        Goal__c goal2 = testData.initializeGoal(act,'Education');
        allGoals.add(goal2);
        insert allGoals;     
          
        Portfolio_Report__c port1 = testData.initialize_PortfolioReport(act, 'Birla Sun Life', 'EQ');
        allPortfolios.add(port1);
        Portfolio_Report__c port2 = testData.initialize_PortfolioReport(act,'Kotak Mahindra', 'MF');
        allPortfolios.add(port2);
        insert allPortfolios;
        
        List<GoalIAULIPAssociation__c> goalUlipList = [select Goal__c, Goal__r.Entity__c from GoalIAULIPAssociation__c where Goal__r.Entity__c = :act.Id];
       
      /* Deployment : Prajakta Sanap */       
        GoalIAULIPAssociation__c objGoal = new GoalIAULIPAssociation__c (Portfolio_Report__c=port1.Id, Allocation__c=10, Goal__c=goal1.Id);
        insert objGoal;
        for(GoalIAULIPAssociation__c gua :goalUlipList){
            gua.Allocation__c=10;
            if(gua.Portfolio_Report__c==port1.Id){
              System.assertEquals(gua.Portfolio_Report__c, port1.Id);
            }
            else if(gua.Portfolio_Report__c==port2.Id){
              System.assertEquals(gua.Portfolio_Report__c, port2.Id);
            }
            gList.add(gua);
        }
        update gList;
        
      //  ID ProfileID = [ Select id from Profile where name = 'Customer Portal Standard - Custom'].id;
      //Deployement
      /*List<User> u1 = [select Id from User where contactid = :act.PersonContactId];
      User user;
      if(u1 == null || u1.isEmpty()){
        user = new User( email='test-user@fakeemail.com', contactid = act.PersonContactId, profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
        insert user; 
      
      }
      else{
        user= u1[0];
      }*/
      //Deployement
   //   User user = new User( email='test-user@fakeemail.com', contactid = act.PersonContactId, profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
    //  insert user; 
        //System.runAs(user)
        {
          //Deployment : Aditi Satpute
          //Added this statement because Customer Portal is not enabled and we could not get Account Id without that.
            ApexPages.currentPage().getParameters().put('Id',act.id);
          GoalStatementController gsc = new GoalStatementController();
          Account acct = gsc.getAccount();
          System.assertEquals(acct.Id, act.Id);
          gsc.getGoals();
          
          
            gsc.getGoalIAULIPAssociationMap();
           // getUlipPortfolioMap();  
            gsc.getPortfolioRecords();
            gsc.getGoalPortfolioMap();
          Planner_Details__c plannerDetails = gsc.getPlannerDescription();
          List<GoalStatementController.goalPortfolioReportWrapper> wrapperList = gsc.getGoalPortfolioReportWrapper();
        }      
      Test.stopTest();
     
    }
}