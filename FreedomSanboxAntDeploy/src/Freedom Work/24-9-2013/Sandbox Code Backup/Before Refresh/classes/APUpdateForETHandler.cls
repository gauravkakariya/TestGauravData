/*
  	Revision History:
    Version     Version Author        Date          Comments
    1.1         Aditi Satpute        19/8/2013      On AP Updation Et records should be updated
    
*/

public with sharing class APUpdateForETHandler 
{
	public void onAfterUpdateForETRecordsCreation(List<Approve_Action_Plan__c> lstNewAAP, List<Approve_Action_Plan__c> lstOldAAP, Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan)
	{
		Set<Id> familyIdSet = new Set<Id>(); 
		List<Execution_Tracker__c>  lstETrecords = new List<Execution_Tracker__c>();
		List<Execution_Tracker__c>  lstdeleteETrecords = new List<Execution_Tracker__c>();
        Map<Id,Account> mapFamilyMambers = new Map<Id,Account>();
        Map<Id,Account> mapClientRecords = new Map<Id,Account>([select Id,Parent_Entity__c ,Name,Related_To__c, OwnerId,Owner.Id, owner.name,
	        							PersonMailingStreet,PersonMailingState,PersonMailingPostalCode,PersonMobilePhone, 
			                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,PersonMailingCity  
			                            from Account where RecordTypeId =: RecTypes__c.getInstance('AccountClient').Record_Type_Value__c]);
        for(Approve_Action_Plan__c objAp  : lstNewAAP)
        {
        	familyIdSet.add(objAp.Account__c);
        }
        
        List<Execution_Tracker__c> lstExistingETrecords = [SELECT Id,Approve_Action_Plan__c,Type__c,Approve_Action_Plan__r.Investment_Asset__c,
             													Application_Status__c,ParentExecutionTracker__c,Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name   
             	 												FROM Execution_Tracker__c where Entity_Name__c IN: familyIdSet  
                                                                /*and ((Application_Status__c = 'Opened' or Application_Status__c = '') 
                                                                and ParentExecutionTracker__c = null)*/
                                                              	and Is_Floating__c = false];
         Map<String,List<Execution_Tracker__c>> mapApIdToET = new Map<String,List<Execution_Tracker__c>>();
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
	        List<Account> lstAcc = [Select Id, Parent_Entity__c ,Name,Related_To__c, OwnerId,Owner.Id, owner.name,
	        							PersonMailingStreet,PersonMailingState,PersonMailingPostalCode,PersonMobilePhone, 
			                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,PersonMailingCity 
	        						from Account where Id =: familyIdSet];
	        Account clientEntity = new Account();
	        for(Account objAcc : lstAcc)
	        {
	            mapFamilyMambers.put(objAcc.Id,objAcc);
	            if(objAcc.Parent_Entity__c == null)
	            	clientEntity = objAcc;
	            else
	            	clientEntity = mapClientRecords.get(objAcc.Parent_Entity__c);
	        }
	        system.debug('-------lstAcc------'+lstAcc);
	        String strAddress = '';
	        system.debug('-------clientEntity------'+clientEntity);
	     	//Added on 31/1/2013 : for Fetching Mailing Address
	        if(clientEntity != null)
	        {
	            clientEntity.PersonMailingStreet = clientEntity.PersonMailingStreet != null ? clientEntity.PersonMailingStreet : ''; 
	            clientEntity.PersonMailingCity= clientEntity.PersonMailingCity != null ? clientEntity.PersonMailingCity: '';
	            clientEntity.PersonMailingState = clientEntity.PersonMailingState!= null ? clientEntity.PersonMailingState : '';
	            clientEntity.PersonMailingCountry = clientEntity.PersonMailingCountry != null? clientEntity.PersonMailingCountry :'';
	            clientEntity.PersonMailingPostalCode = clientEntity.PersonMailingPostalCode != null? clientEntity.PersonMailingPostalCode:'';
	            
	            if(clientEntity.PersonMailingStreet != null && clientEntity.PersonMailingCity != null && clientEntity.PersonMailingState != null || 
	                            clientEntity.PersonMailingCountry != null && clientEntity.PersonMailingPostalCode != null )
	                            if(clientEntity.PersonMailingStreet.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingState.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingCountry.compareTo('') == 0 &&
	                               clientEntity.PersonMailingPostalCode.compareTo('') == 0)
	                                    strAddress = '';
	                             
	            if(clientEntity.PersonMailingStreet != null && clientEntity.PersonMailingCity != null && clientEntity.PersonMailingState != null || 
	                            clientEntity.PersonMailingCountry != null && clientEntity.PersonMailingPostalCode != null )
	                            
	                            if(clientEntity.PersonMailingStreet.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingState.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingCity.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingCountry.compareTo('') == 0 &&
	                               clientEntity.PersonMailingPostalCode.compareTo('') == 0)
	                                    strAddress = '';
	                                    
	                            else if(clientEntity.PersonMailingStreet.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingState.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCity.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCountry.compareTo('') != 0 &&
	                               clientEntity.PersonMailingPostalCode.compareTo('') != 0)   
	                               strAddress =  clientEntity.PersonMailingCity+',\n'+
	                                                    clientEntity.PersonMailingState+', '+clientEntity.PersonMailingCountry+',\n'+
	                                                    clientEntity.PersonMailingPostalCode+'.';
	                             
	                            else if(clientEntity.PersonMailingStreet.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingState.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingCity.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCountry.compareTo('') != 0 &&
	                               clientEntity.PersonMailingPostalCode.compareTo('') != 0)   
	                               strAddress =  clientEntity.PersonMailingStreet+',\n'+
	                                                    clientEntity.PersonMailingCity+', '+clientEntity.PersonMailingCountry+',\n'+
	                                                    clientEntity.PersonMailingPostalCode+'.';
	                                                    
	                            else if(clientEntity.PersonMailingStreet.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingState.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCity.compareTo('') ==  0 &&
	                               clientEntity.PersonMailingCountry.compareTo('') != 0 &&
	                               clientEntity.PersonMailingPostalCode.compareTo('') != 0)   
	                               strAddress =  clientEntity.PersonMailingStreet+', '+clientEntity.PersonMailingState+',\n'+
	                                                    +clientEntity.PersonMailingCountry+',\n'+
	                                                    clientEntity.PersonMailingPostalCode+'.'; 
	                                                    
	                            else if(clientEntity.PersonMailingStreet.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingState.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCity.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCountry.compareTo('') == 0 &&
	                               clientEntity.PersonMailingPostalCode.compareTo('') != 0)   
	                               strAddress =  clientEntity.PersonMailingStreet+', '+clientEntity.PersonMailingState+',\n'+clientEntity.PersonMailingCity+
	                                                    ',\n'+clientEntity.PersonMailingPostalCode+'.';   
	                                                    
	                            else if(clientEntity.PersonMailingStreet.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingState.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCity.compareTo('') !=  0 &&
	                               clientEntity.PersonMailingCountry.compareTo('') != 0 &&
	                               clientEntity.PersonMailingPostalCode.compareTo('') == 0)   
	                               strAddress =  clientEntity.PersonMailingStreet+', '+clientEntity.PersonMailingState+',\n'+clientEntity.PersonMailingCity+
	                                                    ',\n'+clientEntity.PersonMailingCountry+'.';                                              
	                             else    
	                            {
	                                strAddress = clientEntity.PersonMailingStreet+', '+clientEntity.PersonMailingCity+',\n'+
	                                                    clientEntity.PersonMailingState+', '+clientEntity.PersonMailingCountry+',\n'+
	                                                    clientEntity.PersonMailingPostalCode+'.';
	                                system.debug('******strAddress******'+strAddress);
	                            }
	            else
	            {
	                strAddress = '';
	            }
	            
	        Map<Id,User> mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User]);
	        String workStationOwnerId = '';
	        Contact objContact = new Contact();
	        Account objBPAccount = new Account();
	        if(clientEntity.Related_To__c.equalsIgnoreCase('Business Partner'))
	        {
	    	 	User objBPEntityOwnerUser = mapIdToUser.get(clientEntity.OwnerId);
	                            
	        	if(objBPEntityOwnerUser.ContactId != null)
	            {
	                //To fetch Contact of that particular BP User
	                objContact = [select AccountId from Contact where id =: objBPEntityOwnerUser.ContactId];
	                //To fetch Account with previously fetched Contact
	                objBPAccount = [select Id, Email_ID__c, OwnerId, Channel_Manager__c , Channel_Manager__r.Name , IsCreatedByPartner__c, Phone, Name from Account where id =: objContact.AccountId];    
	            }
	            List<Workstation__c> lstBPWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
	                                                                From Workstation__c 
	                                                                where Financial_Planner__c = : objBPAccount.Channel_Manager__c];
	            if(!lstBPWorkstation.isEmpty())
	                  workStationOwnerId = lstBPWorkstation[0].Member_Engagement__c;
	        }
	        else
	        {
	        	List<Workstation__c> lstWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
	                                                         From Workstation__c 
	                                                         where Financial_Planner__c = : clientEntity.Owner.Id];
	                                                         
	            if(!lstWorkstation.isEmpty())
	            	workStationOwnerId = lstWorkstation[0].Member_Engagement__c;
	            system.debug('-----lstWorkstation-----'+lstWorkstation);	
	        }
	        
			for(Integer i = 0 ; i < lstNewAAP.size() ; i++)
			{
				Approve_Action_Plan__c objNewAAP = lstNewAAP[i];
				Approve_Action_Plan__c objOldAAP = lstOldAAP[i];
				//Gold & Silver Lumpsum
				if(!objOldAAP.isGS_ExecutionTracker__c && objNewAAP.isGS_ExecutionTracker__c) // if old is false and new is true
	            {
	            	Execution_Tracker__c objET_GS = new Execution_Tracker__c();
	            	objET_GS.Entity_Name__c = objNewAAP.Account__c;
                	objET_GS.ET_Status__c = 'Assigned to MET';
                	objET_GS.Action__c = objNewAAP.Lumpsum_Action__c;
                    objET_GS.Suggested_Amount__c = objNewAAP.Action_Amount__c;
                    objET_GS.Agreed_Amount__c = objET_GS.Suggested_Amount__c;
                    objET_GS.Actual_Action_Amount__c = objNewAAP.Action_Amount__c;
                    objET_GS.Agreed_Amount_Base_Amount__c = objNewAAP.Action_Amount__c;
                    objET_GS.Amount__c = objNewAAP.Amount__c;
                    objET_GS.Executed_Product_Name__c = objNewAAP.Asset_name__c;
                    objET_GS.Scheme_Name_Policy_Name__c = objNewAAP.Asset_Name__c;
                    objET_GS.Approve_Action_Plan__c = objNewAAP.Id;
                    objET_GS.Goal__c = objNewAAP.Goal__c;
                    objET_GS.Type__c = 'Lumpsum';
                    objET_GS.Investor_Name_as_in_PAN_card__c = objNewAAP.Account__r.FirstName +' '+ objNewAAP.Account__r.LastName;
                    objET_GS.Mobile__c = objNewAAP.Account__r.PersonMobilePhone;
                    objET_GS.Email__c = objNewAAP.Account__r.PersonEmail;
                    objET_GS.DOB__c = objNewAAP.Account__r.PersonBirthdate;
                    objET_GS.PAN__c = objNewAAP.Account__r.PAN_ID__pc;
                    objET_GS.Account_Number__c = objNewAAP.Account__r.Bank_Account_Number2__c;
                    objET_GS.Bank_Name__c = objNewAAP.Account__r.Bank_Name__c;
                    objET_GS.Branch_Address__c = objNewAAP.Account__r.Branch_details__c;
                    objET_GS.Account_Type__c = objNewAAP.Account__r.Bank_Account_Type__c;
                    objET_GS.MICR_Code__c = objNewAAP.Account__r.MICR_Number__c;
                    objET_GS.IFSC_Code__c = objNewAAP.Account__r.IFSC_Number__c; 
                    objET_GS.Renewal_Date__c = objNewAAP.Account__r.Renewal_Date__c;
                   // objET_GS.Communication_Address__c = strAddress;
                    lstETrecords.add(objET_GS); 
	            }
	            else if (objOldAAP.isGS_ExecutionTracker__c && !objNewAAP.isGS_ExecutionTracker__c)// if old is true and new is false - then delete Et
	            {
	            	if(mapApIdToET.containsKey(objNewAAP.Id+'GS_Lumpsum'))
                    {
                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'GS_Lumpsum'));
                    }
	            }
	            
	            //Gold & Silver Running SIP's
	            if(!objOldAAP.isGSsip_ExecutionTracker__c && objNewAAP.isGSsip_ExecutionTracker__c) // if old is false and new is true
	            {
	            	Execution_Tracker__c objET_GS_SIP = new Execution_Tracker__c();
	            	objET_GS_SIP.Entity_Name__c = objNewAAP.Account__c;
                	objET_GS_SIP.ET_Status__c = 'Assigned to MET';
                	objET_GS_SIP.Suggested_Amount__c = objNewAAP.SIP_Action_Amount__c;
                    objET_GS_SIP.Actual_Action_Amount__c = objNewAAP.SIP_Action_Amount__c;
                    objET_GS_SIP.Agreed_Amount_Base_Amount__c = objNewAAP.SIP_Action_Amount__c;
                    objET_GS_SIP.Amount__c = objNewAAP.Current_SIP__c;
                    objET_GS_SIP.Investor_Name_as_in_PAN_card__c = objNewAAP.Account__r.FirstName +' '+ objNewAAP.Account__r.LastName;
                    objET_GS_SIP.Scheme_Name_Policy_Name__c = objNewAAP.Asset_name__c;
                    objET_GS_SIP.Agreed_Amount__c = objET_GS_SIP.Suggested_Amount__c;
                    objET_GS_SIP.Executed_Product_Name__c =  objNewAAP.Asset_name__c;
                 	objET_GS_SIP.Action__c = objNewAAP.SIP_Action__c;
                 	objET_GS_SIP.Approve_Action_Plan__c = objNewAAP.Id;
                    objET_GS_SIP.Goal__c = objNewAAP.Goal__c;
                    objET_GS_SIP.Type__c = 'SIP';
                    objET_GS_SIP.Mobile__c = objNewAAP.Account__r.PersonMobilePhone;
                    objET_GS_SIP.Email__c = objNewAAP.Account__r.PersonEmail;
                    objET_GS_SIP.DOB__c = objNewAAP.Account__r.PersonBirthdate;
                    objET_GS_SIP.PAN__c = objNewAAP.Account__r.PAN_ID__pc;
                    objET_GS_SIP.Account_Number__c = objNewAAP.Account__r.Bank_Account_Number2__c;
                    objET_GS_SIP.Bank_Name__c = objNewAAP.Account__r.Bank_Name__c;
                    objET_GS_SIP.Branch_Address__c = objNewAAP.Account__r.Branch_details__c;
                    objET_GS_SIP.Account_Type__c = objNewAAP.Account__r.Bank_Account_Type__c;
                    objET_GS_SIP.MICR_Code__c = objNewAAP.Account__r.MICR_Number__c;
                    objET_GS_SIP.IFSC_Code__c = objNewAAP.Account__r.IFSC_Number__c;
                    objET_GS_SIP.Renewal_Date__c = objNewAAP.Account__r.Renewal_Date__c;
                    //objET_GS_SIP.Communication_Address__c = strAddress;
                    lstETrecords.add(objET_GS_SIP);
	            }
	            else if (objOldAAP.isGSsip_ExecutionTracker__c && !objNewAAP.isGSsip_ExecutionTracker__c)// if old is true and new is false - then delete Et
	            {
	            	if(mapApIdToET.containsKey(objNewAAP.Id+'GS_SIP'))
                    {
                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'GS_SIP'));
                    }
	            }
	            
	            //Mutual Fund Lumpsum
			 	if(!objOldAAP.isExecutionTracker__c && objNewAAP.isExecutionTracker__c) // if old is false and new is true
	            {
	            	Execution_Tracker__c objET_MF = new Execution_Tracker__c();	
	        	   	objET_MF.Entity_Name__c = objNewAAP.Account__c;
	            	objET_MF.ET_Status__c = 'Assigned to MET';
	            	objET_MF.Action__c = objNewAAP.Lumpsum_Action__c;
	                objET_MF.Suggested_Amount__c = objNewAAP.Action_Amount__c;
	                objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
	                objET_MF.Actual_Action_Amount__c = objNewAAP.Action_Amount__c;
	                objET_MF.Agreed_Amount_Base_Amount__c = objNewAAP.Action_Amount__c;
	                objET_MF.Amount__c = objNewAAP.Amount__c;
	                objET_MF.Approve_Action_Plan__c = objNewAAP.Id;
	                objET_MF.Goal__c = objNewAAP.Goal__c;
	                objET_MF.Type__c = 'Lumpsum';
	                objET_MF.Investor_Name_as_in_PAN_card__c = objNewAAP.Account__r.FirstName +' '+ objNewAAP.Account__r.LastName;
	                objET_MF.Mobile__c = objNewAAP.Account__r.PersonMobilePhone;
	                objET_MF.Email__c = objNewAAP.Account__r.PersonEmail;
	                objET_MF.DOB__c = objNewAAP.Account__r.PersonBirthdate;
	                objET_MF.PAN__c = objNewAAP.Account__r.PAN_ID__pc;
	                objET_MF.Account_Number__c = objNewAAP.Account__r.Bank_Account_Number2__c;
	                objET_MF.Bank_Name__c = objNewAAP.Account__r.Bank_Name__c;
	                objET_MF.Branch_Address__c = objNewAAP.Account__r.Branch_details__c;
	                objET_MF.Account_Type__c = objNewAAP.Account__r.Bank_Account_Type__c;
	                objET_MF.MICR_Code__c = objNewAAP.Account__r.MICR_Number__c;
	                objET_MF.Scheme_Name_Policy_Name__c = objNewAAP.Scheme_Name__c;
	                objET_MF.IFSC_Code__c = objNewAAP.Account__r.IFSC_Number__c; 
	                objET_MF.Renewal_Date__c = objNewAAP.Account__r.Renewal_Date__c;
	               // objET_MF.Communication_Address__c = strAddress;
	                objET_MF.Executed_Product_Name__c = objNewAAP.Scheme_Name__c;
	                system.debug('-----workStationOwnerId-----'+workStationOwnerId);
	            	objET_MF.Owner__c = workStationOwnerId;
	            	system.debug('-----workStationOwnerId-----'+workStationOwnerId);
	                lstETrecords.add(objET_MF); 
	            }
	            else if (objOldAAP.isExecutionTracker__c && !objNewAAP.isExecutionTracker__c)// if old is true and new is false - then delete Et
	            {
	            	if(mapApIdToET.containsKey(objNewAAP.Id+'MF_Lumpsum'))
                    {
                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'MF_Lumpsum'));
                    }
	            }
	            
	            //Mutual Fund Running SIP & SIP Funds
                if(!objOldAAP.isSIPexecutionTracker__c && objNewAAP.isSIPexecutionTracker__c)
                {
                	Execution_Tracker__c objET_MF = new Execution_Tracker__c();
                    if(objNewAAP.Investment_Asset__c != null)
                    {
	                	objET_MF.Entity_Name__c = objNewAAP.Account__c;
	                	objET_MF.ET_Status__c = 'Assigned to MET';
	                	objET_MF.Suggested_Amount__c = objNewAAP.SIP_Action_Amount__c;
	                    objET_MF.Actual_Action_Amount__c = objNewAAP.SIP_Action_Amount__c;
	                    objET_MF.Agreed_Amount_Base_Amount__c = objNewAAP.SIP_Action_Amount__c;
	                    objET_MF.Amount__c = objNewAAP.Current_SIP__c;
	                    objET_MF.Investor_Name_as_in_PAN_card__c = objNewAAP.Account__r.FirstName +' '+ objNewAAP.Account__r.LastName;
	                    objET_MF.Scheme_Name_Policy_Name__c = objNewAAP.Scheme_Name__c;
	                    
	                    /*Below change done by Gaurav - 7/2/2013 
	                      Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
	                      Purpose: Execution Tracker changes 
	                    */
	                    objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
	                    objET_MF.Executed_Product_Name__c =  objNewAAP.Scheme_Name__c;
	                    //Added on 22/3/13 : Aditi Satpute : To open different screens depending on Action for Ops Team
	                 	objET_MF.Action__c = objNewAAP.SIP_Action__c;
                    }
                    else//SIP Funds
                    {
                    	objET_MF.Entity_Name__c = objNewAAP.Account__c;
                    	objET_MF.ET_Status__c = 'Assigned to MET';
                    	objET_MF.Suggested_Amount__c = objNewAAP.Amount__c;
                        objET_MF.Actual_Action_Amount__c = objNewAAP.Amount__c;
                        objET_MF.Agreed_Amount_Base_Amount__c = objNewAAP.Amount__c;
                        objET_MF.Option__c = objNewAAP.Option__c;
                        objET_MF.Transaction_Type__c = objNewAAP.Transaction_Type__c;
                        objET_MF.SIP_Installments__c = objNewAAP.Installments__c;
                        objET_MF.Scheme_Name_Policy_Name__c = objNewAAP.Product_Name__c;
                        
                        /*Below change done by Gaurav - 7/2/2013 
                          Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
                          Purpose: Execution Tracker changes 
                        */
                        objET_MF.Executed_Product_Name__c = objNewAAP.Product_Name__c;
                        objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
                         //Added on : 20/3/13 : Aditi Satpute : ET Screen Changes
						objET_MF.Agreed_Installments__c = objNewAAP.Installments__c;
                    }
                    objET_MF.Approve_Action_Plan__c = objNewAAP.Id;
                    objET_MF.Goal__c = objNewAAP.Goal__c;
                    objET_MF.Type__c = 'SIP';
                    objET_MF.Mobile__c = objNewAAP.Account__r.PersonMobilePhone;
                    objET_MF.Email__c = objNewAAP.Account__r.PersonEmail;
                    objET_MF.DOB__c = objNewAAP.Account__r.PersonBirthdate;
                    objET_MF.PAN__c = objNewAAP.Account__r.PAN_ID__pc;
                    objET_MF.Account_Number__c = objNewAAP.Account__r.Bank_Account_Number2__c;
                    objET_MF.Bank_Name__c = objNewAAP.Account__r.Bank_Name__c;
                    objET_MF.Branch_Address__c = objNewAAP.Account__r.Branch_details__c;
                    objET_MF.Account_Type__c = objNewAAP.Account__r.Bank_Account_Type__c;
                    objET_MF.MICR_Code__c = objNewAAP.Account__r.MICR_Number__c;
                    objET_MF.IFSC_Code__c = objNewAAP.Account__r.IFSC_Number__c;
                    objET_MF.Renewal_Date__c = objNewAAP.Account__r.Renewal_Date__c;
                    //objET_MF.Communication_Address__c = strAddress;
                    objET_MF.Owner__c = workStationOwnerId;
	            	system.debug('-----workStationOwnerId-----'+workStationOwnerId);
                    lstETrecords.add(objET_MF);
                }
                else if (objOldAAP.isSIPexecutionTracker__c && !objNewAAP.isSIPexecutionTracker__c)// if old is true and new is false - then delete Et
	            {
	            	if(objNewAAP.Investment_Asset__c != null)
                    {
                    	if(mapApIdToET.containsKey(objNewAAP.Id+'MF_SIP'))
	                    {
	                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id+'MF_SIP'));
	                    }
                    }
                    else
                    {
                    	if(mapApIdToET.containsKey(objNewAAP.Id))
	                    {
	                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id));
	                    }
                    }
	            	
	            }
	            
	            //Lumpsum Funds
                if(!objOldAAP.isLumpsumExecTracker__c && objNewAAP.isLumpsumExecTracker__c)
                {
            	 	Execution_Tracker__c objET_MF = new Execution_Tracker__c();
            	 	objET_MF.Entity_Name__c = objNewAAP.Account__c;
            		objET_MF.ET_Status__c = 'Assigned to MET';
                	objET_MF.Suggested_Amount__c = objNewAAP.Amount__c;
                    objET_MF.Actual_Action_Amount__c = objNewAAP.Amount__c;
                    objET_MF.Agreed_Amount_Base_Amount__c = objNewAAP.Amount__c;
                    objET_MF.Option__c = objNewAAP.Option__c;
                    objET_MF.Transaction_Type__c = objNewAAP.Transaction_Type__c;
                    objET_MF.Executed_Product_Name__c =  objNewAAP.Product_Name__c;
                    objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
                    objET_MF.Agreed_Amount_Per_Installment__c = objNewAAP.Amount_Per_Installment__c;
					objET_MF.Agreed_Installments__c = objNewAAP.Installments__c;
					objET_MF.Agreed_Scheme_Name_to__c = objNewAAP.Fund__c;
					objET_MF.Approve_Action_Plan__c = objNewAAP.Id;
                    objET_MF.Goal__c = objNewAAP.Goal__c;
                    objET_MF.Type__c = 'Lumpsum';
                    objET_MF.Mobile__c = objNewAAP.Account__r.PersonMobilePhone;
                    objET_MF.Email__c = objNewAAP.Account__r.PersonEmail;
                    objET_MF.DOB__c = objNewAAP.Account__r.PersonBirthdate;
                    objET_MF.PAN__c = objNewAAP.Account__r.PAN_ID__pc;
                    objET_MF.Account_Number__c = objNewAAP.Account__r.Bank_Account_Number2__c;
                    objET_MF.Bank_Name__c = objNewAAP.Account__r.Bank_Name__c;
                    objET_MF.Branch_Address__c = objNewAAP.Account__r.Branch_details__c;
                    objET_MF.Account_Type__c = objNewAAP.Account__r.Bank_Account_Type__c;
                    objET_MF.MICR_Code__c = objNewAAP.Account__r.MICR_Number__c;
                    objET_MF.IFSC_Code__c = objNewAAP.Account__r.IFSC_Number__c;
                    objET_MF.Renewal_Date__c = objNewAAP.Account__r.Renewal_Date__c;
                    objET_MF.Scheme_Name_Policy_Name__c = objNewAAP.Product_Name__c;
                    //objET_MF.Communication_Address__c = strAddress;
                    objET_MF.Owner__c = workStationOwnerId;
	            	system.debug('-----workStationOwnerId-----'+workStationOwnerId);
                    lstETrecords.add(objET_MF);
                }
                else if (objOldAAP.isLumpsumExecTracker__c && !objNewAAP.isLumpsumExecTracker__c)// if old is true and new is false - then delete Et
	            {
	            	if(mapApIdToET.containsKey(objNewAAP.Id))
                    {
                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id));
                    }
	            }
	            //Life Insurance, Recommended & General Insurance
                if(!objOldAAP.isInsuranceExecutionTracker__c && objNewAAP.isInsuranceExecutionTracker__c)
                {
                	if(objNewAAP.Item_Type__c.equals('Life Insurance') || objNewAAP.Item_Type__c.equals('General Insurance'))
                	{
                        Execution_Tracker__c objET_MF = new Execution_Tracker__c();
                        objET_MF.Entity_Name__c = objNewAAP.Account__c;
                    	objET_MF.ET_Status__c = 'Assigned to MET';
                    	if(objNewAAP.Item_Type__c.equals('Life Insurance'))
                        {
                            objET_MF.Policy_Name__c = objNewAAP.Policy_Name__c;
                            objET_MF.Scheme_Name_Policy_Name__c = objNewAAP.Policy_Name__c;
			   				objET_MF.Term_No_Of_Years__c = objNewAAP.Tenure_of_Insurance__c;
			   				if(objNewAAP.Insurance__r.Entity__r.LastName == null)
			          		{
			          			objET_MF.Insured_Name__c = objNewAAP.Insurance__r.Entity__r.FirstName;
			          		}
			          		else if(objNewAAP.Insurance__r.Entity__r.FirstName == null )
			          		{
			          			objET_MF.Insured_Name__c = objNewAAP.Insurance__r.Entity__r.LastName;
			          		}
			          		else if(objNewAAP.Insurance__r.Entity__r.LastName != null && objNewAAP.Insurance__r.Entity__r.FirstName != null)
			          		{
			          			objET_MF.Insured_Name__c = objNewAAP.Insurance__r.Entity__r.FirstName +' '+ objNewAAP.Insurance__r.Entity__r.LastName;
			          		}
			          		else 
			          		{
			          			objET_MF.Insured_Name__c = '';
			          		}
                           	objET_MF.Executed_Product_Name__c = objNewAAP.Policy_Name__c != null ? objNewAAP.Policy_Name__c : objNewAAP.Insurance__r.Policy_Type__c;
                            objET_MF.Suggested_Amount__c = objNewAAP.Sum_Assured_Rs__c;
                            objET_MF.Actual_Action_Amount__c = objNewAAP.Sum_Assured_Rs__c;
                            objET_MF.Agreed_Amount_Base_Amount__c = objNewAAP.Sum_Assured_Rs__c;
                            objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
			   				objET_MF.Sum_Assured__c = objNewAAP.Sum_Assured_Rs__c;
                        }
                        else
                        {
							objET_MF.Policy_Name__c = objNewAAP.Product_Name__c;
							objET_MF.Scheme_Name_Policy_Name__c = objNewAAP.Product_Name__c;
							objET_MF.Executed_Product_Name__c = objNewAAP.Product_Name__c!=null ? objNewAAP.Product_Name__c:objNewAAP.Policy_Type__c;
							objET_MF.Sum_Assured__c = objNewAAP.Sum_Assured_Rs__c;
							objET_MF.Asset_Class_Policy_Type__c = objNewAAP.Policy_Type__c;
							objET_MF.Insured_Name__c = objNewAAP.Insured__c;
                            objET_MF.Suggested_Amount__c =  objET_MF.Sum_Assured__c;
                         	objET_MF.Actual_Action_Amount__c = objET_MF.Sum_Assured__c;
                         	objET_MF.Agreed_Amount_Base_Amount__c = objET_MF.Sum_Assured__c;
                            objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
                        }
                        objET_MF.Approve_Action_Plan__c = objNewAAP.Id;
                        objET_MF.Goal__c = objNewAAP.Goal__c;
                        objET_MF.Type__c = objNewAAP.Item_Type__c;
                        objET_MF.Asset_Class_Policy_Type__c = objNewAAP.Insurance__r.Policy_Type__c;
                        objET_MF.Policy_Number__c = objNewAAP.Insurance__r.Policy_Number__c;
                        objET_MF.Mobile__c = objNewAAP.Account__r.PersonMobilePhone;
                        objET_MF.Email__c = objNewAAP.Account__r.PersonEmail;
                        objET_MF.DOB__c = objNewAAP.Account__r.PersonBirthdate;
                        objET_MF.PAN__c = objNewAAP.Account__r.PAN_ID__pc;
                        objET_MF.Account_Number__c = objNewAAP.Account__r.Bank_Account_Number2__c;
                        objET_MF.Bank_Name__c = objNewAAP.Account__r.Bank_Name__c;
                        objET_MF.Branch_Address__c = objNewAAP.Account__r.Branch_details__c;
                        objET_MF.Account_Type__c = objNewAAP.Account__r.Bank_Account_Type__c;
                        objET_MF.MICR_Code__c = objNewAAP.Account__r.MICR_Number__c;
                        objET_MF.IFSC_Code__c = objNewAAP.Account__r.IFSC_Number__c;
                        objET_MF.Renewal_Date__c = objNewAAP.Account__r.Renewal_Date__c;
                       // objET_MF.Communication_Address__c = strAddress;
                        lstETrecords.add(objET_MF);
                	}
                	else if(objNewAAP.Item_Type__c.equals('Recommended Insurance'))
                    {
                    	Execution_Tracker__c objET_MF = new Execution_Tracker__c();
                    	objET_MF.Entity_Name__c = objNewAAP.Account__c;
                    	objET_MF.ET_Status__c = 'Assigned to MET';
                    	objET_MF.Executed_Product_Name__c = objNewAAP.Insurance__r.Insurance_Company__c;
		          		objET_MF.Policy_Name__c = objNewAAP.Insurance__r.Policy_Name__c;
                        objET_MF.Scheme_Name_Policy_Name__c = objNewAAP.Insurance__r.Policy_Name__c;
                        objET_MF.Asset_Class_Policy_Type__c = objNewAAP.Insurance__r.Policy_Type__c;
                        objET_MF.Premium__c  = objNewAAP.Insurance__r.Premium_Amount_Rs__c;
                        objET_MF.Suggested_Amount__c = objNewAAP.Insurance__r.Surrender_Cash_Value__c;
                        objET_MF.Actual_Action_Amount__c = objNewAAP.Insurance__r.Surrender_Cash_Value__c;
                        objET_MF.Agreed_Amount_Base_Amount__c = objNewAAP.Insurance__r.Surrender_Cash_Value__c;
                        //Tracker is opened for this value : Surrender Cash Value
                        objET_MF.Agreed_Amount__c = objNewAAP.Insurance__r.Surrender_Cash_Value__c;
                        objET_MF.Approve_Action_Plan__c = objNewAAP.Id;
                        objET_MF.Goal__c = objNewAAP.Goal__c;
                        
                        objET_MF.Type__c = objNewAAP.Item_Type__c;
                        if(objNewAAP.Insurance__r.Entity__r.LastName == null)
		          		{
		          			objET_MF.Insured_Name__c = objNewAAP.Insurance__r.Entity__r.FirstName;
		          			objET_MF.Nominee__c = objNewAAP.Insurance__r.Entity__r.FirstName;
		          			
		          		}
		          		else if(objNewAAP.Insurance__r.Entity__r.FirstName == null )
		          		{
		          			objET_MF.Insured_Name__c = objNewAAP.Insurance__r.Entity__r.LastName;
	          				objET_MF.Nominee__c = objNewAAP.Insurance__r.Entity__r.LastName;
		          		}
		          		else if(objNewAAP.Insurance__r.Entity__r.LastName != null && objNewAAP.Insurance__r.Entity__r.FirstName != null)
		          		{
		          			objET_MF.Insured_Name__c = objNewAAP.Insurance__r.Entity__r.FirstName +' '+ objNewAAP.Insurance__r.Entity__r.LastName;
	          				objET_MF.Nominee__c = objNewAAP.Insurance__r.Entity__r.FirstName +' '+ objNewAAP.Insurance__r.Entity__r.LastName;
		          		}
		          		else 
		          		{
		          			objET_MF.Insured_Name__c = '';
	          				objET_MF.Nominee__c = '';
		          		}
                    	objET_MF.Policy_Number__c = objNewAAP.Insurance__r.Policy_Number__c;
                        objET_MF.Mobile__c = objNewAAP.Account__r.PersonMobilePhone;
                        objET_MF.Email__c = objNewAAP.Account__r.PersonEmail;
                        objET_MF.DOB__c = objNewAAP.Account__r.PersonBirthdate;
                        objET_MF.PAN__c = objNewAAP.Account__r.PAN_ID__pc;
                        objET_MF.Account_Number__c = objNewAAP.Account__r.Bank_Account_Number2__c;
                        objET_MF.Bank_Name__c = objNewAAP.Account__r.Bank_Name__c;
                        objET_MF.Branch_Address__c = objNewAAP.Account__r.Branch_details__c;
                        objET_MF.Account_Type__c = objNewAAP.Account__r.Bank_Account_Type__c;
                        objET_MF.MICR_Code__c = objNewAAP.Account__r.MICR_Number__c;
                        objET_MF.IFSC_Code__c = objNewAAP.Account__r.IFSC_Number__c;
                        objET_MF.Renewal_Date__c = objNewAAP.Account__r.Renewal_Date__c;
                        //objET_MF.Communication_Address__c = strAddress;
                        lstETrecords.add(objET_MF);
                    }
                	
                }
                else if (objOldAAP.isInsuranceExecutionTracker__c && !objNewAAP.isInsuranceExecutionTracker__c)// if old is false and new is true - then delete Et
	            {
	            	if(mapApIdToET.containsKey(objNewAAP.Id))
                    {
                    	lstdeleteETrecords.addAll(mapApIdToET.get(objNewAAP.Id));
                    }
	            }
				
			}
			if(!lstETrecords.isEmpty())
				insert lstETrecords;
			if(!lstdeleteETrecords.isEmpty())
				delete lstdeleteETrecords;
        	}
        }
	}

}