/**
 * 
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav             30/1/2013      This class contains unit tests for validating the behavior of 
    											  FinancialWellnessReportController class and Verifies if Existing Lead given
    											  Wellness Test and atttach its score data to attachment object in form of pdf.	 
 */
 
@isTest
private class TestFinancialWellnessReportController {

	//Verify Wellness Score of Existing Lead Created during Wellness Test 
    static testMethod void existingLeadWellnessTest() {
       
        Test.startTest(); // Start  Test
    	
    	Lead LeadDetails = getLead();
    	insert LeadDetails;
    	
    	Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	    
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	    
	    List<Wellness_Score_Card__c> lstWellnessScoreCard = getWellnessScoreCardForLeadList(questionBank.Id ,LeadDetails.Id);
	    insert lstWellnessScoreCard;
	    
	    List<Wellness_Card_Detail__c> lstWellnessScoreCardDetails = getWellnessCardDetailList(lstWellnessScoreCard[0].Id ,lstQuestionOption[0].Id, lstQuestionBankList[0].Id);
	    insert lstWellnessScoreCardDetails;
	    
	    
    	PageReference pageRef = Page.FinancialWellnessReport;
    	pageRef.setRedirect(true);
    	ApexPages.currentPage().getParameters().put('id', LeadDetails.Id);
    	ApexPages.currentPage().getParameters().put('value', '20');
    	
    	FinancialWellnessReportController wellnessAttachment = new FinancialWellnessReportController();
    	wellnessAttachment.generatePdf();
    	Test.stopTest(); // Stop Test
    	
    }	
    	
    	/*
    	FinancialWellnessController financialWellness = new FinancialWellnessController();
    	FinancialWellnessController.SelectQuestionAnswer selectQuetionAnswer = new FinancialWellnessController.SelectQuestionAnswer();
    	financialWellness.objActiveQuestionBank = questionBank;
    	financialWellness.lstQuestionnaire = lstQuestionnaire;
    	financialWellness.lstQuestions = lstQuestionBankList;
    	financialWellness.Init();
    	financialWellness.queNo = 0;
    	
    	financialWellness.lstOfQuestionAnswer[0].selectedAnswer = null;
    	financialWellness.lstOfQuestionAnswer[0].selectedAnswer = lstQuestionOption[0].Id;
    	financialWellness.lstOfQuestionAnswer[1].selectedAnswer = lstQuestionOption[1].Id;
    	financialWellness.lstOfQuestionAnswer[financialWellness.lstOfQuestionAnswer.size()-1].isMultiChoice = false;
    	financialWellness.queNo = financialWellness.lstOfQuestionAnswer.size()-1;
    	financialWellness.showPopUp();
    	financialWellness.saveDetailsOfCustomer();
    	financialWellness.sendMail();
    	
    	pageRef = Page.FinancialWellnessReport;
    	pageRef.setRedirect(true);
    	ApexPages.currentPage().getParameters().get('id');
    	wellnessAttachment.generatePdf();
    	financialWellness.closePopup();
    	Test.stopTest(); // Stop Test
        
    }
    
    /*Create Test Data for Wellness Report Controller Class.*/
    //Create Require Data for Lead 
    private static Lead getLead(){
    	
    	return new Lead(LastName='Test Last',  
					    FirstName ='Test First',
					    MobilePhone='12345',
					    Email = 'abc@gmail.com',
					    Age__c = 45,
					    Occupation__c ='Test Occupation',
					    LeadSource = 'Web-Wellness');
    }
    
    //Create Question Bank for Wellness
    private static Question_Bank__c getQuestionBank(){
    	return new Question_Bank__c(IsWellness__c = true);
    	
    }
    
    //Create Require Data for Questionnaire
    private static List<Question_Bank_List__c> getQuestionBankList(){
    	
    	List<Question_Bank_List__c> lstQuestionBankList = new List<Question_Bank_List__c>();
    	
    	Question_Bank_List__c qBankList = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');
    	lstQuestionBankList.add(qBankList);								  
    									  
        Question_Bank_List__c qBankList1 = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');
			    									 
    									  
    	lstQuestionBankList.add(qBankList1);
    	
    	Question_Bank_List__c qBankList2 = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');
	    									  
	    lstQuestionBankList.add(qBankList2);	
	    
	    Question_Bank_List__c qBankList3 = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');
	    lstQuestionBankList.add(qBankList3);									  								  
    	Question_Bank_List__c qBankList4 = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');
	    lstQuestionBankList.add(qBankList4);									  
	    Question_Bank_List__c qBankList5 = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');
	   lstQuestionBankList.add(qBankList5); 									  
	   Question_Bank_List__c qBankList6 = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');
	    lstQuestionBankList.add(qBankList6);									  
	    Question_Bank_List__c qBankList7 = new Question_Bank_List__c(
	    									  Question__c = 'How much control do you think you have on your expenses?',
	    									  IsDummy__c = false,
	    									  Question_Type__c = 'Yes/No');	
	    lstQuestionBankList.add(qBankList7);								  								   									  									  
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
    
    
    //Create Require Data for Wellness_Score_Card__c List for Lead
    private static List<Wellness_Score_Card__c> getWellnessScoreCardForLeadList(Id pQuestionBankId, Id pRecordId){
    	
    	List<Wellness_Score_Card__c> lstWellnessScoreCard = new List<Wellness_Score_Card__c>();
    	Wellness_Score_Card__c wellnessScoreCard1 = new Wellness_Score_Card__c(
			    									    Name = 'Test1',
			    									    Lead__c = pRecordId,
			    									    Wellness_Test_Date__c = Date.today(),
			    									    Question_Bank__c = pQuestionBankId);
    									  
    	lstWellnessScoreCard.add(wellnessScoreCard1);								  
        Wellness_Score_Card__c wellnessScoreCard2 = new Wellness_Score_Card__c(
				    									Name = 'Test2',
				    									Lead__c = pRecordId,
				    									Wellness_Test_Date__c = Date.today().addDays(2),
				    									Question_Bank__c = pQuestionBankId);
    									  
    	lstWellnessScoreCard.add(wellnessScoreCard2);
    	return lstWellnessScoreCard;
    }
    
    //Create Require Data for Wellness_Score_Card__c List for Lead
    private static List<Wellness_Card_Detail__c> getWellnessCardDetailList(Id pWellnessScoreCardId, Id pOptionId , Id pQuestionBankListId){
    	
    	List<Wellness_Card_Detail__c> lstWellnessDetailList = new List<Wellness_Card_Detail__c>();
    	Wellness_Card_Detail__c wellnessDetailsList = new Wellness_Card_Detail__c(
			    									    Name = 'Test1',
			    									    Score__c = 5,
			    									    Display_Sequence__c = 1,
			    									    Wellness_Score_Card__c = pWellnessScoreCardId,
			    									    Question_Option_List__c = pOptionId,
			    									    Question_Bank_List__c = pQuestionBankListId);
			    									    
    									  
    	lstWellnessDetailList.add(wellnessDetailsList);								  
       
    	return lstWellnessDetailList;
    	
    }
    
}