trigger BeforeUpdateGoalYears on Goal__c (before update) {
    for(Integer j = 0; trigger.new.size()>j; j++){
        for(Integer i = 0; trigger.old.size()>i; i++){
           if(trigger.old[i].id == trigger.new[j].id){
               if(!(trigger.old[i].Goal_Start_Year__c == trigger.new[j].Goal_Start_Year__c 
               && trigger.old[i].Goal_End_Year__c  == trigger.new[j].Goal_End_Year__c)){
                    trigger.new[j].moderately_aggressive_profile_years__c = null;
                    trigger.new[j].moderately_conservative_profile_years__c  = null;
                    trigger.new[j].aggressive_profile_years__c  = null;
                    trigger.new[j].conservative_profile_years__c  = null;
                    trigger.new[j].moderate_profile_years__c  = null;
               }
           }
       } 
    }
}