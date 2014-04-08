@isTest
private class TestUpdateStatusChangeDate {
	public static testMethod void testUpdateStatusChangeDate(){
		
	    List<Lead> leadList = new List<Lead>();
	    List<Lead> updateleadList = new List<Lead>();
	    List<Id> leadIds = new List<Id>();
		for(Integer i=0; i<10; i++){
			Lead ld = new Lead(LastName='Test', FirstName='Lead', Status='Initiating');
			leadList.add(ld);
		}
		insert leadList;
		//Lead ld = new Lead(LastName='Test', FirstName='Lead', Status='Initiating');
		//insert ld;
		for(Lead l: leadList){
			leadIds.add(l.Id);
		}
		for(Lead l1 : [select Status_Change_Date__c from Lead where Id IN :leadIds])
		{
			System.assertEquals(l1.Status_Change_Date__c, System.today());
			l1.Status_Change_Date__c = System.today()- 1;
			l1.Status = 'Meeting-Fixed';
			updateleadList.add(l1);
		}	
		
		update updateleadList;
		
		for(Lead l2 :[select Status_Change_Date__c from Lead where Id IN :leadIds])
		{
			System.assertEquals(l2.Status_Change_Date__c, System.today());
		}
	}


}