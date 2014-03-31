/**
@description controller class for profilerOutputPage
*/
public class ProfilerOutputController{
    
    public List<EntityProfilerQuestion__c>scorerList{get;set;}
    public String entityId{get;set;}
    public ProfilerOutputService service{get;set;}
   /**
   @description constructor
   */
    public ProfilerOutputController(){
        scorerList=new List<EntityProfilerQuestion__c>();
        entityId=ApexPages.currentPage().getParameters().get('EntityId');
        service=new ProfilerOutputService();
        scorerList=service.getAnswers(entityId);
        showTotalPanel=false;
    }
    /** decides profile based on total  score*/
    public String profile{
        get{
           if(total>=32)
               profile='Aggressive';
           else if(total<32 && total>=24)
               profile='Moderately aggressive';
           else if(total<24 && total>=16)
               profile='Moderate';
           else if(total<16 && total>=8)
               profile='Moderately conservative';
           else
               profile='Conservative';
           return profile; 

        }
        set;
    } 
    /** decides cashReserveRequirement based on total score*/
    public integer cashReserveRequirement{
        get{
            if(total>20)
                cashReserveRequirement=3;
            else if(total>10 && total<20)
                cashReserveRequirement=6;
            else
                cashReserveRequirement=9;
            return cashReserveRequirement;
        }
        set;
    }
    /**
    Used to create select option  for rating delay reason question
    */
     public List<SelectOption> getScoreOption(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','0'));    
        options.add(new SelectOption('1','1'));      
        options.add(new SelectOption('2','2'));      
        options.add(new SelectOption('3','3'));      
        options.add(new SelectOption('4','4'));          
        return options;
    }
    public integer delayReasonScore{get;set;}
    public boolean showTotalPanel{get;set;}
    public Integer total {
        get{
            system.debug('==total =='+total );
            total=0;
            if(scorerList.size()>0){
                system.debug('==scorerList=='+scorerList);
                total=0;
                for(EntityProfilerQuestion__c obj:scorerList){
                    
                      if(obj.score__c==null || (obj.score__c.equals('NA')) || (obj.score__c.equals('null')) || (obj.score__c.equals('-1'))){
                          system.debug('==obj.score__c IF=='+obj.score__c);
                      }
                      else{
                          system.debug('==obj.score__c ELSE=='+obj.score__c);
                         total=total+Integer.valueOf(obj.score__c);
                      }   
                }
                if(delayReasonScore!=NULL)
                total=total+delayReasonScore;
            }
            else
                total=0;
            return total;
        }
        set;
    }
    /**
    this function is used to add delay reason score into total and also add that score in the database
    */
    public void Calculate(){
       total=0;
       EntityProfilerQuestion__c delayReason=null;
       for(EntityProfilerQuestion__c obj:scorerList){
           if(obj.score__c==null || (obj.score__c.equals('NA')) || (obj.score__c.equals('-1'))){
           }
           else
                   total=total+Integer.valueOf(obj.score__c);
           if(obj.profilerQuestion__r.name=='PQ-04')
                  delayReason=obj;
        }
        if(delayReasonScore!=NULL)
            total=total+delayReasonScore;
        showTotalPanel=true;
        if(delayReason!=null){
             delayReason.score__c=delayReasonScore+'';
             upsert delayReason;
        }
        
    }
      
}