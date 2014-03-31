/*
  Revision History:
    Version     Version Author        Date          Comments
    1.0             --                --            Initial Draft
    2.0         Mahesh Hirugade     29/03/2012      Changed query to create renewal from Entity Created date instead of Check Received date
    3.0         Mahesh Hirugade     29/03/2012      Issue Id : FS0386 : Removed field update from "Continuation Membership" workflow and code 
                                                    to update Renewal_SMS_Sent__c field here. The issue was, this trigger was getting fired twice
                                                    (1. After update renewal on entity 2. By Workflow) and two subsequent records were created
    4.0         Prajakta Sanap      02/08/2012      Issue Id : 00001725 : Added functionality for updating Cheque_Received_Date__c From Account with Cheque_Date__c 
                                                    from Cheque_Details__c so that we can calculate Data collection duration as it is a formula field.
*/

trigger CreateFirstRenewalOnChqDtls on Cheque_Details__c (after insert, after update) 
{
    /* Code to create new renewal record whenever Cheque Date is added*/
    List<Renewal__c> lstRenewal = new List<Renewal__c>();
    
    List<Renewal__c> lstRenewalUpdate = new List<Renewal__c>();
    
    Map<Id, Cheque_Details__c> mapIdToChequeDetail = new Map<Id, Cheque_Details__c>([select Id, Account__c, Account__r.Id,Cheque_Date__c, Order_Detail__c, 
                                                Installment__c,Account__r.PersonEmail,Account__r.PersonMobilePhone, Account__r.CreatedDate,CreatedDate  
                                            from Cheque_Details__c where Id In : Trigger.newMap.keyset()]);
                                            
    List<Account> lstAccountUpdate = new List<Account>();   
                                         
    if(Trigger.isInsert)
    {   
        //Anupam : Code changes due to Productized FP.
        Set<Id> setEntityId = new Set<Id>();
        Map<Id, Purchase_Order__c> mapEntityIdToNewPurchaseOrder = new Map<Id, Purchase_Order__c>();
        Map<Id, Renewal__c> mapEntityIdToRenewal = new Map<Id, Renewal__c>();
        //Collect EntityId from Cheque record.
        for(Cheque_Details__c objChequeDetail : mapIdToChequeDetail.values())
        {
            setEntityId.add(objChequeDetail.Account__c);
        }
        
        //Create Map between Entity Id to Entity.
        Map<Id, Account> mapIdToEntity = new Map<Id, Account>([Select PersonBirthdate, Retirement_Age__c, Membership_End_Date__c, Membership_Start_Date__c, Renewal_Lapse_Date__c, Renewal_Start_Date__c
                                                                        from Account where Id IN: setEntityId]);
        
        //Create Map between Entity Id to Purchase order record( where Product_Type__c = 'Base Product' and Is_Cancel__c = false)                                                                
        for(Purchase_Order__c objPO : [select Entity__c, Renewal_Grace_Days__c, Renewal_Period_In_Days__c, Subscription_Period_In_Days__c, Selected_Product__c   
                                        from Purchase_Order__c 
                                        where Entity__c IN: setEntityId and Product_Type__c = 'Base Product' and Is_Cancel__c = false])
        {
            mapEntityIdToNewPurchaseOrder.put(objPO.Entity__c, objPO);
        }
        
        //Map between Account Id to Renewal record.
        for(Renewal__c objRenewal : [Select Id, Renewal_Date__c, Entity__c,Is_Renew__c from Renewal__c where Entity__c IN: setEntityId order by CreatedDate])
        {
            mapEntityIdToRenewal.put(objRenewal.Entity__c, objRenewal);
        }
        
        
        for(Cheque_Details__c objCD : Trigger.New)
        {
            Cheque_Details__c chqDtls = mapIdToChequeDetail.get(objCD.Id);
            if(chqDtls.Cheque_Date__c != null && chqDtls.Installment__c == '1st')
            {
                String strkey = objCD.Order_Detail__c+ '' + objCD.Account__c;
                
                Purchase_Order__c objPurchaseOrder = mapEntityIdToNewPurchaseOrder.get(objCD.Account__c);
                if(objPurchaseOrder != NULL)
                {
                    Renewal__c objRenewal;
                    if(!mapEntityIdToRenewal.containsKey(objCD.Account__c) )
                    {
                        objRenewal = new Renewal__c(Entity__c = chqDtls.Account__r.Id,
                                            Renewal_Date__c = chqDtls.CreatedDate.addDays(Integer.valueOf(objPurchaseOrder.Subscription_Period_In_Days__c)).Date(),
                                            Email__c = chqDtls.Account__r.PersonEmail,Mobile__c = chqDtls.Account__r.PersonMobilePhone);
                        lstRenewal.add(objRenewal);
                        
                        Account objAccount = mapIdToEntity.get(objCD.Account__c);
                        objAccount.Membership_Start_Date__c = chqDtls.Cheque_Date__c;
                        objAccount.Membership_End_Date__c = chqDtls.Cheque_Date__c.addDays(Integer.valueOf(objPurchaseOrder.Subscription_Period_In_Days__c));
                        //objAccount.Renewal_Start_Date__c = objAccount.Membership_End_Date__c.addDays(-1 * Integer.valueOf(objPurchaseOrder.Renewal_Period_In_Days__c));
                        //objAccount.Renewal_Lapse_Date__c = objAccount.Membership_End_Date__c.addDays(Integer.valueOf(objPurchaseOrder.Renewal_Grace_Days__c));
                        lstAccountUpdate.add(objAccount);
                    }
                    else
                    {
                        objRenewal = mapEntityIdToRenewal.get(objCD.Account__c);
                        Account objAccount;
                        if(objRenewal.Is_Renew__c)
                        {
                            objAccount = mapIdToEntity.get(objCD.Account__c);
                            objAccount.Membership_End_Date__c = objRenewal.Renewal_Date__c.addDays(Integer.valueOf(objPurchaseOrder.Subscription_Period_In_Days__c));
                            //objAccount.Renewal_Start_Date__c = objAccount.Membership_End_Date__c.addDays(-1 * Integer.valueOf(objPurchaseOrder.Renewal_Period_In_Days__c));
                            //objAccount.Renewal_Lapse_Date__c = objAccount.Membership_End_Date__c.addDays(Integer.valueOf(objPurchaseOrder.Renewal_Grace_Days__c));
                            
                            objRenewal.Renewal_Date__c = objRenewal.Renewal_Date__c.addDays(Integer.valueOf(objPurchaseOrder.Subscription_Period_In_Days__c));
                            objRenewal.Is_Renew__c = false;
                        }
                        else
                        {
                            objRenewal.Renewal_Date__c = chqDtls.CreatedDate.addDays(Integer.valueOf(objPurchaseOrder.Subscription_Period_In_Days__c)).date();
                            
                            objAccount = mapIdToEntity.get(objCD.Account__c);
                            objAccount.Membership_End_Date__c = chqDtls.Cheque_Date__c.addDays(Integer.valueOf(objPurchaseOrder.Subscription_Period_In_Days__c));
                            //objAccount.Renewal_Start_Date__c = objAccount.Membership_End_Date__c.addDays(-1 * Integer.valueOf(objPurchaseOrder.Renewal_Period_In_Days__c));
                            //objAccount.Renewal_Lapse_Date__c = objAccount.Membership_End_Date__c.addDays(Integer.valueOf(objPurchaseOrder.Renewal_Grace_Days__c));
                        }
                        lstRenewalUpdate.add(objRenewal);
                         lstAccountUpdate.add(objAccount);
                    }
                    
                }
            }
        }
        
        if(!lstRenewal.isEmpty())
            insert lstRenewal;
            
        if(!lstRenewalUpdate.isEmpty())
            update lstRenewalUpdate;
        if(!lstAccountUpdate.isEmpty())
            update lstAccountUpdate;
    }
   

    /** Eternus Solutions       **/
    /** Author  : Prajakta Sanap **/
    /** Issue Id: 00001725      **/
    /** Date    : 02/08/2012    **/
    /** Purpose : 1. Added functionality for updating Cheque_Received_Date__c From Account with Cheque_Date__c from Cheque_Details__c
                    so that we can calculate Data collection duration as it is a formula field.  **/
    if(trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {
        map <ID, Account> accMap = new map <ID, Account>();
        Set<Id> setCheque = new Set<Id>();
        for(Cheque_Details__c objChequeDtls : Trigger.new)
        {
            setCheque.add(objChequeDtls.Account__c);
        }
        
        for(Account objAcc : [Select a.Id, a.Cheque_Received_Date__c From Account a where a.Id IN :setCheque])
        {
            accMap.put(objAcc.Id, objAcc);
        }
        
        List<Account> lstAcc = new List<Account>();
        for(Cheque_Details__c objChequeDtls : Trigger.new)
        {
            if(objChequeDtls.Installment__c  == '1st' && accMap != null && accMap.containskey(objChequeDtls.Account__c) && accMap.get(objChequeDtls.Account__c) != null)
            {  
                Account objTempAcc = new Account(Id = objChequeDtls.Account__c);
                if(objChequeDtls.Cheque_Date__c  != null)
                    objTempAcc.Cheque_Received_Date__c  = objChequeDtls.Cheque_Date__c ;
                    objTempAcc.Membership_Start_Date__c = objChequeDtls.Cheque_Date__c ;
                    
                lstAcc.add(objTempAcc);
            }                       
        }
             
        if(lstAcc != null && lstAcc.size() > 0)
            upsert lstAcc;  
    }
    
    
    /* ========= Since ChequeDate is mandatory this code will not fire ============
    else if(Trigger.isUpdate)
    {
        for(Cheque_Details__c chqDtls : lstChqDtls)
        {
            Cheque_Details__c beforeUpdateChq = Trigger.oldMap.get(chqDtls.Account__r.Id);
            
            if(chqDtls.Cheque_Date__c != null && beforeUpdateChq.Cheque_Date__c == null && chqDtls.Installment__c == '1st')
                    // && chqDtls.Cheque_Date__c != beforeUpdateChq.Cheque_Date__c)
            {
                Renewal__c ren = new Renewal__c(Entity__c = chqDtls.Account__r.Id,Renewal_Date__c = chqDtls.Cheque_Date__c.addYears(1),
                                                Email__c = chqDtls.Account__r.PersonEmail,Mobile__c = chqDtls.Account__r.PersonMobilePhone);
                lstRenewal.add(ren);
            }
        }
    }*/
     
}