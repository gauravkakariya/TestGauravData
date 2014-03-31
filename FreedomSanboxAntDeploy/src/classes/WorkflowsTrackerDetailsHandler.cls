/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 08/10/2013   1. Handler class for WorkflowsTrackerDetailsTrigger
	
*/

public class WorkflowsTrackerDetailsHandler 
{
	/*When status of WorkflowsTrackerDetails changes from "In progress" to "Completed", 
	then next task sequence record status should be updated with status 'In Progress' */
	public void changeStatusOnTaskCompletion(List<Workflows_Tracker_Details__c> newList, map<Id,Workflows_Tracker_Details__c> oldMap)
	{
		set<Id> SetIdWFDetail = new set<Id>();
		map<Id, Workflows_Tracker_Details__c> mapIdToWFDetails = new map<Id, Workflows_Tracker_Details__c>();
		
		//Get the set of Work Flow tracker details Ids whose status is changing
		for(Workflows_Tracker_Details__c objDetail : newList)
		{
			if(objDetail.Status__c==Label.Completed && (oldMap != null && (objDetail.Status__c != oldMap.get(objDetail.Id).Status__c)))
			{
				SetIdWFDetail.add(objDetail.Id);
			}
		}
		system.debug('-----1---SetIdWFDetail---------:'+SetIdWFDetail);
		
		map<Id, Workflows_Tracker_Details__c> mapIdToParentWFDetails = new map<Id, Workflows_Tracker_Details__c>();
		map<Id, Task> mapIdToTask = new map<Id, Task>();
		map<Id, Id> mapIdToParentTask = new map<Id, Id>();
		
		set<Id> SetIdWFMaster = new set<Id>();
		set<Id> SetIdTask = new set<Id>();
		
		Id ParentAccount;
		
		if(SetIdWFDetail.size() != 0)
		{
			mapIdToWFDetails = new map<Id, Workflows_Tracker_Details__c>([Select Workflows_Tracker_Master__c, Task_Sequence__c, Task_Id__c, Subject__c, Status__c, 
																Related_Workflow_Details_Date__c, Priority__c, Parent_Workflows_Tracker_Details__c, Comments__c,
																Name, Id, Event_Master__c, Due_Date__c, Department__c, Channel_Type__c, Days_After__c,
																Workflows_Tracker_Master__r.Parent_Account__c, Department__r.Type_of_Department__c,//Is_Partner_Task_Owner__c,
																Workflows_Tracker_Master__r.Parent_Account__r.Virtual_Partner__c,
																Workflows_Tracker_Master__r.Parent_Account__r.Business_Unit__c 
																From Workflows_Tracker_Details__c 
																where Id IN : SetIdWFDetail]);
			system.debug('-----1---mapIdToWFDetails---------:'+mapIdToWFDetails);
			
			for(Workflows_Tracker_Details__c objWTDetails : mapIdToWFDetails.values())
			{
				system.debug('-----1---objWTDetails---------:'+objWTDetails);
				mapIdToParentTask.put(objWTDetails.Id, objWTDetails.Task_Id__c);
			}
			
			List<Integer> lstTaskSequence = new List<Integer>();
			List<Workflows_Tracker_Details__c> lstToBeUpdated = new List<Workflows_Tracker_Details__c>();											
			List<Workflows_Tracker_Details__c> lstToBeUpdatedFinal = new List<Workflows_Tracker_Details__c>();	
			
			//Map Which contains Account Id and its corresponding Workflows_Tracker_Details__c records
			map<String, Integer> mapAccIdToTaskSequence = new map<String, Integer>();
			system.debug('--------SetIdTask---------:'+SetIdTask);
			
			mapIdToTask = new map<Id, Task>([Select Id,LastModifiedDate, Plan_Presentation_Completion_Status__c, Send_Email__c 
											from Task where Id IN: mapIdToParentTask.values()]);
			
			for(Workflows_Tracker_Details__c objWTDetails : mapIdToWFDetails.values())
			{
				
				//Key of Map will be Account Id and Task sequence of Workflows_Tracker_Details__c record
				String strKey = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c;
				if(!mapAccIdToTaskSequence.containsKey(strKey) && (objWTDetails.Subject__c != Label.Plan_Generation 
					&& objWTDetails.Subject__c != Label.Date_For_Plan_Presentation_To_and_Approval_From_The_Partner))
					//&& objWTDetails.Subject__c != Label.Data_Collection_Completion))
				{
					if(objWTDetails.Subject__c == Label.Plan_Presentation)
					{
						system.debug('-----1---objWTDetails.Subject__c---------:'+objWTDetails.Subject__c);
						system.debug('----1----Label--------:'+objWTDetails.Task_Id__c);
						if(mapIdToParentTask.containsKey(objWTDetails.Id))
						{
							Id oldTaskId = mapIdToParentTask.get(objWTDetails.Id);
							Task task = mapIdToTask.get(oldTaskId);
							if(task.Plan_Presentation_Completion_Status__c == Label.Rework_Not_Required)
							{
								mapAccIdToTaskSequence.put(strKey, Integer.valueOf(objWTDetails.Task_Sequence__c)+2);
							}
							else
								mapAccIdToTaskSequence.put(strKey, Integer.valueOf(objWTDetails.Task_Sequence__c)+1);
						}
					}
					else
						mapAccIdToTaskSequence.put(strKey, Integer.valueOf(objWTDetails.Task_Sequence__c)+1);
					system.debug('----1----strKey---------:'+strKey);
				}
			}
			system.debug('----1----mapAccIdToTaskSequence---------:'+mapAccIdToTaskSequence.keySet());
			
			for(Workflows_Tracker_Details__c objWTDetails : mapIdToWFDetails.values())
			{
				system.debug('----objWTDetails--------:'+objWTDetails);
				//Parent Account records 
				ParentAccount = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c;
				//Added 1 to corresponding task sequence to get next one
				Integer taskSequence = Integer.valueOf(objWTDetails.Task_Sequence__c);// + 1;
				
				String str = ParentAccount;//  + ' : ' + taskSequence;
				system.debug('----1----str---------:'+str);
				if(mapAccIdToTaskSequence.ContainsKey(str))
				{
					String query = 'Select Workflows_Tracker_Master__c, Task_Sequence__c, Task_Id__c, Subject__c, Status__c, Related_Workflow_Details_Date__c, Priority__c, Parent_Workflows_Tracker_Details__c, Comments__c,Name, Id, Event_Master__c, Due_Date__c, Department__c, Channel_Type__c, Days_After__c,Workflows_Tracker_Master__r.Parent_Account__c, Department__r.Type_of_Department__c from Workflows_Tracker_Details__c where ';
					
					for(String objAcc : mapAccIdToTaskSequence.keySet())	
					{
						query += '(Workflows_Tracker_Master__r.Parent_Account__c= \''+ objAcc  + '\' and Task_Sequence__c = '+mapAccIdToTaskSequence.get(objAcc)+' )'+' or ';
					}
					if(query.lastIndexOf('or') != -1){
						query = query.subString(0,query.lastIndexOf('or'));
					}
					system.debug('--------query-----record----:'+query);
					
					lstToBeUpdated = Database.query(query);
					for(Workflows_Tracker_Details__c obj : lstToBeUpdated)
					{
						obj.Status__c = Label.In_Progress;
						lstToBeUpdatedFinal.add(obj);
					}
				}
			}
			System.debug('-----------lstToBeUpdatedFinal---1-------'+lstToBeUpdatedFinal);
	        if(lstToBeUpdatedFinal.size() != 0)
	        {
	        	Database.SaveResult[] lstResult = Database.update(lstToBeUpdatedFinal, false);
	        	System.debug('-----------lstResult--1--------'+lstResult);
	        }
	        
	        List<Notification_Queue__c> lstNotification_Queue = new List<Notification_Queue__c>();
	        
	        for(Workflows_Tracker_Details__c objWTDetails : mapIdToWFDetails.values())
			{
				Id Member = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c;
				Id Partner = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.Virtual_Partner__c;
				String BizUnit = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.Business_Unit__c;
				
				if(Member != null)
				{
					if(mapIdToTask.containsKey(objWTDetails.Task_Id__c))
					{
						Task task = mapIdToTask.get(objWTDetails.Task_Id__c);
						System.debug('----------task--------'+task);
						if(task.Send_Email__c != false)
						{
							Notification_Queue__c objNoteQueue = new Notification_Queue__c();
							objNoteQueue.Biz_Unit__c = BizUnit;
							objNoteQueue.Event__c = objWTDetails.Event_Master__c;
							objNoteQueue.Channel_Type__c = objWTDetails.Channel_Type__c;
							objNoteQueue.Member_Id__c = Member;
							objNoteQueue.Partner_Id__c = Partner;
							//objNoteQueue.Custom_Object_Type__c = 'Task';
							//objNoteQueue.Custom_ID__c = objWTDetails.Task_Id__c;
							objNoteQueue.Priority__c = objWTDetails.Priority__c;
							System.debug('----------objNoteQueue--------'+objNoteQueue);
							lstNotification_Queue.add(objNoteQueue);
						}
					}
				}
			}
	        if(lstNotification_Queue != null && lstNotification_Queue.size() != 0)
			{
				Database.SaveResult[] lstSaveResultNQ = Database.insert(lstNotification_Queue, false);
				System.debug('-----------lstSaveResultNQ-----------' + lstSaveResultNQ);
			}												
		}
	}
	
	
	/*When status of WorkflowsTrackerDetails changes from "Not started" to "In progress", Task gets created*/
	public void createTaskOnStatusChange(List<Workflows_Tracker_Details__c> newList, map<Id,Workflows_Tracker_Details__c> oldMap,map<Id,Workflows_Tracker_Details__c> newMap)
	{
		set<Id> WFlowDetailIdSet = new set<Id>();
		//Get the set of Work Flow tracker details Ids whose status is changing
		for(Workflows_Tracker_Details__c objDetail : newList)
		{
			Workflows_Tracker_Details__c oldWFT = oldMap.get(objDetail.id);
			if(oldWFT.Status__c != objDetail.Status__c	 &&  objDetail.Status__c == Label.In_Progress)
			{
				WFlowDetailIdSet.add(objDetail.Id);
			}
		}
		system.debug('--------WFlowDetailIdSet---------:'+WFlowDetailIdSet);
		
		map<Id, Workflows_Tracker_Details__c> mapIdToWFDetails = new map<Id, Workflows_Tracker_Details__c>();
		map<Id, Workflows_Tracker_Details__c> mapIdToParentWFDetails = new map<Id, Workflows_Tracker_Details__c>();
		map<Id, Task> mapIdToTask = new map<Id, Task>();
		
		set<Id> SetIdDepartment = new set<Id>();
		set<Id> SetIdWFMaster = new set<Id>();
		set<Id> SetIdParentWFDetails = new set<Id>();
		set<Id> SetIdTask = new set<Id>();
		
		if(WFlowDetailIdSet.size() != 0)
		{
			mapIdToWFDetails = new map<Id, Workflows_Tracker_Details__c>([Select Workflows_Tracker_Master__c, Task_Sequence__c, Task_Id__c, Subject__c, Status__c, 
																Related_Workflow_Details_Date__c, Priority__c, Parent_Workflows_Tracker_Details__c, Comments__c,
																Name, Id, Event_Master__c, Due_Date__c, Department__c, Channel_Type__c, Days_After__c,
																Workflows_Tracker_Master__r.Parent_Account__c, Department__r.Type_of_Department__c,//Is_Partner_Task_Owner__c,
																Workflows_Tracker_Master__r.Parent_Account__r.PST_Team_Member__r.Team_Member__c,
																Workflows_Tracker_Master__r.Parent_Account__r.MST_Team_Member__r.Team_Member__c,
																Workflows_Tracker_Master__r.Parent_Account__r.FPA_Team_Member__r.Team_Member__c,
																Workflows_Tracker_Master__r.Parent_Account__r.OPS_Team_Member__r.Team_Member__c,
																Workflows_Tracker_Master__r.Parent_Account__r.CreatedDate,
																Workflows_Tracker_Master__r.Parent_Account__r.DataCollectionDate__c,
																Workflows_Tracker_Master__r.Parent_Account__r.MemberFinancialPlanPresentationDate__c,
																Workflows_Tracker_Master__r.Parent_Account__r.Virtual_Partner__c,
																Workflows_Tracker_Master__r.Parent_Account__r.Business_Unit__c,
																Workflows_Tracker_Master__r.Parent_Account__r.Data_Collection_Completion_Reject_Reason__c,
																Event_Master__r.Task_Event_Master__c
																From Workflows_Tracker_Details__c 
																where Id IN : WFlowDetailIdSet]);
			
			for(Workflows_Tracker_Details__c objWTDetails : mapIdToWFDetails.values())
			{
				SetIdDepartment.add(objWTDetails.Department__c);
				SetIdParentWFDetails.add(objWTDetails.Parent_Workflows_Tracker_Details__c);
				system.debug('--------SetIdParentWFDetails---a------:'+SetIdParentWFDetails);
			}
			
			mapIdToParentWFDetails = new map<Id, Workflows_Tracker_Details__c>([Select Id, Task_Id__c, Parent_Workflows_Tracker_Details__c
																				from Workflows_Tracker_Details__c
																				where Id IN : SetIdParentWFDetails]);
																				//and Parent_Workflows_Tracker_Details__c = null]);
			system.debug('--------mapIdToParentWFDetails-----a----:'+mapIdToParentWFDetails);
			
			for(Workflows_Tracker_Details__c objWTDetails : mapIdToParentWFDetails.values())
			{
				SetIdTask.add(objWTDetails.Task_Id__c);
			}
			system.debug('--------SetIdTask---------:'+SetIdTask);
			
			if(SetIdTask.size() != 0)
				mapIdToTask = new map<Id, Task>([Select Id,LastModifiedDate, Automated_Flows_Completion_Date__c 
											from Task where Id IN: SetIdTask]);
			system.debug('--------mapIdToTask---------:'+mapIdToTask.values());
			system.debug('--------mapIdToTask---------:'+mapIdToTask.keySet());
			
			User Owner;
			Date TaskDueDate;
			Id ParentAccount;
			Task objTask;
			List<Task> lstTask = new List<Task>();
			
			for(Workflows_Tracker_Details__c objWTDetails : mapIdToWFDetails.values())
			{
				Owner = calculateTaskOwner(objWTDetails);
				system.debug('--------calculateTaskOwner---------:'+Owner);
				TaskDueDate = calculateDueDate(objWTDetails, mapIdToParentWFDetails, mapIdToTask);
				system.debug('--------calculateDueDate---------:'+TaskDueDate);
				ParentAccount = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c;
				
				/*Create the task according to the collected details */
				if(Owner != null && ParentAccount != null)
				{
					objTask = new Task();
					objTask.OwnerId = Owner.Id;
					objTask.Subject = objWTDetails.Subject__c;
					if(TaskDueDate != null && (Integer.valueOf(objWTDetails.Days_After__c) != (-999)))
					{
						Date newDate = system.today();
						objTask.ActivityDate = TaskDueDate.addDays(Integer.valueOf(objWTDetails.Days_After__c));
						if(objTask.ActivityDate != null)
						{
							Date d = objTask.ActivityDate;
							Datetime dt = (DateTime)d;
							String dayOfWeek = dt.format('EEEE'); 
							system.debug('*********dayOfWeek****'+dayOfWeek);
							if(dayOfWeek == 'Sunday')
								newDate = d.addDays(1);
							else
								newDate = d;
							system.debug('*********newDate****'+newDate);
						}
						objTask.ActivityDate = newDate;
					}
					objTask.Priority = objWTDetails.Priority__c;
					objTask.Subject_Category__c = 'Email';
					if(objWTDetails.Subject__c == Label.Data_Collection_Completion 
						&& objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.Data_Collection_Completion_Reject_Reason__c != null)
					{
						objTask.Description = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.Data_Collection_Completion_Reject_Reason__c;
					}
					else
					{
						objTask.Description = objWTDetails.Comments__c;
					}
					objTask.WhatId = ParentAccount;
	               	System.debug('-----------objTask----------- ' + objTask);
	               	lstTask.add(objTask);
				}
			}
			set<Id> taskIdSet = new set<Id>();
			map<Id,Task> mapIdToInsertedTask = new map<Id,Task>();
			List<Workflows_Tracker_Details__c> lstUpdatedWFTD = new List<Workflows_Tracker_Details__c>();
			
			if(lstTask != null && lstTask.size() != 0)
			{
				lstTask = calculateRecordTypeName(lstTask);
				lstTask = updateDateRecordTypeWise(lstTask);
				
				Database.SaveResult[] lstSaveResult = Database.insert(lstTask, false);
				System.debug('-----------lstSaveResult-----------' + lstSaveResult);
				for(Database.SaveResult res : lstSaveResult)
				{
					taskIdSet.add(res.getId());
				}
		        System.debug('-----------taskIdSet-----------' + taskIdSet);
		        
		        if(taskIdSet.size() != 0)
		        {
		        	mapIdToInsertedTask = new map<Id,Task> ([Select Id, OwnerId, WhatId, Subject, ActivityDate
							        						from Task
							        						where Id IN: taskIdSet]);
		        	System.debug('-----------mapIdToInsertedTask-----------' + mapIdToInsertedTask);
		        	
		        	if(mapIdToInsertedTask != null)
		        	{
		        		for(Task objInsertedTask : mapIdToInsertedTask.values())
				        {
				        	System.debug('-----------inside first for-----------');
				        	for(Workflows_Tracker_Details__c objWFTD : mapIdToWFDetails.values())
				        	{
				        		ParentAccount = objWFTD.Workflows_Tracker_Master__r.Parent_Account__c;
				        		
				        		if(objInsertedTask.WhatId == ParentAccount && objInsertedTask.Subject == objWFTD.Subject__c)
				        		{
				        			System.debug('-----------inside second for-----------');
				        			objWFTD.Task_Id__c = objInsertedTask.Id;
				        			if(objInsertedTask.ActivityDate != null)
				        				objWFTD.Due_Date__c = objInsertedTask.ActivityDate;
				        			System.debug('-----------Task_Id__c-----------'+objWFTD.Task_Id__c);
				        			System.debug('-----------Due_Date__c-----------'+objWFTD.Due_Date__c);
				        			lstUpdatedWFTD.add(objWFTD);
				        		}
				        	}
				        }
		        	} 
		        }
		        System.debug('-----------lstUpdatedWFTD----------'+lstUpdatedWFTD);
		        if(lstUpdatedWFTD.size() != 0)
		        {
		        	Database.SaveResult[] lstResult = Database.update(lstUpdatedWFTD, false);
		        	System.debug('-----------lstResult----------'+lstResult);
		        } 
			}
			
			List<Notification_Queue__c> lstNotification_Queue = new List<Notification_Queue__c>();
	        
	        for(Workflows_Tracker_Details__c objWTDetails : lstUpdatedWFTD)
			{
				Id Member = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c;
				Id Partner = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.Virtual_Partner__c;
				String BizUnit = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.Business_Unit__c;
				
				if(Member != null)
				{
					Notification_Queue__c objNoteQueue = new Notification_Queue__c();
					objNoteQueue.Biz_Unit__c = BizUnit;
					objNoteQueue.Event__c = objWTDetails.Event_Master__r.Task_Event_Master__c;
					objNoteQueue.Channel_Type__c = objWTDetails.Channel_Type__c;
					objNoteQueue.Member_Id__c = Member;
					objNoteQueue.Partner_Id__c = Partner;
					objNoteQueue.Priority__c = objWTDetails.Priority__c;
					objNoteQueue.Custom_Object_Type__c = 'Task';
					objNoteQueue.Custom_ID__c = objWTDetails.Task_Id__c;
					System.debug('----------objNoteQueue---inprogress-----'+objNoteQueue);
					lstNotification_Queue.add(objNoteQueue);
				}
			}
	        if(lstNotification_Queue != null && lstNotification_Queue.size() != 0)
			{
				Database.SaveResult[] lstSaveResultNQ = Database.insert(lstNotification_Queue, false);
				System.debug('-----------lstSaveResultNQ----inprogress-------' + lstSaveResultNQ);
			}								
		}
	}
	
