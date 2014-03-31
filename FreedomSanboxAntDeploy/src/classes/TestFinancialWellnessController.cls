/**
 * 
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav             09/1/2012      This class contains unit tests for validating the behavior of 
    											  FinancialWellnessController class 
 */
 
@isTest(SeeAllData=true)
private class TestFinancialWellnessController {

    //Verify Wellness Lead Created during Wellness Test 
    static testMethod void leadWellnessTest() {
    	
    	Test.startTest(); // Start  Test
    	PageReference pageRef = Page.FinancialWellness;
    	pageRef.setRedirect(true);
    	
    	FinancialWellnessController financialWellness = new FinancialWellnessController();
    	financialWellness.Init();
    	financialWellness.showPopUp();
    	financialWellness.objLead.FirstName = 'TestFirstName';
    	financialWellness.objLead.LastName = 'TestLastName';
    	financialWellness.objLead.MobilePhone = '9090909090';
    	financialWellness.objLead.Email = 'test@test.com';
    	financialWellness.objLead.Occupation__c = 'testOccupation';
    	financialWellness.objLead.Age__c = 23;
    	financialWellness.dblFreedomScore = 0.0;
    	financialWellness.saveDetailsOfCustomer();
    	
    	Lead objLead = [Select Id, 
            				   Name,
            				   Email, 
            				   FirstName,
            				   LastName, 
            				   MobilePhone, 
            				   Age__c,
            				   Income_Source__c,
            				   Occupation__c 
	            		From Lead 
	            		Where Email =:'test@test.com' limit 1];
            		   
    	//system.assertEquals(objLead.MobilePhone, '9090909090');
    	Test.stopTest();  // End Test
    }
    
     //Verify Wellness Lead Created during Wellness Test 
    static testMethod void leadWithExistingWellnessScoreTest() {
    	
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
	    
    	PageReference pageRef = Page.FinancialWellness;
    	pageRef.setRedirect(true);
    	ApexPages.currentPage().getParameters().put('id', LeadDetails.Id);
    	
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
    	financialWellness.displayPopUp = true;
    	financialWellness.objLead.FirstName = 'TestFirstName';
    	financialWellness.objLead.LastName = 'TestLastName';
    	financialWellness.objLead.MobilePhone = '9090909090';
    	financialWellness.objLead.Email = 'test@test.com';
    	financialWellness.objLead.Occupation__c = 'testOccupation';
    	financialWellness.objLead.Age__c = 23;
    	financialWellness.saveDetailsOfCustomer();
    	financialWellness.closePopup();
    	
    	Lead objLead = [Select Id, 
            				   Name,
            				   Email, 
            				   FirstName,
            				   LastName, 
            				   MobilePhone, 
            				   Age__c,
            				   Income_Source__c,
            				   Occupation__c 
	            		From Lead 
	            		Where Email =:'test@test.com' limit 1];
            		   
    	//system.assertEquals(objLead.MobilePhone, '1346465');
    	Test.stopTest();  // End Test
    }
    
    //Verify Wellness Score of Existing Lead Created during Wellness Test 
    static testMethod void ExistingleadWellnessTest() {
    	
    	Test.startTest(); // Start  Test
    	
    	Lead LeadDetails = getLead();
    	system.debug('***LeadDetails'+LeadDetails);
    	insert LeadDetails;
    	
    	PageReference pageRef = Page.FinancialWellness;
    	pageRef.setRedirect(true);
    	ApexPages.currentPage().getParameters().put('id', LeadDetails.Id);
    	
    	FinancialWellnessController financialWellness = new FinancialWellnessController();
    	financialWellness.Init();
    	financialWellness.showPopUp();
    	
    	financialWellness.dblFreedomScore = 0.0;
    	financialWellness.saveDetailsOfCustomer();
    	financialWellness.sendMail();
    	
    	Lead objLead = [Select Id, 
            				   Name,
            				   Email, 
            				   FirstName,
            				   LastName, 
            				   MobilePhone, 
            				   Age__c,
            				   Income_Source__c,
            				   Occupation__c 
            		    From Lead 
            		    Where Id =:LeadDetails.Id Limit 1];
    	
    	system.assertEquals(objLead.MobilePhone, '12345');
    	Test.stopTest();  // End Test
    }
   
  /*  
    //Verify Wellness Entity Created during Wellness Test 
    static testMethod void entityWellnessTest() {
        
        Test.startTest(); // Start  Test
        Account entityDetails = getAccount();
    	insert entityDetails;
    	
        PageReference pageRef = Page.FinancialWellness;
    	pageRef.setRedirect(true);
    	ApexPages.currentPage().getParameters().put('id', entityDetails.Id);
    	
    	FinancialWellnessController financialWellness = new FinancialWellnessController();
    	financialWellness.showPopUp();
    	financialWellness.dblFreedomScore = 0.0;
    	financialWellness.saveDetailsOfCustomer();
    	financialWellness.closePopup();
    	financialWellness.getIncomeTypes();
        Test.stopTest();  // End Test
    }
 */ 
 
