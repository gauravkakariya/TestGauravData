/*
	Revision History:
    Version     Version Author    Date          Comments
	2.0			Aditi Satpute     05/07/2012    Issue ID:00001706 : Change in Function Save() :
	                                            To Update the PlanGenerationDateFromSystem date when Fp saves the PDF
	2.0			Prajakta Sanap	  30/07/2012	Issue Id: 00001724 : Change in Function SendEmail() :
												New Task is created in the activity history when send button is clicked in Generate Action Plan
	2.0			Prajakta Sanap	  07/08/2012	Added toCcAddress and toBccAddress in the SendEmail Function 

*/
public with sharing class GenerateActionPlanAsHTML 
{
	/*
  		@Description: GenerateActionPlanAsHTML is a class to generate html file
 	*/
	  
	DatabaseSOQL dbQuery;
    Integer currentYear;    
    public Account objAccount{get;set;}
	   
    public string entity{get;set;}
    public string owner{get;set;}			//Prajakta
    public String emailBody {get; set;}
    public boolean isFPLimitedAccess{get;set;}// mahesh
    private DateTime startDate;
    
    //Added on:24-May-2013 : Kiran : FP changes part2 - issue 21
    public String ownerEmailId {get; set;}
    public String sentEmailMsg {get; set;}
    public boolean isSendEmailToOwner{get;set;}
    public boolean isBusinessPartner{get;set;}
    public boolean isSentEmail{get;set;}
    
    public GenerateActionPlanAsHTML()
    {
    	dbQuery = new DatabaseSOQL();
    	
    	isFPLimitedAccess = false;
     	entity=System.currentPageReference().getParameters().get('entityId');
     	User objUser = [Select Profile.Name, ProfileId, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
     	if(objUser.Profile.Name == 'Financial Planner(Limited Access)' || objUser.Profile.Name == 'System Administrator')//Financial Planner(Limited Access)		System Administrator
     		isFPLimitedAccess = true;
     	User owner = new User();
 		if(entity != null)
 		{
	    	objAccount = [Select Id, Name, PersonEmail, Email_Temp__c, OwnerId, owner.name from Account where Id =: entity];
	    	owner = [Select Id, ContactId From User where Id =: objAccount.OwnerId];
 		}
	    else
	    	objAccount = new Account();
	    	
	    system.debug('--- 1objAccount --->' + objAccount);
	    
	   
	    if(owner.ContactId != null)
	    	isBusinessPartner = false;
	    else
	    	isBusinessPartner = true;
	    
	    isSendEmailToOwner = false;
	    system.debug('--- 1isSendEmailToOwner --->' + isSendEmailToOwner);
	    isSentEmail = false;
    }
   
   /**
    * @Description: Generate() method to display html file links
    * Return type: pageReference 
    */
    /*public pageReference Generate()
    {
		pageReference pr;
		//Send entity id to GeneratePlanInHtml page
        pr=new pageReference('/apex/GeneratePlanInHtml?entityId='+ entity +'&tabname=Financial+Planning&displayButtons=1');
        return pr;
    }*/
    
    
	public Map<String,Attachment>  getAttachmentMap(String idEntityRelatedAttachment)
	{
		Map<String,Attachment> MapofIdToAttachment = new Map<String,Attachment>();
		for(Attachment objAttachment :[select Id,ParentId,Name from Attachment where ParentId = : idEntityRelatedAttachment and Name like 'Plan_%' order by CreatedDate desc limit 2])
		{
			if(objAttachment.Name.contains('pdf'))
				MapofIdToAttachment.put(objAttachment.ParentId+':pdf',objAttachment); 
			else
				MapofIdToAttachment.put(objAttachment.ParentId+':htm',objAttachment); 
		}
		return MapofIdToAttachment; 
	}
    
  
	/** Purpose : While generating Execution Tracker for given entity, save his Approved plan and his html and pdf as an attachment. **/
	public Pagereference Save()
	{
		Blob htmlBody;
		Blob pdfBody;
		//String strContent;
        PageReference AttachmentPlan;
        Attachment PlanAttachment;
        Account objSelectedAcc;
        String strEntityName;
        String strRelatedId;
        EntityRelatedAttachment__c objRelatedAttachment;
        
        
        if(entity != null)
     	{	
     		objSelectedAcc = selectAccount();
     		Map<ID,EntityRelatedAttachment__c> MapofIdRelatedAttachment  = getRelatedAttachmentMap(entity);
     		if(!MapofIdRelatedAttachment.isEmpty() && MapofIdRelatedAttachment.containsKey(entity))
     			objRelatedAttachment =  MapofIdRelatedAttachment.get(entity);
     		strEntityName = objSelectedAcc.FirstName; 
     		if(objSelectedAcc.LastName != null)
     			strEntityName  +=  '_' + objSelectedAcc.LastName;
     	}
		try
		{
			
			/*Prajakta - Date change 
   		 	Date dtLoginTime = objSelectedAcc.Plan_Generation_Date__c;
			String strDate =  dtLoginTime.day() + '-' + dtLoginTime.month() + '-' + dtLoginTime.year();
			System.debug('---------------------strDate-------------------------------'+strDate);
			String strPlanName = 'Plan_' + strEntityName + '_'+ strDate;*/
			String strPlanName = 'Plan_' + strEntityName + '_'+ system.NOW().format('dd-MM-yyyy hh:mm:ss');
			/*
				Updated By : Aditi Satpute
				Date : 3/7/13
				Purpose : Whenever Financial Plan is Saved.Related Attachments should be overriden.
			*/
			
			Map<String,Attachment> MapofIdToAttachment  = getAttachmentMap(objRelatedAttachment.Id);
			//&& MapofIdToAttachment.get(objRelatedAttachment.Id).Name.contains('pdf')
     		if(!MapofIdToAttachment.isEmpty())
     		{
     			/* Attach content as pdf file*/	
     			if(MapofIdToAttachment.containsKey(objRelatedAttachment.Id+':pdf') && MapofIdToAttachment.get(objRelatedAttachment.Id+':pdf').Name.contains('pdf'))
     			{
     				AttachmentPlan = Page.GeneratePlanInHtml; //Page name
		   		 	AttachmentPlan.getParameters().put('entityId',entity);
		   		 	AttachmentPlan.getParameters().put('isPDF', 'true');
		   		 	AttachmentPlan.getParameters().put('displayButtons','0');
		   		 	AttachmentPlan.getParameters().put('isSendEmail','true');
		   		 	
					pdfBody = AttachmentPlan.getContentAsPDF(); //get content in pdf format
	 				PlanAttachment =  MapofIdToAttachment.get(objRelatedAttachment.Id+':pdf');
	     			PlanAttachment.Name = strPlanName + '.pdf';	//Name format of the PDF: Plan_EntityName_Date.pdf  
					PlanAttachment.Body = pdfBody;
					PlanAttachment.ContentType = '';
					update PlanAttachment;
					//error.debugLog('--------PlanAttachment---pdf-if------'+PlanAttachment);
     			}
     			if(MapofIdToAttachment.containsKey(objRelatedAttachment.Id+':htm') && MapofIdToAttachment.get(objRelatedAttachment.Id+':htm').Name.contains('htm'))
     			{
     				PageReference pr = Page.GeneratePlanInHtml; //Page name
		   		 	pr.getParameters().put('entityId',entity);
		   		 	pr.getParameters().put('isPDF', 'false');
		   		 	pr.getParameters().put('displayButtons','2');
		   		 	
		   		 	
		   		 	htmlBody = pr.getContent(); //get content in html format
		   		 	
     				//system.debug('*******in if**htm**********');
	 				PlanAttachment =  MapofIdToAttachment.get(objRelatedAttachment.Id+':htm');
	 				pr.getParameters().put('attachmentId',PlanAttachment.Id);
	     			PlanAttachment.Name = strPlanName + '.htm';	//Name format of the PDF: Plan_EntityName_Date.pdf  
					PlanAttachment.Body = htmlBody;
					PlanAttachment.ContentType = '';
					update PlanAttachment;
					//error.debugLog('--------PlanAttachment---htm-if------'+PlanAttachment);
     			}
     		}
			else
			{
				//system.debug('*******in else************');
				PlanAttachment = new Attachment();
 				AttachmentPlan = Page.GeneratePlanInHtml; //Page name
	   		 	AttachmentPlan.getParameters().put('entityId',entity);
	   		 	AttachmentPlan.getParameters().put('isPDF', 'true');
	   		 	AttachmentPlan.getParameters().put('displayButtons','0');
	   		 	AttachmentPlan.getParameters().put('isSendEmail','true');
				pdfBody = AttachmentPlan.getContentAsPDF(); //get content in pdf format
				
				if(objRelatedAttachment != null)
					PlanAttachment.ParentId = objRelatedAttachment.Id;
				PlanAttachment.Name = strPlanName + '.pdf';	//Name format of the PDF: Plan_EntityName_Date.pdf  
				PlanAttachment.Body = pdfBody;
				PlanAttachment.ContentType = '';
				//error.debugLog('--------PlanAttachment---pdf---else----'+PlanAttachment);
				insert PlanAttachment;
				
				
				PlanAttachment = new Attachment();
				PageReference pr = Page.GeneratePlanInHtml; //Page name
	   		 	pr.getParameters().put('entityId',entity);
	   		 	pr.getParameters().put('isPDF', 'false');
	   		 	pr.getParameters().put('displayButtons','2');
	   		 	pr.getParameters().put('attachmentId',PlanAttachment.Id);
	   		 	
	   		 	htmlBody = pr.getContent(); //get content in html format
	   		 	if(objRelatedAttachment != null)
					PlanAttachment.ParentId = objRelatedAttachment.Id;
				PlanAttachment.Name = strPlanName + '.htm';	//Name format of the HTML: Plan_EntityName_Date.htm  
				PlanAttachment.Body = htmlBody;
				PlanAttachment.ContentType = '';
				//error.debugLog('--------PlanAttachment---htm---else----'+PlanAttachment);
				insert PlanAttachment;
			}
			
			
			/* Attach content as html file*/			
		/*	PlanAttachment = new Attachment();
			if((!MapofIdToAttachment.isEmpty() && MapofIdToAttachment.containsKey(objRelatedAttachment.Id)) && MapofIdToAttachment.get(objRelatedAttachment.Id).Name.contains('htm'))
     		{
     			system.debug('*******in if**htm**********');
 				PlanAttachment =  MapofIdToAttachment.get(objRelatedAttachment.Id);
     			PlanAttachment.Name = strPlanName + '.htm';	//Name format of the PDF: Plan_EntityName_Date.pdf  
				PlanAttachment.Body = htmlBody;
				PlanAttachment.ContentType = '';
				update PlanAttachment;
				error.debugLog('--------PlanAttachment---htm-if------'+PlanAttachment);
     		}
			else
			{
				system.debug('*******in else*****htm*******');
				if(objRelatedAttachment != null)
					PlanAttachment.ParentId = objRelatedAttachment.Id;
				PlanAttachment.Name = strPlanName + '.htm';	//Name format of the HTML: Plan_EntityName_Date.htm  
				PlanAttachment.Body = htmlBody;
				PlanAttachment.ContentType = '';
				error.debugLog('--------PlanAttachment---htm---else----'+PlanAttachment);
				insert PlanAttachment;
			}
			*/
		/*	if(objRelatedAttachment != null)
	      	PlanAttachment.ParentId = objRelatedAttachment.Id;
			PlanAttachment.Name = strPlanName + '.htm';	//Name format of the HTML: Plan_EntityName_Date.htm  
			PlanAttachment.Body = htmlBody;
			PlanAttachment.ContentType = '';
			error.debugLog('--------PlanAttachment-htm---------'+PlanAttachment);
			insert PlanAttachment;*/
			/** Eternus Solutions   **/
			/** Author  : Aditi Satpute **/
			/** Issue Id: 00001706      	**/
			/** Date    : 05/07/2012 	**/
			/** Purpose : Update the PlanGenerationDateFromSystem date when Fp saves the PDF.
			/****************************************************/
			if(objSelectedAcc != null)
			{
				objSelectedAcc.PlanGenerationDateFromSystem__c = objSelectedAcc.Plan_Generation_Date__c;/*Praj*/
				system.debug('-----objSelectedAcc.PlanGenerationDateFromSystem__c-----'+objSelectedAcc.PlanGenerationDateFromSystem__c);
	     		update objSelectedAcc;	   
			}
		}
		
		catch(System.Exception e)
		{
			error.DebugLog('==Error=='+e.getMessage());
        }
    	return null;
	}
	

	/** Purpose : Created Function and added FistName and LastName in the select statement. **/
	public Account selectAccount()
	{
		Account objSelectedAcc = [select id,PlanGenerationDateFromSystem__c,Plan_Generation_Date__c,LastName,FirstName from Account where Id =: entity];
		return objSelectedAcc;
	}
	
	public Map<ID,EntityRelatedAttachment__c>  getRelatedAttachmentMap(String idEntity)
	{
		Map<ID,EntityRelatedAttachment__c> MapofIdRelatedAttachment = new Map<ID,EntityRelatedAttachment__c>();
		for(EntityRelatedAttachment__c objRelatedAttachment :[select Id,Related_Entity__c from EntityRelatedAttachment__c where Related_Entity__c = : idEntity])
		{
			MapofIdRelatedAttachment.put(objRelatedAttachment.Related_Entity__c,objRelatedAttachment); 
		}
		return MapofIdRelatedAttachment; 
	}
	
	public Pagereference sendEmail()
	{
			//pageReference pageRef = new pageReference('/apex/GeneratePlanInHtml?entityId='+entity+'&tabname=Financial+Planning&isSendEmail=true&displayButtons');
			//return pageRef;
		try{
			PageReference AttachmentPlan;
			Blob pdfBody;
			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
			AttachmentPlan = Page.GeneratePlanInHtml; //Page name
			
   		 	AttachmentPlan.getParameters().put('entityId',entity);
   		 	AttachmentPlan.getParameters().put('displayButtons','0');
			AttachmentPlan.getParameters().put('isSendEmail','true');
			pdfBody = AttachmentPlan.getContentAsPDF();
			efa.setFileName('Plan_'+system.NOW().format('dd-MM-yyyy hh:mm:ss')+'.pdf');
         	efa.setBody(pdfBody);
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	        // Create the email attachment 
	       
	        List<String> toAddresses = new List<String>();
	        //toAddresses.add('');
	        //00001598 Add sender display name as entity owner
	        // Sets the paramaters of the email
	         if(objAccount.PersonEmail != null)
	        	toAddresses.add(objAccount.PersonEmail);
	         else
	         	toAddresses.add(objAccount.Email_Temp__c);
	        System.debug('toAddresses===='+toAddresses); 
	        
	        //For toCcAddresses
	        List<String> toCcAddresses = new List<String>();
	        /*commented Bcc as per client requirement By Aditi Satpute : Date : 24/12/12
	        List<String> toBccAddresses = new List<String>();*/
			Contact con;
			Account acc;
			String ppEmail;
				/*commented Bcc as per client requirement By Aditi Satpute : Date : 24/12/12
			String BccEmail;*/
	        Id AccOwnerId = objAccount.OwnerId;
	        User user=[select Id,Email,Name,ProfileId,ContactId,Profile.Name from User where Id=:AccOwnerId];
	        if(user.ContactId != null)
		    {
			    con = [select AccountId from Contact where id =: user.ContactId];
			    acc = [select Id, Channel_Manager__r.Email, Name from account where id =: con.AccountId];
			    	/*commented Bcc as per client requirement By Aditi Satpute : Date : 24/12/12
			    BccEmail = acc.Channel_Manager__r.Email;
				System.debug('===BccEmail===='+BccEmail);	
				 if(BccEmail != null)
	        	toBccAddresses.add(BccEmail);
	        	email.setBccAddresses ( toBccAddresses );*/
	        	ppEmail = user.Email;
	        	if(ppEmail != null)
	        	toCcAddresses.add(ppEmail);
	        	email.setCcAddresses( toCcAddresses);
	        	
		    }
		   
		    //User user=[select Id, Name, Email from User where Id=:AccOwnerId];
		   
	        
	         
	        //String[] toBccAddresses = new String[] {'aditi.satpute@eternussolutions.com'};
	        email.setSubject( 'Plan for ' + objAccount.Name);		
	        email.setToAddresses( toAddresses );
	      
	       
	        if(emailBody != null && emailBody != '')
	        	email.setHtmlBody(emailBody.replaceAll('\n','<br/>'));
			else
				email.setHtmlBody('Dear '+objAccount.Name+'<br/><br/>Kindly find the attached pdf.');
			email.setSenderDisplayName(objAccount.Owner.Name);
       		email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
	        // Sends the email 
	        
			/** Eternus Solutions  **/
			/** Author  : Prajakta Sanap	**/
			/** Issue Id: 00001724 	**/
			/** Date    : 30/07/2012 	**/
			/** Purpose : New Task is created in the activity history when send button is clicked in Generate Action Plan**/
			/****************************************************/      
	        Task objTask = new Task(OwnerId = objAccount.OwnerId, Status = 'Completed', Subject = Label.NewEmailTaskSubject + ' ' + objAccount.Name, Priority = 'Normal',
						   Description = Label.EmailDescription1 +' '+ objAccount.Name +' '+ Label.EmailDescription2, WhatId = objAccount.Id);
						   
			Database.Saveresult lstSaveResult = Database.insert(objTask);
	        System.debug('==== lstSaveResult : == ' + lstSaveResult);
	
            Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	        //strMessage = 'Mail has been send successfully!!';
		}
		
		catch(Exception e)
		{
			//strMessage = e.getMessage();
		}
		return null;
	}
	
	/*
	  Updated By : Kiran Patil
	  Updated At : 24-May-2013
	  Summary    : FP changes-part2 - issue 21 
	*/
	public Pagereference selectEmailIdToSendEmail()
	{
		Id AccOwnerId = objAccount.OwnerId;
        User user = [
              select Id
                   , Email
                   , Name
                   , ProfileId
                   , ContactId
                   , Profile.Name
                from User
               where Id =: AccOwnerId
        ];
        ownerEmailId = user.Email;
        isSendEmailToOwner = true;
	    system.debug('--- 2isSendEmailToOwner --->' + isSendEmailToOwner);
		return null;
	}
	
	/*
	  Updated By : Kiran Patil
	  Updated At : 24-May-2013
	  Summary    : FP changes-part2 - issue 21 
	*/
	public Pagereference sendEmailToOwner()
	{
		PageReference AttachmentPlan;
		Blob pdfBody;
		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		AttachmentPlan = Page.GeneratePlanInHtml;
			
	 	AttachmentPlan.getParameters().put('entityId',entity);
	 	AttachmentPlan.getParameters().put('displayButtons','0');
		AttachmentPlan.getParameters().put('isSendEmail','true');
		pdfBody = AttachmentPlan.getContentAsPDF();
		efa.setFileName('Plan_'+system.NOW().format('dd-MM-yyyy hh:mm:ss')+'.pdf');
       	efa.setBody(pdfBody);
		
        List<String> toAddresses = new List<String>();
        toAddresses = ownerEmailId.split(';');
	        
        // Create the email attachment 
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject( 'Plan for ' + objAccount.Name);		
        email.setToAddresses( toAddresses );
			
        if(emailBody != null && emailBody != '')
        	email.setHtmlBody(emailBody.replaceAll('\n','<br/>'));
		else
			email.setHtmlBody('Dear '+objAccount.Name+'<br/><br/>Kindly find the attached pdf.');
		email.setSenderDisplayName(objAccount.Owner.Name);
   		email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        // Sends the email
        Messaging.SendEmailResult[] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        Boolean isSuccessful = true;
        for(Messaging.SendEmailResult res : arrResult) {
    		if(res.isSuccess() == false)
    			isSuccessful = false;
    	}
        
        if(isSuccessful == true) {
        	isSentEmail = true;
        	sentEmailMsg = ownerEmailId.replaceAll(';', ',');
        }
        
        isSendEmailToOwner = false;
	    system.debug('--- 3isSendEmailToOwner --->' + isSendEmailToOwner);
		return null;
	}
}