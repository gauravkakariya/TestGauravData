@isTest
private class Test_InvestwellPortfolioController {

    static testMethod void InvestwellPortfolioController() 
    {
     	Test.startTest();
        Apexpages.currentPage().getParameters().put('username','tech@ffreedom.in');
         Apexpages.currentPage().getParameters().put('password','ffreed0m$12');
         
         InvestwellPortfolioController invest = new InvestwellPortfolioController();
         
         User objUser =  invest.getCurrentUserDetails();
        Test.stopTest();
    }
}