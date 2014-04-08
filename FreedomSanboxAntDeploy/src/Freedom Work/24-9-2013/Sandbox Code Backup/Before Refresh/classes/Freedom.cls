@isTest
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

private class Freedom {
 /* Test method for freedom project it covers two trigger */
    public static testMethod void myUnitTest() {
        
        /* Deployment : Prajakta Sanap */
        /* Creating a new Checklist and Inserting*/   
     	Checklist_Template__c checkListTemp = new  Checklist_Template__c(Context__c='a', Stage__c='b', Sequence__c=2);
      	insert checkListTemp;
      	
        //  creating a new checklist Template and Inserting 
        Checklist_Template__c cht = [select id, Context__c, Stage__c, Sequence__c
         from Checklist_Template__c limit 1];
        
        /* Creating a new Checklist and Inserting*/ 
        Checklist__c ch = new Checklist__c(Stage__c='prospecting',Checklist_Template__c = cht.Id );
        insert ch;
     
        
        /* creating a new checklist steps and inserting   */
        Checklist_Step__c chs = new Checklist_Step__c(Step_Status__c='Processing', Sequence__c=1,Checklist__c=ch.id);
            insert chs;    
        
        chs.Start_Date__c = System.today();
        update chs;  
                      
        /* creating a new checkliststeps and inserting to it  */
        checkList_Step__c clt = new checkList_Step__c( Name = ch.Name,
            Context__c = chs.Context__c,
            Checklist__c = ch.id,
            Stage__c = chs.Stage__c,
            Sequence__c = chs.Sequence__c,
           
            Step_Status__c = 'Not Started');
            insert clt;
            
        /* Creating a new event and inerting the value on it  */
        Event event = new Event(       
            WhatId = cht.id,
           /* Context__c = cht.Context__c,
            Stage__c = cht.Stage__c,*/
            Subject = 'hello',
            StartDateTime= System.now() + 1,
            EndDateTime=System.now() + 6,
            description = 'hi');
                          
            insert event;  
        
        Task tsk = new Task(       
            WhatId = cht.id,
           /* Context__c = cht.Context__c,
            Stage__c = cht.Stage__c,*/
            Subject = 'hello',
            ActivityDate = System.TODAY() + 1
            //StartDateTime= System.now() + 1,
           // EndDateTime=System.now() + 6,
           // description = 'hi'
            );
                          
            insert tsk;  
      
    }
}