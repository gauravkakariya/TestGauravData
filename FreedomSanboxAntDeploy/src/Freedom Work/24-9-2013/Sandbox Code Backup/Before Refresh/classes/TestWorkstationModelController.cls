@isTest
private class TestWorkstationModelController {

    static testMethod void myUnitTest() {
           Test.startTest();
           WorkstationModelController controller = new WorkstationModelController();
           controller.Init();
           controller.CreateWorkstation();
           controller.ViewWorkstation();
           controller.Close();
           Test.stopTest();
     } 
    
  
    
    
 }