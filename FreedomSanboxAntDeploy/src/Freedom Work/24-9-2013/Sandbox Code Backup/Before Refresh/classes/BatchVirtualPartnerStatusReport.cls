global class BatchVirtualPartnerStatusReport implements Database.Batchable<sObject>
{
	/*
		@MethodName: start 
		@param : Database.BatchableContext BC
		@Description: It is overriden method of  Database.Batchable interface.
	*/
	public String strDate {get;set;}
	private User objUser{get;set;}
	Map<Id, User> mapIdToUser = new Map<Id, User>();
	public BatchVirtualPartnerStatusReport()
	{
		mapIdToUser = new Map<Id, User>([Select Id, Name, Email from User]);
	}
    global Database.QueryLocator start(Database.BatchableContext BC) 
    { 
    	Id recId = RecTypes__c.getInstance('General_Business').Record_Type_Value__c;
    	system.debug('*****recId*****'+recId);
    	//return Database.getQueryLocator('Select Name, Email, UserType, Profile.Name, ProfileId, Manager.Email, Manager.Name, ManagerId, Id From User where Profile.Name=\'Gold Partner\' and IsActive=true');
    	return Database.getQuerylocator('Select Id, Name, Related_To__c, Email_ID__c, RecordTypeId, Owner.Name, Owner.Email, Owner.ManagerId From Account where Related_To__c = \'Virtual Partner\' and RecordTypeId = \''+recId+'\'');//:     																				
    }
    
    /*
		@MethodName: execute 
		@param : Database.BatchableContext BC, List<sObject> scope
		@Description: It is overriden method of  Database.Batchable interface.
	*/
    global void execute(Database.BatchableContext BC, List<Account> lstAccount) 
    {
    	Account objAccount = lstAccount[0];
    	system.debug('*****objAccount******'+objAccount);
    	Map<Id, List<Lead>> mapAccountToLead = new Map<Id,List<Lead>>();
    	Map<Id, List<Account>> mapVPAccountToAccount = new Map<Id,List<Account>>();
    	String entityStatus = '';
    	Datetime dtReport = Datetime.now();
		strDate = dtReport.format('dd - MMM - yyyy');
		system.debug('*****objAccount.Owner.ManagerId********'+objAccount.Owner.ManagerId);
		if(mapIdToUser.containsKey(objAccount.Owner.ManagerId))
			objUser = mapIdToUser.get(objAccount.Owner.ManagerId);
			
		//strDate = System.now().format();//dtReport.day() + ' ' + dtReport.MONTH() + ' ' + dtReport.year();
    	String strHtmlBodyLead = '<html> <body> <b>Report Date</b>: ' + strDate + '<br/> <b>Partner Name</b> : ' +  objAccount.Name 
    								+ '<br/> <b>FPPM</b> : ' +  objAccount.Owner.Name+'<br/><br/>';
    							//	+'<br/> <b>SBU</b> : ' +  objUser.Name +'<br/><br/>';
    	String strHtmlBody = '';
    	Integer counter = 1;
		Integer entityCounter = 1;
    	Map<Id,Campaign> mapIdToCampaign = new Map<Id,Campaign>([select Id,Name,Owner.Name from Campaign]);
		List<Lead> lstLead = [Select Related_To__c, 
    								Name, Id,
    								Virtual_Partner__c, 
    								Status, 
    								Owner.Name, 
    								LeadSource, 
    								Created_date_Month__c,
    								CreatedDate,
    								Virtual_Partner__r.Name,
    							    (Select CampaignId From CampaignMembers limit 1) campaign 
    							From Lead 
    							where Related_To__c = 'Virtual Partner' and Virtual_Partner__c =: objAccount.Id order by CreatedDate asc];
		List<Account> lstAcc = [Select Related_To__c, 
    									RecordTypeId, 
    									Name, Id, 
    									Entity_Status__c, 
    									Entity_Stage__c,
    									Virtual_Partner__c, 
    									Created_date_Month__c, 
    									CreatedDate,
    									Owner.Name
    								From Account 
    								where Related_To__c = 'Virtual Partner' 
    								and RecordTypeId =: RecTypes__c.getInstance('AccountClient').Record_Type_Value__c 
    								and Virtual_Partner__c =: objAccount.Id order by CreatedDate asc];
		
		if(lstLead != null && lstLead.size() > 0)
    	{
			strHtmlBodyLead += '<table border="1" cellspacing="0" cellpadding="5"><tr bgcolor="#E6E6E7"><th align="center">Sr. No.</th> <th>Lead Creation <br/> Month-Year</th><th> Lead Name </th> <th> Lead Status </th> <th> Campaign Name </th> <th> Campaign Owner </th> </tr>';
			for(Lead objLead : lstLead)
			{
				if(objLead.CampaignMembers.size() > 0)
				{
					if(mapIdToCampaign.containsKey(objLead.CampaignMembers[0].CampaignId))
					{
						Campaign objCampaign = mapIdToCampaign.get(objLead.CampaignMembers[0].CampaignId);
						if(objCampaign != null)
						{
							strHtmlBodyLead += '<tr><td align="center">' +  counter 
									+ '</td><td>' +  objLead.Created_date_Month__c
									+ '</td><td>' +  objLead.Name
									+ '</td><td>' +  objLead.Status
									+ '</td><td>' +  objCampaign.Name
									+ '</td><td>' +  objCampaign.Owner.Name + '</td></tr>';
							counter++;
						}
					}
				}
				else
				{
					strHtmlBodyLead += '<tr><td align="center">' +  counter 
									+ '</td><td>' +  objLead.Created_date_Month__c
									+ '</td><td>' +  objLead.Name
									+ '</td><td>' +  objLead.Status
									+ '</td><td>' +  '-'
									+ '</td><td>' +  '-' + '</td></tr>';
					counter++;
				}
					
				
			}
			strHtmlBodyLead += '<table> <br/></body></html>';
    	}
		if(lstAcc != null && lstAcc.size() > 0)							
    	{
    		strHtmlBody = '<br/><table border="1" cellspacing="0" cellpadding="5"><tr bgcolor="#E6E6E7"><th align="center">Sr. No.</th> <th>Client Creation <br/> Month-Year</th> <th> Client Name </th> <th> Client Stage </th></tr>' ;
    		for(Account objAcc : lstAcc)
			{
				strHtmlBody += '<tr> <td align="center">' +  entityCounter + '</td><td>' 
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
        
        system.debug('***objAccount.Email_ID__c*'+objAccount.Email_ID__c);
        system.debug('***objAccount.Owner.Email*'+objAccount.Owner.Email);
         system.debug('***objUser.Email*'+objUser.Email); 
        
        //create an array of  email addresses
        String[] toAddresses = new String[] {objAccount.Email_ID__c};
        String[] toCcAddresses = new String[] {objAccount.Owner.Email,objUser.Email};
        //set array of email addresses 
        mail.setToAddresses(toAddresses); 
  	  	mail.setCcAddresses(toCcAddresses);
        //set Subject name 
        mail.setSubject('Year To Date Report of Leads and Entities'); 
        mail.setUseSignature(false);
        
        //set email body 
        mail.setHtmlBody(strHtmlBodyLead);
        if(!Test.isRunningTest())
        if((lstLead.size() > 0 ||  lstAcc.size() > 0 ) && toAddresses != null)
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