public with sharing class KPIReportForFP
{
	public List<KPI_Reports__c> lstKPI
	{	get;set;	}
	
	public List<String> lstKPIParameters
	{	get;set; }
	// constructor
	public KPIReportForFP()
	{
		lstKPI = new List<KPI_Reports__c>();
		
		/*lstKPIParameters = new List<String>{'New Entities(Required)','Execution(Required)', 'Plan Approval(Required)',
											'Client Referral(Required)', 'Lead Conversion(Required)', 'Lead Meeting Fixed(Required)', 
											'Testimonial'
										   };*/							
		// query all the KPI Report records
		for(KPI_Reports__c kpi : [SELECT k.Total_Testimonial__c, k.Total_Plan_approvals__c, k.Total_Leads_Score__c,
										 k.Total_Lead_Meetings__c, k.Total_Lead_Conversion__c, k.Total_Entities__c,
										 k.Total_Entities_Till_Date__c, k.Total_Entities_FY__c, k.Total_Client_Refferal__c,
										 k.Testimonial__c, k.Testimonial_Required__c, k.Team_Mgmt__c, k.Role__c, k.Planner_Name__c,
										 k.Plan_Approval__c, k.Plan_Approval_Required__c, k.New_Entities__c,k.Planner_Name__r.Name, 
										 k.New_Entities_Required__c, k.Name, k.Month__c, k.Lead_Meeting_Fixed__c, 
										 k.Lead_Meeting_Fixed_Required__c, k.Lead_Conversion__c, k.Lead_Conversion_Required__c, k.Id,
										 k.Financial_Month__c, k.Executions__c, k.Executions_Required__c, k.Execution_per__c,
										 k.EntitiesPercent__c, k.Client_Referral__c, k.Client_Referral_Required__c
								  FROM 	 KPI_Reports__c k
								  WHERE  CreatedDate = THIS_MONTH AND k.Planner_Name__c =: Userinfo.getUserId()])
								  	{
								  		lstKPI.add(kpi); // add them to list
								  	}
								  	
	}
}