     //Verify Exception Wellness Entity Created during Wellness Test 
    static testMethod void entitySecondTimeWellnessTest() {
        
        Test.startTest(); // Start  Test
        Account entityDetails = getAccount();
    	insert entityDetails;
    	
    	Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	    
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	    
	    List<Wellness_Score_Card__c> lstWellnessScoreCard = getWellnessScoreCardList(questionBank.Id ,entityDetails.Id);
	    insert lstWellnessScoreCard;
	    
	    Account objAccount = [Select Id,LastName,FirstName,PersonEmail,Age__c ,Phone From Account Where Id =:entityDetails.Id];
	    system.debug('****objAccount'+objAccount);
	    
        PageReference pageRef = Page.FinancialWellness;
    	pageRef.setRedirect(true);
    	ApexPages.currentPage().getParameters().put('id', objAccount.Id);
    	
    	FinancialWellnessController financialWellness = new FinancialWellnessController();
    	FinancialWellnessController.SelectQuestionAnswer selectQuetionAnswer = new FinancialWellnessController.SelectQuestionAnswer();
    	financialWellness.objActiveQuestionBank = questionBank;
    	financialWellness.lstQuestionnaire = lstQuestionnaire;
    	financialWellness.lstQuestions = lstQuestionBankList;
    	String nextPage = financialWellness.Init().getUrl(); 
    	financialWellness.queNo = 0;
    	
    	//System.assertEquals('/apex/WellnessThankYou?error=error', nextPage);
    	
        Test.stopTest();  // End Test
    }
    
     //Verify Exception Wellness Entity Created during Wellness Test 
    static testMethod void entityWithSecondTimeWellnessTest() {
        
        Test.startTest(); // Start  Test
        Account entityDetails = getAccount();
    	insert entityDetails;
    	
    	Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	    
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	    
	    List<Wellness_Score_Card__c> lstWellnessScoreCard = getWellnessScoreCardList(questionBank.Id ,entityDetails.Id);
	    lstWellnessScoreCard[0].Wellness_Test_Date__c = Date.today().addYears(-1);
	    lstWellnessScoreCard[1].Wellness_Test_Date__c = Date.today().addYears(-1);
	    insert lstWellnessScoreCard;
	    
	    Account objAccount = [Select Id,LastName,FirstName,PersonEmail,Age__c ,Phone From Account Where Id =:entityDetails.Id];
	    
        PageReference pageRef = Page.FinancialWellness;
    	pageRef.setRedirect(true);
    	ApexPages.currentPage().getParameters().put('id', objAccount.Id);
    	
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
    	
    	financialWellness.displayPopUp = true;
    	financialWellness.showPopUp();
    	financialWellness.saveDetailsOfCustomer();
    	financialWellness.sendMail();
    	financialWellness.closePopup();
    	
    	FinancialWellnessController financialWellnessNew = new FinancialWellnessController();
    	financialWellnessNew.showPopUp();
    	financialWellnessNew.saveDetailsOfCustomer();
    	financialWellnessNew.closePopup();
    	financialWellnessNew.getIncomeTypes();
        
        Test.stopTest();  // End Test
    }
   
     //Verify Exception Wellness Entity Created during Wellness Test 
    static testMethod void insertWellnessRelatedRecordTest() {
    	
		Test.startTest(); // Start  Test
	    Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	      
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	     
	    FinancialWellnessController financialWellness = new FinancialWellnessController();
    	FinancialWellnessController.SelectQuestionAnswer selectQuetionAnswer = new FinancialWellnessController.SelectQuestionAnswer();
    	
    	financialWellness.objActiveQuestionBank = questionBank;
    	financialWellness.lstQuestionnaire = lstQuestionnaire;
    	financialWellness.lstQuestions = lstQuestionBankList;
    	financialWellness.Init();
    	financialWellness.queNo = 0;
    	//financialWellness.lstOfQuestionAnswer[0].selectedAnswer = null;
    	
    	financialWellness.lstOfQuestionAnswer[0].selectedAnswer = lstQuestionOption[0].Id;
    	financialWellness.lstOfQuestionAnswer[1].selectedAnswer = lstQuestionOption[1].Id;
    	financialWellness.lstOfQuestionAnswer[financialWellness.lstOfQuestionAnswer.size()-1].isMultiChoice = false;
    	
    	financialWellness.queNo = financialWellness.lstOfQuestionAnswer.size()-1;
    	financialWellness.displayPopUp = true;
    	financialWellness.showPopUp();
    	financialWellness.objLead.FirstName = 'TestFirstName';
    	financialWellness.objLead.LastName = 'TestLastName';
    	financialWellness.objLead.MobilePhone = '9090909090';
    	financialWellness.objLead.Location__c = 'Pune';
    	financialWellness.objLead.Occupation__c = 'testOccupation';
    	financialWellness.objLead.Email = 'test@test.com';
    	financialWellness.saveDetailsOfCustomer();
    	financialWellness.closePopup();
    	financialWellness.closeWindow();
	    financialWellness.wellnessThankYou();
     		
     	Test.stopTest();  // End Test	
    }
   
