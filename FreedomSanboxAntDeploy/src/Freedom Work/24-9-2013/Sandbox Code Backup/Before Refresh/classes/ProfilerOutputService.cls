/**
@description service class for profileOutputPage
*/
public class ProfilerOutputService{
   DatabaseSOQL dbsoql{get;set;}
   public ProfilerOutputService(){
       dbsoql=new DatabaseSOQL();
   }
   
   /**
   This function gets answers of an entity from entityProfilerQuestion object
   */
   public list<EntityProfilerQuestion__c> getAnswers(string entity){
       list<EntityProfilerQuestion__c> answerList=dbsoql.getProfilerAnswersFromDB(entity);
       return answerList;
   }
    
}