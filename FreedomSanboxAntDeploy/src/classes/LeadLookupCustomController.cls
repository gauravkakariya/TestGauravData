public with sharing class LeadLookupCustomController {
	
  public Lead lead {get;set;} // new account to create
  public List<Account> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string businessUnitName {get; set;}

  public LeadLookupCustomController() {
    lead = new Lead();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    system.debug('*********searchString'+searchString);
    
    businessUnitName  = System.currentPageReference().getParameters().get('BU_Name');
    system.debug('*********searchString'+businessUnitName);
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
    system.debug('*********results'+results);              
  } 
 
  // run the search and return the records found. 
  private List<Account> performSearch(string searchString) {
     System.debug('BUnAme-->' + businessUnitName);
    String soql = 'select id, name from Account';
    //if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\' AND Business_Unit__r.Name=' + businessUnitName+ '';
    soql = soql + ' limit 25';
    System.debug('soql-->' + soql);
    return database.query(soql); 
 
  }
 
  // save the new account record
  public PageReference saveAccount() {
    insert lead;
    // reset the account
    
    lead = new Lead();
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