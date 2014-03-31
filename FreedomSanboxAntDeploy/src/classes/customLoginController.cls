global class customLoginController 
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
    
    global customLoginController()
    {
      	IsInvalid = false;
    }
    
    global PageReference login() 
    {
      	String strurl= ApexPages.currentPage().getHeaders().get('Host');
      	//Error.debugLog('=======LoginURL========'+strurl);
      	//system.debug('=======LoginURL========'+strurl);
    	//fullURL='https://'+ApexPages.CurrentPage().getHeaders().get('Host')+'/apex/InvestwellLogin?'+'&password='+password+'&username='+username;
	    if(password != null && username != null && password != '' && username != '')
	    {
	      	fullURL='http://www.ffreedom.in/InvestwellLoginNew?'+'password='+password+'&username='+username;
	        PageReference pagf=new PageReference(fullURL);
	        return pagf;
	    }
	    else
	    {
	      	IsInvalid = true;
	    }
    	return null;
    }
    
    global static testMethod void testSiteLoginController () 
    {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        System.assertEquals(controller.login(),null);                           
    }    
}