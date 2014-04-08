@isTest
private class TestKPIReportBatch {

    static testMethod void myKPIBatchTest() 
    {
        Test.StartTest();
   		KPIReportBatch objKPIReportBatch = new KPIReportBatch();
  		objKPIReportBatch.query='SELECT ID, Name  FROM User' ; //where UserRole.Name = Fps[AMETHYST MUMBAI] and Name =Bharti Punjabi'
   		ID batchprocessid = Database.executeBatch(objKPIReportBatch);
   		Test.StopTest();
    }
}