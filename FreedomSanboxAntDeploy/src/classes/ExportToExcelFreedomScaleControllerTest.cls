/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *

 */
 
@isTest
private class ExportToExcelFreedomScaleControllerTest {

    static testMethod void ExportToExcelFreedomScaleTest() 
    {
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	//Insert RecordType record
    	List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
    	RecTypes__c objRecType = new RecTypes__c(Name='General_Business', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
    	RecTypes__c objRecType1 = new RecTypes__c(Name='AccountFamily', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
    	RecTypes__c objRecType2 = new RecTypes__c(Name='AccountClient', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
    	
    	lstRecTypes.add(objRecType);										 
    	lstRecTypes.add(objRecType1);
    	lstRecTypes.add(objRecType2);	
    	insert lstRecTypes;
    	
    	List<QuestionNoToQuestionName__c> lstQuestionSetting = new List<QuestionNoToQuestionName__c>();
    	
    	lstQuestionSetting.add(new QuestionNoToQuestionName__c(Name='Q1',QuestionNo__c = 1.0));
    	
    	insert lstQuestionSetting;
    	
    	//Insert smagicbasic SMS Template record 
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	
    	
    	//Insert Account record Related_To__c ='Ffreedom',
    	List<Account> lstAccount = new List<Account>();
    	Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', 
	                       Related_To__c = 'Ffreedom',
	                       RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true);
	                       
	    lstAccount.add(objAccount1);
	    lstAccount.add(objGeneralAccount);               
		insert lstAccount;
		
		Entity_Global_Assumption__c objGlobal = new Entity_Global_Assumption__c 
	    										(Expected_Return_on_Investment__c = 8,
	    										Income_Growth_Rate__c=14,
	                                  			Inflation_Rate__c=10,
	                                  			Account__c=lstAccount[0].Id,
	                                  			Number_Of_Months__c=50,
	                                  			Stock_Growth_Rate__c=14,
	                                  			Gold_Growth_Rate__c=10,
	                                  			IsChanged__c = false,
	                                  			Default_Estimated_Life_Expectancy__c='80',
	                                  			Default_Retirement_Age__c='60');    
	    insert objGlobal;                             			
		
		Question_Bank__c  questionBank =  getQuestionBank();
	    insert questionBank;	
	    
	    List<Question_Bank_List__c>  lstQuestionBankList = getQuestionBankList();
	    insert lstQuestionBankList;
	     
	    List<Questionnaire__c> lstQuestionnaire = getQuestionnaire(questionBank.Id , lstQuestionBankList[0].Id);
	    insert lstQuestionnaire;	
	     
	    List<Question_Option_List__c> lstQuestionOption =  getQuestionOptionList(lstQuestionBankList[0].Id);
	    insert lstQuestionOption;
	    
	    List<Wellness_Score_Card__c> lstWellnessScoreCard = getWellnessScoreCardForAccountList(questionBank.Id ,lstAccount[1].Id);
	    insert lstWellnessScoreCard;
	    
	    List<Wellness_Card_Detail__c> lstWellnessScoreCardDetail = getWellnessCardDetailList(lstWellnessScoreCard[0].Id ,lstQuestionOption[0].Id, lstQuestionBankList[0].Id);
	    insert lstWellnessScoreCardDetail;
	    
	    List<Wellness_Option_Detail__c> lstWellnessOptionDetails = getWellnessOptionDetailList(lstWellnessScoreCardDetail[0].Id ,lstQuestionBankList[0].Id);
	    insert lstWellnessOptionDetails;
	    
	    ExportToExcelFreedomScaleController objFreedomScale = new ExportToExcelFreedomScaleController();
	    ApexPages.currentPage().getParameters().put('entityid',objAccount1.Id);
	    
		ExportToExcelFreedomScaleController objFreedomScale1 = new ExportToExcelFreedomScaleController();
		
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
	    									  Name = 'Q1',
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
    private static List<Wellness_Score_Card__c> getWellnessScoreCardForAccountList(Id pQuestionBankId, Id pRecordId){
    	
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
    
    
    //Create Require Data for Wellness_Score_Card__c List for Lead
    private static List<Wellness_Option_Detail__c> getWellnessOptionDetailList(Id pWellnessScoreCardDetailsId , Id pQuestionBankListId)
    {
    	
    	List<Wellness_Option_Detail__c> lstWellnessOptionDetailList = new List<Wellness_Option_Detail__c>();
    	Wellness_Option_Detail__c wellnessOptionList = new Wellness_Option_Detail__c(
			    									    Name = 'Test1',
			    									    Answer_Text__c = 'No',
			    									    Wellness_card_Detail__c = pWellnessScoreCardDetailsId,
			    									    QuestionMaster__c = pQuestionBankListId);
			    									    
    									  
    	lstWellnessOptionDetailList.add(wellnessOptionList);								  
       
    	return lstWellnessOptionDetailList;
    }
    
}