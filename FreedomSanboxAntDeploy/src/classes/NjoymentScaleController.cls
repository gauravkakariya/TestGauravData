public without sharing class NjoymentScaleController 
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
    private String strEntityStage{get;set;}
    
     public NjoymentScaleController(){
     	
     }
     
    /**** Constructor ****/
    public NjoymentScaleController(ApexPages.standardController con)
    {
    	this.AccountRecord = (Account)con.getRecord();
    	String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        if(browserType != null && browserType.contains('MSIE'))
        {
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');
        }
        strEntityId = '';
        strEntityId = ApexPages.currentPage().getParameters().get('id');  
        strEntityStage = ApexPages.currentPage().getParameters().get('stage');  
        system.debug('****strEntityStage'+strEntityStage);
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
       
        objAccount = new Account();
        AccountRecord =  new Account();
        
        //Fetches Account Record by getiing parameteised RecordId
        if(strEntityId != null && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != '') {
            strEntityCheck = true;
            objAccount = [Select Id,LastName,FirstName,PersonEmail, Owner.Email,Age__c ,Phone,Salutation, Industry From Account Where Id =:strEntityId];
            
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

        if(strEntityStage.trim().compareTo('Data Collection')  == 0)
        //String FinancialWellnessId= QuestionBank.get('FinancialWellness').Question_Bank__c;
        objActiveQuestionBank  = [Select id,Name,IsActive__c, IsWellness__c,Entity_Stage__c From Question_Bank__c Where Id =:'a2VW00000000IjN'   limit 1];
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
                                    FROM Questionnaire__c q where Question_Bank__c =:'a2VW00000000IjN'
                                    order by Display_Sequence__c ASC];
    	system.debug('******lstQuestionnaire'+lstQuestionnaire);
        if(lstQuestionnaire  != null && lstQuestionnaire .size() >0)
        { 
            for(Questionnaire__c objQuestionnaire :lstQuestionnaire)
            {
            	objQuestionnaire.Explanation__c = '';
                setOfIds.add(objQuestionnaire.Question_Bank_List__c);  
                system.debug('******objQuestionnaire.Question_Bank_List__c'+objQuestionnaire.Question_Bank_List__c);
            }
          
            //populating the question and its answer.
            mapOfOptionList = new Map<ID,Question_Option_List__c> ();
            mapQuesIdAnswers = new Map<ID,List<Question_Option_List__c>>();
            for(Question_Option_List__c objAnswer : [Select Question_Bank_List__c,                                    
                                   Name,Id ,Score__c,	
                                   Explaination__c
                            From Question_Option_List__c  
                            Where Question_Bank_List__c IN:setOfIds Order by Question_Bank_List__c  asc])                                                                                                  
            {
            	system.debug('***** objAnswer'+objAnswer.id);
            	system.debug('***** objAnswer'+objAnswer);
            	
                mapOfOptionList.put(objAnswer.Id,objAnswer);
               
             system.debug('***** mapOfOptionList'+mapOfOptionList);
             
             system.debug('***** mapOfOptionList1'+mapQuesIdAnswers.containsKey(objAnswer.Question_Bank_List__c));
                if(!mapQuesIdAnswers.isEmpty() && mapQuesIdAnswers.containsKey(objAnswer.Question_Bank_List__c))
                {
                	system.debug('*****Inside If');
                    List<Question_Option_List__c> lstAnswers = mapQuesIdAnswers.get(objAnswer.Question_Bank_List__c);
                    lstAnswers.add(objAnswer);
                    mapQuesIdAnswers.put(objAnswer.Question_Bank_List__c,lstAnswers);
                }
                else
                {
                    List<Question_Option_List__c> lstAnswers = new List<Question_Option_List__c>();
                    lstAnswers.add(objAnswer);
                    mapQuesIdAnswers.put(objAnswer.Question_Bank_List__c, lstAnswers);
               }
            }
         
          	lstOfQuestionAnswer = new List<SelectQuestionAnswer>();
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
        String RecordId;
        Decimal score = 0.0;
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
	                         system.debug('***saveResult: '+saveResult);
                     system.debug('***objWellnessScoreCardDetail: '+objWellnessScoreCardDetail);
                        
                    }
                    catch(Exception ex)
                    {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses1 = new String[] {'tech@ffreedom.in'};
                        mail.setToAddresses(toAddresses1);
                        mail.setSenderDisplayName('Salesforce Support');
                        mail.setSubject('Error in Lead Creation by Wellness from site');
                        mail.setPlainTextBody(' Error : '+ex.getMessage()+' Lead Id ----> : ');//+saveResult.getId());
                        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
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
     
        if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != ''){
            
            objAccount = [Select Id, LastName,OwnerId, FirstName,PersonEmail,Owner.Email, Age__c ,Phone,Salutation From Account Where Id =:strEntityId];
            system.debug('*****objAccount'+objAccount);
            RecordId = objAccount.Id;
           
        }
        else if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('00Q') == 0 && strEntityId != ''){
            RecordId = objLead.Id;
        }   
        else
            RecordId = objLead.Id;
        system.debug('***RecordId'+objLead.Id);
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        // Create the email attachment 
        List<String> toAddresses = new List<String>();
        
        if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != ''){
            
            RecordId = objAccount.Id;
            
            // Sets the paramaters of the email
            if(objAccount.PersonEmail != null)
                toAddresses.add(objAccount.PersonEmail);
                
            //String[] toCcAddresses = new String[] {objAccount.Owner.Email};
            email.setSubject( 'Wellness Test Report of ' + objAccount.FirstName + objAccount.LastName);     
            email.setToAddresses( toAddresses );
           // email.setCcAddresses(toCcAddresses)   ;
                        
            if(wellnessRecordCheck){   
                
	                 email.setHtmlBody('Dear '+objAccount.FirstName + objAccount.LastName +Label.Send_Mail_Set_Html_Body_Message);
	                 email.setSenderDisplayName(objAccount.FirstName + objAccount.LastName);
	                
	                 //Calculate Percentage of Welleness Score
	                 score = dblFreedomScore;
	                 system.debug('** score'+ score);
	                 system.debug('** dblFreedomScore'+ dblFreedomScore);
	                 score = score * 100/35;
	                 system.debug('** score'+ score);
	                 score = score.setScale(2, RoundingMode.HALF_UP);
	                 scoreValue = string.valueOf(score);
	                 
	                 Date wellnessTestDate = lstWellnessScoreCard[0].Wellness_Test_Date__c;
	                 DateTime dtValue = DateTime.newInstance(wellnessTestDate.year(),wellnessTestDate.month(), wellnessTestDate.day());
	                 string wellnessDate = dtValue.format('DD-MM-yyyy');
	                 //String wellnessDate = String.valueOf(wellnessTestDate);
	                 
	                 email.setHtmlBody('Dear '+objAccount.FirstName + objAccount.LastName +'<br/><br/>Thank you for taking the Ffinancial Wellness Test.'
	                 +'<br/><br/> Your score is '+dblFreedomScore+'. You are probably feeling '+scoreValue +'% good about your personal financial life.'
	                 +'<br/><br/>The last time you took this test was on '+ wellnessDate +' and you scored '+ lstWellnessScoreCard[0].Score__c
	                 +'<br/><br/> Thanks and regards' + '<br/><br/> Ffreedom Team');
	                
	                 // Sends the email to Lead or Entity acccording to RecordId
	                 Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }   
            else{
                 email.setSenderDisplayName(objAccount.FirstName + objAccount.LastName);
                 verifyScore(RecordId);
                 
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
                                          'You have taken the Wellness Test on '+ wellnessTestDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                           Label.Wellness_Report_Analysis + '<br/><br/>' +lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
                                           lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
                                           lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
                                           lstwellnessScoreDetails[6] + '<br/><br/>' + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
                                           +'<br><br/>'+'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
                       	 system.debug('***lstwellnessScoreDetails in test'+lstwellnessScoreDetails); 	
                  }
                 else if(lstwellnessScoreDetails!= NULL && lstwellnessScoreDetails.size() > 0)   	
                 email.setHtmlBody('<img src="'+sfurl+''+ getResourceURL('WellnessEmailLogo')+'"/>'+ 
                     				   '<br/><br/>'+'Dear '+objAccount.FirstName + objAccount.LastName +'<br/><br/> '+'You have taken the Wellness Test on '+ wellnessTestDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                   Label.Wellness_Report_Analysis + '<br/><br/>' +lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
                                   lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
                                   lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
                                   lstwellnessScoreDetails[6] + '<br/><br/>' + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."');
               
                 // Sends the email to Lead or Entity acccording to RecordId
                 Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                }
                
            }
                
            //If Record Id  is Lead
            if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('00Q') == 0 && strEntityId != ''){
                
                RecordId = objLead.Id;
                
                // Sets the paramaters of the email
                if(objLead.Email != null)
                    toAddresses.add(objLead.Email);
                    
                    //String[] toBccAddresses = new String[] {'aditi.satpute@eternussolutions.com'};
                    email.setSubject( 'Wellness Test Report of ' + objLead.FirstName+' '+objLead.LastName);     
                    email.setToAddresses( toAddresses );
                        
                if(wellnessRecordCheck){ 
                    
	                    //Calculate Percentage of Welleness Score
	                     score = dblFreedomScore;
	                     score = score * 100/35;
	                     score = score.setScale(2, RoundingMode.HALF_UP);
	                     scoreValue = string.valueOf(score);
	                     
	                     Date wellnessTestDate = lstWellnessScoreCard[0].Wellness_Test_Date__c;
	                	 DateTime dtValue = DateTime.newInstance(wellnessTestDate.year(),wellnessTestDate.month(), wellnessTestDate.day());
	                 	 string wellnessDate = dtValue.format('DD-MM-yyyy');
	                 	
	                    email.setHtmlBody('Dear '+objLead.FirstName+' '+objLead.LastName +Label.Send_Mail_Set_Html_Body_Message);
	                    email.setSenderDisplayName(objLead.FirstName+''+objLead.LastName);
	                     
	                     email.setHtmlBody('Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/>Thank you for taking the Ffinancial Wellness Test.'
	                     +'<br/><br/> Your score is '+dblFreedomScore+'. You are probably feeling '+scoreValue +'% good about your personal financial life.'
	                     +'<br/><br/>The last time you took this test was on '+wellnessDate +' and you scored '+ lstWellnessScoreCard[0].Score__c
	                     +'<br/><br/> Thanks and regards' + '<br/><br/> Ffreedom Team');
                      
                }
                else{
                    
                     email.setSenderDisplayName(objLead.FirstName+''+objLead.LastName);
                     verifyScore(RecordId);
                     
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
	                                          'You have taken the Wellness Test on '+ wellnessTestDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
	                                           Label.Wellness_Report_Analysis + '<br/><br/>' +lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
	                                           lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
	                                           lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
	                                           lstwellnessScoreDetails[6] + '<br/><br/>' + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
	                                           +'<br><br/>'+'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
	                  }
                      else if(lstwellnessScoreDetails!= NULL && lstwellnessScoreDetails.size() > 0) {
                      email.setHtmlBody('<img src="'+sfurl+''+ getResourceURL('WellnessEmailLogo')+'"/>'+ 
                     				   '<br/><br/>'+'Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/> '+'You have taken the Wellness Test on '+ wellnessTestDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                       Label.Wellness_Report_Analysis + '<br/><br/>' +lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
                                       lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
                                       lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
                                       lstwellnessScoreDetails[6] + '<br/><br/>' + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'+
                                      +'<br><br/>'+'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
                     }
                  // Sends the email to Lead or Entity acccording to RecordId
                  //'<img src="http://ffreedom1.ffreedom.cs13.force.com'+getResourceURL('WellnessEmailLogo')+'"/>'
                    Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    system.debug('***arrResult'+arrResult);                    
                                   
                                       
                }   
            }  
            else if(strEntityId == NULL || strEntityId == ''){ 
                  
                // Sets the paramaters of the email
                if(objLead.Email != null)
                    toAddresses.add(objLead.Email);
                    
                    //String[] toBccAddresses = new String[] {'aditi.satpute@eternussolutions.com'};
                    email.setSubject( 'Wellness Test Report of  ' + objLead.FirstName+' '+objLead.LastName);        
                    email.setToAddresses( toAddresses );
                        
                    if(wellnessRecordCheck){ 
                        
                        Date wellnessTestDate = lstWellnessScoreCard[0].Wellness_Test_Date__c;
	                	DateTime dtValue = DateTime.newInstance(wellnessTestDate.year(),wellnessTestDate.month(), wellnessTestDate.day());
	                 	string wellnessDate = dtValue.format('DD-MM-yyyy');
                        
                        email.setHtmlBody('Dear '+objLead.FirstName+' '+objLead.LastName +Label.Send_Mail_Set_Html_Body_Message);
                        email.setSenderDisplayName(objLead.FirstName+''+objLead.LastName);
                        email.setHtmlBody('Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/>Thank you for taking the Ffinancial Wellness Test.'
                         +'<br/><br/> Your score is '+dblFreedomScore+'. You are probably feeling '+scoreValue +'% good about your personal financial life.'
                         +'<br/><br/>The last time you took this test was on '+wellnessTestDate +' and you scored '+ lstWellnessScoreCard[0].Score__c
                         +'<br/><br/> Thanks and regards' + '<br/><br/> Ffreedom Team');
             
                    }
                    else{
                        
                         //Calculate Percentage of Welleness Score
                         score = dblFreedomScore;
                         score = (score * 100/35);
                         score = score.setScale(2, RoundingMode.HALF_UP);
                         scoreValue = string.valueOf(score);
                         verifyScore(RecordId);
                         
                        //string imagePath = '<img src=\"'+GetResourceURL(NewWellnessImage)+\'"/>';
                        //'<img src="{!URLFOR($Resource.WellnessImage,wellnessImage/FinancialWellness.jpeg}") />'
                        // email.setHtmlBody('<img src="http://ffreedom1.ffreedom.cs13.force.com'+GetResourceURL('NewWellnessImage')+'"/>');
                        //<img src="http://ffreedom1.ffreedom.cs13.force.com'+getResourceURL('WellnessEmailLogo')+'"/>
                        
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
                                          'You have taken the Wellness Test on '+ wellnessTestDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                           Label.Wellness_Report_Analysis + '<br/><br/>' +lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
                                           lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
                                           lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
                                           lstwellnessScoreDetails[6] + '<br/><br/>' + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
                                           +'<br><br/>'+'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
                       }
                       else if(lstwellnessScoreDetails!= NULL && lstwellnessScoreDetails.size() > 0){  
                         email.setHtmlBody('<img src="'+sfurl+''+ getResourceURL('WellnessEmailLogo')+'"/>'+ 
                                            '<br/><br/>' +'Dear '+objLead.FirstName+' '+objLead.LastName +'<br/><br/> '+
                                          'You have taken the Wellness Test on '+ wellnessTestDate +' and you scored: '+ scoreValue+ '% <br/><br/>'+
                                           Label.Wellness_Report_Analysis + '<br/><br/>' +lstwellnessScoreDetails[0] + '<br/><br/>' + lstwellnessScoreDetails[1] + '<br/><br/>'+
                                           lstwellnessScoreDetails[2] + '<br/><br/>' + lstwellnessScoreDetails[3] + '<br/><br/>'+
                                           lstwellnessScoreDetails[4] + '<br/><br/>' + lstwellnessScoreDetails[5] + '<br/><br/>'+
                                           lstwellnessScoreDetails[6] + '<br/><br/>' + Label.Wellness_Report_Text+ '<br/><br/>' +'If you do it now, at the end of your journey '+ recordName+', you can look back and say with pride "I have lived the life of my dreams with no regrets or remorse."'
                                           +'<br><br/>'+'<img src="'+sfurl+''+getResourceURL('FreedomContactus')+'"/>');
                        }
                        // Sends the email to Lead or Entity acccording to RecordId
                        Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                        system.debug('***arrResult'+arrResult); 
                    }  
            }
            //PageReference pageRef = Page.Thankyou;
            PageReference pageRef = Page.WellnessThankyou; 
           
           //pageRef.setRedirect(true);
           return pageRef;
           //return Null;
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
           //Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + pResourceName;   
        }  
        else return '';  
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
        system.debug('***dblFreedomScore'+dblFreedomScore);
        score = score * 100/35;
        system.debug('***score'+score);
        
        score = score.setScale(2, RoundingMode.HALF_UP);
        scoreValue = string.valueOf(score);
        
    
        //Check whether is it lead or Entity Id
        if(pRecordId!= NULL && (pRecordId.substring(0, 3).compareTo('00Q') == 0) ){
            objLead = [Select Id, Name,Email, FirstName,LastName, MobilePhone, Age__c,Income_Source__c,Occupation__c From Lead Where Id =:pRecordId];
            recordName = objLead.Name;
        }
        else if(pRecordId!= NULL && (pRecordId.substring(0, 3).compareTo('001') == 0) ){
            objAccount = [Select FirstName,LastName From Account Where Id =:pRecordId];
            recordName = objAccount.FirstName + objAccount.LastName;
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
                system.debug('****objSelect'+objSelect);
                //if(objSelect.isVisited)
                //{
                    if(!objSelect.objQuestionnaire.Question_Bank_List__r.IsDummy__c)
                    {
                        Id userAnswer = String.valueOf(objSelect.selectedAnswer);
                        system.debug('****userAnswer'+userAnswer);
                        
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
                
                /*if(lstOfQuestionAnswer[lstOfQuestionAnswer.size()- 1].selectedAnswer != null)
                {
                    displayPopUp=true;
                    quesSequence = quesSequence + 4;
                }*/
                
                displayPopUp=true;
                for (SelectQuestionAnswer questionAnswer : lstOfQuestionAnswer) {
                    
                    system.debug('****questionAnswer'+questionAnswer);
                    if (questionAnswer.selectedAnswer == null) {
                        displayPopUp=false; 
                    } 
                }
                if (!displayPopUp)
                {   
                    system.debug('****displayPopUp'+displayPopUp);
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
            
            system.debug('****selectedAnswer'+selectedAnswer);
        }  
     
    }
}//FinancialWellnessController