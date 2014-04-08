trigger UpdatePlatformUserLeadDetails on Lead (after update,before delete) 
{
    if(Trigger.isUpdate)
    {
        List<Lead_Platform_User__c> lstCustLead = new List<Lead_Platform_User__c>(); 
        List<Lead_Platform_User__c> updateLstCustLead = new List<Lead_Platform_User__c>(); 
        List<Lead> lstLead = trigger.new;
        boolean flag = false;
        
        if (!PlatformUserLeadDetailsController.hasAlreadyCreatedFollowUpTasks()) 
        {
            Set<Id> LeadIdSet = new Set<Id>(); // Define a new set  
            for(Lead objlead : lstLead)
            {
                   LeadIdSet.add(objlead.Platform_User_Lead__c);
            }
            
            lstCustLead = [select Id from Lead_Platform_User__c where Id in : LeadIdSet];
            Map<Id,Lead_Platform_User__c> mapLeadPlatformUser= new Map<Id,Lead_Platform_User__c>();
            for(Lead_Platform_User__c Customlead : lstCustLead)
            {
                 //start of if loop for checking lead.Platform_User_Lead__c i.e Id of Custom lead in Map
                if(!(mapLeadPlatformUser.containsKey(Customlead.Id)))
                {
                     mapLeadPlatformUser.put(Customlead.Id,Customlead);
                }
            }
            
            for(Lead newobjLead : lstLead)
            {
                if(mapLeadPlatformUser.containsKey(newobjLead.Platform_User_Lead__c))
                {
                    Lead_Platform_User__c updateCustLeadObj= mapLeadPlatformUser.get(newobjLead.Platform_User_Lead__c);
                
                    system.debug('*****updateCustLeadObj*********'+updateCustLeadObj);
                    
                    updateCustLeadObj.Age__c = newobjLead.Age__c;
                    updateCustLeadObj.Appointment_Time__c = newobjLead.Appointment_Time__c;
                    updateCustLeadObj.Alternate_Mobile__c = newobjLead.Alternate_Mobile__c;
                    //updateCustLeadObj.Appointment_SMS__c = newobjLead.Appointment_SMS__c ;
                    
                    updateCustLeadObj.Close_Date__c = newobjLead.Close_Date__c ;
                    updateCustLeadObj.Company_Name__c = newobjLead.Company_Name__c ;
                    updateCustLeadObj.Christmas_Flag__c = newobjLead.Christmas_Flag__c ;
                    updateCustLeadObj.City__c = newobjLead.City ;
                    updateCustLeadObj.Company__c = newobjLead.Company;
                    updateCustLeadObj.Country__c = newobjLead.Country ;
                    updateCustLeadObj.Description__c = newobjLead.Description;
                    updateCustLeadObj.Do_Not_Call__c = newobjLead.DoNotCall;
                    
                    updateCustLeadObj.Email__c = newobjLead.Email;
                    updateCustLeadObj.First_Name__c = newobjLead.FirstName;
                    updateCustLeadObj.Ffreedom_Score__c = newobjLead.Ffreedom_Score__c;
                    updateCustLeadObj.Ffreedom_Score_Explanation__c = newobjLead.Ffreedom_Score_Explanation__c ;
                    updateCustLeadObj.HasOptedOutOfEmail__c = newobjLead.HasOptedOutOfEmail;
                    updateCustLeadObj.Ideal_time_to_call__c = newobjLead.Ideal_time_to_call__c ;
                    updateCustLeadObj.Industry__c = newobjLead.Industry;
                    updateCustLeadObj.IsLeadCreatedByPartner__c = newobjLead.IsLeadCreatedByPartner__c ;
                    
                    //need to comment below
                    //updateLeadObj.Related_To__c = objCustLead.Related_To__c;
                    updateCustLeadObj.Virtual_Partner__c = newobjLead.Virtual_Partner__c;
                    
                    updateCustLeadObj.IsUnsubscribe__c = newobjLead.IsUnsubscribe__c ;
                    updateCustLeadObj.Interested_In__c = newobjLead.Interested_In__c ;
                    
                    //updateCustLeadObj.Latest_Campaign__c = newobjLead.Latest_Campaign__c ;
                    updateCustLeadObj.Lead_Engine_Type__c = newobjLead.Lead_Engine_Type__c ;
                    updateCustLeadObj.Location__c = newobjLead.Location__c ;
                    updateCustLeadObj.Lead_Source__c = newobjLead.LeadSource;
                    updateCustLeadObj.Name = newobjLead.LastName;
                    updateCustLeadObj.Meeting__c = newobjLead.Meeting__c ;
                    updateCustLeadObj.Mobile__c = newobjLead.MobilePhone;
                    
                    updateCustLeadObj.Occupation__c = newobjLead.Occupation__c ;
                    updateCustLeadObj.Zip_Postal_Code__c = newobjLead.PostalCode;
                    updateCustLeadObj.Preferred_location__c = newobjLead.Preferred_location__c ;
                    updateCustLeadObj.PreferredDepartment__c = newobjLead.PreferredDepartment__c ;
                    //updateCustLeadObj.Id = newobjLead.Platform_User_Lead__c;
                    updateCustLeadObj.Probability__c = newobjLead.Probability__c;
                    updateCustLeadObj.Rating__c = newobjLead.Rating;
                    updateCustLeadObj.RecordTypeId = newobjLead.RecordTypeId ;
                    updateCustLeadObj.Referred_By__c = newobjLead.Referred_By__c ;
                    updateCustLeadObj.Salutation__c = newobjLead.Salutation;
                    updateCustLeadObj.State_Province__c = newobjLead.State;
                    updateCustLeadObj.Status_Change_Date__c = newobjLead.Status_Change_Date__c ;
                    updateCustLeadObj.Street__c = newobjLead.Street;
                    updateCustLeadObj.Title__c = newobjLead.Title;
                    updateCustLeadObj.Tribal_Activity_Flag__c = newobjLead.Tribal_Activity_Flag__c ;
                    updateCustLeadObj.Lead_Status__c = newobjLead.Status;
                    updateCustLeadObj.Is_converted__c = newobjLead.IsConverted ;
                    
                    updateLstCustLead.add(updateCustLeadObj);
                }
            }
        }
        PlatformUserLeadDetailsController.setAlreadyCreatedFollowUpTasks();
        update updateLstCustLead;
    }
    
    if(Trigger.isDelete)
    {
        //PlatformUserLeadDetailsController.DeleteStandardLeadDetails(trigger.old);
        List<Lead> lstLead = trigger.old;
        List<Lead_Platform_User__c> lstCustLead= new List<Lead_Platform_User__c>();
        Set<Id> LeadIdSet = new Set<Id>(); // Define a new set  
        
        if (!PlatformUserLeadDetailsController.hasAlreadyCreatedFollowUpTasks()) 
        {
            for(Lead objlead : lstLead)
            {
                   LeadIdSet.add(objlead.Platform_User_Lead__c);
            }
            lstCustLead = [select Id from Lead_Platform_User__c where Id in : LeadIdSet];
        }
        PlatformUserLeadDetailsController.setAlreadyCreatedFollowUpTasks();
        Database.delete(lstCustLead);       
    }
}


//Update without bulksafe
            //PlatformUserLeadDetailsController.UpdatePlatformUserLeadDetailUpdate(trigger.new);
        /*  system.debug('****new lstLead in if*****'+lstLead);
            Lead_Platform_User__c objCustLead = new Lead_Platform_User__c();
            objCustLead = [select Id from Lead_Platform_User__c where Id =: lstLead[0].Platform_User_Lead__c];
            system.debug('*****objCustLead*********'+objCustLead);
            objCustLead.Name = lstLead[0].LastName;
            objCustLead.Lead_Status__c = lstLead[0].Status;
            objCustLead.Age__c = lstLead[0].Age__c;
            objCustLead.Mobile__c = lstLead[0].MobilePhone;
            objCustLead.Lead_Source__c = lstLead[0].LeadSource;
            //objLead.Platform_User_Lead__c = lstCustLead[0].Id;
            lstCustLead.add(objCustLead);
            */
        //system.debug('******lstLead in CopyPlatformUserLeadDetailUpdate******'+lstLead);