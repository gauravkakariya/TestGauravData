public with sharing class InvestwellPortfolioController 
{
     public User getCurrentUserDetails()
     {
      //======Get EntityId of current user=====
      return [select Id, Name,AccountId from User where Id=:UserInfo.getUserId()];
  	}
     
     public string InvestUserId{get;set;}
     public string InvestwellBrokId{get;set;}
     public string InvestUserPass{get; set;}
    
     public InvestwellPortfolioController()
     {
          InvestUserId=Apexpages.currentPage().getParameters().get('username');
          InvestUserPass=Apexpages.currentPage().getParameters().get('password');
          InvestwellBrokId='11011';
  	}
}


/* 
   public InvestwellPortfolioController()
        {
      String uId = getCurrentUserDetails().AccountId;
              If( uId != null)
              {
                     //InvestwelUserID__c --new field created on ffdev1
                     //Account objAcc = [select Email_Temp__c from Account where Id =: uId];
                     //=======Get portal user name of current entity=====
                     User objUsr = [select Email, UserName from User where AccountId =: uId and IsActive = true and IsPortalEnabled = true];

              if(objUsr != null && objUsr.Email != null)
                  {
                     //========Portal Username to login======
                     InvestUserId = objUsr.Email;
                     
                     //========Extract Ffreedom Broker Id from Custom Setting -- Investwell_Broker__c======
                         Investwell_Broker__c objInvestwellBroker = Investwell_Broker__c.getInstance('Investwell Broker');
                         if(objInvestwellBroker!= null && objInvestwellBroker.Investwell_Broker_Id__c != null)         
                                   InvestwellBrokId = objInvestwellBroker.Investwell_Broker_Id__c;
                  }
              }
          }
              */