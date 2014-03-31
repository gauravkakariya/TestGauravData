/* Batch class to create Task and assign to MST Team Member and Notification queue for entities to wish Birthday*/
global class BatchForCreatingTaskAndAssignToMST implements Database.Batchable<Sobject>{
	
	List<Task> lstTaskTobeCreate = new List<Task>();
	//List<Notification_Queue__c> lstNotification_Queue = new List<Notification_Queue__c>();
	map<Id, User> mapIdToMSTUser;
	
	//start     
    global Database.Querylocator start(Database.BatchableContext context ){
    	
    	Id recordId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
    	Date dateStr = system.today();
    	String queryStr = 'Select Virtual_Partner__c, Name, MST_Team_Member__c, Id, Business_Unit__c, Birthday_This_Year__pc From Account Where RecordTypeId=:recordId and Birthday_This_Year__pc=:dateStr';
        
        return Database.getQueryLocator(queryStr);
    }

	//execute
	global void execute(Database.BatchableContext context, List<Account> listAcc){
	
	    set<Id> setMstTeamMember = new set<Id>();
	    Task objTask;
	    system.debug('******listAcc*********'+listAcc);
	    List<ID> teamMemId = new List<ID>();
	    map<Id, String> teamMemName = new map<Id, String>();
	    map<Id, String> teamMemNameID = new map<Id, String>();
	    
	    if(listAcc.size() >0){
	    	for(Account account : listAcc){
	    		setMstTeamMember.add(account.MST_Team_Member__c);
	    	}	    	
	    	
	    	Team_Member__c MSTTeam_Member;            
        	map<Id, Team_Member__c> mapIdToMSTMember = new map<Id, Team_Member__c>([Select Id, Team_Member__c,Name
                                                                                    from Team_Member__c 
                                                                                    where Id IN: setMstTeamMember]);
        	system.debug('----mapIdToMSTMember------'+mapIdToMSTMember);
            
        	Event_Master__c event = [Select Name,Id From Event_Master__c where Name=: Label.Happy_Birthday_To_Client];
        
        	for(Account objAccount : listAcc){
        
            	if(mapIdToMSTMember.containsKey(objAccount.MST_Team_Member__c)){
                	objTask = new Task();
                	MSTTeam_Member = mapIdToMSTMember.get(objAccount.MST_Team_Member__c);
                	system.debug('----MSTTeam_Member------'+MSTTeam_Member);
                	objTask.OwnerId = MSTTeam_Member.Team_Member__c;
					objTask.Subject = Label.HappyBithday ;
    		    	objTask.Subject_Category__c = 'Email';
    		    	objTask.Priority = 'High';
    		    	objTask.WhatId = objAccount.Id;
    		    	objTask.ActivityDate = objAccount.Birthday_This_Year__pc;    		    	
    		    	lstTaskTobeCreate.add(objTask);
    		    	
    		    	teamMemId.add(MSTTeam_Member.Team_Member__c);
    		    	teamMemName.put(objAccount.Id, mapIdToMSTMember.get(objAccount.MST_Team_Member__c).Name);
    		    	teamMemNameID.put(objAccount.Id, objAccount.Name);
            	}//if ends
                system.debug('----teamMemName------'+teamMemName);        	
            	/*Notification_Queue__c objNoteQueue = new Notification_Queue__c();
												
				objNoteQueue.Biz_Unit__c = objAccount.Business_Unit__c;				
				if(event != null ){
			    	objNoteQueue.Event__c = event.Id;
				}    
				objNoteQueue.Channel_Type__c = 'Email';
				objNoteQueue.Member_Id__c = objAccount.Id;
				objNoteQueue.Partner_Id__c = objAccount.Virtual_Partner__c;
				objNoteQueue.Custom_Object_Type__c = 'Task';
				
				system.debug('----------objNoteQueue---****---'+objNoteQueue);
				lstNotification_Queue.add(objNoteQueue); */             
        	}//for ends
        }//outer if
        
        system.debug('***listTask***'+lstTaskTobeCreate);  
        //system.debug('***lstNotification_Queue***'+lstNotification_Queue);
        
        mapIdToMSTUser = new map<Id, User>([Select Id, Email, Name From User where Id IN: teamMemId]);
	    system.debug('*****mapIdToMSTUser***'+mapIdToMSTUser);
        
        map<String,String> listEmail = new map<String,String>();
        for(User objUser : mapIdToMSTUser.values()){
        	listEmail.put(objUser.Name,objUser.Email);
        }   	
        system.debug('***listEmail***'+listEmail);
        
        Messaging.SingleEmailMessage[]  lstMessageEmail = new Messaging.SingleEmailMessage[]{};        
        if(!lstTaskTobeCreate.isEmpty()){
    		insert(lstTaskTobeCreate); 
    		for(String obj : teamMemName.keySet()){
    			Messaging.Singleemailmessage draftMail = new Messaging.Singleemailmessage();
       	 		draftMail.setToAddresses(new List<String>{listEmail.get(teamMemName.get(obj))});
       	 		draftMail.setSubject(Label.HappyBithday);
       	 		draftMail.setHtmlBody('Hi '+teamMemName.get(obj)+',  <br></br>' +
       	 		                            Label.Birthday_Alert_Reminder_task_has_been_created_for_entity + ' - '+'"<b>'+teamMemNameID.get(obj)+'.</b>"');
         		lstMessageEmail.add(draftMail);
    		}    		   		
    	}
    	Messaging.sendEmail(lstMessageEmail);
    	/*if(!lstNotification_Queue.isEmpty()){ Messaging.sendEmail(new Messaging.SingleEmailMessage[] { draftMail });
    		insert(lstNotification_Queue);    		
    	}*/	
	}
	
	//finish
    global void finish(Database.BatchableContext context){
    
    }


}