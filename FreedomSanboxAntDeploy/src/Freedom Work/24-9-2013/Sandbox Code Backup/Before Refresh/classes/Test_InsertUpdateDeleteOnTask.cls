//By Aditi for testing Platform User Related Code
//Date : 30/08/12 
@isTest
private class Test_InsertUpdateDeleteOnTask {

    static testMethod void myUnitTest() 
    {
        // TO DO: implement unit test
        List<Task> lstTask = new List<Task>();
    	
    	
    	//======================================For Custom Lead======================================
    	Lead_Platform_User__c Custlead1 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Open', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
    	insert Custlead1;
    	
    	Task testTask = new Task(Status ='Completed',Subject ='Call',WhatId = Custlead1.Id);
        lstTask.add(testTask);
        
        Task testTask1 = new Task(Status ='Completed',Subject ='Call',WhatId = Custlead1.Id);
        lstTask.add(testTask1);
    
    	//======================================For Custom Lead======================================
    
        Lead Lead_1 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898',Platform_User_Lead__c = Custlead1.Id,  Age__c = 23);
    	insert Lead_1;
    	
    	Task testTask2 = new Task(Status ='Completed',Subject ='Call',WhoId = Lead_1.Id);
        lstTask.add(testTask2);
        
        Task testTask3 = new Task(Status ='Completed',Subject ='Call',WhoId = Lead_1.Id);
        lstTask.add(testTask3);
       
      	insert lstTask;
      	
      	
      	delete testTask1; //Custom 
      	delete testTask3; //Standard
      	
    }
    
    
    
}