	/* To calculate due date for the task */
	public Date calculateDueDate(Workflows_Tracker_Details__c objWTDetails, map<Id, Workflows_Tracker_Details__c> mapIdToParentWFDetails, map<Id, Task> mapIdToTask)
	{
		Id parentAccount;
		Date dueDate;
		Workflows_Tracker_Details__c objParentDetail;
		Task objTask;
		
		/*If 'Parent Workflows Tracker Details' field is not null, then date will be calcualted by - 
		First find out the Task Id from parent record of WF tracker detail and then Task's completion date which will be added to 'days after' on same record */
		if(objWTDetails.Parent_Workflows_Tracker_Details__c != null && mapIdToParentWFDetails.containsKey(objWTDetails.Parent_Workflows_Tracker_Details__c))
		{
			objParentDetail = mapIdToParentWFDetails.get(objWTDetails.Parent_Workflows_Tracker_Details__c);
			system.debug('--------objParentDetail---------:'+objParentDetail);
			system.debug('--------objParentDetail---Id------:'+objParentDetail.Task_Id__c);
			if(mapIdToTask.containsKey(objParentDetail.Task_Id__c))
			{
				objTask = mapIdToTask.get(objParentDetail.Task_Id__c);
				system.debug('--------objTask-----aaa----:'+objTask);
				system.debug('--------objTask-----abc----:'+objTask.Automated_Flows_Completion_Date__c);
				if(objTask.Automated_Flows_Completion_Date__c != null)
				{
					dueDate = date.valueOf(objTask.Automated_Flows_Completion_Date__c);
					system.debug('--------dueDate--else-------:'+dueDate);
				}
			}
		}
		/* If 'Parent Workflows Tracker Details' field is null and value is picked in 'Related Workflow Details Date' pick list, then date will be calcualted by 
		1.Find out the account from 'Workflows Tracker Master' which is on the same record, and then select dates according to the pick list value
		  which is then will be added in 'days after' to calculate 'Due Date' on Task*/
		else if(objWTDetails.Parent_Workflows_Tracker_Details__c == null && objWTDetails.Related_Workflow_Details_Date__c != null)
		{
			if(objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c != null)
			{
				system.debug('-------objWTDetails.----:'+objWTDetails);
				parentAccount = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c;
				
				if(objWTDetails.Related_Workflow_Details_Date__c == Label.Entity_Creation_Date && objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.CreatedDate != null)
					dueDate = date.valueOf(objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.CreatedDate);
				else if(objWTDetails.Related_Workflow_Details_Date__c == Label.Data_Collection_Date && objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.DataCollectionDate__c != null)
					dueDate = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.DataCollectionDate__c;
				else if(objWTDetails.Related_Workflow_Details_Date__c == Label.Plan_Presentation_Date)
					dueDate = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.MemberFinancialPlanPresentationDate__c;
				system.debug('--------dueDate--if-------:'+dueDate);
			}
		}
		
		else if(objWTDetails.Parent_Workflows_Tracker_Details__c == null && objWTDetails.Related_Workflow_Details_Date__c == null)
		{
			dueDate = null;
		}
		
		if(dueDate != null)
			return dueDate;
		else
			return null;
	}
	
