@isTest
private class TestCheckOppty {
	
	public static testMethod void testOppty(){
		Lead ld = [select Id from Lead limit 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(ld);
		Test.setCurrentPage(Page.CheckOpptyOnLeadConvert);
		CheckOpptyForLeadController chck = new CheckOpptyForLeadController(sc);
		
	}
}