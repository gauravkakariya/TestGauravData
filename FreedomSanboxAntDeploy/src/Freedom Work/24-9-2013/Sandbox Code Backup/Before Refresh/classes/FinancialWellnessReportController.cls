/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0         Gaurav             25/12/2012     This Class is used to generate pdf dynamically accoring to wellness score and 
    											  respective recordid of Lead and Entity
    
*/

public with sharing class FinancialWellnessReportController{
	
	public Double wellnessScore{get;set;}
	public Boolean check{get;set;}
	public String scoreData{get;set;}
	public String wellnessTestDate{set;get;}  
	public String scoreValue{get;set;}
	public String name{get;set;}
	public String optionData{get;set;}
	public String incomeSource{get;set;}
	public String recordId{get;set;}
	public String Email{get;set;}
	public List<Wellness_Card_Detail__c> lstwellnessScoreDetails{get;set;}
	public String recordName{get;set;}
	public String imageURL{get;set;}
	public List<Document> documentList{get;set;}
	public List<String> documentImageUrlList{get;set;}
	public Map<Wellness_Card_Detail__c, String> wellnessScoreCardImageMap {get;set;}
	private Lead objWellnessLead{get;set;}
	private Account objWellnessAccount{get;set;}
	private List <Wellness_Card_Detail__c> lstWellnessCardDetails;
	
	//Constructor
	public FinancialWellnessReportController()
	{
		objWellnessLead = new Lead();
		objWellnessAccount = new Account();
		scoreValue = ApexPages.currentPage().getParameters().get('value'); 
		recordId = ApexPages.currentPage().getParameters().get('id');
		
		if(recordId!= NULL && recordId.substring(0,3).compareTo('00Q') == 0 && recordId != '')
		objWellnessLead = [Select Name From Lead Where Id =:recordId];
		
		if(objWellnessLead != Null)
	    	recordName = objWellnessLead.Name;
	}
 
  	public void generatePdf()
  	{
  		wellnessScoreCardImageMap = new Map<Wellness_Card_Detail__c, String>();
  		//If Record Id  is Lead
   		if(recordId!= NULL && recordId.substring(0,3).compareTo('00Q') == 0 && recordId != '')
   		{
   			system.debug('****recordId********'+recordId);
	        //Calculate Percentage of Welleness Score
	        Decimal score = Double.valueOf(scoreValue);
			score = score * 100/35;
			score = score.setScale(2, RoundingMode.HALF_UP);
			scoreValue = string.valueOf(score);
	        
	        //Fetches wellness Card Details according to lead or Entity id  
			lstWellnessCardDetails = new List <Wellness_Card_Detail__c> ();
			lstWellnessCardDetails = [Select Wellness_Score_Card__r.Lead__c, 
											 Wellness_Score_Card__c, 
											 CreatedDate,
											 Explanation__c,Display_Sequence__c  
									   From Wellness_Card_Detail__c  
									   Where Wellness_Score_Card__r.Lead__c = :recordId 
									   order by CreatedDate desc Limit 7];
			
			if(lstWellnessCardDetails.size() > 0){
				
				lstwellnessScoreDetails = new List<Wellness_Card_Detail__c>();
				for(Wellness_Card_Detail__c wellnessCardDetails : lstWellnessCardDetails){
					
					Date newWellnessTestDate = wellnessCardDetails.CreatedDate.Date();
                    DateTime dtValue = DateTime.newInstance(newWellnessTestDate.year(),newWellnessTestDate.month(), newWellnessTestDate.day());
                    wellnessTestDate = dtValue.format('dd-MM-yyyy');
                    lstwellnessScoreDetails.add(wellnessCardDetails);
					//lstwellnessScoreDetails.add(wellnessCardDetails.Explanation__c);
					lstwellnessScoreDetails.sort();
				}
			}            
        } 
        
  	}
 	
 }//Financial_Wellness_Report