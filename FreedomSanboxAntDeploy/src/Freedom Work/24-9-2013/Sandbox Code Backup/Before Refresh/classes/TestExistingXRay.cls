@isTest
private class TestExistingXRay 
{
	static testMethod void ExistingXRayTest()
	{
		
        List<Questionnaire__c> lstQuestionnaire = new List<Questionnaire__c>();
		List<Question_Bank_List__c> lstQuesBankList = new List<Question_Bank_List__c>();
		List<Question_Option_List__c> lstQuesOptionList = new List<Question_Option_List__c>();
		List<Option_Detail__c> lstOptionsScorecards = new List<Option_Detail__c>();
		List<XRay_ScoreCard__c> lstScoreCardTest = new List<XRay_ScoreCard__c>();
		List<X_Ray_Score_Card_Detail__c> lstScoreCardDetailTest = new List<X_Ray_Score_Card_Detail__c>();
		Set<ID>setOfQuestionIds = new Set<ID>();
		/* Lead  */
    	
       	Question_Bank__c objQuestionBank = new Question_Bank__c ();
    	objQuestionBank.IsActive__c = true;  
    	insert objQuestionBank;
    	
    	/* Question_Bank_List__c  */
    	Question_Bank_List__c quesMasters1 = new Question_Bank_List__c();
    	quesMasters1.Question__c = 'Have you prepared a budget for household expenses?'; 
    	quesMasters1.Criteria__c = 'Yes';
    	quesMasters1.IsDummy__c = false;
    	quesMasters1.Question_Type__c = 'Yes/No';
    	insert quesMasters1;
    	lstQuesBankList.add(quesMasters1);
    	setOfQuestionIds.add(quesMasters1.Id);
    	
    	Question_Bank_List__c quesMasters2 = new Question_Bank_List__c();
    	quesMasters2.Question__c = 'If YES, do you follow your budgeting?'; 
    	quesMasters2.IsDummy__c = false;
    	quesMasters2.Question_Type__c = 'Yes/No';
    	quesMasters2.Master_Parent__c = quesMasters1.Id; 
    	quesMasters2.Parent_Question__c = quesMasters1.Id;
    	insert quesMasters2;
    	lstQuesBankList.add(quesMasters2);
    	setOfQuestionIds.add(quesMasters2.Id);
    	
    	Question_Bank_List__c quesMasters3 = new Question_Bank_List__c();
    	quesMasters3.Question__c = 'If YES, do you follow your budgeting?'; 
    	quesMasters3.IsDummy__c = false;
    	quesMasters3.Question_Type__c = 'Yes/No';
    	//quesMasters3.Master_Parent__c = quesMasters1.Id; 
    	//quesMasters3.Parent_Question__c = quesMasters1.Id;
    	insert quesMasters3;
    	lstQuesBankList.add(quesMasters3);
    	setOfQuestionIds.add(quesMasters3.Id);
    	
    	Question_Bank_List__c quesMasters4 = new Question_Bank_List__c();
    	quesMasters4.Question__c = 'If YES, do you follow your budgeting?'; 
    	quesMasters4.IsDummy__c = true;
    	quesMasters4.Question_Type__c = 'Multichoice';
    	//quesMasters3.Master_Parent__c = quesMasters1.Id; 
    	//quesMasters3.Parent_Question__c = quesMasters1.Id;
    	insert quesMasters4;
    	lstQuesBankList.add(quesMasters4);
    	setOfQuestionIds.add(quesMasters4.Id);
    	
    	Questionnaire__c objQuestionnaire1 = new Questionnaire__c();
    	objQuestionnaire1.Question_Bank__c = objQuestionBank.Id;
    	objQuestionnaire1.Question_Bank_List__c = quesMasters1.Id;
    	objQuestionnaire1.Display_Sequence__c = '1';
    	lstQuestionnaire.add(objQuestionnaire1); 
    	 
    	Questionnaire__c objQuestionnaire2 = new Questionnaire__c();
    	objQuestionnaire2.Question_Bank__c = objQuestionBank.Id;
    	objQuestionnaire2.Question_Bank_List__c = quesMasters3.Id;
    	objQuestionnaire2.Display_Sequence__c = '2';
    	lstQuestionnaire.add(objQuestionnaire2);
    	
    	Questionnaire__c objQuestionnaire3 = new Questionnaire__c();
    	objQuestionnaire3.Question_Bank__c = objQuestionBank.Id;
    	objQuestionnaire3.Question_Bank_List__c = quesMasters1.Id;
    	objQuestionnaire3.Display_Sequence__c = '3';
    	lstQuestionnaire.add(objQuestionnaire3); 
    	 
    	Questionnaire__c objQuestionnaire4 = new Questionnaire__c();
    	objQuestionnaire4.Question_Bank__c = objQuestionBank.Id;
    	objQuestionnaire4.Question_Bank_List__c = quesMasters4.Id;
    	objQuestionnaire4.Display_Sequence__c = '4';
    	lstQuestionnaire.add(objQuestionnaire4);
    	
    	if(!lstQuestionnaire.isEmpty())
    		insert lstQuestionnaire;
    	/* Question_Option_List__c */
    	Question_Option_List__c objQuesOptionList1 =  new Question_Option_List__c();
    	objQuesOptionList1.Name = 'Yes';
    	objQuesOptionList1.Score__c = 5;
    	objQuesOptionList1.Question_Bank_List__c = quesMasters1.Id;
    	insert objQuesOptionList1;
    	lstQuesOptionList.add(objQuesOptionList1); 
    	
    	Question_Option_List__c objQuesOptionList2 =  new Question_Option_List__c();
    	objQuesOptionList2.Score__c = 0;
    	objQuesOptionList2.Name = 'No';
    	objQuesOptionList2.Question_Bank_List__c = quesMasters1.Id;
    	insert objQuesOptionList2; 
    	lstQuesOptionList.add(objQuesOptionList2);
    	
    	Question_Option_List__c objQuesOptionList3 =  new Question_Option_List__c();
    	objQuesOptionList3.Name = 'Yes';
    	objQuesOptionList3.Score__c = 5;
    	objQuesOptionList3.Question_Bank_List__c = quesMasters2.Id;
    	insert objQuesOptionList3;
    	lstQuesOptionList.add(objQuesOptionList3);
	
    	Question_Option_List__c objQuesOptionList4 =  new Question_Option_List__c();
    	objQuesOptionList4.Name = 'No';
    	objQuesOptionList4.Score__c = 0;
    	objQuesOptionList4.Question_Bank_List__c = quesMasters2.Id;
    	insert objQuesOptionList4;
    	lstQuesOptionList.add(objQuesOptionList4);
    	
    	Question_Option_List__c objQuesOptionList5 =  new Question_Option_List__c();
    	objQuesOptionList5.Name = 'Yes';
    	objQuesOptionList5.Score__c = 5;
    	objQuesOptionList5.Question_Bank_List__c = quesMasters3.Id;
    	insert objQuesOptionList5;
    	lstQuesOptionList.add(objQuesOptionList5);
	
    	Question_Option_List__c objQuesOptionList6 =  new Question_Option_List__c();
    	objQuesOptionList6.Name = 'No';
    	objQuesOptionList6.Score__c = 0;
    	objQuesOptionList6.Question_Bank_List__c = quesMasters3.Id;
    	insert objQuesOptionList6;
    	lstQuesOptionList.add(objQuesOptionList6);
    	
    	Question_Option_List__c objQuesOptionList7 =  new Question_Option_List__c();
    	objQuesOptionList7.Name = 'Yes';
    	objQuesOptionList7.Score__c = 5;
    	objQuesOptionList7.Question_Bank_List__c = quesMasters4.Id;
    	insert objQuesOptionList7;
    	lstQuesOptionList.add(objQuesOptionList7);
	
    	Question_Option_List__c objQuesOptionList8 =  new Question_Option_List__c();
    	objQuesOptionList8.Name = 'No';
    	objQuesOptionList8.Score__c = 0;
    	objQuesOptionList8.Question_Bank_List__c = quesMasters4.Id;
    	insert objQuesOptionList8;
    	lstQuesOptionList.add(objQuesOptionList8);
    	
    	
    	/* X_Ray_Score_Card_Detail__c */
    	/* XRay_ScoreCard__c 
    	XRay_ScoreCard__c objXrayScore1 = new XRay_ScoreCard__c ();
    	objXrayScore1.Display_Sequence__c = 1;
    	objXrayScore1.Question_Bank_List__c = quesMasters1.Id;
    	objXrayScore1.XRayScoreCardMaster__c = ObjXrayScoreCardDetail.Id;
    	objXrayScore1.Score_Master__c = 5;   
    	insert objXrayScore1;
    	lstScoreCardTest.add(objXrayScore1);
    	
    	XRay_ScoreCard__c objXrayScore2 = new XRay_ScoreCard__c ();
    	objXrayScore2.Display_Sequence__c = 2;
    	objXrayScore2.Question_Bank_List__c = quesMasters2.Id;
    	objXrayScore2.XRayScoreCardMaster__c = ObjXrayScoreCardDetail.Id;
    	objXrayScore2.Score_Master__c = 5;   
    	insert objXrayScore2;
    	lstScoreCardTest.add(objXrayScore2);
    	
    	Option_Detail__c objOptions1 = new Option_Detail__c();
    	objOptions1.Answer__c = objQuesOptionList1.Id ;
    	objOptions1.XRayScoreCard__c=  objXrayScore1.Id;
    	lstOptionsScorecards.add(objOptions1);
    	
    	
    	Option_Detail__c objOptions2 = new Option_Detail__c();
    	objOptions2.Answer__c = objQuesOptionList3.Id;
    	objOptions2.XRayScoreCard__c=  objXrayScore2.Id;
    	lstOptionsScorecards.add(objOptions2);
    	
    	if(!lstOptionsScorecards.isEmpty())
    		insert lstOptionsScorecards;*/
    	
    	
    	Test.startTest();
    	Lead objLead = new Lead();
    	objLead.LastName = 'TestLastName';
    	objLead.LeadSource = 'Web';
    	objLead.MobilePhone = '9090909090';
    	insert objLead;
    	
    	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail.Question_Bank__c= objQuestionBank.Id;
    	ObjXrayScoreCardDetail.Lead__c = objLead.Id;
    	insert ObjXrayScoreCardDetail;
    	lstScoreCardDetailTest.add(ObjXrayScoreCardDetail);
    	
    	ExistingLeadXRay objExistingXRay = new ExistingLeadXRay(); 
    	objExistingXRay.leadId = objLead.Id;
    	 
    	objExistingXRay.Init();
    	objExistingXRay.objLead = objLead;
    	objExistingXRay.getQuestionAnswers(setOfQuestionIds);
    	objExistingXRay.Save();
    	objExistingXRay.parentId =quesMasters1.Id; 
    	objExistingXRay.resetAllChild();
    	
    	Account objAccount = new Account();
    	objAccount.LastName = 'testAccount';
    	objAccount.Entity_Status__c='Active';
    	objAccount.Agreement_Received__c ='Yes';
    	objAccount.Description = 'testDesc';
    	insert objAccount;
    	
    	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail1 = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail1.Question_Bank__c= objQuestionBank.Id;
    	ObjXrayScoreCardDetail1.Entity__c = objAccount.Id;
    	insert ObjXrayScoreCardDetail1;
    	
    	
    	XRay_ScoreCard__c objXrayScore1 = new XRay_ScoreCard__c ();
    	objXrayScore1.Display_Sequence__c = 1;
    	objXrayScore1.Question_Bank_List__c = quesMasters1.Id;
    	objXrayScore1.XRayScoreCardMaster__c = ObjXrayScoreCardDetail1.Id;
    	objXrayScore1.Score_Master__c = 5;   
    	insert objXrayScore1;
    	setOfQuestionIds.add(objXrayScore1.Id);
    	lstScoreCardTest.add(objXrayScore1);
    	
    	setOfQuestionIds = new Set<ID>();
    	XRay_ScoreCard__c objXrayScore2 = new XRay_ScoreCard__c ();
    	objXrayScore2.Display_Sequence__c = 2;
    	objXrayScore2.Question_Bank_List__c = quesMasters2.Id;
    	objXrayScore2.XRayScoreCardMaster__c = ObjXrayScoreCardDetail1.Id;
    	objXrayScore2.Score_Master__c = 5;   
    	insert objXrayScore2;
    	setOfQuestionIds.add(objXrayScore2.Id);
    	lstScoreCardTest.add(objXrayScore2);
    	
    	Option_Detail__c objOptions1 = new Option_Detail__c();
    	objOptions1.Answer__c = objQuesOptionList1.Id ;
    	objOptions1.XRayScoreCard__c=  objXrayScore1.Id;
    	lstOptionsScorecards.add(objOptions1);
    	
    	
    	Option_Detail__c objOptions2 = new Option_Detail__c();
    	objOptions2.Answer__c = objQuesOptionList3.Id;
    	objOptions2.XRayScoreCard__c=  objXrayScore2.Id;
    	lstOptionsScorecards.add(objOptions2);
    	
    	if(!lstOptionsScorecards.isEmpty())
    		insert lstOptionsScorecards;
    	
    	objExistingXRay = new ExistingLeadXRay();
    	objExistingXRay.entityId = objAccount.Id;
    	objExistingXRay.Init();
    	objExistingXRay.lstScoreCards = lstScoreCardTest;
    	objExistingXRay.setOfScoreCardIds = setOfQuestionIds;
    	//objExistingXRay.getQuestionAnswers(setOfQuestionIds);
    	//objExistingXRay.Save();
    	objExistingXRay.parentId =quesMasters1.Id;
    	objExistingXRay.resetAllChild(); 
    	Test.stopTest();
    	
    	
    	
    	/*Lead objLead1 = new Lead();
    	objLead1.LastName = 'TestLastName';
    	objLead1.LeadSource = 'Web';
    	objLead1.MobilePhone = '9090909090';
    	insert objLead1;
    	
    	objExistingXRay.objLead = objLead1;
    	objExistingXRay.Init();
    	objExistingXRay.parentId =quesMasters1.Id; 
    	objExistingXRay.resetAllChild();
    	objExistingXRay.getQuestionAnswers(setOfQuestionIds);
    	
    	objExistingXRay.leadId = objLead.Id;
    	objExistingXRay.Init(); */
    	
    }
}