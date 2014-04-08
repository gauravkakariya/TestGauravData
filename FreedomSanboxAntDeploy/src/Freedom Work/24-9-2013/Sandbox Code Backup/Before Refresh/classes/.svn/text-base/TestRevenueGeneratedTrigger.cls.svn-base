@isTest
 private class TestRevenueGeneratedTrigger {
	
		public static testMethod void testBookedRevenue(){
	    Id recordTypeId = [select Id from RecordType where Name='Client'].Id;
		Map<Id, Account> actList = new Map<Id, Account>();
		List<Account> newAccts = new List<Account>();
		List<Execution_Tracker__c> extTrackerList = new List<Execution_Tracker__c>();
		for(Integer i=0; i<10; i++){
			Account newAct = new Account(LastName='test', FirstName='Account', RecordTypeId= recordTypeId);
			newAccts.add(newAct);
		}
		insert newAccts;
		
		for(Account act:newAccts){
			actList.put(act.id, act);
		}
		
	    List<CampaignMember> memberList = new List<CampaignMember>();
	    List<Contact> cn = [select Id from Contact where IsPersonAccount = true and AccountId IN :actList.keySet()];
		Campaign cmp = new Campaign(Name = 'Test Campaign');
		insert cmp;
	
		for(Contact c: cn){
			CampaignMember cmpMem = new CampaignMember(ContactId = c.Id, CampaignId=cmp.Id);
			memberList.add(cmpMem);
		}
		insert memberList;
		
		Contact con = new Contact(FirstName='test', LastName='test');
		insert con;
		Campaign cmpFreedomDay = new Campaign(Name = 'Ffreedom Day');
		insert cmpFreedomDay;
		CampaignMember cmpMem = new CampaignMember(ContactId = con.Id, CampaignId=cmpFreedomDay.Id);
		insert cmpMem;
		//FS0402 Changed the datatype of Revenue_Booked__c from Currency to Formula field
		for(Account act: actList.values()){
			Execution_Tracker__c ext = new Execution_Tracker__c(Entity_Name__c = act.Id);//, Revenue_Booked__c=20000 );
		    extTrackerList.add(ext);
		}
		insert extTrackerList;
		delete extTrackerList;
		
		delete memberList;
		
	} 
}