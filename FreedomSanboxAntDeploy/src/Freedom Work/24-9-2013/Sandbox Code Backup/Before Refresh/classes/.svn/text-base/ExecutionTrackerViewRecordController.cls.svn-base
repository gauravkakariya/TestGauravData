/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Anupam	          2/01/13		 Display field on new window launched from ET readonly page.
*/

public with sharing class ExecutionTrackerViewRecordController 
{
	//Public variables.
	public String strType{get;set;}
	public Boolean isSipOrLumpsum {get;set;}
	public Boolean isGeneralOrLife {get;set;}
	public Boolean isError{get;set;}
	public Execution_Tracker__c objExecutionTracker {get;set;}
	public String MFlumpsumHolder {get;set;}
	public String lumpsumHolder {get;set;}
	public String MFSIPHolder {get;set;}
	public String SIPHolder {get;set;}
	public String lifeInsuranceHolder {get;set;}
	public String generalInsuranceHolder {get;set;}
	public Boolean isReadOnly {get;set;}
	public Boolean isClosed {get;set;}
	//Local variables
	private DatabaseSOQL objDatabaseSOQL;
	private Set<Id> setEntityFamilyMemberId ;
	private String etId;
	private String strApproveActionPlanId;
	
	//Constructor
	public ExecutionTrackerViewRecordController()
	{
		//Variable initialization
		objDatabaseSOQL = new DatabaseSOQL();
		setEntityFamilyMemberId = new Set<Id>();
		objExecutionTracker = new Execution_Tracker__c();
		isSipOrLumpsum = false;
		isGeneralOrLife = false;
		isError = false;
		
		etId = Apexpages.currentPage().getParameters().get('eid');
		strType = Apexpages.currentPage().getParameters().get('type');
	
		showMutualFundPopUp();
	}
	public void showMutualFundPopUp()
	{
		Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
		Schema.SObjectType stdETObject = mapGlobalDescribe.get('Execution_Tracker__c');
		Schema.DescribeSObjectResult descStdET = stdETObject.getDescribe();
		Map<String, Schema.SObjectField> stdETfields = descStdET.fields.getMap();
		String strQuery = 'Select Goal__r.Description__c, ';
		for(String strField : stdETfields.keySet())
		{
			strQuery += strField + ',';
		}
		strQuery = strQuery.substring(0, strQuery.length() - 1);
		
		strQuery += ' from Execution_Tracker__c where Id =: etId ';
		for(Execution_Tracker__c objET : Database.query(strQuery))
		{
			objExecutionTracker = objET;
		}
		
		isReadOnly = objExecutionTracker.Application_Status__c == 'Processed';
		if(objExecutionTracker.Type__c.equalsIgnoreCase('Lumpsum') || objExecutionTracker.Type__c.equalsIgnoreCase('sip') )
		{
			
			isSipOrLumpsum = true;
		}
		if(objExecutionTracker.Type__c.equalsIgnoreCase('General Insurance') || objExecutionTracker.Type__c.equalsIgnoreCase('Life Insurance'))
		{
			isGeneralOrLife = true;
		}
	}
	
	public void updateExecutionTracker()
	{
		update objExecutionTracker;
	}
}