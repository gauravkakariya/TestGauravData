public without sharing class PlatformUserLeadDetailsController 
{
	public static boolean alreadyCreatedTasks = false;
    public static boolean alreadyConvertedLead = false;
    public static boolean hasAlreadyCreatedFollowUpTasks() 
   	{
    	return alreadyCreatedTasks;
    }
    public static boolean CheckIsAlreadyConvertedLead() 
   	{
    	return alreadyConvertedLead;
    }
    //By setting the variable to true, it maintains this new value throughout the duration of the request (or testMethod)  
	public static void setAlreadyCreatedFollowUpTasks() 
	{
		alreadyCreatedTasks = true;
	}
	
	//Copy Insert new platform user lead 
	public static Void CopyPlatformUserLeadDetail(List<Lead_Platform_User__c> lstCustLead) // Insert call
	{
		List<Lead> lstLead = new List<Lead>(); 
		
		for(Lead_Platform_User__c custLead : lstCustLead)
		{
			Lead objLead = new Lead();
			
			objLead.Age__c = custLead.Age__c;
			objLead.Appointment_Time__c = custLead.Appointment_Time__c;
			objLead.Alternate_Mobile__c = custLead.Alternate_Mobile__c;
			//objLead.Appointment_SMS__c = custLead.Appointment_SMS__c ;
			
			objLead.Close_Date__c = custLead.Close_Date__c ;
			objLead.Company_Name__c = custLead.Company_Name__c ;
			objLead.Christmas_Flag__c = custLead.Christmas_Flag__c ;
			objLead.City = custLead.City__c ;
			objLead.Company = custLead.Company__c ;
			objLead.Country = custLead.Country__c ;
			objLead.Description = custLead.Description__c ;
			objLead.DoNotCall = custLead.Do_Not_Call__c ;
			
			objLead.Email = custLead.Email__c ;
			objLead.FirstName = custLead.First_Name__c ;
			objLead.Ffreedom_Score__c = custLead.Ffreedom_Score__c;
			objLead.Ffreedom_Score_Explanation__c = custLead.Ffreedom_Score_Explanation__c ;
			objLead.HasOptedOutOfEmail = custLead.HasOptedOutOfEmail__c ;
			objLead.Ideal_time_to_call__c = custLead.Ideal_time_to_call__c ;
			objLead.Industry = custLead.Industry__c ;
			objLead.IsLeadCreatedByPartner__c = custLead.IsLeadCreatedByPartner__c ;
		
			//need to comment below
			objLead.Virtual_Partner__c = custLead.Virtual_Partner__c;
		/*		if(objLead.Virtual_Partner__c != null)
			{
				objLead.Related_To__c = 'Virtual Partner';
			}
			*/
			objLead.IsUnsubscribe__c = custLead.IsUnsubscribe__c ;
			objLead.Interested_In__c = custLead.Interested_In__c ;
			
			//objLead.Latest_Campaign__c = custLead.Latest_Campaign__c ;
			objLead.Lead_Engine_Type__c = custLead.Lead_Engine_Type__c ;
			objLead.Location__c = custLead.Location__c ;
			objLead.LeadSource = custLead.Lead_Source__c;
			objLead.LastName = custLead.Name;
			objLead.Meeting__c = custLead.Meeting__c ;
			objLead.MobilePhone = custLead.Mobile__c;
			
			objLead.Occupation__c = custLead.Occupation__c ;
			objLead.PostalCode = custLead.Zip_Postal_Code__c ;
			objLead.Preferred_location__c = custLead.Preferred_location__c ;
			objLead.PreferredDepartment__c = custLead.PreferredDepartment__c ;
			objLead.Platform_User_Lead__c = custLead.Id;
			objLead.Probability__c = custLead.Probability__c;
			objLead.Rating = custLead.Rating__c;
			//objLead.RecordTypeId = custLead.RecordTypeId ;
			objLead.Referred_By__c = custLead.Referred_By__c ;
			objLead.Salutation = custLead.Salutation__c ;
			objLead.State = custLead.State_Province__c ;
			objLead.Status_Change_Date__c = custLead.Status_Change_Date__c ;
			objLead.Street = custLead.Street__c ;
			objLead.Title = custLead.Title__c ;
			objLead.Tribal_Activity_Flag__c = custLead.Tribal_Activity_Flag__c ;
			objLead.Status = custLead.Lead_Status__c;
			//objLead. = custLead. ;
			
			lstLead.add(objLead);
		}
		
		system.debug('*********Std Lead**********'+lstLead);
		insert lstLead;
	}
	
	//Copy Update platform user lead
	public static Void CopyPlatformUserLeadDetailUpdate(List<Lead_Platform_User__c> lstCustLead,Map<Id,Lead_Platform_User__c> mapOldCustLead) //Update call
	{  
		
		List<Lead> lstLead= new List<Lead>();
		List<Lead> updateLstLead= new List<Lead>();
		boolean flag = false;
		Set<Id> custLeadIdSet = new Set<Id>(); // Define a new set 	
		for(Lead_Platform_User__c objCustlead : lstCustLead)
    	{
        	   custLeadIdSet.add(objCustlead.Id);
        }
        lstLead = [select Id,Status,Platform_User_Lead__c,IsConverted from Lead where Platform_User_Lead__c in : custLeadIdSet];
        Map<Id,Lead> mapLeadStandardUser= new Map<Id,Lead>();
        for(Lead lead : lstLead)
    	{
        	if(!(mapLeadStandardUser.containsKey(lead.Platform_User_Lead__c)))
       		{
            	 mapLeadStandardUser.put(lead.Platform_User_Lead__c,lead);
        	}
        }
        for(Lead_Platform_User__c objCustLead : lstCustLead)
        {
        	if(mapLeadStandardUser.containsKey(objCustLead.Id))
        	{
        		Lead updateLeadObj= mapLeadStandardUser.get(objCustLead.Id);
        		//if(updateLeadObj.Status != 'Converted') //please check manasi//IsConverted
        		if(updateLeadObj.IsConverted != true) //please check manasi//
				{
					if(!mapOldCustLead.get(objCustLead.Id).Is_converted__c == true)
					{
						updateLeadObj.Age__c = objCustLead.Age__c;
						updateLeadObj.Appointment_Time__c = objCustLead.Appointment_Time__c;
						updateLeadObj.Alternate_Mobile__c = objCustLead.Alternate_Mobile__c;
						updateLeadObj.Appointment_SMS__c = objCustLead.Appointment_SMS__c ;
						
						updateLeadObj.Close_Date__c = objCustLead.Close_Date__c ;
						updateLeadObj.Company_Name__c = objCustLead.Company_Name__c ;
						updateLeadObj.Christmas_Flag__c = objCustLead.Christmas_Flag__c ;
						updateLeadObj.City = objCustLead.City__c ;
						updateLeadObj.Company = objCustLead.Company__c ;
						updateLeadObj.Country = objCustLead.Country__c ;
						updateLeadObj.Description = objCustLead.Description__c ;
						updateLeadObj.DoNotCall = objCustLead.Do_Not_Call__c ;
						
						updateLeadObj.Email = objCustLead.Email__c ;
						updateLeadObj.FirstName = objCustLead.First_Name__c ;
						updateLeadObj.Ffreedom_Score__c = objCustLead.Ffreedom_Score__c;
						updateLeadObj.Ffreedom_Score_Explanation__c = objCustLead.Ffreedom_Score_Explanation__c ;
						updateLeadObj.HasOptedOutOfEmail = objCustLead.HasOptedOutOfEmail__c ;
						updateLeadObj.Ideal_time_to_call__c = objCustLead.Ideal_time_to_call__c ;
						updateLeadObj.Industry = objCustLead.Industry__c ;
						updateLeadObj.IsLeadCreatedByPartner__c = objCustLead.IsLeadCreatedByPartner__c ;
						
						//need to comment below
						//updateLeadObj.Related_To__c = objCustLead.Related_To__c;
						updateLeadObj.Virtual_Partner__c = objCustLead.Virtual_Partner__c;
						/*if(updateLeadObj.Virtual_Partner__c != null)
						{
							updateLeadObj.Related_To__c = 'Virtual Partner';
						}*/
						
						updateLeadObj.IsUnsubscribe__c = objCustLead.IsUnsubscribe__c ;
						updateLeadObj.Interested_In__c = objCustLead.Interested_In__c ;
						
						//updateLeadObj.Latest_Campaign__c = objCustLead.Latest_Campaign__c ;
						updateLeadObj.Lead_Engine_Type__c = objCustLead.Lead_Engine_Type__c ;
						updateLeadObj.Location__c = objCustLead.Location__c ;
						updateLeadObj.LeadSource = objCustLead.Lead_Source__c;
						updateLeadObj.LastName = objCustLead.Name;
						updateLeadObj.Meeting__c = objCustLead.Meeting__c ;
						updateLeadObj.MobilePhone = objCustLead.Mobile__c;
						
						updateLeadObj.Occupation__c = objCustLead.Occupation__c ;
						updateLeadObj.PostalCode = objCustLead.Zip_Postal_Code__c ;
						updateLeadObj.Preferred_location__c = objCustLead.Preferred_location__c ;
						updateLeadObj.PreferredDepartment__c = objCustLead.PreferredDepartment__c ;
						updateLeadObj.Platform_User_Lead__c = objCustLead.Id;
						updateLeadObj.Probability__c = objCustLead.Probability__c;
						updateLeadObj.Rating = objCustLead.Rating__c;
						//updateLeadObj.RecordTypeId = objCustLead.RecordTypeId ;
						//updateLeadObj.Referred_By__c = objCustLead.Referred_By__c ;
						updateLeadObj.Salutation = objCustLead.Salutation__c ;
						updateLeadObj.State = objCustLead.State_Province__c ;
						//updateLeadObj.Status_Change_Date__c = objCustLead.Status_Change_Date__c ;
						updateLeadObj.Street = objCustLead.Street__c ;
						//updateLeadObj.Title = objCustLead.Title__c ;
						updateLeadObj.Tribal_Activity_Flag__c = objCustLead.Tribal_Activity_Flag__c ;
						updateLeadObj.Status = objCustLead.Lead_Status__c;
						
						system.debug('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH o');
	            		updateLstLead.add(updateLeadObj);
	            		flag=false;
	            		system.debug('****mapOldCustLead.get(objCustLead.Id).Is_converted__c***** : '+mapOldCustLead.get(objCustLead.Id).Is_converted__c);
						//system.debug('****mapOldCustLead.get(objCustLead.Id).Lead_Status__c != Completed***** : '+mapOldCustLead.get(objCustLead.Id).Lead_Status__c != 'Completed');
						if(objCustLead.Is_converted__c == true && mapOldCustLead.get(objCustLead.Id).Lead_Status__c != 'Converted')
						{
							system.debug('*****inside if loop*****');
							objCustLead.addError('Please select Status as converted before converting');
						}
					}
					/*else
					{
						system.debug('*****in else******');
						objCustLead.addError(' Cannot Update Lead once it is Converted');
						flag=true;
					}*/
				}
				/*else
				{
					system.debug('*****in else******');
					objCustLead.addError(' Cannot Update Lead once it is Converted');
					flag=true;
				}*/
        	}
        	
        }
        //if(flag == false)
		{
        	update updateLstLead;
		}
	}
	
	//Copy Delete platform user lead
	public static Void DeletePlatformUserLeadDetail(List<Lead_Platform_User__c> lstCustLead)
	{
		List<Lead> lstLead= new List<Lead>();
		Set<Id> custLeadIdSet = new Set<Id>(); // Define a new set 	
		system.debug('*******in delete****'+lstCustLead);
		boolean flag = false;
		if (!hasAlreadyCreatedFollowUpTasks()) 
		{
			for(Lead_Platform_User__c objCustlead : lstCustLead)
	    	{
	    		
	    		if(objCustlead.Is_converted__c != true)
	    		{
	        	   custLeadIdSet.add(objCustlead.Id);
	        	   flag = true;
	    		}
	    		else
	    		{
	    			objCustlead.addError('Cannot delete Record once it is Converted');
	    		}
	        }
		}
        lstLead = [select Id,Status,Platform_User_Lead__c from Lead where Platform_User_Lead__c in : custLeadIdSet];
        setAlreadyCreatedFollowUpTasks();
        system.debug('***list to delete****'+lstLead);
        if(flag == true)
        {
        	Database.delete(lstLead);
        }
	}

}


