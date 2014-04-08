trigger AfterLeadUpdateTransferAttachment on Lead (after update)
{
    /*****
      Revision History:
      Version     Version     Author           Date          Comments
         1.0      Eternus    Dipak Nikam    15 Dec 2011      Initial Draft
      Summery : This Trigger transfers the all Attachment and XRayScoreCardDetails Record to respective Entity 
              after Lead conversion.     
    *****/
   
     //ADITI :  PP
     //1. Cretae Set of UserId
     set<Id> leadOwnerIdSet = new set<Id>();
     set<Id> contactIdSet = new set<Id>();
     set<id> convertedAccountId = new set<Id>();
     Map<id,id> convertedAccountIdToLeadOwnerIdMap = new Map<id,id>();
     //Added for Virtual Partner, Date : 04/09/12
     //need to comment below
     Map<id,Lead> convertedAccountIdToLeadMap = new Map<id,Lead>();
      
     for(Lead objLead : trigger.new){
       leadOwnerIdSet.add(objLead.ownerId);
       
      if(objLead.IsConverted)
        convertedAccountId.add(objLead.ConvertedAccountId);
      system.debug('****objLead.ConvertedAccountId******'+objLead.ConvertedAccountId+'Lead OwnerId : '+objLead.OwnerId);
      convertedAccountIdToLeadOwnerIdMap.put(objLead.ConvertedAccountId,objLead.ownerId);
      
      //need to comment below
      convertedAccountIdToLeadMap.put(objLead.ConvertedAccountId,objLead);
     }
     
     //2. 3. Create map <(userId,contactId)>
     /*List<User> lstUser= [select id,Name,...,contactId from User where id in userIdSet];
      Set<Id> contactIdSet;
      for(User u : lstUser  )
      {
        if(u.ContactId!=null)
        {    
          contactIdSet.add(u.ContactId);
        }
      }
     */
     //need to comment below part
     //===============================================================================================================================
     Map<Id,Account> MapConvertedAccount = new Map<Id,Account>([select id,Virtual_Partner__c from Account where Id in : convertedAccountIdToLeadMap.keySet()]);
     Map<Id,Account> mapVirtualIdToAccount = new Map<Id,Account>([select id,Virtual_Partner__c,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Default_Retirement_Age__c from Account ]);
         system.debug('******mapVirtualIdToAccount*******'+mapVirtualIdToAccount);
         Account objAcc;
            
         List<Entity_Global_Assumption__c> lstVirtualGlobalAssump = [select Expected_Return_on_Investment__c,Account__c,Income_Growth_Rate__c,Inflation_Rate__c,
         			Stock_Growth_Rate__c,Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */	
                    Number_Of_Months__c,Default_Retirement_Age__c,Default_Estimated_Life_Expectancy__c from Entity_Global_Assumption__c
                    where Account__c =: MapConvertedAccount.keySet()];      
                    
       Map<Id,Entity_Global_Assumption__c>  EntityIdToEntityVirtualGlobalAssumption = new   Map<Id,Entity_Global_Assumption__c>();
      
       for(Entity_Global_Assumption__c objEntityGlobalAssumption : lstVirtualGlobalAssump)    
       {
        if(!EntityIdToEntityVirtualGlobalAssumption.containsKey(objEntityGlobalAssumption.Account__c))
         EntityIdToEntityVirtualGlobalAssumption.put(objEntityGlobalAssumption.Account__c,objEntityGlobalAssumption);
       }         
          List<Entity_Global_Assumption__c> VirtualGlobalAssumptionList = new List<Entity_Global_Assumption__c>();
      Entity_Global_Assumption__c VirtualGlobalAssump;
            
     system.debug('********MapConvertedAccount********'+MapConvertedAccount);
     List<Account> AccountToUpdate = new List<Account>();
     Lead ToConvertLead = new Lead();
     for(Id accId : MapConvertedAccount.keySet())
     {
       Account a = MapConvertedAccount.get(accId);
       
       ToConvertLead = convertedAccountIdToLeadMap.get(a.id);
       if(ToConvertLead.Virtual_Partner__c != null)
      {
           a.Virtual_Partner__c = ToConvertLead.Virtual_Partner__c;
           AccountToUpdate.add(a);
           if(mapVirtualIdToAccount.containsKey(ToConvertLead.Virtual_Partner__c))
           {
             objAcc = mapVirtualIdToAccount.get(ToConvertLead.Virtual_Partner__c);
           }
           if(objAcc != null)
           {
             if(EntityIdToEntityVirtualGlobalAssumption.containsKey(accId))
             {
               //obj[0].IsCreatedByPartner__c =true;
                 VirtualGlobalAssump = EntityIdToEntityVirtualGlobalAssumption.get(accId);
                 if(VirtualGlobalAssump != null)
                 {
                      VirtualGlobalAssump.Expected_Return_on_Investment__c = objAcc.Expected_Return_on_Investment__c;
                      VirtualGlobalAssump.Income_Growth_Rate__c = objAcc.Income_Growth_Rate__c;
                      VirtualGlobalAssump.Inflation_Rate__c = objAcc.Inflation_Rate__c;
                      VirtualGlobalAssump.Number_Of_Months__c = objAcc.Number_Of_Months__c;
                      VirtualGlobalAssump.Default_Retirement_Age__c = objAcc.Default_Retirement_Age__c;
                      VirtualGlobalAssump.Default_Estimated_Life_Expectancy__c = objAcc.Default_Estimated_Life_Expectancy__c;
                      VirtualGlobalAssumptionList.add(VirtualGlobalAssump);
                 }
             }
           }
      }
      
      system.debug('******Account*****'+a);
     }
     upsert AccountToUpdate;
     Database.update(VirtualGlobalAssumptionList);
     //===============================================================================================================================
     
     List<User> lstUser = [select id,contactId from user where id in : leadOwnerIdSet];
     system.debug('*********************************lstUser : '+lstUser);
     Map<id,id> UserIdToContactIdMappingMap = new Map<id,id>();
     for(User objUser : lstUser)
     {
       if(!UserIdToContactIdMappingMap.containsKey(objUser.Id))
         UserIdToContactIdMappingMap.put(objUser.Id,objUser.contactId);
       if(objUser.contactId != null)
         contactIdSet.add(objUser.contactId);
     }
     //4.//5.Map<Id,Id> map2; i.e (contactIdSet,accountIdSet)
     /*List<Contact> lstCon =[select id,AccountId from Contact where id in contactIdSet];
      Set<Id> accountIdSet;
      for(Contact c : lstCon)
      {
        accountIdSet.add(c.AccountId);
      }
     */
     Map<id,id> ContactIdToAccountIdMappingMap = new Map<id,id>();
     Set<Id> accountIdSet = new Set<Id>(); 
     List<Contact> lstCon =[select id,AccountId from Contact where id in: contactIdSet];
     for(Contact objContact : lstCon)
     {
       accountIdSet.add(objContact.AccountId);
       if(!ContactIdToAccountIdMappingMap.containsKey(objContact.Id))
         ContactIdToAccountIdMappingMap.put(objContact.Id,objContact.AccountId);
     }
     Map<id,Account> partnerAccountMap = new Map<id,Account>([select Id,Logo__c
                       , Email_ID__c,IsCreatedByPartner__c
                       //need to comment below
                       ,Related_To__c
                       ,Expected_Return_on_Investment__c
                       ,Income_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c
                       ,Number_Of_Months__c,Company_Address__c,Default_Retirement_Age__c
                       ,Phone,Name from account where id =: accountIdSet]);
    
     Map<id,Account> accountToUpdatePartnerFlagMap = new Map<id,Account>([Select id,ownerId
                           ,Parent_Entity__c
                           ,IsCreatedByPartner__c
                           //need to comment below
                           ,Related_To__c
                           from Account where Id In : convertedAccountId ]);
                           
     List<Entity_Global_Assumption__c> lstGlobalAssump = [select Expected_Return_on_Investment__c,Account__c,Income_Growth_Rate__c,Inflation_Rate__c,Stock_Growth_Rate__c
                    ,Number_Of_Months__c,Default_Retirement_Age__c,Default_Estimated_Life_Expectancy__c from Entity_Global_Assumption__c
                    where Account__c =: accountToUpdatePartnerFlagMap.keySet()];      
                    
      Map<Id,Entity_Global_Assumption__c>  EntityIdToEntityGlobalAssumption = new   Map<Id,Entity_Global_Assumption__c>();
      
      for(Entity_Global_Assumption__c objEntityGlobalAssumption : lstGlobalAssump)    
      {
        if(!EntityIdToEntityGlobalAssumption.containsKey(objEntityGlobalAssumption.Account__c))
         EntityIdToEntityGlobalAssumption.put(objEntityGlobalAssumption.Account__c,objEntityGlobalAssumption);
      }      
                                
        
     //convertedAccountIdToLeadOwnerIdMap.put(objLead.ConvertedAccountId,objLead.ownerId);
     List<Entity_Global_Assumption__c> globalAssumptionList = new List<Entity_Global_Assumption__c>();
     List<Account> FinalUpdationAccountList = new List<Account>(); 
     for(Id ConvertedAccId : convertedAccountIdToLeadOwnerIdMap.keySet())
     {
       
       Id LeadOwnerId,contactId,partnerAccountId;
       Account partnerAccount;
       Account accountToBeUpdated;
       Entity_Global_Assumption__c GlobalAssump;
       if(convertedAccountIdToLeadOwnerIdMap.containsKey(ConvertedAccId))
         LeadOwnerId = convertedAccountIdToLeadOwnerIdMap.get(ConvertedAccId);
       
       if(LeadOwnerId != null && UserIdToContactIdMappingMap.containsKey(LeadOwnerId))
       {
         contactId = UserIdToContactIdMappingMap.get(LeadOwnerId);
         if(contactId != null && ContactIdToAccountIdMappingMap.containsKey(contactId))
         {
            partnerAccountId = ContactIdToAccountIdMappingMap.get(contactId);
       		if(partnerAccountId != null && partnerAccountMap != null && partnerAccountMap.containsKey(partnerAccountId))
           	{  
             partnerAccount = partnerAccountMap.get(partnerAccountId);
             system.debug('Partner Account: '+partnerAccount);
             if(partnerAccount != null)
             {
	               if(EntityIdToEntityGlobalAssumption.containsKey(ConvertedAccId))
	               {
	               //obj[0].IsCreatedByPartner__c =true;
	                 system.debug('@@@@@@@@@@@@22 :'+GlobalAssump);
	                 GlobalAssump = EntityIdToEntityGlobalAssumption.get(ConvertedAccId);
	                 if(GlobalAssump != null)
	                 {
	                              GlobalAssump.Expected_Return_on_Investment__c=partnerAccount.Expected_Return_on_Investment__c;
	                              GlobalAssump.Income_Growth_Rate__c=partnerAccount.Income_Growth_Rate__c;
	                              GlobalAssump.Inflation_Rate__c=partnerAccount.Inflation_Rate__c;
	                              GlobalAssump.Number_Of_Months__c=partnerAccount.Number_Of_Months__c;
	                              GlobalAssump.Default_Retirement_Age__c = partnerAccount.Default_Retirement_Age__c;
	                              GlobalAssump.Default_Estimated_Life_Expectancy__c = partnerAccount.Default_Estimated_Life_Expectancy__c;
	                              globalAssumptionList.add(GlobalAssump);
	                 }
	               }
                   if(accountToUpdatePartnerFlagMap.containsKey(ConvertedAccId))
                     accountToBeUpdated = accountToUpdatePartnerFlagMap.get(ConvertedAccId);
                   system.debug('accountToBeUpdated---->'+accountToBeUpdated);  
                   if(accountToBeUpdated != null)
                   {
                     //need to comment below
                     accountToBeUpdated.Related_To__c = 'Business Partner';
                     accountToBeUpdated.IsCreatedByPartner__c = true;
                     FinalUpdationAccountList.add(accountToBeUpdated);
                   }
             }
           }
         }
       }
     }
     Database.update(FinalUpdationAccountList);
     Database.update(globalAssumptionList);
     //////////////////////////////////////////////////////////////////////////////////////
    public Set<Id> leadIds = new Set<Id>();
    
    public Map<Id, List<X_Ray_Score_Card_Detail__c>> mapOfIdScoreCardDetails = new Map<Id, List<X_Ray_Score_Card_Detail__c>>();
        public Map<Id, List<Attachment>> mapIdAttachment = new Map<Id, List<Attachment>> ();
        
    List<X_Ray_Score_Card_Detail__c> lstScoreCardDetailTobeUpdate = new List<X_Ray_Score_Card_Detail__c> ();
    List<Attachment> lstAttachmentsTobeUpdate = new List<Attachment>();  

    if(Trigger.new.size() > 0)
    {
      for (Integer i = 0; i < Trigger.new.size(); i++)
       {
           if (Trigger.new[i].IsConverted == true && Trigger.old[i].isConverted == false)
           {
               leadIds.add(Trigger.new[i].Id);
           }
       }
    }
     
     for(Attachment objAttachment :[Select a.ParentId, a.Name, a.Id, a.Description, a.BodyLength, a.Body From Attachment a where ParentId IN :leadIds])
        {
          if(!mapIdAttachment.isEmpty() && mapIdAttachment.containsKey(objAttachment.ParentId))
          {
            List<Attachment> lstAttachment = mapIdAttachment.get(objAttachment.ParentId);
            lstAttachment.add(objAttachment);
            mapIdAttachment.put(objAttachment.ParentId,lstAttachment);
            
          }
          else
          {
            List<Attachment> lstAttachment = new List<Attachment>();
            lstAttachment.add(objAttachment);
            mapIdAttachment.put(objAttachment.ParentId,lstAttachment);
          }
          
        }
        for(X_Ray_Score_Card_Detail__c objScoreCardDetails :[Select x.Name, x.MasterScore__c, x.Lead__c, x.Id, x.Entity__c From X_Ray_Score_Card_Detail__c x where Lead__c IN :leadIds])
        {
          if(!mapOfIdScoreCardDetails.isEmpty() && mapOfIdScoreCardDetails.containsKey(objScoreCardDetails.Lead__c))
          {
            List<X_Ray_Score_Card_Detail__c> lstScoreCardDetails = mapOfIdScoreCardDetails.get(objScoreCardDetails.Lead__c);
            lstScoreCardDetails.add(objScoreCardDetails);
            mapOfIdScoreCardDetails.put(objScoreCardDetails.Lead__c,lstScoreCardDetails);
            
          }
          else
          {
            List<X_Ray_Score_Card_Detail__c> lstScoreCardDetails = new List<X_Ray_Score_Card_Detail__c>();
            lstScoreCardDetails.add(objScoreCardDetails);
            mapOfIdScoreCardDetails.put(objScoreCardDetails.Lead__c,lstScoreCardDetails);
          }
        }
                
         if(!Trigger.new.isEmpty()) 
      {
        for (Lead objLead : Trigger.new)  
        {
          if(!mapOfIdScoreCardDetails.isEmpty() && mapOfIdScoreCardDetails.containsKey(objLead.Id))
              {
                List<X_Ray_Score_Card_Detail__c> lstXrayScoreCardDetails = mapOfIdScoreCardDetails.get(objLead.Id);
                if(lstXrayScoreCardDetails.size() > 0)
                {
                  for(X_Ray_Score_Card_Detail__c objXrayScoreCardDetails :lstXrayScoreCardDetails)
                  {
                    objXrayScoreCardDetails.Lead__c = null;
                    objXrayScoreCardDetails.Entity__c = objLead.ConvertedAccountId; 
                    lstScoreCardDetailTobeUpdate.add(objXrayScoreCardDetails);
                  }
                }
              }
              if(!mapIdAttachment.isEmpty() && mapIdAttachment.containsKey(objLead.Id))
              {
                List<Attachment> lstAttachment = mapIdAttachment.get(objLead.Id);
                if(lstAttachment.size() > 0)
                {
                  for(Attachment objAttachment  :lstAttachment)
                  {
                    objAttachment.ParentId = objLead.ConvertedAccountId;
                    lstAttachmentsTobeUpdate.add(objAttachment);
                  }
                }
              }
           }
       }
     
     if(!lstScoreCardDetailTobeUpdate.isEmpty())
     {
         List<Database.Saveresult> lstUpdateScoreCardResult = Database.update(lstScoreCardDetailTobeUpdate);
     }
     
     if(!lstAttachmentsTobeUpdate.isEmpty())
     {
         List<Database.Saveresult> lstUpdateAttachementResult = Database.update(lstAttachmentsTobeUpdate);
     }
     
     
     /*
     	Author: Gaurav
     	Date : 09/1/2013
     	Subject: Wellness Lead Transfer Code
     */
     //WellnessLeadHandler handler = new WellnessLeadHandler();  
     //handler.onAfterUpdate(Trigger.new, Trigger.old);
}