/*
    Revision History:
    Version       Author    Date          Comments
    2.0           Gaurav   	1/10/2013    1.Populate Account field for creating New and Edit Account
*/
public with sharing class NewEditAccountController 
{ 
    public Contact contTemp {get; set;}
    public User currentUser {get; set;}
    public RecordType recordTypeforAcc {get; set;}
    public Account accountObj{get; set;}
    
    //record type variables
    public boolean isGeneral {get; set;}
    public boolean isClient{get; set;}
    public boolean isFamily{get; set;}
    public boolean isInfluencer{get; set;}
    public boolean isMaster{get; set;}
    
     //Team Memer Variable
    public boolean isPST {get; set;}
    public boolean isMST{get; set;}
    public boolean isMST2{get; set;}
    public boolean isFPA{get; set;}
   
    public String strOldBussinesUnit{get; set;}
    public String strOldPST{get; set;}
    public String strOldMST{get; set;}
    public String strOldFPA{get; set;}
    public String strOldMST2{get; set;}
    public String objPrefixTeamMember{get; set;}
    
   
    public String accountId{get; set;}
    public String retirementAge{get; set;}
    public String relatedClientandLeadCount{get; set;}
    public boolean isClientCountDone {get; set;}
    
    String strRecordType = '';
    String strFamilyRecordType = '';
    String strInfluencersRecordType ='';
    
    String strPST = '';
    String strMST = '';
    String strMST2 = '';
    String strFPA = '';
    
    //Standard Controller
    public NewEditAccountController(ApexPages.StandardController controller) 
    {
      contTemp  = new Contact();
      accountObj = new Account();
      strRecordType = '';
      retirementAge = '';
      
      Schema.DescribeSObjectResult dsr = Team_Member__c.SObjectType.getDescribe();
	  objPrefixTeamMember = dsr.getKeyPrefix();
	  system.debug('*****objPrefixTeamMember********'+objPrefixTeamMember);
	  
      currentUser = [SELECT Id,Name FROM User WHERE Id=:UserInfo.getUserId()];
     try{
	      //While Creating New Account fetch recordType Id and Diplay RecordType section as per RecordType Name
	      if(ApexPages.currentPage().getParameters().get('RecordType') != null)
	      {
	          recordTypeforAcc = [SELECT Id, Name 
	                              FROM RecordType 
	                              WHERE Id=:ApexPages.currentPage().getParameters().get('RecordType') 
	                              AND SobjectType ='Account'];
	                              
	          if(recordTypeforAcc.Name == Label.RecordType_General){
	              isGeneral = true;
	          }else if(recordTypeforAcc.Name == Label.RecordType_Client)
	          {
	          		system.debug('In client rt');
	              strRecordType = recordTypeforAcc.Name;
	              isClient = true;
	              accountObj.RecordTypeId = recordTypeforAcc.Id;
	          }
	          else if(recordTypeforAcc.Name == Label.Record_Type_Family_Member)
	          {
	              isFamily = true;
	              strFamilyRecordType = recordTypeforAcc.Name; 
	          }
	          else if(recordTypeforAcc.Name == Label.RecordType_Influencers)
	          {
	              isInfluencer = true;
	              strInfluencersRecordType = recordTypeforAcc.Name; 
	          }
	          else if(recordTypeforAcc.Name == Label.RecordType_Master)
	          {
	              isMaster = true;
	          }
	      } 
      //If User Click on Edit Button on Account
      
          if(ApexPages.currentPage().getParameters().get('id') != null)
          {
            Account objAccount = [Select Id,Name,Retirement_Age__c,OPS_Team_Member__c,FPA_Team_Member__c,MST_Team_Member__c,PST_Team_Member__c,Business_Unit__c,isPersonAccount,RecordType.Name
                                  From Account 
                                  Where Id =:ApexPages.currentPage().getParameters().get('id')
                                 ];
            
            
            strRecordType = objAccount.RecordType.Name;
            strOldPST = '';
            strOldMST = '';
            strOldMST2 = '';
            strOldFPA = '';
            
            if(strRecordType == Label.RecordType_Client || strRecordType == Label.RecordType_General)
            {   
                strOldBussinesUnit= objAccount.Business_Unit__c;
                strOldPST = objAccount.PST_Team_Member__c;
                strOldMST = objAccount.MST_Team_Member__c;
                strOldFPA = objAccount.FPA_Team_Member__c;
                strOldMST2 = objAccount.OPS_Team_Member__c; 
            }    
            
            accountId = ApexPages.currentPage().getParameters().get('id');
            String strQuery = ' Select RecordType.Name , ';
            Map<String, Schema.SObjectField> mapAAPFieldNameToFieldDescribe = schema.SObjectType.Account.fields.getMap();
            
            system.debug('strRecordType--->' + strRecordType);
            
            // Fetch Account Record as per Record Type
            if(strRecordType == Label.RecordType_Client || strRecordType == Label.Record_Type_Family_Member|| strRecordType == Label.RecordType_Influencers)
            {
                //Create Dynamic query
                for(String strField : mapAAPFieldNameToFieldDescribe.keySet())
                {
                    system.debug('strField--->' + strField);    
                     //if(mapAAPFieldNameToFieldDescribe.get(strField).getDescribe().isUpdateable() ) 
                        strQuery += strField +',';
                }
                system.debug('strQuery--->' + strQuery);    
                //strQuery += 'isPersonAccount ,';
                strQuery = strQuery.substring(0, strQuery.length() - 1);
                strQuery += ' from Account where isPersonAccount = true and Id = \'' + accountId + '\''; 
            }
            else if(strRecordType == Label.RecordType_General)
            {
                
                system.debug('***********strRecordType'+strRecordType);
                
                for(String strField : mapAAPFieldNameToFieldDescribe.keySet())
                {
                    system.debug('***********strField.EndsWit'+strField.EndsWith('__pc'));
                     if(!strField.EndsWith('__pc') ) 
                        strQuery += strField +',';
                }   
                    //strQuery += 'isPersonAccount ,';
                    strQuery = strQuery.substring(0, strQuery.length() - 1);
                    strQuery += ' from Account where Id = \'' + accountId + '\''; 
            }   
            system.debug('strQuery--->' + strQuery);    
            accountObj = Database.query(strQuery);
                         system.debug('accountObj--->' + accountObj);
                         
             if(accountObj.RecordType.Name== Label.RecordType_General)
             {
                isGeneral = true;
                
             }else if(accountObj.RecordType.Name == Label.RecordType_Client){
                isClient = true;
              }
              else if(accountObj.RecordType.Name == Label.Record_Type_Family_Member){
                  isFamily = true;
              }
              else if(accountObj.RecordType.Name == Label.RecordType_Influencers){
                  isInfluencer = true;
              }
              else if(accountObj.RecordType.Name == Label.RecordType_Master){
                  isMaster = true;
              }
              
          }
      }
       catch(Exception e)
     {
        system.debug('******Exception*******'+e.getMessage());
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
        ApexPages.addMessage(myMsg);
        return;
     }
       
                      
    }

  public NewEditAccountController() {
    //accountObj = new Account();
  }
 
  public PageReference getClientandLeadCount()
  {
        
        try{
            relatedClientandLeadCount = '';
            system.debug('*********Hi******'+strRecordType);
            //relatedClientandLeadCount = '';
            if(strRecordType == Label.RecordType_General)
            {
                
                system.debug('*********strRecordType'+strRecordType);
                Integer counterPSTAccount =0;
                Integer counterMSTAccount = 0; 
                Integer counterMST2Account =0; 
                Integer counterFPAAccount  =0;
                Integer counterLead = 0;
                 
                Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name=: Label.RecordType_Client].Id;
                /*Integer counterAccount = [Select count() 
                                   From Account 
                                   Where Entity_Status__c = 'Active' and 
                                         RecordTypeId=:rtId and 
                                         Virtual_Partner__c =: accountId];
                */                         
                               
                isPST = false;
                isMST2 = false;
                isMST = false;
                isFPA = false; 
                
                system.debug('*********strOldPST Upaate'+strOldPST);
               
                if(strOldPST != null && strOldPST != '' &&  strOldPST != accountObj.PST_Team_Member__c) 
                {
                    isPST = true;
                    counterPSTAccount = [Select count() 
                                                 From Account 
                                                 Where Entity_Status__c = 'Active' and 
                                                         RecordTypeId=:rtId and 
                                                         Virtual_Partner__c =: accountId and PST_Team_Member__c=: strOldPST ]; 
                                                         
                    counterLead = [Select count() 
		                               From Lead 
		                               Where Virtual_Partner__c =: accountId and IsConverted = false]; 
                                                         
                }                                         
                                                         
                 if(strOldMST != null && strOldMST != '' && strOldMST != accountObj.MST_Team_Member__c) 
                 {
                    isMST = true;
                    counterMSTAccount = [Select count() 
                                                 From Account 
                                                 Where Entity_Status__c = 'Active' and 
                                                         RecordTypeId=:rtId and 
                                                         Virtual_Partner__c =: accountId and MST_Team_Member__c=: strOldMST ];  
                                                         
                
                 }
                  if(strOldMST2 != null && strOldMST2 != '' && strOldMST2 != accountObj.OPS_Team_Member__c)
                  { 
                    isMST2 = true;
                    counterMST2Account = [Select count() 
                                                 From Account 
                                                 Where Entity_Status__c = 'Active' and 
                                                         RecordTypeId=:rtId and 
                                                         Virtual_Partner__c =: accountId and OPS_Team_Member__c=: strOldMST2 ]; 
                                                          
                                                         
                  }                                  
                   if(strOldFPA != null && strOldFPA != '' && strOldFPA != accountObj.FPA_Team_Member__c)
                   { 
                     isFPA = true;
                    counterFPAAccount = [Select count() 
                                                 From Account 
                                                 Where Entity_Status__c = 'Active' and 
                                                         RecordTypeId=:rtId and 
                                                         Virtual_Partner__c =: accountId and FPA_Team_Member__c=: strOldFPA ];  
                                                                                             
                   }
                 
                
                if(isPST){
                    system.debug('*****isPST**'+isPST);
                    strPST = 'You have changed PST.\\n Total Members whose PST will be changed are : '+ counterPSTAccount;
                    strPST += '\\n and Total Leads whose PST will be changed are : '+ counterLead;
                }   
                
                if(isMST){
                    system.debug('*****isMST**'+isMST);
                    strMST = 'You have changed MST.\\n Total Members whose MST will be changed are : '+ counterMSTAccount;
                }
                if(isMST2){
                    system.debug('*****isMST2**'+isMST2);
                    strMST2 = 'You have changed MST2.\\n Total Members whose MST2 will be changed are :'+ counterMST2Account;
                }
                if(isFPA){
                    system.debug('*****isFPA**'+isFPA);
                    strFPA = 'You have changed FPA.\\n Total Members whose FPA will be changed are :'+ counterFPAAccount;
                }
                
                if(strPST.trim() == '' && strMST.trim() == '' && strMST2.trim() == '' && strFPA.trim() == ''){
                	PageReference accPage = saveAccount();
                	return accPage;
                }
                
                if(strPST.trim() != '' || strMST.trim() != '' || strMST2.trim() != '' || strFPA.trim() != ''){
                    system.debug('*****iffft**');
                   relatedClientandLeadCount = strPST +'\\n' +strMST+ '\\n' + strMST2+'\\n' +strFPA;
                }/*else{
                    system.debug('*****e;lsee**');
                    relatedClientandLeadCount = '';
                    PageReference accPage = null;
                    if(saveAccount() != null ){
                    	accPage = new PageReference('/' + accountObj.Id);
                    	accPage.setRedirect(true);
                    }
                    	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Hello');
        				ApexPages.addMessage(myMsg);
                    
                }*/
                system.debug('*****relatedClientandLeadCount**'+relatedClientandLeadCount);     
                isClientCountDone = true;                                       
            }                                            
            return null;
        }               
        catch(Exception e)
        {
            system.debug('******Exception*******'+e.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
        }           
        return null;
  }
  
  public PageReference cancel() 
  {
    if(accountId == null || accountId == '')
        return new PageReference('/001/o'); 
    
    if(accountId != null && accountId != '')
        return new PageReference('/' + accountObj.Id);
        
    return Null;
  }
  
  // save the new accountObj record
  public PageReference saveAccount() 
  {
    system.debug('******** accountObj.Retirement_Age__c'+accountObj);
    Database.Saveresult  saveResult;
    try{
         // Create New Account and populate salutation first name and last name
         if((strRecordType == Label.RecordType_Client || strFamilyRecordType == Label.Record_Type_Family_Member|| strInfluencersRecordType == Label.RecordType_Influencers) 
            && (accountId == null ||  accountId == '') )
         {
            accountObj.Salutation = contTemp.Salutation;
            accountObj.FirstName = contTemp.FirstName;
            accountObj.LastName = contTemp.LastName;
         }  
         /*
          if(Label.RecordType_General.equals(strRecordType) == true)
          {
          		system.debug('*********saveacc' + accountObj);
          		
          		String strAccount = accountObj.Name;
          		system.debug('*********strAccount' + strAccount);
          		String[] splitString = strAccount.split(' ');
          		
          		if (splitString != null && splitString.size() == 1)
      		        accountObj.FirstName = splitString[0];
      		    if (splitString != null && splitString.size() > 1) {
      		        
      		        for(Integer i= 0;i < splitString.size();i++) {
      		            if (i ==0 )
      		               continue;
      		            accountObj.LastName += splitString[i];
      		        }	
      		    }
      		}
   		 
         */
         //accountObj.Retirement_Age__c = retirementAge;
         //if New Account then insert accountObj according to RecordType
         if(accountId == null || accountId == '')
         {
             accountObj.RecordTypeId = recordTypeforAcc.Id;
             accountObj.OwnerId = currentUser.Id;   
             saveResult = Database.insert(accountObj);
         }  
         else if(accountId != null || accountId != '')
         {
            system.debug('*********saveacc' + accountObj);
            // Update Account with required information
            system.debug('*********client details -->' + accountObj);
            saveResult = Database.update(accountObj);
           
         }
         system.debug('*********save111' + saveResult.isSuccess());
         
         //Redirect to Account if successfulyy created or Update
         if(saveResult.isSuccess()){
            Pagereference accPage = new PageReference('/' + accountObj.Id);
            accPage.setRedirect(true);
            return accPage;
         }
     }
     catch(system.DmlException dml)
     {
     	ApexPages.Message myMsg;
     	system.debug('******dml.getMessage()****'+dml.getMessage());
     	if(dml.getMessage().contains(Label.Member_Bussiness_Unit_Message))
     	{
       	 myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Member_Bussiness_Unit_Message );
       	 ApexPages.addMessage(myMsg);
     	}
     	
     	else if(dml.getMessage().contains(Label.MST2_Business_Unit_Message))
     	{
       	 myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Verify_MST2_Message );
       	 ApexPages.addMessage(myMsg);
     	}
     	else if(dml.getMessage().contains( Label.Team_Member_Business_Unit_Message))
     	{
       	 myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Team_Member_Business_Unit_Message );
       	 ApexPages.addMessage(myMsg);
     	}
     	else if(dml.getMessage().contains('ENTITY_IS_LOCKED'))
     	{
     	  myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Entity is Locked, Please Approve it from your Manager' );
       	  ApexPages.addMessage(myMsg);
     	}
     	else
     	{
	     	myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, dml.getMessage());
	        ApexPages.addMessage(myMsg);
     	}
     	return null;
     }
      
     catch(Exception e)
     {
     	 ApexPages.Message myMsg;
         myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
         ApexPages.addMessage(myMsg);
     }
     return null;
   }  
    
}