trigger SendDiscontinuationSMS on Account (before update)
{
	///*Setty:NewCode
	for( Account objNewAcc : trigger.new){
		Account objOldAcc = trigger.oldMap.get(objNewAcc.Id);
		if(objOldAcc.Discontinuation_SMS_Sent__c == null || objNewAcc.Discontinuation_SMS_Sent__c == null) 
		continue;
		if(objOldAcc.Discontinuation_SMS_Sent__c == false && objNewAcc.Discontinuation_SMS_Sent__c == true){
			AccountHandler.SendDiscontinuationSMS(trigger.new, trigger.oldMap);
			break;
		}
	}
}