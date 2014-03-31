public with sharing class EmailFunctionality {

	public static void SendNewsLetters(List<User> lstUserEmail , List<Lead> lstLead ,List<Account> lstAccount)
	{
		try
		{
			EmailTemplate FfreedomNewsAlert = [Select e.OwnerId, e.Name, e.Id From EmailTemplate e where e.Name='Ffundamental News Letter' limit 1];
			EmailTemplate FfreedomNewsAlert_Lead = [Select e.OwnerId, e.Name, e.Id From EmailTemplate e where e.Name='Ffundamental News Letter Lead' limit 1];
			EmailTemplate FfreedomNewsAlert_Entity = [Select e.OwnerId, e.Name, e.Id From EmailTemplate e where e.Name='Ffundamental News Letter Entity' limit 1];
			List<Messaging.SingleEmailMessage> lstmails = new List<Messaging.SingleEmailMessage>(); // Master list of the Email of User & Lead
			// Added all the active user in to the News alert master List
			
			if(lstUserEmail != null && lstUserEmail.size() > 0)
			{
				for(User objUser : lstUserEmail)
				{
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					mail.setReplyTo('tech@ffreedom.in');
					mail.setBccSender(true);
					mail.setBccAddresses( new String[]{'ffreedomnews@gmail.com'});
					mail.setTemplateId(FfreedomNewsAlert.Id);
					//No need to set the Email id's once you added the Target Object Id.
					mail.setTargetObjectId(objUser.Id);
					// It's Compulsory to set activity false   
	   				mail.setSaveAsActivity(false);
	   				lstmails.add(mail);
				}
			}
			// Added all the active Lead in to the News aler master List
			
			if(lstLead != null && lstLead.size() > 0)
			{
				for(Lead objLead : lstLead)
				{
					if(objLead.Email != null && objLead.Email !='')
					{
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						mail.setReplyTo('tech@ffreedom.in');
						mail.setBccSender(true);
						mail.setBccAddresses( new String[]{'ffreedomnews@gmail.com'});
						mail.setTemplateId(FfreedomNewsAlert_Lead.Id);
						//No need to set the Email id's once you added the Target Object Id.
						mail.setTargetObjectId(objLead.Id);
						// It's Compulsory to set activity false
		   				mail.setSaveAsActivity(false);
		   				lstmails.add(mail);	
					}
				}
			}
			
			// Added all the active Influencers in to the News aler master List
			
			if(lstAccount != null && lstAccount.size() > 0)
			{
				Set<String> setofAccountId = new Set<String>();
				for(Account objAccount : lstAccount)
				{
					setofAccountId.add(objAccount.Id);
				}
				List<Contact> lstContact = [Select c.Id, c.Email, c.Birthdate, c.AccountId From Contact c where c.AccountId IN : setofAccountId];//All contacts with AccountIds in setofAccountId\
				if(lstContact != null && lstContact.size() > 0)
				{
					for(Contact objContact : lstContact)
					{
						if(objContact.Email != null && objContact.Email != '')
						{
						//String[] toAddresses = new String[]{objAccount.PersonEmail};
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						mail.setReplyTo('tech@ffreedom.in');
						mail.setBccSender(true);
						mail.setBccAddresses( new String[]{'ffreedomnews@gmail.com'});
						mail.setTemplateId(FfreedomNewsAlert_Entity.Id);
						//No need to set the Email id's once you added the Target Object Id.
						mail.setTargetObjectId(objContact.Id);
						// It's Compulsory to set activity false   
		   				mail.setSaveAsActivity(false);
		   				lstmails.add(mail);
						}
					}
				}
			}
			
			if(lstmails != null && lstmails.size() > 0)
			{	
				List<Messaging.Sendemailresult> lstResult = Messaging.sendEmail(lstmails,false);
				if(lstResult != null){
					for(Messaging.Sendemailresult email:lstResult){
   						if(email.isSuccess())
   						{
   							System.Debug('Mail Successfully sent  ===>'+email);
   						}
   					}
   				}
			}
		}
		catch(Exception ex)
		{
			EmailFunctionality.SendExceptionMail(ex);
		}
	}

	public static void SendExceptionMail(Exception ex)
	{
		String[] toAddresses = new String[] {'tech@ffreedom.in'};
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(toAddresses);
		mail.setPlainTextBody(ex.Getmessage());
		mail.setSubject('Unable to create Master List');
		mail.setSaveAsActivity(false);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
}