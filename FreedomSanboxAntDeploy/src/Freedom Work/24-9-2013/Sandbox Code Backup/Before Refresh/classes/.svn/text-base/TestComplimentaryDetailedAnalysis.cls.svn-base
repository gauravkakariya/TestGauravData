@isTest
private class TestComplimentaryDetailedAnalysis
{ 
  static testMethod void ComplimentaryDetailedAnalysisTest() 
    {
      Test.startTest();
      List<Question_Option_List__c> lstQuesOptionList = new List<Question_Option_List__c>();
      List<Question_Bank_List__c> lstQuesBankList = new List<Question_Bank_List__c>();
      List<Questionnaire__c> lstQuestionnaire = new List<Questionnaire__c>();
      List<XRay_ScoreCard__c> lstScoreCardTest = new List<XRay_ScoreCard__c>();
      List<Option_Detail__c> lstOptionsScorecards = new List<Option_Detail__c>();
      
      /* Lead  */
      Lead objLead = new Lead();
      objLead.LastName = 'TestLastName';
      objLead.LeadSource = 'Web';
      objLead.MobilePhone = '9090909090';
      insert objLead;
      
      /* Question_Bank__c  */
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
      
      /* Questionnaire__c */
      Questionnaire__c objQuestionnaire1 = new Questionnaire__c();
      objQuestionnaire1.Question_Bank__c = objQuestionBank.Id;
      objQuestionnaire1.Question_Bank_List__c = quesMasters1.Id;
      objQuestionnaire1.Display_Sequence__c = '1';
      lstQuestionnaire.add(objQuestionnaire1); 
       
      Questionnaire__c objQuestionnaire2 = new Questionnaire__c();
      objQuestionnaire2.Question_Bank__c = objQuestionBank.Id;
      objQuestionnaire2.Question_Bank_List__c = quesMasters2.Id;
      objQuestionnaire2.Display_Sequence__c = '2';
      lstQuestionnaire.add(objQuestionnaire2);
      
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
      
      /*if(!lstQuesOptionList.isEmpty())
       insert lstQuesOptionList;*/
      
      /* X_Ray_Score_Card_Detail__c */
      X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail = new X_Ray_Score_Card_Detail__c();
      ObjXrayScoreCardDetail.Question_Bank__c= objQuestionBank.Id;
      ObjXrayScoreCardDetail.Lead__c = objLead.Id;
      insert ObjXrayScoreCardDetail;
      
      /* XRay_ScoreCard__c */
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
        insert lstOptionsScorecards;
      
       
      ComplimentaryDetailedAnalysis objCompDetailedAnalysis = new ComplimentaryDetailedAnalysis();
      objCompDetailedAnalysis.leadId = objLead.Id;
      objCompDetailedAnalysis.lstOptionDetails = lstOptionsScorecards;
      objCompDetailedAnalysis.Init();
      
      Test.stopTest();
    }  
    
    
     static testMethod void leadCoverageTest() 
    {
      Test.startTest();	
      
      ComplimentaryDetailedAnalysis cda = new ComplimentaryDetailedAnalysis();
      cda.Init();
       /* Lead  */
      Lead objLead = new Lead();
      objLead.LastName = 'TestLastName';
      objLead.LeadSource = 'Web';
      objLead.MobilePhone = '9090909090';
      insert objLead;
      
      Id clientRecId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
	  Account act = new Account(FirstName='ABC',LastName='XYZ',RecordTypeId=clientRecId);
	  insert act;
	 	
      Lead newLead = [Select Id From Lead Where Id = : objLead.Id];
      
      Pagereference pgRef= Page.GenerateAnalysis;
      pgRef.setRedirect(true);
      Attachment objAttach = new Attachment();
      if(newLead!= null)
      {
      	ApexPages.currentPage().getParameters().put('leadId', newLead.Id);
      	 objAttach.ParentId = newLead.Id;
      }	
      else
      {
      	ApexPages.currentPage().getParameters().put('entityId', act.Id);	
      	objAttach.ParentId = act.Id;
      	system.debug('********objAttach******'+objAttach);
      }
     // objAttach.Body = 'aaa';
    //  insert objAttach;
      
      //cda.createAnalysisAttachment();
  
     
      //objCompDetailedAnalysis.createAnalysisAttachment();
      Test.stopTest();
    }
}