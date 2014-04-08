@isTest
private class customLoginControllerTest {

    static testMethod void customLoginControllercheck() 
    {
        Test.startTest();
        ApexPages.currentPage().getHeaders().put('Host','255.255.255.255');
        Apexpages.currentPage().getParameters().put('useName','tech@ffreedom.in');
       // Apexpages.currentPage().getParameters().put('password','ffreed0m$12');
         
        customLoginController login = new customLoginController(); 
        login.password = 'PWD';
        login.username = 'Uname';
        PageReference objPageReference =  login.login();
        customLoginController login2 = new customLoginController(); 
        PageReference objPageReference2 =  login2.login();
        
         // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
        System.assertEquals(controller.login(),null); 
        Test.stopTest(); 
    }   
}