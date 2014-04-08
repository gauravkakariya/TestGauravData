global class BatchForRenewalProcess implements Database.Batchable<Sobject>
{
   
   
    public String query;
    public Date todaysDate {set;get;}
    Map<ID,Workstation__c> mapFPAndWorkstation {set;get;}
    List<Task> lstTaskTobeCreate; 
    public Map<Id,Integer> accountTrackersMap {set; get;}
    public BatchForRenewalProcess()
    {
        todaysDate = System.today();
        mapFPAndWorkstation = new  Map<ID,Workstation__c>();
        accountTrackersMap  = new Map<Id,Integer>();
    }
    
    global Database.QueryLocator  start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Renewal__c> lstRenewals)
    {
    	List<SMS_History__c> lstsmsRecords = new List<SMS_History__c>();
    	String dueTplText = null;
		Set<ID> setEntityId = new Set<ID>();
        lstTaskTobeCreate = new List<Task>(); 
        List<String> lstCCAddress;
        Integer executionCount = 0;
        Date renewalDate;
        Boolean isMailSent ;
        //Workstation__c objWorkstation;
        
        System.debug('===========todaysDate===='+todaysDate);
        
        EmailTemplate emailTemplateWithoneExecution = [ Select e.Name, e.Id From EmailTemplate e where Name = 'Renewal Template With Atleast One Execution'];
        EmailTemplate emailTemplateNoExecution = [ Select e.Name, e.Id From EmailTemplate e where Name = 'Renewal Template With No Execution'];
        
      //Setty:SMS Magic uninstall 19/09/2012  smsmagicvc1__SMS_Template__c template =  [select smsmagicvc1__Text__c from smsmagicvc1__SMS_Template__c where smsmagicvc1__Name__c = 'Renewal Due Template' and smsmagicvc1__ObjectName__c = 'Renewal__c'];
      // /*Setty:Newcode
        smagicbasic__SMS_Template__c template=[select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Renewal Due Template' and smagicbasic__ObjectName__c = 'Renewal__c'];
       // */
        
        Date PrevDate = todaysDate.addDays(-1);
       // Date alertMonthBeforeDate; 
      //  Date alertDateforTaskCreate;
       
       /*Setty: SMS Magic uninstall 19/09/2012
        
        if(template.smsmagicvc1__Text__c!= null)
        {
        	dueTplText  = template.smsmagicvc1__Text__c;
    	}
        
       Setty:End*/
       
       // /*Setty: Newcode
        
        if(template.smagicbasic__Text__c!= null)
        {
        	dueTplText  = template.smagicbasic__Text__c;
    	}
        
      // */
        
        for(Workstation__c objWorkstationToPut :[Select w.Member_Engagement__r.Email, w.Member_Engagement__c, w.Manager__r.Email, 
                                            w.Manager__c, w.Id, w.Financial_Planner__r.Email, w.Financial_Planner__c 
                                            From Workstation__c w])
        {
            mapFPAndWorkstation.put(objWorkstationToPut.Financial_Planner__c,objWorkstationToPut); 
        }
        
        try
        {
            if(lstRenewals != null && lstRenewals.size() > 0)
            {
                for(Renewal__c objRenewal : lstRenewals)
                {
                    setEntityId.add(objRenewal.Entity__c);
                }
               for(Execution_Tracker__c tracker : [Select e.Name, e.Id, e.Entity_Name__c, e.Completion_Date__c From Execution_Tracker__c e where Completion_Date__c != null And Entity_Name__c IN:setEntityId])
               {
               		Integer iCount = 0;
                 	if(!accountTrackersMap.isEmpty() && accountTrackersMap.containsKey(tracker.Entity_Name__c))
                    {
                       iCount = accountTrackersMap.get(tracker.Entity_Name__c);
                       accountTrackersMap.put(tracker.Entity_Name__c,++iCount);
                    }       
                    else
                    {
                    	accountTrackersMap.put(tracker.Entity_Name__c,++iCount);
                    }
                }
                
                System.debug('=====accountTrackersMap======='+accountTrackersMap);
                for(Renewal__c objRenewal : lstRenewals)
                {
                    renewalDate = objRenewal.Renewal_Date__c;
                    Date alertMonthBeforeDate = renewalDate.addDays(-30);
                    Date alertDateforTaskCreate = renewalDate.addDays(-15);
                    isMailSent = false;
                    Workstation__c objWorkstation; 
                    if(!mapFPAndWorkstation.isEmpty() && mapFPAndWorkstation.containsKey(objRenewal.Entity__r.OwnerId))
                    	objWorkstation =mapFPAndWorkstation.get(objRenewal.Entity__r.OwnerId);
                    	  
                    System.debug('======renewalDate=========='+renewalDate);
                    System.debug('======alertMonthBeforeDate=========='+alertMonthBeforeDate);
                    System.debug('======alertDateforTaskCreate=========='+alertDateforTaskCreate);
                    if(alertDateforTaskCreate == todaysDate)
                    {
                    	if(objRenewal.Cheque_Received_Date__c == null)
                    	{
                    		System.debug('======objRenewal=========='+objRenewal);
	                        if(objWorkstation != null)
	                        {
	                        	  System.debug('====TaskCreated==========');
	                            if(objWorkstation.Financial_Planner__c != null)
	                               lstTaskTobeCreate.add(createMultipleTask(objWorkstation.Financial_Planner__c ,objRenewal));
	                            if(objWorkstation.Manager__c != null)
	                                lstTaskTobeCreate.add(createMultipleTask(objWorkstation.Manager__c ,objRenewal));
	                            if(objWorkstation.Member_Engagement__c != null)
	                                lstTaskTobeCreate.add(createMultipleTask(objWorkstation.Member_Engagement__c ,objRenewal));
	                        }
	                       /* Setty:SMS Magic uninstall 19/09/2012
	                        smsmagicvc1.TemplateEngine TEngine = new smsmagicvc1.TemplateEngine(dueTplText);
						    TEngine.getFieldMap(objRenewal);
						    dueTplText = TEngine.getReplacedTextForObject(objRenewal, 0);
						    Setty:End*/
						     
						  //   /* Setty:NewCode
	                        smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(dueTplText);
						    TEngine.getFieldMap(objRenewal);
						    dueTplText = TEngine.getReplacedTextForObject(objRenewal, 0);
						 //   */
						    
							if(objRenewal.Mobile__c != null)
            				{
            					SMS_History__c smsObj = new SMS_History__c();
								smsObj.Mobile_Number__c = objRenewal.Mobile__c;
								smsObj.SMSText__c= dueTplText;
	           					smsObj.SenderId__c = 'Ffreedom';
			            		smsObj.Renewal__c = objRenewal.Id;
			            		smsObj.ObjectType__c = 'Renewal';
			            		lstsmsRecords.add(smsObj);
            				}
	                    }
                    }
                    
                    if(alertMonthBeforeDate == todaysDate)
                    {
                    	lstCCAddress = new List<String>();
                    	if(!accountTrackersMap.isEmpty() && accountTrackersMap.containsKey(objRenewal.Entity__c))
                        {
                        	executionCount = accountTrackersMap.get(objRenewal.Entity__c);
                        }
                        else
                        {
                        	executionCount  = 0;
                        } 
                       	if(!mapFPAndWorkstation.isEmpty() && mapFPAndWorkstation.containsKey(objRenewal.Entity__r.OwnerId))
                        {
                            objWorkstation = mapFPAndWorkstation.get(objRenewal.Entity__r.OwnerId);
                            if(objWorkstation != null)
                            {
                                if(objWorkstation.Financial_Planner__r.Email != null)
                                  lstCCAddress.add(objWorkstation.Financial_Planner__r.Email);
                                if(objWorkstation.Manager__r.Email != null)
                                  lstCCAddress.add(objWorkstation.Manager__r.Email );
                                if(objWorkstation.Member_Engagement__r.Email != null)
                                  lstCCAddress.add(objWorkstation.Member_Engagement__r.Email);
                            }
                        }
                         if(executionCount > 0)
                        {
                            if(lstCCAddress != null && emailTemplateWithoneExecution != null && lstCCAddress.size() > 0)
                            {
                                isMailSent = sendEmailFunctionality(lstCCAddress,emailTemplateWithoneExecution.Id,objRenewal.Entity__r.PersonContactId);
                            }
                        }
                        else
                        {
                            if(lstCCAddress != null && emailTemplateNoExecution != null  && lstCCAddress.size() > 0)
                            {
                                isMailSent = sendEmailFunctionality(lstCCAddress,emailTemplateNoExecution.Id,objRenewal.Entity__r.PersonContactId);
                            }
                        }
                    }
                }
            }
            if(lstTaskTobeCreate != null && lstTaskTobeCreate.size() > 0 )
            {
            	System.debug('lstTaskTobeCreate========'+lstTaskTobeCreate);
                Database.DMLOptions dmloptions = new Database.DMLOptions();
 				dmloptions.EmailHeader.triggerUserEmail = true;
                List<Database.Saveresult>  lstSaveResult = Database.insert(lstTaskTobeCreate,dmloptions);
            }
            
         	if(lstsmsRecords != null && lstsmsRecords.size() > 0)
            	insert lstsmsRecords;
        }
        catch(Exception ex)
        {
            System.debug('====Exception====='+ex);
        }
    }
   
    global void finish(Database.BatchableContext BC)
    {
    	AsyncApexJob apexJob = new AsyncApexJob();
    	if(!test.isRunningTest())
    	{
        	apexJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems 
                                 from AsyncApexJob where Id =:BC.getJobId()];
    	}
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'tech@ffreedom.in'};
        //String[] toCCAddresses = new String[] {'tech@ffreedom.in'};
        mail.setToAddresses(toAddresses);
        //mail.setCcAddresses(toCCAddresses);
      	
    	mail.setSubject('Renewal Process job proccessed:' + apexJob.Status);
    	mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems +'batches with '+ apexJob.NumberOfErrors + 'failures with Job id'+apexJob.id);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
    }
    
    public Boolean sendEmailFunctionality(List<String> lstCCAddress,ID templateId ,ID personContactId)
    {
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       email.setCcAddresses(lstCCAddress);
       email.setTemplateId(templateId);
       email.setTargetObjectId(personContactId);
       email.setSenderDisplayName('Ffreedom Team');
       email.setSaveAsActivity(true);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
       return true; 
    }
    
    public Task createMultipleTask(ID assignToId ,Renewal__c pRenewal)
    {
        Task objTask = new Task();
        objTask.OwnerId = assignToId;
        objTask.IsReminderSet = true;
        objTask.ReminderDateTime = System.now().addHours(5);
        objTask.Subject_Category__c = 'Follow up';
        objTask.WhatId = pRenewal.Entity__c;
        objTask.ActivityDate = todaysDate;
        objTask.Subject ='Please follow up with the '+pRenewal.Entity_Name__c  +' for Renewal';
        objTask.Description = 'Please follow up with this Entity for Renewal. The due date for the same is the "Renewal Date" mentioned on the Entity page.';
        objTask.Priority ='High';
        objTask.Status='Planned';
        return objTask;  
    }
}