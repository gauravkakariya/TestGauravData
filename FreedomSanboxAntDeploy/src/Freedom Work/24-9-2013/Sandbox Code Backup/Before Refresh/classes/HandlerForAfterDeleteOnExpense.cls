public with sharing class HandlerForAfterDeleteOnExpense 
{
    public void afterDeleteExpense(list<Expense__c> lstExpense)
    {
        system.debug('************************81.1'+lstExpense);
        SyncDeletedRecords__c objSDR = null;
        
         list<SyncDeletedRecords__c> lstSDR = new List<SyncDeletedRecords__c>();

        for(Expense__c objExpense : lstExpense)
        {
            objSDR = new SyncDeletedRecords__c ();
            objSDR.Sobject_ID__c = objExpense.ID;
            objSDR.Sync_DataTime__c  = objExpense.Synched_Date_Time__c;
            objSDR.SObjectType__c = 'Expense__c';
            lstSDR .add(objSDR);
        }   
        insert lstSDR ;
    
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
          
          Expense__c objExp = new Expense__c();
          objExp.Annualized__c = 12563;
          objExp.Portal_Parent_Entity__c = '1';
          objExp.From_Portal__c = 0;
          insert objExp;
             
          test.startTest();
              delete objExp;
          test.stopTest();
       }
    
    
}