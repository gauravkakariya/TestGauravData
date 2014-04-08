@isTest
private class TestCreateLeadOnEmail {
	static testMethod void testJustDial(){  
		Messaging.InboundEmail email1 = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
		//Campaign objCam= new Campaign(Name='Just Dial');
		//insert objCam;
		email1.htmlBody = '<html><body><table><tr><td>JustDial Services</td></tr>  <tr><td align=/’left/’ class=/’style2/’ width=/’180/’><B>Caller Name : </B></td><td align=/’left/’ class=/’style2/’>Mr Dsouza From Sion</td></tr><tr><td align=/’left/’ class=/’style2/’ width=/’180/’><B>Caller Requirement : </B></td><td align=/’left/’ class=/’style2/’>Insurance Agents</td></tr><tr><td align=/’left/’ class=/’style2/’ width=/’180/’><B>Caller Phone : </B></td><td align=/’left/’ class=/’style2/’> 9321356273,02230843500</td></tr><tr><td align=/’left/’ class=/’style2/’ width=/’180/’><B>Email : </B></td><td align=/’left/’ class=/’style2/’><a href="mailto:janwasia.preeti@gmail.com" target="_blank">janwasia.preeti@gmail.com</a></td></tr><tr><td align=/’left/’ class=/’style2/’ width=/’180/’><B>Called From : </B></td><td align=/’left/’ class=/’style2/’>	9321356273 , 02230843500</td></tr><tr><td align=/’left/’ class=/’style2/’ width=/’180/’><B>Call Date & Time : </B></td><td align=/’left/’ class=/’style2/’>Fri, 04 Feb 2011 At 17:34:23</td></tr></table><body><html>';
		email1.fromname = 'FirstName LastName';
		env1.fromAddress = 'instantemail@justdial.com';
		env1.fromAddress = 'ashwin.dewan@ffreedom.in';
		//system.debug('testing from htmlBody'+email1.htmlBody);
		email1.subject = 'Test subject'; //
		
		Campaign cmp1 = new Campaign(Name = 'Just Dial');
        insert cmp1;
        
        
        Campaign cmp2 = new Campaign(Name = 'Sulekha Classifieds');
        insert cmp2;
        
		CreateLeadOnEmail createLead1 = new CreateLeadOnEmail();
		Messaging.InboundEmailResult result1 =createLead1.handleInboundEmail(email1, env1);
		
		/*Messaging.Inboundemail email3 = new Messaging.Inboundemail();
		Messaging.Inboundenvelope env3 = new Messaging.Inboundenvelope(); 
		email1.plainTextBody = 'Media Speaks:America Calling (Outlook)Dialling his way to success (Impact)Dial A Dream (Jade)'+
		'JustDial Services Instant Feedback for the Day Caller Details Caller Name : test first name Caller  : '+
		'Financial Planner Caller Phone : 1111111111  Caller Email : test@testmail.com Call Date & Time : '+
		'Thu, 16 Sep 2010 At 17:11:04 For any Queries, please feel free to call our Customer Support Division'+
		'on Tel.No 022-28888071 / 61607080 and speak to Customer Support Division OR Send an email to mumbai@justdial.com'+
		'Warm Regards,Team JustDial';
		email3.fromname = 'FirstName LastName';
		email3.subject = 'Test subject';
		env3.fromAddress = 'instantemail@justdial.com';
		//env3.fromAddress = 'ashwin.dewan@ffreedom.in';
		CreateLeadOnEmail createLead3 = new CreateLeadOnEmail();
		Messaging.InboundEmailResult result3=createLead3.handleInboundEmail(email3, env3);
		*/
	}
	static testMethod void testSulekha(){
		Messaging.Inboundemail email2 = new Messaging.Inboundemail();
		Messaging.Inboundenvelope env2 = new Messaging.Inboundenvelope(); 
		email2.plainTextBody = 'Dear Ffreedom Financial Planners,You have received an enquiry for Mutual Fund Investments for your business listing in Sulekha Yellow Pages. The enquiry details are below:'+
		'User name: Dhiraj Matlani(MUM)'+'Looking for: Mutual Fund Investments Preferences: Andheri Contact details of Dhiraj Matlani(MUM) Email id:abcd_1493@yahoo.co.in'+
		'Mobile: 9820619873 You can email us at yp@sulekha.net for any clarifications. Warm Regards, Team Sulekha Yellow Pages';
 		Campaign objCam=new Campaign(Name='Sulekha Classifieds');
 		insert objCam;
 		email2.subject = 'Test subject';
 		email2.fromname = 'FirstName LastName';
		env2.fromAddress = 'enq@ypleads.sulekha.com';
		email2.subject = 'Test subject';
		CreateLeadOnEmail createLead2 = new CreateLeadOnEmail();
		Messaging.InboundEmailResult result2=createLead2.handleInboundEmail(email2, env2);
	}
	static testMethod void testConfirmationCode(){
		Messaging.Inboundemail email4 = new Messaging.Inboundemail();
		Messaging.Inboundenvelope env4 = new Messaging.Inboundenvelope();
		email4.plainTextBody = 'Confirmation code: 57428160';
		//System.debug('email4.plainTextBody:'+email4.plainTextBody);
		email4.subject = 'Test subject';
 		email4.fromname = 'FirstName LastName';
 		email4.subject = 'Test subject';
		CreateLeadOnEmail createLead4 = new CreateLeadOnEmail();
		Messaging.InboundEmailResult result4=createLead4.handleInboundEmail(email4, env4);

	}
}