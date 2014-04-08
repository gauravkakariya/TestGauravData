trigger UpdateAccount4PortalUser on User (after update) {
	
	Map<User, Id> userMap= new Map<User,Id>();
	Map<Id,Account> accountMap= new Map<Id,Account>();
	List<Account> accountList = new List<Account>();
	
	
	Profile profile=[select Id from Profile where Name = 'Customer Portal Standard - Custom'];
	
	for(User user:Trigger.new){
		if(user.ProfileId == profile.Id){
			userMap.put(user, user.AccountId);
		}
	}
	
	for(Account acc: [select Id,
					  PersonEmail,
					  FirstName,
					  LastName,
					  PersonMobilePhone,
					  PersonHomePhone,
					  Fax,
					  PersonTitle,
					  BillingStreet,
					  BillingCity,
					  BillingState,
					  BillingPostalCode from Account where Id IN :userMap.values()]){
		accountMap.put(acc.Id, acc);
	}	
	
	for(Integer i= 0; i< Trigger.size; i++){
		if(userMap.containsKey(Trigger.new[i])){
			Account act = accountMap.get(userMap.get(Trigger.new[i]));
			if(act!=null){
				boolean flag=false;
				if(Trigger.new[i].Email != Trigger.old[i].Email  ){
				act.PersonEmail = Trigger.new[i].Email;
				flag=true;
			    }
				if(Trigger.new[i].FirstName != Trigger.old[i].FirstName ){
					act.FirstName = Trigger.new[i].FirstName;
					flag=true;
				}
				if(Trigger.new[i].LastName != Trigger.old[i].LastName ){
					act.LastName = Trigger.new[i].LastName;
					flag=true;
				}
				if(Trigger.new[i].MobilePhone != Trigger.old[i].MobilePhone ){
					act.PersonMobilePhone = Trigger.new[i].MobilePhone;
					flag=true;
				}
				if(Trigger.new[i].Phone != Trigger.old[i].Phone ){
					act.PersonHomePhone = Trigger.new[i].Phone;
					flag=true;
				}
				if(Trigger.new[i].Fax != Trigger.old[i].Fax ){
					act.Fax = Trigger.new[i].Fax;
					flag=true;
				}
				if(Trigger.new[i].Title != Trigger.old[i].Title  ){
					act.Salutation = Trigger.new[i].Title;
					flag=true;
				}
				if(Trigger.new[i].Street != Trigger.old[i].Street  ){
					act.BillingStreet = Trigger.new[i].Street;
					flag=true;
				}
				if(Trigger.new[i].City != Trigger.old[i].City ){
					act.BillingCity = Trigger.new[i].City;
					flag=true;
				}
				if(Trigger.new[i].State != Trigger.old[i].State ){
					act.BillingState = Trigger.new[i].State;
					flag=true;
				}
				if(Trigger.new[i].PostalCode != Trigger.old[i].PostalCode ){
					act.BillingPostalCode = Trigger.new[i].PostalCode;
					flag=true;
				}
				if(flag){
				accountList.add(act);
				}
			}
			
			
			
		}
	}	
	
	if(accountList.size()>0){
		update accountList;
	}

}