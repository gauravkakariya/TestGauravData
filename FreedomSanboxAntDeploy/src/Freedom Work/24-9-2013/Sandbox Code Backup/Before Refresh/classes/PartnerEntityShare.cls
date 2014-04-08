public with sharing class PartnerEntityShare 
{
	/*
	public void onAfterUpdate(List<Account> lstAccount)
	{
		//Share Business partner entities with Channel manger of Entity(Gold partenr license holder Manager)
		List<AccountShare> lstAccShare = new List<AccountShare>();
		Profile objProfile = [Select Id, UserLicense.Name, UserLicenseId From Profile where UserLicense.Name='Gold Partner' and Name= 'Gold Partner'];
		Map<Id,User> mapIdToUser = new Map<Id,User>([select Id, ManagerId from User where  ProfileId =: objProfile.Id]);
		Map<Id, Id> mapAccountIdToUserId = new Map<Id, Id>();
		
		for(Account objAccount : lstAccount)
		{
			mapAccountIdToUserId.put(objAccount.Id, objAccount.OwnerId);
		}
		
		for(Account objAcc : lstAccount)
		{
			Id userId = mapAccountIdToUserId.get(objAcc.Id);
			if(mapIdToUser.containsKey(userId))
			{
				AccountShare objShare = new AccountShare ();
				objShare.AccountAccessLevel = 'edit';
				objShare.UserOrGroupId = mapIdToUser.get(userId).ManagerId;
				objShare.AccountId = objAcc.Id;
				objShare.OpportunityAccessLevel = 'edit';
				lstAccShare.add(objShare);
			}
		}
		insert  lstAccShare;
	} 
	*/
}