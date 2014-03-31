/*  populate RPP commission total on Entity Detail page
*  
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Gaurav             30/5/2013        Initial Draft
*/


public with sharing class ARPPHandler 
{
    public void onAfterInsertUpdateDeteteCalculateRevenueSum(Map<Id, ARPP_Detail__c> mapIdToARPP)
    {
        
        try{
            Set<Id> setEntityId = new Set<Id>();
            for(ARPP_Detail__c objAD : mapIdToARPP.values())
            {
                setEntityId.add(objAD.Entity__c);
            }
            Map<Id, List<ARPP_Detail__c>> mapEntitiyIdTolstARPP = new Map<Id, List<ARPP_Detail__c>>();
            List<ARPP_Detail__c> lstAD = new List<ARPP_Detail__c>();
            if(setEntityId.size() > 0){
                lstAD = [Select Id, Action_Amount_Revenue__c, Entity__c, Type__c, Execution_Tracker_Total_Revenue__c,
                                            Action_Plan_Amount__c,  Action_Plan_Upfront_Comm_Amount__c, Action_Plan_Trial_Comm_Amount__c,
                                            Execution_Tracker_Amount__c, Execution_Tracker_upfront_Comm_Amount__c, Execution_Tracker_Trial_Comm_Amount__c from ARPP_Detail__c where Entity__c IN: setEntityId];
            }
            for( ARPP_Detail__c objAD :lstAD)
            {
                if(!mapEntitiyIdTolstARPP.containsKey(objAD.Entity__c))
                    mapEntitiyIdTolstARPP.put(objAD.Entity__c, new List<ARPP_Detail__c>{objAD});
                else
                    mapEntitiyIdTolstARPP.get(objAD.Entity__c).add(objAD);
            }
            Map<Id, Account>  mapIdToEntity = new Map<Id, Account>();
            if(setEntityId.size() > 0)
            	mapIdToEntity = new Map<Id, Account>([Select Id, Actual_Revenue__c, Recommended_Revenue__c from Account  where Id IN: setEntityId]);
            List<Account> lstUpdateEntity = new List<Account>();
            System.debug('------------mapEntitiyIdTolstARPP---------'+mapEntitiyIdTolstARPP.size());
            for(Id entityId : mapEntitiyIdTolstARPP.keySet())
            {
                Account objEntity = mapIdToEntity.get(entityId);
                objEntity.Recommended_Revenue__c = 0;
                objEntity.Actual_Revenue__c = 0;
                
                objEntity.Expected_RPP_Amount__c = 0;
                objEntity.Expected_Upfront_Commission__c = 0;
                objEntity.Expected_Trail_Commission__c = 0;
                
                objEntity.Actual_RPP_Amount__c = 0;
                objEntity.Actual_Upfront_Commission__c = 0;
                objEntity.Actual_Trail_Commission__c = 0;
                setEntityId.remove(entityId);
                
                for(ARPP_Detail__c objARPP : mapEntitiyIdTolstARPP.get(entityId))
                {
                    objEntity.Recommended_Revenue__c += (objARPP.Action_Plan_Amount__c + objARPP.Action_Plan_Upfront_Comm_Amount__c + objARPP.Action_Plan_Trial_Comm_Amount__c);
                    objEntity.Actual_Revenue__c += (objARPP.Execution_Tracker_Amount__c + objARPP.Execution_Tracker_upfront_Comm_Amount__c + objARPP.Execution_Tracker_Trial_Comm_Amount__c);
                    
                    objEntity.Expected_RPP_Amount__c += objARPP.Action_Plan_Amount__c;
                    objEntity.Expected_Upfront_Commission__c += objARPP.Action_Plan_Upfront_Comm_Amount__c;
                    objEntity.Expected_Trail_Commission__c += objARPP.Action_Plan_Trial_Comm_Amount__c;
                    
                    objEntity.Actual_RPP_Amount__c += objARPP.Execution_Tracker_Amount__c;
                    objEntity.Actual_Upfront_Commission__c += objARPP.Execution_Tracker_upfront_Comm_Amount__c;
                    objEntity.Actual_Trail_Commission__c += objARPP.Execution_Tracker_Trial_Comm_Amount__c;
                    
                }
                
                lstUpdateEntity.add(objEntity);
            }
            if(setEntityId.size() > 0)
            {
                for(Id entityId : setEntityId)
                {
                    Account objEntity = new Account(Id = entityId);
                    objEntity.Recommended_Revenue__c = 0;
                    objEntity.Actual_Revenue__c = 0;
                    
                    objEntity.Expected_RPP_Amount__c = 0;
                    objEntity.Expected_Upfront_Commission__c = 0;
                    objEntity.Expected_Trail_Commission__c = 0;
                    
                    objEntity.Actual_RPP_Amount__c = 0;
                    objEntity.Actual_Upfront_Commission__c = 0;
                    objEntity.Actual_Trail_Commission__c = 0;
                    lstUpdateEntity.add(objEntity);
                }
            }
            if(!lstUpdateEntity.isEmpty() && !Test.isRunningTest())
            {
                /* Prajakta - 6-9-2013 */
                StaticMethodClass.isAccountUpsertFired = false;
                StaticMethodClass.isAccountSubmitHandlerFired = false;
				system.debug('----StaticMethodClass.isAccountSubmitHandlerFired------'+StaticMethodClass.isAccountSubmitHandlerFired);
                update lstUpdateEntity;              
            }
        }
        catch(Exception e)
        {
            system.debug('****************'+ e.getMessage());
        } 
    }
    
    
    //Test method for ARPP Details
    @isTest
    public static void testARPPHandler()
    {
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
        
        //Insert RecordType record
        List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
        RecTypes__c objRecType = new RecTypes__c(Name='General_Business', 
                                                 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
        
        RecTypes__c objRecType1 = new RecTypes__c(Name='AccountFamily', 
                                                 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
        RecTypes__c objRecType2 = new RecTypes__c(Name='AccountClient', 
                                                 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
        
        lstRecTypes.add(objRecType);                                         
        lstRecTypes.add(objRecType1);
        lstRecTypes.add(objRecType2);   
        insert lstRecTypes;
        
         //Insert smagicbasic SMS Template record 
        List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
        
        smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
                                                                                smagicbasic__ObjectName__c = 'Account');
        
        smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
                                                                                smagicbasic__ObjectName__c = 'Account');
        lstTemplate.add(template);
        lstTemplate.add(template1);
        
        insert lstTemplate;
                            
        //Insert Account record
        Account objGeneralAccount = new Account(Name='Parner Account Test',
                                    RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
        insert  objGeneralAccount;
                                                                        
        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
                           PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true );
                          
                           
        insert objAccount1;
        
        ARPP_Detail__c objARPP = new ARPP_Detail__c(Entity__c = objAccount1.Id, Action_Plan_Amount__c =1000,Action_Plan_Upfront_Comm_Amount__c=1, Action_Plan_Trial_Comm_Amount__c=1,
                                                    Execution_Tracker_upfront_Comm_Amount__c = 1, Execution_Tracker_Trial_Comm_Amount__c =1,Execution_Tracker_Amount__c =100);
       insert objARPP;  
       delete objARPP;
        
        
    }
}