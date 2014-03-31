/*
    Revision History:
    Version     Version Author    Date          Comments
    2.0         Prajakta Sanap   17/09/2013   1.Handler to trigger the Approval process for account
                                              2.Creation of Partner Team Member Allocation records
                                              3.Updation of Partner Team Member Allocation records
                                              4.Chatter post will get generated on change of PST, MST & FPA of Member or partner and mail will be send to department heads
                                              5.When new entity/Member is created, PST, MST & FPA of its selected Practice owners will get assigned to corresponding entity
                                              6.Function to get the Entity allocation count and partner allocation count for particular team member.+
                                              7.When we change team member for Partner, provision is there to change old member to new for all corresponding Active Entities
                                              8.When we create or update Family Member, Team Members of Parent Member will get assign to it.
                                              9.On delete of partner, Its associated Partner Team Member allocations will also get deleted.
    
*/

public class AccountApprovalSubmitHandler 
{
    public static map<String, String> mapOldTOActual = new map<String, String>();
    //FreedomUtils objFreedomUtils = new FreedomUtils()
    //public static boolean isFlatCommissionUpateforPartner = true;
    public static Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    
    /* Function to trigger the approval process */
    public static Boolean excuted = false;
    public static void approvalSubmit(List<Account>accountNewList,map<id,Account> oldMap)
    {
        List<ProcessInstance>lstProcessInstance = [SELECT CreatedDate,Status,SystemModstamp,TargetObjectId FROM ProcessInstance 
                                            where TargetObjectId IN: accountNewList 
                                            order by SystemModstamp DESC];
        
        map<String,List<ProcessInstance>> mapAccIdToProcessInstance = new map<String,List<ProcessInstance>>();
        
        for(ProcessInstance obj : lstProcessInstance)
        {
            if(obj.Status == 'Pending')
            {
                List<ProcessInstance> lstPI = new List<ProcessInstance>();
                if(mapAccIdToProcessInstance.containsKey(obj.TargetObjectId))
                {
                    lstPI = (mapAccIdToProcessInstance.get(obj.TargetObjectId));
                    lstPI.add(obj);
                    mapAccIdToProcessInstance.put(obj.TargetObjectId,lstPI);
                }
                else
                {
                    lstPI.add(obj);
                    mapAccIdToProcessInstance.put(obj.TargetObjectId,lstPI);
                }
            }
        }
        
        for (Account a : accountNewList) 
        {
            if(a.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
            {
                system.debug('a.Rejected__c--->'+a.Rejected__c);
                system.debug('excuted--->'+excuted);
                if (excuted)
                    return;
                system.debug('mapAccIdToProcessInstance--->'+mapAccIdToProcessInstance.size());
                if(!mapAccIdToProcessInstance.containsKey(a.Id) && !a.Rejected__c)
                {
                    Boolean isTeamMemberChanged = false;
                    
                    if(a.PST_Team_Member__c != oldMap.get(a.Id).PST_Team_Member__c)
                    {
                        isTeamMemberChanged = true;
                        a.PST_Old_Value__c = oldMap.get(a.id).PST_Team_Member__c;
                    }
                    if(a.MST_Team_Member__c != oldMap.get(a.Id).MST_Team_Member__c)
                    {
                        isTeamMemberChanged = true;
                        a.MST_Old_Value__c = oldMap.get(a.id).MST_Team_Member__c;
                    }
                    if(a.FPA_Team_Member__c != oldMap.get(a.Id).FPA_Team_Member__c)
                    {
                        isTeamMemberChanged = true;
                        a.FPA_Old_Value__c = oldMap.get(a.id).FPA_Team_Member__c;
                    }
                    if(a.OPS_Team_Member__c != oldMap.get(a.Id).OPS_Team_Member__c)
                    {
                        isTeamMemberChanged = true;
                        a.OPS_Old_Value__c = oldMap.get(a.id).OPS_Team_Member__c;
                    }   
                    system.debug('----acc approve------'+a);
                    
                    if(isTeamMemberChanged)
                    {
                        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
                        app.setObjectId(a.id);
                        Approval.ProcessResult result = Approval.process(app);
                    }
                }
                else if(a.Rejected__c )
                {
                    system.debug('----a.Rejected__c-In rejected--'+a.Rejected__c);
                    if(a.PST_Old_Value__c != null)
                    {
                        
                        a.PST_Team_Member__c = a.PST_Old_Value__c;
                        a.PST_Old_Value__c = null; 
                    }
                    if(a.MST_Old_Value_For_Approval__c != null)
                    {
                        a.MST_Team_Member__c = a.MST_Old_Value__c;
                        a.MST_Old_Value__c = null;
                    }
                    if(a.FPA_Old_Value__c != null)
                    {
                        a.FPA_Team_Member__c = a.FPA_Old_Value__c;
                        a.FPA_Old_Value__c = null;
                    }
                    if(a.OPS_Old_Value__c != null)
                    {
                        a.OPS_Team_Member__c = a.OPS_Old_Value__c;
                        a.OPS_Old_Value__c = null;
                    }
                    a.Rejected__c = false;
                } else 
                {
                    a.PST_Old_Value__c = null;
                    a.MST_Old_Value__c = null;
                    a.FPA_Old_Value__c = null;
                    a.OPS_Old_Value__c = null;
                    a.Rejected__c = false;
                }
                excuted = true;
                system.debug('----excuted--------------'+excuted);
            }
        }
    }
    
    
    /* Function to get the Allocated by and Allodated date of Team Member for Entity/Partner */
    public static void allocationDetails(List<Account>accountNewList ,map<Id,Account> accountOldMap)
    {
        set<Id> updatedPartners = new set<Id>();
        List<Account> lstEntitiesToUpdate = new List<Account>();
        
        //Get the set of partners which are updated
        for(Account acc : accountNewList)
        {
            if(accountOldMap != null && (acc.PST_Team_Member__c != accountOldMap.get(acc.Id).PST_Team_Member__c || acc.MST_Team_Member__c != accountOldMap.get(acc.Id).MST_Team_Member__c
            || acc.FPA_Team_Member__c != accountOldMap.get(acc.Id).FPA_Team_Member__c || acc.OPS_Team_Member__c != accountOldMap.get(acc.Id).OPS_Team_Member__c))
            {
                updatedPartners.add(acc.Id);
            }
            else if(accountOldMap == null)
            {
                updatedPartners.add(acc.Id);
            }
        }
        system.debug('--------updatedPartners-----allocationDetails-----'+updatedPartners);
        // List of the entities which are to be updated
        if(updatedPartners.size() > 0 )
        {
            lstEntitiesToUpdate = [Select Id, Related_To__c,Virtual_Partner__c, OwnerId,  RecordTypeId, Business_Unit__c,
                                    PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c, OPS_Team_Member__c,
                                    PST_Team_Member__r.LastModifiedDate, PST_Team_Member__r.LastModifiedById, PST_Allocated_Date__c, PST_Allocated_By__c,
                                    MST_Team_Member__r.LastModifiedDate, MST_Team_Member__r.LastModifiedById, MST_Allocated_Date__c, MST_Allocated_By__c,
                                    FPA_Team_Member__r.LastModifiedDate, FPA_Team_Member__r.LastModifiedById, FPA_Allocated_Date__c, FPA_Allocated_By__c,
                                    OPS_Team_Member__r.LastModifiedDate, OPS_Team_Member__r.LastModifiedById, OPS_Allocated_Date__c, OPS_Allocated_By__c,
                                    LastModifiedDate,LastModifiedById
                                    //,PST_Team_Member__r.Status__c, MST_Team_Member__r.Status__c, FPA_Team_Member__r.Status__c, OPS_Team_Member__r.Status__c
                              from Account where Id IN : updatedPartners];
        	system.debug('--------lstEntitiesToUpdate------aaa----'+lstEntitiesToUpdate);
            for(Account objAccount : lstEntitiesToUpdate)
            {
                Account oldAccount;
                if(accountOldMap != null && accountOldMap.containsKey(objAccount.Id))
                {
                    oldAccount = accountOldMap.get(objAccount.Id);
                    system.debug('--------oldAccount------aaa----'+oldAccount);
                }
                
                if(objAccount.PST_Team_Member__c != null)
                {
                    if(oldAccount != null && oldAccount.PST_Team_Member__c != objAccount.PST_Team_Member__c)
                    {
                        objAccount.PST_Allocated_Date__c = objAccount.LastModifiedDate;
                        system.debug('----objAccount.PST_Allocated_Date__c------'+objAccount.PST_Allocated_Date__c);
                        objAccount.PST_Allocated_By__c = objAccount.LastModifiedById;
                    }
                    else if(oldAccount == null)
                    {
                        objAccount.PST_Allocated_Date__c = objAccount.PST_Team_Member__r.LastModifiedDate;
                        system.debug('----objAccount.PST_Allocated_Date__c--else----'+objAccount.PST_Allocated_Date__c);
                        objAccount.PST_Allocated_By__c = objAccount.LastModifiedById;
                    }
                }
                if(objAccount.MST_Team_Member__c != null)
                {
                    if(oldAccount != null && oldAccount.MST_Team_Member__c != objAccount.MST_Team_Member__c)
                    {
                        objAccount.MST_Allocated_Date__c = objAccount.LastModifiedDate;
                        system.debug('----objAccount.MST_Allocated_Date__c------'+objAccount.MST_Allocated_Date__c);
                        objAccount.MST_Allocated_By__c = objAccount.LastModifiedById;
                    }
                    else if(oldAccount == null)
                    {
                        objAccount.MST_Allocated_Date__c = objAccount.LastModifiedDate;
                        objAccount.MST_Allocated_By__c = objAccount.LastModifiedById;
                    }
                }
                if(objAccount.FPA_Team_Member__c != null)
                {
                    if(oldAccount != null && oldAccount.FPA_Team_Member__c != objAccount.FPA_Team_Member__c)
                    {
                        objAccount.FPA_Allocated_Date__c = objAccount.LastModifiedDate;
                        system.debug('----objAccount.FPA_Allocated_Date__c------'+objAccount.FPA_Allocated_Date__c);
                        objAccount.FPA_Allocated_By__c = objAccount.LastModifiedById;
                    }
                    else if(oldAccount == null)
                    {
                        objAccount.FPA_Allocated_Date__c = objAccount.LastModifiedDate;
                        system.debug('----objAccount.FPA_Allocated_Date__c---else---'+objAccount.FPA_Allocated_Date__c);
                        objAccount.FPA_Allocated_By__c = objAccount.LastModifiedById;
                    }
                }
                if(objAccount.OPS_Team_Member__c != null)
                {
                    if(oldAccount != null && oldAccount.OPS_Team_Member__c != objAccount.OPS_Team_Member__c)
                    {
                        objAccount.OPS_Allocated_Date__c = objAccount.LastModifiedDate;
                        system.debug('----objAccount.OPS_Allocated_Date__c------'+objAccount.OPS_Allocated_Date__c);
                        objAccount.OPS_Allocated_By__c = objAccount.LastModifiedById;
                    }
                    else if(oldAccount == null)
                    {
                        objAccount.OPS_Allocated_Date__c = objAccount.LastModifiedDate;
                        objAccount.OPS_Allocated_By__c = objAccount.LastModifiedById;
                    }
                }
            }
            update lstEntitiesToUpdate;
        }
    }
    
    /* When we change PST team member for Member, entity owner of corresponding Active Entities will change automatically */
    public static void changeOwnerAsPSTTeamMember(List<Account>accountNewList, Map<Id,Account> accountOldMap)
    {
        set<Id> updatedPST = new set<Id>();
        List<Account> lstEntitiesToUpdate = new List<Account>();
        
        //Get the set of partners which are updated
        for(Account acc : accountNewList)
        {
            Account oldAccount = accountOldMap.get(acc.Id);
            
            system.debug('----acc-PST_Team_Member__c-----'+acc.PST_Team_Member__c);
            system.debug('----oldAccount-PST_Team_Member__c-----'+oldAccount.PST_Team_Member__c);
            if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c && acc.PST_Team_Member__c != oldAccount.PST_Team_Member__c)
            {
                updatedPST.add(acc.PST_Team_Member__c);
                lstEntitiesToUpdate.add(acc);
                system.debug('----acc.PST_Team_Member__c--inner----'+acc.PST_Team_Member__c);
            }
        }
        system.debug('----updatedPST------'+updatedPST);
        
        Team_Member__c PSTTeam_Member;
        if(updatedPST.size() != 0)
        {
            map<Id, Team_Member__c> mapIdToPSTMember = new map<Id, Team_Member__c>([Select Id,Team_Member__c
                                                                from Team_Member__c where Id IN: updatedPST]);
            system.debug('----mapIdToPSTMember------'+mapIdToPSTMember);
            
            for(Account objAccount : lstEntitiesToUpdate)
            {
                if(mapIdToPSTMember.containsKey(objAccount.PST_Team_Member__c))
                {
                    PSTTeam_Member = mapIdToPSTMember.get(objAccount.PST_Team_Member__c);
                    system.debug('----PSTTeam_Member------'+PSTTeam_Member);
                    if(!String.valueOf(objAccount.OwnerId).contains(Label.Technology_Support_Id))
                    {
                        objAccount.OwnerId = PSTTeam_Member.Team_Member__c;
                    }
                    //lstEntitiesToUpdate.add(objAccount);
                } 
                system.debug('----objAccount.OwnerId------'+objAccount.OwnerId); 
            }
        }
        //update lstEntitiesToUpdate;
    }
    
