public with sharing class HandlerForBeforeUpdateOnLead 
{
	public void beforeUpdateLead(List<Lead> lstNewLead, List<Lead> lstOldLead)
		{
			SyncDeletedRecords__c objSDR = new SyncDeletedRecords__c();
					for(Lead objNewLead : lstNewLead)
					{
						if(objNewLead.IsConverted == true)
						{
						 objSDR.Sobject_ID__c = objNewLead.ID;
				    	 objSDR.SObjectType__c = 'Lead';
				    	 objSDR.IsConvertedLead__c = true;
						}
				    	 
						
					}
		
	}
	
	@IsTest(seealldata = true) 
      public static void testCoverage1() 
      { 
          Lead objlead = new Lead();
          objlead.LastName  = 'Test1';
          objlead.Company  = 'Eternus';
          objlead.From_Portal__c = 0;
          objlead.IsSynched__c = true;
          objlead.Portal_Id__c = '6';
          
          Lead objlead1 = new Lead();
          objlead1.LastName  = 'Test1';
          objlead1.Company  = 'Eternus';
          objlead1.Synched_Date_Time__c = system.now(); 
          objlead1.From_Portal__c = 1;
          objlead1.IsSynched__c = true;
          objlead1.Portal_Id__c = '6';
           
          test.startTest();
              insert objlead;
             objlead.Company  = 'Accenture';
              update objlead;
              insert objlead1;
              objlead1.Company  = 'Wipro';
              update objlead1;
          test.stopTest();
       }
}