	public Schema.DescribeSObjectResult DESCRIBE_RESULT = Task.SobjectType.getDescribe();
    public Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
	
	/* To update the date field according to the record type of the task  */
	public List<Task> updateDateRecordTypeWise(List<Task> lstTask)
	{
		set<String> setAccountId = new set<String>();
		map<Id, Account> mapIdToAccount = new map<Id, Account>();
		
		for(Task objTask :lstTask)
		{
			setAccountId.add(objTask.WhatId);
			system.debug('--------setAccountId---------:'+setAccountId);
		}
		if(setAccountId.size() != 0)
		{
			mapIdToAccount = new map<Id, Account>([Select Plan_Presentation_Completion_Status__c,MemberFinancialPlanPresentationDate__c,
											PartnerFinancialPlanPresentationDate__c, FinancialPlanGenerationDate__c, DataCollectionDate__c,
											Entity_Intereseted_in_FP_Status__c, ActionPlanSharingDate__c From Account 
											where Id IN : setAccountId]);
		}
		system.debug('--------mapIdToAccount---------:'+mapIdToAccount);
		
		for(Task objTask :lstTask)
		{
			if(mapIdToAccount.containsKey(objTask.WhatId))
			{
				Account objAccount = mapIdToAccount.get(objTask.WhatId);
				system.debug('--------objAccount---------:'+objAccount);
				if(objTask.RecordTypeId == RECORD_TYPE_INFO_MAP.get('Data Collection Date').getRecordTypeId() && objAccount.DataCollectionDate__c != null)
					objTask.DataCollectionDate__c = objAccount.DataCollectionDate__c;
				else if(objTask.RecordTypeId == RECORD_TYPE_INFO_MAP.get('Partner Plan Presentation Date').getRecordTypeId() && objAccount.PartnerFinancialPlanPresentationDate__c != null)	
					objTask.PartnerFinancialPlanPresentationDate__c = objAccount.PartnerFinancialPlanPresentationDate__c;
				else if(objTask.RecordTypeId == RECORD_TYPE_INFO_MAP.get('Member Plan Presentation Date').getRecordTypeId() && objAccount.MemberFinancialPlanPresentationDate__c != null)	
					objTask.MemberFinancialPlanPresentationDate__c = objAccount.MemberFinancialPlanPresentationDate__c;
				else if(objTask.RecordTypeId == RECORD_TYPE_INFO_MAP.get('Financial Plan Completion').getRecordTypeId() && objAccount.FinancialPlanGenerationDate__c != null)
					objTask.FinancialPlanGenerationDate__c = objAccount.FinancialPlanGenerationDate__c;
				else if(objTask.RecordTypeId == RECORD_TYPE_INFO_MAP.get('Action Plan Disseminate').getRecordTypeId() && objAccount.ActionPlanSharingDate__c != null)
					objTask.ActionPlanSharingDate__c = objAccount.ActionPlanSharingDate__c;
				system.debug('-------objTask.RecordType.Name--------:'+objTask.RecordTypeId );	
			}
		}	
		system.debug('--------lstTask----updateDateRecordTypeWise-----:'+lstTask);
		return lstTask;								
	}
	
	
	map<String, Automated_Workflows_CS__c> mapStringToAW = Automated_Workflows_CS__c.getAll();
	
