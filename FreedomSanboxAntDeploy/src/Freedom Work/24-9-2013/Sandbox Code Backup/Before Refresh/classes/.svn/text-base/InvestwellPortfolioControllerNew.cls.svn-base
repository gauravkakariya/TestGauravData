public with sharing class InvestwellPortfolioControllerNew 
{
	 public User getCurrentUserDetails()
     {
      //======Get EntityId of current user=====
      return [select Id, Name,AccountId from User where Id=:UserInfo.getUserId()];
  }
     
     public string InvestUserId{get;set;}
     public string InvestwellBrokId{get;set;}
     public string InvestUserPass{get; set;}
    
     public InvestwellPortfolioControllerNew()
        {
          
              InvestUserId=Apexpages.currentPage().getParameters().get('username');
              InvestUserPass=Apexpages.currentPage().getParameters().get('password');
              InvestwellBrokId='11011';
  		}
}