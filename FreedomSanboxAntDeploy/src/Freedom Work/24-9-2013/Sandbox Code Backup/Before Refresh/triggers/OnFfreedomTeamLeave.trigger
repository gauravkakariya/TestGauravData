trigger OnFfreedomTeamLeave on Account (after update) {
	
	/*Setty : SMS Magic uninstall 19/09/2012
	
		List<smsmagicvc1__smsMagic__c> smsObjects = new List<smsmagicvc1__smsMagic__c>();
	
	End:Setty */
	
	///*Setty:NewCode
	
	List<smagicbasic__smsMagic__c> smsObjects = new List<smagicbasic__smsMagic__c>();
	
//	*/
	
	/*for(Account objAcc : Trigger.new){
		if(objAcc.IsFfreedom_On_Leave__c && objAcc.PersonMobilePhone != null && objAcc.PersonMobilePhone !='')
		{
			if(objAcc.Entity_Status__c.equals('Active'))
			{
					smsmagicvc1__smsMagic__c smsObj = new smsmagicvc1__smsMagic__c();
			 		smsObj.smsmagicvc1__PhoneNumber__c = objAcc.PersonMobilePhone;
                    smsObj.smsmagicvc1__SMSText__c = 'Dear '+objAcc.FirstName+' We have an internal seminar today from 11am onwards. You can get in touch with your FP on their mobile nos. though. Rgrds. Team Ffreedom'; 
                    smsObj.smsmagicvc1__senderId__c = 'Ffreedom';
                    smsObj.smsmagicvc1__Name__c = objAcc.Name;
                    smsObj.Account__c = objAcc.Id;
                    smsObjects.add(smsObj);
			}
		}
	}*/
	//insert smsObjects;
}