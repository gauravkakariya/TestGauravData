/*

 @Author: Nikam Dipak
 * @since : 18th Dec 2011
 * @Description: CreateQuestionBank is a controller class of CreateQuestion Bank Page.
*/

public with sharing class CreateQuestionBank
{
	public Boolean btnVisible{get;set;}
	public Boolean isNew{get;set;}
	public Boolean isEdit{get;set;}
	List<Question_Bank_List__c> lstQuestions {get;set;}
	List<Questionnaire__c> lstQuestionnaire {get;set;}
	public List<Question_Bank__c> lstQuestionBank{get;set;}
	public List<SelectQuestionLists> lstSelectedQuestions {get;set;}
	public Question_Bank__c objActiveQuestionBank{set;get;}
	Set<Id> setActiveQuestionBank = new Set<Id>();
	public String strUrlFlag {set;get;}
	
	
	public CreateQuestionBank()
	{
		btnVisible = true;
		objActiveQuestionBank = new Question_Bank__c();
		lstQuestions = new List<Question_Bank_List__c>();
		lstQuestionnaire = new List<Questionnaire__c>();
		lstQuestionBank = new List<Question_Bank__c>();
		lstSelectedQuestions = new List<SelectQuestionLists>();
		Map<String, QuestionBank__c> QuestionBank = QuestionBank__c.getAll();
	    String finXRayId = QuestionBank.get('FinancialXRay').Question_Bank__c;
		objActiveQuestionBank = [Select Id,IsActive__c , Name from Question_Bank__c where IsActive__c = true and Id =: finXRayId limit 1];
		strUrlFlag = ApexPages.currentPage().getParameters().get('flag');
	}

	public void Init()
	{
		
		Map<ID,List<Question_Bank_List__c >> mapOfParentAndChildQuestions = new Map<ID,List<Question_Bank_List__c >>();
		Map<ID,Question_Bank_List__c > mapOfParentIdAndParentQuestion = new Map<ID,Question_Bank_List__c>();
		
		if(strUrlFlag != null &&  strUrlFlag.equals('new'))
		{
			isNew = true;
			isEdit = false;
			btnVisible = false;
			
			List<Question_Bank_List__c> lstFinalQuestionBankList = new List<Question_Bank_List__c>();
			for(Question_Bank_List__c questionBankList : [SELECT q.Id, q.Question__c, q.Question_Type__c,
												q.Parent_Question__c, q.Name,
												q.IsDummy__c, q.Criteria__c,
												q.Question_Number__c 
										 		FROM Question_Bank_List__c q order by Question_Number__c Asc])
			{
				SelectQuestionLists objSelQue = new SelectQuestionLists(questionBankList,new Questionnaire__c(),false);
				lstSelectedQuestions.add(objSelQue);
			}
		}
		else if(strUrlFlag != null && strUrlFlag.equals('edit'))
		{ 
			isNew = false;
			isEdit = true;
			btnVisible = false;
			Map<ID,Questionnaire__c> mapOfQuesIdandQuestionnaire = new Map<ID,Questionnaire__c>();
			Map<ID,Question_Bank_List__c> mapOfQuesIdandQuesList = new Map<ID,Question_Bank_List__c>();
			Map<Double,SelectQuestionLists> mapOfIndexandInnerClass = new Map<Double,SelectQuestionLists>();
			
			for(Questionnaire__c questionnaire : [SELECT q.Question_Bank__c,
												  q.Question_Bank_List__r.Question__c,
												  q.Question_Bank_List__r.Name, 
												  q.Display_Sequence__c ,
												  q.Question_Bank_List__c,
												  q.Name, q.Id ,
												  q.Question_Bank_List__r.Parent_Question__c,
												  q.Question_Bank_List__r.Question_Number__c
												  FROM	Questionnaire__c q where q.Question_Bank__c =: objActiveQuestionBank.Id
												  order by q.Display_Sequence__c ASC])//IN : setActiveQuestionBank 
			{
				mapOfQuesIdandQuestionnaire.put(questionnaire.Question_Bank_List__c,questionnaire);
			}
			
			for(Question_Bank_List__c objQuestionList :[Select q.Question__c, 
														q.Question_Type__c,
														q.Parent_Question__c, 
														q.Name, 
				 										q.IsDummy__c,
				 										q.Id,
				 										q.Criteria__c ,Question_Number__c
				 										From Question_Bank_List__c q ] )//order By Question_Number__c ASC
		  {
		  	mapOfQuesIdandQuesList.put(objQuestionList.Id,objQuestionList); 
		  }
		  
		  if(!mapOfQuesIdandQuesList.isEmpty())
		  {
		  	 Questionnaire__c objQuestionnaire;
		  	 Question_Bank_List__c questionBankList;
		  	 SelectQuestionLists objSelQue; // Inner Class
			 
			  for(ID quesId:mapOfQuesIdandQuesList.keySet())
			  {
				  	if(!mapOfQuesIdandQuestionnaire.isEmpty() && mapOfQuesIdandQuestionnaire.containsKey(quesId))
				  	{	
				  		objQuestionnaire = mapOfQuesIdandQuestionnaire.get(quesId);
				  		questionBankList = mapOfQuesIdandQuesList.get(quesId);
				  		if(questionBankList.Parent_Question__c != null)
				  			objSelQue = new SelectQuestionLists(questionBankList,objQuestionnaire,false);
				  		else
				  			objSelQue = new SelectQuestionLists(questionBankList,objQuestionnaire,true);
						lstSelectedQuestions.add(objSelQue);
					}
				  	else
				  	{
				  		objQuestionnaire = new Questionnaire__c();
				  		questionBankList = mapOfQuesIdandQuesList.get(quesId);
				  		if(questionBankList.Parent_Question__c != null)
				  			objSelQue = new SelectQuestionLists(questionBankList,objQuestionnaire,false);
				  		else
				  			objSelQue = new SelectQuestionLists(questionBankList,objQuestionnaire,false);
						lstSelectedQuestions.add(objSelQue); 
				  	}
			  }
			  if(lstSelectedQuestions != null && lstSelectedQuestions.size() > 0)
			  {
				  	for(SelectQuestionLists objSelQues :lstSelectedQuestions)
				  	{
				  		Double quesIndex = Double.valueOf(objSelQues.ques.Question_Number__c);
				  		mapOfIndexandInnerClass.put(quesIndex,objSelQues);
				  	}
				  	if(mapOfIndexandInnerClass.size() > 0)
				  	{
				  		lstSelectedQuestions.clear();
				  		for(Double index=1;index < = mapOfIndexandInnerClass.size();index++)
				  		{
				  			lstSelectedQuestions.add(mapOfIndexandInnerClass.get(index));	
				  		}
				  	}
			  }
		  }
		}
		else
		{
			isNew = false;
			isEdit = false;
			btnVisible = true;
			Set<ID>setOfQuestinnaire = new Set<ID>();
			for(Questionnaire__c questionnaire : [SELECT q.Question_Bank__c,
												  q.Display_Sequence__c , 
												  q.Question_Bank_List__c,
												  q.Name, 
												  q.Id,
												  q.Question_Bank_List__r.Question__c,
												  q.Question_Bank_List__r.Name,
												  q.Question_Bank_List__r.Parent_Question__c
												  FROM	 Questionnaire__c q 
												  where q.Question_Bank__c =:objActiveQuestionBank.Id
												  order by q.Display_Sequence__c ASC])//,q.Question_Bank_List__r.Question__c ASC // IN : setActiveQuestionBank
			{
				setOfQuestinnaire.add(questionnaire.Question_Bank_List__c);
				SelectQuestionLists objSelQue = new SelectQuestionLists(new Question_Bank_List__c(),questionnaire,true);
				lstSelectedQuestions.add(objSelQue);
			}
		}
	}
	
	public  Pagereference  modifyQuestionBank()
	{
		Pagereference pgRef = new Pagereference('/apex/createquestionBank?flag=edit');
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	public  Pagereference  createNewQuestionBank()
	{
		Pagereference pgRef = new Pagereference('/apex/createquestionBank?flag=new');
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	public  Pagereference  cancel()
	{
		Pagereference pgRef = new Pagereference('/apex/createquestionBank');
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	
	
	/*public Boolean deActivateExistingQuestionBank()
	{
		/ This is for deactivating the exisiting Question Bank.
			List<Database.Saveresult> lstSaveResult;
			if(lstQuestionBank != null && lstQuestionBank.size() > 0)
			{
				List<Question_Bank__c>lstQuestionBankTobeUpdate = new List<Question_Bank__c>();
				for(Question_Bank__c objQuestionBank:lstQuestionBank)
				{
					
					lstQuestionBankTobeUpdate.add(objQuestionBank);
				}
				if(lstQuestionBankTobeUpdate != null && lstQuestionBankTobeUpdate.size() > 0)
					lstSaveResult = Database.update(lstQuestionBankTobeUpdate);
			}
			return lstSaveResult[0].isSuccess();
	}*/
	
	//Creating the Question Bank and created question bank becomes active.  
	public Pagereference createQuestionBankAndQuestionnaire()
	{
		Pagereference pgRef = null;
		Set<Id> setQuestions = new Set<Id>();
		
		List<SelectQuestionLists>lstSelectedQuestionToCheck = new List<SelectQuestionLists>(); //This List hold only selected question from page.
		List<SelectQuestionLists>lstUncheckSelectedQuestion = new List<SelectQuestionLists>(); //This List will hold the unselected question.
		try
		{
			//Populating List with question which are checked and unchecked.
			if(lstSelectedQuestions != null && lstSelectedQuestions.size() > 0)
			{
				for(SelectQuestionLists objSelectedQuestion : lstSelectedQuestions)
				{
					if(objSelectedQuestion != null && objSelectedQuestion.isChecked != null && objSelectedQuestion.isChecked)
					{
						lstSelectedQuestionToCheck.add(objSelectedQuestion);
					}
					else if(objSelectedQuestion.isChecked != null)
					{
						lstUncheckSelectedQuestion.add(objSelectedQuestion);
					}
				}
			}
			
			if(lstSelectedQuestionToCheck != null && lstSelectedQuestionToCheck.size()> 0)
			{
				Database.Saveresult saveResult;
				Question_Bank__c objQB = new Question_Bank__c();
				if(objActiveQuestionBank != null)
				{
					objActiveQuestionBank.IsActive__c =false;
					saveResult = Database.update(objActiveQuestionBank);
				}
				
				
				objQB.IsActive__c = true;
				saveResult = Database.insert(objQB);
				if(saveResult.isSuccess())
				{
				
					for(SelectQuestionLists objselect :lstSelectedQuestionToCheck)
					{
						Questionnaire__c objQre = new Questionnaire__c();
						objQre.Display_Sequence__c = objselect.objQuestionnaire.Display_Sequence__c;	
						objQre.Question_Bank__c = objQB.Id;
						objQre.Question_Bank_List__c = objselect.ques.Id;
						setQuestions.add(objselect.ques.Id);
						lstQuestionnaire.add(objQre);
					} 
					
					// Unselected List
					if(!lstUncheckSelectedQuestion.isEmpty())
					{
						for(SelectQuestionLists objselect : lstUncheckSelectedQuestion)
						{
							if(objselect.ques.Parent_question__c != null && setQuestions.contains(objselect.ques.Parent_question__c))
							{
								Questionnaire__c objQuenn = new Questionnaire__c();
								objQuenn.Question_Bank__c = objQB.Id;
								objQuenn.Display_Sequence__c = objselect.objQuestionnaire.Display_Sequence__c;
								objQuenn.Question_Bank_List__c = objselect.ques.Id;
								setQuestions.add(objselect.ques.Id);
								lstQuestionnaire.add(objQuenn);
							}
						}
					}
					
					if(!lstQuestionnaire.isEmpty())
					{
						List<Database.Saveresult> lstsaveResult = Database.insert(lstQuestionnaire);
						
						//Error.DebugLog('Finaly done saveResult ===========>'+lstsaveResult);
						if(lstsaveResult != null && lstsaveResult.size() > 0)
						{
							pgRef = new Pagereference('/apex/CreateQuestionBank');
							pgRef.setRedirect(true);
						}
					}
				}
			}
			else
			{
				pgRef = null;
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, 'Please select the checkbox');
				ApexPages.addMessage(myMsg);
			}
		}
		catch(Exception ex)
		{
			pgRef = null;
		}
		return pgRef;
	}
	
	
	
	//Inner Class for Binding on page
	public class SelectQuestionLists
	{
		public Boolean isChecked {get;set;}
		public Question_Bank_List__c ques {get;set;}
		public Questionnaire__c objQuestionnaire{set;get;}
		
		public SelectQuestionLists(Question_Bank_List__c objQuestionBankList, Questionnaire__c objQre,Boolean isCheck)
		{
			this.ques = objQuestionBankList;
			this.isChecked = isCheck;
			objQuestionnaire = objQre; 
		}
		
		public SelectQuestionLists(){}
	}
	
	
	
	
	
	
}