trigger SendRenewalSMS on Account (before update) 
{
	///*Setty:NewCode
		///*Setty:NewCode
	for( Account objNewAcc : trigger.new){
		Account objOldAcc = trigger.oldMap.get(objNewAcc.Id);
		if(objOldAcc.Renewal_SMS_Sent__c != objNewAcc.Renewal_SMS_Sent__c){
			AccountHandler.SendRenewalSMS(trigger.new, trigger.oldMap);
			break;
		}
	}
//*/	
}