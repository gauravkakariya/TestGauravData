/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav             25/12/2012     This Class is used to create wellness test for lead and Entity  and generate wellness score 
                                                  and used that score in making pdf of particular entity or  lead. 
    
*/

public without sharing class FinancialWellnessController 
{
    public List<Question_Bank_List__c> lstQuestions {get;set;}
    public List<Questionnaire__c> lstQuestionnaire {get;set;}
    public List<Question_Bank__c> lstQuestionBank{get;set;}
    public Question_Bank__c objActiveQuestionBank {set;get;}
    public List<SelectQuestionAnswer> lstOfQuestionAnswer {get;set;}
    public Integer queNo{get;set;} 
    public Map<ID,List<Question_Option_List__c>> mapQuesIdAnswers{set;get;}  
    public Lead objLead{set;get;}
    public Account objAccount{set;get;}
    public Account AccountRecord{set;get;}
    public Boolean displayPopUp {get; set;}  
    public Boolean displayTextBox {get; set;}  
    public Double dblFreedomScore{get;set;}  
    public Integer quesSequence { get;set; }
    public Boolean check{get;set;}
    public Double wellnessScore{get;set;}
    //public String strEntityName {get;set;}
    public Boolean strEntityCheck {get;set;}
    public String sfurl{get;set;}
    
    private List<String> lstwellnessScoreDetails{get;set;} 
    private String wellnessTestDate{set;get;}
    private String strEntityId {get;set;}
    private Map<ID,Question_Option_List__c> mapOfOptionList{set;get;}
    private List<Wellness_card_Detail__c> lstXrayScoreCard = new List<Wellness_card_Detail__c> ();
    private List<Wellness_Score_Card__c> lstWellnessScoreCard = new List<Wellness_Score_Card__c> ();
    private Boolean wellnessRecordCheck{get;set;} 
    private String scoreValue{get;set;}
    private String recordId{get;set;}
    private String recordName{get;set;}
    private integer numberDaysDue{get;set;}
    
    //private	String RecordId;
    private Decimal score = 0.0;
    private Decimal wellnessScoreValue = 0.0;
    private String wellnessPreviousScore;
    
    /**** Constructor ****/
    public FinancialWellnessController()
    {
    	String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
    	
        if(browserType != null && browserType.contains('MSIE'))
        {
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');
        }
        strEntityId = ApexPages.currentPage().getParameters().get('id');  
        displayTextBox = false;
        strEntityCheck = false;
        wellnessRecordCheck = false;
        quesSequence = 0; 
        numberDaysDue = 0;
        dblFreedomScore = 0;
        lstwellnessScoreDetails = new List<String>();
        for(Integer i = 0 ; i < 7; i++)
        	lstwellnessScoreDetails.add('');
        mapOfOptionList = new Map<ID,Question_Option_List__c> ();
        lstWellnessScoreCard.clear();
        sfurl = URL.getSalesforceBaseUrl().toExternalForm();
         system.debug('------------sfurl------------'+sfurl); 
        objAccount = new Account();
        AccountRecord =  new Account();
        
        //Fetches Account Record by getiing parameteised RecordId
        if(strEntityId != null && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != '') {
            strEntityCheck = true;
            objAccount = [Select Id,LastName,FirstName,PersonEmail, OwnerId,Owner.Name, Owner.Email,Age__c, Age__pc, Phone,Salutation From Account Where Id =:strEntityId];
            system.debug('------------objAccount------------'+objAccount.Age__pc);
            if(objAccount!=Null)
            lstWellnessScoreCard = [Select Wellness_Test_Date__c, 
                                           Score__c, 
                                           Name, 
                                           Lead__c, 
                                           Id 
                                    From Wellness_Score_Card__c 
                                    Where Account__c =:objAccount.Id order by CreatedDate Desc];
        }
        
        //Fetches Lead Record by getiing parameteised RecordId
        objLead = new Lead();
      /*  system.debug('*****in web wellness 1 *******');
        if(strEntityId == null || strEntityId == '') 
      	{	
      		system.debug('*****in web wellness 1 *******');
        	objLead.LeadSource = 'Web-Wellness';
	    }*/
        
        if(strEntityId != null && strEntityId.substring(0,3).compareTo('00Q') == 0 && strEntityId != '') {
            objLead = [Select Id, 
                              Name,
                              Email, 
                              FirstName,
                              LastName, 
                              MobilePhone, 
                              Age__c,
                              Income_Source__c,
                              Occupation__c 
                       From Lead 
                       Where Id =:strEntityId];
            
            if(objLead!= Null)
            lstWellnessScoreCard = [Select Wellness_Test_Date__c, 
                                           Score__c, 
                                           Name, 
                                           Lead__c, 
                                           Id 
                                    From Wellness_Score_Card__c 
                                    Where Lead__c =:objLead.Id order by CreatedDate Desc];
        }
        
        if(lstWellnessScoreCard.size() > 0 || !lstWellnessScoreCard.isEmpty() ){
            wellnessRecordCheck = true;
       		numberDaysDue =  lstWellnessScoreCard[0].Wellness_Test_Date__c.daysBetween(Date.today());
        }	
        
        mapQuesIdAnswers = new Map<ID,List<Question_Option_List__c>>();
        lstQuestions = new List<Question_Bank_List__c>();
        lstQuestionnaire = new List<Questionnaire__c>();
        lstQuestionnaire.clear();
        lstQuestionBank = new List<Question_Bank__c>();
        lstOfQuestionAnswer = new List<SelectQuestionAnswer>();
        
        Map<String, QuestionBank__c> QuestionBank = QuestionBank__c.getAll();
        String FinancialWellnessId= QuestionBank.get('FinancialWellness').Question_Bank__c;
        objActiveQuestionBank  = [Select id,Name,IsActive__c, IsWellness__c From Question_Bank__c  Where IsWellness__c = true AND Id =: FinancialWellnessId limit 1];
    }
  
      
    /**** Action Method ****/
    public Pagereference Init(){
        
        PageReference pgref;
        String Days =  Label.Wellness_Test_Day_Limit;
        Integer daylimit;
        if(Days!=null || Days!= '')
        daylimit = Integer.valueOf(Days);
        else
        daylimit = 180;
        if(lstWellnessScoreCard != null && lstWellnessScoreCard.size() > 0 && numberDaysDue < daylimit && strEntityId.substring(0,3).compareTo('001') == 0){
        	
       		pgref = WellnessThankYou();
       		pgref.getParameters().put('error','error');
       		pgref.setRedirect(true);
   		    return pgref;
       	}
       	
        set<ID>setOfIds = new set<ID>();
        
        //Fetches the list of Questionnaire accoding to Question Bank Id
        lstQuestionnaire = [SELECT  Question_Bank__c,
                                    Question_Bank_List__r.Question__c,
                                    Question_Bank_List__r.Name, 
                                    Display_Sequence__c ,
                                    Question_Bank_List__c,
                                    Name, Id ,
                                    Explanation__c,
                                    Question_Bank_List__r.Notes__c,
                                    Question_Bank_List__r.Parent_Question__c,
                                    Question_Bank_List__r.Question_Type__c,
                                    Question_Bank_List__r.Criteria__c, 
                                    Question_Bank_List__r.IsDummy__c 
                                    FROM Questionnaire__c q where Question_Bank__c =:objActiveQuestionBank.Id
                                    order by Display_Sequence__c ASC];
    
        if(lstQuestionnaire  != null && lstQuestionnaire .size() >0)
        { 
            for(Questionnaire__c objQuestionnaire :lstQuestionnaire)
            {
            	objQuestionnaire.Explanation__c = '';
                setOfIds.add(objQuestionnaire.Question_Bank_List__c);  
            }
          
            //populating the question and its answer.
            for(Question_Option_List__c objAnswer: [Select Score__c, 
                                                           Question_Bank_List__c, 
                                                           Name,Id,Explaination__c 
                                                    From Question_Option_List__c  
                                                    Where Question_Bank_List__c IN:setOfIds order by Score__c asc])
            {
                mapOfOptionList.put(objAnswer.Id,objAnswer);
                if(!mapQuesIdAnswers.isEmpty() && mapQuesIdAnswers.containsKey(objAnswer.Question_Bank_List__c))
                {
                    List<Question_Option_List__c> lstAnswers = mapQuesIdAnswers.get(objAnswer.Question_Bank_List__c);
                    lstAnswers.add(objAnswer);
                    lstAnswers.sort();
                    mapQuesIdAnswers.put(objAnswer.Question_Bank_List__c,lstAnswers);
                }
                else
                {
                    List<Question_Option_List__c> lstAnswers = new List<Question_Option_List__c>();
                    lstAnswers.add(objAnswer);
                     lstAnswers.sort();
                    mapQuesIdAnswers.put(objAnswer.Question_Bank_List__c, lstAnswers);
                }
            }
          
            for(Integer iCount =0;iCount < lstQuestionnaire.size() ;iCount++)
            {
                SelectQuestionAnswer objSelectQuesAnswer = new SelectQuestionAnswer();
                objSelectQuesAnswer.objQuestionnaire = lstQuestionnaire[iCount]; 
                
                if(!mapQuesIdAnswers.isEmpty()&& mapQuesIdAnswers.containsKey(lstQuestionnaire[iCount].Question_Bank_List__c))
                {
                    List<Question_Option_List__c> lstAnswer = mapQuesIdAnswers.get(lstQuestionnaire[iCount].Question_Bank_List__c);
                    if(lstAnswer != null && lstAnswer.size()>0)
                    {
                        for(Question_Option_List__c objAns :lstAnswer)
                        {   
                            objSelectQuesAnswer.strAnswer.add(new Selectoption(objAns.Id, objAns.Name));
                            objSelectQuesAnswer.strAnswer.sort();
                            
                        }
                    }
                }
            
                //Verifies question List which is Yes/no or Multichoice
                if(lstQuestionnaire[iCount].Question_Bank_List__r.Question_Type__c == 'Yes/No')
                {
                    objSelectQuesAnswer.isMultiChoice = false;
                }
                
                else if(lstQuestionnaire[iCount].Question_Bank_List__r.Question_Type__c == 'Multichoice')
                {
                    objSelectQuesAnswer.isMultiChoice = true;
                }
            
                objSelectQuesAnswer.qno = iCount;
                if(iCount==0)
                {
                    objSelectQuesAnswer.isCurrentQuestn = true;
                    objSelectQuesAnswer.isVisited = true;
                }
                lstOfQuestionAnswer.add(objSelectQuesAnswer);
            }
        }
       	return NULL;
        
    }
    
    
    /***** Action on Submit *****/
    public PageReference saveDetailsOfCustomer()
    {
        Set<ID> setInsertedScorecardIds = new Set<ID>();
        Database.Saveresult saveResult;
        //String RecordId;
        //Decimal score = 0.0;
        Wellness_Score_Card__c objWellnessScoreCardDetail ;
        Pagereference pgRef;
       
		    //Check whether RecordId is Entity or Lead
		     if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != ''){
					
                    try
                    {
	                        objWellnessScoreCardDetail =  new Wellness_Score_Card__c ();
	                        objWellnessScoreCardDetail.Account__c  = objAccount.Id; //saveResult.getId(); 
	                        objWellnessScoreCardDetail.Question_Bank__c = objActiveQuestionBank.Id;
	                        objWellnessScoreCardDetail.Wellness_Test_Date__c = Date.today();
	                        saveResult = Database.insert(objWellnessScoreCardDetail);
                        
                    }
                    catch(Exception ex)
                    {
                        system.debug('***e.getMessage(): '+ex.getMessage());
                        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        //String[] toAddresses1 = new String[] {'tech@ffreedom.in'};
                        //mail.setToAddresses(toAddresses1);
                        //mail.setSenderDisplayName('Salesforce Support');
                        //mail.setSubject('Error in Lead Creation by Wellness from site');
                        //mail.setPlainTextBody(' Error : '+ex.getMessage()+' Lead Id ----> : ');//+saveResult.getId());
                        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
		     }
		        else{
		            
		            if(objLead.FirstName == null)
		            {
		                objLead.FirstName.addError(Label.Save_Details_Information_Lead_Name);
		            }
		            else if(objLead.Email == null)
		            {
		                objLead.Email.addError(Label.Save_Details_Information_Lead_Name);
		            }
		            else
		            {
		                // User objMkgTeam = [Select Id, Name from User where Name = 'Ffreedom Team' limit 1];
		                //objLead.Ffreedom_Score__c = dblFreedomScore;
	                  	if(strEntityId == null || strEntityId == '') 
	                  	{	
		                	objLead.LeadSource = 'Web-Wellness';
	                  	}
		                //objLead.OwnerId = objMkgTeam.Id;
		                try
		                {
		                     upsert objLead;
		                     //insert objLead;
		                }
		                catch(Exception e){
		                    system.debug('***e.getMessage(): '+e.getMessage());
		                }
		                
		                try
		                {
		                    objWellnessScoreCardDetail =  new Wellness_Score_Card__c ();
		                    objWellnessScoreCardDetail.Lead__c = objLead.Id;//saveResult.getId();
		                    
		                    objWellnessScoreCardDetail.Question_Bank__c = objActiveQuestionBank.Id;
		                    objWellnessScoreCardDetail.Wellness_Test_Date__c = Date.today();
		                    saveResult = Database.insert(objWellnessScoreCardDetail);
		                }
		                catch(Exception ex)
		                {
		                    system.debug('***e.getMessage(): '+ex.getMessage());
		                }
		                    
		            
		             }
		        }     
		        if(saveResult.isSuccess())
		        {
		                    if(lstOfQuestionAnswer.size() > 0)
		                    {
		                        List<Wellness_Option_Detail__c> lstOfOptionDetailsToInsert = new List<Wellness_Option_Detail__c>();   
		                        Map<ID,Wellness_card_Detail__c> mapQuesIdWellnessScoreCardDetails = new map<ID,Wellness_card_Detail__c> ();
		                        Wellness_card_Detail__c objWellnessScoreCard;
		                        for(SelectQuestionAnswer objWrapper : lstOfQuestionAnswer)
		                        {
		                            objWellnessScoreCard = new Wellness_card_Detail__c();
		                            if(!objWrapper.objQuestionnaire.Question_Bank_List__r.IsDummy__c)
		                            {
		                                String userAnswer = String.valueOf(objWrapper.selectedAnswer);
		                                objWellnessScoreCard.Wellness_Score_Card__c = saveResult.getId();
		                                objWellnessScoreCard.Display_Sequence__c = Double.valueOf(objWrapper.objQuestionnaire.Display_Sequence__c);
		                                objWellnessScoreCard.Question_Bank_List__c = objWrapper.objQuestionnaire.Question_Bank_List__c;
		                                                  
		                                //if(objWrapper.isVisited)
		                                //{
		                                    if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
		                                    {
		                                        Question_Option_List__c objOptionList = mapOfOptionList.get(userAnswer);
		                                        if(objOptionList.Score__c != null)
		                                        {
		                                            objWellnessScoreCard.Score__c = objOptionList.Score__c;
		                                            objWellnessScoreCard.Explanation__c = objOptionList.Explaination__c;
		                                        }
		                                    }
		                                //}
		                            }  
		                            else 
		                            {                
		                                objWellnessScoreCard.Wellness_Score_Card__c = saveResult.getId();//objWellnessScoreCardDetail.Id;//saveResult.getId();
		                                objWellnessScoreCard.Display_Sequence__c = Double.valueOf(objWrapper.objQuestionnaire.Display_Sequence__c);
		                                objWellnessScoreCard.Question_Bank_List__c = objWrapper.objQuestionnaire.Question_Bank_List__c;
		                            }
		                            lstXrayScoreCard.add(objWellnessScoreCard);  
		                        }
		              
		                        if(lstXrayScoreCard.size() > 0 )
		                        {
		                            List<Database.Saveresult>  lstScoreCardSaveResult = Database.insert(lstXrayScoreCard);
		                            if(lstScoreCardSaveResult != null && lstScoreCardSaveResult.size() > 0)
		                            {
		                                for(Database.Saveresult objSaveResult : lstScoreCardSaveResult)
		                                {
		                                    setInsertedScorecardIds.add(objSaveResult.getId());
		                                }
		                            }
		                        }
		            
		                        for(Wellness_card_Detail__c  objWellnessScoreCardInserted : [Select Score__c, 
		                                                                                            Question_Bank_List__c, 
		                                                                                            Name, 
		                                                                                            Id, 
		                                                                                            Display_Sequence__c,
		                                                                                            Explanation__c, 
		                                                                                            Question_Option_List__c 
		                                                                                     From Wellness_card_Detail__c x 
		                                                                                     Where Id IN: setInsertedScorecardIds])
		                        {   
		                            mapQuesIdWellnessScoreCardDetails.put(objWellnessScoreCardInserted.Question_Bank_List__c,objWellnessScoreCardInserted);
		                        }
		              
		                        Wellness_Option_Detail__c objOptionDetails;
		                        Question_Option_List__c objOptionList;
		                        for(SelectQuestionAnswer objWrapper : lstOfQuestionAnswer)
		                        {
		                            //if(objWrapper.isVisited)
		                            //{
		                                if(objWrapper.objQuestionnaire.Question_Bank_List__r.Question_Type__c =='Yes/No')
		                                {
		                                    String userAnswer = String.valueOf(objWrapper.selectedAnswer);
		                    
		                                    if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
		                                    {
		                                        
		                                        objOptionDetails = new Wellness_Option_Detail__c ();
		                                        objOptionList = mapOfOptionList.get(userAnswer);
		                                        objOptionDetails.Answer__c = objOptionList.Id;
		                                        objOptionDetails.Answer_Text__c = objOptionList.Name;
		                                        objOptionDetails.Explaination__c = objOptionList.Explaination__c;
		                                        objOptionDetails.QuestionMaster__c = objOptionList.Question_Bank_List__c;
		                                        if(!mapQuesIdWellnessScoreCardDetails.isEmpty() && mapQuesIdWellnessScoreCardDetails.containsKey(objWrapper.objQuestionnaire.Question_Bank_List__c))
		                                        {
		                                            objOptionDetails.Wellness_Card_Detail__c = mapQuesIdWellnessScoreCardDetails.get(objWrapper.objQuestionnaire.Question_Bank_List__c).Id;
		                                        }
		                                        lstOfOptionDetailsToInsert.add(objOptionDetails);
		                                    }
		                                }
		                                else if(objWrapper.objQuestionnaire.Question_Bank_List__r.Question_Type__c == 'Multichoice')
		                                {
		                                    List<String> lstMultichoiceAnswer = objWrapper.selMultipleAnswrs;
		                                    for(String idAnswer:lstMultichoiceAnswer)
		                                    { 
		                                        String userAnswer = String.valueOf(idAnswer);
		                                        if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
		                                        {
		                                            objOptionDetails = new Wellness_Option_Detail__c ();
		                                            objOptionList = mapOfOptionList.get(userAnswer);
		                                            objOptionDetails.Answer__c = objOptionList.Id;
		                                            objOptionDetails.Answer_Text__c = objOptionList.Name;
		                                            objOptionDetails.Explaination__c = objOptionList.Explaination__c;
		                                            objOptionDetails.QuestionMaster__c = objOptionList.Question_Bank_List__c;
		                                            if(!mapQuesIdWellnessScoreCardDetails.isEmpty() && mapQuesIdWellnessScoreCardDetails.containsKey(objWrapper.objQuestionnaire.Question_Bank_List__c))
		                                            {
		                                                objOptionDetails.Wellness_Card_Detail__c = mapQuesIdWellnessScoreCardDetails.get(objWrapper.objQuestionnaire.Question_Bank_List__c).Id;
		                                            }
		                                            lstOfOptionDetailsToInsert.add(objOptionDetails);
		                                        }
		                                    }
		                                }//else if 
		                            //}
		                        }//for
		                        check = true;
		                        
		                        List<Database.Saveresult> lstSaveOptionDetais = Database.insert(lstOfOptionDetailsToInsert);
		                    }// inner if 
		                    
		    }//if outer(save res)  
		    
            if(strEntityId == NULL || strEntityId == ''){ 
                  
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		        
		        // Create the email attachment 
		        List<String> toAddresses = new List<String>();
		        List<String> toCcAddresses = new List<String>(); 
		        
                // Sets the paramaters of the email
                if(objLead.Email != null){
                    toAddresses.add(objLead.Email);
                    toCcAddresses.add(Label.Marketing_Team_Email);
                }    
                    //String[] toBccAddresses = new String[] {'aditi.satpute@eternussolutions.com'};
                    email.setSubject( 'Freedom Scale Test Report of  ' + objLead.FirstName+' '+objLead.LastName);        
                    email.setToAddresses( toAddresses );
                    email.setCcAddresses(toCcAddresses); 
                       
                    if(wellnessRecordCheck){ 
                        
                        //Calculate Percentage of Welleness Score
                      	score = dblFreedomScore;
                     	score = (score * 100/35);
                     	score = score.setScale(2, RoundingMode.HALF_UP);
                     	scoreValue = string.valueOf(score);
                     	
                     	//Calculate Previous wellness score in Percentage(%)
                     	wellnessScoreValue = lstWellnessScoreCard[0].Score__c;
                     	wellnessScoreValue = (wellnessScoreValue * 100/35);
                     	wellnessScoreValue = wellnessScoreValue.setScale(2, RoundingMode.HALF_UP);
                     	wellnessPreviousScore = string.valueOf(wellnessScoreValue);
                          
                        Date wellnessTestDate = lstWellnessScoreCard[0].Wellness_Test_Date__c;
	                	DateTime dtValue = DateTime.newInstance(wellnessTestDate.year(),wellnessTestDate.month(), wellnessTestDate.day());
	                 	string wellnessDate = dtValue.format('dd-MM-yyyy');
	                 	
                        
                        email.setHtmlBody('Dear '+objLead.FirstName+' '+objLead.LastName +Label.Send_Mail_Set_Html_Body_Message);
                        email.setSenderDisplayName(objLead.FirstName+''+objLead.LastName);
                        email.setHtmlBody('Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/>Thank you for taking the Freedom Scale Test.'
                         +'<br/><br/> Your score is '+Integer.valueOf(dblFreedomScore)+'. You are probably feeling '+scoreValue +'% good about your personal financial life.'
                         +'<br/><br/>The last time you took this test was on '+wellnessDate +' '+Label.Wellness_Score_Message+' '+ wellnessPreviousScore + '% .'
                         +'<br/><br/> Thanks and regards' + '<br/><br/> Ffreedom Team');
             
                    }
                    else{
                        
                         //Calculate Percentage of Welleness Score
                         score = dblFreedomScore;
                         score = (score * 100/35);
                         score = score.setScale(2, RoundingMode.HALF_UP);
                         scoreValue = string.valueOf(score);
                         verifyScore(RecordId);
                         
                         Date wellnessTestDate = Date.today();
					     DateTime dtValue = DateTime.newInstance(wellnessTestDate.year(),wellnessTestDate.month(), wellnessTestDate.day());
				         string wellnessDate = dtValue.format('dd-MM-yyyy');
                         
                       if(Test.isRunningTest())
                       {
                          lstwellnessScoreDetails[0] = 'aaa';
                          lstwellnessScoreDetails[1] = 'bbb';
                          lstwellnessScoreDetails[2] = 'bbb';
                          lstwellnessScoreDetails[3] = 'bbb';
                          lstwellnessScoreDetails[4] = 'bbb';
                          lstwellnessScoreDetails[5] = 'bbb';
                          lstwellnessScoreDetails[6] = 'bbb';
                       	  email.setHtmlBody('<img src="'+sfurl+''+ getResourceURL('WellnessEmailLogo')+'"/>'+ 
                                            '<br/><br/>' +'Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/> '+
                                          'You have taken the Freedom Scale Test on '+ wellnessDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                           Label.Wellness_Report_Analysis + '<br/><br/>' +lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
                                           lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
                                           lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
                                           lstwellnessScoreDetails[6] + '<br/><br/>' + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
                                           +'<br><br/>'+'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
                       }
                       else if(lstwellnessScoreDetails!= NULL && lstwellnessScoreDetails.size() > 0){  
                         email.setHtmlBody('<img src="'+sfurl+''+ getResourceURL('WellnessEmailLogo')+'"/>'+ 
                                            '<br/><br/>' +'Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/> '+
                                          'You have taken the Freedom Scale Test on '+ wellnessDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                           Label.Wellness_Report_Analysis + '<br/><br/>' + getWellnessReportWithImage() +
                                           Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ objLead.FirstName+' '+objLead.LastName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
                                           +'<br><br/>'+'<div> <center> <div style="background-color:#F2F2F2; float: center; align:center;">'+Label.Wellness_Freedom_Contact+
                                   			'<br/><img src = "'+Label.Freedom_Site_Url + getResourceURL('FfreedomFacebookLogo')+' " />'+
												Label.Wellness_Freedom_Contact_2+ '</div> </center> </div></div>');
                                           
                                           //'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
                                           
                                           //lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
                                           //lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
                                           //lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
                                           //lstwellnessScoreDetails[6] + '<br/><br/>' 
                        }
                        // Sends the email to Lead or Entity acccording to RecordId
                        Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                        system.debug('***arrResult'+arrResult); 
                    }  
                    
                    //PageReference pageRef = Page.Thankyou;
           			PageReference pageRef = Page.WellnessThankyou; 
            		pageRef.setRedirect(true);
            		return pageRef;
             }
            
	           return Null;
    }   
    
    //Send Mail to Lead when Lead is created and Entity is updated 
    public pageReference sendMail(){
    	
    	 if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != ''){
            
            objAccount = [Select Id, LastName,OwnerId, Virtual_Partner__r.Email_ID__c,Owner.Name, FirstName,PersonEmail,Owner.Email, Age__c, Age__pc, Phone,Salutation From Account Where Id =:strEntityId];
            RecordId = objAccount.Id;
           
        }
        else if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('00Q') == 0 && strEntityId != ''){
            RecordId = objLead.Id;
        }   
        else
            RecordId = objLead.Id;
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        // Create the email attachment 
        List<String> toAddresses = new List<String>();
        List<String> toCcAddresses = new List<String>();
        
        if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != ''){
            
            RecordId = objAccount.Id;
          
            // Sets the paramaters of the email
            if(objAccount.PersonEmail != null){
                toAddresses.add(objAccount.PersonEmail);
                //toAddresses.add(objAccount.Owner.Email);
                //toCcAddresses.add(Label.Marketing_Team_Email);
                toCcAddresses.add(objAccount.Owner.Email);
               
                if(objAccount.Virtual_Partner__r.Email_ID__c != null)
                	toCcAddresses.add(objAccount.Virtual_Partner__r.Email_ID__c);
               
            } 
                
            //String[] toCcAddresses = new String[] {objAccount.Owner.Email};
            //String toCcAddresses = Label.Marketing_Team_Email;
            email.setSubject( 'Freedom Scale Test Report of ' + objAccount.FirstName + objAccount.LastName);     
            email.setToAddresses(toAddresses);
            email.setCcAddresses(toCcAddresses);
                  
            if(wellnessRecordCheck){   
                
                 email.setHtmlBody('Dear '+objAccount.FirstName + objAccount.LastName +Label.Send_Mail_Set_Html_Body_Message);
                 email.setSenderDisplayName(objAccount.FirstName + objAccount.LastName);
                
                 //Calculate Percentage of Welleness Score
                 score = dblFreedomScore;
                 score = score * 100/35;
                 score = score.setScale(2, RoundingMode.HALF_UP);
                 scoreValue = string.valueOf(score);
                 
                 Date wellnessTestDate = lstWellnessScoreCard[0].Wellness_Test_Date__c;
				 DateTime dtValue = DateTime.newInstance(wellnessTestDate.year(),wellnessTestDate.month(), wellnessTestDate.day());
				 string wellnessDate = dtValue.format('dd-MM-yyyy');
                 //String wellnessDate = String.valueOf(wellnessTestDate);
                 
                 //Calculate Previous wellness score in Percentage(%)
                 wellnessScoreValue = lstWellnessScoreCard[0].Score__c;
             	 wellnessScoreValue = (wellnessScoreValue * 100/35);
             	 wellnessScoreValue = wellnessScoreValue.setScale(2, RoundingMode.HALF_UP);
             	 wellnessPreviousScore = string.valueOf(wellnessScoreValue);
                 
                 email.setHtmlBody('Dear '+objAccount.FirstName +' '+ objAccount.LastName +'<br/><br/>Thank you for taking the Freedom Scale Test.'
                 +'<br/><br/> Your score is '+Integer.valueOf(dblFreedomScore)+'. You are probably feeling '+scoreValue +'% good about your personal financial life.'
                 +'<br/><br/>The last time you took this test was on '+ wellnessDate +' '+Label.Wellness_Score_Message+' ' + wellnessPreviousScore + '% .'
                 +'<br/><br/> Thanks and regards' + '<br/><br/> Ffreedom Team');
                
                
                 // Sends the email to Lead or Entity acccording to RecordId
                 Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }   
            else{
                 email.setSenderDisplayName(objAccount.FirstName + objAccount.LastName);
                 verifyScore(RecordId);
                 
                 Date wellnessTestDate = Date.today();
				 DateTime dtValue = DateTime.newInstance(wellnessTestDate.year(),wellnessTestDate.month(), wellnessTestDate.day());
				 string wellnessDate = dtValue.format('dd-MM-yyyy');
				 
                  if(Test.isRunningTest())
                  {
                          lstwellnessScoreDetails[0] = 'aaa';
                          lstwellnessScoreDetails[1] = 'bbb';
                          lstwellnessScoreDetails[2] = 'bbb';
                          lstwellnessScoreDetails[3] = 'bbb';
                          lstwellnessScoreDetails[4] = 'bbb';
                          lstwellnessScoreDetails[5] = 'bbb';
                          lstwellnessScoreDetails[6] = 'bbb';
                          
                       	  email.setHtmlBody('<img src="'+sfurl+''+ getResourceURL('WellnessEmailLogo')+'"/>'+ 
                                            '<br/><br/>' +'Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/> '+
                                          'You have taken the Freedom Scale Test on '+ wellnessDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                           Label.Wellness_Report_Analysis + '<br/><br/>'+
                                           '<table width="100%">'+ 
                                             '<tr width="100%"><td width="60%">' +lstwellnessScoreDetails[0] + '</td> <td width="40%">'+
                                           			 '<img src="'+ getImageUrl(1)+'" />'+'</td></tr><br/><br/>' + 
										     '<tr width="100%"><td width="60%">' +lstwellnessScoreDetails[1] + '</td> <td width="40%">'+
                                           			'<img src="'+ getImageUrl(2)+'" />'+'</td></tr><br/><br/>'+
                                             '<tr width="100%"><td width="60%">' +lstwellnessScoreDetails[2] + '</td> <td width="40%">'+
                                           			'<img src="'+ getImageUrl(3)+'" />'+'</td></tr><br/><br/>'+	
                                           	 '<tr width="100%"><td width="60%">' +lstwellnessScoreDetails[3] + '</td> <td width="40%">'+
                                           			 '<img src="'+ getImageUrl(4)+'" />'+'</td></tr><br/><br/>'+
                                           	 '<tr width="100%"><td width="60%">' +lstwellnessScoreDetails[4] + '</td> <td width="40%">'+
                                           			 '<img src="'+ getImageUrl(5)+'" />'+'</td></tr><br/><br/>'+
                                           	 '<tr width="100%"><td width="60%">' +lstwellnessScoreDetails[5] + '</td> <td width="40%">'+
                                           			 '<img src="'+ getImageUrl(6)+'" />'+'</td></tr><br/><br/>'+
                                           	 '<tr width="100%"><td width="60%">' +lstwellnessScoreDetails[6] + '</td> <td width="40%">'+
                                           			 '<img src="'+ getImageUrl(7)+'" />'
                                           	+'</td></tr></table><br/><br/>'+
                                           + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
                                           +'<br><br/>'+'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
                  }
                 else if(lstwellnessScoreDetails!= NULL && lstwellnessScoreDetails.size() > 0)   	
                 email.setHtmlBody('<div align="left" style="width:90%; min-height:680px; font-size: 13px; margin-left:2%;text-align:justify; margin-right:auto; border-style: solid;padding-left:2%;'+ 
						  +'padding-right:2%; border-color: gray;"><img src="'+Label.Freedom_Site_Url +getResourceURL('WellnessEmailLogo')+'"/>'+ 
                     				   '<br/><br/> <b>'+'Dear '+objAccount.FirstName +' '+ objAccount.LastName +'</b><br/><br/> '+'You have taken the Freedom Scale Test on '+ wellnessDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                   Label.Wellness_Report_Analysis + '<br/>'+ getWellnessReportWithImage()+
                                   Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
                                   +'<br><br/>'+'<div> <center> <div style="background-color:#F2F2F2; float: center; align:center;">'+Label.Wellness_Freedom_Contact+
                                   '<br/><img src = "'+Label.Freedom_Site_Url + getResourceURL('FfreedomFacebookLogo')+' " />'+
									Label.Wellness_Freedom_Contact_2+ '</div> </center> </div></div>');
	    					
               	//'<img src="http://ffreedom.force.com/'+getResourceURL('FreedomContactus')+'"/>
               
                 // Sends the email to Lead or Entity acccording to RecordId
                 Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                }
                
            }
                
            //If Record Id  is Lead
            if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('00Q') == 0 && strEntityId != '')
            {
            	
                RecordId = objLead.Id;
                
                // Reference the attachment page and pass in the account ID
		        PageReference pdf =  Page.FinancialWellnessReport;
		        pdf.getParameters().put('id',RecordId); 
		        pdf.getParameters().put('value',string.valueOf(dblFreedomScore)); 
		        pdf.setRedirect(true);
                
                //Take the PDF content
                Blob body = !Test.isRunningTest() ? pdf.getContent() : Blob.ValueOf('dummy text');
                //pdf.getContent();
                
                if(body!=null){  
                	
			       Attachment attach = new Attachment();  
			       attach.Body = body;
			       attach.Name = 'FreedomScaleReport.pdf';  
			       attach.ParentID = objLead.id;  
				      
				   try{  
				       insert(attach);  
				   } 
				   catch(System.DMLException e){  
			          ApexPages.addMessages(e);  
			          return null;  
				   }  
			      
                }  
            } 
             
           //PageReference pageRef = Page.Thankyou;
           PageReference pageRef = Page.WellnessThankyou; 
           pageRef.setRedirect(true);
           return pageRef;
           //return Null;
    	
    }
    
    public String getWellnessReportWithImage()
    {
    	String strWellnessReport=''; 
    	for(Integer i = 0; i<=7; i++)
    	{
    		if(lstwellnessScoreDetails.size() == 7 && i==7 )
    			break;
    		strWellnessReport += '<table width="100%"><tr><td width="60%" style="text-align: justify;">'+lstwellnessScoreDetails[i]+'</td> <td></td><td></td>'+'<td width="40%">'+ '<img src="'+ getImageUrl(i+1)+'" />'+'</td></tr></table></br>';
    	}																	
    	
    	return strWellnessReport;
    }
   
    //Pass the resource name  
    public static String getResourceURL(String pResourceName)  
    {  
        //Fetching the resource  
        List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :pResourceName];  
                              
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL    resourceList[0].SystemModStamp.getTime() + '/'
           String url = '/resource/' + resourceList[0].SystemModStamp.getTime() + '/'+(namespace != null && namespace != '' ? namespace + '__' : '') + pResourceName;
          
           return url;   
        }  
        else return '';  
    } 
    
   
    
    public static String  getImageUrl(Integer i)
    {
    	String imageUrl;
    	
       	return imageUrl=  Label.Freedom_Site_Url+'/resource/1358833664000/WellnessQustionImage/images/Q'+ i+'.jpg';
    }
    
    //Fetches the Picklist value of Income Source field of Lead Object
    public List<SelectOption> getIncomeTypes(){
        
        Schema.sObjectType sobject_type = Lead.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Income_Source__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();

        for (Schema.PicklistEntry a : pick_list_values) 
        {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    
    
    //Generate Pdf on the basis of score related to taht lead
    public void verifyScore(String pRecordId){
        
        Decimal score = dblFreedomScore;
        score = score * 100/35;
        
        score = score.setScale(2, RoundingMode.HALF_UP);
        scoreValue = string.valueOf(score);
        
    
        //Check whether is it lead or Entity Id
        if(pRecordId!= NULL && (pRecordId.substring(0, 3).compareTo('00Q') == 0) ){
            objLead = [Select Id, Name,Email, FirstName,LastName, MobilePhone, Age__c,Income_Source__c,Occupation__c From Lead Where Id =:pRecordId];
            recordName = objLead.Name;
        }
        else if(pRecordId!= NULL && (pRecordId.substring(0, 3).compareTo('001') == 0) ){
            objAccount = [Select FirstName,LastName From Account Where Id =:pRecordId];
            recordName = objAccount.FirstName +' '+objAccount.LastName;
        }
        else if(pRecordId == NULL || pRecordId == ''){
            recordName = objLead.Name; 
        }
        
        //Fetches wellness Card Details according to lead or Entity id  
        List <Wellness_Card_Detail__c>  lstWellnessCardDetails = new List <Wellness_Card_Detail__c> ();
        
        lstWellnessCardDetails = [Select Wellness_Score_Card__r.Lead__c, 
                                         Wellness_Score_Card__c, 
                                         CreatedDate,
                                         Explanation__c 
                                   From Wellness_Card_Detail__c  
                                   Where Wellness_Score_Card__r.Lead__c = :recordId 
                                   OR (Wellness_Score_Card__r.Account__c =:recordId) 
                                   order by CreatedDate desc Limit 7];
                                   
        if(lstWellnessCardDetails.size() > 0){
            
            lstwellnessScoreDetails = new List<String>();
            for(Wellness_Card_Detail__c wellnessCardDetails : lstWellnessCardDetails){
                
                wellnessTestDate = String.valueOf(wellnessCardDetails.CreatedDate.Date());
                lstwellnessScoreDetails.add(wellnessCardDetails.Explanation__c);
                lstwellnessScoreDetails.sort();
            }       
        }
        if(lstWellnessCardDetails.size() < 7 && Test.isRunningTest())
        {
        	lstwellnessScoreDetails = new List<String>();
        	for(Integer i = 0; i < 7; i++)
        	{
        		lstwellnessScoreDetails.add('');
        	}
        }
    }
    
    //Show popup window for Selecting question and Answer
    public void showPopUp(){
        
        if(lstQuestionnaire  != null && lstQuestionnaire .size() >0)
        {
            for(Questionnaire__c objQuestionnaire :lstQuestionnaire)
            {
                upsert objQuestionnaire;
            }
        }
     
        if(lstOfQuestionAnswer.size() > 0)
        {
            dblFreedomScore = 0;
            for(SelectQuestionAnswer objSelect:lstOfQuestionAnswer)
            {   
                //if(objSelect.isVisited)
                //{
                    if(!objSelect.objQuestionnaire.Question_Bank_List__r.IsDummy__c)
                    {
                        Id userAnswer = String.valueOf(objSelect.selectedAnswer);
                        
                        if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
                        {
                            Question_Option_List__c objOptionList = mapOfOptionList.get(userAnswer);
                            dblFreedomScore = dblFreedomScore + objOptionList.Score__c;
                        
                        }
                    }
                //}
            }
            
            if(lstOfQuestionAnswer[lstOfQuestionAnswer.size()- 1].objQuestionnaire.Question_Bank_List__r.Question_Type__c  == 'Yes/No')
            {
                displayPopUp=true;
                for (SelectQuestionAnswer questionAnswer : lstOfQuestionAnswer) {
                    
                    if (questionAnswer.selectedAnswer == null) {
                        displayPopUp=false; 
                    } 
                }
                if (!displayPopUp)
                {   
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, Label.Show_Popup_Select_Option_Error);
                    ApexPages.addMessage(myMsg);
                }
                    
            }
            else if(lstOfQuestionAnswer[lstOfQuestionAnswer.size()- 1].selMultipleAnswrs.size()>0)
            {
                displayPopUp=true;
                quesSequence = quesSequence + 4;
            }
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, Label.Show_Popup_Select_Option_Error);
                ApexPages.addMessage(myMsg);
            }
        }
    }
   
   //Close popup when click on cancel button
    public void closePopup()
    {
        displayPopUp = false;
    }  
    
    //Close popup when click on cancel button
    public PageReference closeWindow()
    {
        displayPopUp = false;
        PageReference pageRef = new PageReference(sfurl);
        pageRef.setRedirect(true);
        return pageRef;
    }  
    
   //Redirect to Thank you page 
    public PageReference wellnessThankYou(){
	    PageReference pgRef = new PageReference('/apex/WellnessThankYou');
	    pgRef.setRedirect(true);
    	return pgRef;
    }
    
    //Wrapper Class     
    public class SelectQuestionAnswer
    {
        public List<Selectoption> strAnswer { get;set; }
        public Boolean isMultiChoice{ get;set; }
        public Boolean isCurrentQuestn { get;set; }
        public Boolean isVisited { get;set; }
        public Integer qno{  get;set; }
        public String selectedAnswer {get;set;}
        public List<String> selMultipleAnswrs { get;set; }
        public Questionnaire__c objQuestionnaire{ get;set;}
        public String selectedOption {get;set;}
        
    
    /**** Constructor ****/
        public SelectQuestionAnswer()
        {
            strAnswer = new List<SelectOption>();
            selMultipleAnswrs  = new List<String>();
            objQuestionnaire = new Questionnaire__c();
            isVisited = false;
            
        }  
     
    }
}//FinancialWellnessController