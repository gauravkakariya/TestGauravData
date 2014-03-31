/*
  	Revision History:
    Version     Version Author        Date          Comments
    1.1         Aditi Satpute        19/8/2013      On AP Updation Et records should be updated
    
*/

//public with sharing class APUpdateForETHandler  - Commented because Action Plan fails when Entity gets Locked
public class APUpdateForETHandler
{
	public void onAfterUpdateForETRecordsCreation(List<Approve_Action_Plan__c> lstNewAAP, List<Approve_Action_Plan__c> lstOldAAP, Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan)
	{
		Messaging.SingleEmailMessage emailToMetAndFp = new Messaging.SingleEmailMessage();
		Boolean isSendEmail = false;
		Set<Id> familyIdSet = new Set<Id>(); 
		Boolean executeTrigger = false;
		for(Integer i = 0 ; i < lstNewAAP.size() ; i++)
		{
			Approve_Action_Plan__c objNewAAP = lstNewAAP[i];
			Approve_Action_Plan__c objOldAAP = lstOldAAP[i];
			familyIdSet.add(objNewAAP.Account__c);
			if((objOldAAP.isGS_ExecutionTracker__c && !objNewAAP.isGS_ExecutionTracker__c) || (objOldAAP.isGSsip_ExecutionTracker__c && !objNewAAP.isGSsip_ExecutionTracker__c) 
			|| (objOldAAP.isExecutionTracker__c && !objNewAAP.isExecutionTracker__c) || (objOldAAP.isSIPexecutionTracker__c && !objNewAAP.isSIPexecutionTracker__c) 
			|| (objOldAAP.isLumpsumExecTracker__c && !objNewAAP.isLumpsumExecTracker__c) || (objOldAAP.isInsuranceExecutionTracker__c && !objNewAAP.isInsuranceExecutionTracker__c) 
			|| (objOldAAP.isAddOnExecutionTracker__c && !objNewAAP.isAddOnExecutionTracker__c))
			{
				executeTrigger = true;
			}
		}
		
		if(executeTrigger)
		{
			List<Execution_Tracker__c>  lstdeleteETrecords = new List<Execution_Tracker__c>();
	        Map<Id,Account> mapFamilyMambers = new Map<Id,Account>();
			Map<Id,Goal__c> mapIdToGoal = new Map<Id,Goal__c>([select Id,Description__c from Goal__c where Entity__c IN: familyIdSet]);
			Map<Id,Insurance__c> mapIdToInsurance = new Map<Id,Insurance__c>([select Id,Policy_Type__c,Policy_Number__c,Entity__c,
														Insurance_Company__c,Policy_Name__c,Premium_Amount_Rs__c,Surrender_Cash_Value__c 
														from Insurance__c where Entity__c IN: familyIdSet]);
	        
	        List<Execution_Tracker__c> lstExistingETrecords = [SELECT Id,Approve_Action_Plan__c,Type__c,Approve_Action_Plan__r.Investment_Asset__c,
	             													Application_Status__c,ParentExecutionTracker__c,Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name   
	             	 												FROM Execution_Tracker__c where Entity_Name__c IN: familyIdSet  
	                                                                /*and ((Application_Status__c = 'Opened' or Application_Status__c = '') 
	                                                                and ParentExecutionTracker__c = null)*/
	                                                              	and Is_Floating__c = false];
	         Map<String,List<Execution_Tracker__c>> mapApIdToET = new Map<String,List<Execution_Tracker__c>>();
	       	 List<Event_Master__c> lstEM = [Select e.Task_Event_Master__c, e.Name, e.Event_Id__c, e.Escalation_Event_Master__c 
	        									From Event_Master__c e
	        									where isActive__c = true 
	        									and (Name =: Label.Delete_Opened_ET_Event)];
	        									
	        									
	        map<String,Event_Master__c> mapNameToEventMaster = new map<String,Event_Master__c>();
	        for(Event_Master__c objEM : lstEM)
	        {
	        	if(!mapNameToEventMaster.containsKey(objEM.Name))
	        		mapNameToEventMaster.put(objEM.Name,objEM);
	        }
	        system.debug('----mapNameToEventMaster.keySet()----'+mapNameToEventMaster.keySet());
	        
	        List<Notification_Queue__c> lstInsertNotificationQueue = new List<Notification_Queue__c>();
	         
	         for(Execution_Tracker__c objET : lstExistingETrecords)
	         {
	         	String strKey = objET.Approve_Action_Plan__c+'';
	         	List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>(); 
	     		if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('Lumpsum') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
	     		{
	     			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
	     			{
		     			if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'MF_Lumpsum'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'MF_Lumpsum');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_Lumpsum',lstET);
	     			}
	     			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
	     			{
	     				if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'GS_Lumpsum'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'GS_Lumpsum');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_Lumpsum',lstET);
	     			}
	     		}
	     		else if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('SIP') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
	     		{
	     			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
	     			{
		     			if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'MF_SIP'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'MF_SIP');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_SIP',lstET);
	     			}
	     			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
	     			{
	     				if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'GS_SIP'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'GS_SIP');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_SIP',lstET);
	     			}
	     		}
	     		else
	     		{
	     			if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c))
		          	{
			            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c);
			            lstET.add(objET);
		          	}
		          	else
		            	lstET.add(objET);
	     			mapApIdToET.put(objET.Approve_Action_Plan__c,lstET);
	     		}
	         }
	        
	        if(lstExistingETrecords.size() > 0 )
	        {
	    		List<Account> lstAcc = [SELECT Id, Name, isPersonAccount, Parent_Entity__c, FirstName, LastName,Total_Assets__c,Total_Income__c, 
	                            Total_Investment_Assets__c,Total_Liabilities__c,Investment_Asset_Rollup__c,PersonMailingCountry,
	                            RecordTypeId,Adjustment_Factor__c,PersonMailingStreet,PersonMailingState,PersonMailingPostalCode,
	                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,PersonMailingCity,
	                            PersonMobilePhone, Alternate_Mobile__c, PersonEmail, Alternate_E_Mail_Address__c,
	                            Retirement_Year__c,Residential_Status_del__c,Retirement_Age__c,Estimated_Life_Expectancy__c,Stock_Growth_Rate__c,
	                            Estimated_Life_EndYear__c,Relationship_to_Entity__pc,  Will__c, Gender__pc, Marital_Status__pc,
	                          	IsExecutionTrackerGenerated__c,owner.name,Earning_member__c,Dependent__c, Gold__c, Equity__c, Debt__c,
	                          	Gold_Growth_Rate__c,Related_To__c,PAN_ID__pc,Bank_Account_Number2__c,MICR_Number__c,IFSC_Number__c,Renewal_Date__c,
	                          	Retirement_Planning_Entity__c,Bank_Name__c,Branch_details__c,Bank_Account_Type__c,
	                          	Plan_Generation_Date__c, MST_Team_Member__c,MST_Team_Member__r.Team_Member__c,Virtual_Partner__c,Business_Unit__c  
	                    FROM Account 
	                    where Id IN: familyIdSet];
				Account clientEntity = new Account();
		        Set<Id> ClientIdSet = new Set<Id>();
		        for(Account objAcc : lstAcc)//Database.query(strAccountQuery))
		        {
		            mapFamilyMambers.put(objAcc.Id,objAcc);
		            
		            if(objAcc.Parent_Entity__c == null)
		            	ClientIdSet.add(objAcc.Id);
		            else
		            	ClientIdSet.add(objAcc.Parent_Entity__c);
		        }
				Map<Id,Account> mapClientRecords = new Map<Id,Account>([select Id,Parent_Entity__c ,Name,Related_To__c, OwnerId,Owner.Id, owner.name,
		        							PersonMailingStreet,PersonMailingState,PersonMailingPostalCode,PersonMobilePhone, 
				                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,PersonMailingCity,
				                            MST_Team_Member__c,MST_Team_Member__r.Team_Member__c,Virtual_Partner__c,Business_Unit__c    
				                            from Account where RecordTypeId =: RecTypes__c.getInstance('AccountClient').Record_Type_Value__c and Id IN:ClientIdSet]);
		      	
		        for(Account objAcc : lstAcc)//Database.query(strAccountQuery))
		        {
		            if(objAcc.Parent_Entity__c == null)
		            	clientEntity = objAcc;
		            else
		            	clientEntity = mapClientRecords.get(objAcc.Parent_Entity__c);
		        }
		        String strAddress = '';
		        system.debug('-------clientEntity------'+clientEntity);
		     	//Added on 31/1/2013 : for Fetching Mailing Address
		        if(clientEntity != null)
		        {
		            String htmlBody = '';  
			        Integer cntr = 0;
					for(Integer i = 0 ; i < lstNewAAP.size() ; i++)
					{
						Approve_Action_Plan__c objNewAAP = lstNewAAP[i];
						Approve_Action_Plan__c objOldAAP = lstOldAAP[i];
						//Gold & Silver Lumpsum
						if (objOldAAP.isGS_ExecutionTracker__c && !objNewAAP.isGS_ExecutionTracker__c)// if old is true and new is false - then delete Et
			            {
			            	if(mapApIdToET.containsKey(objNewAAP.Id+'GS_Lumpsum'))
		                    {
		                    	//emailToMetAndFp_GS_Lumpsum.setToAddresses(lstToAddresses);
		                    	//emailToMetAndFp_GS_Lumpsum.setSubject('Deletion of Opened ET record for Entity Named "'+clientEntity.Name+'".');       
		                    	 isSendEmail = true;
		                    	 htmlBody += '<br/>'+ ++cntr + '. <b>Current GOLD AND SILVER - Lumpsum</b> section with Product Name <b>"'
		                                          +objNewAAP.Asset_Name__c+'"</b>.';
		                    	
		                    	/*emailToMetAndFp.setHtmlBody(++cntr + '. <b>Current GOLD AND SILVER - Lumpsum</b> section with Product Named "'
		                                          +objNewAAP.Scheme_Name__c+'".');*/
		                                          // +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
		                        //emailToMetAndFp_GS_Lumpsum.setSenderDisplayName(clientEntity.Owner.Name);
		                        //lstSendMail.add(emailToMetAndFp_GS_Lumpsum);
		                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'GS_Lumpsum'));
		                    }
			            }
		            
			            //Gold & Silver Running SIP's
			            if (objOldAAP.isGSsip_ExecutionTracker__c && !objNewAAP.isGSsip_ExecutionTracker__c)// if old is true and new is false - then delete Et
			            {
			            	if(mapApIdToET.containsKey(objNewAAP.Id+'GS_SIP'))
		                    {
		                    	isSendEmail = true;
		                    	/*emailToMetAndFp_GS_SIP.setToAddresses(lstToAddresses);
		                    	emailToMetAndFp_GS_SIP.setSubject('Deletion of Opened ET record for Entity Named "'+clientEntity.Name+'".');       
		                    	emailToMetAndFp_GS_SIP.setHtmlBody('Dear Team,<br/><br/>In Action Plan <b>Current GOLD AND SILVER - Running SIP</b> section, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
		                                          +objNewAAP.Scheme_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
		                        emailToMetAndFp_GS_SIP.setSenderDisplayName(clientEntity.Owner.Name);
		                        lstSendMail.add(emailToMetAndFp_GS_SIP);*/
		                        htmlBody += '<br/>'+ ++cntr + '. <b>Current GOLD AND SILVER - Running SIP</b> section with Product Name <b>"'
		                                          +objNewAAP.Asset_Name__c+'"</b>.';
		                        //emailToMetAndFp.setHtmlBody(++cntr + '. <b>Current GOLD AND SILVER - Running SIP</b> section with Product Named "'
		                        //                  +objNewAAP.Scheme_Name__c+'".');
		                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'GS_SIP'));
		                    }
			            }
			            //Mutual Fund Lumpsum
					 	if (objOldAAP.isExecutionTracker__c && !objNewAAP.isExecutionTracker__c)// if old is true and new is false - then delete Et
			            {
			            	 isSendEmail = true;
			            	 system.debug('------in if ---');
			            	if(mapApIdToET.containsKey(objNewAAP.Id+'MF_Lumpsum'))
		                    {
		                    	/*emailToMetAndFp_MF_Lumpsum.setToAddresses(lstToAddresses);
		                    	emailToMetAndFp_MF_Lumpsum.setSubject('Deletion of Opened ET record for Entity Named "'+clientEntity.Name+'".');       
		                    	emailToMetAndFp_MF_Lumpsum.setHtmlBody('Dear Team,<br/><br/>In Action Plan <b>Current MUTUAL FUND - Lumpsum</b> section, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
		                                          +objNewAAP.Scheme_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
		                        emailToMetAndFp_MF_Lumpsum.setSenderDisplayName(clientEntity.Owner.Name);
		                        lstSendMail.add(emailToMetAndFp_MF_Lumpsum);*/
		                        htmlBody += '<br/>'+ ++cntr + '. <b>Current MUTUAL FUND - Lumpsum</b> section with Product Name <b>"'
		                                  +objNewAAP.Scheme_Name__c+'"</b>.';
		                        //emailToMetAndFp.setHtmlBody(++cntr + '. <b>Current MUTUAL FUND - Lumpsum</b> section with Product Named "'
		                        //          +objNewAAP.Scheme_Name__c+'".');
		                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'MF_Lumpsum'));
		                    }
			            }
		            	//Mutual Fund Running SIP & SIP Funds
		                if (objOldAAP.isSIPexecutionTracker__c && !objNewAAP.isSIPexecutionTracker__c)// if old is true and new is false - then delete Et
			            {
		            	
			            	if(objNewAAP.Investment_Asset__c != null)
		                    {
		                    	isSendEmail = true;
		                    	if(mapApIdToET.containsKey(objNewAAP.Id+'MF_SIP'))
			                    {
			                    	/*emailToMetAndFp_MF_SIP.setToAddresses(lstToAddresses);
			                    	emailToMetAndFp_MF_SIP.setSubject('Deletion of Opened ET record for Entity Named "'+clientEntity.Name+'".');       
			                    	emailToMetAndFp_MF_SIP.setHtmlBody('Dear Team,<br/><br/>In Action Plan <b>Current MUTUAL FUND - Running SIP</b> section, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
			                                          +objNewAAP.Scheme_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
			                        emailToMetAndFp_MF_SIP.setSenderDisplayName(clientEntity.Owner.Name);
			                        lstSendMail.add(emailToMetAndFp_MF_SIP);*/
			                        htmlBody += '<br/>'+ ++cntr + '. <b>Current MUTUAL FUND - Running SIP</b> section with Product Named <b>"'
		                                  +objNewAAP.Scheme_Name__c+'"</b>.';
		                           	//emailToMetAndFp.setHtmlBody(++cntr + '. <b>Current MUTUAL FUND - Running SIP</b> section with Product Named "'
		                            //      +objNewAAP.Scheme_Name__c+'".');
			                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'MF_SIP'));
			                    }
		                    }
		                    else
		                    {
		                    	isSendEmail = true;
		                    	if(mapApIdToET.containsKey(objNewAAP.Id))
			                    {
			                    	/*emailToMetAndFp_SIPFunds.setToAddresses(lstToAddresses);
			                    	emailToMetAndFp_SIPFunds.setSubject('Deletion of Opened ET record for Entity Named "'+clientEntity.Name+'".');       
			                    	emailToMetAndFp_SIPFunds.setHtmlBody('Dear Team,<br/><br/>In Action Plan SIP Fund Section of Goal Named <b>"'
		                    						+objNewAAP.Goal__r.Description__c+'"</b>, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
		                                          +objNewAAP.Product_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
			                        emailToMetAndFp_SIPFunds.setSenderDisplayName(clientEntity.Owner.Name);
			                        lstSendMail.add(emailToMetAndFp_SIPFunds);*/
		                    		htmlBody += '<br/>'+ ++cntr + '. SIP Fund Section of Goal <b>"'
		                    						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b> with Product Name <b>"'
		                              				+objNewAAP.Product_Name__c+'"</b>.';
		                    		/*emailToMetAndFp.setHtmlBody(++cntr + '. <b>SIP Fund Section of Goal <b>"'
		                    						+objNewAAP.Goal__r.Description__c+'"</b> with Product Named "'
		                              				+objNewAAP.Product_Name__c+'".');*/
			                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id));
			                    }
	                    	}
		            	}
		            	//Lumpsum Funds
		                if (objOldAAP.isLumpsumExecTracker__c && !objNewAAP.isLumpsumExecTracker__c)// if old is true and new is false - then delete Et
			            {
			            	isSendEmail = true;
			            	if(mapApIdToET.containsKey(objNewAAP.Id))
		                    {
		                    	/*emailToMetAndFp_LumpsumFunds.setToAddresses(lstToAddresses);
		                    	emailToMetAndFp_LumpsumFunds.setSubject('Deletion of Opened ET record for Entity Named "'+clientEntity.Name+'".');       
		                    	emailToMetAndFp_LumpsumFunds.setHtmlBody('Dear Team,<br/><br/>In Action Plan Lumpsum Fund Section of Goal Named <b>"'
		                    						+objNewAAP.Goal__r.Description__c+'"</b>, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
		                                          +objNewAAP.Product_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
		                        emailToMetAndFp_LumpsumFunds.setSenderDisplayName(clientEntity.Owner.Name);
		                        lstSendMail.add(emailToMetAndFp_LumpsumFunds);
		                        */
		                        htmlBody += '<br/>'+ ++cntr + '. Lumpsum Fund Section of Goal <b>"'
		                    						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b> with Product Name <b>"'
		                              				+objNewAAP.Product_Name__c+'"</b>.';
		                        /*emailToMetAndFp.setHtmlBody(++cntr + '. <b>Lumpsum Fund Section of Goal <b>"'
		                    						+objNewAAP.Goal__r.Description__c+'"</b> with Product Named "'
		                              				+objNewAAP.Product_Name__c+'".');*/
		                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id));
		                    }
			            }
		            	//Life Insurance, Recommended & General Insurance
		                if (objOldAAP.isInsuranceExecutionTracker__c && !objNewAAP.isInsuranceExecutionTracker__c)// if old is true and new is false - then delete Et
			            {
			            	isSendEmail = true;
			            	if(mapApIdToET.containsKey(objNewAAP.Id))
		                    {
		                    	//error.debugLog('----in Insurance-------');
		                    	/*emailToMetAndFp_Insurance.setToAddresses(lstToAddresses);
		                    	emailToMetAndFp_Insurance.setSubject('Deletion of Opened ET record for Entity Named "'+clientEntity.Name+'".');       
		                      	if(objOldAAP.Item_Type__c == 'Life insurance')
		                        	emailToMetAndFp_Insurance.setHtmlBody('Dear Team,<br/><br/>In Action Plan <b>Life Insurance</b> Section, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
		                                                              +objNewAAP.Policy_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
		                        else if(objOldAAP.Item_Type__c == 'General insurance')
		                        	emailToMetAndFp_Insurance.setHtmlBody('Dear Team,<br/><br/>In Action Plan <b>General Insurance</b> Section, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
		                                                              +objNewAAP.Product_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
		                        else
		                        	emailToMetAndFp_Insurance.setHtmlBody('Dear Team,<br/><br/>In Action Plan <b>Recommended Insurance</b> Section, "ET to be opened" field has been changed from <b>Yes</b> to <b>No</b> for Product Named "'
		                                                              +mapIdToInsurance.get(objNewAAP.Insurance__c).Policy_Name__c +'<br/><br/> Thanks,<br/>'+clientEntity.Owner.Name);
		                                                              
		                        emailToMetAndFp_Insurance.setSenderDisplayName(clientEntity.Owner.Name);
		                        lstSendMail.add(emailToMetAndFp_Insurance);*/
		              
		                        if(objNewAAP.Item_Type__c == 'Life insurance')                                      
		                        	htmlBody += '<br/>'+ ++cntr + '. <b>Life Insurance</b> Section with Policy Name <b>"'
		                             				+objNewAAP.Policy_Name__c+'"</b>.';
		                        else if(objNewAAP.Item_Type__c == 'General Insurance')
		                       		 htmlBody += '<br/>'+ ++cntr + '. <b>General Insurance</b> Section with Product Name <b>"'
		                              				+objNewAAP.Product_Name__c+'"</b>.';
		                        else if(objNewAAP.Item_Type__c == Label.Surrender_Insurance)    	
		                        	htmlBody += '<br/>'+ ++cntr + '. <b>'+Label.Surrender_Insurance+'</b> Section with Product Name <b>"'
		                              				+mapIdToInsurance.get(objNewAAP.Insurance__c).Policy_Name__c+'"</b>.';
		                        lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id));
		                    }
			            }
			            //Other Products - Loan,Fixed Deposit & Bond
		                if (objOldAAP.isAddOnExecutionTracker__c && !objNewAAP.isAddOnExecutionTracker__c)// if old is true and new is false - then delete Et
			            {
			            	isSendEmail = true;
			            	if(mapApIdToET.containsKey(objNewAAP.Id))
		                    {
		              
		                        if(objNewAAP.Item_Type__c == 'Loan')                                      
		                        	htmlBody += '<br/>'+ ++cntr + '. <b>Loan</b> Section with Vendor Name <b>"'
		                             				+objNewAAP.Product_Name__c+'"</b>.';
		                        else if(objNewAAP.Item_Type__c == 'Fixed Deposit')
		                       		 htmlBody += '<br/>'+ ++cntr + '. <b>Fixed Deposit</b> Section with Scheme Name <b>"'
		                              				+objNewAAP.Product_Name__c+'"</b>.';
		                        else if(objNewAAP.Item_Type__c == 'Bond')    	
		                        	htmlBody += '<br/>'+ ++cntr + '. <b>Bond</b> Section with Category Named <b>"'
		                              				+objNewAAP.Product_Name__c+'"</b>.';
		                        lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id));
		                    }
			            }
					}//end of For loop
				
					if(!lstdeleteETrecords.isEmpty())
						delete lstdeleteETrecords;
					
					if(isSendEmail)
			        {
			        	htmlBody += '<br/><br/> Thanks,<br/>'+UserInfo.getName();
			        	map<String, String> mapOldTOActual = new map<String, String>();
				        mapOldTOActual.put('mailBody', htmlBody); 
				        mapOldTOActual.put('loggedInUserEmailId', UserInfo.getUserEmail()); 
				        mapOldTOActual.put('MSTHeadEmail', Label.MET_Head_Email_id); 
				        mapOldTOActual.put('RNAHeadEmail', Label.RNA_Head_Email_id);  
				        String getOldPSTName = FreedomUtils.returnPayLoad(mapOldTOActual); 
				                
						if(mapNameToEventMaster.containsKey(Label.Delete_Opened_ET_Event))
						{
				              Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
				              objNotificationQueue.Partner_Id__c = clientEntity.Virtual_Partner__c;
				              objNotificationQueue.Biz_Unit__c = clientEntity.Business_Unit__c;
				              objNotificationQueue.Member_Id__c = clientEntity.Id;
				              objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.Delete_Opened_ET_Event).Id;
				              objNotificationQueue.Channel_Type__c = 'Email';
				              objNotificationQueue.PayloadXML__c = getOldPSTName;
				              lstInsertNotificationQueue.add(objNotificationQueue);
						}    
						//emailToMetAndFp.setHtmlBody(htmlBody);
			        	//Messaging.SendEmailResult [] arrBPEntityOwnerResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMetAndFp});
			        	if(!lstInsertNotificationQueue.isEmpty())
		            		insert lstInsertNotificationQueue;
			        }
	        	} 
	      	}
    	}
	}
	
	public void BeforeAPUpdateAfterETRecordsCreation(List<Approve_Action_Plan__c> lstNewAAP, List<Approve_Action_Plan__c> lstOldAAP, Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan)
	{
        
      	Set<Id> familyIdSet = new Set<Id>();
		Map<Id,Account> mapFamilyMambers = new Map<Id,Account>();
		Set<Id> setCompanyNameIds = new Set<Id>();
		for(Approve_Action_Plan__c objAp  : lstNewAAP)
        {
        	familyIdSet.add(objAp.Account__c);
        	setCompanyNameIds.add(objAp.Company_Name__c);
        }
        for(Approve_Action_Plan__c objOldAp  : lstOldAAP)
        {
        	setCompanyNameIds.add(objOldAp.Company_Name__c);
        }
        List<Execution_Tracker__c> lstExistingETrecords = [SELECT Id,Approve_Action_Plan__c,Type__c,Approve_Action_Plan__r.Investment_Asset__c,
             													Application_Status__c,ParentExecutionTracker__c,Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name   
             	 												FROM Execution_Tracker__c where Entity_Name__c IN: familyIdSet  
                                                                /*and ((Application_Status__c = 'Opened' or Application_Status__c = '') */
                                                                and ParentExecutionTracker__c = null
                                                              	and Is_Floating__c = false];
        List<Event_Master__c> lstEM = [Select e.Task_Event_Master__c, e.Name, e.Event_Id__c, e.Escalation_Event_Master__c 
        									From Event_Master__c e
        									where isActive__c = true 
        									and (Name =: Label.AP_Update_Event)];
        									
        Map<Id,Product_Manufacturer_Master__c> mapIdToPM = new Map<Id,Product_Manufacturer_Master__c>([select Id,Name 
        										from Product_Manufacturer_Master__c where Id IN: setCompanyNameIds]);									
        map<String,Event_Master__c> mapNameToEventMaster = new map<String,Event_Master__c>();
        for(Event_Master__c objEM : lstEM)
        {
        	if(!mapNameToEventMaster.containsKey(objEM.Name))
        		mapNameToEventMaster.put(objEM.Name,objEM);
        }
        system.debug('----mapNameToEventMaster.keySet()----'+mapNameToEventMaster.keySet());
        
        List<Notification_Queue__c> lstInsertNotificationQueue = new List<Notification_Queue__c>();
                                                              	
        Map<String,Execution_Tracker__c> mapApIdToET = new Map<String,Execution_Tracker__c>();
        for(Execution_Tracker__c objET : lstExistingETrecords)
        {
         	String strKey = objET.Approve_Action_Plan__c+'';
     		if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('Lumpsum') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
     		{
     			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
     				mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_Lumpsum',objET);
     			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
     				mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_Lumpsum',objET);
     		}
     		else if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('SIP') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
     		{
     			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
     				mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_SIP',objET);
     			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
     				mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_SIP',objET);
     		}
     		else
     		{
     			mapApIdToET.put(objET.Approve_Action_Plan__c,objET);
     		}
        }
        
        if(lstExistingETrecords.size() > 0 )
        {
	       
	        List<Account> lstAcc = [Select Id, Parent_Entity__c ,Name,Related_To__c, OwnerId,Owner.Id, owner.name,
		        							PersonMailingStreet,PersonMailingState,PersonMailingPostalCode,PersonMobilePhone, 
				                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,PersonMailingCity,
				                            MST_Team_Member__c,MST_Team_Member__r.Team_Member__c,Virtual_Partner__c,Business_Unit__c     
		        						from Account where Id =: familyIdSet];
	        Account clientEntity = new Account();
	        Boolean isSendEmail = false;
	       /* Map<Id,Account> mapClientRecords = new Map<Id,Account>([select Id,Parent_Entity__c ,Name,Related_To__c, OwnerId,Owner.Id, owner.name,
		        							PersonMailingStreet,PersonMailingState,PersonMailingPostalCode,PersonMobilePhone, 
				                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,PersonMailingCity  
				                            from Account where RecordTypeId =: RecTypes__c.getInstance('AccountClient').Record_Type_Value__c and Id IN:familyIdSet]);*/
			Map<Id,Goal__c> mapIdToGoal = new Map<Id,Goal__c>([select Id,Description__c from Goal__c where Entity__c IN: familyIdSet]);
			Map<Id,Insurance__c> mapIdToInsurance = new Map<Id,Insurance__c>([select Id,Policy_Type__c,Policy_Number__c,Entity__c,
													Insurance_Company__c,Policy_Name__c,Premium_Amount_Rs__c,Surrender_Cash_Value__c 
													from Insurance__c where Entity__c IN: familyIdSet]);
	        
	        Set<Id> ClientIdSet = new Set<Id>();
	        for(Account objAcc : lstAcc)//Database.query(strAccountQuery))
	        {
	            mapFamilyMambers.put(objAcc.Id,objAcc);
	            
	            if(objAcc.Parent_Entity__c == null)
	            	ClientIdSet.add(objAcc.Id);
	            else
	            	ClientIdSet.add(objAcc.Parent_Entity__c);
	        }
			Map<Id,Account> mapClientRecords = new Map<Id,Account>([select Id,Parent_Entity__c ,Name,Related_To__c, OwnerId,Owner.Id, owner.name,
	        							PersonMailingStreet,PersonMailingState,PersonMailingPostalCode,PersonMobilePhone, 
			                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,PersonMailingCity,
			                            MST_Team_Member__c,MST_Team_Member__r.Team_Member__c,Virtual_Partner__c,Business_Unit__c    
			                            from Account where RecordTypeId =: RecTypes__c.getInstance('AccountClient').Record_Type_Value__c and Id IN:ClientIdSet]);
	      	
	        for(Account objAcc : lstAcc)
	        {
	            mapFamilyMambers.put(objAcc.Id,objAcc);
	            if(objAcc.Parent_Entity__c == null)
	            	clientEntity = objAcc;
	            else
	            	clientEntity = mapClientRecords.get(objAcc.Parent_Entity__c);
	        }
	        
	      /*  String mstUserEmail = '';
	        String MetUserID = '';
	        String METName = '';
	        Contact objContact = new Contact();
	        Account objBPAccount = new Account();
	        if(clientEntity.Related_To__c.equalsIgnoreCase('Business Partner'))
	        {
	        	Map<Id,User> mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User]);
	    	 	User objBPEntityOwnerUser = mapIdToUser.get(clientEntity.OwnerId);
	        	if(objBPEntityOwnerUser.ContactId != null)
	            {
	                //To fetch Contact of that particular BP User
	                objContact = [select AccountId from Contact where id =: objBPEntityOwnerUser.ContactId];
	                //To fetch Account with previously fetched Contact
	                objBPAccount = [select Id, Email_ID__c, OwnerId, Channel_Manager__c , Channel_Manager__r.Name , IsCreatedByPartner__c, Phone, Name from Account where id =: objContact.AccountId];    
	            }
	            List<Workstation__c> lstBPWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name,Member_Engagement__r.Email, Financial_Planner__c 
	                                                                From Workstation__c 
	                                                                where Financial_Planner__c = : objBPAccount.Channel_Manager__c];
	            if(!lstBPWorkstation.isEmpty())
	            {
            		MetUserID = lstBPWorkstation[0].Member_Engagement__c;
                  	mstUserEmail = lstBPWorkstation[0].Member_Engagement__r.Email;
                  	METName = lstBPWorkstation[0].Member_Engagement__r.Name;
	            }
	        }
	        else
	        {
	        	List<Workstation__c> lstWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name,Member_Engagement__r.Email, Financial_Planner__c 
	                                                         From Workstation__c 
	                                                         where Financial_Planner__c = : clientEntity.Owner.Id or Member_Engagement__c =: clientEntity.Owner.Id];
	                                                         
	            if(!lstWorkstation.isEmpty())
	            {
	            	MetUserID = lstWorkstation[0].Member_Engagement__c;
	            	mstUserEmail = lstWorkstation[0].Member_Engagement__r.Email;
	            	METName = lstWorkstation[0].Member_Engagement__r.Name;
	            }
	            system.debug('-----lstWorkstation-----'+lstWorkstation);	
	        }
	        
			Messaging.SingleEmailMessage emailToMetAndFp = new Messaging.SingleEmailMessage();
			List<String> lstToAddresses = new List<String>();
			lstToAddresses.add(mstUserEmail);
			system.debug('--lstToAddresses-----'+lstToAddresses.size());
			
	        emailToMetAndFp.setToAddresses(lstToAddresses);
	    	emailToMetAndFp.setSubject('Action Plan records are updated for Entity Named "'+clientEntity.Name+'".'); 
	    	String htmlBody = '';  
	    	if(METName != null || METName != '')
	    		htmlBody = 'Dear '+METName+',<br/><br/>Following Action Plan Records have been Updated after Creation of ET records : <br/>';   
	    	else
	    		htmlBody = 'Dear Team,<br/><br/>Following Action Plan Records have been Updated after Creation of ET records : <br/>';   
	    		        
	        emailToMetAndFp.setSenderDisplayName(UserInfo.getName());
	        */
	        if(clientEntity != null)
	        {
				Integer cntr = 0;
				String htmlBody = '';  
				for(Integer i = 0 ; i < lstNewAAP.size() ; i++)
				{
					Approve_Action_Plan__c objNewAAP = lstNewAAP[i];
					Approve_Action_Plan__c objOldAAP = lstOldAAP[i];
		 			//==================If any AP records are updated======================
		 			
		 			if(mapApIdToET.containsKey(objNewAAP.Id+'MF_Lumpsum'))
	                {
	                	if(objOldAAP.Lumpsum_Action__c != objNewAAP.Lumpsum_Action__c) 
			            {
			            	isSendEmail = true;
							//error.debugLog('----In lumpsum Amount-----Mutual Fund--Lumpsum_Action__c-');			
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current MUTUAL FUND - SIP</b> section, "Action" has been changed from <b>'
	                                  +objOldAAP.Lumpsum_Action__c+'</b> to <b>'+objNewAAP.Lumpsum_Action__c+'</b> for Product Named "'
	                                  +objNewAAP.Scheme_Name__c+'".';
			            }
			            if(objOldAAP.Action_Amount__c != objNewAAP.Action_Amount__c) 
			            {
			            	isSendEmail = true;
							//error.debugLog('----In lumpsum Amount-----Mutual Fund-Action_Amount__c--');				
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current MUTUAL FUND - SIP</b> section, "Action Amount" has been changed from <b>'
	                                  +objOldAAP.Action_Amount__c+'</b> to <b>'+objNewAAP.Action_Amount__c+'</b> for Product Named "'
	                                  +objNewAAP.Scheme_Name__c+'".';
			            }
			            if(objOldAAP.isExecutionTracker__c == false && objNewAAP.isExecutionTracker__c == true)
			            {
			            	isSendEmail = true;
			            	htmlBody += '<br/>'+ ++cntr + '. In <b>Current MUTUAL FUND - SIP</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
	                                  +objOldAAP.isExecutionTracker__c+'</b> to <b>'+objNewAAP.isExecutionTracker__c+'</b> for Product Named "'
	                                  +objNewAAP.Scheme_Name__c+'".';
			            }
			            
	                }
					else if(mapApIdToET.containsKey(objNewAAP.Id+'GS_Lumpsum'))
	                {
			            if(objOldAAP.Lumpsum_Action__c != objNewAAP.Lumpsum_Action__c) 
			            {
			            	isSendEmail = true;
							//error.debugLog('----In lumpsum Amount------Gold and Silver--Lumpsum_Action__c--');			
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current GOLD AND SILVER - SIP</b> section, "Action Amount" has been changed from <b>'
	                                  +objOldAAP.Lumpsum_Action__c+'</b> to <b>'+objNewAAP.Lumpsum_Action__c+'</b> for Product Named "'
	                                  +objNewAAP.Asset_Name__c+'".';	
			            }
			            if(objOldAAP.Action_Amount__c != objNewAAP.Action_Amount__c) 
			            {
			            	isSendEmail = true;
							//error.debugLog('----In lumpsum Amount----Gold and Silver---Action_Amount__c--');		
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current GOLD AND SILVER - SIP</b> section, "Action Amount" has been changed from <b>'
	                                  +objOldAAP.Action_Amount__c+'</b> to <b>'+objNewAAP.Action_Amount__c+'</b> for Product Named "'
	                                  +objNewAAP.Asset_Name__c+'".';			
			            }
			            if(objOldAAP.isGS_ExecutionTracker__c == false && objNewAAP.isGS_ExecutionTracker__c == true)
			            {
			            	isSendEmail = true;
			            	htmlBody += '<br/>'+ ++cntr + '. In <b>Current GOLD AND SILVER - SIP</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
	                                  +objOldAAP.isGS_ExecutionTracker__c+'</b> to <b>'+objNewAAP.isGS_ExecutionTracker__c+'</b> for Product Named "'
	                                  +objNewAAP.Asset_Name__c+'".';
			            }
	                }
	                else if (mapApIdToET.containsKey(objNewAAP.Id+'MF_SIP'))
	                {
	                	if(objOldAAP.SIP_Action__c != objNewAAP.SIP_Action__c) 
			            {
			            	isSendEmail = true;
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current MUTUAL FUND - SIP</b> section, "Action" has been changed from <b>'
	                                  +objOldAAP.SIP_Action__c+'</b> to <b>'+objNewAAP.SIP_Action__c+'</b> for Product Named "'
	                                  +objNewAAP.Scheme_Name__c+'".';
			            }
			            if(objOldAAP.SIP_Action_Amount__c != objNewAAP.SIP_Action_Amount__c) 
			            {
			            	isSendEmail = true;
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current MUTUAL FUND - SIP</b> section, "Action Amount" has been changed from <b>'
	                                  +objOldAAP.SIP_Action_Amount__c+'</b> to <b>'+objNewAAP.SIP_Action_Amount__c+'</b> for Product Named "'
	                                  +objNewAAP.Scheme_Name__c+'".';
			            }
			            if(objOldAAP.isSIPexecutionTracker__c == false && objNewAAP.isSIPexecutionTracker__c == true)
			            {
			            	isSendEmail = true;
			            	htmlBody += '<br/>'+ ++cntr + '. In <b>Current MUTUAL FUND - SIP</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
	                                  +objOldAAP.isSIPexecutionTracker__c+'</b> to <b>'+objNewAAP.isSIPexecutionTracker__c+'</b> for Product Named "'
	                                  +objNewAAP.Scheme_Name__c+'".';
			            }
	                }
	                else if (mapApIdToET.containsKey(objNewAAP.Id+'GS_SIP'))
	                {
	                	if(objOldAAP.SIP_Action__c != objNewAAP.SIP_Action__c) 
			            {
			            	isSendEmail = true;
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current GOLD AND SILVER - SIP</b> section, "Action" has been changed from <b>'
	                                  +objOldAAP.SIP_Action__c+'</b> to <b>'+objNewAAP.SIP_Action__c+'</b> for Product Named "'
	                                  +objNewAAP.Asset_Name__c+'".';
			            }
			            if(objOldAAP.SIP_Action_Amount__c != objNewAAP.SIP_Action_Amount__c) 
			            {
			            	isSendEmail = true;
							htmlBody += '<br/>'+ ++cntr + '. In <b>Current GOLD AND SILVER - SIP</b> section, "Action Amount" has been changed from <b>'
	                                  +objOldAAP.SIP_Action_Amount__c+'</b> to <b>'+objNewAAP.SIP_Action_Amount__c+'</b> for Product Named "'
	                                  +objNewAAP.Asset_Name__c+'".';
			            }
			            if(objOldAAP.isGSsip_ExecutionTracker__c == false && objNewAAP.isGSsip_ExecutionTracker__c == true)
			            {
			            	isSendEmail = true;
			            	htmlBody += '<br/>'+ ++cntr + '. In <b>Current GOLD AND SILVER - SIP</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
	                                  +objOldAAP.isGSsip_ExecutionTracker__c+'</b> to <b>'+objNewAAP.isGSsip_ExecutionTracker__c+'</b> for Product Named "'
	                                  +objNewAAP.Asset_Name__c+'".';
			            }
	                }
	                else if (mapApIdToET.containsKey(objNewAAP.Id))
	                {
	                	if(objNewAAP.Item_Type__c == 'SIP')
	                	{
	                		if(objOldAAP.Product_Name__c != objNewAAP.Product_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "SIP Funds" (i.e Product Name) has been changed from <b>'
	                			 			+objOldAAP.Product_Name__c+'</b> to <b>'+objNewAAP.Product_Name__c+'</b>.';
	                		}
	                		if(objOldAAP.Transaction_Type__c != objNewAAP.Transaction_Type__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Transaction Type" has been changed from <b>'
	            			 				+objOldAAP.Transaction_Type__c+'</b> to <b>'+objNewAAP.Transaction_Type__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Amount__c != objNewAAP.Amount__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Amount" has been changed from <b>'
	            			 				+objOldAAP.Amount__c+'</b> to <b>'+objNewAAP.Amount__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Installments__c != objNewAAP.Installments__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Installments" has been changed from <b>'
	            			 				+objOldAAP.Installments__c+'</b> to <b>'+objNewAAP.Installments__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Category__c != objNewAAP.Category__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Category" has been changed from <b>'
	            			 				+objOldAAP.Category__c+'</b> to <b>'+objNewAAP.Category__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Option__c != objNewAAP.Option__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Option" has been changed from <b>'
	            			 				+objOldAAP.Option__c+'</b> to <b>'+objNewAAP.Option__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Remarks__c != objNewAAP.Remarks__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Remarks" has been changed from <b>'
	            			 				+objOldAAP.Remarks__c+'</b> to <b>'+objNewAAP.Remarks__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.isSIPexecutionTracker__c == false && objNewAAP.isSIPexecutionTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>SIP Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Execution Tracker To Be Opened" has been changed from <b>'
	            			 				+objOldAAP.isSIPexecutionTracker__c+'</b> to <b>'+objNewAAP.isSIPexecutionTracker__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
				            }
	                	}
	                	else if(objNewAAP.Item_Type__c == 'Lumpsum') 
	                	{
	                		if(objOldAAP.Product_Name__c != objNewAAP.Product_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                    						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Lumpsum Funds" (i.e Product Name) has been changed from <b>'
	                			 +objOldAAP.Product_Name__c+'</b> to <b>'+objNewAAP.Product_Name__c+'</b>.';
	                		}
	                		if(objOldAAP.Transaction_Type__c != objNewAAP.Transaction_Type__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Transaction Type" has been changed from <b>'
	            			 				+objOldAAP.Transaction_Type__c+'</b> to <b>'+objNewAAP.Transaction_Type__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Fund__c != objNewAAP.Fund__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Fund" has been changed from <b>'
	            			 				+objOldAAP.Fund__c+'</b> to <b>'+objNewAAP.Fund__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Amount__c != objNewAAP.Amount__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Amount" has been changed from <b>'
	            			 				+objOldAAP.Amount__c+'</b> to <b>'+objNewAAP.Amount__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Installments__c != objNewAAP.Installments__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Installments" has been changed from <b>'
	            			 				+objOldAAP.Installments__c+'</b> to <b>'+objNewAAP.Installments__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Amount_Per_Installment__c != objNewAAP.Amount_Per_Installment__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Amount Per Installments" has been changed from <b>'
	            			 				+objOldAAP.Amount_Per_Installment__c+'</b> to <b>'+objNewAAP.Amount_Per_Installment__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Category__c != objNewAAP.Category__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Category" has been changed from <b>'
	            			 				+objOldAAP.Category__c+'</b> to <b>'+objNewAAP.Category__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Option__c != objNewAAP.Option__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. <In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Option" has been changed from <b>'
	            			 				+objOldAAP.Option__c+'</b> to <b>'+objNewAAP.Option__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Remarks__c != objNewAAP.Remarks__c)
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Remarks" has been changed from <b>'
	            			 				+objOldAAP.Remarks__c+'</b> to <b>'+objNewAAP.Remarks__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.isLumpsumExecTracker__c == false && objNewAAP.isLumpsumExecTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>Lumpsum Funds</b> Section of Goal Named <b>"'
	                						+mapIdToGoal.get(objNewAAP.Goal__c).Description__c+'"</b>, the "Execution Tracker To Be Opened" has been changed from <b>'
	            			 				+objOldAAP.isLumpsumExecTracker__c+'</b> to <b>'+objNewAAP.isLumpsumExecTracker__c+'</b> for Product Named "'
	                  						+objNewAAP.Product_Name__c+'".';
				            }
	                	}
	                	else if(objNewAAP.Item_Type__c == Label.Surrender_Insurance)
	                	{
	                		if(objOldAAP.isInsuranceExecutionTracker__c == false && objNewAAP.isInsuranceExecutionTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>RECOMMENDATION ON EXISTING INSURANCE</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
		                                  +objOldAAP.isInsuranceExecutionTracker__c+'</b> to <b>'+objNewAAP.isInsuranceExecutionTracker__c+'</b> for Policy Named "'
		                                  +mapIdToInsurance.get(objNewAAP.Insurance__c).Policy_Name__c+'".';
				            }
	                	}
	                	else if(objNewAAP.Item_Type__c == 'Life Insurance')
	                	{
	                		if(objOldAAP.Sum_Assured_Rs__c != objNewAAP.Sum_Assured_Rs__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LIFE INSURANCE</b> section, "Sum Assured (Rs.)" has been changed from <b>'
		                                  +objOldAAP.Sum_Assured_Rs__c+'</b> to <b>'+objNewAAP.Sum_Assured_Rs__c+'</b> for Policy Named "'
		                                  +objNewAAP.Policy_Name__c+'".';
				            }
				            if(objOldAAP.Policy_Name__c != objNewAAP.Policy_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>LIFE INSURANCE</b> section, the "Policy Name" has been changed from "'
	                			 +objOldAAP.Policy_Name__c+'</b> to <b>'+objNewAAP.Policy_Name__c+'</b>.';
	                		}
				            if(objOldAAP.Premium_Amount_Rs__c != objNewAAP.Premium_Amount_Rs__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LIFE INSURANCE</b> section, "Premium Amount" has been changed from <b>'
		                                  +objOldAAP.Premium_Amount_Rs__c+'</b> to <b>'+objNewAAP.Premium_Amount_Rs__c+'</b> for Policy Named "'
		                                  +objNewAAP.Policy_Name__c+'".';
				            }
				            if(objOldAAP.Tenure_of_Insurance__c != objNewAAP.Tenure_of_Insurance__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LIFE INSURANCE</b> section, "Tenure of Insurance" has been changed from <b>'
		                                  +objOldAAP.Tenure_of_Insurance__c+'</b> to <b>'+objNewAAP.Tenure_of_Insurance__c+'</b> for Policy Named "'
		                                  +objNewAAP.Policy_Name__c+'".';
				            }
				            if(objOldAAP.isInsuranceExecutionTracker__c == false && objNewAAP.isInsuranceExecutionTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LIFE INSURANCE</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
		                                  +objOldAAP.isInsuranceExecutionTracker__c+'</b> to <b>'+objNewAAP.isInsuranceExecutionTracker__c+'</b> for Policy Named "'
		                                  +objNewAAP.Policy_Name__c+'".';
				            }
	                	} 
	                	else if(objNewAAP.Item_Type__c == 'General Insurance')
	                	{
	                		if(objNewAAP.Insurance__c == null)
	                		{
	                			if(objOldAAP.Insured__c != objNewAAP.Insured__c)
					            {
					            	isSendEmail = true;
					            	htmlBody += '<br/>'+ ++cntr + '. In <b>GENERAL INSURANCE</b> section, "Insured" has been changed from <b>'
			                                  +objOldAAP.Insured__c+'</b> to <b>'+objNewAAP.Insured__c+'</b> for Product Named "'
			                                  +objNewAAP.Product_Name__c+'".';
					            }
	                			if(objOldAAP.Sum_Assured_Rs__c != objNewAAP.Sum_Assured_Rs__c)
					            {
					            	isSendEmail = true;
					            	htmlBody += '<br/>'+ ++cntr + '. In <b>GENERAL INSURANCE</b> section, "Sum Assured (Rs.)" has been changed from <b>'
			                                  +objOldAAP.Sum_Assured_Rs__c+'</b> to <b>'+objNewAAP.Sum_Assured_Rs__c+'</b> for Product Named "'
			                                  +objNewAAP.Product_Name__c+'".';
					            }
					            if(objOldAAP.Policy_Type__c != objNewAAP.Policy_Type__c)
					            {
					            	isSendEmail = true;
					            	htmlBody += '<br/>'+ ++cntr + '. In <b>GENERAL INSURANCE</b> section, "Policy Type" has been changed from <b>'
			                                  +objOldAAP.Policy_Type__c+'</b> to <b>'+objNewAAP.Policy_Type__c+'</b> for Product Named "'
			                                  +objNewAAP.Product_Name__c+'".';
					            }
	                		}
	                		
				            if(objOldAAP.Product_Name__c != objNewAAP.Product_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>GENERAL INSURANCE</b> section, the "Product Name" has been changed from <b>'
	                			 			+objOldAAP.Product_Name__c+'</b> to <b>'+objNewAAP.Product_Name__c+'</b>.';
	                		}
				            if(objOldAAP.Premium_Amount_Rs__c != objNewAAP.Premium_Amount_Rs__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>GENERAL INSURANCE</b> section, "Premium Amount" has been changed from <b>'
		                                  +objOldAAP.Premium_Amount_Rs__c+'</b> to <b>'+objNewAAP.Premium_Amount_Rs__c+'</b> for Product Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.isInsuranceExecutionTracker__c == false && objNewAAP.isInsuranceExecutionTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>GENERAL INSURANCE</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
		                                  +objOldAAP.isInsuranceExecutionTracker__c+'</b> to <b>'+objNewAAP.isInsuranceExecutionTracker__c+'</b> for Product Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
	                		
	                	}
	                	else if(objNewAAP.Item_Type__c == 'Loan')
	                	{
	                		if(objOldAAP.Insured__c != objNewAAP.Insured__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LOAN</b> section, "Applicant" has been changed from <b>'
		                                  +objOldAAP.Insured__c+'</b> to <b>'+objNewAAP.Insured__c+'</b> for Vendor Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.Loan_Type__c != objNewAAP.Loan_Type__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LOAN</b> section, "Loan Type" has been changed from <b>'
		                                  +objOldAAP.Loan_Type__c+'</b> to <b>'+objNewAAP.Loan_Type__c+'</b> for Vendor Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
	                		if(objOldAAP.Product_Name__c != objNewAAP.Product_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>LOAN</b> section, the "Vendor Name" has been changed from <b>'
	                			 			+objOldAAP.Product_Name__c+'</b> to <b>'+objNewAAP.Product_Name__c+'</b>.';
	                		}
	                		if(objOldAAP.Amount__c != objNewAAP.Amount__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LOAN</b> section, "Amount" has been changed from <b>'
		                                  +objOldAAP.Amount__c+'</b> to <b>'+objNewAAP.Amount__c+'</b> for Vendor Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.isAddOnExecutionTracker__c == false && objNewAAP.isAddOnExecutionTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>LOAN</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
		                                  +objOldAAP.isAddOnExecutionTracker__c+'</b> to <b>'+objNewAAP.isAddOnExecutionTracker__c+'</b> for Vendor Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
	                	}
	                	else if(objNewAAP.Item_Type__c == 'Fixed Deposit')
	                	{
	                		if(objOldAAP.Insured__c != objNewAAP.Insured__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Applicant" has been changed from <b>'
		                                  +objOldAAP.Insured__c+'</b> to <b>'+objNewAAP.Insured__c+'</b> for Scheme Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.Goal_Type__c != objNewAAP.Goal_Type__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Goal Type" has been changed from <b>'
		                                  +objOldAAP.Goal_Type__c+'</b> to <b>'+objNewAAP.Goal_Type__c+'</b> for Scheme Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.Company_Name__c != objNewAAP.Company_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, the "Company Name" has been changed from <b>'
	                			 			+mapIdToPM.get(objOldAAP.Company_Name__c).Name+'</b> to <b>'+mapIdToPM.get(objNewAAP.Company_Name__c).Name+'</b>.';
	                		}
	                		if(objOldAAP.Product_Name__c != objNewAAP.Product_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, the "Scheme Name" has been changed from <b>'
	                			 			+objOldAAP.Product_Name__c+'</b> to <b>'+objNewAAP.Product_Name__c+'</b>.';
	                		}
	                		if(objOldAAP.Period_in_Months__c != objNewAAP.Period_in_Months__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Period in Months" has been changed from <b>'
		                                  +objOldAAP.Period_in_Months__c+'</b> to <b>'+objNewAAP.Period_in_Months__c+'</b> for Scheme Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
	                		if(objOldAAP.Amount__c != objNewAAP.Amount__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Investment Amount" has been changed from <b>'
		                                  +objOldAAP.Amount__c+'</b> to <b>'+objNewAAP.Amount__c+'</b> for Scheme Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.isAddOnExecutionTracker__c == false && objNewAAP.isAddOnExecutionTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
		                                  +objOldAAP.isAddOnExecutionTracker__c+'</b> to <b>'+objNewAAP.isAddOnExecutionTracker__c+'</b> for Scheme Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
	                	}
	                	else if(objNewAAP.Item_Type__c == 'Bond')
	                	{
	                		if(objOldAAP.Insured__c != objNewAAP.Insured__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Applicant" has been changed from <b>'
		                                  +objOldAAP.Insured__c+'</b> to <b>'+objNewAAP.Insured__c+'</b> for Category Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.Goal_Type__c != objNewAAP.Goal_Type__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Goal Type" has been changed from <b>'
		                                  +objOldAAP.Goal_Type__c+'</b> to <b>'+objNewAAP.Goal_Type__c+'</b> for Category Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.Company_Name__c != objNewAAP.Company_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, the "Company Name" has been changed from <b>'
	                			 			+mapIdToPM.get(objOldAAP.Company_Name__c).Name+'</b> to <b>'+mapIdToPM.get(objNewAAP.Company_Name__c)+'</b> for Category Named "'
		                                  +objNewAAP.Product_Name__c+'".';
	                		}
	                		if(objOldAAP.Product_Name__c != objNewAAP.Product_Name__c) 
	                		{
	                			isSendEmail = true;
	                			htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, the "Category" has been changed from <b>'
	                			 			+objOldAAP.Product_Name__c+'</b> to <b>'+objNewAAP.Product_Name__c+'</b>.';
	                		}
                		   	if(objOldAAP.Bond_Type__c != objNewAAP.Bond_Type__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Bond Type" has been changed from <b>'
		                                  +objOldAAP.Bond_Type__c+'</b> to <b>'+objNewAAP.Bond_Type__c+'</b> for Category Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
	                		if(objOldAAP.Amount__c != objNewAAP.Amount__c)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Bond Amount" has been changed from <b>'
		                                  +objOldAAP.Amount__c+'</b> to <b>'+objNewAAP.Amount__c+'</b> for Category Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
				            if(objOldAAP.isAddOnExecutionTracker__c == false && objNewAAP.isAddOnExecutionTracker__c == true)
				            {
				            	isSendEmail = true;
				            	htmlBody += '<br/>'+ ++cntr + '. In <b>FIXED DEPOSIT</b> section, "Execution Tracker To Be Opened" has been changed from <b>'
		                                  +objOldAAP.isAddOnExecutionTracker__c+'</b> to <b>'+objNewAAP.isAddOnExecutionTracker__c+'</b> for Category Named "'
		                                  +objNewAAP.Product_Name__c+'".';
				            }
	                	}
	                	
	                }
	                
		        }
		     	if(isSendEmail)
		     	{
		     		//Send Chatter Notification to MET
			        String chatterPostBody = 'Following Action Plan Records have been Updated after Creation of ET records : <br/>';
			        
		            //if(MetUserID != null)
		            if(clientEntity.MST_Team_Member__c != null)
		            {
		            	FeedItem post = new FeedItem();
		            	post.ParentId = clientEntity.MST_Team_Member__r.Team_Member__c;//MetUserID;
	            	 	post.Body = 'For Entity "'+clientEntity.Name+'", some Action Plan Records have been updated after creation of Execution Tracker records.Please go through your mail for all details.';
		                insert post;
		            }
		            
		     		
	     			htmlBody += '<br/><br/> Thanks,<br/>'+UserInfo.getName();
		        	map<String, String> mapOldTOActual = new map<String, String>();
			        mapOldTOActual.put('mailBody', htmlBody); 
			        mapOldTOActual.put('loggedInUserEmailId', UserInfo.getUserEmail()); 
			        String getOldPSTName = FreedomUtils.returnPayLoad(mapOldTOActual); 
			                
					if(mapNameToEventMaster.containsKey(Label.AP_Update_Event))
					{
			              Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
			              objNotificationQueue.Partner_Id__c = clientEntity.Virtual_Partner__c;
			              objNotificationQueue.Biz_Unit__c = clientEntity.Business_Unit__c;
			              objNotificationQueue.Member_Id__c = clientEntity.Id;
			              objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.AP_Update_Event).Id;
			              objNotificationQueue.Channel_Type__c = 'Email';
			              objNotificationQueue.PayloadXML__c = getOldPSTName;
			              lstInsertNotificationQueue.add(objNotificationQueue);
					}
		     		
					//emailToMetAndFp.setHtmlBody(htmlBody);
		        	//Messaging.SendEmailResult [] arrBPEntityOwnerResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMetAndFp});
		        	if(!lstInsertNotificationQueue.isEmpty())
            			insert lstInsertNotificationQueue;
		     	}
	        }
        }
	}
}