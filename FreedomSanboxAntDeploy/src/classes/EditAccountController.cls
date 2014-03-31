public with sharing class EditAccountController 
{
    public Contact contTemp {get; set;}
    public User currentUser {get; set;}
    public RecordType recordTypeforAcc {get; set;}
    public Account account{get; set;}
    
    //record type variables
    public boolean isGeneral {get; set;}
    public boolean isClient{get; set;}
    public boolean isFamily{get; set;}
    public boolean isInfluencer{get; set;}
    public boolean isMaster{get; set;}
   
    public String accountId{get; set;}
   	String strRecordType = '';
   	String strFamilyRecordType = '';
   	String strInfluencersRecordType ='';
   	
    public EditAccountController(ApexPages.StandardController controller) 
    {
      contTemp  = new Contact();
      account = new Account();
      currentUser = [SELECT Id,Name FROM User WHERE Id=:UserInfo.getUserId()];
    
      if(ApexPages.currentPage().getParameters().get('RecordType') != null)
      {
      	account = [Select Id,Name,RecordType.Name from Account Where Id =:ApexPages.currentPage().getParameters().get('RecordType')];
      	
      	 if(account.RecordType.Name== 'General'){
              isGeneral = true;
              
          }else if(account.RecordType.Name == 'Client'){
          	strRecordType = account.RecordType.Name;
              isClient = true;
          }
          else if(account.RecordType.Name == 'Family Member'){
              isFamily = true;
          }
          else if(account.RecordType.Name == 'Influencers'){
              isInfluencer = true;
          }
          else if(account.RecordType.Name == 'Master'){
              isMaster = true;
          }
      	
      }
      
      
    }

  
  public Pagereference pageredir()
    {

        accountId= ApexPages.currentPage().getParameters().get('Id'); 
        if(accountId!=null)
        {
	          account = [Select Id,Name,RecordType.Name,Email_ID__c from Account Where Id =:ApexPages.currentPage().getParameters().get('id')];
	      	
	      	 if(account.RecordType.Name== 'General'){
	              isGeneral = true;
	              
	          }else if(account.RecordType.Name == 'Client'){
	          	strRecordType = account.RecordType.Name;
	              isClient = true;
	          }
	          else if(account.RecordType.Name == 'Family Member'){
	              isFamily = true;
	          }
	          else if(account.RecordType.Name == 'Influencers'){
	              isInfluencer = true;
	          }
	          else if(account.RecordType.Name == 'Master'){
	              isMaster = true;
	          }
      		
        }	
      	 return null;
      }
 
  public EditAccountController() {
    account = new Account();
  }
 
  // save the new account record
  public PageReference saveAccount() 
  {
  	try{
	    //populate salutation first name and last name if record type is Client
	     if(strRecordType == 'Client' || strFamilyRecordType == 'Family Member'|| strInfluencersRecordType == 'Influencers')
	     {
	     	account.Salutation = contTemp.Salutation;
	     	account.FirstName = contTemp.FirstName;
	     	account.LastName = contTemp.LastName;
	     	system.debug('**********contTemp*********'+contTemp);
	     	system.debug('**********account*********'+account);
	     	 account.RecordTypeId = recordTypeforAcc.Id;
	     	
	     }	
	    	
	   	 //populate entity Owner based on currentUser variable used
	     account.OwnerId = currentUser.Id;	
	    Database.Saveresult  saveResult= Database.insert(account);
    if(saveResult.isSuccess())
   	 return new PageReference('/' + account.Id);
  	}
  	catch(Exception e)
  	{
  		system.debug('*************'+e.getMessage());
  		
  	}
  	return null;
  }   
    
}