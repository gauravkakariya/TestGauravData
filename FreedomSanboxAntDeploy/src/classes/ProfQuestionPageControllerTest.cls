/* 
*  Test class created for ProfQuestionPageController
*
*   Revision History:
*
*   Version			Author             Date          Description
*   1.0         Prajakta Sanap		18/07/2013 	 	Initial Draft 
*/


@isTest
private class ProfQuestionPageControllerTest 
{
    static testMethod void profilerTest() 
    {
        Test.startTest();
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	List<Account> lstAccount = new List<Account>();
    	
    	Account objAccount = testData.initializeAccount();
	    lstAccount.add(objAccount);
	    insert lstAccount;
	    
	    Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	    
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	    
	    List<Profiler_Score_Card__c> lstProfileScoreCard = getProfileScoreCardList(questionBank.Id , objAccount.Id);
	    insert lstProfileScoreCard;
	    
	    List<Profiler_Card_Detail__c> lstProfileCardDetail = getProfileCardDetailList(lstProfileScoreCard[0].Id, lstQuestionBankList[0].Id, lstQuestionOption[0].Id);
	    insert lstProfileCardDetail;
	    
	    Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
	    ProfQuestionPageController objProfilerQue = new ProfQuestionPageController();
	    
	    objProfilerQue.Init();
	    objProfilerQue.lstOfQuestionAnswer[0].selectedAnswer = lstQuestionOption[0].Id;
	    objProfilerQue.lstOfQuestionAnswer[1].selectedAnswer = lstQuestionOption[1].Id;
	    
	    objProfilerQue.save();
	    objProfilerQue.isProfilerOutput = false;
	    objProfilerQue.isProfilerQuestion = true;
	    objProfilerQue.totalScore = 55;
	    
		test.stopTest();
    }
    
    static testMethod void profilerScoreCardTest() 
    {
        Test.startTest();
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	List<Account> lstAccount = new List<Account>();
    	
    	Account objAccount = testData.initializeAccount();
	    lstAccount.add(objAccount);
	    insert lstAccount;
	    
	    Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	    
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	    
	    List<Profiler_Score_Card__c> lstProfileScoreCard = new List<Profiler_Score_Card__c>();
	    insert lstProfileScoreCard;
	    /*List<Profiler_Score_Card__c> lstProfileScoreCard = getProfileScoreCardList(questionBank.Id , objAccount.Id);
	    insert lstProfileScoreCard;
	    
	    List<Profiler_Card_Detail__c> lstProfileCardDetail = getProfileCardDetailList(lstProfileScoreCard[0].Id, lstQuestionBankList[0].Id, lstQuestionOption[0].Id);
	    insert lstProfileCardDetail;*/
	    
	    Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
	    ProfQuestionPageController objProfilerQue = new ProfQuestionPageController();
	    objProfilerQue.Init();
	    objProfilerQue.Reset();
	    //objProfilerQue.save();
	    objProfilerQue.isProfilerOutput = false;
	    objProfilerQue.isProfilerQuestion = true;
	    objProfilerQue.totalScore = 55;
	    
		test.stopTest();
    }
    
    //Create Question Bank for Wellness
    private static Question_Bank__c getQuestionBank()
    {
    	return new Question_Bank__c(IsProfilerQue__c = true);
    }
    
    //Create Require Data for Questionnaire
    private static List<Question_Bank_List__c> getQuestionBankList()
    {
    	List<Question_Bank_List__c> lstQuestionBankList = new List<Question_Bank_List__c>();
    	
    	Question_Bank_List__c qBankList = new Question_Bank_List__c(
	    									  Question__c = 'My Current Stage of Life Best Described As Follows:',
	    									  Question_Type__c = 'Yes/No');
    	lstQuestionBankList.add(qBankList);								  
    									  
        Question_Bank_List__c qBankList1 = new Question_Bank_List__c(
	    									  Question__c = 'Number of people (other than yourself) dependent on your income?',
	    									  Question_Type__c = 'Yes/No');
    	lstQuestionBankList.add(qBankList1);
    	
    	Question_Bank_List__c qBankList2 = new Question_Bank_List__c(
	    									  Question__c = 'What is your view regarding the stability of your income?',
	    									  Question_Type__c = 'Yes/No');
	    lstQuestionBankList.add(qBankList2);	
	    
	    Question_Bank_List__c qBankList3 = new Question_Bank_List__c(
	    									  Question__c = 'How well do you understand investing and the equity market?',
	    									  Question_Type__c = 'Yes/No');
	    lstQuestionBankList.add(qBankList3);									  								  
    	Question_Bank_List__c qBankList4 = new Question_Bank_List__c(
	    									  Question__c = 'You have three investment options to choose from:',
	    									  Question_Type__c = 'Yes/No');
	    lstQuestionBankList.add(qBankList4);									  
	    Question_Bank_List__c qBankList5 = new Question_Bank_List__c(
	    									  Question__c = 'You invest Rs 1,00,000 in a fund that goes down by 8% the next day. You ?',
	    									  Question_Type__c = 'Yes/No');
	    lstQuestionBankList.add(qBankList5); 									  
    	return lstQuestionBankList;
    }
    
