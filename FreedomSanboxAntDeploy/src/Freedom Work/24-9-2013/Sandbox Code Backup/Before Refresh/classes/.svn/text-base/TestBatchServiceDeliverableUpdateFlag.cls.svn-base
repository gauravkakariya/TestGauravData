/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestBatchServiceDeliverableUpdateFlag {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         // TO DO: implement unit test
        test.startTest();
        
     	//Create Test records	
        Account objAccount = new Account(FirstName='Fname2',LastName='Lname2');
        insert objAccount;
         
        Task testTask = new Task(Status ='Completed',Subject ='Call',WhatId = objAccount.Id);
        insert testTask;
        
        Event  testEvent = new Event(Event_Category__c='meeting',Event_Place__c='Test Place',Description='test',Event_Status__c ='Complete',Completion_Date__c = System.Today(), Subject = 'Meeting',StartDateTime = System.now(),EndDateTime = System.now().addMinutes(30),WhatId = objAccount.Id);
        insert testEvent;
        
        List<Service_Deliverables__c> lstServiceDeliverables =new List<Service_Deliverables__c>();
        
        //For New Member
        Id Record_Type_Id = [select Id,Name from RecordType where Name=:Label.New_Member].Id ;
        Integer year =  System.today().year();
        Date currentDate = Date.newInstance(year, 3, 31);
        String strDate = String.valueOf(currentDate); 
        Service_Deliverables__c sd =new Service_Deliverables__c(RecordTypeId=Record_Type_Id,RelatedAccount__c=objAccount.Id,Expiration_Date__c=System.today().addYears(2),Call__c = 'December',Meeting__c = 'Q3',Completed__c=false,End_Date__c=System.today());
        Service_Deliverables__c sd1 =new Service_Deliverables__c(RecordTypeId=Record_Type_Id,RelatedAccount__c=objAccount.Id,Expiration_Date__c=System.today().addYears(2),Call__c = 'December',Meeting__c = 'Q3',Completed__c=false,End_Date__c= currentDate);
        lstServiceDeliverables.add(sd);
        lstServiceDeliverables.add(sd1);

        insert lstServiceDeliverables;
        
        BatchServiceDeliverableUpdateCompFlag objbatchProcess =new BatchServiceDeliverableUpdateCompFlag();

        objbatchProcess.query = 'select Name,RecordTypeId,RecordType.Name,RelatedAccount__c,Call__c,Meeting__c,Completed__c,End_Date__c from Service_Deliverables__c where id=\''+sd.id+'\' or id=\''+sd1.id+'\'';
        Database.executeBatch(objbatchProcess,5);
        
        test.stopTest(); 
    }
}