//wITHOUT Bulksafe

/*	public static Void CopyPlatformUserLeadDetailUpdate(List<Lead_Platform_User__c> lstCustLead)
	{
			if(lstCustLead[0].Lead_Status__c != 'Converted' )
			{
				List<Lead> lstLead = new List<Lead>(); 
				Lead objLead = new Lead();
				objLead = [select Id,Status from Lead where Platform_User_Lead__c =: lstCustLead[0].Id];
				if(objLead.Status != 'Converted')
				{
					system.debug('*****objLead*********'+objLead);
					objLead.LastName = lstCustLead[0].Name;
					objLead.Status = lstCustLead[0].Lead_Status__c;
					objLead.Age__c = lstCustLead[0].Age__c;
					objLead.MobilePhone = lstCustLead[0].Mobile__c;
					objLead.LeadSource = lstCustLead[0].Lead_Source__c;
					objLead.Rating = lstCustLead[0].Rating__c;
					objLead.Probability__c = lstCustLead[0].Probability__c;
					objLead.Appointment_Time__c = lstCustLead[0].Appointment_Time__c;
					objLead.Ffreedom_Score__c = lstCustLead[0].Ffreedom_Score__c;
					objLead.Company_Name__c = lstCustLead[0].Company_Name__c ;
					objLead.Close_Date__c = lstCustLead[0].Close_Date__c ;
					objLead.Email = lstCustLead[0].Email__c ;
					objLead.Interested_In__c = lstCustLead[0].Interested_In__c ;
					
					//objLead.Platform_User_Lead__c = lstCustLead[0].Id;
					lstLead.add(objLead);
					system.debug('*********Std Lead in Update**********'+lstLead);
					update lstLead;
				}
			}
		
	}*/
	
	//For delete old code
	/*	
	public static Void DeleteStandardLeadDetails(List<Lead> lstLead)
	{
		List<Lead_Platform_User__c> lstCustLead= new List<Lead_Platform_User__c>();
		Set<Id> LeadIdSet = new Set<Id>(); // Define a new set 	
		system.debug('*******in delete Std lstLead****'+lstLead);
		for(Lead objlead : lstLead)
    	{
        	   LeadIdSet.add(objlead.Platform_User_Lead__c);
        }
         lstCustLead = [select Id from Lead_Platform_User__c where Id in : LeadIdSet];
        system.debug('***list to delete lstCustLead ****'+lstCustLead);
        Database.delete(lstCustLead);
	}*/