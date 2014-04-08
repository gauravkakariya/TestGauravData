/**
@description profilerQuestionBean bean class for profileQuestionPage
*/
public class profilerQuestionBean{

    public list<ProfileQuestionWrpper> questionInstanceList{get;set;}
    public  String currentEntity{get;set;}
    
    
    
    /**
    This class is used to map question and associated picklist
    */
    public class ProfileQuestionWrpper{
        public ProfilerQuestions__c profileQuestion{get;set;}
        public List<SelectOption> answerOption{get;set;}
        public boolean optionDisplay{get;set;}
        public string answer{get;set;}
        
        public ProfileQuestionWrpper(){
            profileQuestion=new  ProfilerQuestions__c();
            answerOption=new  List<SelectOption>();
        }
      }
}