    /* When we change PST team member for Member, entity owner of corresponding Active Entities will change automatically */
    public static void changeOwnerAsPSTTeamMemberOnInsert(List<Account> accountNewList)
    {
        set<Id> updatedPST = new set<Id>();
        List<Account> lstEntitiesToUpdate = new List<Account>();
        
        //Get the set of partners which are updated
        for(Account acc : accountNewList)
        {
            if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
            {
                updatedPST.add(acc.PST_Team_Member__c);
                lstEntitiesToUpdate.add(acc);
                system.debug('----acc.PST_Team_Member__c--inner----'+acc.PST_Team_Member__c);
            }
        }
        system.debug('----updatedPST--aaaaaaaaa----'+updatedPST);
        
        Team_Member__c PSTTeam_Member;
        if(updatedPST.size() != 0)
        {
            map<Id, Team_Member__c> mapIdToPSTMember = new map<Id, Team_Member__c>([Select Id,Team_Member__c
                                                                from Team_Member__c where Id IN: updatedPST]);
            system.debug('----mapIdToPSTMember------'+mapIdToPSTMember);
            
            for(Account objAccount : lstEntitiesToUpdate)
            {
                if(mapIdToPSTMember.containsKey(objAccount.PST_Team_Member__c))
                {
                    PSTTeam_Member = mapIdToPSTMember.get(objAccount.PST_Team_Member__c);
                    system.debug('----PSTTeam_Member------'+PSTTeam_Member);
                    objAccount.OwnerId = PSTTeam_Member.Team_Member__c;
                    //lstEntitiesToUpdate.add(objAccount);
                } 
                system.debug('----objAccount.OwnerId------'+objAccount.OwnerId); 
            }
        }
        //update lstEntitiesToUpdate;
    }
    
    /* When we change team member for Partner, provision is there to change old member to new for all corresponding Active Entities */
    public static void changeTeamMembersPartnerwise(List<Account>accountNewList, Map<Id,Account> mapIdToOldPartnerAcc, Map<Id,Account> mapIdToNewPartnerAcc)
    {
        system.debug('---mapIdToOldPartnerAcc-'+mapIdToOldPartnerAcc);
        set<Id> updatedPartners = new set<Id>();
        List<Account> lstEntitiesToUpdate = new List<Account>();
        List<Lead> lstLeadsToUpdate = new List<Lead>();
        
        //Get the set of partners which are updated
        //system.debug('---accountNewList[0].PST_Team_Member__c-------------'+accountNewList[0].PST_Team_Member__c);
        //system.debug('---accountNewList[1].PST_Team_Member__c-------------'+accountNewList[1].PST_Team_Member__c);
        for(Account acc : accountNewList)
        {
            Account oldAccount = mapIdToOldPartnerAcc.get(acc.Id);
            system.debug('----oldAccount.PST_Team_Member__c-----------'+oldAccount.PST_Team_Member__c);
            system.debug('----acc.PST_Team_Member__c---------'+acc.PST_Team_Member__c);
            if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
                && (oldAccount.PST_Team_Member__c != acc.PST_Team_Member__c || oldAccount.MST_Team_Member__c != acc.MST_Team_Member__c 
                || oldAccount.FPA_Team_Member__c != acc.FPA_Team_Member__c || oldAccount.OPS_Team_Member__c != acc.OPS_Team_Member__c
                || oldAccount.Business_Unit__c != acc.Business_Unit__c))
            {
                updatedPartners.add(acc.Id);
            }
        }
        
