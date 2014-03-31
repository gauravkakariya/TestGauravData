public with sharing class TeamMemberLookupController 
{
	  public Team_Member__c teamMember {get;set;} // new account to create
	  public List<Team_Member__c> results{get;set;} // search results
	  public string searchString{get;set;} // search keyword
	  public string businessUnitName {get; set;}
	  public string teamMemberType {get; set;}
	  
	  public TeamMemberLookupController() 
	  {
	    teamMember = new Team_Member__c();
	    // get the current search string
	    searchString = System.currentPageReference().getParameters().get('lksrch');
	    if(System.currentPageReference().getParameters().get('BU_Name') != null || System.currentPageReference().getParameters().get('BU_Name') == ''){
	    	businessUnitName  = System.currentPageReference().getParameters().get('BU_Name');
	    }else{
	    	 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'<font color="red"><b>Please Select Business Unit first</b></font> ');
	        ApexPages.addMessage(myMsg);
	        return;
	    }
	    if(System.currentPageReference().getParameters().get('TM_Type') != null){
	    	teamMemberType = System.currentPageReference().getParameters().get('TM_Type') ;
	    }
	    runSearch();  
	  }
	 
	  // performs the keyword search
	  public PageReference search() {
	    runSearch();
	    return null;
	  }
	 
	  // prepare the query and issue the search command
	  private void runSearch() {
	    // TODO prepare query string for complex serarches & prevent injections
	    results = performSearch(searchString);               
	  } 
	 
	  // run the search and return the records found. 
	  private List<Team_Member__c> performSearch(string searchString) {
	     System.debug('BUnAme-->' + businessUnitName);
	    String soql = 'select id, name from Team_Member__c';
	    //if(searchString != '' && searchString != null)
	      soql = soql +  ' where name LIKE \'%' + searchString +'%\' AND Department__r.Business_Unit__r.Name=\'' + businessUnitName + '\' and Team_Member__c != null and Status__c =\'Active\'  AND Department__r.Type_of_Department__c = \'' + teamMemberType +  '\'';
	    soql = soql + ' limit 25';
	    System.debug('soql-->' + soql);
	    return database.query(soql); 
	
	  }
	 
	  // save the new account record
	  public PageReference saveAccount() {
	    //insert teamMember;
	    // reset the account
	    
	    teamMember = new Team_Member__c();
	    return null;
	  }
	 
	  // used by the visualforce page to send the link to the right dom element
	  public string getFormTag() {
	    return System.currentPageReference().getParameters().get('frm');
	  }
	 
	  // used by the visualforce page to send the link to the right dom element for the text box
	  public string getTextBox() {
	    return System.currentPageReference().getParameters().get('txt');
	  }

}