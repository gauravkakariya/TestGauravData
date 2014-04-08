public with sharing class IntegrateGmailAndSalesforceTest
{
	public static testMethod void testIntegrateGmailAndSalesforce()
    {
    	try
    	{
	    	test.startTest();
	    	
	    	// create a new email and envelope object
			Messaging.InboundEmail email = new Messaging.InboundEmail() ;
			Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			
			IntegrateGmailAndSalesforce obj = new IntegrateGmailAndSalesforce();
					
	    	User objuser = new User( email = 'eternus@ffreedom.in',profileid = 'Financial Planner',UserName = 'test-user@fakeemail.com',alias = 'tuser1',CommunityNickName = 'tuser1',TimeZoneSidKey = 'America/New_York',LocaleSidKey = 'en_US',EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US',FirstName = 'Test_Parent_Fname',LastName = 'Test_Parent_Lname');
	        insert objuser;
	    	
	    	System.runAs(objuser)
	    	{
		    	/*=================For Entity====================*/   
		    	Account objAccount = new Account();
			    objAccount.RecordTypeId = RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c; //Prajakta//'01220000000DnK3';
			    objAccount.LastName = 'TestEntityLast';
			    objAccount.Entity_Status__c = 'Active';
			    objAccount.Agreement_Received__c = 'Yes';
			    objAccount.Cheque_Received_Date__c = Date.valueOf('2012-25-01 16:15:30');
			    objAccount.Client_Category__c = 'Neutral';
			    objAccount.Description = 'Test entity for InboundMail';
			    objAccount.Age__c = 25;
			    objAccount.Email_ID__c = 'jyoti.chouthai@eternussolutions.com';
			    insert objAccount;
			    
			   	List<Account> lstAct = [select Id,OwnerId,PersonEmail from Account where PersonEmail =: 'jyoti.chouthai@eternussolutions.com'];
			   	if(lstAct != null && lstAct.size() > 0)
	       		{
			    	// setup the data for the email
					email.plainTextBody = 'TestMethodForEntity';
					email.fromAddress =lstAct[0].PersonEmail;
					email.subject = 'TestMethodForEntity';
					
					Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env); 
					System.assert(result.success, 'InboundEmailResult returned a failure message');
				
			    	//obj.MapEntity(lstAct[0].PersonEmail,'TestMethodForEntity','TestMethodForEntity');
	       		}
		     	else
		       	{
			       /*=================For Lead====================*/    	
			    	Lead objLead = new Lead();
			    	objLead.Status = 'Open';
			    	objLead.LastName = 'TestLeadLast';
			    	objLead.Age__c = 30;
			    	objLead.MobilePhone = '12345678';
			    	objLead.Email = 'mahesh.hirugade@eternussolutions.com';
			    	objLead.LeadSource = 'Web';
			    	insert objLead;
		    	 	
			    	List<Lead> lstLead = [select Id,OwnerId,Email from Lead where Email =: 'mahesh.hirugade@eternussolutions.com' and Status != 'Converted'];
				   	if(lstLead != null && lstLead.size() > 0)
		       		{
		       			// setup the data for the email
						email.plainTextBody = 'TestMethodForLead';
						email.fromAddress = lstLead[0].Email;
						email.subject = 'TestMethodForLead';
						
						Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env); 
						System.assert (result.success, 'InboundEmailResult returned a failure message');
					
			    		//obj.MapEntity(lstLead[0].Email,'TestMethodForLead','TestMethodForLead');
			       	}
		       	}
	    	}
	    	test.stopTest();
    	}
    	catch(Exception ex)
    	{
    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    		mail.setToAddresses(new String [] {'tech@ffreedom.in'});
    		mail.setSubject('Exception In Email Functionality');
    		mail.SetPlainTextBody(String.valueof(ex));
    		
    		Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    	}
    }
}