    //Verify Wellness Score of Existing Lead which is converted into Entity  
    static testMethod void updateLeadWellnessTest() {
    	
    	Test.startTest(); // Start  Test
    	Lead LeadDetails = getLead();
    	insert LeadDetails;
    	
    	PageReference pageRef = Page.FinancialWellness;
    	pageRef.setRedirect(true); 
    	
	    Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	     
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	     
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
		financialWellness.displayPopUp = true;
		financialWellness.showPopUp();
		financialWellness.objLead.FirstName = 'TestFirstName';
		financialWellness.objLead.LastName = 'TestLastName';
		financialWellness.objLead.MobilePhone = '9090909090';
		financialWellness.objLead.Location__c = 'Pune';
		financialWellness.objLead.Occupation__c = 'testOccupation';
		financialWellness.objLead.Email = 'test@test.com';
		financialWellness.saveDetailsOfCustomer();
		financialWellness.closePopup();
    	
    	Lead objLead = [Select Id, 
            			       Name,
            				   Email, 
            				   FirstName,
            				   LastName, 
            				   MobilePhone, 
            				   Age__c,
            				   Income_Source__c,
            				   Occupation__c 
            		   From Lead 
            		   Where FirstName ='TestFirstName' Limit 1];
            		   
        objLead.Status = 'Coverted'; 
    	objLead.LeadSource = 'Web - Wellness';
    	update objLead;
    	
    	List<Wellness_Score_Card__c> lstWellnessScoreCard = getWellnessScoreCardForLeadList(questionBank.Id ,objLead.Id);
	    lstWellnessScoreCard[0].Wellness_Test_Date__c = Date.today().addYears(-1);
	    lstWellnessScoreCard[1].Wellness_Test_Date__c = Date.today().addYears(-1);
	    insert lstWellnessScoreCard;
    	
    	Lead updatedLead = [Select Id, 
            				  Name,
            				  Email, 
            				  FirstName,
            				  LastName, 
            				  MobilePhone, 
            				  Age__c,
            				  Status,
            				  LeadSource,
            				  Income_Source__c,
            				  Occupation__c 
            		   From Lead 
            		   Where Id =:objLead.Id Limit 1];
            		   
		Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(objLead.id);
		
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);
		
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		System.assert(lcr.isSuccess());
		System.debug('LeadConvertResult AccountId : '+ lcr.getAccountId());
		system.debug('***'+lcr.isSuccess());
		
		Account account = new Account();
		account = [Select Name, PersonEmail From Account Where Id =:lcr.getAccountId()];
	    system.debug('***account'+account);	
    	Test.stopTest();  // End Test
    }
    
    //Create Require Data for Account
    private static Account getAccount(){
    	
    	return new Account(LastName='Test LastName', 
    					   Entity_Status__c ='Active',
    					   Phone='123',
    					   Age__c = 23,
    					   PersonEmail = 'abc@gmail.com',
    					   Agreement_Received__c ='Yes',
    					   Category_Description__c ='Test');
    }
    
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
    
    //Create Require Data for Wellness_Score_Card__c List for Entity
    private static List<Wellness_Score_Card__c> getWellnessScoreCardList(Id pQuestionBankId, Id pRecordId){
    	
    	List<Wellness_Score_Card__c> lstWellnessScoreCard = new List<Wellness_Score_Card__c>();
    	Wellness_Score_Card__c wellnessScoreCard1 = new Wellness_Score_Card__c(
				    									Name = 'Test1',
				    									Account__c = pRecordId,
				    									Wellness_Test_Date__c = Date.today(),
				    								    Question_Bank__c = pQuestionBankId);
    									  
    	lstWellnessScoreCard.add(wellnessScoreCard1);								  
        Wellness_Score_Card__c wellnessScoreCard2 = new Wellness_Score_Card__c(
				    									Name = 'Test2',
				    									Account__c = pRecordId,
				    									Wellness_Test_Date__c = Date.today().addDays(2),
				    									Question_Bank__c = pQuestionBankId);
    									  
    	lstWellnessScoreCard.add(wellnessScoreCard2);
    	return lstWellnessScoreCard;
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
    
}