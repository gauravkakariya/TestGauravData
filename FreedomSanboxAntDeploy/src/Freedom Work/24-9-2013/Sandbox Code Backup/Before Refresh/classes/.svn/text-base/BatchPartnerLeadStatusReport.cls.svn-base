global class BatchPartnerLeadStatusReport implements Database.Batchable<sObject>
{
	/*
		@MethodName: start 
		@param : Database.BatchableContext BC
		@Description: It is overriden method of  Database.Batchable interface.
	*/
	Map<Id, User> mapIdToUser = new Map<Id, User>([Select Id, Name from User]);
	public String strDate {get;set;}
	
    global Database.QueryLocator start(Database.BatchableContext BC) 
    { 
    	return Database.getQueryLocator('Select Name, Email, UserType, Profile.Name, ProfileId, Manager.Email, Manager.Name, ManagerId, Id From User where Profile.Name=\'Gold Partner\' and IsActive=true');    																				
    }
    
    /*
		@MethodName: execute 
		@param : Database.BatchableContext BC, List<sObject> scope
		@Description: It is overriden method of  Database.Batchable interface.
	*/
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
    	User objUser = (User)scope[0];
    	
    	
    	//--*************************************************************************************************************************
    	Map<Id, CampaignMember> mapContactIdToCampaignMember = new Map<Id, CampaignMember>();
    	Map<Id, Account> mapContactIdToEntity = new Map<Id, Account>();
    	
    	List<CampaignMember> lstCampaignMember = [Select Contact.OwnerId, Contact.Name, ContactId , Campaign.Name, Campaign.CreatedDate
    												From CampaignMember 
    												where Contact.OwnerId =: objUser.Id ];
    	system.debug('===========lstCampaignMember========='+lstCampaignMember);
    	
    	for(CampaignMember objCampaignMember : lstCampaignMember)
    	{
    		mapContactIdToCampaignMember.put(objCampaignMember.ContactId, objCampaignMember);
    	}
    	
    	for(Account objEntity : [Select Related_To__c, PersonContactId, Name, Entity_Status__c, Entity_Stage__c,Created_date_Month__c
    							From Account   
    							where PersonContactId IN: mapContactIdToCampaignMember.keySet()])
    	{
    		mapContactIdToEntity.put(objEntity.PersonContactId, objEntity);
    	}
    	//*************************************************************************************************************************
    	
    	List<CampaignMember> lstLeadCampaignMember = [Select Lead.Related_To__c, Lead.IsConverted, Lead.OwnerId, Lead.Status, Lead.Created_date_Month__c,
    														Lead.Lead_Owner_Name__c, Lead.Name, LeadId, Campaign.Name, Campaign.OwnerId 
    												From CampaignMember 
													where Lead.Related_To__c='Business Partner' and Lead.IsConverted=false and Lead.OwnerId =: objUser.Id ];
		
		
													
		system.debug('===========lstLeadCampaignMember========='+lstLeadCampaignMember);
		if((lstLeadCampaignMember != null && lstLeadCampaignMember.size() > 0) || mapContactIdToEntity.keySet().size() > 0)
		{
			Datetime dtReport = System.today();
			strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
			//create html String for sending information 
			String strHtmlBodyLead ='<html> <body> <b>Report Date</b>: ' + strDate + '<br/> <b>Partner Name</b>: ' +  objUser.Name + '<br/> <b>FPPM Name</b>: ' + objUser.Manager.Name + '<br/><br/>' +
								'<table border="1" cellspacing="0"><tr bgcolor="#E6E6E7"><th>Sr. No.</th> <th>Lead Creation <br/> Month-Year</th><th> Lead Name </th> <th> Lead Status </th> <th> Campaign Name </th> <th> Campaign Owner </th> </tr>' ;
			Integer counter = 1;
			Integer entityCounter = 1;
			for(CampaignMember objCM : lstLeadCampaignMember)
			{
				strHtmlBodyLead += '<tr> <td>' +  counter + '</td> <td>' +  objCM.Lead.Created_date_Month__c + '</td>  <td>' +  objCM.Lead.Name + 
								'</td> <td>' + objCM.Lead.Status + '</td> <td>' + objCM.Campaign.Name + 
								'</td> <td>' + mapIdToUser.get(objCM.Campaign.OwnerId).Name +'</td> </tr>';
				counter++;
			}
			//strHtmlBodyLead += '<table> <br/>Thank you <br/><br/></body></html>';
			strHtmlBodyLead += '<table> <br/></body></html>';
			
			//*************************************************************************************************************************
			//create html String for sending information
			//'<html> <body> <b>Partner</b>: ' +  objUser.Name + '<br/> <b>Manager</b>: ' + objUser.Manager.Name + 
			String strHtmlBody = '<br/><table border="1" cellspacing="0"><tr bgcolor="#E6E6E7"><th>Sr. No.</th> <th>Entity Creation <br/> Month-Year</th> <th> Entity Name </th> <th> Entity Stage </th></tr>' ;
			for(Id contactId : mapContactIdToEntity.keySet())
			{
				strHtmlBody += '<tr> <td>' +  entityCounter + '</td><td>' 
											+  mapContactIdToEntity.get(contactId).Created_date_Month__c + '</td> <td>' 
											+  mapContactIdToEntity.get(contactId).Name + '</td> <td>' 
											+ mapContactIdToEntity.get(contactId).Entity_Stage__c + '</td> </tr>';//Created_date_Month__c
				entityCounter++;
			}
			strHtmlBody += '<table> <br/>Thank you </body></html>';
			//*************************************************************************************************************************
			 
			strHtmlBodyLead += strHtmlBody;
			//create an object of SingleEmailMessage 	 
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        
	        //create an array of  email addresses
	        String[] toAddresses = new String[] {objUser.Email};
	        String[] ccAddresses = new String[] {objUser.Manager.Email};
	        
	        //set array of email addresses 
	        mail.setToAddresses(toAddresses); 
	        mail.setCcAddresses(ccAddresses);
	        
	        //set Subject name 
	        mail.setSubject('Year To Date Report of Leads and Entities'); 
	        mail.setUseSignature(false);
	        //set email body 
	        mail.setHtmlBody(strHtmlBodyLead);
	        //mail.setHtmlBody();
	        
	       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
    }
    
    /*
		@MethodName: finish 
		@param : Database.BatchableContext BC
		@Description: It is overriden method of  Database.Batchable interface.
	*/
    global void finish(Database.BatchableContext BC)
    {
    	
    }
}