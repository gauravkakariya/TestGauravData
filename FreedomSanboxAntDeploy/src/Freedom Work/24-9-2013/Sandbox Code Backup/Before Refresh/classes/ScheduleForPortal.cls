/* way to write a batchabe class */
global class ScheduleForPortal implements Database.Batchable<sObject>{
    global String Query;
    String newQuery;
   // Datetime newDate;
   
     //  private  String SELECT_CLAUSE = 'Select  from ';
  //    private Final String WHERE_CLAUSE = ' where lastmodifieddate > :newDate';
    List<PortalObjects__c> CustomSettingPortalObjects = PortalObjects__c.getall().values();
                 
   // global ScheduleForPortal(){
   // }
         
   // Start Method
   global Database.QueryLocator start(Database.BatchableContext BC){
      Query = 'select name from lead limit 1';
      return Database.getQueryLocator(Query);
  }
           
   // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        list<PortalSync__c> lstSDR = new List<PortalSync__c>();
      //  List<PortalObjects__c> CustomSettingPortalObjects = PortalObjects__c.getall().values();
        String olddate;
        //datetime myDateTime = datetime.now();
       // Datetime newDate = myDateTime.addHours(-2);
         
         try
         {
          List<SyncScheduleJob__c> objSsclst  = [SELECT Batch_Start_Time__c FROM SyncScheduleJob__c order by lastmodifieddate desc limit 1];
          
          SyncScheduleJob__c objSsc = null;
          if(!objSsclst.isEmpty()){
          		objSsc = objSscLst.get(0);
            }
            else{
          	return;
          }
           
         Datetime newDate = objSsc.Batch_Start_Time__c;
         system.debug('**New Date='+newDate); 
         
         
         SyncScheduleJob__c Ssc = new SyncScheduleJob__c();
         Ssc.Batch_Start_Time__c = datetime.now();
         
         
         
         
        for(PortalObjects__c portalObject : CustomSettingPortalObjects){
            system.debug(portalObject.Name);
            if(portalObject.Name == 'feedcomment' )
            {
                 newQuery = 'Select id from ';
                 newQuery += portalObject.Name;
                 newQuery += ' where createdDate > :newDate';
            }
            else
            {
                 newQuery = 'Select id from ';
                 newQuery += portalObject.Name;
                 newQuery += ' where lastmodifieddate > :newDate';
            }
            system.debug(newQuery);
            List<SObject> lstAc =  Database.query(newQuery);
            
            system.debug('**************'+lstAc.size());

            PortalSync__c objSDR = null;
               
               if(!lstAc.isEmpty())
               {
                        for(SObject objAccount : lstAc){
		                objSDR = new PortalSync__c();
		                objSDR.Object_Id__c = objAccount.ID;
		                objSDR.Object_Type__c = portalObject.Object_Name__c;
		                
                        lstSDR.add(objSDR);
                        } 
               }
               else
                 {
                 	return;
                 }
                 
       }
      
        if(!lstSDR.isEmpty())   
            insert lstSDR;
            
            // SyncScheduleJob__c Ssc1 = new SyncScheduleJob__c();
             Ssc.Batch_End_Time__c = datetime.now();
             Ssc.No_Of_Records__c = lstSDR.size();
             insert Ssc;
             
         }
         catch(exception e)
         {
         	system.debug(e);
         }      
     }
       
    global void finish(Database.BatchableContext BC){
        system.debug('scheduled');
    }
         
     @isTest
     public static void testbatch(){
        List<Lead> leadList = new List<Lead>();
        Lead objLead;
        for(Integer i=0;i<20;i++){
            objLead = new Lead();
            objLead.LastName = 'test'+i;
            objLead.MobilePhone = '99887766554';
            leadList.add(objLead);
        }
        
        SyncScheduleJob__c sc = new SyncScheduleJob__c();
        sc.Batch_Start_Time__c = DateTime.now().addHours(-6);
        insert sc;
        insert leadList;
        
        PortalObjects__c po = new PortalObjects__c();
        po.Name = 'Lead';
        po.Object_Name__c='Lead';
        insert po;
       
        
        
        
        ScheduleForPortal sp = new ScheduleForPortal();
        sp.CustomSettingPortalObjects.add(po);
        
        test.startTest(); 
        Database.executeBatch(sp);  
       
        test.stopTest();
        
        //assertEquals
     } 
         
  }