public with sharing class WellnessReportController {
	
	public Date fromDate{get;set;}
	public Date toDate{get;set;}
	public Lead wellnessLead{get;set;}
	public Wellness_Score_Card__c wellnessScoreCard{get;set;}
	
	
	WellnessReportController(){
		
		wellnessLead = new Lead();
		wellnessScoreCard = new Wellness_Score_Card__c();
		
		
	}
	
	public PageReference showWellnessRecord(){
		
		return Null;
		
	}
	
}