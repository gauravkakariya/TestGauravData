/**
 * An apex page controller that exposes the site login functionality
 */
global class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
     /*String startUrl = 'https://emea.salesforce.com/secur/login_portal.jsp';
  startUrl += '?orgId=00D20000000JZVv&portalId=06020000000M1En&loginType=3';
  startUrl += '&useSecure=true';
  startUrl += '&un=' + 'tech_portal@ffreedom.in';
  startUrl += '&pw='+ 'cloud@24';*/
       String  startURL = (Site.getPrefix() == null ? '' : Site.getPrefix()) +  '/home/home.jsp';
        System.debug('startURL'+startURL);
        System.debug(Site.login(username, password, startURL));
        return Site.login(username, password, startURL);
    }
    
    
    global SiteLoginController () {}
    
    global static testMethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}