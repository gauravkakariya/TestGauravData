/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class InboundEmailHistoryService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		
		 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setToAddresses(new String[] {'tech@ffreedom.in'});
         mail.setSenderDisplayName('Salesforce');  
         mail.setSubject('Varificatioin Code');
         mail.setPlainTextBody(email.plainTextBody);
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
        return result;
    }
    
   	static testMethod void myTestMethod() 
    {
	  	// Create a new email, envelope object and Attachment
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	     
	    email.subject = 'test';
	    email.plainTextBody = 'test';
	    env.fromAddress = 'tech@ffreedom.in';
	     
	    // call the class and test it with the data in the testMethod
	    InboundEmailHistoryService emailServiceObj = new InboundEmailHistoryService();
	    emailServiceObj.handleInboundEmail(email, env );                      
 	}
}