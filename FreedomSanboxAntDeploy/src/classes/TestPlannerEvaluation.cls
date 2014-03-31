/*
	
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0		   Manasi Ranade     14/12/2011	  	Issue ID : FS0290 : Change in Class :ApprovedPlanServices :
   											    Need to remove the field from Execution Tracker object : Original_Target_Date__c,Owner__c.
   											    So removed the following field from Test class 
   2.0		   Manasi Ranade     22/12/2011	  	Issue ID : FS0310 : Added Appointment_Time__c as it was throwing an exception because of Lead validation rule
   2.0  	   Prajakta Sanap    26/04/2013		Created TestData_Ffreedom which contains all the test data for this test class.
*/
@isTest
private class TestPlannerEvaluation {

    static testMethod void testingPlannerEvaluation() {
        
        List<Account> accountList = new List<Account>(); 
        List<Execution_Tracker__c> trackersList = new List<Execution_Tracker__c>();
    	Date todaysDate = Date.today();
    	datetime myDateTime = datetime.now();
    	
    	ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
    	UserRole ur1 = [select Id, Name from UserRole where Name = 'Sr.Mgr.FP - GALAXY'];//Fps [MAEGAN MUMBAI]

		User u1 = new User(UserRoleId=ur1.Id , isActive = true,email='test-user@fakeemail1.com', 
  							profileid = ProfileID, UserName='test-user@fakeemail1.com', Workstations__c='Galaxy',
  	 						alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
  	 						LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US',
  	 						FirstName = 'Test_Parent_Fname1', LastName = 'Test_Parent_Lname1');
        insert u1;
    	
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		System.runas(u1)
        {
		Account acc1 = testData.initializeAccount(u1);
		acc1.PAN_ID__pc = 'adadad4545';
        accountList.add(acc1);
        
       // insert acc1;
        
        Account acc2 = testData.initializeAccount(u1);
        acc2.PAN_ID__pc = 'adadad4546';
        accountList.add(acc2);
       // insert acc2;
        
        Account acc3 = testData.initializeAccount(u1);
        acc3.PAN_ID__pc = 'adadad4r45';
        accountList.add(acc3);
        //insert acc3;
        insert accountList;

       	List<Lead> leadList = new List<Lead>(); 
       	Lead ld1 = testData.init_Lead(u1, 'BNI', 'Meeting Done');
       	leadList.add(ld1);
       	Lead ld2 = testData.init_Lead(u1, 'Client/Lead Referral', 'Converted');
       	leadList.add(ld2);
       	Lead ld3 = testData.init_Lead(u1, 'Referral', 'Not Interested');
       	leadList.add(ld3);
       	Lead ld4 = testData.init_Lead(u1, 'Corp Comm', 'Not Interested');
       	leadList.add(ld4);
       	Lead ld5 = testData.init_Lead(u1, 'NDC', 'Converted'); 
       	leadList.add(ld5);
       	insert leadList;
     	Test.startTest();
        Execution_Tracker__c exec1 = new Execution_Tracker__c(Entity_Name__c=acc1.Id,Target_Revenue__c=10000,Opportunity_Name__c='SIP' );
        trackersList.add(exec1); 
        Execution_Tracker__c exec2 = new Execution_Tracker__c(Entity_Name__c=acc1.Id,Target_Revenue__c=10000,Opportunity_Name__c='SIP' );
        trackersList.add(exec2);
        Execution_Tracker__c exec3 = new Execution_Tracker__c(Entity_Name__c=acc1.Id,Target_Revenue__c=10000,Opportunity_Name__c='SIP' );
        trackersList.add(exec3);
        insert trackersList;
       
        
        	PlannerEvaluation pl = new PlannerEvaluation();
        	pl.plannerName = acc1.OwnerId;
        	
        	date myDate = date.newInstance(1960, 2, 17);
        	//pl.plannerMonthlyLeadsWrapper obj = new pl.plannerMonthlyLeadsWrapper();
	        pl.setStartDate(myDate.format());
	        pl.setEndDate(todaysDate.format());
	        //System.assertEquals('08/01/2010', pl.getStartDate());
	        //System.assertEquals('12/30/2010', pl.getEndDate());
	        pl.getPlannerRoles();
         	List<Lead> lstLead  = pl.getLead();
	        pl.getReport();
	        List<SelectOption> selectOptionsList = pl.getItems();
	        String getTotalEntities=pl.getTotalEntities();
	        String getFavourableEntities=pl.getFavourableEntities();
	        String PercentageOfFavourableEntities=pl.getPercentageOfFavourableEntities();
	        String FavourablePlanApprovals=pl.getFavourablePlanApprovals();
	        String PercentageOfPlanApproval=pl.getPercentageOfPlanApproval();
        	String TestimonialsReceived=pl.numberOfTestimonialsReceived;
        	List<PlannerEvaluation.userMonthlyLeadsWrapper> userMonthlyLeadsWrapperList= pl.getuserMonthlyLeadsWrapperList();
        	
        }
      
        Test.stopTest();
    }
    
}