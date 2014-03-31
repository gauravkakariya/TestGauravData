public with sharing class RedirectToConveyanceManager 
{
	static testmethod void RedirectToConveyanceManager()
	{
		Test.startTest();
			
		List<User> lstUser = [Select u.IsActive, u.Id From User u Where u.IsActive = True and u.Profile.Name = 'System Administrator'];
		Lead objLead = new Lead();
		objLead.LastName = 'TestLead';
		insert objLead;
			
		Event objEvent = new Event();
		objEvent.OwnerId = lstUser[0].Id;
		objEvent.WhoId = objLead.id;
		objEvent.DurationInMinutes = 10;
		objEvent.Event_Status__c = 'complete';
		objEvent.Description = 'Test Description';
		objEvent.ActivityDateTime = System.today();
		objEvent.Completion_Date__c = System.today().addDays(2);
		objEvent.StartDateTime = System.today();
		objEvent.Event_Place__c = 'place';
		objEvent.Event_Category__c ='Meeting';
		objEvent.To_Time__c = '10';
        objEvent.From_Time__c = '20';
		insert objEvent;
		
		Event__c objCustomEvent = new Event__c();
		objCustomEvent.Completion_Date__c = objEvent.Completion_Date__c;
		objCustomEvent.Description__c = objEvent.Description;
		objCustomEvent.End__c = objEvent.EndDateTime;
		objCustomEvent.Event_Category__c = objEvent.Subject;
		objCustomEvent.Event_Status__c = 'complete';
		insert objCustomEvent;
		ApexPages.currentPage().getParameters().put('id', objCustomEvent.Id);
		
		Event__c objCustomEvent1 = new Event__c();
		objCustomEvent1.Completion_Date__c = objEvent.Completion_Date__c;
		objCustomEvent1.Description__c = objEvent.Description;
		objCustomEvent1.End__c = objEvent.EndDateTime;
		objCustomEvent1.Event_Category__c = objEvent.Subject;
		objCustomEvent1.Event_Status__c = '';
		insert objCustomEvent1;
		
		
		Conveyance_Manager__c objConveyanceManager = new Conveyance_Manager__c();
		objConveyanceManager.Event__c = objCustomEvent.id;
		objConveyanceManager.Is_Submitted__c=true;
		insert objConveyanceManager;
		
		PageReference pageRef = Page.RedirectToConveyanceManager;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', objConveyanceManager.Id);
		
			ApexPages.StandardController QController = new ApexPages.StandardController(objConveyanceManager);
			RedirectToConveyanceManager objRedirectToConveyanceManager = new RedirectToConveyanceManager(QController);
			objRedirectToConveyanceManager.objEvent = objCustomEvent;
			objRedirectToConveyanceManager.eventId = objCustomEvent.id; 
			objRedirectToConveyanceManager.Back();
			objRedirectToConveyanceManager.Init();
			
			ApexPages.StandardController QController1 = new ApexPages.StandardController(objConveyanceManager);
			RedirectToConveyanceManager objRedirectToConveyanceManager1 = new RedirectToConveyanceManager(QController);
			objRedirectToConveyanceManager1.objEvent = objCustomEvent1;
			objRedirectToConveyanceManager1.eventId = objCustomEvent1.id; 
			objRedirectToConveyanceManager1.Back();
			ApexPages.currentPage().getParameters().put('id', objCustomEvent1.Id);
			objRedirectToConveyanceManager1.Init();
		Test.stopTest();
	}
	
	String eventId{get;set;}
	Conveyance_Manager__c objConveyence = null;
	public	Event__c objEvent{set;get;}
	public Boolean bIsSubmited{get;set;}
	
	public RedirectToConveyanceManager(ApexPages.StandardController stdController)
 	{
 		 bIsSubmited = false;
 		this.objConveyence = (Conveyance_Manager__c)stdController.getRecord();
 		eventId = ApexPages.currentPage().getParameters().get('CF00N20000003B7dX_lkid');
      	if(eventId !=null && eventId != '')
		{
			objEvent = [Select e.OwnerId, e.Name, e.Id, e.Event_Status__c, e.Event_Place__c, e.Event_Category__c, e.End__c, e.Email__c, e.Duration__c, e.Description__c From Event__c e where e.Id =: eventId];
		}
		else
		{
			String StrtmpId = ApexPages.currentPage().getParameters().get('id');
			if(StrtmpId != null)
			{
				Conveyance_Manager__c objtmpConveyence = [Select 
															c.Remarks__c, 
															c.Name, 
															c.Id,c.Is_Submitted__c, 
															c.Event__c,
															c.Event__r.Name
														From Conveyance_Manager__c c 
														where c.Id =:StrtmpId];
	      		
	      							
	      							if(objtmpConveyence != null)
	      							{
	      								bIsSubmited = objtmpConveyence.Is_Submitted__c;
						      				eventId = objtmpConveyence.Event__c;
						      				objEvent = [Select e.OwnerId, 
						      							   e.Name, 
						      							   e.Id, 
						      							   e.Event_Status__c, 
						      							   e.Event_Place__c, 
						      							   e.Event_Category__c, 
						      							   e.End__c,
						      							   e.Email__c, 
						      							   e.Duration__c,
						      							   e.Description__c 
						      							   From Event__c e 
						      							   where e.Id =: eventId];
						  			}
			}
		}      	
   } 
 	
 	
 	public Pagereference Init()
 	{
 			Pagereference pgreference;
 			if(objEvent.Event_Status__c == 'Complete')
 			{
 				if(eventId != null && this.objConveyence.id != null)
 				{
 					if(bIsSubmited)
 					{
 						pgReference = new Pagereference('/apex/ConveyanceManager?id='+this.objConveyence.id+'&submit=submit'+'&eventId='+eventId);
 					}
 					else
 						pgreference = new Pagereference('/apex/ConveyanceManager?eventId='+eventId+'&id='+this.objConveyence.id);
 				}
 				else if(this.objConveyence.id != null)
 				   pgreference = new Pagereference('/apex/ConveyanceManager?id='+this.objConveyence.id);
				else if(eventId != null)
					pgreference = new Pagereference('/apex/ConveyanceManager?eventId='+eventId);
				else
					pgreference = new Pagereference('/apex/ConveyanceManager');
 			}
 			else
 			{
 				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Event Status is not complete');	
 				ApexPages.addMessage(myMsg);
 			}
 		return pgreference;
 	}
 	public Pagereference Back()
 	{
 		Pagereference pgreference = new Pagereference('/'+eventId);
 		return pgreference;
 		
 	}
 }