        system.debug('----updatedPartners-*****-------------'+updatedPartners);
        // List of the entities which are to be updated
        if(updatedPartners.size() != 0)
        {
            lstEntitiesToUpdate = [Select Id, Related_To__c,Virtual_Partner__c, OwnerId, PST_Team_Member__c, MST_Team_Member__c, 
                                    OPS_Team_Member__c, FPA_Team_Member__c, RecordTypeId, Business_Unit__c
                                    from Account where RecordType.Name = 'Client' and Virtual_Partner__c IN : updatedPartners];
            
           /* lstLeadsToUpdate = [Select Id, Related_To__c,Virtual_Partner__c, OwnerId, PST_Team_Member__c, Business_Unit__c
                              from Lead where Virtual_Partner__c IN : updatedPartners  and isConverted = false];
            system.debug('----lstLeadsToUpdate------'+lstLeadsToUpdate.size());
            
            for(Lead objLead : lstLeadsToUpdate)
            {
                Account virtualPartner = mapIdToNewPartnerAcc.get(objLead.Virtual_Partner__c);
                Account oldVP = mapIdToOldPartnerAcc.get(objLead.Virtual_Partner__c);
                
                /* Check if the lead to be updated has the same old Team member as that of partner,
                   then only assign new team member to the lead as that of its partner */
             /*   if(oldVP.PST_Team_Member__c == objLead.PST_Team_Member__c)
                {
                    objLead.PST_Team_Member__c = virtualPartner.PST_Team_Member__c;
                    system.debug('----objLead---new---'+objLead.PST_Team_Member__c);
                }
                /* If Biz unit of partner is changed, then all the team members should have the same Biz unit 
                   and its corresponding entities Biz unit and team members will also get changed */
            /*    if(oldVP.Business_Unit__c != virtualPartner.Business_Unit__c)
                {
                    system.debug('----objAccount------'+objLead.Business_Unit__c);
                    objLead.Business_Unit__c = virtualPartner.Business_Unit__c;
                    system.debug('----objAccount----after--'+objLead.Business_Unit__c);
                    objLead.PST_Team_Member__c = virtualPartner.PST_Team_Member__c;
                }
            }*/
             system.debug('----lstEntitiesToUpdate-'+lstEntitiesToUpdate);
            for(Account objAccount : lstEntitiesToUpdate)
            {
                Account virtualPartner = mapIdToNewPartnerAcc.get(objAccount.Virtual_Partner__c);
                Account oldVP = mapIdToOldPartnerAcc.get(objAccount.Virtual_Partner__c);
                
                /* Check if the member to be updated has the same old Team member as that of partner,
                   then only assign new team member to the member as that of its partner */
                //if(oldVP.PST_Team_Member__c == objAccount.PST_Team_Member__c)
                    objAccount.PST_Team_Member__c = virtualPartner.PST_Team_Member__c;
                //if(oldVP.MST_Team_Member__c == objAccount.MST_Team_Member__c)
                    objAccount.MST_Team_Member__c = virtualPartner.MST_Team_Member__c;
                //if(oldVP.FPA_Team_Member__c == objAccount.FPA_Team_Member__c)
                    objAccount.FPA_Team_Member__c = virtualPartner.FPA_Team_Member__c;
                //if(oldVP.OPS_Team_Member__c == objAccount.OPS_Team_Member__c)
                    objAccount.OPS_Team_Member__c = virtualPartner.OPS_Team_Member__c;
                
                /* If Biz unit of partner is changed, then all the team members should have the same Biz unit 
                   and its corresponding entities Biz unit and team members will also get changed */
                if(oldVP.Business_Unit__c != virtualPartner.Business_Unit__c)
                {
                    system.debug('----objAccount------'+objAccount.Business_Unit__c);
                    objAccount.Business_Unit__c = virtualPartner.Business_Unit__c;
                    system.debug('----objAccount----after--'+objAccount.Business_Unit__c);
                    objAccount.PST_Team_Member__c = virtualPartner.PST_Team_Member__c;
                    objAccount.MST_Team_Member__c = virtualPartner.MST_Team_Member__c;
                    objAccount.FPA_Team_Member__c = virtualPartner.FPA_Team_Member__c;
                    objAccount.OPS_Team_Member__c = virtualPartner.OPS_Team_Member__c;
                }
            }
            //if(!lstLeadsToUpdate.isEmpty())
            //  update lstLeadsToUpdate;
            if(!lstEntitiesToUpdate.isEmpty())
                update lstEntitiesToUpdate;
        }
    }
    
    
    /* 3 records of Partner Team Member Allocation will be created at the time of new partner creation and PST, MST & FPA are assigned to them */
    public static void partnerTeamMemberAllocation(List<Account>accountNewList)
    {
        List<Partner_Team_Member_Allocation__c> lstPTM = new List<Partner_Team_Member_Allocation__c>();
        set<Id> newMembers = new set<Id>();
        for(Account acc : accountNewList)
        {
            if(acc.Virtual_Partner__c != null)
            {
                newMembers.add(acc.Virtual_Partner__c);
            }
        }
        
        map<Id, Account> mapIdToAccount = new map<Id, Account>([Select Id, Related_To__c,Virtual_Partner__c, OwnerId,  RecordTypeId, Business_Unit__c,
                                                    PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c, OPS_Team_Member__c,
                                                    CreatedDate, Data_Collection_Date__c ,MemberFinancialPlanPresentationDate__c
                                                    from Account where Id IN : newMembers]);
                                                            
        
        for (Account acc : accountNewList) 
        {
            if(acc.RecordTypeId != RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c)
            {
                String EntityName = '';
                if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {   
                    if(acc.LastName == null)
                        EntityName = acc.FirstName;
                    else if(acc.FirstName == null )
                        EntityName = acc.LastName;
                    else if(acc.LastName != null && acc.FirstName != null)
                        EntityName = acc.FirstName +' '+ acc.LastName;
                    else 
                        EntityName = '';
                }
                if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                {
                    EntityName = acc.Name;
                }
                
                system.debug('----acc------'+acc);
                system.debug('----acc--aaa----'+acc.RecordType.Name);
                Partner_Team_Member_Allocation__c objPTM1 = new Partner_Team_Member_Allocation__c();
                
                objPTM1.Name = 'PST - ' + EntityName;
                objPTM1.Partner__c = acc.Id;
                objPTM1.Allocation_Date__c = system.today();
                objPTM1.Allocated_By__c = acc.OwnerId;
                if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                    objPTM1.Team_Member__c = acc.PST_Team_Member__c;
                else if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {
                    if(mapIdToAccount.containsKey(acc.Virtual_Partner__c))
                    {
                        objPTM1.Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).PST_Team_Member__c;
                        system.debug('----objPTM1------'+objPTM1.Team_Member__c);
                    }
                }
                system.debug('----objPTM1------'+objPTM1);
                lstPTM.add(objPTM1);
                
                Partner_Team_Member_Allocation__c objPTM2 = new Partner_Team_Member_Allocation__c();
                objPTM2.Name = 'MST - ' + EntityName;
                objPTM2.Partner__c = acc.Id;
                objPTM2.Allocation_Date__c = system.today();
                objPTM2.Allocated_By__c = acc.OwnerId;
                if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                    objPTM2.Team_Member__c = acc.MST_Team_Member__c;
                else if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {
                    if(mapIdToAccount.containsKey(acc.Virtual_Partner__c))
                    {
                        objPTM2.Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).MST_Team_Member__c;
                    }
                }
                system.debug('----objPTM2------'+objPTM2);
                lstPTM.add(objPTM2);
                
                Partner_Team_Member_Allocation__c objPTM3 = new Partner_Team_Member_Allocation__c();
                objPTM3.Name = 'FPA - ' + EntityName;
                objPTM3.Partner__c = acc.Id;
                objPTM3.Allocation_Date__c = system.today();
                objPTM3.Allocated_By__c = acc.OwnerId;
                if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                    objPTM3.Team_Member__c = acc.FPA_Team_Member__c;
                else if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {
                    if(mapIdToAccount.containsKey(acc.Virtual_Partner__c))
                    {
                        objPTM3.Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).FPA_Team_Member__c;
                    }
                }
                system.debug('----objPTM3------'+objPTM3);
                lstPTM.add(objPTM3);
                
                Partner_Team_Member_Allocation__c objPTM4 = new Partner_Team_Member_Allocation__c();
                objPTM4.Name = 'MST2 - ' + EntityName;
                objPTM4.Partner__c = acc.Id;
                objPTM4.Allocation_Date__c = system.today();
                objPTM4.Allocated_By__c = acc.OwnerId;
                if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                    objPTM4.Team_Member__c = acc.OPS_Team_Member__c;
                else if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {
                    if(mapIdToAccount.containsKey(acc.Virtual_Partner__c))
                    {
                        objPTM4.Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).OPS_Team_Member__c;
                    }
                }
                system.debug('----objPTM4------'+objPTM4);
                lstPTM.add(objPTM4);
            }
        }
        system.debug('----lstPTM------'+lstPTM);
        insert lstPTM;
    }
    
    /* 3 records of Partner Team Member Allocation will be updated at the time of partners  PST, MST & FPA fields are updated */
    public static void partnerTeamMemberUpdation(List<Account>accountNewList, Map<Id,Account> oldMap)
    {
        map<Id,Id> mapAccountIdToPSTteamMember = new map<Id,Id>();
        map<Id,Id> mapAccountIdToMSTteamMember = new map<Id,Id>();
        map<Id,Id> mapAccountIdToFPAteamMember = new map<Id,Id>();
        map<Id,Id> mapAccountIdToOPSteamMember = new map<Id,Id>();
        set<Id> setOfEntityId = new set<Id>(); 
        
        for (Account acc : accountNewList) 
        {
            if(acc.PST_Team_Member__c != oldMap.get(acc.Id).PST_Team_Member__c || acc.MST_Team_Member__c != oldMap.get(acc.Id).MST_Team_Member__c
                || acc.FPA_Team_Member__c != oldMap.get(acc.Id).FPA_Team_Member__c || acc.OPS_Team_Member__c != oldMap.get(acc.Id).OPS_Team_Member__c)
            {
                setOfEntityId.add(acc.Id);
                
                //if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                {
                    // If the team member of partner got changed, then put it into seperate maps
                    if(acc.PST_Team_Member__c != oldMap.get(acc.Id).PST_Team_Member__c)
                    {
                    	system.debug('----acc.PST_Team_Member__c------'+oldMap.get(acc.Id).PST_Team_Member__c +' - '+acc.PST_Team_Member__c);
                        //mapAccountToOldTeamMember.put(acc.Id,oldMap.get(acc.Id).PST_Team_Member__c);
                        //mapAccountToNewTeamMember.put(acc.Id,acc.PST_Team_Member__c);   
                        mapAccountIdToPSTteamMember.put(acc.Id,acc.PST_Team_Member__c);
                    }
                    if(acc.MST_Team_Member__c != oldMap.get(acc.Id).MST_Team_Member__c)
                    {
                        //mapAccountToOldTeamMember.put(acc.Id,oldMap.get(acc.Id).MST_Team_Member__c);
                        //mapAccountToNewTeamMember.put(acc.Id,acc.MST_Team_Member__c);  
                        mapAccountIdToMSTteamMember.put(acc.Id,acc.MST_Team_Member__c); 
                    }
                    if(acc.FPA_Team_Member__c != oldMap.get(acc.Id).FPA_Team_Member__c)
                    {
                        //mapAccountToOldTeamMember.put(acc.Id,oldMap.get(acc.Id).FPA_Team_Member__c);
                        //mapAccountToNewTeamMember.put(acc.Id,acc.FPA_Team_Member__c);  
                        mapAccountIdToFPAteamMember.put(acc.Id,acc.FPA_Team_Member__c); 
                    }
                    if(acc.OPS_Team_Member__c != oldMap.get(acc.Id).OPS_Team_Member__c)
                    {
                        //mapAccountToOldTeamMember.put(acc.Id,oldMap.get(acc.Id).OPS_Team_Member__c);
                        //mapAccountToNewTeamMember.put(acc.Id,acc.OPS_Team_Member__c);  
                        mapAccountIdToOPSteamMember.put(acc.Id,acc.OPS_Team_Member__c); 
                    }
                }
                system.debug('----acc------'+acc);
            }
        }
        system.debug('----map------'+mapAccountIdToFPAteamMember+' - '+mapAccountIdToOPSteamMember);
        system.debug('----setOfEntityId------'+setOfEntityId);
        //if(mapAccountToNewTeamMember.values().size() != 0)
        if(setOfEntityId.size() > 0)
        {
            List<Partner_Team_Member_Allocation__c> lst = [Select p.Partner__c, p.OwnerId, p.Name,Department_Name__c, p.Id, p.Allocation_Date__c, 
                                                            p.Allocated_By__c,Team_Member__c,Team_Member__r.Department__r.Type_of_Department__c   
                                                            From Partner_Team_Member_Allocation__c p 
                                                            where p.Partner__c IN : setOfEntityId];//mapAccountToOldTeamMember.keySet()
                                                            //and p.Team_Member__c IN : setofTeamMembers];//mapAccountToOldTeamMember.values()];
            system.debug('----lst------'+lst);                                                
            map<Id,List<Partner_Team_Member_Allocation__c>> mapIdToTMAllocation = new map<Id,List<Partner_Team_Member_Allocation__c>>();   
            for(Partner_Team_Member_Allocation__c obj : lst)
            {
                if(mapIdToTMAllocation.containsKey(obj.Partner__c))
                {
                    mapIdToTMAllocation.get(obj.Partner__c).add(obj);
                }
                else
                {
                    List<Partner_Team_Member_Allocation__c> lstTM = new List<Partner_Team_Member_Allocation__c>();
                    lstTM.add(obj);
                    mapIdToTMAllocation.put(obj.Partner__c,lstTM);
                }
            }
            system.debug('----mapIdToTMAllocation------'+mapIdToTMAllocation);         
            
            List<Partner_Team_Member_Allocation__c> lstUpdateTMallocation = new List<Partner_Team_Member_Allocation__c>();                                              
            for(Id entityId : mapIdToTMAllocation.keySet())
            {
                // If team member of partner get changed, then assign the new ID of Team Member in Partner Team Member allocation object
                //obj.Team_Member__c = mapAccountToNewTeamMember.get(obj.Partner__c);
                if(mapIdToTMAllocation.containsKey(entityId))
                {
                    List<Partner_Team_Member_Allocation__c> lstTMallocation = mapIdToTMAllocation.get(entityId);
                    for(Partner_Team_Member_Allocation__c objTMallocation : lstTMallocation)
                    {
                        //if(objTMallocation.Team_Member__c != null)
                        {
                        	//if(objTMallocation.Team_Member__r.Department__c != null)
                        	{
	                            if((objTMallocation.Team_Member__c == null  && objTMallocation.Name.contains(Label.PST)) 
	                            		|| (objTMallocation.Team_Member__r.Department__r.Type_of_Department__c!= null
	                            		&& objTMallocation.Team_Member__r.Department__r.Type_of_Department__c.contains(Label.PST)))
	                            {
	                                if(mapAccountIdToPSTteamMember.containsKey(objTMallocation.Partner__c))
	                                    objTMallocation.Team_Member__c = mapAccountIdToPSTteamMember.get(objTMallocation.Partner__c);
	                            }
	                            else if((objTMallocation.Team_Member__c == null  && (objTMallocation.Name.contains(Label.MST2) || objTMallocation.Name.contains('OPs')))
	                            		|| (objTMallocation.Team_Member__r.Department__r.Type_of_Department__c!= null
	                            		&& objTMallocation.Team_Member__r.Department__r.Type_of_Department__c.contains(Label.MST2)))
	                            {
	                            	system.debug('----mapAccountIdToOPSteamMember------'+mapAccountIdToOPSteamMember);
	                                if(mapAccountIdToOPSteamMember.containsKey(objTMallocation.Partner__c))
	                                {
	                                	system.debug('----OPSSSSSS-----'+mapAccountIdToOPSteamMember.get(objTMallocation.Partner__c));
	                                    objTMallocation.Team_Member__c = mapAccountIdToOPSteamMember.get(objTMallocation.Partner__c);
	                                }
	                            }
	                            else if((objTMallocation.Team_Member__c == null  && objTMallocation.Name.contains(Label.MST)) 
	                            		|| (objTMallocation.Team_Member__r.Department__r.Type_of_Department__c!= null
	                            		&& objTMallocation.Team_Member__r.Department__r.Type_of_Department__c.contains(Label.MST)))
	                            {
	                                if(mapAccountIdToMSTteamMember.containsKey(objTMallocation.Partner__c))
	                                    objTMallocation.Team_Member__c = mapAccountIdToMSTteamMember.get(objTMallocation.Partner__c);
	                            }
	                            else if((objTMallocation.Team_Member__c == null && objTMallocation.Name.contains(Label.FPA)) 
	                            		|| (objTMallocation.Team_Member__r.Department__r.Type_of_Department__c!= null
	                            		&& objTMallocation.Team_Member__r.Department__r.Type_of_Department__c.contains(Label.FPA)))
	                            {
	                            	system.debug('----mapAccountIdToFPAteamMember------'+mapAccountIdToFPAteamMember);
	                                if(mapAccountIdToFPAteamMember.containsKey(objTMallocation.Partner__c))
	                                {
	                                	system.debug('----objTMallocation.Team_Member__c(FPA) = -----'+mapAccountIdToFPAteamMember.get(objTMallocation.Partner__c));
										objTMallocation.Team_Member__c = mapAccountIdToFPAteamMember.get(objTMallocation.Partner__c);
	                                }
	                            }
                        	}
                        }
                        lstUpdateTMallocation.add(objTMallocation);
                    }
                }
            }       
            update lstUpdateTMallocation;                                     
        }   
    }
    
    /* 3 records of Partner Team Member Allocation will be deleted if related partner is deleted */
    public static void partnerTeamMemberDeletion(List<Account>accountOldList)
    {
        List<Partner_Team_Member_Allocation__c> lst = [Select p.Partner__c, p.OwnerId, p.Name, p.Id, p.Allocation_Date__c, p.Allocated_By__c 
                                                            From Partner_Team_Member_Allocation__c p 
                                                            where p.Partner__c IN : accountOldList];
        system.debug('----lst----'+lst);
        if(lst.size() > 0)
            delete lst;
    }
    
    /* When entity is created through conversion of Lead, which is Pathfinder Lead, Its "Entity Status" should Be "Pathfinder" */
    public static void setEntityStatusAsPathfinder(List<Account>accountNewList)
    {
        List<Account> lstAccount = new List<Account>();
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        
        set<Id> PathfinderAccIdSet = new set<Id>();
        for(Account acc : accountNewList)
        {
            if(acc.Is_Pathfinder__c == true)
            {
                PathfinderAccIdSet.add(acc.Id);
            }
        }
        system.debug('----PathfinderAccIdSet----'+PathfinderAccIdSet);
        if(PathfinderAccIdSet.size() != 0)
        {
            for (Account acc : accountNewList) 
            {
                acc.Category__c = 'Member';
            }
        }
    }
    
    /* When new entity/Member is created, PST, MST & FPA of its selected Practice owners will get assigned to corresponding entity*/
    public static void assignTeamMember(List<Account>accountNewList)
    {
        List<Account> lstAccount = new List<Account>();
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        
        set<Id> virtualPartnerIdSet = new set<Id>();
        for(Account acc : accountNewList)
        {
            if(acc.Virtual_Partner__c != null)
            {
                virtualPartnerIdSet.add(acc.Virtual_Partner__c);
            }
        }
        system.debug('----virtualPartnerIdSet----'+virtualPartnerIdSet);
        
        if(virtualPartnerIdSet.size() != 0)
        {
            mapIdToAccount = new map<Id, Account>([Select Id, PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c,
                                                                OPS_Team_Member__c, RecordTypeId, Business_Unit__c
                                                                from Account 
                                                                where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c
                                                                and Id IN: virtualPartnerIdSet]);
            system.debug('----mapIdToAccount----'+mapIdToAccount);
            for (Account acc : accountNewList) 
            {
                system.debug('----acc in accountNewList----'+acc);
                system.debug('----mapIdToAccount--VP--'+mapIdToAccount.containsKey(acc.Virtual_Partner__c));
                if(mapIdToAccount.containsKey(acc.Virtual_Partner__c))
                {    
                    system.debug('----mapIdToAccount--BU--'+mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c);
                    if(acc.Business_Unit__c == null)
                    {
                        acc.Business_Unit__c = mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c;
                        system.debug('----acc.Business_Unit__c----'+acc.Business_Unit__c);
                    }
                    if(acc.PST_Team_Member__c == null)
                    {
                        acc.PST_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).PST_Team_Member__c;
                        system.debug('----map--PST---'+mapIdToAccount.get(acc.Virtual_Partner__c).PST_Team_Member__c);
                    }
                    if(acc.MST_Team_Member__c == null)
                    {
                        acc.MST_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).MST_Team_Member__c;
                    }
                    if(acc.FPA_Team_Member__c == null)
                    {
                        acc.FPA_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).FPA_Team_Member__c;
                    }
                    if(acc.OPS_Team_Member__c == null)
                    {
                        acc.OPS_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).OPS_Team_Member__c;
                    }
                    
                }
                system.debug('---acc-'+acc);
                system.debug('---acc.Business_Unit__c--'+acc.Business_Unit__c);
                 system.debug('---mapIdToAccount.keyset()---'+mapIdToAccount.keyset());
                  
                //21/10/13 - Aditi - Added Validation to check Business Unit is Entered same as Practice Owners Business Unit
                if(mapIdToAccount.get(acc.Virtual_Partner__c)!=null &&  acc.Business_Unit__c !=  mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c && acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {
                    acc.Business_Unit__c.addError('Please select valid Practice Owner');
                }
                
                lstAccount.add(acc);
                system.debug('----lstAccount-----'+lstAccount);
            }
        }
    }
    
    /* When new entity/Member is updated, PST, MST, FPA, MST2 of its selected Practice owners will get assigned to corresponding entity*/
    public static void assignTeamMemberIfBlank(List<Account>accountNewList, map<Id,Account> accountOldMap, map<Id,Account> newMap)
    {
        List<Account> lstAccount = new List<Account>();
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        set<Id> updatedPartners = new set<Id>();
        set<Id> virtualPartnerIdSet = new set<Id>();

        for(Account acc : accountNewList)
        {
            if(accountOldMap != null && acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c && 
            (acc.PST_Team_Member__c != accountOldMap.get(acc.Id).PST_Team_Member__c || acc.MST_Team_Member__c != accountOldMap.get(acc.Id).MST_Team_Member__c
            || acc.FPA_Team_Member__c != accountOldMap.get(acc.Id).FPA_Team_Member__c || acc.OPS_Team_Member__c != accountOldMap.get(acc.Id).OPS_Team_Member__c))
            {
                virtualPartnerIdSet.add(acc.Virtual_Partner__c);
                updatedPartners.add(acc.Id);
            }
        }
        system.debug('----updatedPartners blank-----'+updatedPartners);

        if(virtualPartnerIdSet.size() != 0)
        {
            mapIdToAccount = new map<Id, Account>([Select Id, PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c,
                                                    OPS_Team_Member__c, RecordTypeId, Business_Unit__c
                                                    from Account 
                                                    where Id IN: virtualPartnerIdSet]);
            system.debug('----mapIdToAccount blank-----'+mapIdToAccount);
            for (Id objAccId : updatedPartners) 
            {
                Account acc = newMap.get(objAccId);
                system.debug('----newMap blank-----'+newMap);
                system.debug('----acc blank-----'+acc);
                
                if(mapIdToAccount.containsKey(acc.Virtual_Partner__c))
                {
                    if(acc.Business_Unit__c == null)
                    {
                        acc.Business_Unit__c = mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c;
                        system.debug('----map--BU---'+mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c);
                    }
                    if(acc.PST_Team_Member__c == null)
                    {
                        acc.PST_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).PST_Team_Member__c;
                        system.debug('----map--PST---'+mapIdToAccount.get(acc.Virtual_Partner__c).PST_Team_Member__c);
                    }
                    if(acc.MST_Team_Member__c == null)
                    {
                        acc.MST_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).MST_Team_Member__c;
                    }
                    if(acc.FPA_Team_Member__c == null)
                    {
                        acc.FPA_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).FPA_Team_Member__c;
                    }
                    if(acc.OPS_Team_Member__c == null)
                    {
                        acc.OPS_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).OPS_Team_Member__c;
                    }
                }
                //21/10/13 - Aditi - Added Validation to check Business Unit is Entered same as Practice Owners Business Unit
                if(acc.Business_Unit__c !=  mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c)
                {
                    acc.Business_Unit__c.addError('Please select valid Practice Owner');
                }
                
                lstAccount.add(acc);
                system.debug('----lstAccount-----'+lstAccount);
            }
        }
    }
    
    /* When new entity/Member is created, PST, MST & FPA of its selected Practice owners will get assigned to corresponding entity*/
    public static void assignTeamMemberOnChangeOfPO(List<Account>accountNewList, map<Id,Account> accountOldMap)
    {
          system.debug('---assignTeamMemberOnChangeOfPO=--');
        List<Account> lstAccount = new List<Account>();
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        set<Id> newCreatedAccId = new set<Id>();
        
        set<Id> virtualPartnerIdSet = new set<Id>();
        for(Account acc : accountNewList)
        {
            Account oldAccount = accountOldMap.get(acc.Id);
            if(acc.Virtual_Partner__c != null)// && acc.Virtual_Partner__c != oldAccount.Virtual_Partner__c)
            {
                virtualPartnerIdSet.add(acc.Virtual_Partner__c);
            }
        }
         system.debug('---virtualPartnerIdSet----'+virtualPartnerIdSet);
        if(virtualPartnerIdSet.size() != 0)
        {
            mapIdToAccount = new map<Id, Account>([Select Id, PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c,OwnerId,
                                                                OPS_Team_Member__c, RecordTypeId, Business_Unit__c,Related_To__c 
                                                                from Account 
                                                                where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c
                                                                and Id IN: virtualPartnerIdSet]);
            
            for (Account acc : accountNewList) 
            {
                system.debug('----acc in accountNewList----'+acc);
                if(mapIdToAccount.containsKey(acc.Virtual_Partner__c)) 
                {
                    if(acc.Business_Unit__c != accountOldMap.get(acc.Id).Business_Unit__c)
                    {
                        if(acc.Business_Unit__c != mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c)
                        {
                            system.debug('--in If-Business Unit not equal to Partenr BU-');
                            acc.Business_Unit__c.addError('Please select valid Practice Owner');
                        }
                    }
                    if(acc.Virtual_Partner__c != accountOldMap.get(acc.Id).Virtual_Partner__c)
                    {
                        acc.Business_Unit__c = mapIdToAccount.get(acc.Virtual_Partner__c).Business_Unit__c;//Praj - 12-11-13
                        acc.PST_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).PST_Team_Member__c;
                        system.debug('----acc.PST_Team_Member__ct----'+acc.PST_Team_Member__c);
                        acc.MST_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).MST_Team_Member__c;
                        acc.FPA_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).FPA_Team_Member__c;
                        acc.OPS_Team_Member__c = mapIdToAccount.get(acc.Virtual_Partner__c).OPS_Team_Member__c;
                        acc.Related_To__c = mapIdToAccount.get(acc.Virtual_Partner__c).Related_To__c;
                        //Added on 6/11/2013 - Aditi Satpute : Owner should not change if Partner Owner is Technology Support
                        if(!String.valueOf(mapIdToAccount.get(acc.Virtual_Partner__c).OwnerId).contains(Label.Technology_Support_Id))
                            acc.OwnerId = mapIdToAccount.get(acc.Virtual_Partner__c).OwnerId;
                    }
                }
                lstAccount.add(acc);
                system.debug('----lstAccount-----'+lstAccount);
            }
            
        }
    }
    
    public static void changeflatCommssionOnChangeOfPO(List<Account>accountNewList, map<Id,Account> accountOldMap)
    {
         system.debug('---changeflatCommssionOnChangeOfPO=--');
        map<Id, Account> mapIdToAccount = new map<Id, Account>();
        set<Id> virtualPartnerOldIdSet = new set<Id>();
        set<Id> virtualPartnerIdSet = new set<Id>();
        
    	Map<Id, List<Purchase_Order__c>> mapProductMasterIdTolstPurchaseOrder = new Map<Id, List<Purchase_Order__c>>(); 
		Map<Id, String> mapPurchaseOrderIdToProductMaster = new Map<Id, String>();
		Map<Id, Product_Price_Book__c> mapProductMasterIdToPriceBook = new Map<Id, Product_Price_Book__c>();
		Map<Id, Account> mapIdToVirtualPartnerAccount = new Map<Id, Account>();
		Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrderNew = new Map<Id, Purchase_Order__c>();
		//Map<Id, Account> mapIdToAccount = new Map<Id, Account>();
		List<Product_Price_Book__c> lstPriceBook = new List<Product_Price_Book__c> ();
		Map<Id, List<Purchase_Order__c>> mapEntityIdTolstPurchaseOrder = new Map<Id, List<Purchase_Order__c>>(); 
		Map<Id,String> mapAccIdToOldPO = new Map<Id,String>();
        
        for(Account acc : accountNewList)
        {
            Account oldAccount = accountOldMap.get(acc.Id);
            
            if(acc.Virtual_Partner__c != null && oldAccount.Virtual_Partner__c != null && acc.Virtual_Partner__c != oldAccount.Virtual_Partner__c)
            {
               virtualPartnerIdSet.add(acc.Virtual_Partner__c);
               virtualPartnerIdSet.add(oldAccount.Virtual_Partner__c);
               mapAccIdToOldPO.put(acc.Id, oldAccount.Virtual_Partner__c);
            }
            
        }
         system.debug('---virtualPartnerIdSet----'+virtualPartnerIdSet);
        if(virtualPartnerIdSet.size() != 0)
        {
        	//if(isFlatCommissionUpateforPartner)
        	{
	            mapIdToAccount = new map<Id, Account>([Select Id, PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c,OwnerId,
	                                                                OPS_Team_Member__c, RecordTypeId, Business_Unit__c,Related_To__c ,
	                                                                Total_Flat_Commission__c
	                                                                from Account 
	                                                                where RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c
	                                                                and Id IN: virtualPartnerIdSet]);
	                                                                
	                                                                
	            
				
				
					List<Purchase_Order__c> lstUpdatedPurchaseOrder = new List<Purchase_Order__c>(); 		
					List<Purchase_Order__c> lstPurchaseOrder0 = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																		Entity__r.Virtual_Partner__c,
																		Product_Master__r.Name,
																		Product_Price__c, Product_Master__c, Name, Id 
															     From Purchase_Order__c 
															     Where  Entity__c IN: accountOldMap.keySet()
																	 and Entity__r.RecordTypeId =: clientRecordTypeId
															    	 //and Product_Type__c = 'Base Product' 
															         order By CreatedDate Desc];
					Set<String> strProductType = new Set<String>();	
					if(lstPurchaseOrder0.size() > 0)	
					{								    
						for(Purchase_Order__c objPurchaseOrder: lstPurchaseOrder0)
						{
							/*if(!mapEntityIdToPurchaseOrderNew.containsKey(objPurchaseOrder.Entity__c))
							{
								//mapPurchaseOrderIdToProductMaster.put(objPurchaseOrder.Id, objPurchaseOrder.Product_Master__c);
								lstUpdatedPurchaseOrder.add(objPurchaseOrder);
							}*/
							
							if(!strProductType.contains('Base Product'))	
							{
								lstUpdatedPurchaseOrder.add(objPurchaseOrder);
								strProductType.add('Base Product');
							}
							else
							{
								lstUpdatedPurchaseOrder.add(objPurchaseOrder);
							}
						}										    
							
					}									    
															    			
			/*		List<Purchase_Order__c>  lstPurchaseOrder1 = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																		Entity__r.Virtual_Partner__c,
																		Product_Master__r.Name,
																		Product_Price__c, Product_Master__c, Name, Id 
															     From Purchase_Order__c 
															     Where  Product_Type__c != 'Base Product'
															     and Entity__c IN: accountOldMap.keySet()
															     and Entity__r.RecordTypeId =: clientRecordTypeId
															    ];
					
															    
						
																    
					lstUpdatedPurchaseOrder.addAll(lstPurchaseOrder1);	*/
					system.debug('************lstUpdatedPurchaseOrder'+lstUpdatedPurchaseOrder);
					
							
				Map<Id,List<Purchase_Order__c>>	 mapIdToLstPurchaseOrder = new Map<Id,List<Purchase_Order__c>>();	
				Map<Id,List<Purchase_Order__c>>	 mapPartnerEntityIdTolstPurchaseOrder = new Map<Id,List<Purchase_Order__c>>();		
				if(lstUpdatedPurchaseOrder.size() > 0)									    
				for(Purchase_Order__c objPurchaseOrder : lstUpdatedPurchaseOrder)
				{
					if(!mapProductMasterIdTolstPurchaseOrder.containsKey(objPurchaseOrder.Product_Master__c))
							mapProductMasterIdTolstPurchaseOrder.put(objPurchaseOrder.Product_Master__c , new List<Purchase_Order__c>{objPurchaseOrder});
						else
							mapProductMasterIdTolstPurchaseOrder.get(objPurchaseOrder.Product_Master__c).add(objPurchaseOrder);
							
					mapPurchaseOrderIdToProductMaster.put(objPurchaseOrder.Id, objPurchaseOrder.Product_Master__c);		
					
					if(!mapIdToLstPurchaseOrder.containsKey(objPurchaseOrder.Entity__c))
						mapIdToLstPurchaseOrder.put(objPurchaseOrder.Entity__c, new List<Purchase_Order__c>{objPurchaseOrder});
					else
						mapIdToLstPurchaseOrder.get(objPurchaseOrder.Entity__c).add(objPurchaseOrder);
						
					if(!mapPartnerEntityIdTolstPurchaseOrder.containsKey(objPurchaseOrder.Entity__r.Virtual_Partner__c))
							mapPartnerEntityIdTolstPurchaseOrder.put(objPurchaseOrder.Entity__r.Virtual_Partner__c , new List<Purchase_Order__c>{objPurchaseOrder});
						else
							mapPartnerEntityIdTolstPurchaseOrder.get(objPurchaseOrder.Entity__r.Virtual_Partner__c).add(objPurchaseOrder);	
						
				}	
				
				system.debug('************mapPurchaseOrderIdToProductMaster'+mapPurchaseOrderIdToProductMaster);										    
															  
				lstPriceBook =  [Select Product_code__c, 
											Price_value__c, 
											Name, 
											Flat_Commission__c 
								     From Product_Price_Book__c
							         Where Product_code__c IN : mapProductMasterIdTolstPurchaseOrder.keyset()];
														    
															    
				if(!lstPriceBook.isEmpty())	
				{									     
					for(Product_Price_Book__c objPriceBook: lstPriceBook)	
					{
						mapProductMasterIdToPriceBook.put(objPriceBook.Product_code__c, objPriceBook);
						system.debug('************mapProductMasterIdToPriceBook'+mapProductMasterIdToPriceBook);
					}									     
				}
				
				 
				 List<Account> lstVirtualPartnerAccount = new List<Account>();
				 for(Account objAccount : accountNewList)
				{
					 	Account objNewPOAccount = mapIdToAccount.get(objAccount.Virtual_Partner__c); 
					 	Account objOldPOAccount = mapIdToAccount.get(mapAccIdToOldPO.get(objAccount.Id));
					 	
					 	if(mapIdToLstPurchaseOrder.get(objAccount.id) != null && mapIdToLstPurchaseOrder.values() != null){
							List<Purchase_Order__c> lstPurchaseOrderUpdated = mapIdToLstPurchaseOrder.get(objAccount.id); 	
							if(!lstPurchaseOrderUpdated.isEmpty() )
							for(Purchase_Order__c objPurchaseOrder : lstPurchaseOrderUpdated)
							{
								if(objPurchaseOrder.Entity__c == objAccount.Id )
								{
									system.debug('************objPurchaseOrder.Entity__r'+objPurchaseOrder.Entity__c +'Product Name  '+ objPurchaseOrder.Product_Master__r.Name);	
									Id objProductMasterId = mapPurchaseOrderIdToProductMaster.get(objPurchaseOrder.Id);
									Product_Price_Book__c objPriceBook = mapProductMasterIdToPriceBook.get(objProductMasterId);
									system.debug('************objPriceBook'+objPriceBook );	
									objPriceBook.Flat_Commission__c = objPriceBook.Flat_Commission__c != null ? objPriceBook.Flat_Commission__c: 0;
									objNewPOAccount.Total_Flat_Commission__c = objNewPOAccount.Total_Flat_Commission__c != null ? objNewPOAccount.Total_Flat_Commission__c : 0;
									objOldPOAccount.Total_Flat_Commission__c = objOldPOAccount.Total_Flat_Commission__c != null ? objOldPOAccount.Total_Flat_Commission__c : 0;
									objNewPOAccount.Total_Flat_Commission__c += objPriceBook.Flat_Commission__c;
									objOldPOAccount.Total_Flat_Commission__c -= objPriceBook.Flat_Commission__c;
									mapIdToVirtualPartnerAccount.put(objOldPOAccount.Id, objOldPOAccount);
									mapIdToVirtualPartnerAccount.put(objNewPOAccount.Id, objNewPOAccount);
									//lstVirtualPartnerAccount.add(objOldPOAccount);
									//lstVirtualPartnerAccount.add(objNewPOAccount);
								
									//system.debug('************lstVirtualPartnerAccount'+lstVirtualPartnerAccount);	
									
								}	
							}
					 	}
				 }
				 
					 if(mapIdToVirtualPartnerAccount.size() > 0)
					 {
					 	update mapIdToVirtualPartnerAccount.values();
					 	//isFlatCommissionUpateforPartner = false;
					 }	
        		}
	        }
        
    }
    
    
    /* When PST Team Member is changes, its corresponding Entity owner gets changed.
       Sharing rules should be applied accordingly to that particular user.*/
    public static Boolean excutedShare = false;
    public static void accountSharing(List<Account>accountNewList,map<Id,Account> accountOldMap,map<Id,Account> accountNewMap,Boolean isInsertAcc)
    {
        //map<Id,Id> accountTONewOwner = new map<Id,Id>();
        map<String, set<String>> mapIdToSetOfUser = new map<String, set<String>>();
        set<Id> newCreatedAccId = new set<Id>();
        system.debug('----accountNewList--accountSharing---'+accountNewList);
        
        for(Account acc : accountNewList)
        {
            if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c
                || acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c 
                || acc.RecordTypeId == RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c)
            {
                if(!isInsertAcc)
                {
                    if(accountOldMap != null && !accountOldMap.isEmpty() && (accountOldMap.get(acc.Id).Virtual_Partner__c != acc.Virtual_Partner__c || 
                        (acc.PST_Team_Member__c != accountOldMap.get(acc.Id).PST_Team_Member__c || acc.MST_Team_Member__c != accountOldMap.get(acc.Id).MST_Team_Member__c
                        || acc.FPA_Team_Member__c != accountOldMap.get(acc.Id).FPA_Team_Member__c || acc.OPS_Team_Member__c != accountOldMap.get(acc.Id).OPS_Team_Member__c)))
                    {
                        newCreatedAccId.add(acc.Id);
                        //accountTONewOwner.put(acc.Id,acc.ownerId);
                    }
                }
                else
                {
                    newCreatedAccId.add(acc.Id);
                }
            }
        }
        system.debug('----newCreatedAccId--accountSharing---'+newCreatedAccId);
        if(newCreatedAccId.size() != 0)
        {
            map<string, set<string>> mapAccIdToSetUsersExisting = new map<string, set<string>>();
            
            List<AccountShare> lstAccountShare = [Select Id, UserOrGroupId, AccountId 
                                                    from AccountShare 
                                                    where AccountId IN : newCreatedAccId];
            system.debug('----lstAccountShare---'+lstAccountShare);                                     
            for(AccountShare accInst :  lstAccountShare)
            {
                if(!mapAccIdToSetUsersExisting.containskey(accInst.AccountId))
                {
                    set<String> setUserId = new set<String>();
                    setUserId.add(accInst.UserOrGroupId);
                    mapAccIdToSetUsersExisting.put(accInst.AccountId,setUserId);
                }
                else
                {
                    mapAccIdToSetUsersExisting.get(accInst.AccountId).add(accInst.UserOrGroupId);
                }
            }
            
            AccountShare share = new AccountShare();
            List<AccountShare> shares = new List<AccountShare>();
            Set<Id> setOfCommonUserId = new Set<Id>();
            
            List<Account> lstUserIdAcc = [Select Id, PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c,OPS_Team_Member__c, 
                                      PST_Team_Member__r.Team_Member__c, MST_Team_Member__r.Team_Member__c,
                                      FPA_Team_Member__r.Team_Member__c, OPS_Team_Member__r.Team_Member__c,ownerId
                                      from Account where Id IN: newCreatedAccId];
            
            system.debug('----lstUserIdAcc---'+lstUserIdAcc);                          
            if(! lstUserIdAcc.isEmpty())
            {
                for (Account acc : lstUserIdAcc) 
                {
                    system.debug('----acc.OwnerId--->'+acc.OwnerId);
                    set<String> setUserId = new set<String>();
                    //if (accountTONewOwner.containsKey(acc.id) && accountTONewOwner.get(acc.id) != acc.PST_Team_Member__r.Team_Member__c) 
                    setUserId.add(acc.PST_Team_Member__r.Team_Member__c);
                    setUserId.add(acc.MST_Team_Member__r.Team_Member__c);
                    setUserId.add(acc.FPA_Team_Member__r.Team_Member__c);
                    setUserId.add(acc.OPS_Team_Member__r.Team_Member__c);
                    
                    if(!mapIdToSetOfUser.containsKey(acc.Id))
                    {
                        mapIdToSetOfUser.put(acc.Id,setUserId);
                        system.debug('----setUserId----'+setUserId);
                    }
                }    
                system.debug('----mapIdToSetOfUser----'+mapIdToSetOfUser);     
                
                for (Id accId : mapIdToSetOfUser.KeySet()) 
                {  
                    system.debug('----accId-----'+accId);
                    
                    share.AccountId = accId;
                    share.AccountAccessLevel = 'Edit';
                    //Set the portal user Id to share the accounts with
                    if(mapIdToSetOfUser.containsKey(accId))
                    {
                        set<String> setOfUserId = mapIdToSetOfUser.get(accId);  
                        for(String userId : setOfUserId)
                        {
                            if(!mapAccIdToSetUsersExisting.get(accId).contains(userId))
                            {
                                AccountShare shareAcc = new AccountShare();
                                shareAcc = share.clone();
                                shareAcc.UserOrGroupId = userId;
                                shareAcc.OpportunityAccessLevel = 'Read';
                                shareAcc.CaseAccessLevel = 'Read';
                                system.debug('----shareAcc-----'+shareAcc);
                                if(shareAcc.UserOrGroupId != null)
                                {
                                    shares.add(shareAcc);   
                                }
                            }
                            else
                            {
                                setOfCommonUserId.add(userId);
                            }
                            system.debug('----sharesoooo inside----'+shares);
                        }
                    }
                    system.debug('----sharesooooooo----'+shares); 
                }
            }
            List<AccountShare> lstAccountShareToDelete = [Select Id, UserOrGroupId, AccountId 
                                                    from AccountShare 
                                                    where AccountId IN : newCreatedAccId AND rowCause = 'Manual' and UserOrGroupId NOT IN: setOfCommonUserId];
            if(!lstAccountShareToDelete.isEmpty())
                delete lstAccountShareToDelete;                                     
            if(!shares.isEmpty())
                insert shares;
        }
        system.debug('----excutedShare----'+excutedShare); 
    }
    
    /* When new Family Member is created, PST, MST, FPA, MST2 of its selected Practice owners will get assigned to corresponding entity*/
    public static void assignTeamMemberToFamily(List<Account>accountNewList,map<Id,Account> accountOldMap)
    {
        
        List<Account> lstAccount = new List<Account>();
        List<Account> lstFM = new List<Account>();
        set<Id> setParentId = new set<Id>();
        for (Account acc : accountNewList) 
        {
            if(accountOldMap != null && !accountOldMap.isEmpty() && acc.RecordTypeId != RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
                    &&  (accountOldMap.get(acc.Id).OwnerId != acc.OwnerId ||
                        accountOldMap.get(acc.Id).Virtual_Partner__c != acc.Virtual_Partner__c || accountOldMap.get(acc.Id).Business_Unit__c != acc.Business_Unit__c ||
                        (acc.PST_Team_Member__c != accountOldMap.get(acc.Id).PST_Team_Member__c || acc.MST_Team_Member__c != accountOldMap.get(acc.Id).MST_Team_Member__c
                        || acc.FPA_Team_Member__c != accountOldMap.get(acc.Id).FPA_Team_Member__c || acc.OPS_Team_Member__c != accountOldMap.get(acc.Id).OPS_Team_Member__c)))
            {
                if(acc.Parent_Entity__c == null)
                {
                    setParentId.add(acc.Id);
                }
                else
                {
                    setParentId.add(acc.Parent_Entity__c);
                }
            }
        }
        system.debug('--------setParentId family---------'+setParentId);
        if(setParentId.size() > 0)
        {
            map<Id, Account> mapIdToAccount = new map<Id, Account>();
            map<Id, List<Account>> mapParentIdTolstAccount = new map<Id, List<Account>>();
            lstAccount = [Select Id, Parent_Entity__c,
                                        PST_Team_Member__c, MST_Team_Member__c, FPA_Team_Member__c,
                                        OPS_Team_Member__c, RecordTypeId, Business_Unit__c, Virtual_Partner__c 
                                        from Account 
                                        where (RecordTypeId =: RecTypes__c.getInstance('AccountClient').Record_Type_Value__c
                                            or RecordTypeId =: RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c)
                                            and (Id IN : setParentId or Parent_Entity__c IN : setParentId)];
            system.debug('----lstAccountcc in --in fot--'+lstAccount.size());
            
            for(Account objAcc : lstAccount)
            {
                if(objAcc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {
                    if(mapIdToAccount.containsKey(objAcc.Id))
                    {
                        mapIdToAccount.put(objAcc.Id,objAcc);
                    }
                }
                else if(objAcc.RecordTypeId == RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c)
                {
                    List<Account> lstAcc = new List<Account>();
                    if(mapParentIdTolstAccount.containsKey(objAcc.Parent_Entity__c))
                    {
                        lstAcc = mapParentIdTolstAccount.get(objAcc.Parent_Entity__c);
                        lstAcc.add(objAcc);
                    }
                    else
                    {
                        lstAcc.add(objAcc);
                    }
                    mapParentIdTolstAccount.put(objAcc.Parent_Entity__c,lstAcc);
                }
            }
            system.debug('----mapIdToAccount --in fot--'+mapIdToAccount);
            system.debug('----mapParentIdTolstAccount--in fot--'+mapParentIdTolstAccount);
            
            for (Account acc : accountNewList) 
            {
                Account parentAccount = new Account();
                system.debug('----acc in --in fot--'+acc);
                if(acc.RecordTypeId == RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c)
                {
                    system.debug('----acc in -if---'+acc);
                    if(mapIdToAccount.containsKey(acc.Parent_Entity__c))
                    {
                        system.debug('----acc in ----'+acc);
                        parentAccount = mapIdToAccount.get(acc.Parent_Entity__c);
                        if(parentAccount.Business_Unit__c != null)
                        {
                            acc.Business_Unit__c = parentAccount.Business_Unit__c;
                            system.debug('----acc in --BU--'+acc.Business_Unit__c);
                        }
                        if(parentAccount.Virtual_Partner__c != null)
                            acc.Virtual_Partner__c = parentAccount.Virtual_Partner__c;
                        if(parentAccount.Related_To__c != null)
                            acc.Related_To__c = parentAccount.Related_To__c;
                        if(parentAccount.PST_Team_Member__c != null)
                            acc.PST_Team_Member__c = parentAccount.PST_Team_Member__c;
                        if(parentAccount.MST_Team_Member__c != null)
                            acc.MST_Team_Member__c = parentAccount.MST_Team_Member__c;
                        if(parentAccount.FPA_Team_Member__c != null)    
                            acc.FPA_Team_Member__c = parentAccount.FPA_Team_Member__c;
                        if(parentAccount.OPS_Team_Member__c != null)    
                            acc.OPS_Team_Member__c = parentAccount.OPS_Team_Member__c;
                        system.debug('----acc in --------'+acc);
                        system.debug('----acc in ---name--fff---'+acc.FirstName +'-'+acc.LastName);
                    }
                    lstAccount.add(acc);
                }
                
                else if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {
                    if(mapParentIdTolstAccount.containsKey(acc.Id))
                    {
                        system.debug('----acc in -client---'+acc);
                        if(accountOldMap != null && !accountOldMap.isEmpty() && (accountOldMap.get(acc.Id).OwnerId != acc.OwnerId || 
                            accountOldMap.get(acc.Id).Virtual_Partner__c != acc.Virtual_Partner__c || accountOldMap.get(acc.Id).Business_Unit__c != acc.Business_Unit__c ||
                            (acc.PST_Team_Member__c != accountOldMap.get(acc.Id).PST_Team_Member__c || acc.MST_Team_Member__c != accountOldMap.get(acc.Id).MST_Team_Member__c
                            || acc.FPA_Team_Member__c != accountOldMap.get(acc.Id).FPA_Team_Member__c || acc.OPS_Team_Member__c != accountOldMap.get(acc.Id).OPS_Team_Member__c)))
                        {
                            List<Account> lstFamily = new List<Account>();
                            lstFamily = mapParentIdTolstAccount.get(acc.Id);
                            
                            system.debug('---lstFamily---'+lstFamily);
                            for(Account objFamily : lstFamily)
                            {
                                if(acc.Business_Unit__c != null)
                                {
                                    objFamily.Business_Unit__c = acc.Business_Unit__c;
                                    system.debug('---objFamily.Business_Unit__c---'+objFamily.Business_Unit__c);
                                }
                                if(acc.Virtual_Partner__c != null)
                                {
                                    objFamily.Virtual_Partner__c = acc.Virtual_Partner__c;
                                    system.debug('----aobjFamily.Virtual_Partner__c--------'+objFamily.Virtual_Partner__c);
                                }
                                if(acc.OwnerId != null)
                                {
                                    objFamily.OwnerId = acc.OwnerId;
                                    system.debug('----aobjFamily.OwnerId--------'+objFamily.OwnerId);
                                }
                        		if(acc.Related_To__c != null)
                            		objFamily.Related_To__c = acc.Related_To__c;
                                if(acc.PST_Team_Member__c != null)
                                    objFamily.PST_Team_Member__c = acc.PST_Team_Member__c;
                                if(acc.MST_Team_Member__c != null)
                                    objFamily.MST_Team_Member__c = acc.MST_Team_Member__c;
                                if(acc.FPA_Team_Member__c != null)    
                                    objFamily.FPA_Team_Member__c = acc.FPA_Team_Member__c;
                                if(acc.OPS_Team_Member__c != null)    
                                    objFamily.OPS_Team_Member__c = acc.OPS_Team_Member__c;
                                system.debug('----acc in --------'+acc);
                                system.debug('----objFamily in ---name-----'+objFamily.Id);
                                system.debug('----objFamily in ---PST-----'+objFamily.PST_Team_Member__c +' - '+
                                                                            objFamily.MST_Team_Member__c +' - '+
                                                                            objFamily.FPA_Team_Member__c +' - '+
                                                                            objFamily.OPS_Team_Member__c);
                                lstFM.add(objFamily);
                            }
                            system.debug('----lstFM--family-client--'+lstFM);
                        }
                    }
                    system.debug('----lstAccount--family-client--'+lstAccount.size());
                }
                system.debug('----lstAccount--family---'+lstAccount);
            }
            update lstFM;
        }
    }
    
    /* Function to get the Entity allocation count and partner allocation count for particular team member. */
    public static void entityAllocationCount(List<Account>accountNewList ,map<Id,Account> accountOldMap)
    {
        List<Team_Member__c> lstTeam = new List<Team_Member__c>();
        map<Id,Id> mapAccountToOldPSTTeamMember = new map<Id,Id>();
        set<Id> setOfMember = new set<Id>();
        
        for(Account objAccount : accountNewList)
        {
            setOfMember.add(objAccount.PST_Team_Member__c);
            setOfMember.add(objAccount.MST_Team_Member__c);
            setOfMember.add(objAccount.FPA_Team_Member__c);
            setOfMember.add(objAccount.OPS_Team_Member__c);
            
            if(accountOldMap != null && accountOldMap.containsKey(objAccount.Id))
            {
                Account oldAccount = accountOldMap.get(objAccount.Id);
                if(objAccount.PST_Team_Member__c != oldAccount.PST_Team_Member__c)
                {
                    setOfMember.add(accountOldMap.get(objAccount.Id).PST_Team_Member__c);
                    system.debug('----setOfMember---PST--'+setOfMember);
                }    
                else
                { 
                    setOfMember.remove(objAccount.PST_Team_Member__c);  
                    system.debug('----setOfMember--PST else---'+setOfMember);
                }
                if(objAccount.MST_Team_Member__c != oldAccount.MST_Team_Member__c)
                    setOfMember.add(accountOldMap.get(objAccount.Id).MST_Team_Member__c);
                else 
                    setOfMember.remove(objAccount.MST_Team_Member__c);
                        
                if(objAccount.FPA_Team_Member__c != oldAccount.FPA_Team_Member__c)
                    setOfMember.add(accountOldMap.get(objAccount.Id).FPA_Team_Member__c);
                else 
                    setOfMember.remove(objAccount.FPA_Team_Member__c);
                    
                if(objAccount.OPS_Team_Member__c != oldAccount.OPS_Team_Member__c)
                    setOfMember.add(accountOldMap.get(objAccount.Id).OPS_Team_Member__c);
                else 
                    setOfMember.remove(objAccount.OPS_Team_Member__c);
            }
            system.debug('----setOfMember-----'+setOfMember);
        }
        if(setOfMember.size() != 0)
        {
            List<Team_Member__c> lstTeamMember = [Select Team_Member__c, Status__c, Name, Id, Entity_Allocation_Count__c, Partner_Allocation_Count__c,
                                                    (Select Id, RecordTypeId, LastModifiedDate From Accounts2__r),
                                                    (Select Id, RecordTypeId, LastModifiedDate From Accounts1__r),
                                                    (Select Id, RecordTypeId, LastModifiedDate From Accounts__r),
                                                    (Select Id, RecordTypeId, LastModifiedDate From Accounts3__r)
                                                    From Team_Member__c where Id IN : setOfMember];
            system.debug('----lstTeamMember-----'+lstTeamMember);
            Integer countClient = 0;    
                Integer countPartner = 0;
                DateTime lastDate = system.now();
            for(Team_Member__c objTeam : lstTeamMember)
            {
                // For PST Team Members
                for(Account acc : objTeam.Accounts2__r)
                {
                    if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                    {
                        countClient++ ;
                        lastDate = acc.LastModifiedDate;
                    }
                    else if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                        countPartner++ ;
                }
                // For MST Team Members
                for(Account acc : objTeam.Accounts1__r)
                {
                    if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                    {
                        countClient++ ;
                        lastDate = acc.LastModifiedDate;
                    }
                    else if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                        countPartner++ ;
                }
                // For FPA Team Members
                for(Account acc : objTeam.Accounts__r)
                {
                    if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                    {
                        countClient++ ;
                        lastDate = acc.LastModifiedDate;
                    }
                    else if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                        countPartner++ ;
                }
                for(Account acc : objTeam.Accounts3__r)
                {
                    if(acc.RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                    {
                        countClient++ ;
                        lastDate = acc.LastModifiedDate;
                    }
                    else if(acc.RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                        countPartner++ ;
                }
                objTeam.Entity_Allocation_Count__c = countClient;
                objTeam.Partner_Allocation_Count__c = countPartner;
                objTeam.Last_Entity_Allocation_Date__c = Date.valueOf(lastDate);
            }
            system.debug('----countClient---in--'+countClient);
            system.debug('----countPartner---in--'+countPartner);
            system.debug('----lastDate---in--'+lastDate);
            update lstTeamMember;
            
        }
    }
    
    /* Post chatter on change of Team Member */
    public static Boolean postExcuted = false;
    public static void chatterPost(List<Account>newList,map<Id,Account> oldMap, map<Id,Account> newMap)
    {
        set<Id> updatedTeamMember = new set<Id>();
        set<Id> teamMemberIdSet = new set<Id>();
        List<FeedItem> lstFeedItem = new List<FeedItem>();
        String memberName = '';
        List<String> toAddresses = new List<String>();
        List<String> toAddresses1 = new List<String>();
        List<String> toAddresses2 = new List<String>();
        List<String> toAddresses3 = new List<String>();
        set<Id> SetIdUser = new set<Id>();
        for(Account objAcc : newList)
        {
            if(objAcc.PST_Team_Member__c != oldMap.get(objAcc.Id).PST_Team_Member__c || objAcc.MST_Team_Member__c != oldMap.get(objAcc.Id).MST_Team_Member__c
            || objAcc.FPA_Team_Member__c != oldMap.get(objAcc.Id).FPA_Team_Member__c || objAcc.OPS_Team_Member__c != oldMap.get(objAcc.Id).OPS_Team_Member__c )
            {
                teamMemberIdSet.add(objAcc.PST_Team_Member__c);
                teamMemberIdSet.add(objAcc.MST_Team_Member__c);
                teamMemberIdSet.add(objAcc.FPA_Team_Member__c);
                teamMemberIdSet.add(objAcc.OPS_Team_Member__c);
                teamMemberIdSet.add(oldMap.get(objAcc.Id).PST_Team_Member__c);
                teamMemberIdSet.add(oldMap.get(objAcc.Id).MST_Team_Member__c);
                teamMemberIdSet.add(oldMap.get(objAcc.Id).FPA_Team_Member__c);
                teamMemberIdSet.add(oldMap.get(objAcc.Id).OPS_Team_Member__c);
                
                updatedTeamMember.add(objAcc.Id);
                SetIdUser.add(objAcc.OwnerId); //Added on 31/12/13 - to send Owner's Email Id in Payload
            }
            
        }
        
        
        List<Event_Master__c> lstEM = [Select e.Task_Event_Master__c, e.Name, e.Event_Id__c, e.Escalation_Event_Master__c 
                                            From Event_Master__c e
                                            where isActive__c = true 
                                            and (Name =: Label.PST_Team_Member_Change or Name =: Label.MST_Team_Member_Change 
                                            or Name =: Label.FPA_Team_Member_Change or Name =: Label.OPS_Team_Member_Change)];
                                            
                                            
        map<String,Event_Master__c> mapNameToEventMaster = new map<String,Event_Master__c>();
        for(Event_Master__c objEM : lstEM)
        {
            if(!mapNameToEventMaster.containsKey(objEM.Name))
                mapNameToEventMaster.put(objEM.Name,objEM);
        }
        system.debug('----mapNameToEventMaster.keySet()----'+mapNameToEventMaster.keySet());
        List<Notification_Queue__c> lstInsertNotificationQueue = new List<Notification_Queue__c>();
        
        
        Map <Id,Team_Member__c> mapIdToTeamMember;  
        if(teamMemberIdSet.size() != 0)
        {
            if(postExcuted)
                return;
            
            //set<Id> SetIdUser = new set<Id>();
            mapIdToTeamMember = new map<Id,Team_Member__c>([Select Name,Team_Member__c, Team_Member__r.Id From Team_Member__c where Id IN: teamMemberIdSet]);
            for(Team_Member__c objTeamM : mapIdToTeamMember.values())
            {
                SetIdUser.add(objTeamM.Team_Member__c);
            }
            map<Id,User> mapIdToUserEmail = new map<Id,User>([Select Name, ManagerId, Manager.Email, Id, Email, Manager.Name 
                                                              From User where Id =: SetIdUser]);

            for(Id objAccId : updatedTeamMember)
            {
                if(newMap.get(objAccId).RecordTypeId == RecTypes__c.getInstance('AccountClient').Record_Type_Value__c)
                {   
                    if(newMap.get(objAccId).LastName == null)
                        memberName = newMap.get(objAccId).FirstName;
                    else if(newMap.get(objAccId).FirstName == null )
                        memberName = newMap.get(objAccId).LastName;
                    else if(newMap.get(objAccId).LastName != null && newMap.get(objAccId).FirstName != null)
                        memberName = newMap.get(objAccId).FirstName +' '+ newMap.get(objAccId).LastName;
                    else 
                        memberName = '';
                    
                    if(newMap.get(objAccId).Partner_Email__c != null)
                        toAddresses.add(newMap.get(objAccId).Partner_Email__c);
                }
                if(newMap.get(objAccId).RecordTypeId == RecTypes__c.getInstance('General_Business').Record_Type_Value__c)
                {
                    memberName = newMap.get(objAccId).Name;
                    if(newMap.get(objAccId).Email_ID__c != null)
                        toAddresses.add(newMap.get(objAccId).Email_ID__c);
                }       
                
                if(mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c) != mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c))
                {
                    if(newMap.get(objAccId).PST_Team_Member__c != null && mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c).Team_Member__c != null 
                        && mapIdToUserEmail.containsKey(mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c).Team_Member__c))
                    {
                        String mail = mapIdToUserEmail.get(mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c).Team_Member__c).Manager.Email;
                        system.debug('----mail-user---'+mail);
                        if(mail != null)
                            toAddresses.add(mail); 
                    }
                    system.debug('----toAddresses-user-PST--'+toAddresses);                
                        
                    Messaging.SingleEmailMessage emailToManager = new Messaging.SingleEmailMessage();
                    emailToManager.setToAddresses(toAddresses);
                    emailToManager.setSubject(' PST Team Member Changed for Account : ' + memberName);
                    system.debug('----emailToManager----'+emailToManager);
                    
                    String oldPSTName = ' - ';
                    String newPSTName = ' - ';
                    
                    if(oldMap.get(objAccId).PST_Team_Member__c != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c) != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c).Name != null 
                        && newMap.get(objAccId).PST_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c).Name != null)
                    {
                        oldPSTName = mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c).Name;
                        newPSTName = mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c).Name;
                    }
                    else if(oldMap.get(objAccId).PST_Team_Member__c == null
                        && newMap.get(objAccId).PST_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c).Name != null)
                    {
                        oldPSTName = ' - ';
                        newPSTName = mapIdToTeamMember.get(newMap.get(objAccId).PST_Team_Member__c).Name;
                    }
                                                
                    emailToManager.setHtmlBody('Hi, <br/>  PST Team Member has been changed for the account <b>' + memberName
                                            + '</b> from <b>'
                                            + oldPSTName
                                            + '</b> to <b>' + newPSTName 
                                            +'</b>.<br/><br/> Regards, <br/>' + UserInfo.getName());
                    
                    //if(! toAddresses.isEmpty())
                       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailToManager });
                    
                    String oldPSTUserManagerName = '';
                    String oldPSTUserManagerEmail = '';
                    String MemberOwnerEmail = '';
                    String MemberOwnerName = '';
                    
                    if(oldMap.get(objAccId) != null)
                    {
                    	if(mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c) != null)
                    	{
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldPSTUserManagerName = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c).Team_Member__c).Manager.Name;
                    		}
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldPSTUserManagerEmail = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).PST_Team_Member__c).Team_Member__c).Manager.Email;
                    		}
                    	}
                    }
                    
                    if(mapIdToUserEmail.get(newMap.get(objAccId).OwnerId) != null)
                    {
                    	MemberOwnerEmail = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Email;
                    	MemberOwnerName = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Name;
                    }
                                        
                    mapOldTOActual = new map<String, String>();
                    mapOldTOActual.put('PST.OldName', oldPSTName); 
                    mapOldTOActual.put('PST.NewName', newPSTName);
                    mapOldTOActual.put('Member.Owner.Email', MemberOwnerEmail);
                    mapOldTOActual.put('Member.Owner.Name', MemberOwnerName);
                    mapOldTOActual.put('PSTOld.User.Manager.Name', oldPSTUserManagerName);
                    mapOldTOActual.put('PSTOld.User.Manager.Email', oldPSTUserManagerEmail);
                      
                    String getOldPSTName = FreedomUtils.returnPayLoad(mapOldTOActual); 
                       
                    /**Added on : 21/10/13 : Aditi Satpute**/
                    if(mapNameToEventMaster.containsKey(Label.PST_Team_Member_Change))
                    {
                        system.debug('----mapNameToEventMaster in if--newMap.get(objAccId).Virtual_Partner__c-'+newMap.get(objAccId).Virtual_Partner__c);
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Partner_Id__c = newMap.get(objAccId).Virtual_Partner__c;
                        objNotificationQueue.Biz_Unit__c = newMap.get(objAccId).Business_Unit__c;
                        objNotificationQueue.Member_Id__c = objAccId;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.PST_Team_Member_Change).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        objNotificationQueue.PayloadXML__c = getOldPSTName;
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }    
                    
                    // Post the chatter for members and partners 
                    FeedItem post = new FeedItem();
                    post.ParentId = objAccId;
                    post.Body = 'PST Team Member has been changed from "' + oldPSTName +'" To "'+ newPSTName + '" .';
                    lstFeedItem.add(post);
                }
                
                if(mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c) != mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c))
                {
                    if(newMap.get(objAccId).MST_Team_Member__c != null && mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c).Team_Member__c != null
                       && mapIdToUserEmail.containsKey(mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c).Team_Member__c))
                    {
                        String mail = mapIdToUserEmail.get(mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c).Team_Member__c).Manager.Email;
                        system.debug('----mail-user---'+mail);
                        if(mail != null)
                            toAddresses1.add(mail); 
                    }
                    system.debug('----toAddresses-user--MST-'+toAddresses1);                
                        
                    Messaging.SingleEmailMessage emailToManager = new Messaging.SingleEmailMessage();
                    emailToManager.setToAddresses(toAddresses1);
                    emailToManager.setSubject(' MST Team Member Changed for Account : ' + memberName);
                    system.debug('----emailToManager----'+emailToManager);
                    
                    String oldMSTName = ' - ';
                    String newMSTName = ' - ';
                    
                    if(oldMap.get(objAccId).MST_Team_Member__c != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c) != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c).Name != null 
                        && newMap.get(objAccId).MST_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c).Name != null)
                    {
                        oldMSTName = mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c).Name;
                        newMSTName = mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c).Name;
                    }
                    else if(oldMap.get(objAccId).MST_Team_Member__c == null
                        && newMap.get(objAccId).MST_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c).Name != null)
                    {
                        oldMSTName = ' - ';
                        newMSTName = mapIdToTeamMember.get(newMap.get(objAccId).MST_Team_Member__c).Name;
                    }
                    
                    emailToManager.setHtmlBody('Hi, <br/>  MST Team Member has been changed for the account <b>' + memberName
                                            + '</b> from <b>'
                                            + oldMSTName
                                            + '</b> to <b>' + newMSTName 
                                            +'</b>.<br/><br/> Regards, <br/>' + UserInfo.getName());
                    //if(! toAddresses1.isEmpty())
                       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailToManager });
                    
                    String oldMSTUserManagerName = '';
                    String oldMSTUserManagerEmail = '';
                    String MemberOwnerEmail = '';
                    String MemberOwnerName = ''; 
                    if(oldMap.get(objAccId) != null)
                    {
                    	if(mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c) != null)
                    	{
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldMSTUserManagerName = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c).Team_Member__c).Manager.Name;
                    		}
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldMSTUserManagerEmail = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).MST_Team_Member__c).Team_Member__c).Manager.Email;
                    		}
                    	}
                    }
                    
                    if(mapIdToUserEmail.get(newMap.get(objAccId).OwnerId) != null)
                    {
                    	MemberOwnerEmail = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Email;
                    	MemberOwnerName = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Name;
                    }
                                        
                    mapOldTOActual = new map<String, String>();
                    mapOldTOActual.put('MST.OldName', oldMSTName);
                    mapOldTOActual.put('MST.NewName', newMSTName);     
                    mapOldTOActual.put('Member.Owner.Email', MemberOwnerEmail);
                    mapOldTOActual.put('Member.Owner.Name', MemberOwnerName);
                    mapOldTOActual.put('MSTOld.User.Manager.Name', oldMSTUserManagerName);
                    mapOldTOActual.put('MSTOld.User.Manager.Email', oldMSTUserManagerEmail);
                    
                    
                    
                  
                    String getOldMSTName = FreedomUtils.returnPayLoad(mapOldTOActual);   
                    
                    /**Added on : 21/10/13 : Aditi Satpute**/
                    if(mapNameToEventMaster.containsKey('MST Team Member Change Event for Partner Member'))
                    {
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Biz_Unit__c = newMap.get(objAccId).Business_Unit__c;
                        objNotificationQueue.Partner_Id__c = newMap.get(objAccId).Virtual_Partner__c;
                        objNotificationQueue.Member_Id__c = objAccId;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get('MST Team Member Change Event for Partner Member').Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        objNotificationQueue.PayloadXML__c = getOldMSTName;
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }    
                    // Post the chatter for members and partners 
                    FeedItem post = new FeedItem();
                    post.ParentId = objAccId;
                    post.Body = 'MST Team Member has been changed from "' + oldMSTName +'" To "'+ newMSTName + '" .';
                    lstFeedItem.add(post);
                    system.debug('----post-----'+post);
                }
                
                if(mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c) != mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c))
                {
                    if(newMap.get(objAccId).FPA_Team_Member__c != null && mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c).Team_Member__c != null
                        && mapIdToUserEmail.containsKey(mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c).Team_Member__c))
                    {
                        String mail = mapIdToUserEmail.get(mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c).Team_Member__c).Manager.Email;
                        system.debug('----mail-user---'+mail);
                        if(mail != null)
                            toAddresses2.add(mail); 
                    }
                    system.debug('----toAddresses-user-FPA--'+toAddresses2);                
                        
                    Messaging.SingleEmailMessage emailToManager = new Messaging.SingleEmailMessage();
                    emailToManager.setToAddresses(toAddresses2);
                    emailToManager.setSubject(' FPA Team Member Changed for Account : ' + memberName);
                    system.debug('----emailToManager----'+emailToManager);
                    
                    String oldFPAName = ' - ';
                    String newFPAName = ' - ';
                    
                    if(oldMap.get(objAccId).FPA_Team_Member__c != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c) != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c).Name != null 
                        && newMap.get(objAccId).FPA_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c).Name != null)
                    {
                        oldFPAName = mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c).Name;
                        newFPAName = mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c).Name;
                    }
                    else if(oldMap.get(objAccId).FPA_Team_Member__c == null
                        && newMap.get(objAccId).FPA_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c).Name != null)
                    {
                        oldFPAName = ' - ';
                        newFPAName = mapIdToTeamMember.get(newMap.get(objAccId).FPA_Team_Member__c).Name;
                    }
                    
                    emailToManager.setHtmlBody('Hi, <br/>  FPA Team Member has been changed for the account <b>' + memberName
                                            + '</b> from <b>'
                                            + oldFPAName
                                            + '</b> to <b>' + newFPAName 
                                            +'</b>.<br/><br/> Regards, <br/>' + UserInfo.getName());
                    
                    //if(! toAddresses2.isEmpty())
                    //   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailToManager });
                    
                    String oldFPAUserManagerName = '';
                    String oldFPAUserManagerEmail = '';
                    String MemberOwnerEmail = '';
                    String MemberOwnerName = '';
                    if(oldMap.get(objAccId) != null)
                    {
                    	if(mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c) != null)
                    	{
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldFPAUserManagerName = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c).Team_Member__c).Manager.Name;
                    		}
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldFPAUserManagerEmail = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).FPA_Team_Member__c).Team_Member__c).Manager.Email;
                    		}
                    	}
                    }
                    
                    if(mapIdToUserEmail.get(newMap.get(objAccId).OwnerId) != null)
                    {
                    	MemberOwnerEmail = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Email;
                    	MemberOwnerName = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Name; 
                    }
                                        
                    mapOldTOActual = new map<String, String>();
                    mapOldTOActual.put('FPA.OldName', oldFPAName); 
                    mapOldTOActual.put('FPA.NewName', newFPAName);
                    mapOldTOActual.put('Member.Owner.Email', MemberOwnerEmail);
                    mapOldTOActual.put('Member.Owner.Name', MemberOwnerName);
                    mapOldTOActual.put('FPAOld.User.Manager.Name', oldFPAUserManagerName);
                    mapOldTOActual.put('FPAOld.User.Manager.Email', oldFPAUserManagerEmail);
                   
                    String getOldFPAName = FreedomUtils.returnPayLoad(mapOldTOActual); 
                    
                    /**Added on : 21/10/13 : Aditi Satpute**/
                    if(mapNameToEventMaster.containsKey(Label.FPA_Team_Member_Change))
                    {
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Biz_Unit__c = newMap.get(objAccId).Business_Unit__c;
                        objNotificationQueue.Partner_Id__c = newMap.get(objAccId).Virtual_Partner__c;
                        objNotificationQueue.Member_Id__c = objAccId;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.FPA_Team_Member_Change).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        objNotificationQueue.PayloadXML__c = getOldFPAName;
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }   
                    // Post the chatter for members and partners 
                    FeedItem post = new FeedItem();
                    post.ParentId = objAccId;
                    post.Body = 'FPA Team Member has been changed from "' + oldFPAName +'" To "'+ newFPAName + '" .';
                    lstFeedItem.add(post);
                    system.debug('----post-----'+post);
                }
                
                if(mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c) != mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c))
                {
                    if(newMap.get(objAccId).OPS_Team_Member__c != null 
                     && mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c).Team_Member__c != null
                     && mapIdToUserEmail.containsKey(mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c).Team_Member__c))
                    {
                        String mail = mapIdToUserEmail.get(mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c).Team_Member__c).Manager.Email;
                        system.debug('----mail-user---'+mail);
                        if(mail != null)
                            toAddresses3.add(mail); 
                    }
                    system.debug('----toAddresses-user-OPS--'+toAddresses3);                
                        
                    Messaging.SingleEmailMessage emailToManager = new Messaging.SingleEmailMessage();
                    emailToManager.setToAddresses(toAddresses3);
                    emailToManager.setSubject(' MST2 Team Member Changed for Account : ' + memberName);
                    system.debug('----emailToManager----'+emailToManager);
                    
                    String oldOPSName = ' - ';
                    String newOPSName = ' - ';
                    
                    if(oldMap.get(objAccId).OPS_Team_Member__c != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c) != null
                        && mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c).Name != null 
                        && newMap.get(objAccId).OPS_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c).Name != null)
                    {
                        oldOPSName = mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c).Name;
                        newOPSName = mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c).Name;
                    }
                    else if(oldMap.get(objAccId).OPS_Team_Member__c == null
                        && newMap.get(objAccId).OPS_Team_Member__c != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c) != null
                        && mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c).Name != null)
                    {
                        oldOPSName = ' - ';
                        newOPSName = mapIdToTeamMember.get(newMap.get(objAccId).OPS_Team_Member__c).Name;
                    }
                    
                    emailToManager.setHtmlBody('Hi, <br/>  MST2 Team Member has been changed for the account <b>' + memberName
                                            + '</b> from <b>'
                                            + oldOPSName
                                            + '</b> to <b>' + newOPSName 
                                            +'</b>.<br/><br/> Regards, <br/>' + UserInfo.getName());
                    
                    //if(! toAddresses3.isEmpty())
                    //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailToManager });
                    
                    String oldOPSUserManagerName = '';
                    String oldOPSUserManagerEmail = '';
                    String MemberOwnerEmail = '';
                     String MemberOwnerName = '';
                    if(oldMap.get(objAccId) != null)
                    {
                    	if(mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c) != null)
                    	{
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldOPSUserManagerName = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c).Team_Member__c).Manager.Name;
                    		}
                    		if(mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c).Team_Member__c) != null)
                    		{
                    			oldOPSUserManagerEmail = mapIdToUserEmail.get(mapIdToTeamMember.get(oldMap.get(objAccId).OPS_Team_Member__c).Team_Member__c).Manager.Email;
                    		}
                    	}
                    }
                    
                    if(mapIdToUserEmail.get(newMap.get(objAccId).OwnerId) != null)
                    {
                    	MemberOwnerEmail = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Email;
                    	MemberOwnerName = mapIdToUserEmail.get(newMap.get(objAccId).OwnerId).Name;
                    }
                                        
                    mapOldTOActual = new map<String, String>();
                    mapOldTOActual.put('OPS.OldName', oldOPSName);
                    mapOldTOActual.put('OPS.NewName', newOPSName);
                    mapOldTOActual.put('Member.Owner.Email', MemberOwnerEmail);
                    mapOldTOActual.put('Member.Owner.Name', MemberOwnerName);
                    mapOldTOActual.put('OPSOld.User.Manager.Name', oldOPSUserManagerName);
                    mapOldTOActual.put('OPSOld.User.Manager.Email', oldOPSUserManagerEmail);
                   
                    String getOldOPSName = FreedomUtils.returnPayLoad(mapOldTOActual); 
                    
                    /**Added on : 21/10/13 : Aditi Satpute**/
                    if(mapNameToEventMaster.containsKey(Label.OPS_Team_Member_Change))
                    {
                        Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
                        objNotificationQueue.Biz_Unit__c = newMap.get(objAccId).Business_Unit__c;   
                        objNotificationQueue.Partner_Id__c = newMap.get(objAccId).Virtual_Partner__c;
                        objNotificationQueue.Member_Id__c = objAccId;
                        objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.OPS_Team_Member_Change).Id;
                        objNotificationQueue.Channel_Type__c = 'Email';
                        objNotificationQueue.PayloadXML__c = getOldOPSName;
                        lstInsertNotificationQueue.add(objNotificationQueue);
                    }   
                    // Post the chatter for members and partners 
                    FeedItem post = new FeedItem();
                    post.ParentId = objAccId;
                    post.Body = 'MST2 Team Member has been changed from "' + oldOPSName +'" To "'+ newOPSName + '" .';
                    lstFeedItem.add(post);
                    system.debug('----post-----'+post);
                }
            }
            insert lstFeedItem;
            
            system.debug('----lstInsertNotificationQueue--------'+lstInsertNotificationQueue);
            if(!lstInsertNotificationQueue.isEmpty())
                insert lstInsertNotificationQueue;
            postExcuted = true;
        }
    }
}