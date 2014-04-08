@isTest
private class LifeInsurancePlanningControllerTest {
    static LifeInsurancePlanningController lifeInsurancePlanning;

    public static void testData(){
        lifeInsurancePlanning=new LifeInsurancePlanningController();
    }

    static testMethod void myUnitTest() {
        test.startTest();
        testData();
        test.stopTest();
    }
}