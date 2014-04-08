/*
Revision History:

   Version     Version Author     Date          Comments
   1.0         Dipak Nikam      NA      Initial Draft
   
   2.0        Mahesh Hirugade    30/03/2012  To remove browser compatibility issue with IE9, added a line
   3.0 		  Setty				10/31/2012  Web-FinancialX-Ray page@ Diff Lead source lead insert
*/  
public with sharing class XrayWizardController 
{
	public List<Question_Bank_List__c> lstQuestions {get;set;}
  	public List<Questionnaire__c> lstQuestionnaire {get;set;}
  	public List<Question_Bank__c> lstQuestionBank{get;set;}
  	public Question_Bank__c objActiveQuestionBank {set;get;}
   	public List<SelectQuestionAnswer> lstOfQuestionAnswer {get;set;}
  	public Integer queNo{get;set;} 
  	public Map<ID,List<Question_Option_List__c>> mapQuesIdAnswers{set;get;}  
  	public Lead objLead{set;get;}
  	Map<ID,Question_Option_List__c> mapOfOptionList{set;get;}
  	List<XRay_ScoreCard__c> lstXrayScoreCard = new List<XRay_ScoreCard__c> ();
  	public Boolean displayPopUp {get; set;}  
  	public Double dblFreedomScore{set;get;}  
  	public Integer quesSequence { get;set; }
  
  	/**** Constructor ****/
  	public XrayWizardController()
  	{
	    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');//Added to remove IE9 compatibility issue
	    quesSequence = 0; 
	    mapOfOptionList = new Map<ID,Question_Option_List__c> ();
	    objLead = new Lead();
	    mapQuesIdAnswers = new Map<ID,List<Question_Option_List__c>>();
	    lstQuestions = new List<Question_Bank_List__c>();
	    lstQuestionnaire = new List<Questionnaire__c>();
	    lstQuestionBank = new List<Question_Bank__c>();
	    lstOfQuestionAnswer = new List<SelectQuestionAnswer>();
	    //Custom Setting used for collecting id of X-Ray questions
	    Map<String, QuestionBank__c> QuestionBank = QuestionBank__c.getAll();
	    String finXRayId = QuestionBank.get('FinancialXRay').Question_Bank__c;
	    objActiveQuestionBank  = [select id,Name,IsActive__c from Question_Bank__c  where IsActive__c =true and Id =: finXRayId limit 1]; 
  	}
  
  	/**** Action Method ****/
  	public Pagereference Init()
  	{
    	set<ID>setOfIds = new set<ID>();
    
    	lstQuestionnaire =[SELECT q.Question_Bank__c,
                q.Question_Bank_List__r.Question__c,
                q.Question_Bank_List__r.Name, 
                q.Display_Sequence__c ,
                q.Question_Bank_List__c,
                q.Name, q.Id ,
                q.Question_Bank_List__r.Parent_Question__c,
                q.Question_Bank_List__r.Question_Type__c,
                q.Question_Bank_List__r.Criteria__c, 
                q.Question_Bank_List__r.IsDummy__c 
                FROM Questionnaire__c q where q.Question_Bank__c =:objActiveQuestionBank.Id
                order by q.Display_Sequence__c ASC];
    
    	if(lstQuestionnaire  != null && lstQuestionnaire .size() >0)
    	{
      		for(Questionnaire__c objQuestionnaire :lstQuestionnaire)
      		{
        		setOfIds.add(objQuestionnaire.Question_Bank_List__c);  
      		}
          
      		//populating the question and its answer.
      		for(Question_Option_List__c objAnswer: [Select q.Score__c, q.Question_Bank_List__c, q.Name, q.Id From Question_Option_List__c q where Question_Bank_List__c IN:setOfIds])
      		{
        		mapOfOptionList.put(objAnswer.Id,objAnswer);
        		if(!mapQuesIdAnswers.isEmpty() && mapQuesIdAnswers.containsKey(objAnswer.Question_Bank_List__c))
        		{
          			List<Question_Option_List__c> lstAnswers = mapQuesIdAnswers.get(objAnswer.Question_Bank_List__c);
          			lstAnswers.add(objAnswer);
          			mapQuesIdAnswers.put(objAnswer.Question_Bank_List__c,lstAnswers);
        		}
        		else
        		{
          			List<Question_Option_List__c> lstAnswers = new List<Question_Option_List__c>();
		          	lstAnswers.add(objAnswer);
          			mapQuesIdAnswers.put(objAnswer.Question_Bank_List__c, lstAnswers);
        		}
      		}
      
      		for(Integer iCount =0;iCount < lstQuestionnaire.size() ;iCount++)
      		{
        		SelectQuestionAnswer objSelectQuesAnswer = new SelectQuestionAnswer();
        		objSelectQuesAnswer.objQuestionnaire = lstQuestionnaire[iCount]; 
        
        		if(!mapQuesIdAnswers.isEmpty()&& mapQuesIdAnswers.containsKey(lstQuestionnaire[iCount].Question_Bank_List__c))
        		{
          			List<Question_Option_List__c> lstAnswer = mapQuesIdAnswers.get(lstQuestionnaire[iCount].Question_Bank_List__c);
          			if(lstAnswer != null && lstAnswer.size()>0)
          			{
            			for(Question_Option_List__c objAns :lstAnswer)
            			{
              				objSelectQuesAnswer.strAnswer.add(new Selectoption(objAns.Id, objAns.Name));
            			}
          			}
        		}
	        
        		if(lstQuestionnaire[iCount].Question_Bank_List__r.Question_Type__c == 'Yes/No')
        		{
            		objSelectQuesAnswer.isMultiChoice = false;
        		}
	        
        		else if(lstQuestionnaire[iCount].Question_Bank_List__r.Question_Type__c == 'Multichoice')
        		{
          			objSelectQuesAnswer.isMultiChoice = true;
        		}
        
        		objSelectQuesAnswer.qno = iCount;
        		if(iCount==0)
        		{
          			objSelectQuesAnswer.isCurrentQuestn = true;
          			objSelectQuesAnswer.isVisited = true;
        		}
        		lstOfQuestionAnswer.add(objSelectQuesAnswer);
      		}
    	}
    	return null;
  	}
  
  	/**** Action on Next button *****/ 
  	public Pagereference goToNextQuestn()
  	{ 
    	if(queNo != null)
    	{
      		if(queNo < lstOfQuestionAnswer.size()-1)
      		{
        		if(lstOfQuestionAnswer[queNo].objQuestionnaire.Question_Bank_List__r.Question_Type__c  == 'Yes/No')
        		{
          			if(lstOfQuestionAnswer[queNo].selectedAnswer !=Null)
          			{ 
            			lstOfQuestionAnswer[queNo].isCurrentQuestn = false;
            			String tempParentId = null; 
            			if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(lstOfQuestionAnswer[queNo].selectedAnswer))
            			{
              				Question_Option_List__c objOptionList = mapOfOptionList.get(lstOfQuestionAnswer[queNo].selectedAnswer);
              				if(objOptionList.Name != lstOfQuestionAnswer[queNo].objQuestionnaire.Question_Bank_List__r.Criteria__c)
              				{
                				Integer index = 0;
                				for( index = queNo;index < lstOfQuestionAnswer.size()-1 ;index++)
                				{
                  					tempParentId = lstOfQuestionAnswer[index].objQuestionnaire.Question_Bank_List__c;
                  					if(tempParentId == (lstOfQuestionAnswer[index  + 1].objQuestionnaire.Question_Bank_List__r.Parent_Question__c ))
                  					{
                    					tempParentId = lstOfQuestionAnswer[index + 1].objQuestionnaire.Question_Bank_List__r.Parent_Question__c;
                  					}
                  					else
                  					{
                    					break;
                  					}
                				}
                				queNo = index;
              				}
              				quesSequence = quesSequence + 4;
            			}
            			lstOfQuestionAnswer[queNo].isCurrentQuestn = false;
            			lstOfQuestionAnswer[queNo+1].isCurrentQuestn = true;
            			lstOfQuestionAnswer[queNo+1].isVisited = true;
          			}
          			else
          			{
            			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select your Option');
            			ApexPages.addMessage(myMsg);
          			}
        		}
        		else if(lstOfQuestionAnswer[queNo].selMultipleAnswrs.size() > 0)
        		{
          			quesSequence = quesSequence + 4;
          			if(lstOfQuestionAnswer[queNo].objQuestionnaire.Question_Bank_List__r.Question_Type__c == 'Multichoice')
          			{
			            lstOfQuestionAnswer[queNo].isCurrentQuestn = false;
			            lstOfQuestionAnswer[queNo+1].isCurrentQuestn = true;
			            lstOfQuestionAnswer[queNo+1].isVisited = true;
          			}
        		}
        		else
        		{
          			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select your Option');
          			ApexPages.addMessage(myMsg);
        		}
      		}
    	}
    	return null;
  	}
  
  
  	/**** Action on Previous button *****/
  	public Pagereference goToPrevQuestn()
  	{
    	if(queNo != null)
    	{
      		if(queNo > 0)
      		{
		        lstOfQuestionAnswer[queNo].isCurrentQuestn = false;
		        lstOfQuestionAnswer[queNo].isVisited = false;
		        String tempParentId =null; 
		        Integer index = 0;
		        for( index = queNo -1;index > 0;index--)
		        {
          			if(lstOfQuestionAnswer[index].isVisited)
          			{
            			break;
          			}
          			tempParentId =lstOfQuestionAnswer[index].objQuestionnaire.Question_Bank_List__r.Parent_Question__c;
		          
          			if(tempParentId == (lstOfQuestionAnswer[index -1].objQuestionnaire.Question_Bank_List__c))
          			{
            			tempParentId = lstOfQuestionAnswer[index - 1].objQuestionnaire.Question_Bank_List__c;
          			}
          			else
          			{
            			break;
          			}
        		}
        		quesSequence = quesSequence - 4;
        		queNo = index;
      		}
      		lstOfQuestionAnswer[queNo].isCurrentQuestn = true;
      		lstOfQuestionAnswer[queNo].isVisited = true;
    	}
    	return null;
  	}
  
  
  	/***** Action on Submit *****/
  	public Pagereference saveDetailsOfCandidate()
  	{
    	Set<ID> setInsertedScorecardIds = new Set<ID>();
    	Database.Saveresult saveResult;
    	X_Ray_Score_Card_Detail__c objXrayScoreCardDetail ;
    	Pagereference pgRef;
    
    	if(objLead.FirstName == null)
    	{
      		objLead.FirstName.addError('You must enter a value');
    	}
    	else if(objLead.Email == null)
    	{
      		objLead.Email.addError('You must enter a value');
    	}
    
    	else
    	{
      		//User objMkgTeam = [Select Id, Name from User where Name = 'Ffreedom Team' limit 1];
      		//User objMkgTeam = [Select Id, Name from User where Name = 'Ffreedom Team' limit 1];
      		objLead.Ffreedom_Score__c = dblFreedomScore;
      		//objLead.LeadSource = 'Web';
      		//objLead.OwnerId = objMkgTeam.Id;
      		saveResult = Database.insert(objLead);
      		system.debug('Lead succefully inserted*****objLead.Name*******'+objLead.Name+'%%%%%%%%%%%objLead.Source%%%%%%%%%%%'+objLead.LeadSource);
    		if(saveResult.isSuccess())
    		{
        		try
        		{
            		objXrayScoreCardDetail =  new  X_Ray_Score_Card_Detail__c ();
            		objXrayScoreCardDetail.Lead__c = saveResult.getId();
            		objXrayScoreCardDetail.Question_Bank__c = objActiveQuestionBank.Id;
            		saveResult = Database.insert(objXrayScoreCardDetail);
        		}
        		catch(Exception ex)
        		{
          			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         			String[] toAddresses = new String[] {'tech@ffreedom.in'};
        			mail.setToAddresses(toAddresses);
        			mail.setSenderDisplayName('Salesforce Support');
        			mail.setSubject('Error in Lead Creation by X-Ray from site');
          			mail.setPlainTextBody(' Error : '+ex.getMessage()+' Lead Id ----> : ' + saveResult.getId());
          			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        		}
          		if(saveResult.isSuccess())
          		{
            		if(lstOfQuestionAnswer.size() > 0)
            		{
              			List<Option_Detail__c> lstOfOptionDetailsToInsert = new List<Option_Detail__c>();   
              			Map<ID,XRay_ScoreCard__c> mapQuesIdXrayScoreCard = new map<ID,XRay_ScoreCard__c> ();
              			XRay_ScoreCard__c objXrayScoreCard;
              			for(SelectQuestionAnswer objWrapper : lstOfQuestionAnswer)
              			{
                			objXrayScoreCard = new XRay_ScoreCard__c();
                			if(!objWrapper.objQuestionnaire.Question_Bank_List__r.IsDummy__c)
                			{
                  				ID userAnswer = String.valueOf(objWrapper.selectedAnswer);
                  				objXrayScoreCard.XRayScoreCardMaster__c = saveResult.getId();
                  				objXrayScoreCard.Display_Sequence__c = Double.valueOf(objWrapper.objQuestionnaire.Display_Sequence__c);
                  				objXrayScoreCard.Question_Bank_List__c = objWrapper.objQuestionnaire.Question_Bank_List__c;
		                  
                  				if(objWrapper.isVisited)
                  				{
                    				if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
                    				{
                      					Question_Option_List__c objOptionList = mapOfOptionList.get(userAnswer);
		                      
                      					if(objOptionList.Score__c != null)
                      					{
                        					objXrayScoreCard.Score_Master__c = objOptionList.Score__c;
                      					}
                    				}
                  				}
                			}  
                			else 
                			{                
                  				objXrayScoreCard.XRayScoreCardMaster__c = saveResult.getId();
                  				objXrayScoreCard.Display_Sequence__c = Double.valueOf(objWrapper.objQuestionnaire.Display_Sequence__c);
                  				objXrayScoreCard.Question_Bank_List__c = objWrapper.objQuestionnaire.Question_Bank_List__c;
                			}
                			lstXrayScoreCard.add(objXrayScoreCard);  
              			}
	              
              			if(lstXrayScoreCard.size() > 0 )
              			{
                			List<Database.Saveresult>  lstScoreCardSaveResult = Database.insert(lstXrayScoreCard);
                			if(lstScoreCardSaveResult != null && lstScoreCardSaveResult.size() > 0)
                			{
                  				for(Database.Saveresult objSaveResult : lstScoreCardSaveResult)
                  				{
                    				setInsertedScorecardIds.add(objSaveResult.getId());
                  				}
                			}
              			}
		            
              			for(XRay_ScoreCard__c  objXrayScorecardInserted:[Select x.Score_Master__c, x.Question_Bank_List__c, x.Name, x.Id, x.Display_Sequence__c, x.Answer_Question_Master__c From XRay_ScoreCard__c x where Id IN: setInsertedScorecardIds])
              			{
                			mapQuesIdXrayScoreCard.put(objXrayScorecardInserted.Question_Bank_List__c,objXrayScorecardInserted);
              			}
	              
              			Option_Detail__c objOptionDetails;
              			Question_Option_List__c objOptionList;
              			for(SelectQuestionAnswer objWrapper : lstOfQuestionAnswer)
              			{
                			if(objWrapper.isVisited)
                			{
                  				if(objWrapper.objQuestionnaire.Question_Bank_List__r.Question_Type__c =='Yes/No')
                  				{
                    				ID userAnswer = String.valueOf(objWrapper.selectedAnswer);
		                    
                    				if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
                    				{
                      					objOptionDetails = new Option_Detail__c ();
                      					objOptionList = mapOfOptionList.get(userAnswer);
                      					objOptionDetails.Answer__c = objOptionList.Id;
                        				objOptionDetails.Answer_Text__c = objOptionList.Name;
                        				objOptionDetails.QuestionMaster__c = objOptionList.Question_Bank_List__c;
                        				if(!mapQuesIdXrayScoreCard.isEmpty() && mapQuesIdXrayScoreCard.containsKey(objWrapper.objQuestionnaire.Question_Bank_List__c))
                        				{
                          					objOptionDetails.XRayScoreCard__c = mapQuesIdXrayScoreCard.get(objWrapper.objQuestionnaire.Question_Bank_List__c).Id;
                        				}
                        				lstOfOptionDetailsToInsert.add(objOptionDetails);
                    				}
                  				}
                  				else if(objWrapper.objQuestionnaire.Question_Bank_List__r.Question_Type__c == 'Multichoice')
                  				{
                    				List<String> lstMultichoiceAnswer = objWrapper.selMultipleAnswrs;
                    				for(String idAnswer:lstMultichoiceAnswer)
                    				{ 
                        				ID userAnswer = String.valueOf(idAnswer);
                          				if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
                        				{
                            				objOptionDetails = new Option_Detail__c ();
                          					objOptionList = mapOfOptionList.get(userAnswer);
                          					objOptionDetails.Answer__c = objOptionList.Id;
                            				objOptionDetails.Answer_Text__c = objOptionList.Name;
                            				objOptionDetails.QuestionMaster__c = objOptionList.Question_Bank_List__c;
                            				if(!mapQuesIdXrayScoreCard.isEmpty() && mapQuesIdXrayScoreCard.containsKey(objWrapper.objQuestionnaire.Question_Bank_List__c))
                            				{
                              					objOptionDetails.XRayScoreCard__c = mapQuesIdXrayScoreCard.get(objWrapper.objQuestionnaire.Question_Bank_List__c).Id;
                            				}
                            				lstOfOptionDetailsToInsert.add(objOptionDetails);
                         				}
                    				}
                  				}
                			}
              			}
            			List<Database.Saveresult> lstSaveOptionDetais = Database.insert(lstOfOptionDetailsToInsert);
          			}
        		}
	  	  	}
      		pgRef = new Pagereference('/ThankYou');//Redirect to thank you page.
      		pgRef.setRedirect(true);
    	}
  		return pgRef;
  	}
    
   	public void showPopUp() 
   	{
     	if(lstOfQuestionAnswer.size() > 0)
     	{
       		dblFreedomScore = 0;
       		//Question_Option_List__c objOptionList;
       		for(SelectQuestionAnswer objSelect:lstOfQuestionAnswer)
       		{
         		if(objSelect.isVisited)
         		{
           			if(!objSelect.objQuestionnaire.Question_Bank_List__r.IsDummy__c)
           			{
               			ID userAnswer = String.valueOf(objSelect.selectedAnswer);
              			if(!mapOfOptionList.isEmpty() && mapOfOptionList.containsKey(userAnswer))
              			{
                			Question_Option_List__c objOptionList = mapOfOptionList.get(userAnswer);
                			dblFreedomScore = dblFreedomScore + objOptionList.Score__c;
              			}
           			}
         		}
       		}
	       
       		if(lstOfQuestionAnswer[lstOfQuestionAnswer.size()- 1].objQuestionnaire.Question_Bank_List__r.Question_Type__c  == 'Yes/No')
       		{
         		if(lstOfQuestionAnswer[lstOfQuestionAnswer.size()- 1].selectedAnswer != null)
         		{
           			displayPopUp=true;
             		quesSequence = quesSequence + 4;
         		}
         		else
         		{
           			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select your Option');
          			ApexPages.addMessage(myMsg);
         		}
       		}
       		else if(lstOfQuestionAnswer[lstOfQuestionAnswer.size()- 1].selMultipleAnswrs.size()>0)
       		{
	            displayPopUp=true;
            	quesSequence = quesSequence + 4;
       		}
       		else
       		{
         		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select your Option');
        		ApexPages.addMessage(myMsg);
       		}
     	}
   	}
   
   	public void closePopup()
   	{
     	displayPopUp = false;
   	}  
 	/*    Eternus Solutions  
	      Author  : Setty 
	      Issue Id: 00001700       
	      Date    : 18/7/2012    
	      Purpose : Online promotion page Without Score Card Lead Insert
 		  *************************************************** */
   	public Pagereference saveDetailsOfCandidatewithoutScore()
  	{
      
      	//User objMkgTeam = [Select Id, Name from User where Name = 'Ffreedom Team' limit 1];
      	//objLead.LeadSource = 'Web';
      	//objLead.OwnerId = objMkgTeam.Id;
      	if(objLead.FirstName == null|| objLead.Email == null||objLead.LastName==null||objLead.MobilePhone==null)
      	{
	      	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You must enter a values which have *');
      		ApexPages.addMessage(myMsg);
      	}
      	else
      	{
      		Database.insert(objLead);
      		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Thank you for your interest in Ffreedom Financial Planners.');
      		ApexPages.addMessage(myMsg);
      	}
     	// displayPopUp=true;*/
      	Pagereference pgRef = new Pagereference('/ThankYou');//Redirect to Same page.
      	pgRef.setRedirect(true);
      	return pgRef;
   	}
   
   /*-------End---*/
  //Wrapper Class     
  	public class SelectQuestionAnswer
  	{
    	public List<Selectoption> strAnswer { get;set; }
    	public Boolean isMultiChoice{ get;set; }
    	public Boolean isCurrentQuestn { get;set; }
    	public Boolean isVisited { get;set; }
    	public Integer qno{  get;set; }
    	public ID selectedAnswer {get;set;}
    	public List<String> selMultipleAnswrs { get;set; }
    	public Questionnaire__c objQuestionnaire{ get;set;}
	    
    
    	/**** Constructor ****/
    	public SelectQuestionAnswer()
    	{
      		strAnswer = new List<SelectOption>();
      		selMultipleAnswrs  = new List<String>();
      		objQuestionnaire = new Questionnaire__c();
      		isVisited = false;
    	}  
  	}
}