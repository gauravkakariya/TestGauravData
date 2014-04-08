/*
Revision History:

	Version     Version Author     Date        Comments
	1.0         --           	   --	  	   Initial Draft
	2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class ProfilerOutputControllerTest 
{

    static ProfilerQuestions__c pfQns;
    static ProfilerOutputController pfoutCon;
    
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
        pfoutCon=new ProfilerOutputController();
      
       
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
        
        EntityProfilerQuestion__c entityPfQns = testData.init_profilerQue(acc, questionList.get(0),'Yes','10');  
        insert entityPfQns;
        system.assertNotEquals(null, entityPfQns.id);
        
        entityPfQns = testData.init_profilerQue(acc, questionList.get(1),'No','5');   
       	insert entityPfQns;
       	system.assertNotEquals(null, entityPfQns.id);
        System.currentPageReference().getParameters().put('EntityId',acc.id);
        pfoutCon=new ProfilerOutputController();
    }
    
    static void test2Data()
    {
       	List<ProfilerQuestions__c> questionList=new databaseSOQL().getProfilerQuestion();
        pfQns=questionList.get(0);
        system.assertNotEquals(null, pfQns.Name);
        
        TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null, acc.id);
        
        EntityProfilerQuestion__c entityPfQns = testData.init_profilerQue(acc, questionList.get(0),'Yes','5');  
        insert entityPfQns;
        system.assertNotEquals(null, entityPfQns.id);
        
        entityPfQns = testData.init_profilerQue(acc, questionList.get(1),'No','12');  
       	insert entityPfQns;
       	system.assertNotEquals(null, entityPfQns.id);
        System.currentPageReference().getParameters().put('EntityId',acc.id);
        pfoutCon=new ProfilerOutputController();
    }
    
    static void test3Data()
    {
       	List<ProfilerQuestions__c> questionList=new databaseSOQL().getProfilerQuestion();
        pfQns=questionList.get(0);
        system.assertNotEquals(null, pfQns.Name);
        
        TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null, acc.id);
        
        EntityProfilerQuestion__c entityPfQns = testData.init_profilerQue(acc, questionList.get(0),'Yes','5'); 
        insert entityPfQns;
        system.assertNotEquals(null, entityPfQns.id);
        
        entityPfQns = testData.init_profilerQue(acc, questionList.get(0),'No','8'); 
       	insert entityPfQns;
       	system.assertNotEquals(null, entityPfQns.id);
        System.currentPageReference().getParameters().put('EntityId',acc.id);
        pfoutCon=new ProfilerOutputController();
    }
    
    static void test4Data()
    {
       	List<ProfilerQuestions__c> questionList=new databaseSOQL().getProfilerQuestion();
        pfQns=questionList.get(0);
        system.assertNotEquals(null, pfQns.Name);
        
        TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null, acc.id);
        
        EntityProfilerQuestion__c entityPfQns = testData.init_profilerQue(acc, questionList.get(0),'Yes',null); 
        insert entityPfQns;
        system.assertNotEquals(null, entityPfQns.id);
        
        entityPfQns = testData.init_profilerQue(acc, questionList.get(4),'No',null);
        entityPfQns=new EntityProfilerQuestion__c(Answer__c='No',Entity__c=acc.id,   
                                              ProfilerQuestion__c=questionList.get(4).id,Score__c=null);
       	insert entityPfQns;
       	system.assertNotEquals(null, entityPfQns.id);
        System.currentPageReference().getParameters().put('EntityId',acc.id);
        pfoutCon=new ProfilerOutputController();
    }
    
    static testMethod void saveTest() {
        test.startTest();
        testData();
        String profile = pfoutCon.profile;
        integer cashReserveRequirement =pfoutCon.cashReserveRequirement;
        pfoutCon.getScoreOption();
        Integer total =pfoutCon.total;
        pfoutCon.Calculate();
       
        test.stopTest();
    }
   static testMethod void save1Test() {
        test.startTest();
        test1Data();
        String profile = pfoutCon.profile;
        integer cashReserveRequirement =pfoutCon.cashReserveRequirement;
        pfoutCon.getScoreOption();
        Integer total =pfoutCon.total;
        pfoutCon.Calculate();
       
        test.stopTest();
    }
  static testMethod void save2Test() {
        test.startTest();
        test2Data();
        String profile = pfoutCon.profile;
        integer cashReserveRequirement =pfoutCon.cashReserveRequirement;
        pfoutCon.getScoreOption();
        Integer total =pfoutCon.total;
        pfoutCon.Calculate();
       
        test.stopTest();
    }
    static testMethod void save3Test() {
        test.startTest();
        test3Data();
        String profile = pfoutCon.profile;
        integer cashReserveRequirement =pfoutCon.cashReserveRequirement;
        pfoutCon.getScoreOption();
        Integer total =pfoutCon.total;
        pfoutCon.Calculate();
       
        test.stopTest();
    } 
    static testMethod void save4Test() {
        test.startTest();
        test4Data();
        String profile = pfoutCon.profile;
        integer cashReserveRequirement =pfoutCon.cashReserveRequirement;
        pfoutCon.getScoreOption();
        Integer total =pfoutCon.total;
        pfoutCon.Calculate();
       
        test.stopTest();
    } 
}