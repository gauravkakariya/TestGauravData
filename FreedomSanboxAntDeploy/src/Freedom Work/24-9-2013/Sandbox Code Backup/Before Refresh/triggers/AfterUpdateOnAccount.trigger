trigger AfterUpdateOnAccount on Account (before update)
 {
 	
		HandlerForAfterUpdateOnAccount objAccount = new HandlerForAfterUpdateOnAccount();
		objAccount.beforeUpdateAccount(trigger.new,trigger.old);
 }