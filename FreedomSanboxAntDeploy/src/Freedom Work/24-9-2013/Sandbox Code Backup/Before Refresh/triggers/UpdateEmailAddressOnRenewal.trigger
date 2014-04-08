trigger UpdateEmailAddressOnRenewal on Renewal__c (before insert) {
	System.debug('test');
	System.debug('size'+Trigger.size);
	Map<Id,Id> renewalEntityMap = new Map<ID,Id>();	
	
	for(Renewal__c ren:Trigger.new){
		/*system.debug('entity email:'+ren.Entity__r.Email_Temp__c );
		system.debug('ren email:'+ren.Email__c );
		if(ren.Entity__r.Email_Temp__c != null && ren.Email__c == null){
			system.debug('entity email:'+ren.Entity__r.Email_Temp__c );
			ren.Email__c=ren.Entity__r.Email_Temp__c ;
		}*/
		//system.debug('enity id:'+ren.Entity__c );
		renewalEntityMap.put(ren.Id,ren.Entity__c);
	}
	//system.debug('renewalEntityMap'+renewalEntityMap);
	List<Account>  accountList= new List<Account>();
	accountList = [select Id,PersonEmail,PersonMobilePhone,Name  from Account where Id IN: renewalEntityMap.values()];
	Map<Id,Account> AccountMap = new Map<Id,Account>();
	
	for(Account acc:accountList){
		AccountMap.put(acc.Id,acc);
	}
	    //System.debug('AccountMap'+AccountMap);
	   // System.debug('accountList'+accountList);
	    
	    
	for(Renewal__c ren:Trigger.new){
		Id accId= renewalEntityMap.get(ren.Id);
		 Account acc= AccountMap.get(accId);
		
		if(ren.Email__c==null && acc.PersonEmail!=null){
			ren.Email__c=acc.PersonEmail;
		}
		if(ren.Mobile__c==null && acc.PersonMobilePhone!=null){
			ren.Mobile__c=acc.PersonMobilePhone;
		}
		if(ren.Entity_Name__c==null && acc.Name!=null){
			ren.Entity_Name__c=acc.Name;
		}
	}
}