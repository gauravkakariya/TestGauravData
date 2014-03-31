public with sharing class HandlerForBeforeInsertContact 
{
    public void beforeInsertContact(List<Contact> lstNewContact)
        {
            for(Contact objContact : lstNewContact)
            {
                objContact.IsSynched__c = false;
            }
        }
        


      @IsTest
      public static void testCoverage() 
      {
        Contact objContact = new Contact();
        objContact.lastname = 'abc';
          test.startTest();
        insert objContact;
          test.stopTest();
      
      }
      }