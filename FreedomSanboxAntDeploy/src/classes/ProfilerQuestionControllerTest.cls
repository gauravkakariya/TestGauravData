/*
Revision History:

	Version     Version Author     Date        Comments
	1.0         --           	   --	  	   Initial Draft
	2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class ProfilerQuestionControllerTest 
{
    static ProfilerQuestionPageController pfQnsCon;
    public static Account acc;
    
    static void testData()
    {
        TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null, acc.id);
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
        pfQnsCon = new ProfilerQuestionPageController();
    }
   
    static testMethod void ProfileTest() 
    {
        test.startTest();
        testData();
        acc.Finametrica_Score__c = 15;
        update acc;
        acc.Finametrica_Score__c = 45;
        update acc;
        acc.Finametrica_Score__c = 75;
        update acc;
        //pfQnsCon.save();
        test.stopTest();
    }
   	
   	static testMethod void saveTest() 
   	{
        test.startTest();
        //testData();
        TestData_Ffreedom testData = new TestData_Ffreedom();
		Account account = testData.initializeAccount();
		account.Risk_profile__c = 'Medium';
		account.Finametrica_Score__c = 56;
		account.LastName = 'Risk Test';
        insert account;
        Goal__c objGoal = new Goal__c(Goal_Type__c = 'Test', Entity__c = account.Id); 
	    insert objGoal;
	    
	    Apexpages.currentPage().getParameters().put('entityId',account.id);
        pfQnsCon = new ProfilerQuestionPageController();
        pfQnsCon.save();
        test.stopTest();
    }
  	
  	static testMethod void saveRemarkTest() 
   	{
        test.startTest();
        testData();
        
        ID RecTypeId = [select id from RecordType where Name=: 'RiskProfiler'][0].id;
        Remarks__c objSaveRemark = new Remarks__c();
        objSaveRemark.Entity__c = acc.id;
        objSaveRemark.Remark__c = 'strRemark';
        objSaveRemark.RecordTypeId = RecTypeId;
        insert objSaveRemark;
        pfQnsCon.save();
        test.stopTest();
    }
    
    
    
  	static testMethod void saveDirectTest() 
   	{
		test.startTest();
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Account account = testData.initializeAccount();
		account.Risk_profile__c = 'Medium';
		account.Finametrica_Score__c = 56;
		account.LastName = 'Risk Test';
        insert account;
        account = [
	    	select id, LastName
	    		 , Finametrica_Score__c
	          from Account
	          where id =: account.id
	    ];
	    system.debug('------------------aaaaaaaaaa------'+account);
	    account.Finametrica_Score__c = 23;
	    update account;
	    
	   
	    
	    Apexpages.currentPage().getParameters().put('entityId',account.id);
        pfQnsCon = new ProfilerQuestionPageController();
	    //pfQnsCon = new ProfilerQuestionPageController();
	    //pfQnsCon.save();
        test.stopTest();
    }
  	
  	static testMethod void saveRiskProfileForGoalsTest() 
   	{
        test.startTest();
        testData();
        pfQnsCon.save();
        pfQnsCon.saveRiskProfileForGoals();
        test.stopTest();
    }
    
    static testMethod void cancelTest() 
    {
        test.startTest();
        testData();
        pfQnsCon.cancelPopup();
        test.stopTest();
    }
    
}