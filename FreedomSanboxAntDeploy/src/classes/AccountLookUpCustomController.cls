public with sharing class AccountLookUpCustomController 
{
  public Account account {get;set;} // new account to create
  public List<Account> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string businessUnitName {get; set;}

  public AccountLookUpCustomController() {
    account = new Account();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    if(System.currentPageReference().getParameters().get('BU_Name') != null && System.currentPageReference().getParameters().get('BU_Name') != ''){
        businessUnitName  = System.currentPageReference().getParameters().get('BU_Name');
    }
    else{
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'<font color="red"><b>Please Select Business Unit first</b></font> ');
        ApexPages.addMessage(myMsg);
        return;
    }
   
    //businessUnitName  = System.currentPageReference().getParameters().get('BU_Name');
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
  private List<Account> performSearch(string searchString) {
     System.debug('BUnAme-->' + businessUnitName);
     RecordType genRecType = [SELECT Id FROM RecordType where sobjectType = 'Account' AND Name = 'General'];
    String soql = 'select id, name from account';
    //if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\' AND Business_Unit__r.Name=\'' + businessUnitName + '\' AND RecordTypeId = \'' + genRecType.Id + '\' AND (Related_To__c =\'Virtual Partner\' OR Related_To__c = \'Ffreedom\')';
    soql = soql + ' limit 25';
    System.debug('soql-->' + soql);
    return database.query(soql); 
 
  }
 
 /*
  // save the new account record
  public PageReference saveAccount() {
    insert account;
    // reset the account
    
    account = new Account();
    return null;
  }
 */
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}