global class PortalLoginController 
{
	list<Account> lstAcc= new list<Account>();
    global String username {get; set;}
    global String password {get; set;}
    public Boolean IsInvalid{get; set;}
    //sessionid
    global string sessionID{get; set;}
    //end
    global String fullURL;
    global String strurl;
    
   
	public pageReference pgReference = null;
	
	public Boolean displayPopUp{get;set;}
	public Boolean displayPopUpLogin{get;set;}
	
	
	 global PortalLoginController()
    {
      	IsInvalid = false;
      	displayPopUp = false;
		displayPopUpLogin = false;
    }
    
	public void showPopUpLogin()
	{
		displayPopUpLogin = true;
	}
	public void showPopUp()
	{
		displayPopUp = true;
	}
	public void closePopUp()
	{
		displayPopUp = false;
		displayPopUpLogin = false;
	}
	
	public PageReference getPageReference()
	{
		pgReference = page.AdvisorOffice;
		pgReference.setRedirect(true);
		return pgReference;
	}
	
	public pagereference cancel()
	{
		return(getPageReference());
	}
    
    global PageReference login() 
    {
      	String baseUrl = Partner_Portal__c.getInstance('Base Url').PortalUrl__c;
  	    String orgId = Partner_Portal__c.getInstance('Org Id').PortalUrl__c;
  	    String portalId = Partner_Portal__c.getInstance('Portal Id').PortalUrl__c;
  	 /* Profile prof = [select id from profile where usertype = 'PowerPartner' limit 1];
  	   	ID PartnerProfileID =prof.id;
	  	List<User> lstUser = [select Id,Name,UserName,password__c,ProfileId,Portal_Id__c,ContactId,Profile.Name from User where (UserName = :username and password__c =: password)];
	  	System.debug('---------------------lstUser-----------------------------'+lstUser);
	  	if(lstUser.size() > 0)
		{
	  		for(User objUser : lstUser)
	  		{*/
			    //String startUrl = 'https://ffreedom--Ffreedom.cs13.my.salesforce.com/secur/login_portal.jsp?orgId=00DW00000012h2l&portalId=06020000000DWVe';
			 
			  	//String startUrl = baseUrl+'/secur/login_portal.jsp?'+orgId+'&portalId='+portalId;
			  	
			 // 	String startUrl = 'https://ffreedom--Ffreedom.cs13.my.salesforce.com/secur/login_portal.jsp?'+orgId+'&portalId='+portalId;//+'&loginType=3';
			  	//String startUrl = 'https://ffreedom--Ffreedom.cs13.my.salesforce.com/secur/login_portal.jsp?orgId=00DW00000012h2l&portalId=06020000000DWVe&loginType=3';
			  	String startUrl = baseUrl+'/secur/login_portal.jsp?'+orgId+'&portalId='+portalId+'&loginType=3';
			  	startUrl += '&startUrl='; 
			  	startUrl += '&loginUrl=';
			  	startUrl += '&useSecure=true';
			  	startUrl += '&un=' + username;
			  	startUrl += '&pw='+ password;
		  
			  	PageReference portalPage	= new PageReference(startUrl);
			  	portalPage.setRedirect(true);
			  
			  	PageReference p = Site.login(username, password, startUrl);
			  	
			  	if(p==null) 
			  		return Site.login(username, password, null);			  	
			  	else			  	
			  		return portalPage;
			 /*	if(p == null)
			 	{
			 		ApexPages.Message strError = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct UserName/Password');
	   	  			ApexPages.addMessage(strError);
	   	  			return null;
			 	}
			 	else
			 	 return 'http://ffreedom1.ffreedom.cs13.force.com/partnerlogin';*/
/*		    }
		    
	  	}
	  	else
	    {
  	 		ApexPages.Message strError = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter correct UserName/Password');
	   	  	ApexPages.addMessage(strError);
	   	  	System.debug('---------------------in else----------------------------');
	   	  	return null;
	   	  //	PageReference portalPage1	= new PageReference('http://ffreedom1.ffreedom.cs13.force.com/partnerlogin');
    		//return portalPage1;
	   	 
	    }*/
	 //return null;  
    }
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.PartnerForgotPasswordConfirm;
        pr.setRedirect(true);
        
        system.debug(success);
        
        if (success) {              
            return pr;
        }
        return null;
    }
  
    global static testMethod void testPortalLoginController () 
    {
        // Instantiate a new controller with all parameters in the page
        PortalLoginController controller = new PortalLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        System.assertEquals(controller.login(),null);                           
    }    
}