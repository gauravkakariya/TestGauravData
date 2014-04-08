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
private class TestBatchDailyServiceDeliverableUpdate {

    static testMethod void UnitTest() {
        // TO DO: implement unit test
        test.startTest();
        
     	//Create Test records	
        Account objAccount = new Account(FirstName='Fname2',LastName='Lname2');
        insert objAccount;
         
        List<Task> lstTask = new List<Task>();
        Task testTask = new Task(Status ='Completed',Subject_Category__c ='Call',WhatId = objAccount.Id);
        lstTask.add(testTask);
        
        Task testTask1 = new Task(Status ='Completed',Subject_Category__c ='Call',WhatId = objAccount.Id , Completion_Date__c = System.Today().addDays(-4));
        lstTask.add(testTask1);
        
        Task testTask11 = new Task(Status ='Completed',Subject_Category__c ='Call',WhatId = objAccount.Id, Completion_Date__c = System.Today().addDays(-4));
        lstTask.add(testTask11);
        
        insert lstTask;
        
        Event  testEvent = new Event(Event_Category__c='Meeting',Event_Place__c='Test Place',Description='test',Event_Status__c ='Complete',
        								Completion_Date__c = System.Today().addDays(-4), Subject = 'Meeting',StartDateTime = System.now(),
        								EndDateTime = System.now().addMinutes(30),WhatId = objAccount.Id);
        insert testEvent;
        
        Event  testEvent1 = new Event(Event_Category__c='Meeting',Event_Place__c='Test Place',Description='test',Event_Status__c ='Complete',
        								Completion_Date__c = System.Today().addDays(-4), Subject = 'Meeting',StartDateTime = System.now(),
        								EndDateTime = System.now().addMinutes(30),WhatId = objAccount.Id);
        insert testEvent1;
        
        List<Service_Deliverables__c> lstServiceDeliverables =new List<Service_Deliverables__c>();
        
        //For New Member
        Id Record_Type_Id = [select Id,Name from RecordType where Name=: Label.New_Member].Id ;
        
        Service_Deliverables__c sd =new Service_Deliverables__c(RecordTypeId = Record_Type_Id, RelatedAccount__c = objAccount.Id, Expiration_Date__c = System.today(),
        														Call__c = 'December', Meeting__c = 'Q3', Completed__c=true);
        lstServiceDeliverables.add(sd);
        
        Service_Deliverables__c sd1 =new Service_Deliverables__c(RecordTypeId = Record_Type_Id, RelatedAccount__c=objAccount.Id, Expiration_Date__c = System.today());
        lstServiceDeliverables.add(sd1);
        
        //For Old Member
        Record_Type_Id = [select Id,Name from RecordType where Name=: Label.Ongoing_Member].Id ;
        
        Service_Deliverables__c sd2 =new Service_Deliverables__c(RecordTypeId=Record_Type_Id, RelatedAccount__c = objAccount.Id , Expiration_Date__c = System.today().addYears(1),
        															Call__c = 'May',Meeting__c = 'Q1');
        lstServiceDeliverables.add(sd2);
        
        Service_Deliverables__c sd3 =new Service_Deliverables__c(RecordTypeId=Record_Type_Id,RelatedAccount__c=objAccount.Id,Expiration_Date__c=System.today());
        lstServiceDeliverables.add(sd3);
        
        insert lstServiceDeliverables;
        
        BatchDailyServiceDeliverableUpdate objbatchProcess =new BatchDailyServiceDeliverableUpdate();
        objbatchProcess.mapOfCalenderCustomSetting = Calender__c.getAll();
        
        //objbatchProcess.alertDate =  System.today().addDays(1);
        objbatchProcess.CreateNewTask(sd,'Call','test');
        objbatchProcess.dtCurrentDate = System.today().addDays(1);
        
        objbatchProcess.query = 'select Name,RecordTypeId,RecordType.Name,RelatedAccount__c,Call__c,Meeting__c,Completed__c,Expiration_Date__c  from Service_Deliverables__c where id=\''+sd.id+'\' Or Id=\''+sd1.id+'\' Or Id=\''+sd2.id+'\' Or Id=\''+sd3.id+'\'';
        
        Database.executeBatch(objbatchProcess,4);
        
        test.stopTest(); 
        
    }
}