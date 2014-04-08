global class BatchPartnerEntityStatusReport implements Database.Batchable<sObject>
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
    	//return Database.getQueryLocator('Select Name, Email, UserType, Profile.Name, ProfileId, Manager.Email, Manager.Name, ManagerId, Id From User where Profile.Name=\'Gold Partner\' and IsActive=true');
    	return Database.getQuerylocator('Select Id, Name, Related_To__c, Email_ID__c, RecordTypeId From Account where Related_To__c = \'Virtual Partner\' and RecordTypeId = \'01220000000Do0o\'');//: RecTypes__c.getInstance(\'General_Business\').Record_Type_Value__c');    																				
    }
    
    /*
		@MethodName: execute 
		@param : Database.BatchableContext BC, List<sObject> scope
		@Description: It is overriden method of  Database.Batchable interface.
	*/
    global void execute(Database.BatchableContext BC, List<Account> lstAccount) 
    {
    	Account objAccount = lstAccount[0];
    	Map<Id, List<Lead>> mapAccountToLead = new Map<Id,List<Lead>>();
    	Map<Id, List<Account>> mapVPAccountToAccount = new Map<Id,List<Account>>();
    	String entityStatus = '';
    	Datetime dtReport = System.today();
		strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
    	String strHtmlBodyLead = '<html> <body> <b>Report Date</b>: ' + strDate + '<br/> <b>Partner Name</b> : ' +  objAccount.Name + '<br/>';
    	String strHtmlBody = '';
    	Integer counter = 1;
		Integer entityCounter = 1;
    	
		List<Lead> lstLead = [Select Related_To__c, 
    								Name, Id,
    								Virtual_Partner__c, 
    								Status, 
    								Owner.Name, 
    								LeadSource, 
    								Created_date_Month__c,
    								Virtual_Partner__r.Name
    							//	(Select CampaignId, Name From CampaignMembers limit 1)  
    							From Lead 
    							where Related_To__c = 'Virtual Partner' and Virtual_Partner__c =: objAccount.Id];
		system.debug('=======lstLead=========='+lstLead.size());
		//Map<Id, Campaign> mapIdToCampaign = new Map<Id, Campaign>([Select Id, Name,OwnerId,Owner.Name from Campaign ]);
		List<CampaignMember> lstLeadCampaignMember = [Select Lead.Related_To__c, Lead.IsConverted, Lead.OwnerId, Lead.Status, Lead.Created_date_Month__c,
    														Lead.Lead_Owner_Name__c, Lead.Name, LeadId, Campaign.Name, Campaign.OwnerId 
    												From CampaignMember ];
													//where Lead.Related_To__c='Business Partner' and Lead.IsConverted=false and Lead.OwnerId =: objUser.Id ];
		
		
		Map<Id, CampaignMember> mapLeadToCampaign = new Map<Id,CampaignMember>();
		for(CampaignMember obj : lstLeadCampaignMember)
		{
			if(!mapLeadToCampaign.containsKey(obj.LeadId))
			{
				mapLeadToCampaign.put(obj.LeadId,obj);
			}
		}
		Map<Id,User> mapUser = new Map<Id,User>([select Id, Name from User]);
    	List<Account> lstAcc = [Select Related_To__c, 
    									RecordTypeId, 
    									Name, Id, 
    									Entity_Status__c, 
    									Entity_Stage__c,
    									Virtual_Partner__c, 
    									Created_date_Month__c, 
    									Owner.Name
    								From Account 
    								where Related_To__c = 'Virtual Partner' 
    								and RecordTypeId =: RecTypes__c.getInstance('AccountClient').Record_Type_Value__c and Virtual_Partner__c =: objAccount.Id];
    							
    	User obj = new User();						
    	if(lstLead != null && lstLead.size() > 0)
    	{
			strHtmlBodyLead += '<table border="1" cellspacing="0"><tr bgcolor="#E6E6E7"><th>Sr. No.</th> <th>Lead Creation <br/> Month-Year</th><th> Lead Name </th> <th> Lead Status </th> <th> Campaign Name </th> <th> Campaign Owner </th> </tr>';
							// <th> Lead Source </th> <th> Lead Owner </th> </tr>' ;
			for(Lead objLead : lstLead)
			{
				CampaignMember objCampaign = mapLeadToCampaign.get(objLead.Id);
				if(objCampaign != null)
				{
					obj = mapUser.get(objCampaign.Campaign.OwnerId);
				}	
					strHtmlBodyLead += '<tr><td>' +  counter 
									+ '</td><td>' +  objLead.Created_date_Month__c
									+ '</td><td>' +  objLead.Name
									+ '</td><td>' +  objLead.Status
									+ '</td><td>' +  objCampaign.Campaign.Name
									+ '</td><td>' +  obj.Name + '</td></tr>';
								// <td>' +  objLead.LeadSource +'</td> <td>' + objLead.Owner.Name +'</td> </tr>';mapContactIdToEntity.get(contactId).Name
					counter++;
				
			}
			strHtmlBodyLead += '<table> <br/></body></html>';
    	}
    	
    	if(lstAcc != null && lstAcc.size() > 0)							
    	{
    		strHtmlBody = '<br/><table border="1" cellspacing="0"><tr bgcolor="#E6E6E7"><th>Sr. No.</th> <th>Entity Creation <br/> Month-Year</th> <th> Entity Name </th> <th> Entity Stage </th></tr>' ;
    		for(Account objAcc : lstAcc)
			{
				strHtmlBody += '<tr> <td>' +  entityCounter + '</td><td>' 
											+ objAcc.Created_date_Month__c + '</td> <td>' 
											+ objAcc.Name + '</td> <td>' 
											+ objAcc.Entity_Stage__c + '</td> </tr>';
				entityCounter++;
			}
			strHtmlBody += '<table> <br/>Thank you </body></html>';
    	}
    	
			
		strHtmlBodyLead += strHtmlBody;
    	
    	//create an object of SingleEmailMessage 	 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //create an array of  email addresses
        String[] toAddresses = new String[] {objAccount.Email_ID__c};
        
        //set array of email addresses 
        mail.setToAddresses(toAddresses); 
        
        //set Subject name 
        mail.setSubject('Year To Date Report of Leads and Entities'); 
        mail.setUseSignature(false);
        
        //set email body 
        mail.setHtmlBody(strHtmlBodyLead);
        if(lstLead.size() > 0 || lstAcc.size() > 0 )
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	
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