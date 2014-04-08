/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Anupam/Aditi	   28/12/12		 Executon Tracker Trigger Handler Class.
*/

public with sharing class ExecutionTrackerHandler 
{
	//Commented on : 11/02/2013 : As per Jigar Sir and Samir Sir's discussion with client : no need to send task, 
	//Email and chatter notification is enough
	/*
	//Method invoke after insert of Excecution tracker record and assing to task respected EMT member.
	public void onAfterInsert(List<Execution_Tracker__c> lstNewExecutionTracker)
	{
		List<Execution_Tracker__c> lstExecutionTracker = new List<Execution_Tracker__c>();
		for(Execution_Tracker__c objET : lstNewExecutionTracker) 
		{
			if(objET.ET_Status__c == 'Assigned to MET') 
			{
				lstExecutionTracker.add(objET);
			}
		}
		//Local variables.
		Set<id> setUserIdFP = new Set<Id>();
		Set<id> setUserIdBP = new Set<Id>();
		Account objBPAccount = new Account();
		Contact objContact = new Contact();
		Map<Id, List<Account>> mapUserIdToLstAccount = new Map<Id, List<Account>>();
		Map<Id, List<Execution_Tracker__c>> mapAccountIdToLstExecutionTracker = new Map<Id, List<Execution_Tracker__c>>();
		
		Map<Id, RecordType> mapIdToRecordType = new Map<Id, RecordType>([Select Id, Name from RecordType where sobjectType='Account']);
		//Map to retrive all Business Entities
		Map<Id, Account> mapIdToBPAccount = new Map<Id, Account>([select Id, OwnerId, Channel_Manager__c 
																	from Account 
																	where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c]);
		Map<Id, Contact> mapIdToContact = new Map<Id, Contact>([select Id, AccountId from Contact]);
		List<Task> lstTask = new List<Task>();
		
		//Create map between EntityId and related Execution records.
		for(Execution_Tracker__c objET : lstExecutionTracker)
		{
			if(!mapAccountIdToLstExecutionTracker.containsKey(objET.Entity_Name__c))
				mapAccountIdToLstExecutionTracker.put(objET.Entity_Name__c, new List<Execution_Tracker__c>{objET});
			else
				mapAccountIdToLstExecutionTracker.get(objET.Entity_Name__c).add(objET);
		}
		
		System.debug('------------------Map.keyset--------------'+mapAccountIdToLstExecutionTracker.keySet());
		//Collect Owner of all entities and created Map between userId and related Entity objects.
		for(Account objAccount : [Select Id, Name, OwnerId, Related_To__c, RecordTypeId from Account where Id IN : mapAccountIdToLstExecutionTracker.keySet()])
		{
			//Map between User Id and Entity objects
			if(!mapUserIdToLstAccount.containsKey(objAccount.OwnerId))
				mapUserIdToLstAccount.put(objAccount.OwnerId, new List<Account>{objAccount});
			else
				mapUserIdToLstAccount.get(objAccount.OwnerId).add(objAccount);
			
			//Collect Owner Id.
			if(objAccount.Related_To__c.equalsIgnoreCase('Business Partner') && mapIdToRecordType.get(objAccount.RecordTypeId).Name == 'Client')
				setUserIdBP.add(objAccount.OwnerId);
			else if(mapIdToRecordType.get(objAccount.RecordTypeId).Name == 'Client')
				setUserIdFP.add(objAccount.OwnerId);
		}
		
		System.debug('-------------setUserIdFP-------------'+setUserIdFP);
		if(setUserIdFP.size() > 0)
		{
			for(Workstation__c objWorkstation : [Select Member_Engagement__c, Financial_Planner__c From Workstation__c where Financial_Planner__c IN : setUserIdFP ])
			{
				List<Account> lstAcc = mapUserIdToLstAccount.get(objWorkstation.Financial_Planner__c);
				for(Account objAcc : lstAcc)
				{ 
					List<Execution_Tracker__c> lstET = mapAccountIdToLstExecutionTracker.get(objAcc.Id);
					for(Execution_Tracker__c objET : lstET)
					{
						Task objTask = new Task(
											        OwnerId = objWorkstation.Member_Engagement__c,
											        WhatId = objAcc.Id,
										            Subject = 'Execution record created for entity:'+ objAcc.Name
										       );
					   lstTask.add(objTask);
					}
				}
			}
		}
		
		
		if(setUserIdBP.size() > 0)
		{
			Map<Id, Id> mapEntityOwnerIdToManagerId = new Map<Id, Id>();
			for(User objUser : [select Id, ContactId, ManagerId from  User where Id IN:setUserIdBP])
			{
				if(mapIdToContact.containsKey(objUser.ContactId))
				{
					objContact = mapIdToContact.get(objUser.ContactId);
					if(objContact != null)
					{
						if(mapIdToBPAccount.containsKey(objContact.AccountId))
						{
							objBPAccount = mapIdToBPAccount.get(objContact.AccountId);
							mapEntityOwnerIdToManagerId.put(objUser.Id, objBPAccount.Channel_Manager__c);
						}
					}
				}
				
			}
			Map<Id, Id> mapManagerIdToMET = new Map<Id, Id>();
			for(Workstation__c objWorkstation : [Select Member_Engagement__c, Financial_Planner__c From Workstation__c where Financial_Planner__c IN : mapEntityOwnerIdToManagerId.values() ])
			{
				mapManagerIdToMET.put(objWorkstation.Financial_Planner__c, objWorkstation.Member_Engagement__c);
			}
			for(Id userId : mapEntityOwnerIdToManagerId.keySet())
			{
				Id emtId = mapManagerIdToMET.get(mapEntityOwnerIdToManagerId.get(userId));
				List<Account> lstAcc = mapUserIdToLstAccount.get(userId);
				for(Account objAcc : lstAcc)
				{ 
					List<Execution_Tracker__c> lstET = mapAccountIdToLstExecutionTracker.get(objAcc.Id);
					for(Execution_Tracker__c objET : lstET)
					{
						Task objTask = new Task(
											        OwnerId = emtId,
											        WhatId = objAcc.Id,
										            Subject = 'Execution record created for entity:'+ objAcc.Name
										            
										          );
					   lstTask.add(objTask);
					}
				}
			}
		}
		try
		{
			if(!lstTask.isEmpty())
				insert lstTask;
		}
		catch(Exception e)
		{
			system.debug('************Error*******************'+e);
		}
	}
	
	//create tasl for Operation Team Member 
	public void onAfterUpdate(List<Execution_Tracker__c> lstNewExecutionTracker, List<Execution_Tracker__c> lstOldExecutionTracker)
	{
		//Local variables.
		Set<id> setUserIdFP = new Set<Id>();
		Set<id> setUserIdBP = new Set<Id>();
		Account objBPAccount = new Account();
		Contact objContact = new Contact();
		Map<Id, List<Account>> mapUserIdToLstAccount = new Map<Id, List<Account>>();
		Map<Id, List<Execution_Tracker__c>> mapAccountIdToLstExecutionTracker = new Map<Id, List<Execution_Tracker__c>>();
		
		Map<Id, RecordType> mapIdToRecordType = new Map<Id, RecordType>([Select Id, Name from RecordType where sobjectType='Account']);
		List<Task> lstTask = new List<Task>();
		//Map to retrive all Business Entities
		Map<Id, Account> mapIdToBPAccount = new Map<Id, Account>([select Id, OwnerId, Channel_Manager__c 
																	from Account 
																	where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c]);
		Map<Id, Contact> mapIdToContact = new Map<Id, Contact>([select Id, AccountId from Contact]);
		List<Execution_Tracker__c> lstExecutionTracker = new List<Execution_Tracker__c>();
		List<Execution_Tracker__c> lstCompletedET = new List<Execution_Tracker__c>();
		
		//Create a list ET records where status = 'Assign to Operations'
		for(Integer i = 0 ; i < lstNewExecutionTracker.size() ; i++)
		{
			Execution_Tracker__c objET = lstNewExecutionTracker[i];
			Execution_Tracker__c objOldET = lstOldExecutionTracker[i];
			if((objOldET.Application_Status__c == '' && objET.Application_Status__c == 'Opened') ||
				(objOldET.ET_Status__c == 'Assigned to MET' && objET.ET_Status__c == 'Assigned to Operations'))
			{
				lstExecutionTracker.add(objET);
			}
			//if(objET.ET_Status__c == 'Completed')
			//{
			//	lstCompletedET.add(objET);
			//}
		}
		//Create map between EntityId and related Execution records.
		for(Execution_Tracker__c objET : lstExecutionTracker)
		{
			if(!mapAccountIdToLstExecutionTracker.containsKey(objET.Entity_Name__c))
				mapAccountIdToLstExecutionTracker.put(objET.Entity_Name__c, new List<Execution_Tracker__c>{objET});
			else
				mapAccountIdToLstExecutionTracker.get(objET.Entity_Name__c).add(objET);
		}
		
		System.debug('------------------Map.keyset--------------'+mapAccountIdToLstExecutionTracker.keySet());
		//Collect Owner of all entities and created Map between userId and related Entity objects.
		for(Account objAccount : [Select Id, Name, OwnerId, Related_To__c, RecordTypeId from Account where Id IN : mapAccountIdToLstExecutionTracker.keySet()])
		{
			//Map between User Id and Entity objects
			if(!mapUserIdToLstAccount.containsKey(objAccount.OwnerId))
				mapUserIdToLstAccount.put(objAccount.OwnerId, new List<Account>{objAccount});
			else
				mapUserIdToLstAccount.get(objAccount.OwnerId).add(objAccount);
			
			//Collect Owner Id.
			if(objAccount.Related_To__c.equalsIgnoreCase('Business Partner') && mapIdToRecordType.get(objAccount.RecordTypeId).Name == 'Client')
				setUserIdBP.add(objAccount.OwnerId);
			else if(mapIdToRecordType.get(objAccount.RecordTypeId).Name == 'Client')
				setUserIdFP.add(objAccount.OwnerId);
		}
		
		System.debug('-------------setUserIdFP-------------'+setUserIdFP);
		
		if(setUserIdFP.size() > 0)
		{
			for(Workstation__c objWorkstation : [Select Member_Engagement__c, Operations__c, Financial_Planner__c From Workstation__c where Financial_Planner__c IN : setUserIdFP ])
			{
				List<Account> lstAcc = mapUserIdToLstAccount.get(objWorkstation.Financial_Planner__c);
				for(Account objAcc : lstAcc)
				{ 
					List<Execution_Tracker__c> lstET = mapAccountIdToLstExecutionTracker.get(objAcc.Id);
					for(Execution_Tracker__c objET : lstET)
					{
						Task objTask = new Task(
											        OwnerId = objWorkstation.Operations__c,
											        WhatId = objAcc.Id,
										            Subject = 'Execution record created for entity:'+ objAcc.Name
										       );
					   lstTask.add(objTask);
					}
				}
			}
		}
		
		if(setUserIdBP.size() > 0)
		{
			Map<Id, Id> mapEntityOwnerIdToManagerId = new Map<Id, Id>();
			for(User objUser : [select Id, ContactId, ManagerId from  User where Id IN:setUserIdBP])
			{
				if(mapIdToContact.containsKey(objUser.ContactId))
				{
					objContact = mapIdToContact.get(objUser.ContactId);
					if(objContact != null)
					{
						if(mapIdToBPAccount.containsKey(objContact.AccountId))
						{
							objBPAccount = mapIdToBPAccount.get(objContact.AccountId);
							mapEntityOwnerIdToManagerId.put(objUser.Id, objBPAccount.Channel_Manager__c);
						}
					}
				}
			}
			Map<Id, Id> mapManagerIdToOTM = new Map<Id, Id>();
			for(Workstation__c objWorkstation : [Select Member_Engagement__c, Operations__c, Financial_Planner__c From Workstation__c where Financial_Planner__c IN : mapEntityOwnerIdToManagerId.values() ])
			{
				mapManagerIdToOTM.put(objWorkstation.Financial_Planner__c, objWorkstation.Operations__c);
			}
			
			for(Id userId : mapEntityOwnerIdToManagerId.keySet())
			{
				Id operationId = mapManagerIdToOTM.get(mapEntityOwnerIdToManagerId.get(userId));
				system.debug('*******operationId*********'+operationId);
				List<Account> lstAcc = mapUserIdToLstAccount.get(userId);
				for(Account objAcc : lstAcc)
				{ 
					List<Execution_Tracker__c> lstET = mapAccountIdToLstExecutionTracker.get(objAcc.Id);
					for(Execution_Tracker__c objET : lstET)
					{
						Task objTask = new Task(
											        OwnerId = operationId,
											        WhatId = objAcc.Id,
										            Subject = 'Execution record created for entity:'+ objAcc.Name
										            
										          );
					   lstTask.add(objTask);
					}
				}
			}
		}
		try
		{
			if(!lstTask.isEmpty())
				insert lstTask;
		}
		catch(Exception e)
		{
			system.debug('************Error*******************'+e);
		}
		
	}
	*/
	//If there is change in Agreed Amount by MET member Mail notification is sent to the Opreation Team member
	public void onBeforeUpdate(List<Execution_Tracker__c> lstNewExecutionTracker, List<Execution_Tracker__c> lstOldExecutionTracker)
	{
		List<Task> lstTask = new List<Task>();
		Map<Id,User> mapIdToUser = new Map<Id,User>([select Id,Email,Name from User]);
		Map<Id,Account> mapIdToAccount = new Map<Id,Account>([Select Id, Name from Account]);
		Messaging.SingleEmailMessage emailToOperations = new Messaging.SingleEmailMessage();
		List<Messaging.SingleEmailMessage> lstSendEmail = new List<Messaging.SingleEmailMessage>();
		List<String> lstToAddress = new List<String>();
		List<FeedItem> lstFeedItem = new List<FeedItem>();
		
		for(Integer i = 0 ; i < lstNewExecutionTracker.size() ; i++)
		{
			
			/*Added By : Aditi Satpute
			 *Date : 14/1/13
			 *Purpose : Send notification to Ops Team on change in Agreed amount by MET team0
			 */	
			if(lstOldExecutionTracker[i].Agreed_Amount__c != null)
			{
				if(lstOldExecutionTracker[i].Agreed_Amount__c != lstNewExecutionTracker[i].Agreed_Amount__c && lstOldExecutionTracker[i].ET_Status__c != 'Assigned to MET')
				{
					//Task created for that particular record is assigned to Ops Team.
					Task objTask = new Task(
											 OwnerId = lstOldExecutionTracker[i].Owner__c,
											 WhatId = lstOldExecutionTracker[i].Entity_Name__c,
										     Subject = 'Agreed Amount of ET record with Scheme Name "'
										     			+ lstOldExecutionTracker[i].Scheme_Name_Policy_Name__c
										     			+ '" has been Changed from "'
										     			+ lstOldExecutionTracker[i].Agreed_Amount__c + '" to "'+ lstNewExecutionTracker[i].Agreed_Amount__c + '".'
										   );
						
					lstTask.add(objTask);
					
					//Send Mail Notification to Operations User
					if(mapIdToUser.containsKey(lstOldExecutionTracker[i].Owner__c))
					{
						User objOpsUser = mapIdToUser.get(lstOldExecutionTracker[i].Owner__c);
						if(objOpsUser.Email != null)
		    				lstToAddress.add(objOpsUser.Email);
		    			if(!lstToAddress.isEmpty())
			        		emailToOperations.setToAddresses( lstToAddress );
			        	
			        	if(mapIdToAccount.containsKey(lstOldExecutionTracker[i].Entity_Name__c))
			        	{
			        		Account objAccount = mapIdToAccount.get(lstOldExecutionTracker[i].Entity_Name__c);
					       	emailToOperations.setSubject( 'Change in Agreed Amount of Entity ' + objAccount.Name);		
					      	String domain = URL.getSalesforceBaseUrl().toExternalForm();
						    String TargetLink = domain + '/' + lstOldExecutionTracker[i].Entity_Name__c;
						     	
						    emailToOperations.setHtmlBody('Dear '+ objOpsUser.Name + ',<br/><br/>Agreed Amount of ET record with Scheme Name "'
						      								  	+ lstOldExecutionTracker[i].Scheme_Name_Policy_Name__c 
						      								  	+ '" has been Changed from "'
						      								  	+ lstOldExecutionTracker[i].Agreed_Amount__c + '" to "'+ lstNewExecutionTracker[i].Agreed_Amount__c 
						      								  	+ '". Please go through the Execution Tracker button on the detail page.<br/>Click here : <a href=\''
							      								+TargetLink+'\'>'+TargetLink+'</a> <br/><br/> Thanks,<br/>Member Engagement Team');
							      								
						    //emailToOperations.setSenderDisplayName(objBPAccount.Channel_Manager__r.Name);
							emailToOperations.setSenderDisplayName('Member Engagement Team');	
							
						    //Sends the email Notification to Operations User
						    lstSendEmail.add(emailToOperations);
						    //Messaging.SendEmailResult [] arrBPOperationResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToOperations});
			        	}  
					    //Send Chatter Notification to Operations User
						FeedItem post = new FeedItem();
						post.ParentId = lstOldExecutionTracker[i].Owner__c;
						post.Body = 'Agreed Amount of ET record with Scheme Name "'
										     			+ lstOldExecutionTracker[i].Scheme_Name_Policy_Name__c
										     			+ '" has been Changed from "'
										     			+ lstOldExecutionTracker[i].Agreed_Amount__c + '" to "'+ lstNewExecutionTracker[i].Agreed_Amount__c + '".';
						lstFeedItem.add(post);
					}
				}
			}
			if(lstOldExecutionTracker[i].Agreed_Amount__c == lstOldExecutionTracker[i].Actual_Action_Amount__c
				 && lstNewExecutionTracker[i].Agreed_Amount__c != lstNewExecutionTracker[i].Actual_Action_Amount__c)
			{
			 	lstNewExecutionTracker[i].Agreed_Amount_Base_Amount__c = lstNewExecutionTracker[i].Agreed_Amount__c;
			}
		}
		try
		{
			if(!lstTask.isEmpty())
				insert lstTask;
			if(!lstFeedItem.isEmpty())	
				insert lstFeedItem;	
			if(!lstSendEmail.isEmpty())	
				Messaging.sendEmail(lstSendEmail);	
			if(!lstNewExecutionTracker.isEmpty())
				update lstNewExecutionTracker;
		}
		catch(Exception e)
		{
			system.debug('************Error*******************'+e);
		}
	}
	
}