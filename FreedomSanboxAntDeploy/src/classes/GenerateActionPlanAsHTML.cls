/*
  Revision History:
    Version     Version Author    Date          Comments
  2.0      Aditi Satpute     05/07/2012    Issue ID:00001706 : Change in Function Save() :
                                              To Update the PlanGenerationDateFromSystem date when Fp saves the PDF
  2.0      Prajakta Sanap    30/07/2012  Issue Id: 00001724 : Change in Function SendEmail() :
                        New Task is created in the activity history when send button is clicked in Generate Action Plan
  2.0      Prajakta Sanap    07/08/2012  Added toCcAddress and toBccAddress in the SendEmail Function 

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
    public string owner{get;set;}      //Prajakta
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
       if(objUser.Profile.Name == 'Financial Planner(Limited Access)' || objUser.Profile.Name == 'System Administrator')//Financial Planner(Limited Access)    System Administrator
         isFPLimitedAccess = true;
      objAccount = [Select Id, Name, PersonEmail, Email_Temp__c,FPA_Team_Member__c,FPA_Team_Member__r.Name, OwnerId, owner.name from Account where Id =: entity];
      system.debug('--- 1objAccount --->' + objAccount);
      
      User owner = [Select Id, ContactId From User where Id =: objAccount.OwnerId];
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
      AttachmentPlan = Page.GeneratePlanInHtml; //Page name
          AttachmentPlan.getParameters().put('entityId',entity);
          AttachmentPlan.getParameters().put('isPDF', 'true');
          AttachmentPlan.getParameters().put('displayButtons','0');
          AttachmentPlan.getParameters().put('isSendEmail','true');
          
          /*Prajakta - Date change 
          Date dtLoginTime = objSelectedAcc.Plan_Generation_Date__c;
      String strDate =  dtLoginTime.day() + '-' + dtLoginTime.month() + '-' + dtLoginTime.year();
      System.debug('---------------------strDate-------------------------------'+strDate);
      String strPlanName = 'Plan_' + strEntityName + '_'+ strDate;*/
      String strPlanName = 'Plan_' + strEntityName + '_'+ system.NOW().format('dd-MM-yyyy hh:mm:ss');
      pdfBody = !Test.isRunningTest() ? AttachmentPlan.getContentAsPDF() : Blob.ValueOf('dummy text'); //get content in pdf format
      
      /* Attach content as pdf file*/  
      PlanAttachment = new Attachment();
      if(objRelatedAttachment != null)
      PlanAttachment.ParentId = objRelatedAttachment.Id;
           PlanAttachment.Name = strPlanName + '.pdf';  //Name format of the PDF: Plan_EntityName_Date.pdf  
      PlanAttachment.Body = pdfBody;
      PlanAttachment.ContentType = '';
      insert PlanAttachment;
      
      PageReference pr = Page.GeneratePlanInHtml; //Page name
          pr.getParameters().put('entityId',entity);
          pr.getParameters().put('isPDF', 'false');
          pr.getParameters().put('displayButtons','2');
          pr.getParameters().put('attachmentId',PlanAttachment.Id);
          
          htmlBody = !Test.isRunningTest() ? pr.getContent() : Blob.ValueOf('dummy text'); //get content in html format
          

      /* Attach content as html file*/      
      PlanAttachment = new Attachment();
      if(objRelatedAttachment != null)
          PlanAttachment.ParentId = objRelatedAttachment.Id;
      PlanAttachment.Name = strPlanName + '.htm';  //Name format of the HTML: Plan_EntityName_Date.htm  
      PlanAttachment.Body = htmlBody;
      PlanAttachment.ContentType = '';
      insert PlanAttachment;
      /** Eternus Solutions   **/
      /** Author  : Aditi Satpute **/
      /** Issue Id: 00001706        **/
      /** Date    : 05/07/2012   **/
      /** Purpose : Update the PlanGenerationDateFromSystem date when Fp saves the PDF.
      /****************************************************/
      if(objSelectedAcc != null)
      {
      	objSelectedAcc.isFPGenerated__c = true;
        //objSelectedAcc.PlanGenerationDateFromSystem__c = objSelectedAcc.Plan_Generation_Date__c;/*Praj*/
        //Added on 11/10/13 : Aditi Satpute : Store Financial Plan Generation date
        objSelectedAcc.FinancialPlanGenerationDate__c = Date.today();
        system.debug('-----objSelectedAcc.FinancialPlanGenerationDate__c-----'+objSelectedAcc.FinancialPlanGenerationDate__c);
           update objSelectedAcc;     
      }
    }
    
    catch(System.Exception e)
    {
      	error.DebugLog('==Error=='+e.getMessage());
    }
    pageReference pageRef = new pageReference('/apex/GenerateHtml?entityId='+entity+'&tabname=Financial+Planning');
	pageRef.setRedirect(true);
	return pageRef;
    //  return null;
  }
  

  /** Purpose : Created Function and added FistName and LastName in the select statement. **/
  public Account selectAccount()
  {
    Account objSelectedAcc = [select id,PlanGenerationDateFromSystem__c,FinancialPlanGenerationDate__c,Plan_Generation_Date__c,LastName,FirstName from Account where Id =: entity];
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
    try
    {
      	PageReference AttachmentPlan;
      	Blob pdfBody;
      	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
      	AttachmentPlan = Page.GeneratePlanInHtml; //Page name
      
        AttachmentPlan.getParameters().put('entityId',entity);
        AttachmentPlan.getParameters().put('displayButtons','0');
      	AttachmentPlan.getParameters().put('isSendEmail','true');
      	pdfBody = !Test.isRunningTest() ? AttachmentPlan.getContentAsPDF() : Blob.ValueOf('dummy text') ;
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
        
      	//email.setSenderDisplayName(objAccount.Owner.Name);
      	if(objAccount.FPA_Team_Member__c != null)
      		email.setSenderDisplayName(objAccount.FPA_Team_Member__r.Name);
      	else
      		email.setSenderDisplayName(UserInfo.getName());
      	email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
          // Sends the email 
          
      	/** Eternus Solutions  **/
      	/** Author  : Prajakta Sanap  **/
      	/** Issue Id: 00001724   **/
      	/** Date    : 30/07/2012   **/
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
    pdfBody = !Test.isRunningTest() ? AttachmentPlan.getContentAsPDF() : Blob.ValueOf('dummy text');
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
  
  /* @isTest
   public static void testGenerateActionPlanAsHtml()
   {
   		TestData_Ffreedom testData = new TestData_Ffreedom();
		
    	Account objacc = testData.initializeAccount();
		insert objacc;
        Test.StartTest();
        Apexpages.currentPage().getParameters().put('entityId',objacc.Id);
        GenerateActionPlanAsHTML Gplan= new GenerateActionPlanAsHTML();
        //Test.setCurrentPageReference(Page.GeneratePlanInHtml);
        Gplan.Save();
        Gplan.sendEmail();
        Gplan.selectAccount();
        
        Gplan.sendEmail();
        Pagereference obj1 = Gplan.selectEmailIdToSendEmail();
        Pagereference obj2 = Gplan.sendEmailToOwner();
        
        Test.stopTest();
   }*/
}