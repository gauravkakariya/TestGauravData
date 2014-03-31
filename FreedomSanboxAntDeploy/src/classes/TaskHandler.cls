/*
    Revision History:
    Version       Author    Date          Comments
    2.0           Gaurav   	15/10/2013    1.Task Handler to update task status and create new task as per Wflowtracker Sequence
*/

public class TaskHandler 
{
	public static Boolean executed = false;
	public MAP<Id,Workflows_Tracker_Details__c> mapNewWFlowTrackerIdToWFlowTracker{get;set;}
	
	/*
	//Update WFlowTrackerDetails record to Completed Status when task is completed
	public void onAfterUpdateToWFlowTrackerDetails(map<Id, Task> mapOldTaskIdToTask, map<Id, Task> mapNewTaskIdToTask)
	{
		List<Workflows_Tracker_Details__c> lstWFlowTrackerTrackerToUpdate = new List<Workflows_Tracker_Details__c>();
		MAP<Id, String> mapTaskIdToStatus = new MAP<Id, String>();
		MAP<Id, Id> mapTaskIdToAccountId = new MAP<Id, String>();
		
		//Get All task whose status is completed												 
		for(Task objTask : mapNewTaskIdToTask.values())
		{
			if(mapOldTaskIdToTask.get(objTask.Id).Status != Label.Completed
				&& objTask.Status == Label.Completed)
			{
				mapTaskIdToAccountId.put(objTask.Id, objTask.WhatId);
				mapTaskIdToStatus.put(objTask.Id, objTask.Status);
			}	
			
		}
		
		//Collect all wflowtrackerdetails record whose Task id available in Wflowtrackerdetails
		List<Workflows_Tracker_Details__c> lstWFlowTrackerTracker = [Select Task_Sequence__c, 
											    							Task_Id__c, Subject__c, Status__c, 
													    					Related_Workflow_Details_Date__c, Priority__c,
													    					Event_Master__r.Escalation_Event_Master__c,Workflows_Tracker_Master__c,
													    					Workflows_Tracker_Master__r.Name,
																			Parent_Workflows_Tracker_Details__c, Name, Id, Event_Master__c, 
																			Due_Date__c, Department__c, Department__r.Business_Unit__c,Days_After__c, Comments__c, 
																			Channel_Type__c ,Workflows_Tracker_Master__r.Parent_Account__c
																	  From Workflows_Tracker_Details__c 
			                                      				      Where Task_Id__c IN: mapTaskIdToAccountId.keySet()];
		
		if(!lstWFlowTrackerTracker.isEmpty())
		{
			for(Workflows_Tracker_Details__c objFlowTracker : lstWFlowTrackerTracker)
			{
				if(objFlowTracker.Workflows_Tracker_Master__r.Parent_Account__c == mapTaskIdToAccountId.get(objFlowTracker.Task_Id__c))
				{
					objFlowTracker.Status__c = mapTaskIdToStatus.get(objFlowTracker.Task_Id__c);
					lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
				}
			}
			
			//Update Wflowtracker details record to completed status
			if(!lstWFlowTrackerTrackerToUpdate.isEmpty())
				
				update lstWFlowTrackerTrackerToUpdate;
			
		}
	} 
	*/
	
