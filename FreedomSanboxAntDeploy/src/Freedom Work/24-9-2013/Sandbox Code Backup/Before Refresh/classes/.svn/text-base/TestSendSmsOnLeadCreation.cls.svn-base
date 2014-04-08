/*
	
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   2.0		   Manasi Ranade     22/12/2011	  	Issue ID : FS0310 : Added Appointment_Time__c as it was throwing an exception because of Lead validation rule
   3.0  	   Prajakta Sanap    26/04/2013		Created TestData_Ffreedom which contains all the test data for this test class.			  											
*/
@isTest
private class TestSendSmsOnLeadCreation 
{
    static testMethod void testSendSMSOnInsert() 
    {
    	List<Lead> leadList = new List<Lead>();
    	List<Lead> updateLeadList = new List<Lead>();
        Lead ld = new Lead(FirstName='Fname',LastName='Lname',LeadSource='Lead Engines', MobilePhone='9221527253',Email='rupesh@gmail.com');
        leadList.add(ld);
        Lead ld1 = new Lead(FirstName='Fname1',LastName='Lname1',Status='Open', MobilePhone='9221527253',Email='rupesh1@gmail.com');
        leadList.add(ld1);
        Lead ld2 = new Lead(FirstName='Fname2',LastName='Lname2',Status='Open', MobilePhone='9221527253',Email='rupes2h@gmail.com');
        leadList.add(ld2); 
        Lead ld3 = new Lead(FirstName='Fname3',LastName='Lname3',Status='Open', MobilePhone='9221527253',Email='rupesh22@gmail.com');
        leadList.add(ld3);
        insert leadList;
        
        Lead leadOne=[select Id, Status,Appointment_Time__c from Lead where FirstName = 'Fname1' LIMIT 1];
        leadOne.Status='Meeting Fixed';
        leadOne.Appointment_Time__c= System.now();
        updateLeadList.add(leadOne);
        
        Lead leadTwo=[select Id, Status from Lead where FirstName = 'Fname2' LIMIT 1];
        leadTwo.Status='Meeting Done';
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: FS0310      	**/
		/** Date    : 22/12/2011    **/
		/** Purpose : Added Appointment_Time__c as it was throwing an exception because of Lead validation rule
		/****************************************************/
        leadTwo.Appointment_Time__c = System.today();
        leadTwo.Ffreedom_Score__c=34;
        leadTwo.Probability__c='75%';
        leadTwo.Close_Date__c=System.today();
        
        updateLeadList.add(leadTwo);
        
        Lead leadThree=[select Id, Status from Lead where FirstName = 'Fname3' LIMIT 1];
        leadThree.Status='Converted';
        updateLeadList.add(leadThree);
        
        update updateLeadList;
    }
    
}