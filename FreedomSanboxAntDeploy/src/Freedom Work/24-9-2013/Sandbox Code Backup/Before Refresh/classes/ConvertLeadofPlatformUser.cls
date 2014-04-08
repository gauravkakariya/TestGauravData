public without sharing class ConvertLeadofPlatformUser
{
    public static void convertCustomLead(MAp<Id,Lead_Platform_User__c> customLeadToConvertNewMap,List<Lead_Platform_User__c> customLeadToConvertList,MAp<Id,Lead_Platform_User__c> customLeadToConvertOldMap)
    {
        List<Lead> relatedStandardLeadList = new List<Lead>();
        //PlatformUserLeadDetailsController.CheckIsAlreadyConvertedLead();
        system.debug('DSSSSSSSSSSSSSSSS PlatformUserLeadDetailsController.alreadyConvertedLead: '+PlatformUserLeadDetailsController.CheckIsAlreadyConvertedLead());
        if(!PlatformUserLeadDetailsController.CheckIsAlreadyConvertedLead())
        {
            //flag added by Aditi :  need to check
            boolean flag ;
            Map<id,Lead> relatedStandardLeadMap = new Map<id,Lead>();
            if(customLeadToConvertNewMap != null)
                relatedStandardLeadList = [select id,Platform_User_Lead__c,IsConverted,OwnerId from lead where Platform_User_Lead__c =: customLeadToConvertNewMap.Keyset()];
            
            for(Lead objlead : relatedStandardLeadList){
                if(!relatedStandardLeadMap.containsKey(objlead.Platform_User_Lead__c))
                    relatedStandardLeadMap.put(objlead.Platform_User_Lead__c,objlead);
            }
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            
            List<Database.LeadConvert> leadConversionList= new List<Database.LeadConvert>();
            List<Lead> leadToConvertList = new List<Lead>(); 
            
            for(Lead_Platform_User__c objCustomLead : customLeadToConvertList)
            {
                if(!objCustomLead.Is_converted__c)
                  continue;
                  
                
                    Lead_Platform_User__c objOldCustomLead;
                    if(customLeadToConvertOldMap != null && customLeadToConvertOldMap.containsKey(objCustomLead.Id))
                        objOldCustomLead = customLeadToConvertOldMap.get(objCustomLead.Id);
                        
                    if(objOldCustomLead != null && !objOldCustomLead.Is_converted__c == true)
                    {
                        if(relatedStandardLeadMap.ContainsKey(objCustomLead.Id) && objCustomLead.Is_converted__c  == true && objCustomLead.Lead_Status__c == 'Converted')
                        {
                            Lead objLeadToConvert = relatedStandardLeadMap.get(objCustomLead.Id);
                            //leadConversionList.setLeadId(objLeadToConvert.id);
                            if(!objLeadToConvert.IsConverted)
                            {
                                Database.LeadConvert lc = new database.LeadConvert();
                                lc.setLeadId(objLeadToConvert.id);
                                lc.setOwnerId(objLeadToConvert.OwnerId);//Remove
                                leadConversionList.add(lc);
                                system.debug('SSSSSSSSSSSSSS:'+lc);
                                leadToConvertList.add(objLeadToConvert);
                            }
                        }
                        else
                        {
                            system.debug('*****in else******');
                            objCustomLead.addError(' Please select Status as converted before converting ');
                            flag=true;
                        }
                    }
                    else
                        objCustomLead.addError(' Cannot Update Lead once it is Converted');
                    //flag added by Aditi :  need to check
                    flag = true;
                
            }
            
            system.debug('leadConversionList=======>'+leadConversionList);
            PlatformUserLeadDetailsController.alreadyConvertedLead = true;
            for(Database.LeadConvert objlleadConvert : leadConversionList)
            {
                system.debug('!!!!!!!!!!!!!!!convertStatus.MasterLabel:'+objlleadConvert);
                //  try
                //  {
                //setOwnerId(l.OwnerId);//Remove
                
                if(objlleadConvert.getConvertedStatus() == null)
                {
                    system.debug('****in if **above***');
                //  objlleadConvert.setConvertedStatus(convertStatus.MasterLabel);
                    objlleadConvert.setConvertedStatus('Converted');
                    system.debug('====' + objlleadConvert.getConvertedStatus());
                    system.debug('****in if **below***');
                }
                //}
                //      catch(Exception s)
                //  {
                        system.debug('!!!!!!!!!!!!!!!!');
                //  }
            }
            
            for(Database.LeadConvert objlleadConvert : leadConversionList)
                system.debug('====== objlleadConvert : ' + objlleadConvert);
            
            List<Database.LeadConvertResult> leadConvertResultList = Database.convertLead(leadConversionList);
            system.debug('*****leadConvertResultList******'+leadConvertResultList);
            for(Database.LeadConvertResult obj : leadConvertResultList)
            {
                system.debug('Lead Conversion Result ' + obj);
            }
            
        // if condition added By Aditi : Need to check 
        //  if(flag!=true)
            //PlatformUserLeadDetailsController.CheckIsAlreadyConvertedLead();
            
        }
        else
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!:Else.........');
        
        /*if(PlatformUserLeadDetailsController.hasAlreadyCreatedFollowUpTasks())
        {
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!:IF.........');
            List<Database.LeadConvertResult> leadConvertResultList = Database.convertLead(leadConversionList);
        }
        else
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!:Else.........');
            PlatformUserLeadDetailsController.setAlreadyCreatedFollowUpTasks();*/
        
        /*if(!PlatformUserLeadDetailsController.CheckIsAlreadyConvertedLead())
        {
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!:IF.........');
            List<Database.LeadConvertResult> leadConvertResultList = Database.convertLead(leadConversionList);
        }
        else
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!:Else.........');
            PlatformUserLeadDetailsController.alreadyConvertedLead = true;*/
    //  }
        ////////////////////////////////////
        /*List<Lead_Platform_User__c> lstPlatformLeadsToConvert = new List<Lead_Platform_User__c>();
        Lead_Platform_User__c objPlatformUser = lstLeadConvert[0];
        Lead objLead = [select id from lead where Platform_User_Lead__c =: objPlatformUser.Id];
        system.debug('%%%%%%%%%%%%%%%%%%5 objLead:'+objLead);
        system.debug('%%%%%%%%%%%%%%%%%%5 objPlatformUser.Id:'+objPlatformUser.Id);
        if(objPlatformUser.Is_converted__c == true) ///
        {
            Database.LeadConvert lc = new database.LeadConvert();//
            lc.setLeadId(objLead.id);//
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1]; //
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
        }*/
    }
}