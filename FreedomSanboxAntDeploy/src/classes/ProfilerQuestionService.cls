/**
@description ProfilerQuestionService service class for profileQuestionPage
*/
public class ProfilerQuestionService{
    DatabaseSOQL dbsoql{get;set;}
    public ProfilerQuestionService(){
        dbsoql=new DatabaseSOQL ();
    }
    
    /**
    This function is used to create list of depedent question name
    input parameters profilerQuestionBean instance
    retuns list of string
    */
    public List<String> getQuestionName(profilerQuestionBean questionBean)
    {
        List<String> tempStrList = new List<String>();
        tempStrList.add(addQuestionName(System.Label.Question3,questionBean));
        tempStrList.add(addQuestionName(System.Label.Question6,questionBean));
        tempStrList.add(addQuestionName(System.Label.Question4,questionBean));
        tempStrList.add(addQuestionName(System.Label.Question7,questionBean));
        return tempStrList;
    }
    /**
    This function is used to get name of dependent question 
    input parameters profilerQuestionBean instance,question
    retuns  string
    */
    public String addQuestionName(String questionString,profilerQuestionBean questionBean)
    {
        String qName;
        for(profilerQuestionBean.ProfileQuestionWrpper currentInstance:questionBean.questionInstanceList){
            if(currentInstance.profileQuestion.question__c == questionString) {
                qName = currentInstance.profileQuestion.Name;
             }
        }
        return qName;
    }
    /**
    This function is used to validate the answers for dependent question i.e if user is selecting answer 'Yes' and
    not providing answers to dependent question then exception is thrown
    input parameters profilerQuestionBean instance
    retuns  void
    */
    public void validateAnswer(profilerQuestionBean questionBean){ 
        integer indexCounter=-1;
        List<String> questionNameString;
        integer PQ3index,PQ6index; 
        questionNameString=getQuestionName(questionBean);
        for(profilerQuestionBean.ProfileQuestionWrpper currentInstance:questionBean.questionInstanceList){
            indexCounter++;
            if(currentInstance.profileQuestion.name==questionNameString[0]) //'PQ-03'
                PQ3index=indexCounter;
            if(currentInstance.profileQuestion.name==questionNameString[1]) //'PQ-06'
                PQ6index=indexCounter;
        }
        if(questionBean.questionInstanceList.get(PQ3index).answer=='Yes'){
            if((questionBean.questionInstanceList.get(PQ3index+1).answer==null)||(questionBean.questionInstanceList.get(PQ3index+1).answer.trim().equals(''))){
                throw new ValidationException(Label.delayReason);     
            }
        }
        if(questionBean.questionInstanceList.get(PQ6index).answer=='Agree'){
            if(questionBean.questionInstanceList.get(PQ6index+1).answer==null|| (questionBean.questionInstanceList.get(PQ6index+1).answer.trim().equals(''))){
                throw new ValidationException(Label.SelfEmploymentValidation);     
            }
        }
    }
     /**
    This function is used to save the answers in entityProfilerQuestion object 
    It creates new record of entityProfilerQuestion if not present for that entity otherwise update previous record
    input parameters profilerQuestionBean instance
    retuns  void
    */
    public void save(profilerQuestionBean questionBean){
        List<EntityProfilerQuestion__c> answerList;
        string index3,index6;
        integer errorFlag=0;
        EntityProfilerQuestion__c entityProfilerQuestionInstance;
        List<String> questionNameString;
        try{
            validateAnswer(questionBean);
            answerList=dbsoql.getProfilerAnswersFromDB(questionBean.currentEntity);
            if(answerList.size()==0){
                answerList=new list<EntityProfilerQuestion__c>();
                for(profilerQuestionBean.ProfileQuestionWrpper currentInstance:questionBean.questionInstanceList){
                    entityProfilerQuestionInstance=new EntityProfilerQuestion__c();
                    entityProfilerQuestionInstance.Entity__c=questionBean.currentEntity;   
                    entityProfilerQuestionInstance.ProfilerQuestion__c=currentInstance.profileQuestion.Id;
                    List<String>answerScore=new list<String>();
                    if(currentInstance.optionDisplay!=false  && currentInstance.answer!=null)
                        answerScore=currentInstance.answer.split(';');
                    if(!answerScore.isEmpty()){
                        entityProfilerQuestionInstance.Answer__c=answerScore[0];
                        entityProfilerQuestionInstance.Score__c=answerScore[1];
                    }
                    else{
                        entityProfilerQuestionInstance.Answer__c=currentInstance.answer;
                        entityProfilerQuestionInstance.Score__c='-1';
                    }
                    if( entityProfilerQuestionInstance.Answer__c!=null &&(!(entityProfilerQuestionInstance.Answer__c.trim().equals('')))){
                        answerList.add(entityProfilerQuestionInstance);
                    }
                       
                }
                try{
                    insert(answerList);
                }catch(Exception e)
                {
                    system.debug(e.getMessage());
                }
         }
         else{
            integer flag=0;
            questionNameString = getQuestionName(questionBean);
            for(profilerQuestionBean.ProfileQuestionWrpper currentInstance:questionBean.questionInstanceList)
            {   
                flag=0;
                if(currentInstance.profileQuestion.name==questionNameString[0])    //'PQ-03'
                       index3=currentInstance.answer;
                if(currentInstance.profileQuestion.name==questionNameString[1])    //'PQ-06'
                       index6=currentInstance.answer;
                for(EntityProfilerQuestion__c DBanswer:answerList){
                   if(currentInstance.profileQuestion.Id==DBanswer.ProfilerQuestion__c){
                   
                      List<String>answerScore=new list<String>();
                      if((DBanswer.Answer__c!=currentInstance.answer && (currentInstance.answer!=''))){
                          if(currentInstance.optionDisplay!=false  && currentInstance.answer!=null)
                                answerScore=currentInstance.answer.split(';');
                          if(!answerScore.isEmpty()){
                              DBanswer.Answer__c=answerScore[0];
                              DBanswer.Score__c=answerScore[1];
                          }
                          try{
                               update(DBanswer);
                          }
                          catch(Exception e){
                               system.debug(e.getmessage());
                          }
                           flag=0;
                           break;
                       }
                       else{
                           flag=0;
                           if( ((currentInstance.profileQuestion.name==questionNameString[2] && index3=='No')|| (currentInstance.profileQuestion.name==questionNameString[3] && index6=='Disagree'))){
                           system.debug('%%%%%%delete else');
                           try{
                               delete(DBanswer);
                           }catch(Exception e){
                               system.debug(e.getmessage());
                           }
                           flag=0;
                          
                           }
                            break;
                      } 
                       
                    }
                    else
                        flag=1;
                        
                 }
                if(flag==1 ){
                    EntityProfilerQuestionInstance=new EntityProfilerQuestion__c();
                    EntityProfilerQuestionInstance.Entity__c=questionBean.currentEntity;   
                    EntityProfilerQuestionInstance.ProfilerQuestion__c=currentInstance.profileQuestion.Id;
                    EntityProfilerQuestionInstance.Answer__c=currentInstance.answer;
                    try{
                        upsert(EntityProfilerQuestionInstance);
                    }catch(Exception e){
                        system.debug(e.getMessage());
                    }
                 }
                     
             }
         }
           initQuestionList(questionBean);
        }
         catch(validationException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getmessage()) );
         }
       
         
    }
    /**
    This function is used to initialise question list and creating select option 
    If user answers are present in the database then that option is shown otherwise resetanswer function is called
   
    */
    public void initQuestionList(profilerQuestionBean pbean)
    {
        list<ProfilerQuestions__c>profilerQuestionsInstanceList=dbsoql.getProfilerQuestion();
        list<EntityProfilerQuestion__c>DbRecordList =dbsoql.getProfilerAnswersFromDB(pbean.currentEntity);
        string userAnswer,userScore;
        profilerQuestionBean.ProfileQuestionWrpper profileQuestionWrpperInstance;
        integer flag=0,i=0;
        list<String> scoreValue=new list<String>();
        pbean.questionInstanceList.clear();
        if(DbRecordList.size()!=0){
           
            for(ProfilerQuestions__c currentQuestion:profilerQuestionsInstanceList){
                profileQuestionWrpperInstance=new profilerQuestionBean.ProfileQuestionWrpper();
                profileQuestionWrpperInstance.profileQuestion=currentQuestion;
                List<String> parts = new list<String>();
                for(EntityProfilerQuestion__c DbRecord:DbRecordList){
                    if(DbRecord.ProfilerQuestion__c==currentQuestion.id){
                        userAnswer=DbRecord.Answer__c;
                        userScore=DbRecord.Score__c;
                        flag=1;
                        break;
                    }
                    else
                        flag=0;
                }
                if(currentQuestion.AnswerOptions__c!=null){
                    parts=currentQuestion.AnswerOptions__c.split(';');
                    profileQuestionWrpperInstance.answerOption.add(new SelectOption(userAnswer+';'+userScore,userAnswer));
                    if(currentQuestion.Score__c.Contains(';')){
                        scoreValue=currentQuestion.Score__c.split(';');
                        for(String s:parts){
                            if(s!=userAnswer){
                                
                                profileQuestionWrpperInstance.answerOption.add(new SelectOption(s+';'+scoreValue[i],s));  
                            
                        } 
                        i++;  
                       }
                    }else{
                          for(String s:parts){
                            if(s!=userAnswer){
                                ProfileQuestionWrpperInstance.answerOption.add(new SelectOption(s,s));  
                            }
                        }   
                    }   
                    profileQuestionWrpperInstance.optionDisplay=true;
                 }
                 
                 else{
                   
                     profileQuestionWrpperInstance.answer=userAnswer;
                     profileQuestionWrpperInstance.optionDisplay=false;
                 }
                 pbean.questionInstanceList.add(ProfileQuestionWrpperInstance);
                 i=0;
            }
        }
        else{
            resetAnswer(pbean);
        }
       
    }
    
    
    /**
    This function is used to initialise question instance list or resetting the answers
    */
    public void resetAnswer(profilerQuestionBean pbean){
         List<ProfilerQuestions__c>ProfilerQuestionsInstanceList=dbsoql.getProfilerQuestion();
         profilerQuestionBean.ProfileQuestionWrpper ProfileQuestionWrpperInstance;
         pbean.questionInstanceList.clear();
         for(ProfilerQuestions__c currentQuestion:ProfilerQuestionsInstanceList){
               ProfileQuestionWrpperInstance=new profilerQuestionBean.ProfileQuestionWrpper();
               ProfileQuestionWrpperInstance.profileQuestion=currentQuestion;
               List<String> parts = new list<String>();
               list<String> scoreValue=new list<String>();
               integer i=0;
               if(currentQuestion.AnswerOptions__c!=null){
                    parts=currentQuestion.AnswerOptions__c.split(';');
                    if(currentQuestion.Score__c.Contains(';')){
                        scoreValue=currentQuestion.Score__c.split(';');
                      
                        for(String s:parts){
                            
                            ProfileQuestionWrpperInstance.answerOption.add(new SelectOption(s+';'+scoreValue[i],s));  
                            i++;  
                        }   
                    }else{
                         for(String s:parts){
                            
                            ProfileQuestionWrpperInstance.answerOption.add(new SelectOption(s,s));  
                            i++;  
                        }   
                    }
                     
                    ProfileQuestionWrpperInstance.optionDisplay=true;
                 }
                 else{
                     ProfileQuestionWrpperInstance.optionDisplay=false;
                 }
                 pbean.questionInstanceList.add(ProfileQuestionWrpperInstance);
            }
    }
}