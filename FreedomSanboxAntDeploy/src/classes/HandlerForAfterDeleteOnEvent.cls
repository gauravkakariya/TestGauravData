public with sharing class HandlerForAfterDeleteOnEvent 
{
    public void afterDeleteEvent(list<Event> lstEvent)
    {
        
        SyncDeletedRecords__c objSDR = null;
        
         list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();
         
        for(Event objEvent : lstEvent)
        {
        	objSDR = new SyncDeletedRecords__c();
            objSDR.Sobject_ID__c = objEvent.Id;
            objSDR.Sync_DataTime__c  = objEvent.LastModifiedDate;
            objSDR.SObjectType__c = 'Event';
            
            lstSDR.add(objSDR);
        }   
        insert lstSDR;
    
    }
    
    @IsTest(seealldata = true) 
      public static void testCoverage() 
      {
         TestData_Ffreedom testData = new TestData_Ffreedom();
         Account parent = new Account();
          parent = testData.initializeAccount();
          insert parent;
          Account child = new Account(); 
          child = testData.init_FamilyMember(parent);
          child.Portal_Id__c = '1';
          insert child;
          
          Event objEvent = new Event ();
          objEvent.Description= 'abcd';
          objEvent.Type= 'Email';
          objEvent.StartDateTime= date.ValueOf('2013-01-05'); 
          objEvent.EndDateTime=date.ValueOf('2013-01-08');
          insert objEvent;
             
          test.startTest();
              delete objEvent;
          test.stopTest();
       }
}