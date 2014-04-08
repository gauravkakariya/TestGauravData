global with sharing class SendSmsScheduler Implements Schedulable
{
	
	global void Execute(SchedulableContext SC)
	{
 	 	//funSendSMS();
 	}
 	
 	/*@future (callout=true)  
 	static void funSendSMS()
 	{
 		List<SMS_History__c> lstSMSHistory =  [Select s.Sent_SMS__c, s.SMSText__c, s.Mobile_Number__c,s.CreatedDate  From SMS_History__c s where Sent_SMS__c = false  order by CreatedDate desc limit 10];
 		System.debug('=====lstSMSHistory ==========='+lstSMSHistory );
 		List<Messaging.SingleEmailMessage> lstSingleEmailMessage = new List<Messaging.SingleEmailMessage>();
 		
 		if(lstSMSHistory != null && lstSMSHistory.size() > 0)
 		{
 			 PhpHelloservice.helloService smsService = new  PhpHelloservice.helloService();
 			 Credential_For_SMS__c objCredentials= Credential_For_SMS__c.getInstance('QLC Credential');
	      	 List<SMS_History__c> lstSmsHistoryToBeUpdate = new List<SMS_History__c>();
	      	 String userId = objCredentials.UserName__c;
	         String key =  objCredentials.Key__c;
		     String return_cell_number = objCredentials.Reply_Number__c;
		  
 			for(SMS_History__c objSmsTobeSend : lstSMSHistory)
 			{
 				String strMobilePhone = '@91'+objSmsTobeSend.Mobile_Number__c;
 				try
 				{
 					String bodyText = objSmsTobeSend.SMSText__c;
	  				String strSuccess = smsService.sendSms(userId, key, strMobilePhone, return_cell_number, bodyText);
	  				System.debug('=====strSuccess############==========='+strSuccess);
	  				if(strSuccess.contains('200'))
	  					objSmsTobeSend.Sent_SMS__c = true;
	  				lstSmsHistoryToBeUpdate.add(objSmsTobeSend);
 				}
 				catch(Exception ex)
 				{
 						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					   	String[] toAddresses = new String[] {'tech@ffreedom.in'};
					   	mail.setToAddresses(toAddresses);
					   	mail.setSubject('SMS Sending Failed:' +strMobilePhone);
					   	mail.setPlainTextBody('SMS Sending Failed due to the'+ex.getMessage());
					   	lstSingleEmailMessage.add(mail);
					  	//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 				} 
  			}
  			Messaging.sendEmail(lstSingleEmailMessage);
  			
  			if(lstSmsHistoryToBeUpdate != null && lstSmsHistoryToBeUpdate.size() > 0 )
  				Database.update(lstSmsHistoryToBeUpdate);
 		}
 	}*/
}