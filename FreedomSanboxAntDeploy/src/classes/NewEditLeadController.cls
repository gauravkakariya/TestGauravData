public without sharing class NewEditLeadController
{
	public User currentUser {get; set;}
    public RecordType recordTypeforAcc {get; set;}
    public Lead lead{get; set;}
	public String leadId{get; set;}	
	public String objPrefix{get; set;}	
	public String objPrefixTeamMember{get; set;}	
	
	ApexPages.standardController controller = null;
	public NewEditLeadController(ApexPages.StandardController controller) 
    {
      Schema.DescribeSObjectResult dsr = Account.SObjectType.getDescribe();
	  objPrefix = dsr.getKeyPrefix();
	
	  Schema.DescribeSObjectResult dsrTeamMember = Team_Member__c.SObjectType.getDescribe();
	  objPrefixTeamMember = dsrTeamMember.getKeyPrefix();
	  	
      leadId = '';
      controller = controller;	
      lead = new Lead();
      currentUser = [SELECT Id,Name FROM User WHERE Id=:UserInfo.getUserId()];
      
       if(ApexPages.currentPage().getParameters().get('id') != null)
       {
       	leadId = ApexPages.currentPage().getParameters().get('id');
       	String strQuery = ' Select  ';
	   	Map<String, Schema.SObjectField> mapAAPFieldNameToFieldDescribe = schema.SObjectType.Lead.fields.getMap();
		
		// Fetch Account Record as per Record Type
		
		//Create Dynamic query
		for(String strField : mapAAPFieldNameToFieldDescribe.keySet())
		{
			system.debug('strField--->' + strField);	
			 if(mapAAPFieldNameToFieldDescribe.get(strField).getDescribe().isUpdateable() ) 
				strQuery += strField + ',';
		}
		
		system.debug('strQuery--->' + strQuery);	
		strQuery = strQuery.substring(0, strQuery.length() - 1);
		strQuery += ' , Owner.Name from Lead Where Id = \'' + leadId + '\''; 
       
       
       lead = Database.query(strQuery);
       }
    }

  public NewEditLeadController() {
    lead = new Lead();
  }
  
   public PageReference cancel() 
  {
    if(leadId == null || leadId == '')
  		return new PageReference('/00Q/o');	
  	
  	if(leadId != null || leadId != '')
  		return new PageReference('/' + lead.Id);
  		
  	return Null;
  }
 
  // save the new lead record
  public PageReference saveLead() 
  {
  	 Database.Saveresult saveResult;
  	try{
  		 if(leadId == null ||  leadId == '') 
  		 {
		     lead.OwnerId = currentUser.Id;	
		     saveResult= Database.insert(lead);
  		 }   
  		 else if(leadId != null ||  leadId != '') 
  		 {
		     saveResult= Database.update(lead);
  		 }
  		 
	     if(saveResult.isSuccess())
	   	 	 return new PageReference('/' + lead.Id);
	 }
  	 catch(Exception e)
  	 {
  		system.debug('*************'+e.getMessage());
  	 }
  	 return null;
   }   


}