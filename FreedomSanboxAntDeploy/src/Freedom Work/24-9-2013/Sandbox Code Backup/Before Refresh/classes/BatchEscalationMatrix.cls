/*
   Revision History:
   Version     Version Author     Date          Comments
    2.0 	    Aditi Satpute	  03/06/2012	Issue id: 00001705 :Removed Haren's name from escalation emails.
*/	


global class BatchEscalationMatrix implements Database.Batchable<SObject>{
	
	public String[] lstToAddress;
	public Task objTask;
	global String query;
	public List<String> lstCcAddress;
	
	Map<ID, Workstation__c> mapOwnerIdWorkstation = new Map<ID, Workstation__c>();
	Map<String,Advisory__c> userRoleMapOfAdvisor = Advisory__c.getAll();
	Map<String, EscalationEmails__c> mapEscalationEmails = EscalationEmails__c.getAll();
	Map<String, EscalationLevels__c> mapEscalationLevels = EscalationLevels__c.getAll();
	
	public Set<ID> setFPID = new Set<Id>();
	public Set<ID> setAccountID = new Set<Id>();
	
	global Database.Querylocator start(Database.BatchableContext BC){
		Date dt = Date.Today();
		//if(Test.isRunningTest())	query += ' where CreatedDate =: dt';
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, list<Account> lstScope)
	{
		try{
			System.debug('**lstScope***'+lstScope);
			Messaging.Email[] allEmails = new List<Messaging.Email>();
			lstCcAddress = new List<String>();
			if(lstScope != null && lstScope.size() > 0){
				for(Account objAccount : lstScope){
					setFPID.add(objAccount.OwnerId);
					setAccountID.add(objAccount.Id);
				}
			}
			
			if(setFPID != null && setFPID.size() >0)
			{
				for(Workstation__c objWorkstation : [Select w.Tech__c, w.OwnerId, w.Name, w.Member_Engagement__c, w.Member_Engagement__r.Email,
															w.Manager__c,w.Manager__r.Email,w.Location__c,w.Id,w.Financial_Planner__c,w.Financial_Planner__r.Email,
															w.Financial_Planner__r.FirstName,w.Financial_Planner__r.IsActive, w.Compliance__c,w.Business_Developer__c,w.Advisory__c,w.Advisory__r.Email
													 From Workstation__c w where w.Financial_Planner__c IN : setFPID AND w.Financial_Planner__r.IsActive = true])
				{
					mapOwnerIdWorkstation.put(objWorkstation.Financial_Planner__c, objWorkstation);
				}
			}
			System.debug('======== mapOwnerIdWorkstation ========' + mapOwnerIdWorkstation);
			System.debug('======== lstScope ========' + lstScope.size());
			System.debug('======== lstScope ========' + lstScope);
			if(lstScope != null && lstScope.size() > 0)
			{
				for(Account objAccount : lstScope)
				{
					if(objAccount != null )
					{
						if(objAccount.Data_Collection_Date__c == null)
						{
							for(Messaging.Singleemailmessage objEmail : dataCollectionCompletionProcess(objAccount, mapEscalationLevels))
							{
								allEmails.add(objEmail);
							}
						}
		
						if(objAccount.Data_Collection_Date__c != null && objAccount.Plan_Writing_Date__c == null)
						{
							for(Messaging.Singleemailmessage objEmail : planWritingCompletionProcess(objAccount, mapEscalationLevels))
							{
								allEmails.add(objEmail);
							}
						}
		
						if(objAccount.Plan_Writing_Date__c != null && objAccount.Plan_Approved_Date__c == null)
						{
							for(Messaging.Singleemailmessage objEmail : planApprovedProcess(objAccount, mapEscalationLevels))
							{
								allEmails.add(objEmail);
							}
						}
		
						if(objAccount.Plan_Approved_Date__c != null && objAccount.Action_Plan_Generation_Date__c == null)
						{
							for(Messaging.Singleemailmessage objEmail : actionPlanGenerationProcess(objAccount, mapEscalationLevels))
							{
								allEmails.add(objEmail);
							}
						}
		
						if(objAccount.Action_Plan_Generation_Date__c != null && objAccount.First_Execution_Completion_Date__c == null)
						{
							for(Messaging.Singleemailmessage objEmail : firstExecutionCompletionProcess(objAccount, mapEscalationLevels))
							{
								allEmails.add(objEmail);
							}
						}
					}
				}
	
				if(allEmails != null && allEmails.size() > 0) 
				{
					system.debug('====allEmails===='+allEmails.size());
					system.debug('====allEmails===='+allEmails);
					List<Messaging.SendEmailResult> results = Messaging.sendEmail(allEmails);
					system.debug('results ================>'+results);
				}
			}
		}
		catch(Exception e)
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {'tech@ffreedom.in'};
	        mail.setToAddresses(toAddresses);
	        mail.setSubject('Batch failure BatchEscalationMatrix');
	        mail.setPlainTextBody('Batch failure' + e.getMessage());
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
	}
	
	global void finish(Database.BatchableContext BC)
	{
		AsyncApexJob apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email 
                                 from AsyncApexJob where Id =:BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {apexJob.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Escalation Matrix job proccessed: ' + apexJob.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems +'batches with '+ apexJob.NumberOfErrors + 'failures with Job id'+apexJob.id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
	public Messaging.Singleemailmessage [] dataCollectionCompletionProcess(Account objAccount, Map<String, EscalationLevels__c> mapEscalationLevels)
	{
		Messaging.Singleemailmessage [] lstEmails = new List<Messaging.SingleEmailMessage>();
		if(objAccount != null && objAccount.Data_Collection_Date__c == null)
		{
			Date entityCreatedDate = objAccount.CreatedDate.Date();
			Date taskDueDate = entityCreatedDate.addDays(Integer.ValueOf(mapEscalationLevels.get('Data Collection Level1').Escalation_Days__c));
			
			Integer DataCollectionDateDiff = entityCreatedDate.daysBetween(Date.today());
			String[] lstToAddress = new List<String>(); 
			if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
			{
				lstToAddress.add(objAccount.Owner.Email);
				if(DataCollectionDateDiff > mapEscalationLevels.get('Data Collection Level1').Escalation_Days__c && DataCollectionDateDiff <= mapEscalationLevels.get('Data Collection Level2').Escalation_Days__c)
				{
					if(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email != null)
						lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
					if(lstToAddress != null)
					{
						Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Data Collection', 1, DataCollectionDateDiff, objAccount.Owner.FirstName);
						System.debug(' 1. email ===================>'+email);
						if(email != null)
							lstEmails.add(email);
					}
					/* Create Task */
					if(DataCollectionDateDiff == (mapEscalationLevels.get('Data Collection Level1').Escalation_Days__c + 1))
						createTask(objAccount, taskDueDate, 'Please Follow up with the Entity For Data Collection', 'Planned', 'Normal', 'Please Follow up with the Entity For Data Collection');
				}
				else if(DataCollectionDateDiff > mapEscalationLevels.get('Data Collection Level2').Escalation_Days__c && DataCollectionDateDiff <= mapEscalationLevels.get('Data Collection Level3').Escalation_Days__c)
				{
					if(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email != null && mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email != null)
					{
						lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
						lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
					}
					if(mapEscalationEmails.get('Vinita Somaiya').Email__c != null)
						lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);
					if(lstToAddress != null){
						Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Data Collection', 2, DataCollectionDateDiff, objAccount.Owner.FirstName);
						System.debug(' 2. email ===================>'+email);
						if(email != null)
							lstEmails.add(email);
					}
				}
				else if(DataCollectionDateDiff > mapEscalationLevels.get('Data Collection Level3').Escalation_Days__c)
				{
					if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
					{
						if(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email != null && mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email != null)
						{
							lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
							lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
						}
					}
					if(mapEscalationEmails.get('Vinita Somaiya').Email__c != null && mapEscalationEmails.get('Bishnu Sahu').Email__c != null)
					{
						lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);//Added as per new requirement
						lstToAddress.add(mapEscalationEmails.get('Bishnu Sahu').Email__c);
						//lstToAddress.add(mapEscalationEmails.get('Haren Banker').Email__c); /* Removed as per new Requirement */
					}
					if(lstToAddress != null)
					{
						Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Data Collection', 3, DataCollectionDateDiff, objAccount.Owner.FirstName);
						System.debug(' 3. email ===================>'+email);
						if(email != null)
							lstEmails.add(email);
					}
				}
			}
		}
		return lstEmails;
	}

	public Messaging.Singleemailmessage [] planWritingCompletionProcess(Account objAccount, Map<String, EscalationLevels__c> mapEscalationLevels)
	{
		Messaging.Singleemailmessage [] lstEmails = new List<Messaging.SingleEmailMessage>();
		
		if(objAccount.Plan_Writing_Date__c == null && objAccount.Data_Collection_Date__c != null)
		{
			Integer PlanWritingDateDiff = objAccount.Data_Collection_Date__c.daysBetween(Date.today());
			System.debug(' PlanWritingDateDiff =========>'+PlanWritingDateDiff);
			Date taskDueDate = objAccount.Data_Collection_Date__c.addDays(Integer.ValueOf(mapEscalationLevels.get('Plan Writing Level1').Escalation_Days__c));
			
			String[] lstToAddress = new List<String>();
			
			lstToAddress.add(objAccount.Owner.Email);

			if(PlanWritingDateDiff > mapEscalationLevels.get('Plan Writing Level1').Escalation_Days__c && PlanWritingDateDiff <= mapEscalationLevels.get('Plan Writing Level2').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);//Added as per new requirement
				
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Plan Writing', 1, PlanWritingDateDiff, objAccount.Owner.FirstName);
					System.debug(' 1. planWritingCompletionProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
				/* Create Task */
				if(PlanWritingDateDiff == (mapEscalationLevels.get('Plan Writing Level1').Escalation_Days__c + 1))
					createTask(objAccount, taskDueDate, 'Please Write The Plan For The Entity ASAP', 'Planned', 'Normal', 'Please Write The Plan For The Entity ASAP');
			}

			if(PlanWritingDateDiff > mapEscalationLevels.get('Plan Writing Level2').Escalation_Days__c && PlanWritingDateDiff <= mapEscalationLevels.get('Plan Writing Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				}
				lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Plan Writing', 2, PlanWritingDateDiff, objAccount.Owner.FirstName);
					System.debug(' 2. planWritingCompletionProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}

			if(PlanWritingDateDiff > mapEscalationLevels.get('Plan Writing Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				}
				lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);
				//lstToAddress.add(mapEscalationEmails.get('Bishnu Sahu').Email__c);/* Removed as per new requirement */
				lstToAddress.add(mapEscalationEmails.get('Bishnu Sahu').Email__c);
				/** Eternus Solutions  **/
				/** Author  : Aditi Satpute	**/
				/** Issue Id: 00001705 	**/
				/** Date    : 03/06/2012 	**/
				/** Purpose : Removed Haren's email id from escaltion emails**/
				/****************************************************/
				//lstToAddress.add(mapEscalationEmails.get('Haren Banker').Email__c); Removed as per issue Id:00001705 
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Plan Writing', 3, PlanWritingDateDiff, objAccount.Owner.FirstName);
					System.debug(' 3. email ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}
		}
		return lstEmails;
	}
	
	public Messaging.Singleemailmessage [] planApprovedProcess(Account objAccount, Map<String, EscalationLevels__c> mapEscalationLevels)
	{
		Messaging.Singleemailmessage [] lstEmails = new List<Messaging.SingleEmailMessage>();
		
		if(objAccount.Plan_Writing_Date__c != null && objAccount.Plan_Approved_Date__c == null)
		{
			String[] lstToAddress = new List<String>();
			Integer PlanApprovedDateDiff = objAccount.Plan_Writing_Date__c.daysBetween(Date.today());
			Date taskDueDate = objAccount.Plan_Writing_Date__c.addDays(Integer.ValueOf(mapEscalationLevels.get('Plan Approved Level1').Escalation_Days__c));
			
			lstToAddress.add(objAccount.Owner.Email);
			
			if(PlanApprovedDateDiff > mapEscalationLevels.get('Plan Approved Level1').Escalation_Days__c && PlanApprovedDateDiff <= mapEscalationLevels.get('Plan Approved Level2').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Plan Approved Stage', 1, PlanApprovedDateDiff, objAccount.Owner.FirstName);
					System.debug(' 1. planApprovedProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
				/* Create Task */
				if(PlanApprovedDateDiff == (mapEscalationLevels.get('Plan Approved Level1').Escalation_Days__c + 1))
					createTask(objAccount, taskDueDate, 'Please Get The Plan Approved For The Entity ASAP', 'Planned', 'Normal', 'Please Get The Plan Approved For The Entity ASAP');
			}

			if(PlanApprovedDateDiff > mapEscalationLevels.get('Plan Approved Level2').Escalation_Days__c && PlanApprovedDateDiff <= mapEscalationLevels.get('Plan Approved Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				}
				lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Plan Approved Stage', 2, PlanApprovedDateDiff, objAccount.Owner.FirstName);
					System.debug(' 2. planApprovedProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}

			if(PlanApprovedDateDiff > mapEscalationLevels.get('Plan Approved Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				}
				lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);
				lstToAddress.add(mapEscalationEmails.get('Bishnu Sahu').Email__c);
				//lstToAddress.add(mapEscalationEmails.get('Haren Banker').Email__c); /* Removed as per new requirement */
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Plan Approved Stage', 3, PlanApprovedDateDiff, objAccount.Owner.FirstName);
					System.debug(' 3. planApprovedProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}
		}
		return lstEmails;
	}
	
	public Messaging.Singleemailmessage [] actionPlanGenerationProcess(Account objAccount, Map<String, EscalationLevels__c> mapEscalationLevels)
	{
		Messaging.Singleemailmessage [] lstEmails = new List<Messaging.SingleEmailMessage>();
		if(objAccount.Plan_Approved_Date__c != null && objAccount.Action_Plan_Generation_Date__c == null)
		{
			String[] lstToAddress = new List<String>();
			Integer actionPlanDateDiff = objAccount.Plan_Approved_Date__c.daysBetween(Date.today());
			Date taskDueDate = objAccount.Plan_Approved_Date__c.addDays(Integer.ValueOf(mapEscalationLevels.get('Action Plan Level1').Escalation_Days__c));
			
			lstToAddress.add(objAccount.Owner.Email);
			
			if(actionPlanDateDiff > mapEscalationLevels.get('Action Plan Level1').Escalation_Days__c && actionPlanDateDiff <= mapEscalationLevels.get('Action Plan Level2').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Action Plan Generation', 1, actionPlanDateDiff, objAccount.Owner.FirstName);
					System.debug(' 1. actionPlanGenerationProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
				/* Create Task */
				if(actionPlanDateDiff == (mapEscalationLevels.get('Action Plan Level1').Escalation_Days__c + 1))
					createTask(objAccount, taskDueDate, 'Please Get The Plan Approved For The Entity ASAP', 'Planned', 'Normal', 'Please Get The Plan Approved For The Entity ASAP');
			}
			
			else if(actionPlanDateDiff > mapEscalationLevels.get('Action Plan Level2').Escalation_Days__c && actionPlanDateDiff <= mapEscalationLevels.get('Action Plan Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				}
				lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);
				
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Action Plan Generation', 2, actionPlanDateDiff, objAccount.Owner.FirstName);
					System.debug(' 2. actionPlanGenerationProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}
			
			else if(actionPlanDateDiff > mapEscalationLevels.get('Action Plan Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email);
				}
				//lstToAddress.add(mapEscalationEmails.get('Bishnu Sahu').Email__c); /* Removed as per new Requirement */
				lstToAddress.add(mapEscalationEmails.get('Bishnu Sahu').Email__c);
				lstToAddress.add(mapEscalationEmails.get('Vinita Somaiya').Email__c);
				/** Eternus Solutions  **/
				/** Author  : Aditi Satpute	**/
				/** Issue Id: 00001705 	**/
				/** Date    : 03/06/2012 	**/
				/** Purpose : Removed Haren's email id from escaltion emails**/
				/****************************************************/
			//	lstToAddress.add(mapEscalationEmails.get('Haren Banker').Email__c); Removed as per issue Id:00001705 
				
				if(lstToAddress != null)
				{
					System.debug(' lstToAddress =====> ' + lstToAddress);
					System.debug(' objAccount =====> ' + objAccount);
					System.debug(' actionPlanDateDiff =====> ' + actionPlanDateDiff);
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, 'Action Plan Generation', 3, actionPlanDateDiff, objAccount.Owner.FirstName);
					System.debug(' 3. actionPlanGenerationProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}
		}
		return lstEmails;
	} 

	public Messaging.Singleemailmessage [] firstExecutionCompletionProcess(Account objAccount, Map<String, EscalationLevels__c> mapEscalationLevels)
	{
		Messaging.Singleemailmessage [] lstEmails = new List<Messaging.SingleEmailMessage>();
		if(objAccount.Action_Plan_Generation_Date__c != null && objAccount.First_Execution_Completion_Date__c == null)
		{
			String[] lstToAddress = new List<String>();
			Integer firstExeComplDateDiff = objAccount.Action_Plan_Generation_Date__c.daysBetween(Date.today());
			Date taskDueDate = objAccount.Action_Plan_Generation_Date__c.addDays(Integer.ValueOf(mapEscalationLevels.get('First Execution Level1').Escalation_Days__c));
			
			lstToAddress.add(objAccount.Owner.Email);
						
			if(firstExeComplDateDiff > mapEscalationLevels.get('First Execution Level1').Escalation_Days__c && firstExeComplDateDiff <= mapEscalationLevels.get('First Execution Level2').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Member_Engagement__r.Email);
					//lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Advisory__r.Email); /* Removed as per new Requirement */
				}
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, '1st Execution', 1, firstExeComplDateDiff, objAccount.Owner.FirstName);
					System.debug(' 1. firstExecutionCompletionProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
				/* Create Task */
				if(firstExeComplDateDiff == (mapEscalationLevels.get('First Execution Level1').Escalation_Days__c + 1))
					createTask(objAccount, taskDueDate, 'Please Generate First Execution For The Entity ASAP', 'Planned', 'Normal', 'Please Generate First Execution For The Entity ASAP');
			}
			
			else if(firstExeComplDateDiff > mapEscalationLevels.get('First Execution Level2').Escalation_Days__c && firstExeComplDateDiff <= mapEscalationLevels.get('First Execution Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Member_Engagement__r.Email);
				}
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, ' 1st Execution', 2, firstExeComplDateDiff, objAccount.Owner.FirstName);
					System.debug(' 2. actionPlanGenerationProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}
			
			else if(firstExeComplDateDiff > mapEscalationLevels.get('First Execution Level3').Escalation_Days__c)
			{
				if(mapOwnerIdWorkstation.get(objAccount.OwnerId) != null)
				{
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Manager__r.Email);
					lstToAddress.add(mapOwnerIdWorkstation.get(objAccount.OwnerId).Member_Engagement__r.Email);
				}
				lstToAddress.add(mapEscalationEmails.get('Bishnu Sahu').Email__c);
				//lstToAddress.add(mapEscalationEmails.get('Haren Banker').Email__c);/* Removed as per new Requirement */
				
				if(lstToAddress != null)
				{
					Messaging.Singleemailmessage email = sendEmailFunctionality(lstToAddress, objAccount, '1st Execution', 3, firstExeComplDateDiff, objAccount.Owner.FirstName);
					System.debug(' 3. firstExecutionCompletionProcess ===================>'+email);
					if(email != null)
						lstEmails.add(email);
				}
			}
		}
		return lstEmails;
	}

	public Messaging.SingleEmailMessage sendEmailFunctionality(List<string> listToAddresses, Account objAccount, string stageName, Integer stageLevel, Integer days, String OwnerName)
	{
			Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
			email.setToAddresses(listToAddresses);
			email.setTargetObjectId(objAccount.OwnerId);
			//email.setCcAddresses(new String[]{'ffreedom.testmail@gmail.com'});
			email.setSubject('Level ' + stageLevel + ' Alert -- ' + stageName + ' for ' + objAccount.Name);
			email.setHtmlBody('<p> Hello ' + OwnerName + '</p>' +'<p>  The ' + stageName + ' duration for the entity ' + 
								objAccount.Name + ' has crossed ' + days + ' days.</p>' + '\n' + 'Herein is the link of the same : ' +
								'<a href= \'https://ffreedom.my.salesforce.com/' + objAccount.Id + '\' >' + objAccount.Name + '</a>' 
								+ '<p>Please accomplish the task as early as possible.</p>' + '<p>Thank You,</p>'+'<p>Compliance Team</p>');
			email.setSaveAsActivity(false);			
			return email;
	}
	
	public void createTask(Account objAccount, Date dueDate, String subject, String status, String priority, String description)
	{
		objTask = new Task(OwnerId = objAccount.OwnerId, Subject = subject,Status = status,Priority = priority,
						   Description = description, WhatId = objAccount.Id);
						   
		Database.Saveresult lstSaveResult = Database.insert(objTask);
		System.debug('==== lstSaveResult : == ' + lstSaveResult);
		if(lstSaveResult.isSuccess())
		{
			Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			mail.setSubject(objTask.Subject);
			mail.setHtmlBody('<p style="font-size:25px;font-weight:bold;"> New Task </p>'+ 
							 '<p>To : ' + objAccount.Owner.Name + '</p>' +
							 '<p>' + 'Technology Support has assigned you the following new task: ' + '</p>' + 
							 '<p>  Subject : ' + Subject + '</p>' + 
							 '<p>  Entity : ' + objAccount.Name + '</p>' +
							 '<p>  Due Date : ' + dueDate + '</p>' +
							 '<p>  Comments : ' + Subject + '</p>' +
							 '<p>' + ' For more details : ' + 
							 '<a href= \'https://ffreedom.my.salesforce.com/' + lstSaveResult.getId() + '\' >' + 'Click Here' + '</a>' + '</p>');
			
			mail.setTargetObjectId(objAccount.OwnerId);
			mail.setSaveAsActivity(false);
			List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail });
			System.debug('==== Create Task results : == ' + results);
		}
		
	}
}