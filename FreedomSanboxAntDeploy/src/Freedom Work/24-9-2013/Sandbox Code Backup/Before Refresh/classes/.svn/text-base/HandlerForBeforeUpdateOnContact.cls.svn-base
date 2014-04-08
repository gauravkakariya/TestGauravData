public with sharing class HandlerForBeforeUpdateOnContact 
{
    public void beforeUpdateContact(List<Contact> lstNewContact, List<Contact> lstOldContact)
    {
       /* for(Contact objNewContact : lstNewContact)
        {
            for(Contact objOldContact : lstOldContact)
            {
               if(objNewContact.From_Portal__c == 1 && objNewContact.Synched_Date_Time__c > objNewContact.LastModifiedDate )
               {
                  objNewContact.From_Portal__c = 0; 
                  objNewContact.IsSynched__c = true;
               }
               else if(objOldContact.From_Portal__c == 1 && objOldContact.Synched_Date_Time__c < objOldContact.LastModifiedDate )
               {
                  objOldContact.From_Portal__c = 0;
               }
               else if(objOldContact.From_Portal__c == 0)
               {
                 objNewContact.IsSynched__c = false;
               }
               }
            
           }
    }/*
    
    @IsTest(seealldata = true) 
      public static void testCoverage() 
      {
         /*TestData_Ffreedom testData = new TestData_Ffreedom();
         Account testAcct = new Account();
          testAcct = testData.initializeAccount();
          insert testAcct; */
      }
}