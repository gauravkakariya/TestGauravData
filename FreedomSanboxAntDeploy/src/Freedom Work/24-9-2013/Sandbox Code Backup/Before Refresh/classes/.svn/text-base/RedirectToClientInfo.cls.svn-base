public class RedirectToClientInfo{
    Contact contInfo = null;
    public RedirectToClientInfo() {
           User userdetails = [select ContactId,Email,FirstName,LastName,Title from User where Id=:userinfo.getuserId()];
           if(userdetails !=null && userdetails.ContactId!=null){
               contInfo = [select Id, AccountId from contact where id =: userdetails.ContactId ];
           }
    }
    
    public PageReference redirectTo() {
    	 
      if(contInfo !=null && contInfo.AccountId!=null){
          pageReference pageVf = new pagereference('/apex/ClientMemberDetails?entityId='+contInfo.AccountId+'&tabname=Financial Planning&sfdc.override=1');
          pageVf.setRedirect(true);
          return pageVf;
      }else{
          return null;
      }
	          
    }

}