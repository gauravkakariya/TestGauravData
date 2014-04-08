/*
Revision History:

	Version     Version Author     Date        Comments
	1.0         --           	   --	  	   Initial Draft
	2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class ProfilerQuestionControllerTest 
{
    static ProfilerQuestions__c pfQns;
    static ProfilerQuestionPageController pfQnsCon;
    static void testData()
    {
        List<ProfilerQuestions__c> questionList=new databaseSOQL().getProfilerQuestion();
        pfQns=questionList.get(0);
        system.assertNotEquals(null, pfQns.Name);
        
        TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null, acc.id);
        
        EntityProfilerQuestion__c entityPfQns = testData.init_profilerQue(acc, questionList.get(0),'Yes','20');  
        insert entityPfQns;
        system.assertNotEquals(null, entityPfQns.id);
        
        entityPfQns = testData.init_profilerQue(acc, questionList.get(1),'No','20');  
       	insert entityPfQns;
       	system.assertNotEquals(null, entityPfQns.id);
        System.currentPageReference().getParameters().put('EntityId',acc.id);
        pfQnsCon=new ProfilerQuestionPageController();
    }
   
   static void test1Data()
   {
        List<ProfilerQuestions__c> questionList=new databaseSOQL().getProfilerQuestion();
        pfQns=questionList.get(0);
        system.assertNotEquals(null, pfQns.Name);
        
        TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null, acc.id);
       
        System.currentPageReference().getParameters().put('EntityId',acc.id);
        pfQnsCon=new ProfilerQuestionPageController();
       
       
    }
    
    static testMethod void saveTest() 
    {
        test.startTest();
        testData();
        pfQnsCon.save();
        test.stopTest();
    }
   	
   	static testMethod void save1Test() 
   	{
        test.startTest();
        test1Data();
        pfQnsCon.save();
        test.stopTest();
    }
  
    static testMethod void cancelTest() 
    {
        test.startTest();
        testData();
        pfQnsCon.cancel();
        test.stopTest();
    }
}