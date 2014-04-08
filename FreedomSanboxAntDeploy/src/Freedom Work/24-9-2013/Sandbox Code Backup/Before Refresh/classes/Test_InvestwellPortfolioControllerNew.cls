@isTest
private class Test_InvestwellPortfolioControllerNew {

     static testMethod void InvestwellPortfolioControllerNew() 
    {
     	Test.startTest();
        Apexpages.currentPage().getParameters().put('username','tech@ffreedom.in');
        Apexpages.currentPage().getParameters().put('password','ffreed0m$12');
         
        InvestwellPortfolioControllerNew invest = new InvestwellPortfolioControllerNew();
         
        User objUser =  invest.getCurrentUserDetails();
        Test.stopTest();
    }
}