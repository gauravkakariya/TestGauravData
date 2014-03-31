trigger CreateCheckListSteps1 on Checklist__c (after insert)
 {
   /*List<Checklist_Step__c> checkListStep = new List<Checklist_Step__c>();

    //For each Checklist processed by the trigger, add all
    //check list step record for the specified checklisttemplate.
    //Note that Trigger.New is a list of all the new Checklist
    //that are being created.
    
      for (Checklist__c newCheckList: Trigger.New)
      {
    	   String s = newCheckList.Checklist_Template__c; 
           if (newCheckList.Checklist_Template__c != null) 
             { 
        
                  for (Checklist_Template__c clStep : [SELECT (SELECT Subject,Context__c, Stage__c,Seq_Day__c,OwnerId, ActivityDate,Status, 
                   Description from OpenActivities where isTask=true),Context__c,Name, Stage__c,Sequence__c  FROM Checklist_Template__c 
                   WHERE Checklist_Template__c =
                   :s  ORDER BY Sequence__c ASC])
                  
                   {
                   	 checkListStep.add(new Checklist_Step__c(
                     Name = clStep.Name,
                     Checklist__c = newCheckList.id,
            	     Context__c = clStep.Context__c,
            	     Stage__c = clStep.Stage__c,
            	     Sequence__c = clStep.Sequence__c,
           		     Step_Status__c = 'Not Started'));
            
                      for(OpenActivity taskTemplate : clStep.OpenActivities)
                       {
	                       Integer seqDay = taskTemplate.Seq_Day__c.intValue();
	                       Task task = new Task( 
	                       Context__c = clStep.Context__c,
	                       Stage__c = clStep.Stage__c,      
	                       WhatId = newCheckList.Id,
	                       Subject = taskTemplate.Subject,
	                       ActivityDate = System.today() + seqDay,
	                       OwnerId = taskTemplate.OwnerId,
	                       status = taskTemplate.status,
	                       description = taskTemplate.description);
                            
                           insert task;
                      }
                 }
       
              {
                 for (Checklist_Template__c clStep : [SELECT (SELECT isTask, Subject,Context__c,Stage__c,Seq_Day__c,OwnerId, ActivityDate,Status, 
                  Description from OpenActivities where isTask=false),Context__c,Stage__c,Name, Sequence__c FROM Checklist_Template__c 
                  WHERE Checklist_Template__c =
                  :s  ORDER BY Sequence__c ASC])
                 {  
            
	               /* for(OpenActivity eventTemplate : clStep.OpenActivities)
	                
	                  {
		                Integer seqDay = eventTemplate.Seq_Day__c.intValue(); 
		                Event event = new Event(       
		                WhatId = newCheckList.Id,
		                Context__c = clStep.Context__c,
		                Stage__c = clStep.Stage__c,
		                Subject = eventTemplate.Subject,
		                StartDateTime= System.now() + seqDay,
		                EndDateTime=System.now() + seqDay,
		                OwnerId = eventTemplate.OwnerId,
		                description = eventTemplate.description);
		         
		                insert event;
                    }
              }*/
         /*  }
           
        }
    
    }    
   
    insert checkListStep;*/
}