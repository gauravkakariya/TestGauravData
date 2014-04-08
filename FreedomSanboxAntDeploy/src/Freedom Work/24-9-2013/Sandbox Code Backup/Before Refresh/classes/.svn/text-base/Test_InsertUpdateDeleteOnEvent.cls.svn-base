@isTest
private class Test_InsertUpdateDeleteOnEvent {

    static testMethod void myUnitTest() 
    {
     	// TO DO: implement unit test
        List<Event> lstEvent = new List<Event>();
    	
    	//======================================For Custom Lead======================================
    	Lead_Platform_User__c Custlead = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Open', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
    	insert Custlead;
    	
    	Event Event1 = new Event(Subject = 'Meeting',StartDateTime = System.now(),EndDateTime = System.now().addMinutes(30),WhatId = Custlead.Id);
        lstEvent.add(Event1);
        
        Event Event2 = new Event(Subject = 'Meeting',StartDateTime = System.now(),EndDateTime = System.now().addMinutes(30),WhatId = Custlead.Id);
        lstEvent.add(Event2);
        
        	//======================================For Custom Lead======================================
    
        Lead Lead_1 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898',Platform_User_Lead__c = Custlead.Id,  Age__c = 23);
    	insert Lead_1;
    	
    	Event Event3 = new Event(Subject = 'Meeting',StartDateTime = System.now(),EndDateTime = System.now().addMinutes(30),WhoId = Lead_1.Id);
        lstEvent.add(Event3);
    	
    	Event Event4 = new Event(Subject = 'Meeting',StartDateTime = System.now(),EndDateTime = System.now().addMinutes(30),WhoId = Lead_1.Id);
        lstEvent.add(Event4);
    
      	insert lstEvent;

      	delete Event4; //Custom 
      	delete Event2; //Standard
    }
}