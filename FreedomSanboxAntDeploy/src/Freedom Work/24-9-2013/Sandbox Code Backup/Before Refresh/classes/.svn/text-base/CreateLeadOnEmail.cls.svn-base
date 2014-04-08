global class CreateLeadOnEmail implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope env){
	  	 System.debug('Inbound Email:'+email);
	  	// System.debug('Inbound envelope:'+env);
	  	 Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	  	 
	  	 List<Campaign> lstC = [Select c.Name, c.Id From Campaign c where c.Name='Just Dial'];
	  	 Campaign justDial;
	  	 if(!lstC.IsEmpty())
	  	 	justDial = lstC[0];
	  	 
	  	 List<Campaign> lstS= [Select c.Name, c.Id From Campaign c where c.Name='Sulekha Classifieds'];
	   	 Campaign sulekha;
	   	 	 if(!lstS.IsEmpty())
	  	 	sulekha = lstS[0];
	  	 
	  	//System.debug('FROM ADDRESS:'+env.fromAddress);
	  	 QueueSobject fpQueue = [Select q.Queue.Name, q.QueueId From QueueSobject q where q.Queue.Name='FPQueue' limit 1];
	  	 
	  	 Id id = fpQueue.QueueId;
	 	 String myPlainText= '';
	 	 String myHtmlText= '';
	 	 Boolean isHtmlBodyTruncated=False;
	 	 Boolean isPlainTextBodyTruncated=False;
	 	 String Subject = '';
	 	 String []emailReferences=null;
	 	 
	 	 Id campaignId;
	 	 
	 	 try{
		 	 if(email!=null){
		 	 	myPlainText = email.plainTextBody;
		 	 	myHtmlText = email.htmlBody;
		 	 	isHtmlBodyTruncated = email.htmlBodyIsTruncated;
		 	 	isPlainTextBodyTruncated = email.plainTextBodyIsTruncated;
		 	 	Subject = email.Subject;
		 	 	emailReferences = email.references;
		 	 }
		 	 System.debug('myHtmlText'+myHtmlText);
			 System.debug('isHtmlBodyTruncated'+isHtmlBodyTruncated);
		 	 System.debug('isPlainTextBodyTruncated'+isPlainTextBodyTruncated);
		 	 System.debug('Subject'+Subject);
		 	 System.debug('emailReferences'+emailReferences);
		 	 System.debug('My Plain Text outside if-blocks:'+myPlainText);
		     String fromAddress = '';
		     if(email!=null && email.fromAddress!=null){
		     	fromAddress = email.fromAddress;
		     }
			
		 	 if(myPlainText!=null && myPlainText.indexOf(Label.Confirmation_code)!=-1){//////////check for confirmation code
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        mail.setToAddresses(new String[] {Label.Technology_Support});
		        mail.setReplyTo(Label.Technology_Support);
		        mail.setSenderDisplayName(Label.Confirmation_Code_Lead);  
		        mail.setSubject(Label.Verify_Email_Subject);
		        mail.setPlainTextBody(myPlainText);
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		   	} 
		 	else{ /////////////check for emails other than confirmation code
		 		String leadEngineType=null;
			 	 String allDetails='';
			 	 String interestedIn='';
			 	 String location='';
			 	 String mobileNumber='';
			 	 String alternateMobileNumber='';
			 	 String emailAddress='';
			 	 String name='';
			 	 boolean error=false;
			 	 Exception errorLead;
		 	 
		 		
		 		if(myPlainText!=null && myPlainText.indexOf(Label.Team_Sulekha_Yellow_Pages)!=-1){////////////if email from sulekha
		 			try{
			 			leadEngineType = Label.SulekhaClassifieds;////set lead Engine Type as "sulekha"
			 			
			 			if(sulekha != null && sulekha.Id != null)
			 				campaignId = sulekha.Id;////set campaign Id as Sulekha
			 				 
				 		//System.debug('My Plain Text inside Sulekha:'+myPlainText);
						Integer lookingForStart = myPlainText.indexOf(Label.Looking_for);
				 	    Integer lookingForEnd = lookingForStart+13;
					 	Integer nameStart = myPlainText.indexOf(Label.name); 
					 	Integer nameEnd = nameStart + 5;
					 	Integer preferencesStart  = myPlainText.indexOf(Label.Preferences);
					 	Integer emailStart = myPlainText.indexOf(Label.Email_id);
					 	Integer emailEnd = emailStart + 10;
					 	Integer mobileStart = myPlainText.indexOf(Label.Mobile);
					 	Integer mobileEnd = mobileStart +8;
					 	Integer bracketStart = myPlainText.indexOf('(',nameEnd);
					 	Integer bracketEnd = myPlainText.indexOf(')',nameEnd);
					 	location = myPlainText.substring(bracketStart+1, bracketEnd);/////retrieve location
					 	interestedIn = myPlainText.substring(lookingForEnd, preferencesStart);/////retrieve preferences
					 	allDetails = myPlainText.substring(nameStart, mobileEnd + 10);/////retrieve all Details 
					 	allDetails += ' ' + Label.SulekhaClassifieds;
					 	String nameText=myPlainText.substring(nameEnd,lookingForStart);
					 	name=myPlainText.substring(nameEnd,bracketStart);   //////retrieve name
					    
					 	for(Integer i=mobileEnd;i<=mobileEnd+10;i++){
					 		mobileNumber += myPlainText.substring(i, i+1);
					 	}
					 	emailAddress = myPlainText.substring(emailEnd, mobileStart);/////retrieve email Address 
		 			} 
		 			catch(Exception e){
		 				error=true;
		 				errorLead = e;
		 			}
			     }/////sulekha block ends
		 	
			 	else if(myHtmlText!=null && myHtmlText.indexOf(Label.JustDial)!=-1 || fromAddress.contains(Label.justdial_com) ){////if email from just dial
				 	try{
				 		System.debug('My Plain Text inside Just Dial:'+myPlainText);
				 		leadEngineType = Label.JustDialServices;////set lead Engine Type as "Just Dial"
				 		if(justDial != null && justDial.Id != null)
				 			campaignId = justDial.Id;///set campaign Id as Just Dial
				 			
					 	Integer nameStart = myHtmlText.indexOf(Label.capsName);
					 	Integer nameEnd  = nameStart + 6;
					 	Integer requirementStart=0;
					 	Integer requirementEnd=0;
					 	Integer phoneStart =  myHtmlText.indexOf(Label.Phone);
					 	Integer phoneEnd = phoneStart + 7;
					 	String mobileNumber1='';
					 	String alternateMobileNumber1='';
					 	String name1='';
					 	String interestedIn1='';
					 	String emailAddress1='';
					 /////////////	String phoneNumber1='';
					 ////////////	String phoneNumber2='';
					 	String requirement='';
					 	Integer callDateStart = myHtmlText.indexOf(Label.Call_Date);
					 	Integer timeStart =  myHtmlText.indexOf(Label.Time);
					 	Integer callerDetailsStart = myHtmlText.indexOf(Label.Caller_Details);
					 	Integer callerDetailsEnd = callerDetailsStart + 15;
					 	
					 	//-----------retrieve name starts------------------
					 	Integer columnStartName = myHtmlText.indexOf('<td',nameEnd);
					 	Integer greaterThanSignName = myHtmlText.indexOf('>',columnStartName);
						Integer columnEnd = myHtmlText.indexOf('</td>',greaterThanSignName);
						name1 = myHtmlText.substring(greaterThanSignName,columnEnd); 
						
						if(name.indexOf(Label.From_Label)!=-1){
							Integer fromTextStart = myHtmlText.indexOf(Label.From_Label,greaterThanSignName);
							Integer fromTextEnd = fromTextStart + 4;
							name1= myHtmlText.substring(greaterThanSignName +1,fromTextStart);
							//System.debug('name with from'+name);
							location = myHtmlText.substring(fromTextEnd+1,columnEnd);
							//System.debug('location'+location);
						}
						//-----------retrieve name Ends------------------
						
					
						//-----------retrieve Requirement starts------------------
						if(myHtmlText.indexOf(Label.Requirement)!=-1){
							requirementStart = myHtmlText.indexOf(Label.Requirement);
					 		requirementEnd = requirementStart + 15;
							Integer columnStartRequirement = myHtmlText.indexOf('<td',requirementEnd);
							Integer greaterThanSignRequirement = myHtmlText.indexOf('>',columnStartRequirement);
							Integer columnEndRequirement = myHtmlText.indexOf('</td>',greaterThanSignRequirement);
							interestedIn1 = myHtmlText.substring(greaterThanSignRequirement +1,columnEndRequirement);
							//System.debug('interestedIn'+interestedIn);
						}
						//-----------retrieve Requirement Ends-----------------
						
				 		//-----------retrieve Phone Starts------------------
				 		Integer columnStartPhone = myHtmlText.indexOf('<td',phoneEnd);
						Integer greaterThanSignPhone = myHtmlText.indexOf('>',columnStartPhone);
						Integer columnEndPhone = myHtmlText.indexOf('</td>',greaterThanSignPhone);
						
						for(Integer i=greaterThanSignPhone+1;i<=greaterThanSignPhone+11;i++){
					 		 mobileNumber1 += myHtmlText.substring(i, i+1);
					 	}
					 	if(myHtmlText.substring(greaterThanSignPhone+12,greaterThanSignPhone+13)== ','){
					 		for(Integer i=greaterThanSignPhone+14;i<=greaterThanSignPhone+24;i++){
							 		alternateMobileNumber1 += myHtmlText.substring(i, i+1);
						 	}
					 	}
					 	//-----------retrieve Phone Ends------------------
					 	
					 	//-----------retrieve Email Starts------------------
					 	if(myHtmlText.indexOf(Label.Email)!=-1){
					 		Integer emailStart= myHtmlText.indexOf(Label.Email);
					 		Integer emailEnd = emailStart + 7;
					 		
					 		Integer columnStartEmail = myHtmlText.indexOf('<td',emailEnd);
					 		Integer greaterThanSignEmail = myHtmlText.indexOf('>',columnStartEmail);
					 		Integer columnEndEmail = myHtmlText.indexOf('</td>',greaterThanSignEmail);
					 		emailAddress1 = myHtmlText.substring(greaterThanSignEmail +1,columnEndEmail);
					 		
					 		//Integer anchorTagStart =  myHtmlText.indexOf('<a',columnStartEmail);
					 		//Integer greaterThanSignEmail = myHtmlText.indexOf('>',anchorTagStart);
					 		//Integer anchorTagEnd = myHtmlText.indexOf('</a>',greaterThanSignEmail);
					 		//emailAddress1 = myHtmlText.substring(greaterThanSignEmail+1,anchorTagEnd);
					 		System.debug('emailAddress1'+emailAddress1);
					 	}
					 	
					 	//-----------retrieve Email Ends------------------
					 	
					 	//-----------retrieve All details Starts------------------
					 	allDetails = myHtmlText.substring(nameStart, callDateStart);////retrieve all details
					 	allDetails += ' ' + Label.JustDialServices;
					 	String	allDetails1 = allDetails.replace('<td', '');
					 	String	allDetails2 = allDetails1.replace('</td>', '');
					 	String	allDetails3 = allDetails2.replace('<b>', '');
					 	String	allDetails4 = allDetails3.replace('</b>', '');
					 	String	allDetails5 = allDetails4.replace('', '');
					 	String	allDetails6 = allDetails5.replace('</a>', '');
					 	String	allDetails7 = allDetails6.replace('<a', '');
					 	String	allDetails8 = allDetails7.replace('align=\'left\'', '');
					 	String	allDetails9 = allDetails8.replace('<tr>', '');
					 	String	allDetails10 = allDetails9.replace('</tr>', '');
					 	String	allDetails11 = allDetails10.replace('href=\'mailto:\'', '');
					 	String	allDetails12 = allDetails11.replace('width=\'180\'', '');
					 	String	allDetails13 = allDetails12.replace('target=\'_blank\'', '');
					 	String	allDetails14 = allDetails13.replace('class=\'style2\'', '');
					 	String	allDetails15 = allDetails14.replace('width=\'28%\'', '');
					 	String	allDetails16 = allDetails15.replace('valign=\'top\'',  '' );
					 	String	allDetails17 = allDetails16.replace('>',  '' );
					 	System.debug('all details'+allDetails17);
					 	//-----------retrieve alldetails ends--------
					 	
					 	mobileNumber = mobileNumber1.replace(Label.star, '');
					 	alternateMobileNumber = alternateMobileNumber1.replace(Label.star, '');
	
					 	String trimmedName1=name1.replace(Label.star, '');
					 	name=trimmedName1.replace(Label.Caller, '');
					 	
					 	String trimmedinterestedIn1 = interestedIn1.replace(Label.star, '');
					 	interestedIn = trimmedinterestedIn1.replace(Label.Caller, '');
					 	
					 	emailAddress = emailAddress1.replace(Label.star, '');
					 	System.debug('emailAddress'+emailAddress);
				 		
				 	}
				 	catch(Exception e){
		 				error = true;////set error flag to true
		 				errorLead = e;
		 			}
				} //////Just Dial block ends
				lead ld1;
				if(leadEngineType!=null){
					if(!error){   ///if not error lead insert lead and add to just dial or sulekha campaign 
						ld1 = new Lead(FirstName='',LastName=name,Lead_Engine_Type__c=leadEngineType,OwnerId=id,Status='Open',Description=allDetails,MobilePhone=mobileNumber,Interested_In__c=interestedIn,LeadSource='Lead Engines',Location__c=location,Email=emailAddress);
					    
			 		}
					
			 		else if(error){ ////if error in lead create error lead and insert error lead
			 			ld1 = new Lead(FirstName='',LastName='Error in lead',OwnerId=id,LeadSource='Lead Engines',Description=allDetails);
			 			
			 			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				        mail.setToAddresses(new String[] {Label.Technology_Support});
				        mail.setReplyTo(Label.Technology_Support);
				        mail.setSenderDisplayName(Label.Error_in_Lead);  
				        mail.setSubject(Label.Error_in_Lead);
				        mail.setPlainTextBody(errorLead.getMessage());
				        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			 		} 
			 		insert ld1;  
				    CampaignMember cmp = new CampaignMember(CampaignId=campaignId, LeadId=ld1.Id);
		        	insert cmp;
				}/////lead engine check ends
	  		 }////outer else ends
	 	 }
	 	 catch(Exception e){
	 	 	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses(new String[] {Label.Technology_Support});
	        mail.setReplyTo(Label.Technology_Support);
	        mail.setSenderDisplayName(Label.Error_in_Lead);  
	        mail.setSubject(Label.Error_in_Lead);
	        mail.setPlainTextBody(e.getMessage());
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	 	 }
  		 result.success = true;
     	 return result;
   	  }/////Method handle inbound email ends
 }//////create lead on email class ends