	public void onBeforeUpdatePopulateCompletionDate(map<Id, Task> mapOldTaskIdToTask,map<Id, Task> mapNewTaskIdToTask)
	{
		for(Task taskInst : mapNewTaskIdToTask.values())
		{
			system.debug('taskInst -- > '+ taskInst);
			if(mapOldTaskIdToTask.get(taskInst.Id).Status != Label.Completed && mapNewTaskIdToTask.get(taskInst.Id).Status == Label.Completed)
			{
				taskInst.Automated_Flows_Completion_Date__c = System.Now();
				system.debug('taskInst after-- > '+ taskInst);
			}
		}
	}
	
	
	public void onAfterUpdateTaskToUpdateAccount(map<Id, Task> mapOldTaskIdToTask, map<Id, Task> mapNewTaskIdToTask)
	{
		MAP<Id,String> mapWFlowTrackerIdToAccountId = new MAP<Id,String>();
		MAP<Id,Workflows_Tracker_Details__c> mapWFlowTrackerIdToWFlowTracker = new MAP<Id,Workflows_Tracker_Details__c>();
		MAP<Id, Task> mapIdToCompleteTask = new MAP<Id, Task>();
		MAP<Id, Task> mapIdToNotCompleteTask  = new MAP<Id, Task>();
		List<Account> lstUpdateAccount = new List<Account>();
		MAP<Id,Account> mapAccountIdToAccount = new MAP<Id,Account>();
		List<Task> lstUpdateTask = new List<Task>();
		List<Workflows_Tracker_Details__c> lstWFlowTrackerTrackerToUpdate = new List<Workflows_Tracker_Details__c>();
		mapNewWFlowTrackerIdToWFlowTracker  = new MAP<Id,Workflows_Tracker_Details__c>();
		Map<Id, Workflows_Tracker_Details__c> mapParentWflowTrackerIdToParentWflowTrackerRecord; 
		List<Task> lstDeleteTask = new List<Task>();
		Map<Id, Workflows_Tracker_Master__c> mapIdToWorkflowsTrackerMasterRecord = new Map<Id, Workflows_Tracker_Master__c>(); 
		List<String> lstParentWFlowTrackerRecordId = new List<String>();
		
		if(mapNewTaskIdToTask != null)
		{
			List<Task> lstTask = [Select WhatId, 
										Subject_Category__c, Subject, Status, Description,
										RecordTypeId, Priority, Plan_Presentation_Completion_Status__c, 
										PartnerFinancialPlanPresentationDate__c, MemberFinancialPlanPresentationDate__c, 
										Id, FinancialPlanGenerationDate__c, FinancialPlanCompletionDate__c,ExpectedFinancialPlanGenerationDate__c, 
										ExecutionTrackerOpenedDate__c, Event_Status__c, Entity_Intereseted_in_FP_Status__c, 
										Data_Collection_Approved_Status__c, DataCollectionDate__c, ActivityDate, 
										ActionPlanSharingDate__c 
						 		 From Task  
						 		 Where Id IN: mapNewTaskIdToTask.keySet()];
											 		
			for(Task objTask : lstTask)			
			{
				if(objTask.Status == Label.Completed)
				{
					mapIdToCompleteTask.put(objTask.Id, objTask);
				}
				else if(objTask.Status <> Label.Completed)
				{
					mapIdToNotCompleteTask.put(objTask.Id, objTask);
				}
			}	
			
		/*	mapIdToCompleteTask = new Map<Id, Task>([Select WhatId, 
															Subject_Category__c, Subject, Status, Description,
															RecordTypeId, Priority, Plan_Presentation_Completion_Status__c, 
															PartnerFinancialPlanPresentationDate__c, MemberFinancialPlanPresentationDate__c, 
															Id, FinancialPlanGenerationDate__c, FinancialPlanCompletionDate__c,ExpectedFinancialPlanGenerationDate__c, 
															ExecutionTrackerOpenedDate__c, Event_Status__c, Entity_Intereseted_in_FP_Status__c, 
															Data_Collection_Approved_Status__c, DataCollectionDate__c, ActivityDate, 
															ActionPlanSharingDate__c 
											 		 From Task  
											 		 Where Id IN: mapNewTaskIdToTask.keySet() 
											 		 	and Status =:Label.Completed]);
		
		
		 
		    mapIdToNotCompleteTask = new Map<Id, Task>([Select WhatId, 
															Subject_Category__c, Subject, Status, Description,
															RecordTypeId, Priority, Plan_Presentation_Completion_Status__c, 
															PartnerFinancialPlanPresentationDate__c, MemberFinancialPlanPresentationDate__c, 
															Id, FinancialPlanGenerationDate__c, FinancialPlanCompletionDate__c,ExpectedFinancialPlanGenerationDate__c, 
															ExecutionTrackerOpenedDate__c, Event_Status__c, Entity_Intereseted_in_FP_Status__c, 
															Data_Collection_Approved_Status__c, DataCollectionDate__c, ActivityDate, 
															ActionPlanSharingDate__c 
											 		 From Task  
											 		 Where Id IN: mapNewTaskIdToTask.keySet() 
											 		 	and Status <>:Label.Completed]);*/
											 		 	
		//query to get records if status <> completed
		// iterate and check for WFTD records
		/// then check for status and if Data Collection Date Confirmation or Plan presentaion date confirmation handle accordingly
		// dont do anything if same date entered
		
		}
		
		if(mapIdToNotCompleteTask.keySet() != null)
		{
			system.debug('**********mapIdToCompleteTask*******'+mapIdToCompleteTask);
			//Collect all wflowtrackerdetails record whose Task id available in Wflowtrackerdetails
			List<Workflows_Tracker_Details__c> lstWFlowTrackerTrackerForNotCompletedTask = [Select Task_Sequence__c, 
												    							Task_Id__c, Subject__c, Status__c, 
														    					Related_Workflow_Details_Date__c, Priority__c,
														    					Event_Master__r.Escalation_Event_Master__c,Workflows_Tracker_Master__c,
														    					Workflows_Tracker_Master__r.Name, Parent_Workflows_Tracker_Details__r.Status__c,
																				Parent_Workflows_Tracker_Details__c, Name, Id, Event_Master__c, 
																				Due_Date__c, Department__c, Department__r.Business_Unit__c,Days_After__c, Comments__c, 
																				Channel_Type__c ,Workflows_Tracker_Master__r.Parent_Account__c
																		  From Workflows_Tracker_Details__c 
				                                      				      Where Task_Id__c IN: mapIdToNotCompleteTask.keySet() and Status__c !=: Label.Completed];
		
			system.debug('**********lstWFlowTrackerTracker*******'+lstWFlowTrackerTrackerForNotCompletedTask);
			if(!lstWFlowTrackerTrackerForNotCompletedTask.isEmpty())
			{
				
				for(Workflows_Tracker_Details__c objFlowTracker : lstWFlowTrackerTrackerForNotCompletedTask)
				{
					String accountId = objFlowTracker.Workflows_Tracker_Master__r.Parent_Account__c;
					mapWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id, objFlowTracker);
					mapWFlowTrackerIdToAccountId.put(objFlowTracker.Id, accountId);
					lstParentWFlowTrackerRecordId.add(objFlowTracker.Parent_Workflows_Tracker_Details__c);
					mapIdToWorkflowsTrackerMasterRecord.put(objFlowTracker.Id, objFlowTracker.Workflows_Tracker_Master__r);
					
				}
				
		}	
			
		
		
		if(mapIdToCompleteTask.keySet() != null)
		{
			system.debug('**********mapIdToCompleteTask*******'+mapIdToCompleteTask);
			//Collect all wflowtrackerdetails record whose Task id available in Wflowtrackerdetails
			List<Workflows_Tracker_Details__c> lstWFlowTrackerTracker = [Select Task_Sequence__c, 
												    							Task_Id__c, Subject__c, Status__c, 
														    					Related_Workflow_Details_Date__c, Priority__c,
														    					Event_Master__r.Escalation_Event_Master__c,Workflows_Tracker_Master__c,
														    					Workflows_Tracker_Master__r.Name, Parent_Workflows_Tracker_Details__r.Status__c,
																				Parent_Workflows_Tracker_Details__c, Name, Id, Event_Master__c, 
																				Due_Date__c, Department__c, Department__r.Business_Unit__c,Days_After__c, Comments__c, 
																				Channel_Type__c ,Workflows_Tracker_Master__r.Parent_Account__c
																		  From Workflows_Tracker_Details__c 
				                                      				      Where Task_Id__c IN: mapIdToCompleteTask.keySet() and Status__c !=: Label.Completed];
		
			system.debug('**********lstWFlowTrackerTracker*******'+lstWFlowTrackerTracker);
			if(!lstWFlowTrackerTracker.isEmpty())
			{
				for(Workflows_Tracker_Details__c objFlowTracker : lstWFlowTrackerTracker)
				{
					system.debug('**********objFlowTracker*******'+objFlowTracker);
					String accountId = objFlowTracker.Workflows_Tracker_Master__r.Parent_Account__c;
					mapWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id, objFlowTracker);
					mapWFlowTrackerIdToAccountId.put(objFlowTracker.Id, accountId);
					lstParentWFlowTrackerRecordId.add(objFlowTracker.Parent_Workflows_Tracker_Details__c);
					mapIdToWorkflowsTrackerMasterRecord.put(objFlowTracker.Id, objFlowTracker.Workflows_Tracker_Master__r);
					system.debug('**********lstParentWFlowTrackerRecordId*******'+lstParentWFlowTrackerRecordId);
				}
				
			}
			
			if(lstParentWFlowTrackerRecordId.size() > 0)
			{
				//Collect all parent wflowtrackerdetails record whose Task id available in Wflowtrackerdetails
				mapParentWflowTrackerIdToParentWflowTrackerRecord = new  Map<id, Workflows_Tracker_Details__c>
																([Select Task_Sequence__c, 
										    							Task_Id__c, Subject__c, Status__c, 
												    					Related_Workflow_Details_Date__c, Priority__c,
												    					Event_Master__r.Escalation_Event_Master__c,Workflows_Tracker_Master__c,
												    					Workflows_Tracker_Master__r.Name, Parent_Workflows_Tracker_Details__r.Status__c,
																		Parent_Workflows_Tracker_Details__c, Name, Id, Event_Master__c, 
																		Due_Date__c, Department__c, Department__r.Business_Unit__c,Days_After__c, Comments__c, 
																		Channel_Type__c ,Workflows_Tracker_Master__r.Parent_Account__c
																		,Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c
																  From Workflows_Tracker_Details__c  
																  Where Id IN: lstParentWFlowTrackerRecordId]);
																		  
																		  
			}	    
			     
			if(mapWflowTrackerIdToAccountId.keyset() != null)  
			{    
				//Collect all Account Record whose wflowtracker Record avaialable
				mapAccountIdToAccount = new map<Id, Account>([Select Id,Name,IsPersonAccount,FirstName, LastName,
																	 Entity_Intereseted_in_FP_Status__c, 
																	 DataCollectionDate__c,ExpectedFinancialPlanGenerationDate__c,
															         FinancialPlanCompletionDate__c,PartnerFinancialPlanPresentationDate__c, 
																	 MemberFinancialPlanPresentationDate__c,Plan_Presentation_Completion_Status__c,
																	 PlanGenerationDateFromSystem__c,ActionPlanSharingDate__c
															 From Account 
															 Where Id IN:mapWflowTrackerIdToAccountId.values()]);
			}												 	
		}		
		
