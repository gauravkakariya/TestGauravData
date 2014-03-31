/*
  Revision History:
  
    Version     Version Author     Date         Comments
    1.0         Gaurav            17/7/2012       This class is used to Export all details related to Freedom Scale Card
   
*/

public with sharing class ExportToExcelFreedomScaleController 
{
	public List<Wellness_Option_Detail__c>	lstWellneesOptionDetail{get;set;}
	public List<WrapperExportToExcel> lstWrapperExportToExcel{get;set;}
	public string entityId{get;set;}
	public Boolean isRender{get;set;}
	Map<Id,map<string,string>> mapScoreCardToScoreCardOption;
	
	//Constructor
	public ExportToExcelFreedomScaleController()
	{
		lstWrapperExportToExcel = new List<WrapperExportToExcel>();
		Map<Id, String> mapAccountIdTOOwner = new Map<Id, String>();
		Map<Id,List<String>> mapWellnessScoreCardIdTOAnswer = new Map<Id,List<String>> ();
		entityId = ApexPages.currentPage().getParameters().get('entityid'); 
		List<Wellness_Score_Card__c> lstWellnessScoreCard = new List<Wellness_Score_Card__c>();
		List<Wellness_Option_Detail__c>	lstWellneesOptionDetail = new List<Wellness_Option_Detail__c>();
		isRender = false;
		mapScoreCardToScoreCardOption = new map<Id,map<string,string>>();//new Map<Id,List<String>>();
		
		if(ApexPages.currentPage().getParameters().get('entityid') == '')
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid or Insufficient Parameter(s)'));
			isRender = true;
            return;
		}
		
		if(!ApexPages.currentPage().getParameters().containsKey('entityid'))
		{	
			//Collect all Freedom Scale Record 
			lstWellnessScoreCard = [Select Wellness_Test_Date__c, 
										   Account__r.Name, Account__r.OwnerId, 
										   Account__r.Owner.Name, 
										   Question_Bank__c, 
										   Name, Id, Account__c 
									From Wellness_Score_Card__c 
									Where Account__c != Null]; 	
			
			if(!lstWellnessScoreCard.isEmpty())
			{
				//Collect all Freedom Scale Answer Record
			 	lstWellneesOptionDetail = [Select Wellness_card_Detail__r.Wellness_Score_Card__c, 
												  Wellness_card_Detail__r.Score__c, 
												  Wellness_card_Detail__c,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Wellness_Test_Date__c,
												  QuestionMaster__r.Name, 
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__c,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__r.Id,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__r.Name,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__r.OwnerId,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__r.Owner.Name,
												  Name, Id,
												  Answer_Text__c 
											From Wellness_Option_Detail__c 
											Where Wellness_card_Detail__r.Wellness_Score_Card__c IN: lstWellnessScoreCard
											order by CreatedDate Desc ];
											
            	for(Wellness_Option_Detail__c objWellnessOptionDetail : lstWellneesOptionDetail)
			    {
			    	system.debug('objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c--->'+objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c);
			    	if (mapScoreCardToScoreCardOption.containsKey(objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c)) 
			    	{
			    		mapScoreCardToScoreCardOption.get(objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c).put(objWellnessOptionDetail.QuestionMaster__r.Name,objWellnessOptionDetail.Answer_Text__c);
			    	} else 
			    	{
			    		map<string,string> optionMap = new map<String,String>();
			    		optionMap.put(objWellnessOptionDetail.QuestionMaster__r.Name,objWellnessOptionDetail.Answer_Text__c);
			    		mapScoreCardToScoreCardOption.put(objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c,optionMap);
			    	}
			    	
			    }											
			}							
		}	
		else if(entityId != null && entityId.substring(0, 3).compareTo('001') == 0 )
		{
			//Collect all Freedom Scale Record 
			lstWellnessScoreCard = [Select Wellness_Test_Date__c, 
										   Account__r.Name, Account__r.OwnerId, 
										   Account__r.Owner.Name, 
										   Question_Bank__c, 
										   Name, Id, Account__c 
									From Wellness_Score_Card__c 
									Where Account__c =:  entityId ]; 	
			
			if(!lstWellnessScoreCard.isEmpty())
			{
				//Collect all Freedom Scale Answer Record
			 	lstWellneesOptionDetail = [Select Wellness_card_Detail__r.Wellness_Score_Card__c, 
												  Wellness_card_Detail__r.Score__c, 
												  Wellness_card_Detail__c,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Wellness_Test_Date__c,
												  QuestionMaster__r.Name, 
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__c,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__r.Name,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__r.OwnerId,
												  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__r.Owner.Name,
												  Name, Id,
												  Answer_Text__c 
											From Wellness_Option_Detail__c 
											Where  Wellness_card_Detail__r.Wellness_Score_Card__r.Account__c =: entityId 
											order by Wellness_card_Detail__r.Display_Sequence__c];
											
            	for(Wellness_Option_Detail__c objWellnessOptionDetail : lstWellneesOptionDetail)
			    {
			    	system.debug('objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c--->'+objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c);
			    	if (mapScoreCardToScoreCardOption.containsKey(objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c)) 
			    	{
			    		mapScoreCardToScoreCardOption.get(objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c).put(objWellnessOptionDetail.QuestionMaster__r.Name,objWellnessOptionDetail.Answer_Text__c);
			    	} else 
			    	{
			    		map<string,string> optionMap = new map<String,String>();
			    		optionMap.put(objWellnessOptionDetail.QuestionMaster__r.Name,objWellnessOptionDetail.Answer_Text__c);
			    		mapScoreCardToScoreCardOption.put(objWellnessOptionDetail.Wellness_card_Detail__r.Wellness_Score_Card__c,optionMap);
			    	}
			    	
			    }											
			} 							
		}
		List<String> lstAnswerText = new List<String>();
		List<QuestionNoToQuestionName__c> QnoToQNameList = new list<QuestionNoToQuestionName__c>();
		map<Decimal,String> QnoToQNameMap = new Map<Decimal,String>();
		system.debug('-----------QuestionNoToQuestionName--------'+QuestionNoToQuestionName__c.getAll().Values());
		QnoToQNameList.addAll(QuestionNoToQuestionName__c.getAll().Values());
		for(QuestionNoToQuestionName__c QuestionNoToQuestionName : QnoToQNameList){
			QnoToQNameMap.put(QuestionNoToQuestionName.QuestionNo__c,QuestionNoToQuestionName.Name);
		}
		
		for(Wellness_Score_Card__c objWellnessScoreCard: lstWellnessScoreCard)
		{
			system.debug('objWellnessScoreCard.Id--->'+objWellnessScoreCard.Id);
			
			if(mapScoreCardToScoreCardOption.get(objWellnessScoreCard.Id) != null)
			{
				WrapperExportToExcel  objWrapperExcel = new WrapperExportToExcel();
				objWrapperExcel.entityName = objWellnessScoreCard.Account__r.Name;
				objWrapperExcel.entityOwner = objWellnessScoreCard.Account__r.Owner.Name;
				map<string,string> mapOption = mapScoreCardToScoreCardOption.get(objWellnessScoreCard.Id);
				system.debug('mapOption---->'+mapOption);
				for (Integer i=1; i<= QnoToQNameList.size(); i++) {
					Decimal No = i+0.0;
					system.debug('No-->'+No);
					string questionName = QnoToQNameMap.get(No);
					system.debug('questionName--->'+questionName+'mapOption.get(questionName)-->'+mapOption.get(questionName));
					objWrapperExcel.lstAnswerText.add(mapOption.get(questionName));
				}
				objWrapperExcel.wellnessTestDate = objWellnessScoreCard.Wellness_Test_Date__c;
				//Collect all Wrapper Record with Wellness Score Card and Account
				lstWrapperExportToExcel.add(objWrapperExcel);
			}
		}
		
	}
						
	//Wrapper Class
	public class WrapperExportToExcel
	{
		public List<String> lstAnswerText{get;set;}
		public String entityName{get;set;}
		public string entityOwner{get;set;}
		public Date wellnessTestDate{get;set;}
		
		public WrapperExportToExcel()
		{
			lstAnswerText = new List<String>();
		}
	}//end WrapperExportToExcel

}//end