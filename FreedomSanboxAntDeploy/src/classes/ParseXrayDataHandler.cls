/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav             03/06/2013     This Class is used to parse xml data of Xray and Create respective x ray record
    
*/

public with sharing class ParseXrayDataHandler {
	/*
	private Id parentId; 
	private String parentObjId;
	
	public List<Question_Bank_List__c> lstQuestions {get;set;}
  	public List<Questionnaire__c> lstQuestionnaire {get;set;}
  	public List<Question_Bank__c> lstQuestionBank{get;set;}
  	public Question_Bank__c objActiveQuestionBank {set;get;}
  	public Integer queNo{get;set;} 
  	public Map<ID,List<Question_Option_List__c>> mapQuesIdAnswers{set;get;}  
  	public Lead objLead{set;get;}
  	Map<ID,Question_Option_List__c> mapOfOptionList{set;get;}
  	List<XRay_ScoreCard__c> lstXrayScoreCard = new List<XRay_ScoreCard__c> ();
  	public Boolean displayPopUp {get; set;}  
  	public Double dblFreedomScore{set;get;}  
  	public Integer quesSequence { get;set; }
   	
   	private Map<String, Set<String>> questionMap = new Map<string,Set<String>>();
   	
   
   	private Id getXrayScoreCardDetails(){
   		
   	//Custom Setting used for collecting id of X-Ray questions
		Database.Saveresult saveResult; 
	    Map<String, QuestionBank__c> QuestionBank = QuestionBank__c.getAll();
	    String finXRayId = QuestionBank.get('FinancialXRay').Question_Bank__c;	
	     //Getting the Qustion bank of Xray
	    Question_Bank__c objActiveQuestionBank = [Select Id,Name,IsActive__c 
	    										  From Question_Bank__c 
	    										  Where IsActive__c = true and Id =: finXRayId 
	    										  limit 1];
   
   	//Check whether it is Lead or Entity ID as per it create X-Ray Records
   	X_Ray_Score_Card_Detail__c XrayscoreCardDetails = new X_Ray_Score_Card_Detail__c();
		if(parentObjId.startsWith('00Q'))
			XrayscoreCardDetails.Lead__c = parentId;
		else if(parentObjId.startsWith('001'))
		    XrayscoreCardDetails.Entity__c = parentId;
		else{  
		   XrayscoreCardDetails.Lead__c = Null;
		   XrayscoreCardDetails.Entity__c = Null;
		}  
		XrayscoreCardDetails.Question_Bank__c = objActiveQuestionBank.Id;
		saveResult = Database.insert(XrayscoreCardDetails);
   		String xrayScoreId = saveResult.getId();
   		return xrayScoreId;
   	}
   	
   	
	public void onAfterInsert(List<Attachment> pAttachementList){
		
		for(Attachment tempAttchement : pAttachementList )
			{
				parentId= tempAttchement.ParentId;
				parentObjId = tempAttchement.ParentId;
				if(parentObjId.startsWith('00Q') ||(parentObjId.startsWith('001')) )
				{
					system.debug('***********Detected Attachment on Lead object');
					
					if(tempAttchement.ContentType=='text/xml')
					{
						system.debug('######### Text/Xml Attachment');
						
						String xmlString = tempAttchement.Body.toString();
						system.debug('^^^^^^^^^^^^^^^^'+ xmlString);
						XmlStreamReader xsr = new XmlStreamReader(xmlString);
						
						while(xsr.hasNext())
						{
							if(xsr.getEventType()== XmlTag.START_ELEMENT)
							{
								system.debug('************'+xsr.getLocalName());
								String q_no = xsr.getLocalName();
								parseRecord(q_no, xsr);
							}
							xsr.next();
						}
					}
					else
					{
						system.debug('******** Other Attachment');
					}
				}
				else
				{
					system.debug('***********Detected Attachment on other object');
				}
			}
			System.debug('---Test'+ questionMap );
			insertRecords( questionMap );
			
	}
	
	//Get the Content in Xml Tag
	public void parseRecord(String q_no, XmlStreamReader reader)
	{
		Set<String> tempSet = new Set<String>();
		while(reader.hasNext())
		{
			if (reader.getEventType() == XmlTag.END_ELEMENT) {
           	break;
        	} else if (reader.getEventType() == XmlTag.CHARACTERS) {
          		system.debug('&&&&&&&&&&&&&'+reader.getText());
          		tempSet.add(reader.getText());
          	}
           reader.next();
		}
		questionMap.put(q_no, tempSet);
	}
	
	//Insert X-ray Score Card Record
	private void insertRecords(Map<String, Set<String>> qSet){
		
		Map<String, Id> questionsMap = 
						new Map<String, Id>();
		Map<String, Id> optionMap = 
						new Map<String, Id>();	
		List<Question_Option_List__c> questionOptionList = new List<Question_Option_List__c>();		
		questionOptionList.clear();	
			
		//for(Question_Bank_List__c q_no :[select Id, Name from Question_Bank_List__c]){
			//	questionsMap.put(q_no.Name, q_no);
		//}
		for(Question_Option_List__c optionList : 
			[select Id, Name, Question_Bank_List__c, Score__c,Question_Bank_List__r.Name from Question_Option_List__c 
				where Question_Bank_List__r.Name IN:qSet.keySet()]){
				
				
				questionsMap.put(optionList.Question_Bank_List__r.Name, optionList.Question_Bank_List__c);
				optionMap.put(optionList.Question_Bank_List__r.Name, optionList.Id);
				questionOptionList.add(optionList);
				questionOptionList.sort();
				system.debug('**questionOptionList'+questionOptionList);
		}
		
		Id xrayScoreDetailsId = (Id)getXrayScoreCardDetails();
		List<XRay_ScoreCard__c> listRecords = new List<XRay_ScoreCard__c>();
		List<Option_Detail__c> listOption = new List<Option_Detail__c>();
		
		for(String setRecord : qSet.keySet()){
			if( questionsMap.containsKey(setRecord)){
				XRay_ScoreCard__c xrayscorecard = new XRay_ScoreCard__c();
				xrayscorecard.XRayScoreCardMaster__c = 	xrayScoreDetailsId;
				xrayscorecard.Question_Bank_List__c = questionsMap.get(setRecord);
				for(Question_Option_List__c OptionList :questionOptionList ){
					system.debug('**OptionList'+OptionList);
					xrayscorecard.Score_Master__c = OptionList.Score__c;
				}	
				insert xrayscorecard;
			//}
			//if( optionMap.containsKey(setRecord)){
			if(xrayscorecard.Id !=NULL){
				Option_Detail__c optionDetail = new Option_Detail__c();
				optionDetail.XRayScoreCard__c = xrayscorecard.Id; 
				optionDetail.QuestionMaster__c = questionsMap.get(setRecord);
				optionDetail.Answer__c = 	optionMap.get(setRecord);
				for(String tempStr : qSet.get(setRecord)){
					optionDetail.Answer_Text__c = tempStr;
				}
				insert optionDetail;
				//listOption.add(optionDetail);
			}
		}
		
	  }

	}*/
}