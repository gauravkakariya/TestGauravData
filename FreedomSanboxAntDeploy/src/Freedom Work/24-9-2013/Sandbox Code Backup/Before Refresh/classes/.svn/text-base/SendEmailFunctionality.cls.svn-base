public with sharing class SendEmailFunctionality 
{
	public static void sendCVattachment(Lead lead,Attachment fileAttachment)
	{
		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
		try
		{
			if(lead != null)
			{
				/** Eternus:Setty:00001772 Email to Swati Thakkar**/
				String test = Label.SwatiThakkar;
				String bcc= Label.Technology_Support;
				String[] bccAddresses= new String[]{bcc};
				System.debug('Technology support email id'+ bccAddresses);
				String[] toAddresses = new String[] {test};
      	      	mail.setToAddresses(toAddresses);
      	      	mail.setSubject(Lead.Role_Position__c +'&'+ Lead.Location__c);
      	      	mail.setBccAddresses(bccAddresses);
      	      	 
      	      	// Need to Optimise this code by using this function
      	      	String strhtmlBody = '<html> <body> Hi<br/>Positions Application has come from the website on '+ System.now()+'<br/> <br/>';
      	      	strhtmlBody +='First Name :'+Lead.FirstName+'<br/>';
      	      	strhtmlBody +='Last Name  :'+Lead.LastName+'<br/>';
      	      	strhtmlBody +='Email id   :'+Lead.Email+'<br/>';
      	      	strhtmlBody +='Mobile number:'+Lead.MobilePhone+'<br/>';
      	      	
        /** Eternus Solutions       **/
		/** Author  : Trupti         **/
		/** Issue Id: FS0310    	**/
		/** Date    : 23/11/2011 	**/
		/** Purpose : Add this two field Current/Permanent location and Preferred location
		/****************************************************/ 
      	      	strhtmlBody +='Interested in :'+Lead.Interested_In__c +'Sales Role'+'<br/>';
      	      	strhtmlBody +='Current & Expected CTC  :'+ Lead.Current_CTC__c+'/'+ Lead.Expected_CTC__c+ '<br/>';
      	      	strhtmlBody +='Notice Period :'+Lead.Notice_Period__c+'<br/>';
      	      	strhtmlBody +='Please respond to the same ASAP.</body> </html>';
      	      	
      	     	mail.setHtmlBody(strhtmlBody);
      	     	/** End:00001772**/
      	     	
      	     	if(fileAttachment != null)
      	     	{
      	     		Messaging.Emailfileattachment emailAttachment = GetEmailfileattachmentByAttachment(fileAttachment);
      	     		mail.setFileAttachments(new Messaging.Emailfileattachment[]{emailAttachment}); 
      	     	}
      	     	 Messaging.sendEmailResult[] sendEmailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      	     	 for(Messaging.SendEmailResult sendEmailResult: sendEmailResults)
      	     	 {
		     		if(!sendEmailResult.isSuccess())
		     		{
		        		System.debug('############# Email Sent #########');
		     		}
				}
			}
		}
		catch(Exception ex)
		{
			// call the SendException method
			
			SendExceptionMail(ex);
			System.debug('++++++++++++++++ Send email Functionality Exception ###############'+ex);
		}
	}
	
	public static Messaging.EmailFileAttachment GetEmailfileattachmentByAttachment(Attachment fileAttachment)
	{
		  Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    	  attach.setContentType(fileAttachment.contentType);
		  attach.setFileName(fileAttachment.Name);
		  attach.setInline(false);
		  attach.Body = fileAttachment.Body;
		  return attach;
	}
	
	public  static void SendExceptionMail(Exception ex)
	{
		//Single Mail send 
		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
		String[] toAddresses = new String[] {'tech@ffreedom.in'};
      	mail.setToAddresses(toAddresses);
      	mail.setSubject('Exception in attachment of Cv on Careers Page Of Website');
      	mail.setHtmlBody('This gives Error When attach CV and SendEmail');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
      	
     }
}