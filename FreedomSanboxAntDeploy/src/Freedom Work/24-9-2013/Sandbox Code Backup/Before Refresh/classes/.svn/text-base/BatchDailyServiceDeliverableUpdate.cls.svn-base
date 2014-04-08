/*
    
*    Revision History:
    
*    Version     Version Author     Date              Comments
*    1.0         Dipak Nikam     	27/12/2011		Code to update service Deliverables record if 
*                                               	all or meeting done on previous day also check the 
*                                               	completed flag true if previous day and expiration date match 
*
*    2.0          Dipak Nikam     	1/4/2012    	Code to create service Deliverables record of type 
*                                             		‘Ongoing Member’ when expiration Date exceeds

*    2.0          Mahesh Hirugade 	05/06/2012  	Added startDate and endDate
*													‘Ongoing Member’ when expiration Date exceeds
	 2.0          Manasi Ranade  	27/07/2012  	Case : 00001713 : It was fetching meetings of 1 day before now we have defined span of 1 week
*/


global class BatchDailyServiceDeliverableUpdate implements Database.Batchable<Sobject>
{
	public String query;
	public Date alertDate{set;get;}
	public Date meetingAlertDate{set;get;}
	public Date startDate, endDate;
	public Date dtCurrentDate{set;get;}
	public  Map<ID,List<Task>> mapOfAccIdAndLstTask = new Map<ID,List<Task>>();
	public  Map<ID,List<Event>> mapOfAccIdAndLstEvent = new Map<ID,List<Event>>();
	/* Custom setting */
	public  Map<String ,Calender__c> mapOfCalenderCustomSetting = Calender__c.getAll();
	List<Service_Deliverables__c> lstServiceDeliverableToUpdate = new List<Service_Deliverables__c>();
	List<Task> lstOfTaskTobeCreate = new List<Task>();  
	RecordType objRecordType{set;get;}
	
	public BatchDailyServiceDeliverableUpdate()
	{
		dtCurrentDate = system.today();//Date.newInstance(2012, 04, 01) : Reverted to original : mahesh
		//mahesh : added startDate & endDate
		Integer daysInMonth = date.daysInMonth(System.Today().year(), System.Today().month());
		/** Eternus Solutions      **/
		/** Author  : Manasi Ranade*/
		/** Issue Id: 00001713      **/
		/** Date    : 27/7/2012 **/
		/** Purpose : It was fetching meetings of 1 day before now we have defined span of 1 week**/
		/****************************************************/
		
		startDate = System.Today().addDays(-8);
		endDate = System.Today().addDays(-1);
		/*startDate = Date.newInstance(System.Today().year(),System.Today().month(), 1);
		endDate = Date.newInstance(System.Today().year(), System.Today().month(), daysInMonth);*/
	} 
	
	global Database.QueryLocator  start(Database.BatchableContext bc)
	{
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, list<Service_Deliverables__c> lstScopeServDeliverables)
	{
		set<ID> setOfAccountId = new Set<ID>();
		List<Service_Deliverables__c> lstOngoingServDeliverables =  new List<Service_Deliverables__c>();
		Calender__c objCalender;

		//Date startDate = Date.newInstance(2012, 04, 01);//mahesh
		//Date endDate = Date.newInstance(2012, 04, 30);//mahesh
		
		System.debug('dtCurrentDate====='+dtCurrentDate);
		String callTextNewMember = Label.CallText;//Label.NumberOfDay
		String MeetingTextNewMember  = Label.MeetingText;
		
		String callTextOngoing = Label.CallTxtforOngoing;//Label.NumberOfDay
		String MeetingTextOngoing = Label.MeetingTxtOngoing;
		
		Date prevDate = dtCurrentDate.addDays(-1);
		System.debug('prevDate====='+prevDate);
		Integer currentMonth = prevDate.month();
		String strCurrentMonth = String.valueOf(currentMonth);
		Integer noOfday = Integer.valueOf(Label.NumberOfDay);
		Integer meetingDay =Integer.valueOf(Label.MeetingAlertDay);
		Date LastDayOfmonth = prevDate.toStartOfMonth().addMonths(1).addDays(-1);
		alertDate = LastDayOfmonth.addDays(-noOfday);// Label.NumberOfDay
		meetingAlertDate = LastDayOfmonth.addDays(-meetingDay);// Label.NumberOfDay
		
		objRecordType = [select Id,Name from RecordType where Name =:Label.Ongoing_Member limit 1];
		
		if(!mapOfCalenderCustomSetting.isEmpty() && mapOfCalenderCustomSetting.containsKey(strCurrentMonth))
				objCalender = mapOfCalenderCustomSetting.get(strCurrentMonth);
		
		if(lstScopeServDeliverables != null && lstScopeServDeliverables.size() > 0)
		{
			for(Service_Deliverables__c objService:lstScopeServDeliverables )
				setOfAccountId.add(objService.RelatedAccount__c);
		}
		/* Modified by : Dipak Nikam
		   Modified Date : 15-2-2012
		   Reason :Change from Bishnu.
		   Comment : Modified the Query.Put the Subject catagory in query.Added the Completion date 
		   			 and also filtered task data according to completion date. 
		*/
		List<Task> lstTaskTest = [	Select t.WhatId, t.Subject, t.OwnerId, t.Status ,t.Id, t.CreatedDate, 
								 t.Account.Id, t.AccountId,t.Subject_Category__c,t.Completion_Date__c  
							From Task t 
							where Status ='Completed' 
							and Subject_Category__c ='Call'
							
							and Completion_Date__c >=: startDate	//mahesh
							and Completion_Date__c <=: endDate	//mahesh
							
							and WhatId IN:setOfAccountId];
		system.Debug('List of Tasks:'+lstTaskTest);
		system.debug('StartDate=======>'+startDate);
		system.debug('endDate=======>'+endDate);
		system.debug('setOfAccountId=======>'+setOfAccountId);
		
		//Mahesh : added filter on Completion_Date__c
		for(Task objTask :[	Select t.WhatId, t.Subject, t.OwnerId, t.Status ,t.Id, t.CreatedDate, 
								 t.Account.Id, t.AccountId,t.Subject_Category__c,t.Completion_Date__c  
							From Task t 
							where Status ='Completed' 
							and Subject_Category__c ='Call'
							
							and Completion_Date__c >=: startDate	//mahesh
							and Completion_Date__c <=: endDate	//mahesh
							
							and WhatId IN:setOfAccountId])//and CreatedDate = :dtCurrentDate 
		{
			//if(objTask.Completion_Date__c == prevDate )//Replace this dtCurrentDate with prevDate	//mahesh
			{
				if(!mapOfAccIdAndLstTask.isEmpty() && mapOfAccIdAndLstTask.containsKey(objTask.WhatId))
				{
					List<Task> lstTask = mapOfAccIdAndLstTask.get(objTask.WhatId);
					lstTask.add(objTask);
					mapOfAccIdAndLstTask.put(objTask.WhatId,lstTask);
				}
				else
				{
					List<Task> lstTask = new List<Task>();
					lstTask.add(objTask);
					mapOfAccIdAndLstTask.put(objTask.WhatId,lstTask);
				}
			}
		}
		/*
			Author	: Mahesh
			Case no	: 00001507
			Comment	: Added filter on Completion_Date__c & replaced the condition Subject='Meeting' with Event_Category__c ='Meeting' in below query. 
					  Also commented the IF condition
		*/
		for(Event objEvent:[Select e.WhatId, e.Subject, e.Id, e.CreatedDate, e.Event_Status__c ,
								e.AccountId, Completion_Date__c 
							From Event e 
							where Event_Status__c ='Complete' 
							and Event_Category__c ='Meeting' //case : 00001507
							and Completion_Date__c >=: startDate	//case : 00001507
							and Completion_Date__c <=: endDate	//case : 00001507
							and WhatId IN :setOfAccountId])//and CreatedDate = :dtCurrentDate
		{
			//if(objEvent.Completion_Date__c == prevDate )//Replace this dtCurrentDate with prevDate//case : 00001507 : only commented this line 
			{
				if(!mapOfAccIdAndLstEvent.isEmpty() && mapOfAccIdAndLstEvent.containsKey(objEvent.WhatId))
				{
					List<Event> lstEvent = mapOfAccIdAndLstEvent.get(objEvent.WhatId);
					lstEvent.add(objEvent);
					mapOfAccIdAndLstEvent.put(objEvent.WhatId,lstEvent);
				}
				else
				{
					List<Event> lstEvent = new List<Event>();
					lstEvent.add(objEvent);
					mapOfAccIdAndLstEvent.put(objEvent.WhatId,lstEvent);
				}
			}
		}
		system.debug('SSSSSSSSSSSSSSSSSSSs'+mapOfAccIdAndLstTask);
		if(lstScopeServDeliverables != null && lstScopeServDeliverables.size() > 0)
		{
			for(Service_Deliverables__c objServiceToUpdate:lstScopeServDeliverables)
			{
				String strCategory = '';
				
				if(objServiceToUpdate.RecordType.Name == Label.New_Member)
				{
					List<Task> lstTaskCreatedBeforeSevenDays = mapOfAccIdAndLstTask.get(objServiceToUpdate.RelatedAccount__c);
					system.debug('lstTaskCreatedBeforeSevenDays ===>'+lstTaskCreatedBeforeSevenDays );
					if(lstTaskCreatedBeforeSevenDays != null && lstTaskCreatedBeforeSevenDays.size() > 0)
					{
						/** Eternus Solutions      **/
						/** Author  : Manasi Ranade*/
						/** Issue Id: 00001713      **/
						/** Date    : 27/7/2012 **/
						/** Purpose : It was fetching meetings of 1 day before now we have defined span of 1 week**/
						/****************************************************/
						for(Task objAccountRelatedTask: lstTaskCreatedBeforeSevenDays)
						{
							//Original Code before changing 7 days related code
							/*if(objServiceToUpdate.Call__c == null)
								objServiceToUpdate.Call__c =  objCalender.Name_of_Month__c;
							else if(!objServiceToUpdate.Call__c.contains(objCalender.Name_of_Month__c))
							{
								objServiceToUpdate.Call__c +=  ';'+objCalender.Name_of_Month__c;
							}*/
							Calender__c objCurrentTaskCalender;
							Date dtTaskCompletionDate = objAccountRelatedTask.Completion_Date__c;
							
							if(!mapOfCalenderCustomSetting.isEmpty() && mapOfCalenderCustomSetting.containsKey(String.valueOf(dtTaskCompletionDate.month())))
								objCurrentTaskCalender = mapOfCalenderCustomSetting.get(String.valueOf(dtTaskCompletionDate.month()));
								
							if(objServiceToUpdate.Call__c == null)
								objServiceToUpdate.Call__c = objCurrentTaskCalender.Name_of_Month__c;
							else if(!objServiceToUpdate.Call__c.contains(objCurrentTaskCalender.Name_of_Month__c))
							{
								objServiceToUpdate.Call__c +=  ';'+ objCurrentTaskCalender.Name_of_Month__c;
							}
						} 
					}
					else if(objServiceToUpdate.Call__c == null || !objServiceToUpdate.Call__c.contains(objCalender.Name_of_Month__c)) 
					{	
						if(alertDate == dtCurrentDate)
						{
							strCategory ='Call';
							Task objTask = CreateNewTask(objServiceToUpdate,strCategory,callTextNewMember);
							lstOfTaskTobeCreate.add(objTask);
						}
					}
					
					List<Event> lstEventCreatedBeforeSevenDays = mapOfAccIdAndLstEvent.get(objServiceToUpdate.RelatedAccount__c);
					
					if(lstEventCreatedBeforeSevenDays != null && lstEventCreatedBeforeSevenDays.size() > 0)
					{
						/** Eternus Solutions      **/
						/** Author  : Manasi Ranade*/
						/** Issue Id: 00001713      **/
						/** Date    : 27/7/2012 **/
						/** Purpose : It was fetching meetings of 1 day before now we have defined span of 1 week**/
						/****************************************************/
						//Original Code
						/*
						if(objServiceToUpdate.Meeting__c == null)
							objServiceToUpdate.Meeting__c = objCalender.Name_of_Quarter__c;
						else if(!objServiceToUpdate.Meeting__c.contains(objCalender.Name_of_Quarter__c))
						{
							objServiceToUpdate.Meeting__c += ';'+objCalender.Name_of_Quarter__c;
						}*/
						for(Event objAccountRelatedEvent : lstEventCreatedBeforeSevenDays)
						{
							Calender__c objCurrentEventCalender;
							Date dtEventCompletionDate = objAccountRelatedEvent.Completion_Date__c;
							
							if(!mapOfCalenderCustomSetting.isEmpty() && mapOfCalenderCustomSetting.containsKey(String.valueOf(dtEventCompletionDate.month())))
								objCurrentEventCalender = mapOfCalenderCustomSetting.get(String.valueOf(dtEventCompletionDate.month()));
								
							if(objServiceToUpdate.Meeting__c == null)
								objServiceToUpdate.Meeting__c = objCurrentEventCalender.Name_of_Quarter__c;
							else if(!objServiceToUpdate.Meeting__c.contains(objCurrentEventCalender.Name_of_Quarter__c))
							{
								objServiceToUpdate.Meeting__c += ';'+objCurrentEventCalender.Name_of_Quarter__c;
							}
						}
					}
					else if(objServiceToUpdate.Meeting__c == null || !objServiceToUpdate.Meeting__c.contains(objCalender.Name_of_Quarter__c))
					{
						if(objCalender.IsEndOfQuarter__c)
						{
							if(meetingAlertDate == dtCurrentDate)
							{
								strCategory ='Meeting';
								Task objTask = CreateNewTask(objServiceToUpdate,strCategory,MeetingTextNewMember);
								lstOfTaskTobeCreate.add(objTask);
							}	
						}
					}
				}
				else if(objServiceToUpdate.RecordType.Name == Label.Ongoing_Member)
				{
					List<Task> lstTaskCreatedBeforeSevenDays = mapOfAccIdAndLstTask.get(objServiceToUpdate.RelatedAccount__c);
					
					if(lstTaskCreatedBeforeSevenDays != null && lstTaskCreatedBeforeSevenDays.size() > 0)
					{
						/** Eternus Solutions      **/
						/** Author  : Manasi Ranade*/
						/** Issue Id: 00001713      **/
						/** Date    : 27/7/2012 **/
						/** Purpose : It was fetching meetings of 1 day before now we have defined span of 1 week**/
						/****************************************************/
						//Original Code
						/*if(objServiceToUpdate.Call__c == null)
						{
							objServiceToUpdate.Call__c = objCalender.Name_of_Quarter__c;
						}
						if(!objServiceToUpdate.Call__c.contains(objCalender.Name_of_Quarter__c) )//!= objCalender.Name_of_Quarter__c
						{
							objServiceToUpdate.Call__c +=  ';'+ objCalender.Name_of_Quarter__c; 
						}*/
						for(Task objAccountRelatedTask: lstTaskCreatedBeforeSevenDays)
						{
							Calender__c objCurrentTaskCalender;
							Date dtTaskCompletionDate = objAccountRelatedTask.Completion_Date__c;
							
							if(!mapOfCalenderCustomSetting.isEmpty() && mapOfCalenderCustomSetting.containsKey(String.valueOf(dtTaskCompletionDate.month())))
								objCurrentTaskCalender = mapOfCalenderCustomSetting.get(String.valueOf(dtTaskCompletionDate.month()));
								
							if(objServiceToUpdate.Call__c == null)
							{
								objServiceToUpdate.Call__c = objCurrentTaskCalender.Name_of_Quarter__c;
							}
							if(!objServiceToUpdate.Call__c.contains(objCurrentTaskCalender.Name_of_Quarter__c) )//!= objCalender.Name_of_Quarter__c
							{
								objServiceToUpdate.Call__c +=  ';'+ objCurrentTaskCalender.Name_of_Quarter__c; 
							}
						} 
						
					}
					else if(objServiceToUpdate.Call__c == null || !objServiceToUpdate.Call__c.contains(objCalender.Name_of_Quarter__c))
					{
						if(objCalender.IsEndOfQuarter__c)
						{
							if(alertDate == dtCurrentDate)
							{
								strCategory ='Call';
								Task objTask = CreateNewTask(objServiceToUpdate,strCategory,callTextOngoing);
								lstOfTaskTobeCreate.add(objTask);
							}	
						}
					}
					
					List<Event> lstEventCreatedBeforeSevenDays = mapOfAccIdAndLstEvent.get(objServiceToUpdate.RelatedAccount__c);
					
					if(lstEventCreatedBeforeSevenDays != null && lstEventCreatedBeforeSevenDays.size() > 0)
					{
						//Original code
						/*if(objServiceToUpdate.Meeting__c ==  null)
							objServiceToUpdate.Meeting__c = objCalender.Part_of_Year__c;
						else if(!objServiceToUpdate.Meeting__c.contains(objCalender.Part_of_Year__c))//objCalender.Part_of_Year__c
						{
							objServiceToUpdate.Meeting__c += ';'+objCalender.Part_of_Year__c;
						}*/
						for(Event objAccountRelatedEvent : lstEventCreatedBeforeSevenDays)
						{
							Calender__c objCurrentEventCalender;
							Date dtEventCompletionDate = objAccountRelatedEvent.Completion_Date__c;
							
							if(!mapOfCalenderCustomSetting.isEmpty() && mapOfCalenderCustomSetting.containsKey(String.valueOf(dtEventCompletionDate.month())))
								objCurrentEventCalender = mapOfCalenderCustomSetting.get(String.valueOf(dtEventCompletionDate.month()));
								
							if(objServiceToUpdate.Meeting__c ==  null)
								objServiceToUpdate.Meeting__c = objCurrentEventCalender.Part_of_Year__c;
							else if(!objServiceToUpdate.Meeting__c.contains(objCurrentEventCalender.Part_of_Year__c))//objCalender.Part_of_Year__c
							{
								objServiceToUpdate.Meeting__c += ';'+objCurrentEventCalender.Part_of_Year__c;
							}
						}
					}
					else if(objServiceToUpdate.Meeting__c ==  null || !objServiceToUpdate.Meeting__c.contains(objCalender.Part_of_Year__c))
					{
						if(objCalender.IsEndOfHalfYear__c)
						{
							if(meetingAlertDate == dtCurrentDate)
							{
								strCategory ='Meeting';
								Task objTask = CreateNewTask(objServiceToUpdate,strCategory,MeetingTextOngoing);
								lstOfTaskTobeCreate.add(objTask);
							}	
						}
					}
				}
				
				if(objServiceToUpdate.Expiration_Date__c == prevDate)
				{
					objServiceToUpdate.Completed__c = true;
					
					Service_Deliverables__c objOngoingServiceTobecreate = new Service_Deliverables__c();
					objOngoingServiceTobecreate.RecordTypeId = objRecordType.Id;
					objOngoingServiceTobecreate.RelatedAccount__c = objServiceToUpdate.RelatedAccount__c;
					objOngoingServiceTobecreate.Start_Date__c = objServiceToUpdate.Start_Date__c;
					objOngoingServiceTobecreate.End_Date__c = objServiceToUpdate.End_Date__c;
					Date expirationDate = objServiceToUpdate.Expiration_Date__c;
					objOngoingServiceTobecreate.Expiration_Date__c = expirationDate.addYears(1);
					lstOngoingServDeliverables.add(objOngoingServiceTobecreate); 
				}
				lstServiceDeliverableToUpdate.add(objServiceToUpdate);
			}
		}
		
		if(lstServiceDeliverableToUpdate != null && lstServiceDeliverableToUpdate.size() > 0)
		{
			List<Database.Saveresult> lstSaveResult = Database.update(lstServiceDeliverableToUpdate);
		}
		
		/* This will create the task.*/
		if(lstOfTaskTobeCreate != null && lstOfTaskTobeCreate.size() > 0)
		{
			Database.DMLOptions dmloptions = new Database.DMLOptions();
 			dmloptions.EmailHeader.triggerUserEmail = true;
  			List<Database.Saveresult> lstSaveResultTask = Database.insert(lstOfTaskTobeCreate, dmloptions);
  		}
  		if(lstOngoingServDeliverables != null && lstOngoingServDeliverables.size() > 0)
  		{
  		    List<Database.Saveresult> lstSaveResultOngoing = Database.insert(lstOngoingServDeliverables);
  		}
	}
	
	global void finish(Database.BatchableContext BC)
	{
		AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems 
      					  		 from AsyncApexJob where Id =:BC.getJobId()];
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   	String[] toAddresses = new String[] {'tech@ffreedom.in'};
	   	mail.setToAddresses(toAddresses);
	   	mail.setSubject('Daily Service Deliverable Update job proccessed:' + apexJob.Status);
	   	mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems +'batches with '+ apexJob.NumberOfErrors + 'failures with Job id'+apexJob.id);
	  	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
	public Task  CreateNewTask(Service_Deliverables__c objServiceDeliverables,String strCategory,String strComment)
 	{
  		Task objTask = new Task();
		objTask.OwnerId = objServiceDeliverables.RelatedAccount__r.OwnerId;
		objTask.Subject = strCategory +' Pending';
		objTask.Subject_Category__c = strCategory;
		objTask.Priority = 'High';
		objTask.Status =  'Planned';
		objTask.Description = strComment;
		objTask.WhatId = objServiceDeliverables.RelatedAccount__c;
		return objTask; 
	}
}