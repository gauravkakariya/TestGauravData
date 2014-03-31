/*
    Revision History:
    Version     Version Author    Date              Comments
    1.0         Prajakta Sanap   18/12/2013   1. Handler for AccountTrigger to send email alert 
    											 - when entity is created in the advisor factory
                                 
*/

public class AccountWorkflowHandler 
{
	/* Function to create notification queue record on entity creation */
    public static void newEntityCreation(List<Account>accountNewList, map<Id,Account> newMap)
    {
    	set<Id> newMemberSet = new set<Id>();
    	set<Id> teamMemberIdSet = new set<Id>();
        
        //Get the set of members which are newly created
        for(Account acc : accountNewList)
        {
            newMemberSet.add(acc.Id);
            teamMemberIdSet.add(acc.MST_Team_Member__c);
        }
        system.debug('--------newMemberSet----------'+newMemberSet+' - '+teamMemberIdSet);
        
        List<Event_Master__c> lstEM = [Select Task_Event_Master__c, Name, Event_Id__c, Escalation_Event_Master__c 
                                            From Event_Master__c
                                            where isActive__c = true 
                                            and (Name =: Label.New_Entity_Creation_Email_Alert)];
                                            
        map<String,Event_Master__c> mapNameToEventMaster = new map<String,Event_Master__c>();
        for(Event_Master__c objEM : lstEM)
        {
            if(!mapNameToEventMaster.containsKey(objEM.Name))
                mapNameToEventMaster.put(objEM.Name,objEM);
        }
        system.debug('----mapNameToEventMaster.keySet()----'+mapNameToEventMaster.keySet());
        
        List<Notification_Queue__c> lstInsertNotificationQueue = new List<Notification_Queue__c>();
        
        if(teamMemberIdSet.size() > 0)
        {
            for(Id objAccId : newMemberSet)
            {
                if(newMap.get(objAccId).RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {   
             		if(mapNameToEventMaster.containsKey(Label.New_Entity_Creation_Email_Alert))
                    {
                        system.debug('----mapNameToEventMaster in if--------------'+newMap.get(objAccId).Virtual_Partner__c);
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Partner_Id__c = newMap.get(objAccId).Virtual_Partner__c;
                        objNotificationQueue.Biz_Unit__c = newMap.get(objAccId).Business_Unit__c;
                        objNotificationQueue.Member_Id__c = objAccId;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.New_Entity_Creation_Email_Alert).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        //objNotificationQueue.PayloadXML__c = ;
                        system.debug('----objNotificationQueue in if--------------'+objNotificationQueue);
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }    
                           
                } 
            }
        }
        system.debug('----lstInsertNotificationQueue in if--------------'+lstInsertNotificationQueue);
        if(!lstInsertNotificationQueue.isEmpty())
            insert lstInsertNotificationQueue;
    }
    
    
    /* Function to change the Entity Stage according to the condition */
    public static void entityStageChange(List<Account>accountNewList, map<Id,Account> oldMap, map<Id,Account> newMap,Boolean isAfterAcc)
    {
    	set<Id> UpdatedMemberSet = new set<Id>();
        List<Account> lstAccount = new List<Account>();
        List<Account> lstUpdatedAccount = new List<Account>();
        
        //Get the set of members for which dates are updated
        system.debug('************accountNewList'+accountNewList);

        for(Account acc : accountNewList)
        {
        	if(oldMap != null)// && acc.RecordType.Name == 'Client')
        	{
	        	Account oldAcc = oldMap.get(acc.Id);
	        	system.debug('--------11----------'+acc.Data_Collection_Date__c);
	        	system.debug('--------22----------'+oldAcc.Data_Collection_Date__c);
	        	system.debug('-----acc------'+acc);
	        	system.debug('-----oldAcc------'+oldAcc);
	        	
	        	if(acc.Data_Collection_Date__c != oldAcc.Data_Collection_Date__c
	        	|| acc.Plan_Writing_Date__c != oldAcc.Plan_Writing_Date__c 
	        	|| acc.Plan_Approved_Date__c != oldAcc.Plan_Approved_Date__c
	        	|| acc.Action_Plan_Generation_Date__c != oldAcc.Action_Plan_Generation_Date__c
	        	|| acc.IsExecutionTrackerGenerated__c != oldAcc.IsExecutionTrackerGenerated__c)
	        	{
		            UpdatedMemberSet.add(acc.Id);
		            lstAccount.add(acc);
	        	}
        	}
        }
        system.debug('--------UpdatedMemberSet----------'+UpdatedMemberSet);
        
        List<Event_Master__c> lstEM = [Select Task_Event_Master__c, Name, Event_Id__c, Escalation_Event_Master__c 
                                            From Event_Master__c
                                            where isActive__c = true 
                                            and (Name =: Label.Alert_For_Data_Collection_Completion
                                            	or Name =: Label.Alert_For_Plan_Writing_Completion_Date
												or Name =: Label.Alert_For_Plan_Approved_Date
												or Name =: Label.Alert_For_Action_Plan_Generation_Date
												or Name =: Label.Alert_For_First_Execution_Completion_Date
												or Name =: Label.Alert_For_Execution_Completion_Date)];
                                            
        map<String,Event_Master__c> mapNameToEventMaster = new map<String,Event_Master__c>();
        for(Event_Master__c objEM : lstEM)
        {
            if(!mapNameToEventMaster.containsKey(objEM.Name))
                mapNameToEventMaster.put(objEM.Name,objEM);
        }
        system.debug('----mapNameToEventMaster.keySet()----'+mapNameToEventMaster.keySet());
        
        List<Notification_Queue__c> lstInsertNotificationQueue = new List<Notification_Queue__c>();
        
        if(UpdatedMemberSet.size() > 0)
        {
        	system.debug('--------lstAccount----------'+lstAccount);
        	
        	for(Account acc : lstAccount)
        	{
        		if(acc.CreatedDate != null && acc.Data_Collection_Date__c == null
        								   && acc.Plan_Writing_Date__c== null
        								   && acc.Plan_Approved_Date__c == null
        								   && acc.Action_Plan_Generation_Date__c == null)
        		{
        			if(!isAfterAcc)
        			{
        				acc.Entity_Stage__c = 'Data Collection';
        			}
        		}
        		if(acc.Data_Collection_Date__c != null && acc.Plan_Writing_Date__c== null
			        								   && acc.Plan_Approved_Date__c == null
			        								   && acc.Action_Plan_Generation_Date__c == null)
        		{
        			if(!isAfterAcc)
        			{
        				acc.Entity_Stage__c = 'Plan Writing';
        			}
        			if(mapNameToEventMaster.containsKey(Label.Alert_For_Data_Collection_Completion))
                    {
                        system.debug('----mapNameToEventMaster in if--------------'+newMap.get(acc.Id).Virtual_Partner__c);
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Partner_Id__c = newMap.get(acc.Id).Virtual_Partner__c;
                        objNotificationQueue.Biz_Unit__c = newMap.get(acc.Id).Business_Unit__c;
                        objNotificationQueue.Member_Id__c = acc.Id;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.Alert_For_Data_Collection_Completion).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        //objNotificationQueue.PayloadXML__c = ;
                        system.debug('----objNotificationQueue alert 1--------------'+objNotificationQueue);
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }
        		}
        		if(acc.Plan_Writing_Date__c!= null && acc.Plan_Approved_Date__c == null
        								   		   && acc.Action_Plan_Generation_Date__c == null)
        		{
        			if(!isAfterAcc)
        			{
        				acc.Entity_Stage__c = 'Plan Approval';
        			}
        			if(mapNameToEventMaster.containsKey(Label.Alert_For_Plan_Writing_Completion_Date))
                    {
                        system.debug('----mapNameToEventMaster in if--------------'+newMap.get(acc.Id).Virtual_Partner__c);
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Partner_Id__c = newMap.get(acc.Id).Virtual_Partner__c;
                        objNotificationQueue.Biz_Unit__c = newMap.get(acc.Id).Business_Unit__c;
                        objNotificationQueue.Member_Id__c = acc.Id;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.Alert_For_Plan_Writing_Completion_Date).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        //objNotificationQueue.PayloadXML__c = ;
                        system.debug('----objNotificationQueue alert 2--------------'+objNotificationQueue);
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }
        		}
        		if(acc.Plan_Approved_Date__c != null && acc.Action_Plan_Generation_Date__c == null)
        		{
        			system.debug('--------Plan_Approved_Date__c----------'+acc.Plan_Approved_Date__c);
        			
        			if(!isAfterAcc)
        			{
        				acc.Entity_Stage__c = 'Action Plan Generation';
        			}
        			
        			if(mapNameToEventMaster.containsKey(Label.Alert_For_Plan_Approved_Date))
                    {
                        system.debug('----mapNameToEventMaster in if--------------'+newMap.get(acc.Id).Virtual_Partner__c);
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Partner_Id__c = newMap.get(acc.Id).Virtual_Partner__c;
                        objNotificationQueue.Biz_Unit__c = newMap.get(acc.Id).Business_Unit__c;
                        objNotificationQueue.Member_Id__c = acc.Id;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.Alert_For_Plan_Approved_Date).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        //objNotificationQueue.PayloadXML__c = ;
                        system.debug('----objNotificationQueue alert 3--------------'+objNotificationQueue);
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }
        		}
        		if(acc.Action_Plan_Generation_Date__c != null)
        		{
        			if(!isAfterAcc)
        			{
        				acc.Entity_Stage__c = 'Ready for Execution';
        			}
        			if(mapNameToEventMaster.containsKey(Label.Alert_For_Action_Plan_Generation_Date))
                    {
                        system.debug('----mapNameToEventMaster in if--------------'+newMap.get(acc.Id).Virtual_Partner__c);
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Partner_Id__c = newMap.get(acc.Id).Virtual_Partner__c;
                        objNotificationQueue.Biz_Unit__c = newMap.get(acc.Id).Business_Unit__c;
                        objNotificationQueue.Member_Id__c = acc.Id;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.Alert_For_Action_Plan_Generation_Date).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        //objNotificationQueue.PayloadXML__c = ;
                        system.debug('----objNotificationQueue alert 4--------------'+objNotificationQueue);
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }
        		}
        		if(acc.IsExecutionTrackerGenerated__c == true && acc.Action_Plan_Generation_Date__c!= null)
        		{
        			acc.First_Execution_Completion_Date__c = acc.Action_Plan_Generation_Date__c;
        			
        			if(!isAfterAcc)
        			{
        				acc.Entity_Stage__c = 'Execution in Progress';
        			}
        			if(mapNameToEventMaster.containsKey(Label.Alert_For_First_Execution_Completion_Date))
                    {
                        system.debug('----mapNameToEventMaster in if--------------'+newMap.get(acc.Id).Virtual_Partner__c                                                                                             );
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Partner_Id__c = newMap.get(acc.Id).Virtual_Partner__c;
                        objNotificationQueue.Biz_Unit__c = newMap.get(acc.Id).Business_Unit__c;
                        objNotificationQueue.Member_Id__c = acc.Id;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.Alert_For_First_Execution_Completion_Date).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        //objNotificationQueue.PayloadXML__c = ;
                        system.debug('----objNotificationQueue alert 5--------------'+objNotificationQueue);
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }
        		}
        		
        		
        		system.debug('--------acc----entityStageChange------'+acc);
        		lstUpdatedAccount.add(acc);
        	}							
        }
        system.debug('--------acc----lstInsertNotificationQueue------'+lstInsertNotificationQueue);
    	if(!lstInsertNotificationQueue.isEmpty())
    	{
    		insert lstInsertNotificationQueue;
    	}
    }
    
    /*Function to create task and assign to MST Team Member , and create Notification Queue for email*/     
  /*  public static void createTaskForBirthdayAlert(List<Account> newAccountList, Map<Id, Account> oldAccountMap)
    {	
    	List<Account> lstAccount = new List<Account>();
    	List<Task> listTask = new List<Task>();
    	List<Notification_Queue__c> lstNotification_Queue = new List<Notification_Queue__c>();
    	set<Id> setAccountId = new set<Id>();
    	set<Id> setMstTeamMember = new set<Id>();
    	set<Id> setBizUnit = new set<Id>();
    	set<Id> setVPartner = new set<Id>();
    	Task objTask;
    	
    	for(Account objAcc : newAccountList)
    	{
    		system.debug('******Test*********'+objAcc);
    		system.debug('******Test*********'+objAcc.Birthday_This_Year__pc);
			if(objAcc.Birthday_This_Year__pc >= system.today() && (objAcc.MST_Team_Member__c != null))
			{
				if(oldAccountMap!=null && oldAccountMap.get(objAcc.Id).Birthday_This_Year__pc == objAcc.Birthday_This_Year__pc){
					continue;
				}
				setAccountId.add(objAcc.Id);
				setMstTeamMember.add(objAcc.MST_Team_Member__c);				 
				lstAccount.add(objAcc);
			}    		
    	}
    	//system.debug('-------setAccountId-------'+setAccountId);
    	
    	if(setAccountId.size() > 0)
    	{
    		objTask = new Task();
    		Team_Member__c MSTTeam_Member;
            
            map<Id, Team_Member__c> mapIdToMSTMember = new map<Id, Team_Member__c>([Select Id, Team_Member__c
                                                                                    from Team_Member__c 
                                                                                    where Id IN: setMstTeamMember]);
            system.debug('----mapIdToMSTMember------'+mapIdToMSTMember);
            
            Event_Master__c event = [Select Name,Id From Event_Master__c where Name=: Label.Happy_Birthday_To_Client];
            
            for(Account objAccount : lstAccount)
            {
                if(mapIdToMSTMember.containsKey(objAccount.MST_Team_Member__c))
                {
                	objTask = new Task();
                    MSTTeam_Member = mapIdToMSTMember.get(objAccount.MST_Team_Member__c);
                    system.debug('----MSTTeam_Member------'+MSTTeam_Member);
                    objTask.OwnerId = MSTTeam_Member.Team_Member__c;
					objTask.Subject = Label.HappyBithday ;
    		        objTask.Subject_Category__c = 'Email';
    		        objTask.Priority = 'High';
    		        objTask.WhatId = objAccount.Id;
    		        listTask.add(objTask);
                }//if ends
                        	
                Notification_Queue__c objNoteQueue = new Notification_Queue__c();
												
				objNoteQueue.Biz_Unit__c = objAccount.Business_Unit__c;				
				if(event != null ){
				    objNoteQueue.Event__c = event.Id;
				}    
				objNoteQueue.Channel_Type__c = 'Email';
				objNoteQueue.Member_Id__c = objAccount.Id;
				objNoteQueue.Partner_Id__c = objAccount.Virtual_Partner__c;
				objNoteQueue.Custom_Object_Type__c = 'Task';
				
				system.debug('----------objNoteQueue---****---'+objNoteQueue);
				lstNotification_Queue.add(objNoteQueue);              
            }//for ends
        }//outer if
        system.debug('***listTask***'+listTask);  
        system.debug('***lstNotification_Queue***'+lstNotification_Queue);   	
        if(!listTask.isEmpty()){
    		insert(listTask);    		
    	}
    	if(!lstNotification_Queue.isEmpty()){
    		insert(lstNotification_Queue);    		
    	}
    }*/
}