	public map<String, String> mapEventNameToRecordTypeName = new map<String, String>();
 	
	/* To calculate record type name for the task  */
	public List<Task> calculateRecordTypeName(List<Task> lstTask)
	{
		String recordTypeName;
		set<String> setSubjectSet = new set<String>();
		system.debug('--------mapStringToAW---------:'+mapStringToAW);
		for(Task objTask :lstTask)
		{
			setSubjectSet.add(objTask.Subject);
			system.debug('--------setSubjectSet---------:'+setSubjectSet);
		}
        for(Automated_Workflows_CS__c objAW : mapStringToAW.values())
        {
        	if(!mapEventNameToRecordTypeName.containsKey(objAW.Event_Name__c))
        		mapEventNameToRecordTypeName.put(objAW.Event_Name__c, objAW.Record_Type__c);
        	system.debug('--------mapEventNameToRecordTypeName---------:'+mapEventNameToRecordTypeName);
        }
        set<String> recordTypeNameSet = new set<String>(); 
        for(String objSubject :setSubjectSet)
		{
			if(mapEventNameToRecordTypeName.containsKey(objSubject))
			{
				recordTypeNameSet.add(mapEventNameToRecordTypeName.get(objSubject));
				system.debug('--------recordTypeNameSet---------:'+recordTypeNameSet);
			}
		}
        List<RecordType> lstRecordType = [Select Name, Id, DeveloperName 
        						From RecordType where Name IN: recordTypeNameSet];
        map<String, Id> mapNameToID = new map <String, Id>();
        
        for(RecordType objRecordType : lstRecordType)
        {
        	mapNameToID.put(objRecordType.Name, objRecordType.Id);
        	system.debug('--------mapNameToID---------:'+mapNameToID);
        }				
		
		for(Task objTask : lstTask)
		{
			if(mapEventNameToRecordTypeName.containsKey(objTask.Subject))
			{
        		String RecordTypeNameFinal = mapEventNameToRecordTypeName.get(objTask.Subject);
        		if(mapNameToID.containsKey(RecordTypeNameFinal))
        		{
        			objTask.RecordTypeId = mapNameToID.get(RecordTypeNameFinal);
        			system.debug('--------objTask.RecordTypeId ---------:'+objTask.RecordTypeId );
        		}
			}
		}
		system.debug('--------lstTask---------:'+lstTask);
		return lstTask;
	}
	
