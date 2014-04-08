/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class FPsidebarControllerTest 
{
   	static Account acc;
   	static Goal__c goal;
   	static Account child;
   	static FPsidebarController fpSideCon;
   	public static void testData()
   	{
   		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
	    upsert acc;
	    system.assertNotEquals(null,acc);
	    
	    Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      	insert goalProfile;
      	goal = testData.initialize_Goal(acc, 'Marriage', goalProfile);
    	insert goal;
    	system.assertNotEquals(null,goal.id);
	    
	    Apexpages.currentPage().getParameters().put('entityId',acc.id);
	    ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
	    fpSideCon = new FPsidebarController(stdController);
	    GeneralException ge=new GeneralException();
    }
    
    public static  void testData1()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
    
	    upsert acc;
	    system.assertNotEquals(null,acc);
	    
	    child = testData.init_FamilyMember(acc);
	    upsert child;
	    system.assert(child!=null);
	    Apexpages.currentPage().getParameters().put('entityId',child.id);
	    ApexPages.StandardController stdController= new ApexPages.StandardController(acc);
	    fpSideCon=new FPsidebarController(stdController);
	}
    
    static testMethod void myUnitTest() 
    {
        test.startTest();
        testData();
        fpSideCon.getGoals();
        test.stopTest();
    }
    static testMethod void myUnitTest1() 
    {
        test.startTest();
        testData1();
      // fpSideCon.getGoals();
        test.stopTest();
    }
}