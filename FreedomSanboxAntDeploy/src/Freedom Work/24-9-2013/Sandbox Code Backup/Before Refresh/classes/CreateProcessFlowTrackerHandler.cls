/*  CreateProcessFlowTrackerHandler class is using to create set of Flow tracker to associated with Entity on After entity creation.
	Creating new task for first flow tacker record with notification queue.
*  
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Anupam Agrawal     2-Aug-2013        Initial Draft
*/
public with sharing class CreateProcessFlowTrackerHandler 
{
	//Method call on Client Entity Creation.
	public void createFlowTempateWithTracker(map<Id, Account> mapIdToAccount)
	{
		List<Flows_Template__c> lstFlowTemplate = new List<Flows_Template__c>();
		List<Flows_Tracker__c> lstFlowTracker = new List<Flows_Tracker__c>();
		Map<Id, Id> mapEntityIdToOwnerId = new Map<Id, Id>();
		Map<Id, Workstation__c > mapEntityOwnerIdToWorkstation = new Map<Id, Workstation__c >();
		
		//Client recordType Id
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
		Id clientRecordTypeId =  RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId();	
		
		//"Flow Template Detail" recordtype Id.
		Id rtIdOfDetailFlowTemplate = [Select Id from RecordType where Name = 'Flows Template Detail'].Id;
		
		//list contain Flow Template Master record with its flow Tracker records.
		List<Flows_Template__c> lstMasterFlowsTemplate= [Select Skip_Weekends__c, RecordTypeId, Name, 
																(Select Name, Category__c, Subject__c, Days_After__c, Due_Date__c, 
																 Flows_Template__c, Comments__c, Priority__c, Stage__c, Task_Sequence__c,
																 Status__c From Flows_Trackers__r) 
														 From Flows_Template__c 
														 where RecordType.Name = 'Flows Template Master'];
														 
		
		
		//Master Flow template is not Empty
		if(!lstMasterFlowsTemplate.isEmpty())
		{				
			//Create Detail Flow Template record for each client entity.																 
			for(Account objEntity : mapIdToAccount.values())
			{
				//Entity must be client type.
				if(objEntity.RecordTypeId == clientRecordTypeId)
				{	
					Flows_Template__c objFlowTemplate = new Flows_Template__c();
					objFlowTemplate.Account__c = objEntity.Id;				
					objFlowTemplate.Name = 'MST Flow Tempalate Detail';			
					lstFlowTemplate.add(objFlowTemplate);
					
					//Map contain EntityId with their Owner.
					mapEntityIdToOwnerId.put(objEntity.Id, objEntity.OwnerId);
				}	
			}
			
			//Insert Flow template Detail record
			if(!lstFlowTemplate.isEmpty())
				insert lstFlowTemplate;
			
			//Entity to Owner map is not Empty Means there is client entity present.
			if(mapEntityIdToOwnerId.size() != 0)
			{
				//Create WorkStation Map between Financial planner to workstation obj to get associated MST I, MST II etc..
				for(Workstation__c objWorkstation : [Select Id, Member_Engagement__c, Financial_Planner__c from Workstation__c where Financial_Planner__c =: mapEntityIdToOwnerId.values()])
					mapEntityOwnerIdToWorkstation.put(objWorkstation.Financial_Planner__c, objWorkstation);
				
				//Create Flow tracker records for each newly inserted Flow Template
				for(Flows_Template__c objFT : lstFlowTemplate)
				{
					for(Flows_Tracker__c objFTrack : lstMasterFlowsTemplate[0].Flows_Trackers__r)
					{
						Flows_Tracker__c objFlowTracker = new Flows_Tracker__c();
						objFlowTracker.Flows_Template__c = objFT.Id;
						objFlowTracker.Name = objFTrack.Name;
						objFlowTracker.Category__c = objFTrack.Category__c ;
					    objFlowTracker.Subject__c = objFTrack.Subject__c;
					    objFlowTracker.Days_After__c = objFTrack.Days_After__c;
					    objFlowTracker.Due_Date__c = objFTrack.Due_Date__c;
					    objFlowTracker.Comments__c = objFTrack.Comments__c;
					    objFlowTracker.Priority__c = objFTrack.Priority__c;
					    objFlowTracker.Stage__c = objFTrack.Stage__c;
					    objFlowTracker.Task_Sequence__c = objFTrack.Task_Sequence__c;
						objFlowTracker.Status__c = objFTrack.Status__c;
						
						lstFlowTracker.add(objFlowTracker);
					}
				}
				
				//Insert Flow trac
				if(!lstFlowTracker.isEmpty())
					insert lstFlowTracker;
				
				//Collect all new created Flow Tracker where Task Sequence = 1
				List<Flows_Tracker__c> lstFirstTaskFlowTracker = [Select Name, Category__c, Subject__c, Days_After__c, Due_Date__c, 
																	 Flows_Template__c, Comments__c, Priority__c, Stage__c, Task_Sequence__c, Flows_Template__r.Account__c,
																	 Status__c From Flows_Tracker__c where Id =: lstFlowTracker and Task_Sequence__c = 1];
				
				//Create task for each Flow tracker
				List<Task> lstTask = new List<Task>();	
				if(mapEntityOwnerIdToWorkstation.size() != 0)															 
				{	
					for(Flows_Tracker__c objFTrack : lstFirstTaskFlowTracker)
					{
						Task objTask = new Task();
						objTask.OwnerId = mapEntityOwnerIdToWorkstation.get(mapEntityIdToOwnerId.get(objFTrack.Flows_Template__r.Account__c)).Member_Engagement__c;
						objTask.WhatId = objFTrack.Flows_Template__r.Account__c;
						objTask.Subject = objFTrack.Subject__c;
						objTask.Subject_Category__c = objFTrack.Category__c;
						objTask.Priority = objFTrack.Priority__c;
						objTask.Status = 'In Progress';
						objTask.ActivityDate = system.today() + Integer.valueOf(objFTrack.Days_After__c);
						//objTask.Description = objFTrack.Comments__c;
						
						lstTask.add(objTask);
					}
					
					// Insert task
					if(!lstTask.isEmpty())
						insert lstTask;
					
					//Relate task with Flow Trakcer record.
					for(Task objTask : lstTask)
						for(Flows_Tracker__c objFTrack : lstFirstTaskFlowTracker)
							if((objTask.WhatId  == objFTrack.Flows_Template__r.Account__c) && (objTask.Subject == objFTrack.Subject__c))
							{
								objFTrack.Task_Id__c = objTask.Id;
								objFTrack.Status__c = 'In Progress';
							}
					
					//update Flow tracker with Task Id.
					if(!lstFirstTaskFlowTracker.isEmpty())
						update lstFirstTaskFlowTracker;
				}		
			}
		}
			
	}
	
	@isTest
	private static void CreateProcessFlowTrackerHandlerTest() 
	{
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_FLOWS_TEMPLATE = Flows_Template__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_FLOWS_TEMPLATE_MAP = DESCRIBE_RESULT_FLOWS_TEMPLATE.getRecordTypeInfosByName();
    	
    	//Insert RecordType record
    	List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
    	RecTypes__c objRecType = new RecTypes__c(Name='General_Business', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
    	RecTypes__c objRecType1 = new RecTypes__c(Name='AccountFamily', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
    	RecTypes__c objRecType2 = new RecTypes__c(Name='AccountClient', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
    	
    	lstRecTypes.add(objRecType);										 
    	lstRecTypes.add(objRecType1);
    	lstRecTypes.add(objRecType2);	
    	insert lstRecTypes;
		
		List<Account> lstAccount = new List<Account>();
		
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		User user = testData.initializeUser();
	    insert user;
	    
	    system.runAs(user)
		{
			
	   	    Workstation__c workstation = testData.init_workstation(user);
			insert workstation;
			
			List<Flows_Template__c> lstFlowTemplate = new List<Flows_Template__c>();
			List<Flows_Tracker__c> lstFlowTracker = new List<Flows_Tracker__c>();
			
			
			Flows_Template__c objFlowTemplate = new Flows_Template__c(RecordTypeId = RECORD_TYPE_INFO_FLOWS_TEMPLATE_MAP.get('Flows Template Master').getRecordTypeId(), Name = 'MST Flow Template');
			lstFlowTemplate.add(objFlowTemplate);
			
			insert lstFlowTemplate;
			
	        Flows_Tracker__c objFlowTracker = new Flows_Tracker__c();
		   	objFlowTracker.Flows_Template__c = objFlowTemplate.Id;
			objFlowTracker.Name = 'Welcome Call Test';
			objFlowTracker.Category__c = 'Call' ;
			objFlowTracker.Subject__c = 'Welcome Call Test';
			objFlowTracker.Days_After__c = 1;
			objFlowTracker.Priority__c = 'High';
			objFlowTracker.Task_Sequence__c = 1;
			objFlowTracker.Status__c = 'Planned';
				
			lstFlowTracker.Add(objFlowTracker);
			
			insert lstFlowTracker;
			
			
	    	//Insert Account record
	    	Account objGeneralAccount = new Account(Name='Parner Account Test',OwnerId = user.Id,
	    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
	    	
	        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = user.Id,
		                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
		                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
		                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
		                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
		                       RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true);
		                       
		    lstAccount.add(objAccount1);
		    lstAccount.add(objGeneralAccount);               
			insert lstAccount;
		}	
	}
}