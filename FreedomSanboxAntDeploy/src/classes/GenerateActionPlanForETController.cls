/*
	
Revision History:

   Version     Version Author     Date          Comments
   
   1.0 		   Manasi Ranade	  18/11/2011	Issue Id : FS0290 :
   												Added Controller for generating Execution Tracker from Approved Action Plan
*/
public with sharing class GenerateActionPlanForETController
{
	private DatabaseSOQL objDBSOQL;
	private String entityId;
	public String email;
	public Boolean blnIsAllowedToCreateET{get; set;} //If ET record is not exist for selected entity then allow to create it.
	public Boolean blnDisplaySucessMsg{get;set;} //Display after sucessfully creating ET Records
	public Boolean blnIsEtAlreadyExist{get;set;} //Display msg if ET for selected entity already Exists
	public Boolean blnIsPlanApproved{get;set;} //Before generating ET ,Check Is Plan is approved or not
	
	private List<Account> lstFamilyMembers;
	private List<Approved_Action_Plan__c> lstApprovedActionPlan;
	private List<Insurance__c> lstGI;
	private List<Insurance__c> lstLI;
	private Account objParentAccount;
	//Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	public void init()
	{
		try
		{
			if(entityId != null )
			{
				blnIsPlanApproved = false;
				lstFamilyMembers = objDBSOQL.getFamilyDetails(entityId);
				lstApprovedActionPlan = objDBSOQL.getAllocatedApprovedPlans(lstFamilyMembers);
				lstGI = objDBSOQL.getApprovedInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, lstFamilyMembers);
				lstLI = objDBSOQL.getApprovedInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, lstFamilyMembers);
				
				if(lstFamilyMembers != null && lstFamilyMembers.size() > 0)
				{
					for(Account objAccount : lstFamilyMembers)
					{
						if(objAccount.Id == entityId)
						{
							objParentAccount = objAccount; 
							if(objAccount.IsExecutionTrackerGenerated__c)
							{
								blnIsAllowedToCreateET = false;
								blnIsEtAlreadyExist = true;
							}
							else
							{
								blnIsAllowedToCreateET = true;
								blnIsEtAlreadyExist = false;
							}
							break;
						}
					}
				}
				if(lstApprovedActionPlan.size() <= 0 && lstGI.size() <= 0 && lstLI.size() <= 0)
				{
					blnIsPlanApproved = true;
					blnIsAllowedToCreateET = false;
					blnIsEtAlreadyExist = false;
				}
				
				
			}
		}
		catch(System.Exception e)
		{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
	}
	public GenerateActionPlanForETController()
	{
		objDBSOQL = new DatabaseSOQL();
		blnDisplaySucessMsg = false;
	    blnIsAllowedToCreateET = true;
	    blnIsEtAlreadyExist = false;
	    blnIsPlanApproved = false;
	    //Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
	   	isDisplaySaveButton = true;
		entityId = Apexpages.currentPage().getParameters().get('entityId');
		objParentAccount = new Account();
		try
		{
			if(entityId != null)
			{
				//Placed this code in Init method
				/*lstFamilyMembers = objDBSOQL.getFamilyDetails(entityId);
				if(lstFamilyMembers != null && lstFamilyMembers.size() > 0)
					for(Account objAccount : lstFamilyMembers)
					{
						if(objAccount.Id == entityId)
						{
							objParentAccount = objAccount; 
							if(objAccount.IsExecutionTrackerGenerated__c)
							{
								blnIsAllowedToCreateET = false;
								blnIsEtAlreadyExist = true;
							}
							else
							{
								blnIsAllowedToCreateET = true;
								blnIsEtAlreadyExist = false;
							}
							break;
						}
					}*/
				//Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
			    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
			    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
			    {
			    	isDisplaySaveButton = false;
			    }	
			}
			
		}
		catch(System.Exception e)
		{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
		
	}
	public void generateAPForET()
	{
		try
		{
			system.debug('())))))))))))00 1');
			Boolean blnIsETGenerated = false,IsPDFAttached = false;
			String strName = '';
			Account objAcc;
			if(entityId != null)
				objAcc = [select FirstName from Account where id =:entityId ];
			if(strName != null)
				strName = objAcc.FirstName;
			if(lstFamilyMembers != null && lstFamilyMembers.size() > 0)
			{
				if((lstApprovedActionPlan != null || lstGI != null || lstLI != null) && blnIsAllowedToCreateET)
				{
					blnIsETGenerated = InsertExecutionTracker();
					if(blnIsETGenerated)
						IsPDFAttached = CreateActionPlanPDF();
					if(IsPDFAttached)
					{
						SendEmailToOwnerAndMemberEngTeam();
						//Create task for the user
						Task tskForUSer = new Task(
				        OwnerId = Label.ETTaskPrafulPanchalID,
				        WhatId = entityId,
			            Subject = 'Action Plan generated for entity:'+ strName,
			            ActivityDate = System.TODAY() + 1
			            );
			            
			            insert tskForUSer; 
					}
				}
			}
		}
		catch(System.Exception e)
		{
			system.debug('!!!!!!!!!! e:generateAPForET:'+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
		//return null;
	}
	/*
		Once the Execution Tracker records are created, a mail should be sent to the Member Engagement team that ‘Action Plan has been generated for
		<Entity Name> <link to the Entity page> and executions can be done. Please look into the related Exection Trackers.’ 
	*/
	/*
		And another mail to the entity owner stating that the ‘Action Plan is being generated and Execution Tracker records are being created 
		for the Member Engagement Team.’
	*/
	private void SendEmailToOwnerAndMemberEngTeam()
	{
		try
		{
			Account objAccount = [select Id,Name,OwnerId,PersonEmail from Account where Id =: entityId];
			User objUser = [select id,Email,Name from User where id =: objAccount.OwnerId];
			String strEntityOwnerName = objUser.Name;
			String strToId,strEmailBody = '',strSubject = '';
			List<Workstation__c> lstWorkStation = [select Member_Engagement__c from Workstation__c where Financial_Planner__c=: objUser.Id];
			strEmailBody =  'Dear '
							+ strEntityOwnerName
							+'\n\n'
							+'Action Plan has been generated for '+ objAccount.Name
							+ ' '
							+  URL.getSalesforceBaseUrl().toExternalForm() +'/'+objAccount.Id
							+' and executions can be done. Please look into the related Exection Trackers.'
							+'\n\n';
			strToId = objUser.Email;
			strSubject = Label.ETSubjectForMET;
			system.debug('!!!!!!Owner NAme:'+strToId);
			if(strToId != null)
				sendEmail(strToId,strEmailBody,strSubject); //To send Email to owner
			//if(lstWorkStation != null && lstWorkStation.Member_Engagement__c != null)
			if(lstWorkStation != null && lstWorkStation.size() > 0 )
			{
				Workstation__c objWorkStation = lstWorkStation[0];
				if(objWorkStation != null && objWorkStation.Member_Engagement__c != null)
				{
					objUser = [select id,Email,Name from User where id =: objWorkStation.Member_Engagement__c];
					if(objUser != null)
					{
						strToId = objUser.Email;
						strSubject = Label.ETSubjectForMET;
						strEmailBody =  'Dear '
										+ objUser.Name
										+'\n\n'
										+'Action Plan has been generated for '+ objAccount.Name
										+ ' '
										+  URL.getSalesforceBaseUrl().toExternalForm() +'/'+objAccount.Id
										+' and executions can be done. Please look into the related Exection Trackers.'
										+'\n\n'
										+ 'Regards,'
										+'\n'
										+ strEntityOwnerName;
										
						if(strToId != null && strToId != '')
							sendEmail(strToId,strEmailBody,strSubject); //To send email to MET
					}
				}
			}
			//Code to send Email to Tech team
			strToId = 'tech@ffreedom.in';
			strSubject = Label.ETSubjectForMET;
			strEmailBody = 'Dear Technology Support'
							+'\n\n'
							+'Action Plan has been generated for '+ objAccount.Name
							+ ' '
							+' .Please save the plan in Library '
							+'\n\n'
							+ 'Regards,'
							+'\n'
							+ strEntityOwnerName;
			sendEmail(strToId,strEmailBody,strSubject);//Send Email to Tech Team
			
			//Code to send Email to Entity
			if(objAccount != null && objAccount.PersonEmail != null)
			{
				strToId = objAccount.PersonEmail;
				strSubject = 'Action Plan is Generated for your Account';
				strEmailBody = 'Dear '
								+ objAccount.Name
								+'\n\n'
								+'Action Plan has been generated and saved in the library for your account.'
								+'\n\n'
								+ 'Regards,'
								+'\n'
								+ strEntityOwnerName;
				sendEmail(strToId,strEmailBody,strSubject);//Send Email to Entity
			}
		}
		catch(System.Exception e)
		{
			system.debug('!!!!!!!!!! e:SendEmailToOwner:'+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
	}
	private void sendEmail(String strToId,String strEmailBody,String strSubject)
	{
		try
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(new String[] {strToId});
	        mail.setSenderDisplayName('Execution Tracker');  
	        mail.setSubject(strSubject);
	        mail.setPlainTextBody(strEmailBody);
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
		catch(System.Exception e)
		{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
	}
	/*
		To save Action plan as an attachment in related Entity Record
	*/
	private Boolean CreateActionPlanPDF()
	{
        Boolean bIsAttached = false;
        Blob body;
        PageReference AttachmentPlan;
        Attachment ActionPlanAttachment;
		if(entityId != null)
		{
			try
			{
	   		 	AttachmentPlan = Page.ApprovedPlanPDF;
				AttachmentPlan.getParameters().put('entityId',entityId);
				ActionPlanAttachment = new Attachment();
				body = AttachmentPlan.getContent();
			}
			catch(System.Exception e)
			{
				body = Blob.valueOf('PDF contents for test class');
	        }
	        ActionPlanAttachment.Body = body;
	        ActionPlanAttachment.ParentId = entityId;
	        String todaysDateStr = system.NOW().format('dd-MM-yyyy');
			ActionPlanAttachment.Name = 'ActionPlan'+ '_' +todaysDateStr + '.pdf';
			ActionPlanAttachment.ContentType = '';
			Database.Saveresult dbSaveResult = database.insert(ActionPlanAttachment);
			bIsAttached = dbSaveResult.isSuccess();
		}
        return bIsAttached;
	}
	
	/*
		1. Create ET Record from Aproved Action Plan
		2. Update flag from Account IsExecutionTrackerGenerated__c to true
	*/
	private Boolean InsertExecutionTracker()
	{
		Boolean blnIsETGenerated = false;
		try
		{
			List<Execution_Tracker__c> lstInsertETFromAP = new List<Execution_Tracker__c>();
			Execution_Tracker__c objET;
			String strAssetClass;
			Double dblPayOut = 0;
			 Set<String> chkDuplicate1 = new  Set<String>();
			for(Approved_Action_Plan__c objActionPlan : lstApprovedActionPlan)
			{
				String strErrDe = objActionPlan.id
						+'*******:::'+objActionPlan.RecordType.Name+objActionPlan.Entity__c+objActionPlan.Scheme_Name_Text__c;
				
				String strKey = '';
				if(objActionPlan.Scheme_Name_Text__c != null)
				{
					strKey = objActionPlan.RecordType.Name + objActionPlan.Entity__c + objActionPlan.Scheme_Name_Text__c;
				}
				else
					strKey = objActionPlan.RecordType.Name+objActionPlan.Entity__c;
				 if(! chkDuplicate1.contains(strKey))
				 {
					objET = new Execution_Tracker__c();
					dblPayOut = 0;
					objET.Entity_Name__c= objActionPlan.Entity__c; //Assign original Parent
					if(objActionPlan.RecordType.Name.equals(Label.CurrentLumpSumRecordType) || objActionPlan.RecordType.Name.equals(Label.SuggestedLumpSumRecordType))
					{
						objET.Opportunity_Name__c = 'LumpSum';
						objET.Action__c = objActionPlan.Lumpsum_Action__c;
					}
					else if(objActionPlan.RecordType.Name.equals(Label.CurrentSIPRecordType) || objActionPlan.RecordType.Name.equals(Label.SuggestedSIPRecordType))
					{
						objET.Opportunity_Name__c = 'Sip';
						objET.Action__c = objActionPlan.SIP_Action__c;
					}
					if(objActionPlan.Notes__c != null && objActionPlan.Notes__c != '')
						objET.Comments__c = objActionPlan.Notes__c;
					//Action ::Map the Action from Action Plan to this field
					objET.Suggested_Action_Amount__c = objActionPlan.Amount__c;
					//Asset Class ::Equity,Debt picklist :What value should be there if Asset Class is blank or if hybrid option is selected : Need input from Haren
					//tmpObj.assetsClass = apObj.Investment_Asset__r.Asset_Type__c;
					if(objActionPlan.Asset_Class__c != null && objActionPlan.Asset_Class__c != '')
					{
						strAssetClass = objActionPlan.Asset_Class__c;
						if(strAssetClass.contains('Equity') || strAssetClass.contains('equity'))
						{
							objET.Asset_Class_Policy_Type__c = 'Equity';
							dblPayOut = objET.Suggested_Action_Amount__c * 1.25/100;					
						}
						else if(strAssetClass.contains('Debt') || strAssetClass.contains('debt'))
						{
							objET.Asset_Class_Policy_Type__c = 'Debt';
							dblPayOut = objET.Suggested_Action_Amount__c * 0.35/100;
						}
						else
							dblPayOut = objET.Suggested_Action_Amount__c * 0.35/100;
					}
					objET.Target_Revenue__c = dblPayOut; 
					objET.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name_Text__c;
					lstInsertETFromAP.add(objET);
					chkDuplicate1.add(strKey);
				}
			}
			if(lstFamilyMembers != null)
			{
				String strPolicyName = '';
				for(Insurance__c objGI : lstGI)
				{
					if(objGI.Suggested_Cover_General_Insurance__c != null && objGI.Suggested_Cover_General_Insurance__c > 0)
					{
						dblPayOut = 0;
						objET = new Execution_Tracker__c();
						//To link them to an actual owner
						objET.Entity_Name__c = objGI.Entity__c;
						objET.Opportunity_Name__c = 'General Insurance';
						objET.Suggested_Action_Amount__c = objGI.Suggested_Cover_General_Insurance__c;
						if(objGI.Insurance_Company__c != null && objGI.Insurance_Company__c != '')
							objET.Scheme_Name_Policy_Name__c = objGI.Insurance_Company__c;
						if(objGI.Policy_Type__c != null && objGI.Policy_Type__c != '' && !objGI.Policy_Type__c.contains('None'))
							objET.Asset_Class_Policy_Type__c = objGI.Policy_Type__c;
						if(objGI.Policy_Type__c != null)
						{
							strPolicyName = objGI.Policy_Type__c;
							if(strPolicyName.contains('Motor'))
								dblPayOut = objET.Suggested_Action_Amount__c * 10/100;
							else if(strPolicyName.contains('Critical Illness'))
								dblPayOut = objET.Suggested_Action_Amount__c * 20/100;
							else if(strPolicyName.contains('Medical') || strPolicyName.contains('Top Up') || strPolicyName.contains('disability')) //Modified By : Prajakta - FP changes - 22-03-2013
								dblPayOut = objET.Suggested_Action_Amount__c * 20/100;
							else if(strPolicyName.contains('Householder'))
								dblPayOut = objET.Suggested_Action_Amount__c * 15/100;
							else if(strPolicyName.contains('Travel'))
								dblPayOut = objET.Suggested_Action_Amount__c * 20/100;
							else if(strPolicyName.contains('vehicle') || strPolicyName.contains('Personal Accident'))
								dblPayOut = objET.Suggested_Action_Amount__c * 15/100;
							else
								dblPayOut = objET.Suggested_Action_Amount__c * 15/100; //Default
								//Critical Illness
								//Health - Medical,disability
								//Householder
								//PA
								//Travel
								//Risk - vehicle, Personal Accident
						}
						else
								dblPayOut = objET.Suggested_Action_Amount__c * 15/100; //Default
								
						objET.Target_Revenue__c = dblPayOut;
						objET.Description__c = String.valueOf(objGI.Premium_Amount_Rs__c);
						lstInsertETFromAP.add(objET);
					}
				}
				for(Insurance__c objLI : lstLI)
				{
					if(objLI.Suggested_Cover_General_Insurance__c != null && objLI.Suggested_Cover_General_Insurance__c > 0)
					{
						dblPayOut = 0;
						
						objET = new Execution_Tracker__c();
						//To link them to an actual owner
						objET.Entity_Name__c = objLI.Entity__c;
						objET.Opportunity_Name__c = 'Life Insurance';
						objET.Suggested_Action_Amount__c = objLI.Suggested_Cover_General_Insurance__c;
						
						if(objLI.Insurance_Company__c != null && objLI.Insurance_Company__c != '')
						{
							objET.Scheme_Name_Policy_Name__c = objLI.Insurance_Company__c;
							if(objLI.Insurance_Company__c.contains('Birla Sun Life'))
								dblPayOut = objET.Suggested_Action_Amount__c * 28 / 100;
							else if(objLI.Insurance_Company__c.contains('HDFC'))
								dblPayOut = objET.Suggested_Action_Amount__c * 22 / 100;
							else if(objLI.Insurance_Company__c.contains('ICICI'))
								dblPayOut = objET.Suggested_Action_Amount__c * 8 / 100;
							else if(objLI.Insurance_Company__c.contains('Kotak'))
								dblPayOut = objET.Suggested_Action_Amount__c * 32 / 100;
							else if(objLI.Insurance_Company__c.contains('LIC'))
								dblPayOut = objET.Suggested_Action_Amount__c * 19 / 100;
							else
								dblPayOut = objET.Suggested_Action_Amount__c * 20 / 100; //Default
						}
						else
							dblPayOut = objET.Suggested_Action_Amount__c * 20 / 100;//Default
						objET.Target_Revenue__c = dblPayOut;
						if(objLI.Policy_Type__c != null && objLI.Policy_Type__c != '' && !objLI.Policy_Type__c.contains('None'))
							objET.Asset_Class_Policy_Type__c = objLI.Policy_Type__c;
							
						objET.Description__c = String.valueOf(objLI.Premium_Amount_Rs__c);
						lstInsertETFromAP.add(objET);
					}
				}
			}
			Boolean blnIsETCompleted = true;
			if(lstInsertETFromAP != null && lstInsertETFromAP.size() > 0)
			{
				List<Database.Saveresult> lstDBSaveResult = Database.insert(lstInsertETFromAP);
				for (Database.SaveResult dbResult : lstDBSaveResult)
				{
					if(!dbResult.isSuccess())
					{
						blnIsETCompleted = false;
						break;	
					}
				}
				if(blnIsETCompleted)
				{
					objParentAccount.IsExecutionTrackerGenerated__c = true;
					
					 /*==========Date:22/2/2012,Requested in Changes to the Account Object document --Update Action Plan Generation Date ===========*/
		            objParentAccount.Action_Plan_Generation_Date__c=Date.today();
		            /*==========================================================================================*/
		           
					Database.Saveresult objSave = Database.update(objParentAccount);
					if(objSave.isSuccess())
					{
						blnIsETGenerated = true;
						blnIsAllowedToCreateET = false;
						blnIsEtAlreadyExist = false;
						blnDisplaySucessMsg = true;
					}
					
				}
			}
		}
		catch(System.Exception e)
		{
			system.debug('!!!!!!!!!! e:InsertExecutionTracker:'+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
        return blnIsETGenerated;
	}
}