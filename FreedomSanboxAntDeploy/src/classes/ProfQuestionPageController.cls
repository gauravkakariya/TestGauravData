/*
Revision History:

   Version     Version Author       Date          Comments
   1.0         Prajakta Sanap     06-07-2013      Initial Draft - Profiler Question pattern to be changed
   
*/  


public with sharing class ProfQuestionPageController 
{
    public List<Questionnaire__c> lstQuestionnaire {get;set;}
    public Question_Bank__c objActiveQuestionBank {set;get;}
    public List<SelectQuestionAnswer> lstOfQuestionAnswer {get;set;}
    public Map<ID,List<Question_Option_List__c>> mapQuesIdAnswers{set;get;}  
    public String strEntityId {get;set;}
    private Map<ID,Question_Option_List__c> mapOfOptionList{set;get;}
    public Double totalScore{set;get;}  
    public String riskProfile {get;set;} 
    public List<Profiler_Score_Card__c> lstProfilerScoreCard{get;set;}
    public List<Profiler_Card_Detail__c> lstProfilerCardDetail{get;set;}
    public Account objAccount{set;get;}
    public list<Profiler_Card_Detail__c>  profCardDetailsList;
    public Boolean isProfilerQuestion {get;set;}
    public Boolean isProfilerOutput {get;set;}
    
    /**** Constructor ****/
    public ProfQuestionPageController()
    {
        String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        
        if(browserType != null && browserType.contains('MSIE'))
        {
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');
        }
        strEntityId = ApexPages.currentPage().getParameters().get('entityId');  
        system.debug('------------strEntityId------------'+strEntityId);
        mapOfOptionList = new Map<ID,Question_Option_List__c> ();
        
        isProfilerQuestion = false;
        isProfilerOutput = false;
        
        objAccount = new Account();
        //Fetches Account Record by getiing parameteised RecordId
        if(strEntityId != null && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != '') 
        {
            objAccount = [Select Id,LastName,FirstName,PersonEmail, Owner.Email,Age__c, Age__pc, Phone,Salutation From Account Where Id =:strEntityId];
            system.debug('------------objAccount------------'+objAccount);
           
            lstProfilerScoreCard = [Select Id, Name, Score__c, Risk_Profile__c, Account__c
                                    From Profiler_Score_Card__c 
                                    Where Account__c =:objAccount.Id order by CreatedDate Desc limit 1];
                                    
                                
        }
        
        mapQuesIdAnswers = new Map<ID,List<Question_Option_List__c>>();
        lstQuestionnaire = new List<Questionnaire__c>();
        lstQuestionnaire.clear();
        Map<String, QuestionBank__c> QuestionBank = QuestionBank__c.getAll();
        String ProfilerQuestionId= QuestionBank.get('ProfilerQuestion').Question_Bank__c;
        objActiveQuestionBank  = [Select id, Name, IsActive__c, IsProfilerQue__c 
                                    From Question_Bank__c  
                                    Where IsProfilerQue__c = true AND Id =: ProfilerQuestionId limit 1];
                                    
        Init();
    }
  
      
    /**** Action Method ****/
    public Pagereference Init()
    {
        lstOfQuestionAnswer = new List<SelectQuestionAnswer>();
        map<string, string> questionAnswerIdMap = new map<string, string>(); 
        
        if (lstProfilerScoreCard != null && !lstProfilerScoreCard.isEmpty())
        {
            profCardDetailsList = [Select Question_Option_List__c, Question_Bank_List__c , Profiler_Score_Card__c 
                                    From Profiler_Card_Detail__c
                                    WHERE Profiler_Score_Card__c =: lstProfilerScoreCard[0].id];
            if(profCardDetailsList != null && !profCardDetailsList.isEmpty())
            {
                for(Profiler_Card_Detail__c p : profCardDetailsList)
                {
                    questionAnswerIdMap.put(p.Question_Bank_List__c, p.Question_Option_List__c);
                }
            }
        } 

        isProfilerQuestion = true;
        isProfilerOutput = false;
            
        PageReference pgref;
        
        set<ID>setOfIds = new set<ID>();
        
        //Fetches the list of Questionnaire accoding to Question Bank Id
        lstQuestionnaire = [SELECT  Question_Bank__c,
                                    Question_Bank_List__r.Question__c,
                                    Question_Bank_List__r.Name, 
                                    Display_Sequence__c ,
                                    Question_Bank_List__c,
                                    Name, Id ,
                                    Explanation__c,
                                    Question_Bank_List__r.Id,
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
                
                if(!mapQuesIdAnswers.isEmpty() && mapQuesIdAnswers.containsKey(lstQuestionnaire[iCount].Question_Bank_List__c))
                {
                    List<Question_Option_List__c> lstAnswer = mapQuesIdAnswers.get(lstQuestionnaire[iCount].Question_Bank_List__c);
                    if(lstAnswer != null && lstAnswer.size()>0)
                    {
                        for(Question_Option_List__c objAns :lstAnswer)
                        {   
                            string answerId15digit  = objAns.Id;
                            if(answerId15digit.length() == 18){
                                answerId15digit = String.valueOf(objAns.Id).substring(0, 15);
                            }
                            objSelectQuesAnswer.strAnswer.add(new Selectoption(answerId15digit, objAns.Explaination__c));
                            objSelectQuesAnswer.strAnswer.sort();
                            
                        }
                    }
                }
                system.debug('----------objSelectQuesAnswer Answers-------------'+objSelectQuesAnswer);
                
                objSelectQuesAnswer.question = lstQuestionnaire[iCount].Question_Bank_List__r.Question__c;
                
                //code to populate selected answer
                if (lstProfilerScoreCard != null && !lstProfilerScoreCard.isEmpty()) 
                {
                    if(questionAnswerIdMap.get(lstQuestionnaire[iCount].Question_Bank_List__r.Id) != null)
                        objSelectQuesAnswer.selectedAnswer = questionAnswerIdMap.get(lstQuestionnaire[iCount].Question_Bank_List__r.Id).substring(0,15);
                }
                lstOfQuestionAnswer.add(objSelectQuesAnswer);
            }
            system.debug('----------Answers-------------'+lstOfQuestionAnswer);
        }
        return NULL;
    }
    
    public Pagereference Reset()
    {
        isProfilerQuestion = true;
        isProfilerOutput = false;
        system.debug('----------Reset-------------');
        if (lstProfilerScoreCard != null && lstProfilerScoreCard.size() > 0)
            delete lstProfilerScoreCard;
         
        profCardDetailsList = new list <Profiler_Card_Detail__c>();
        lstProfilerScoreCard = new List<Profiler_Score_Card__c>();
        mapOfOptionList = new Map<ID,Question_Option_List__c> ();
        mapQuesIdAnswers = new Map<ID,List<Question_Option_List__c>>();
        Init();
        return null;
    }
   
    public Pagereference save() 
    {
        Boolean isExistingScoreCard = false;
        isProfilerQuestion = false;
        isProfilerOutput = true;
        
        List<Decimal> lstQuestion_Option_List = new List<Decimal>();
        
        Profiler_Score_Card__c objProfiler_Score_Card;
        Database.Saveresult saveResult;
        
        Map<Id,Profiler_Score_Card__c>  mapIdtToProfilerScore = new  Map<Id,Profiler_Score_Card__c>();
        if(!lstProfilerScoreCard.isEmpty())     
        {
            for(Profiler_Score_Card__c objScoreCard : lstProfilerScoreCard)
            {
                if(!mapIdtToProfilerScore.containsKey(objScoreCard.Account__c))
                {
                    mapIdtToProfilerScore.put(objScoreCard.Account__c,objScoreCard);
                }
            }
        }
        
        if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('001') == 0 && strEntityId != '')
        {
            if (lstProfilerScoreCard != null && lstProfilerScoreCard.size() > 0) 
            {
                isExistingScoreCard = true;
                system.debug('objAccount.Id if --->'+objAccount.Id);
                system.debug('lstProfilerScoreCard[0]****'+lstProfilerScoreCard[0]);
                objProfiler_Score_Card = lstProfilerScoreCard[0];
                objProfiler_Score_Card.Question_Bank__c = objActiveQuestionBank.Id;
                saveResult = Database.update(objProfiler_Score_Card);
            }
            else
            {
                objProfiler_Score_Card =  new Profiler_Score_Card__c ();
                objProfiler_Score_Card.Account__c  = objAccount.Id;
                objProfiler_Score_Card.Question_Bank__c = objActiveQuestionBank.Id;
                system.debug('objAccount.Id else --->'+objAccount.Id);
                saveResult = Database.insert(objProfiler_Score_Card);
                lstProfilerScoreCard.add(objProfiler_Score_Card);
            }       
        }

        if(lstOfQuestionAnswer.size() > 0)
        {
            totalScore = 0;
            lstProfilerCardDetail = new List<Profiler_Card_Detail__c>();
            Profiler_Card_Detail__c objProfilerCardDetail;
            ID userAnswer;
            
            for(SelectQuestionAnswer objSelect : lstOfQuestionAnswer)
            {
                Boolean objFound = false;
                if (profCardDetailsList != null)
                    for (Profiler_Card_Detail__c ProfilerCardDetail : profCardDetailsList) 
                    {
                        if (ProfilerCardDetail.Question_Bank_List__c == objSelect.objQuestionnaire.Question_Bank_List__c) 
                        {
                            system.debug('ProfilerCardDetail-->'+ProfilerCardDetail);
                            objProfilerCardDetail = ProfilerCardDetail;
                            objFound = true;
                            break;
                        }
                    }
                if (!objFound) 
                {
                    if (profCardDetailsList == null)
                       profCardDetailsList = new list<Profiler_Card_Detail__c>();
                    objProfilerCardDetail = new Profiler_Card_Detail__c();
                    profCardDetailsList.add(objProfilerCardDetail);
                }
                
                objSelect.isVisited = false;
                
                if(!objSelect.isVisited)
                {
                    userAnswer = String.valueOf(objSelect.selectedAnswer);
                    objProfilerCardDetail.Question_Option_List__c = userAnswer;
                    if (objProfilerCardDetail.Profiler_Score_Card__c == null)
                        objProfilerCardDetail.Profiler_Score_Card__c = saveResult.getId();
                    objProfilerCardDetail.Display_Sequence__c = Double.valueOf(objSelect.objQuestionnaire.Display_Sequence__c);
                    objProfilerCardDetail.Question_Bank_List__c = objSelect.objQuestionnaire.Question_Bank_List__c;
                    
                    if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
                    {
                        Question_Option_List__c objOptionList = mapOfOptionList.get(userAnswer);
                        if(objOptionList.Score__c != null)
                        {
                            objSelect.isVisited = true;
                            system.debug('----------objSelect.isVisited-----------'+objSelect.isVisited);
                            objProfilerCardDetail.Score__c = objOptionList.Score__c;
                            objProfilerCardDetail.Explanation__c = objOptionList.Explaination__c;
                            objSelect.score = Integer.valueOf(objOptionList.Score__c);
                            totalScore += objSelect.score;
                            objSelect.selectedOption = objOptionList.Explaination__c;
                        }
                    }
                    if(objSelect.isVisited) 
                    {
                        lstProfilerCardDetail.add(objProfilerCardDetail);
                    }
                    else
                    {
                        isProfilerQuestion = true;
                        isProfilerOutput = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please answer all the questions.'));
                        if(isExistingScoreCard == false)
                        {
                            profCardDetailsList = lstProfilerCardDetail = new list<Profiler_Card_Detail__c>();
                            delete lstProfilerScoreCard[0];
                            lstProfilerScoreCard = new list<Profiler_Score_Card__c>();
                        }
                        return null;
                    }       
                    system.debug('--------lstProfilerCardDetail-----------'+lstProfilerCardDetail);
                }
            }
            
            if(lstProfilerCardDetail.size() == 6)
            {
                Database.upsert(lstProfilerCardDetail);
            }
            
            lstProfilerScoreCard = [Select Id, Name, Score__c, Risk_Profile__c, Account__c
                                    From Profiler_Score_Card__c 
                                    Where Account__c =:objAccount.Id order by CreatedDate Desc limit 1];
            
            if(!lstProfilerScoreCard.isEmpty())     
            {
                for(Profiler_Score_Card__c objScoreCard : lstProfilerScoreCard)
                {
                    riskProfile = objScoreCard.Risk_Profile__c;
                    system.debug('-------------riskProfile--------->'+riskProfile);
                }
            }
        }
        return null;
    }
    
    //Wrapper Class     
    public class SelectQuestionAnswer
    {
        public List<Selectoption> strAnswer { get;set; }
        public Boolean isCurrentQuestn { get;set; }
        public Boolean isVisited { get;set; }
        public String selectedAnswer {get;set;}
        public Questionnaire__c objQuestionnaire{ get;set;}
        public String selectedOption {get;set;}
        public Integer score {get;set;}
        public String question {get;set;}
    
        /**** Constructor ****/
        public SelectQuestionAnswer()
        {
            strAnswer = new List<SelectOption>();
            objQuestionnaire = new Questionnaire__c();
            isVisited = true;
        }  
    }
}