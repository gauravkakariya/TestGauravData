/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav             13/03/2013     This Class is used to parse xml data of Xray and Create respective x ray record.
    											  This Apex class is Used to download attachment from Inbound Email Service.
*/

public with sharing class AttachXrayRecordController {
	
	public blob xmlFileBody{get;set;} 
	public blob newXmlFileBody{get;set;}
	public String fileName{get;set;}
  	public Question_Bank__c objActiveQuestionBank {set;get;}
  	public Integer queNo{get;set;} 
  	public boolean toperrmsg{get;set;}
	public List<Lead> leadList;
	public Map<String, String> xmlTagValueMap;
	
   	private Map<String, Set<String>> questionMap;
   	private Map<String, Set<String>> questionAnswerMap;
   	private Set<String> answerSet; 
   	private String leadId; 
	private String parentObjId;
	private String fromEmailAddress;
	
	
	//Constructor		
	public 	AttachXrayRecordController(){
		questionMap = new Map<string,Set<String>>();
		xmlTagValueMap = new Map<String, String>();	
	}

	//Parameterised Constructor		
	public 	AttachXrayRecordController(String strFromEmailAddress){
		questionMap = new Map<string,Set<String>>();
		xmlTagValueMap = new Map<String, String>();	
		fromEmailAddress = strFromEmailAddress;
		leadList = new List<Lead>(); 
	}

 	//Read the content of XmlFile
	public PageReference readXmlFileBody(){
		
		//Check Content of Xmlfile, if not valid Xml file body then throws Error
		if(xmlFileBody <> Null)
			newXmlFileBody = xmlFileBody;
		else{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please Attach valid file'));
			 toperrmsg=true;
			 return Null;	
		}	
		//Check Filename of Xmlfile, if not valid Xml file then throws Error
		if(fileName <> Null && fileName <> '' && fileName.toLowerCase().contains('.xml'))
			parseXmlFileRecord(newXmlFileBody);	
		else{
			  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please Attach valid file'));
			  toperrmsg=true;
			  return Null;
			 
		}	
		return Null;
	}
	
	//Parse Xml file Record
	public void parseXmlFileRecord(blob pNewXmlFileBody){
		
		questionAnswerMap = new Map<String, Set<String>>();
		XmlStreamReader xsr = new XmlStreamReader(pNewXmlFileBody.tostring());
		while(xsr.hasNext())
		{
			if(xsr.getEventType()== XmlTag.START_ELEMENT)
			{
				if( xsr.getLocalName() <> 'topmostSubform'){//'fields'){
					String xmlValue = xsr.getLocalName();
					//xmlTagValueMap.put(q_no,reader.getText());
					//Call to ParseRecord method 
					parseRecord(xmlValue, xsr);
					
				}
			}
			xsr.next();
		}
		//Call to insertLeadRecord() for inserting lead record
		insertLeadRecord(xmlTagValueMap);
		
		if(questionAnswerMap <> Null && leadId <> NULL)
		//insertxrayScoreCardRecord( questionMap, leadId);
		insertxrayScoreCardRecord( questionAnswerMap, leadId);
	}
	
	//Send Mail to Freedom Team
	public Messaging.SingleEmailMessage setEmail( String subject, String mailbody){
        Messaging.SingleEmailMessage successEmail = new Messaging.SingleEmailMessage();
        String[] toAddresses ;
       		if(Test.isRunningTest()){
      			toAddresses = new String[] {'abc@Test.com'};
       		}
       		else{
        		toAddresses = new String[] {fromEmailAddress};
       		}
        //Send Mail to Marketing team and cc to related partner when Lead owner is Freedom team 
        String[] ccAddresses = new String[] {Label.Xray_Pdf_To_Email_Address};
        successEmail.setToAddresses( toAddresses);
        successEmail.setCcAddresses(ccAddresses); 
        successEmail.setSubject( subject );
        successEmail.setHtmlBody(  mailbody );
        return successEmail;
    }//End setEmail   
	
	
	//Send Sccessful Mail if lead created
	public void sendSuccessMail(){
		List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
		if( leadList.size() > 0){
		        String subject  = 'Status of Lead Record';
		        String mailbody = getMailBody( leadList );
		        emails.add(setEmail( subject, mailbody )); 
		    }//End If 
		    Messaging.sendEmail( emails );  
	}  
	   
	//Get the Content in Xml Tag
	public void parseRecord(String questionNumber, XmlStreamReader reader)
	{   
		answerSet = new Set<String>();
		while(reader.hasNext())
		{
			if (reader.getEventType() == XmlTag.END_ELEMENT) {
           	break;
        	}
			 else if (reader.getEventType() == XmlTag.CHARACTERS) {
          		/*system.debug('&&&&&&&&&&&&&'+questionNumber+'--' + reader.getText());
          		answerSet.add(reader.getText());
          	}*/
          			//Put the question Number  and Its Answer in xmlTagValueMap
          	        xmlTagValueMap.put(questionNumber,reader.getText());
          	          	
          	        //If it questionAnswerMap already contain questionNumber then get new answer for that QuestionNumber
          			if(questionAnswerMap.containsKey(questionNumber)){
						Set<String> newAnswerSet = questionAnswerMap.get(questionNumber);
						newAnswerSet.add(reader.getText());
						questionAnswerMap.put(questionNumber, newAnswerSet);
					}else{
						Set<String> newAnswerSet = new Set<String>();
						newAnswerSet.add(reader.getText());
						questionAnswerMap.put(questionNumber, newAnswerSet);
					}
			 }//else if
           reader.next();
		}
		//Put QuestionNumber and AnswerValue Set  in questionMap
		questionMap.put(questionNumber, answerSet);
	}
	
	//Create Lead Record 
	public void insertLeadRecord(Map<String, String> xmlTagValueMap){
		
		Lead newLead = new Lead();
		 
		List<String> leadNameList= new List<String>();
			
			//Get the User from Email id or Name equal to Freedom Team
			List<User> objUserList = [Select Name, Email,ProfileId, ContactId, UserType, IsActive From User Where (Email = : fromEmailAddress and IsActive =: true) OR (Name =:'Ffreedom Team')  Limit 1];//fromEmailAddress];
			if(objUserList.size() > 0){
				Profile profile = [Select Name From Profile Where Id =:objUserList[0].ProfileId Limit 1];
				if((objUserList[0].ContactId != Null && objUserList[0].UserType =='PowerPartner') || 
					(objUserList[0].ProfileId != Null && profile.Name == 'Financial Planner') || 
					(objUserList[0].Name.compareTo('Ffreedom Team') == 0)){
					newLead.OwnerId = objUserList[0].Id;
				}	
			
				String leadName = xmlTagValueMap.get('Name');
				leadNameList = leadName.split(' ', -1);
				if(leadNameList.size() == 1 ){
					newLead.FirstName = '';
					newLead.LastName = xmlTagValueMap.get('Name');
				}
				else{ 
				newLead.FirstName  = leadNameList[0];
				Integer size = leadNameList.size();
				newLead.LastName = leadNameList[size-1];
				}
				
				newLead.Email = xmlTagValueMap.get('Email_id');
				newLead.Age__c = Double.valueOf(xmlTagValueMap.get('Age'));
				newLead.Occupation__c = xmlTagValueMap.get('Occupation');
				newLead.MobilePhone = xmlTagValueMap.get('Mobile_No');
				
				try{	
					insert newLead;
					
					if(objUserList[0].Name.compareTo('Ffreedom Team') == 0){
						//List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						//String subject = 'Lead Creation for Xray';
						//String mailBody = 'Lead Created and Owner is Set to '+ '\"Freedom Team\" as No match  is found for Bussiness Partner'+
			            				   //' and Financial Planner';
		            	//setEmail(subject, mailBody );	
						
						
			            String[] toAddresses ;
			            
			            String[] ccAddresses = new String[] {Label.Xray_Pdf_To_Email_Address};
			          
				        if(Test.isRunningTest()){
	      					toAddresses = new String[] {'abc@Test.com'};
			       		}
			       		else{
			        		toAddresses = new String[] {fromEmailAddress};
			       		} 
			       		
			       		mail.setToAddresses(toAddresses);
			           	mail.setCcAddresses(ccAddresses); 
			            mail.setSenderDisplayName('Salesforce Support');
			            mail.setSubject('Lead Creation for Xray ');
			            mail.setHtmlBody( 'Lead Created and Owner is Set to '+ '\"Freedom Team\" as No match  is found for Bussiness Partner'+
			            				   ' and Financial Planner' );
			            				   
			            				   
			           	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			           // Messaging.sendEmail(emails);
					}
					
					leadList.add(newLead);
					leadId = newLead.Id;
				}	
				catch(Exception ex){
					//List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					//String subject = 'Error in Lead Creation for Xray';
					//String mailBody = 'Error in Lead Creation for Xray.<br /> '+ ' Error : '+ex.getMessage()+'. <br />'
					//				   +
					//				  'Please check whether your profile is Bussiness partner or Financial Planners.';
		            //mail = setEmail(subject, mailBody );	
		            			  
		            String[] toAddresses;
		            String[] ccAddresses = new String[] {Label.Xray_Pdf_To_Email_Address};
		           	mail.setToAddresses(toAddresses);
		           	mail.setCcAddresses(ccAddresses);
		           	if(Test.isRunningTest()){
      					toAddresses = new String[] {'abc@Test.com'};
		       		}
		       		else{
		        		toAddresses = new String[] {fromEmailAddress};
		       		} 
		            mail.setSenderDisplayName('Salesforce Support');
		            mail.setSubject('Error in Lead Creation for Xray ');
		            mail.setHtmlBody('Error in Lead Creation for Xray.<br /> '+ ' Error : '+ex.getMessage()+'. <br />'+
		            					  'Please check whether your profile is Bussiness partner or Financial Planners.');
		            
		           	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		           
				}
			}//end if
	}
   
    //Get XrayScoreCard Detail Recods for that particular Lead 
   	private Id getxrayScoreCardDetails(String pLeadId){
   		
   		if(pLeadId == NULL) return NULL;
   		
   		//Custom Setting used for collecting id of X-Ray questions
		Database.Saveresult saveResult; 
	    Map<String, QuestionBank__c> QuestionBank = QuestionBank__c.getAll();
	    String finXRayId = QuestionBank.get('FinancialXRay').Question_Bank__c;	
	    system.debug('****finXRayId****'+finXRayId);
	    //Getting the Qustion bank of Xray
	    Question_Bank__c objActiveQuestionBank = [Select Id,Name,IsActive__c 
	    										  From Question_Bank__c 
	    										  Where IsActive__c = true And Id =: finXRayId 
	    										  limit 1];
   
   		//Check whether it is Lead or Entity ID as per it create X-Ray Records
   		X_Ray_Score_Card_Detail__c xrayScoreCardDetails = new X_Ray_Score_Card_Detail__c();
		if(pLeadId.startsWith('00Q'))
			xrayScoreCardDetails.Lead__c = pLeadId;
		else if(pLeadId.startsWith('001'))
		    xrayScoreCardDetails.Entity__c = pLeadId;
		else{  
		   xrayScoreCardDetails.Lead__c = Null;
		   xrayScoreCardDetails.Entity__c = Null;
		}  
		xrayScoreCardDetails.Question_Bank__c = objActiveQuestionBank.Id;
		saveResult = Database.insert(xrayScoreCardDetails);
   		String xrayScoreId = saveResult.getId();
   		return xrayScoreId;
   	}
   	/*
   	//Insert Xray record which user not given answer
   	public void insertNotAnswerXrayRecord(Set<String> pQuestionNameSet){
   		Set<String>  defaultQuestionSet;
		Map<String, Set<String>> defaultQuestionAnswerMap  = new Map<String, Set<String>>();	
		Set<String> defaultAnswerSet = new Set<String>();
		for(Question_Bank_List__c questionNameSet : [Select Name from Question_Bank_List__c where Name Not IN :pQuestionNameSet]){
			defaultQuestionSet.add(questionNameSet.Name);
		}
		
		
		system.debug('****defaultQuestionSet'+defaultQuestionSet);
		
		for(String questionBankList : defaultQuestionSet){
			Set<Question_Option_List__c> optionListSet  = getOptionListRecords(defaultQuestionSet, questionBankList);
			for(Question_Option_List__c answerOptionList: optionListSet){
				if(questionBankList <> 'Q17' || questionBankList<> 'Q3' || questionBankList <> 'Q10')
					answerOptionList.Name = 'No';
				else if(questionBankList<> 'Q17'){
					answerOptionList.Name = 'Real Estate';	
				}
				
				defaultAnswerSet.add(answerOptionList.Name);
				
			}
			defaultQuestionAnswerMap.put(questionBankList,defaultAnswerSet);
			
		}
		
	}*/
   	
	//Crate Xray Score Card Record
	public void insertxrayScoreCardRecord(Map<String, Set<String>> questionAnswerMap, Id pleadId){
		
		Map<String, Id> questionsMap = new Map<String, Id>();
		Map<String, Id> optionMap = new Map<String, Id>();	
		Boolean isSuccess = false;
		if(questionAnswerMap.size() == 0 ) return;			
		List<Question_Option_List__c> questionOptionList = new List<Question_Option_List__c>();		
		questionOptionList.clear();	
		
       	List<Question_Option_List__c> newOptionList = new List<Question_Option_List__c>();
       	/*
       	for(String strQuestion : questionAnswerMap.keySet()){
       			for(String strAnswer : questionAnswerMap.get(strQuestion)){
       				
       				system.debug('******strAnswer'+strAnswer);
       				if((strQuestion <> Null || strQuestion <> '')  && (strAnswer <> Null || strAnswer <> '')){
       					
       					system.debug('******strAnswer'+strAnswer);
						for(Question_Option_List__c optionList : 
								[Select Id, Name, Question_Bank_List__c, Score__c,Question_Bank_List__r.Name From Question_Option_List__c 
								 Where Question_Bank_List__r.Name =: strQuestion And Name =:strAnswer]){
								 	system.debug('******optionList'+optionList);
								 	newOptionList.add(optionList);
						}
       				}//if	
       			}//inner for		
		}//outer for
		*/
		
		//Get All the Answer or Option related to question that User given answer
		List<Question_Option_List__c> answerOptionList =  [Select Id, 
																  Name, 
																  Question_Bank_List__c, 
																  Score__c,
																  Question_Bank_List__r.Name 
														   From Question_Option_List__c 
								 						   Where Question_Bank_List__r.Name IN: questionAnswerMap.keySet()];
								 
		for(Question_Option_List__c option : answerOptionList ){
			Set<String> ansSet = questionAnswerMap.get(option.Question_Bank_List__r.Name);
			if(ansSet.contains(option.Name)){
				System.debug('**Test Ans:'+ option.Question_Bank_List__r.Name +' = ' + option.Name);
				newOptionList.add(option);
			}
		}
		
		//Get the Answer of question which User given
		for(Question_Option_List__c optionList : [Select Id, 
														 Name, 
														 Question_Bank_List__c, 
														 Score__c,Question_Bank_List__r.Name 
												  From Question_Option_List__c 
												  Where Question_Bank_List__r.Name IN:questionAnswerMap.keySet()]){
													
				questionsMap.put(optionList.Question_Bank_List__r.Name, optionList.Question_Bank_List__c);
				optionMap.put(optionList.Question_Bank_List__r.Name, optionList.Id);
		}
		
		//Insert Xray Score Card Details Record
		Id xrayScoreDetailsId = (Id)getxrayScoreCardDetails(pleadId);
		List<XRay_ScoreCard__c> listRecords = new List<XRay_ScoreCard__c>();
		List<Option_Detail__c> insertOptionList = new List<Option_Detail__c>();
		List<String> newOptionListForQuestion = new List<String>();
		List<XRay_ScoreCard__c> insertXrayRecordList = new List<XRay_ScoreCard__c>();
		
		/*Insert Xray Record and Option Details Record related to that lead and 
		XrayScoreCardDetails Record*/
		for(Question_Option_List__c OptionList :newOptionList ){
				
				if(OptionList.Question_Bank_List__r.Name == 'Q17'){
					newOptionListForQuestion.add(OptionList.Question_Bank_List__r.Name);
				}
				if(newOptionListForQuestion.size() > 1 && optionList.Question_Bank_List__r.Name == 'Q17'){
					continue;
				}
				else{
					XRay_ScoreCard__c xrayScoreCard = new XRay_ScoreCard__c();
					xrayScoreCard.xrayScoreCardMaster__c = 	xrayScoreDetailsId;
					xrayScoreCard.Question_Bank_List__c = OptionList.Question_Bank_List__c;
					xrayScoreCard.Score_Master__c = OptionList.Score__c;
					
					insertXrayRecordList.add(xrayScoreCard);
				}
			/*
				Option_Detail__c optionDetail = new Option_Detail__c();
				optionDetail.xrayScoreCard__c = xrayScoreCard.Id; 
				optionDetail.QuestionMaster__c = OptionList.Question_Bank_List__c;//questionsMap.get(setRecord);
				optionDetail.Answer__c =  OptionList.Id;//optionMap.get(setRecord);
			 	optionDetail.Answer_Text__c = OptionList.Name;	
			 	
			 	insertOptionList.add(optionDetail);
			 	system.debug('*****optionDetail'+optionDetail);
			 	*/
		}	
		try{
			insert insertXrayRecordList;
			isSuccess = true;
		}catch(DmlException e) {
			system.debug('*****Error Message'+e.getMessage());	
		}
		if(isSuccess){
			insertOptionList = getOptionDetailsListRecords(insertXrayRecordList, newOptionList);
			if(insertOptionList <> NULL ||  insertOptionList.size() > 0)
				insert insertOptionList;
		}		
	}//end of insertxrayScoreCardRecord
	
	//Get the Option Details Record Related tp XrayScoreCard and 
	private List<Option_Detail__c> getOptionDetailsListRecords(List<XRay_ScoreCard__c> pXrayScoreCardList, 
														       List<Question_Option_List__c> pOptionList){
		List<Option_Detail__c> insertOptionList = new List<Option_Detail__c>();
		
		//if(pXrayScoreCardList == NULL || pXrayScoreCardList.size() == 0) return Null ;
		//if(pOptionList == NULL || pOptionList.size() == 0) return Null ;
		
		for(XRay_ScoreCard__c xrayScoreCard : pXrayScoreCardList){
			for(Question_Option_List__c optionList : pOptionList){	
				if(xrayScoreCard.Question_Bank_List__c  == optionList.Question_Bank_List__c){
					Option_Detail__c optionDetail = new Option_Detail__c();
					optionDetail.xrayScoreCard__c = xrayScoreCard.Id; 
					optionDetail.QuestionMaster__c = xrayScoreCard.Question_Bank_List__c;
					optionDetail.Answer__c =  optionList.Id;
			 		optionDetail.Answer_Text__c = optionList.Name;
			 		insertOptionList.add(optionDetail);
				}	
			}//inner for	
		}
			system.debug('*****insertOptionList'+insertOptionList);
			return insertOptionList;
	}//end getOptionListRecords method 
	/*
	private Set<Question_Option_List__c> getOptionListRecords(Set<String> pQuestionSet , String pQuestionName){
		
		List<Question_Option_List__c>  optionListSet = [Select Id, Name, Question_Bank_List__c, Score__c,Question_Bank_List__r.Name From Question_Option_List__c 
														Where Question_Bank_List__r.Name IN :pQuestionSet OR Question_Bank_List__r.Name =: pQuestionName];
		Set<Question_Option_List__c> abcSet =  new Set<Question_Option_List__c>();											
		abcSet.addAll(optionListSet);
		return abcSet;
	} 
	*/
	
	  /*-----------------Start :  To Create A MailBody **********************/
    private String getMailBody( List<Lead> leadList ){
        
         String table_body = '';
         //String nostatus_table_body = '<tr color="blue" align="center"><td colspan="7"> Status Not Calculated for Records </td></tr>';
         boolean uflag = false, nuflag=false;
         String temp;
            for(Lead lead : leadList ){
            	String leadId = lead.Id;
                String leadName = lead.FirstName + ' ' + lead.LastName;
                String status = 'Successfully Inserted';
                
                temp = '<tr>'+
                                '<td>' + leadId + '</td>' +
                                '<td>' + leadName + '</td>' +
                                '<td>' + status + '</td>' +
                                
                        '</tr>';
                if( status != null ){ table_body += temp; uflag = true;}
               // else{ nostatus_table_body += temp; nuflag = true; }
        
            }//End for
        
         if( !uflag )table_body = '';
        // if( !nuflag ) nostatus_table_body = '';
         String mailBody = '<html>' +
                                '<head><title>Title Page</title></head>' +
                                '<body>' +
                                    '<table border="1px"><tr color="blue" align="center"><td colspan="3"> Xray Status Of Lead Record </td></tr>'+
                                    '<tr color="blue">' +
                                        '<th> Lead Id</th>'+
                                        '<th> Lead Name </th>'+
                                        '<th> Lead Status</th>'+
                                    '</tr>' +
                                    table_body +
                                    '</table>' +
                                '</body>' +
                           '</html>';
         return mailBody;
    }//End getMailBody Method
}//end of AttachXrayRecordController class