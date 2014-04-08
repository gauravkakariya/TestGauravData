public with sharing class IUDonWellness {
	
	public Questionnaire__c questionnaire{get;set;}
	public Id questionnaireId{get;set;}
	
	public Question_Bank_List__c questionBankList{get;set;}
	public Id questionBankListId{get;set;}
	
	public Question_Option_List__c questionOptionList{get;set;}
	public Id questionOptionListId{get;set;}
	
	public IUDonWellness(){
		
		questionnaire = [Select Question_Bank__c, Question_Bank_List__c, Name, Id, Explanation__c, Display_Sequence__c From Questionnaire__c Where Id=:'a2XW000000003tT'];
		questionBankList = [Select Question__c, Question_Type__c, Question_Number__c, Parent_Question__c, Notes__c, Name, Id From Question_Bank_List__c Where Id=:'a2UW00000004TFT'];	
	}

	public Pagereference save(){
		
	try {
			upsert questionnaire;
			upsert questionBankList;
	}
	catch ( DmlException exc) {
	      ApexPages.addMessages(exc);
	      return null;
	}
		return null;
	}


	public Pagereference cancel(){
		
		return null;
	}
	
}