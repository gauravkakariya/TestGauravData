@isTest(SeeAllData=true)
private class TestXRayWizardController 
{
	
	static testMethod void XRayWizardControllerTest() 
	{
		Test.startTest();
		List<Questionnaire__c> lstQuestionnaire = new List<Questionnaire__c>();
		List<Question_Bank_List__c> lstQuesBankList = new List<Question_Bank_List__c>();
		List<Question_Option_List__c> lstQuesOptionList = new List<Question_Option_List__c>();
		
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
    	
    	Question_Bank_List__c quesMasters2 = new Question_Bank_List__c();
    	quesMasters2.Question__c = 'If YES, do you follow your budgeting?'; 
    	quesMasters2.IsDummy__c = false;
    	quesMasters2.Question_Type__c = 'Yes/No';
    	quesMasters2.Master_Parent__c = quesMasters1.Id; 
    	quesMasters2.Parent_Question__c = quesMasters1.Id;
    	insert quesMasters2;
    	lstQuesBankList.add(quesMasters2);
    	
    	Question_Bank_List__c quesMasters3 = new Question_Bank_List__c();
    	quesMasters3.Question__c = 'If YES, do you follow your budgeting?'; 
    	quesMasters3.IsDummy__c = false;
    	quesMasters3.Question_Type__c = 'Yes/No';
    	//quesMasters3.Master_Parent__c = quesMasters1.Id; 
    	//quesMasters3.Parent_Question__c = quesMasters1.Id;
    	insert quesMasters3;
    	lstQuesBankList.add(quesMasters3);
    	
    	Question_Bank_List__c quesMasters4 = new Question_Bank_List__c();
    	quesMasters4.Question__c = 'If YES, do you follow your budgeting?'; 
    	quesMasters4.IsDummy__c = true;
    	quesMasters4.Question_Type__c = 'Multichoice';
    	//quesMasters3.Master_Parent__c = quesMasters1.Id; 
    	//quesMasters3.Parent_Question__c = quesMasters1.Id;
    	insert quesMasters4;
    	lstQuesBankList.add(quesMasters4);
    	
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
    		
    		
    		
    	XrayWizardController objXrayWizardController = new XrayWizardController();
    	
    	objXrayWizardController.objActiveQuestionBank = objQuestionBank;
    	objXrayWizardController.lstQuestionnaire = lstQuestionnaire;
    	objXrayWizardController.lstQuestions = lstQuesBankList;
    	objXrayWizardController.Init();
    	objXrayWizardController.queNo = 0;
    	objXrayWizardController.lstOfQuestionAnswer[0].selectedAnswer = null;
    	objXrayWizardController.goToNextQuestn();
    	objXrayWizardController.lstOfQuestionAnswer[0].selectedAnswer = objQuesOptionList1.Id;
    	objXrayWizardController.lstOfQuestionAnswer[objXrayWizardController.lstOfQuestionAnswer.size()-1].isMultiChoice = true;
    	objXrayWizardController.goToNextQuestn();
    	objXrayWizardController.queNo = objXrayWizardController.lstOfQuestionAnswer.size()-1;
    	objXrayWizardController.goToPrevQuestn();
    	objXrayWizardController.displayPopUp = true;
    	objXrayWizardController.showPopUp();
    	objXrayWizardController.saveDetailsOfCandidate();
    	objXrayWizardController.objLead.FirstName = 'TestFirstName';
    	objXrayWizardController.objLead.LastName = 'TestLastName';
    	objXrayWizardController.objLead.MobilePhone = '9090909090';
    	objXrayWizardController.objLead.Location__c = 'Pune';
    	objXrayWizardController.objLead.Occupation__c = 'testOccupation';
    	objXrayWizardController.objLead.Email = 'test@test.com';
    	objXrayWizardController.saveDetailsOfCandidate();
    	objXrayWizardController.closePopup();
    	//objXrayWizardController.saveDetailsOfCandidatewithoutScore();
    	Test.stopTest();	
    }
}