		if(!lstWFlowTrackerTrackerForNotCompletedTask.isEmpty())
		{
			for(Workflows_Tracker_Details__c objFlowTracker : lstWFlowTrackerTrackerForNotCompletedTask)
		    {
					system.debug('*********objFlowTracker****'+objFlowTracker);
					Account objAccount;
					Task objTask;
					Workflows_Tracker_Details__c objOldFlowTracker;
					Id accountId = mapWFlowTrackerIdToAccountId.get(objFlowTracker.Id);
					objAccount = mapAccountIdToAccount.get(accountId);
					objTask = mapIdToNotCompleteTask.get(objFlowTracker.Task_Id__c);
					String wflowTrackerTaskStatus = '0/18';	
						
						
						if(objFlowTracker.Subject__c == Label.Data_Collection_Date_Confirmation)
					    {
								wflowTrackerTaskStatus = '5/18';
								objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
								
								system.debug('******objFlowTracker.Subject__c5*********'+objFlowTracker.Subject__c);
								if(objTask.DataCollectionDate__c != null)
								{
									// If New Date Entered 
									if(objTask.DataCollectionDate__c != objAccount.DataCollectionDate__c)
									{
										system.debug('*******bjTask.DataCollectionDate__c*********'+objTask.DataCollectionDate__c);
										system.debug('*******objAccountDataCollectionDate__c*********'+objAccount.DataCollectionDate__c);
										objAccount.DataCollectionDate__c = objTask.DataCollectionDate__c;
										objTask.ActivityDate = objTask.DataCollectionDate__c.addDays(-1);
										objTask.Status = Label.In_Progress;
										
										lstUpdateAccount.add(objAccount);
										lstUpdateTask.add(objTask);
									}
									
								}
						
					    }
					    
					   if(objFlowTracker.Subject__c == Label.Plan_Presentation_Date_Confirmation)
					   {
							wflowTrackerTaskStatus = '10/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
								
							if(objTask.MemberFinancialPlanPresentationDate__c != null)
							{ 
								// If New Date Entered 
								if(objTask.MemberFinancialPlanPresentationDate__c  != objAccount.MemberFinancialPlanPresentationDate__c )
								{
									objAccount.MemberFinancialPlanPresentationDate__c  = objTask.MemberFinancialPlanPresentationDate__c;
									objTask.ActivityDate = objTask.MemberFinancialPlanPresentationDate__c.addDays(-1);
									objTask.Status = Label.In_Progress;
									
									lstUpdateAccount.add(objAccount);
									lstUpdateTask.add(objTask);
								}
							}
					    
					   }
						
					}
					
			}	
		}
									 
		if(mapWFlowTrackerIdToWFlowTracker != null && mapWFlowTrackerIdToWFlowTracker.values() != null && mapAccountIdToAccount != null)
		{
			for(Workflows_Tracker_Details__c objFlowTracker : mapWFlowTrackerIdToWFlowTracker.values())		
			{
				system.debug('*********objFlowTracker****'+objFlowTracker);
				Account objAccount;
				Task objTask;
				Workflows_Tracker_Details__c objOldFlowTracker;
				Id accountId = mapWFlowTrackerIdToAccountId.get(objFlowTracker.Id);
				objAccount = mapAccountIdToAccount.get(accountId);
				objTask = mapIdToCompleteTask.get(objFlowTracker.Task_Id__c);
				String wflowTrackerTaskStatus = '0/18';	
				if(objAccount != null && objTask != null)
				{
					if(objFlowTracker.Workflows_Tracker_Master__r.Parent_Account__c == accountId)
					{
						//Task Sequence 1 Meeting for Entity Details
						if(objFlowTracker.Subject__c == Label.Meeting_for_Entity_Details)
						{
							if(mapOldTaskIdToTask.get(objTask.Id).Status != Label.Completed && mapNewTaskIdToTask.get(objTask.Id).Status == Label.Completed)
							{
								if(objTask.Entity_Intereseted_in_FP_Status__c == Label.Converted)
								{
									wflowTrackerTaskStatus = '1/18';
									objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
									
									objAccount.Entity_Intereseted_in_FP_Status__c = objTask.Entity_Intereseted_in_FP_Status__c;
									
									if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
									{
										system.debug('*********objFlowTracker****'+objFlowTracker);
										objFlowTracker.Status__c = Label.Completed;
										mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
									}
									else
									{
										system.debug('*********objFlowTracker111****'+objFlowTracker);
										Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
										objFlowTrackerTemp.Status__c = Label.Completed;
										mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
									}
									//objFlowTracker.Status__c = Label.Completed;
									//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
									
									lstUpdateAccount.add(objAccount);
								}
								else if(objTask.Entity_Intereseted_in_FP_Status__c == Label.Interested_in_FP)
								{
									wflowTrackerTaskStatus = '1/18';
									objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
									
									//Here Wflow tracker not updated
									Date newDate = Date.today();
									objAccount.Entity_Intereseted_in_FP_Status__c = objTask.Entity_Intereseted_in_FP_Status__c;
									//objTask.ActivityDate = Date.today().addDays(3);
									Date dueDate = Date.today().addDays(3);
									Datetime dt = (DateTime)dueDate;
									String dayOfWeek = dt.format('EEEE'); 
									system.debug('*********dayOfWeek****'+dayOfWeek);
									
									if(dayOfWeek == 'Sunday')
									{
										newDate = dueDate.addDays(1);
										system.debug('*********newDate****'+newDate);
									}
									else
										newDate = dueDate;
										
									objTask.Status = Label.In_Progress;
									
									lstUpdateTask.add(objTask);
									lstUpdateAccount.add(objAccount);
								}
								else if(objTask.Entity_Intereseted_in_FP_Status__c == Label.Not_Interested_in_FP)
								{
									wflowTrackerTaskStatus = '1/18';
									objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
									
									if(mapOldTaskIdToTask.get(objTask.Id).Status != Label.Completed && mapNewTaskIdToTask.get(objTask.Id).Status == Label.Completed)
									{
										objAccount.Entity_Intereseted_in_FP_Status__c = objTask.Entity_Intereseted_in_FP_Status__c;
										
										lstUpdateTask.add(objTask);
										lstUpdateAccount.add(objAccount);
									}
								}
							}
								
						}
							
						//Task Sequence 2 Welocme Call 
						else if(objFlowTracker.Subject__c == Label.Welcome_Call)
						{
							wflowTrackerTaskStatus = '2/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							// Wflow tracker updated
							if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
							
						}
						
						//Task Sequence 3 Welcome Mail + SMS
						else if(objFlowTracker.Subject__c == Label.Welcome_Email_Sms)
						{
							wflowTrackerTaskStatus = '3/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							// Wflow tracker updated
							if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
						}
						//Task Sequence 4 Data Collection Date Finalization
						else if(objFlowTracker.Subject__c == Label.Data_Collection_Date_Finalisation)
						{
							wflowTrackerTaskStatus = '4/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							system.debug('******objFlowTracker.Subject__c4*********'+objFlowTracker.Subject__c);
							if(objTask.DataCollectionDate__c != null)
							{
								objAccount.DataCollectionDate__c = objTask.DataCollectionDate__c;
								lstUpdateAccount.add(objAccount);
								
								// Wflow tracker updated
								if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
								{
									objFlowTracker.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
								}
								else
								{
										Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
										objFlowTrackerTemp.Status__c = Label.Completed;
										mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
							}
						}
						//Task Sequence 5 Data Collection Date Confirmation
						else if(objFlowTracker.Subject__c == Label.Data_Collection_Date_Confirmation)
						{
							wflowTrackerTaskStatus = '5/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							system.debug('******objFlowTracker.Subject__c5*********'+objFlowTracker.Subject__c);
							if(objTask.DataCollectionDate__c != null)
							{
								// If New Date Entered 
								if(objTask.DataCollectionDate__c != objAccount.DataCollectionDate__c)
								{
									system.debug('*******bjTask.DataCollectionDate__c*********'+objTask.DataCollectionDate__c);
									system.debug('*******objAccountDataCollectionDate__c*********'+objAccount.DataCollectionDate__c);
									objAccount.DataCollectionDate__c = objTask.DataCollectionDate__c;
									objTask.ActivityDate = objTask.DataCollectionDate__c.addDays(-1);
									objTask.Status = Label.In_Progress;
									
									lstUpdateAccount.add(objAccount);
									lstUpdateTask.add(objTask);
								}
								//If Same Date as of Data Collection Confirmation
								else if(objTask.DataCollectionDate__c == objAccount.DataCollectionDate__c)
								{
									objAccount.DataCollectionDate__c = objTask.DataCollectionDate__c;
									lstUpdateAccount.add(objAccount);
									
									// Wflow tracker updated
									if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
									{
										objFlowTracker.Status__c = Label.Completed;
										mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
									}
									else
									{
										Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
										objFlowTrackerTemp.Status__c = Label.Completed;
										mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
									}
								}// end else if
							}
						}
						
						//Task Sequence 6 Data Collection Completion
						else if(objFlowTracker.Subject__c == Label.Data_Collection_Completion)
						{
							wflowTrackerTaskStatus = '6/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							system.debug('******objFlowTracker.Subject__c6*********'+objFlowTracker.Subject__c);
								
							// Wflow tracker updated
							if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
						}
						//Task Sequence 7 Data Collection Completion Approved
						else if(objFlowTracker.Subject__c == Label.Data_Collection_Completion_Approved)
						{
							wflowTrackerTaskStatus = '7/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							if(objTask.Data_Collection_Approved_Status__c == Label.Accept)
							{
								objAccount.Data_Collection_Completion_Reject_Reason__c = objTask.Description;
								lstUpdateAccount.add(objAccount);
								
								// Wflow tracker updated
								if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
								{
									objFlowTracker.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
								}
								else
								{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
								
							}
							else if(objTask.Data_Collection_Approved_Status__c ==  Label.Reject)
							{
								// Wflow tracker updated
								objOldFlowTracker = mapParentWflowTrackerIdToParentWflowTrackerRecord.get(objFlowTracker.Parent_Workflows_Tracker_Details__c);
								
								//Reject Reason
								objAccount.Data_Collection_Completion_Reject_Reason__c = objTask.Description;
								lstUpdateAccount.add(objAccount);
								
								system.debug('*****objOldFlowTracker-----********'+objOldFlowTracker);
								if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objOldFlowTracker.Id))
								{
									system.debug('*****objOldFlowTracker********'+objOldFlowTracker);
									objOldFlowTracker.Status__c = Label.In_Progress;	
									objFlowTracker.Status__c =  Label.Not_Started;
									
									system.debug('*****objFlowTracker********'+objFlowTracker);
									mapNewWFlowTrackerIdToWFlowTracker.put(objOldFlowTracker.Id,objOldFlowTracker);
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
								}
								else
								{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objOldFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.In_Progress; 
									system.debug('*****objFlowTrackerTemp********'+objFlowTrackerTemp);
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
								
								//objOldFlowTracker.Status__c = Label.In_Progress; 
								
								// Data Collection Apporved  Status to Not Started
								//objFlowTracker.Status__c =  Label.Not_Started;
								//lstWFlowTrackerTrackerToUpdate.add(objOldFlowTracker);
								//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
								
								objTask.Status = Label.Completed;
								lstUpdateTask.add(objTask);
								//lstDeleteTask.add(objTask);	
								//objTask.Status = Label.Planned;
							}
							
						}
						//Task Sequence 8  Expected Plan Completion Date
						else if(objFlowTracker.Subject__c == Label.Expected_Plan_Completion_Date)
						{
							wflowTrackerTaskStatus = '8/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							if(objTask.ExpectedFinancialPlanGenerationDate__c != null)
							{
								objAccount.ExpectedFinancialPlanGenerationDate__c = objTask.ExpectedFinancialPlanGenerationDate__c;
								lstUpdateAccount.add(objAccount);
								
								 // Wflow tracker updated
								if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
								{
									objFlowTracker.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
								}
								else
								{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
								
							}
								
							//Account Not Updated as aditi done in code
							//objAccount.FinancialPlanGenerationDate__c = objTask.FinancialPlanGenerationDate__c;
						}
						
						//Task Sequence 9 Plan_Generation
						else if(objFlowTracker.Subject__c == Label.Plan_Generation)
						{
							wflowTrackerTaskStatus = '9/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							 // Wflow tracker updated
							 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
						}
						
						//Task Sequence 10  Date For Plan Presentation To and Approval From The Partner
						else if(objFlowTracker.Subject__c == Label.Date_For_Plan_Presentation_To_and_Approval_From_The_Partner)
						{ 	
							wflowTrackerTaskStatus = '9/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							if(objTask.PartnerFinancialPlanPresentationDate__c != null)
							{
								 // Wflow tracker updated
								 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
								{
									objFlowTracker.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
								}
								else
								{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
								 
								objAccount.PartnerFinancialPlanPresentationDate__c = objTask.PartnerFinancialPlanPresentationDate__c;
								lstUpdateAccount.add(objAccount);
							}
							
						}
						
						//Task Sequence 11  Date For Plan Presentation To  Member
						else if(objFlowTracker.Subject__c == Label.Date_For_Plan_Presentation_To_The_Member)
						{
							wflowTrackerTaskStatus = '9/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							 // Wflow tracker  updated
							if(objTask.MemberFinancialPlanPresentationDate__c != null)
							{
								 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
								{
									objFlowTracker.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
								}
								else
								{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
								objAccount.MemberFinancialPlanPresentationDate__c = objTask.MemberFinancialPlanPresentationDate__c ;
								lstUpdateAccount.add(objAccount);
							}	
						}
						//Task Sequence 12  Date For Plan_Presentation_Date_Confirmation
						else if(objFlowTracker.Subject__c == Label.Plan_Presentation_Date_Confirmation)
						{
							wflowTrackerTaskStatus = '10/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							if(objTask.MemberFinancialPlanPresentationDate__c != null)
							{ 
								// If New Date Entered 
								if(objTask.MemberFinancialPlanPresentationDate__c  != objAccount.MemberFinancialPlanPresentationDate__c )
								{
									objAccount.MemberFinancialPlanPresentationDate__c  = objTask.MemberFinancialPlanPresentationDate__c;
									objTask.ActivityDate = objTask.MemberFinancialPlanPresentationDate__c.addDays(-1);
									objTask.Status = Label.In_Progress;
									
									lstUpdateAccount.add(objAccount);
									lstUpdateTask.add(objTask);
								}
								//If Same Date as of Data Collection Confirmation
								else if(objTask.MemberFinancialPlanPresentationDate__c  == objAccount.MemberFinancialPlanPresentationDate__c )
								{
									objAccount.MemberFinancialPlanPresentationDate__c  = objTask.MemberFinancialPlanPresentationDate__c;
									lstUpdateAccount.add(objAccount);
									
									// Wflow tracker updated
									 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
									{
										objFlowTracker.Status__c = Label.Completed;
										mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
									}
									else
									{
										Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
										objFlowTrackerTemp.Status__c = Label.Completed;
										mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
									}
									//objFlowTracker.Status__c = Label.Completed;
									//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
								} 
							}
							 
						}
						//Task Sequence 13 Plan_Presentation
						else if(objFlowTracker.Subject__c == Label.Plan_Presentation)
						{
							wflowTrackerTaskStatus = '11/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							objAccount.Plan_Presentation_Completion_Status__c  = objTask.Plan_Presentation_Completion_Status__c;
							lstUpdateAccount.add(objAccount);
							
							
							 // Wflow tracker updated
							 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
						}
						
						//Task Sequence 14 Revised Plan
						else if(objFlowTracker.Subject__c == Label.Revised_Plan)
						{
							wflowTrackerTaskStatus = '12/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							// Wflow tracker updated
							
							 // Wflow tracker updated
							 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
							
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
						}
						//Task Sequence 15 Plan Approval
						else if(objFlowTracker.Subject__c == Label.Plan_Approval)
						{
							wflowTrackerTaskStatus = '13/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							// Wflow tracker updated
							 // Wflow tracker updated
							 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
								
						}
						
						//Task Sequence 16  Action Plan Generation
						else if(objFlowTracker.Subject__c == Label.Action_Plan_Generation)
						{
							// aditi is done alredy in code PlanGenerationDateFromSystem__c
							wflowTrackerTaskStatus = '14/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							// Wflow tracker updated
							if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
							}
								
						}
						//Task Sequence 17 Action_Plan_Dissemination_To_The_Member_Post_Feedback_From_Partner
						else if(objFlowTracker.Subject__c == Label.Action_Plan_Dissemination_To_The_Member_Post_Feedback_From_Partner)
						{
							wflowTrackerTaskStatus = '15/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							if(objTask.ActionPlanSharingDate__c != null)
							{
								objAccount.ActionPlanSharingDate__c  = objTask.ActionPlanSharingDate__c;
								lstUpdateAccount.add(objAccount);
								
								// Wflow tracker updated
								if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
								{
									objFlowTracker.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
								}
								else
								{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
							}
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
								
						}
						//Task Sequence 18  Activation Of The Action Plan With The Member
						else if(objFlowTracker.Subject__c == Label.Activation_Of_The_Action_Plan_With_The_Member)
						{
							wflowTrackerTaskStatus = '16/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							// Wflow tracker updated
							if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								{
									Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
									objFlowTrackerTemp.Status__c = Label.Completed;
									mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								}
							}
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
						}
						//Task Sequence 18  Execution_Tracker_Open
						else if(objFlowTracker.Subject__c == Label.Execution_Tracker_Open)
						{
							wflowTrackerTaskStatus = '17/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							// Wflow tracker updated
							 // Wflow tracker updated
							 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
								
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								
							}
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
						}
						//Task Sequence 18  Execution_Tracker_Close
						else if(objFlowTracker.Subject__c == Label.Execution_Tracker_Close)
						{
							wflowTrackerTaskStatus = '18/18';
							objFlowTracker.Workflows_Tracker_Master__r.Workflow_Tracker_Detail_Status__c = wflowTrackerTaskStatus;
							
							// Wflow tracker updated
							 // Wflow tracker updated
							 if(!mapNewWFlowTrackerIdToWFlowTracker.containsKey(objFlowTracker.Id))
							{
								objFlowTracker.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTracker.Id,objFlowTracker);
							}
							else
							{
							
								Workflows_Tracker_Details__c objFlowTrackerTemp = mapNewWFlowTrackerIdToWFlowTracker.get(objFlowTracker.Id);
								objFlowTrackerTemp.Status__c = Label.Completed;
								mapNewWFlowTrackerIdToWFlowTracker.put(objFlowTrackerTemp.Id,objFlowTrackerTemp);
								
							}
							//objFlowTracker.Status__c = Label.Completed;
							//lstWFlowTrackerTrackerToUpdate.add(objFlowTracker);
								
						}
						
					}//if inner
				}//if outer (objAccount != null && objTask != null)
				
			}//for
				
				
			//Update Account							 									                                      				      
			if(lstUpdateAccount.size() > 0)
			{
				if (executed)
	   				 return;
				Update lstUpdateAccount;
				executed = true;
				system.debug('**********lstUpdateAccount******'+lstUpdateAccount);
			}  
			
			//Update Wflowtracker Record	
			if(mapNewWFlowTrackerIdToWFlowTracker != null)
			{
				update mapNewWFlowTrackerIdToWFlowTracker.values();
				update mapIdToWorkflowsTrackerMasterRecord.values();
				system.debug('**********mapNewWFlowTrackerIdToWFlowTracker******'+mapNewWFlowTrackerIdToWFlowTracker.values());
			}
			
			//Update Task Record	
			if(lstUpdateTask.size() > 0)
			{
				Update lstUpdateTask;
				system.debug('**********lstUpdateTask*******'+lstUpdateTask);
			}
			/*//Delete Task Record	
			if(lstDeleteTask.size() > 0)
			{
				Delete lstDeleteTask;
			}
			*/
		}
					
	}//end of OnAfterUpdateTaskToUpdateAccount
	
}