public with sharing class PartnerLeadShare 
{
	public void onAfterUpdate(List<Lead> lstLead)
	{
		//Share Business partner entities with Channel manger of Entity(Gold partenr license holder Manager)
		List<LeadShare> lstLeadShare = new List<LeadShare>();
		Profile objProfile = [Select Id, UserLicense.Name, UserLicenseId From Profile where UserLicense.Name='Gold Partner' and Name= 'Gold Partner'];
		Map<Id,User> mapIdToUser = new Map<Id,User>([select Id, ManagerId from User where  ProfileId =: objProfile.Id]);
		Map<Id, Id> mapLeadIdToUserId = new Map<Id, Id>();
		
		for(Lead objLead : lstLead)
		{
			mapLeadIdToUserId.put(objLead.Id, objLead.OwnerId);
		}
		
		for(Lead objAcc : lstLead)
		{
			Id userId = mapLeadIdToUserId.get(objAcc.Id);
			if(mapIdToUser.containsKey(userId))
			{
				LeadShare objShare = new LeadShare ();
				objShare.LeadAccessLevel = 'edit';
				objShare.UserOrGroupId = mapIdToUser.get(userId).ManagerId;
				objShare.LeadId = objAcc.Id;
				
				lstLeadShare.add(objShare);
			}
		}
		insert  lstLeadShare;
	}
}