    //Create Require Data for Questionnaire
    private static List<Questionnaire__c> getQuestionnaire(Id pQuestionBankId, Id pQuestionBankListId){
    	
    	List<Questionnaire__c> lstQuestionnaire = new List<Questionnaire__c>();
    	
    	Questionnaire__c Questionnaire1 = new Questionnaire__c(
	    									  Question_Bank__c = pQuestionBankId,
	    									  Question_Bank_List__c = pQuestionBankListId,
	    									  Display_Sequence__c = '1');
    									  
    	 lstQuestionnaire.add(Questionnaire1);								  
    									  
        Questionnaire__c Questionnaire2 = new Questionnaire__c(
	    									  Question_Bank__c = pQuestionBankId,
	    									  Question_Bank_List__c= pQuestionBankListId,
	    									  Display_Sequence__c = '2');
    									  
    	lstQuestionnaire.add(Questionnaire2);
    	
    	return lstQuestionnaire;
    }
    
    //Create Require Data for Question Option List
    private static List<Question_Option_List__c> getQuestionOptionList(Id pQuestionBankListId){
    	
    	List<Question_Option_List__c> lstQuestionOption = new List<Question_Option_List__c>();
    	Question_Option_List__c QuestionOption1 = new Question_Option_List__c(
			    									  Name = 'No',
			    									  Score__c = 5,
			    									  Question_Bank_List__c = pQuestionBankListId);
    									  
    	lstQuestionOption.add(QuestionOption1);								  
        Question_Option_List__c QuestionOption2 = new Question_Option_List__c(
			    									  Name = 'Yes',
			    									  Score__c= 5,
			    									  Question_Bank_List__c = pQuestionBankListId);
    									  
    	lstQuestionOption.add(QuestionOption2);
    	return lstQuestionOption;
    }
    
    //Create Require Data for Profiler_Score_Card__c List for Entity
    private static List<Profiler_Score_Card__c> getProfileScoreCardList(Id pQuestionBankId, Id pRecordId){
    	
    	List<Profiler_Score_Card__c> lstProfileScoreCard = new List<Profiler_Score_Card__c>();
    	Profiler_Score_Card__c ProfileScoreCard1 = new Profiler_Score_Card__c(
				    									Name = 'Test1',
				    									Account__c = pRecordId,
				    								    Question_Bank__c = pQuestionBankId);
    	lstProfileScoreCard.add(ProfileScoreCard1);								  
    	return lstProfileScoreCard;
    }
    
    //Create Require Data for Profiler_Score_Card__c List for Entity
    private static List<Profiler_Card_Detail__c> getProfileCardDetailList(Id pProfileScoreCardId, Id pQuestionBankListId, Id pQuestionOptionListId){
    	
    	List<Profiler_Card_Detail__c> lstProfileCardDetail = new List<Profiler_Card_Detail__c>();
    	Profiler_Card_Detail__c ProfileCardDetail1 = new Profiler_Card_Detail__c(
				    									Name = 'Test1',
				    									Question_Bank_List__c = pQuestionBankListId,
				    									Question_Option_List__c = pQuestionOptionListId,
				    								    Profiler_Score_Card__c = pProfileScoreCardId);
    	lstProfileCardDetail.add(ProfileCardDetail1);

		Profiler_Card_Detail__c ProfileCardDetail2 = new Profiler_Card_Detail__c(
				    									Name = 'Test2',
				    									Question_Bank_List__c = pQuestionBankListId,
				    									Question_Option_List__c = pQuestionOptionListId,
				    								    Profiler_Score_Card__c = pProfileScoreCardId);
    	lstProfileCardDetail.add(ProfileCardDetail2);
		
		Profiler_Card_Detail__c ProfileCardDetail3 = new Profiler_Card_Detail__c(
				    									Name = 'Test2',
				    									Question_Bank_List__c = pQuestionBankListId,
				    									Question_Option_List__c = pQuestionOptionListId,
				    								    Profiler_Score_Card__c = pProfileScoreCardId);
    	lstProfileCardDetail.add(ProfileCardDetail3);
    	
    	Profiler_Card_Detail__c ProfileCardDetail4 = new Profiler_Card_Detail__c(
				    									Name = 'Test2',
				    									Question_Bank_List__c = pQuestionBankListId,
				    									Question_Option_List__c = pQuestionOptionListId,
				    								    Profiler_Score_Card__c = pProfileScoreCardId);
    	lstProfileCardDetail.add(ProfileCardDetail4);
    	
    	Profiler_Card_Detail__c ProfileCardDetail5 = new Profiler_Card_Detail__c(
				    									Name = 'Test2',
				    									Question_Bank_List__c = pQuestionBankListId,
				    									Question_Option_List__c = pQuestionOptionListId,
				    								    Profiler_Score_Card__c = pProfileScoreCardId);
    	lstProfileCardDetail.add(ProfileCardDetail5);
    	
    	Profiler_Card_Detail__c ProfileCardDetail6 = new Profiler_Card_Detail__c(
				    									Name = 'Test2',
				    									Question_Bank_List__c = pQuestionBankListId,
				    									Question_Option_List__c = pQuestionOptionListId,
				    								    Profiler_Score_Card__c = pProfileScoreCardId);
    	lstProfileCardDetail.add(ProfileCardDetail6);
		
    	return lstProfileCardDetail;
    }
    
}