	/* To calculate task owner for the task  */
	public User calculateTaskOwner(Workflows_Tracker_Details__c objWTDetails)
	{
		Id parentAccount;
		Department__c objDepartment;
		Id objUser; 
		
		/* Get the Parent Account from the Workflow Tracker Master and then Get Team Member record according to the selected department type of the WF tracker detail */
		if(objWTDetails.Workflows_Tracker_Master__c != null)
		{
			if(objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c != null)
			{
				// Get Account record
				parentAccount = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__c;
				system.debug('--------parentAccount---------:'+parentAccount);
				
				// If department is not null, then we get user from Team Members
				if(objWTDetails.Department__c != null && parentAccount != null)
				{	
					if(objWTDetails.Department__r.Type_of_Department__c == Label.Team_Member_Type_PST 
					&& objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.PST_Team_Member__r.Team_Member__c != null)
						objUser = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.PST_Team_Member__r.Team_Member__c;
					else if(objWTDetails.Department__r.Type_of_Department__c == Label.Team_Member_Type_MST
					&& objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.MST_Team_Member__r.Team_Member__c != null)
						objUser = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.MST_Team_Member__r.Team_Member__c;
					else if(objWTDetails.Department__r.Type_of_Department__c == Label.Team_Member_Type_FPA 
					&& objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.FPA_Team_Member__r.Team_Member__c != null)
						objUser = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.FPA_Team_Member__r.Team_Member__c;
					else if(objWTDetails.Department__r.Type_of_Department__c == Label.Team_Member_Type_MST2 
					&& objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.OPS_Team_Member__r.Team_Member__c != null)
						objUser = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.OPS_Team_Member__r.Team_Member__c;
					system.debug('--------objUser---------:'+objUser);
				}
				// If Is_Partner_Task_Owner__c is checked, then we get user from Account's Practice owner's Owner
				// Task owner is the Look Up field only for User and Not Partner Entities.
				/*else if(objWTDetails.Is_Partner_Task_Owner__c == true && parentAccount != null)
				{
					objUser = objWTDetails.Workflows_Tracker_Master__r.Parent_Account__r.Virtual_Partner__r.OwnerId;
					system.debug('--------objUser--PFP-------:'+objUser);
				}*/
			}
		}
		if(objUser != null)
			return [Select Id from User where Id =: objUser];
		else
			return null;
	}
}