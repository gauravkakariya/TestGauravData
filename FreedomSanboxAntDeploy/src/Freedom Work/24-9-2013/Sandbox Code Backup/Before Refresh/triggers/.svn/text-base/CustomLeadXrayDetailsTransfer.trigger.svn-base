//Trigger Written By Aditi For Platform User related changes
//Date : 27/08/12
trigger CustomLeadXrayDetailsTransfer on X_Ray_Score_Card_Detail__c (before insert, before update) 
{
		/*List<X_Ray_Score_Card_Detail__c> lstXrayScore = trigger.new;
		
		//Platform_User_Lead__c 
		List<Lead_Platform_User__c> lstPlatformUser = [select Id from Lead_Platform_User__c where id = : lstXrayScore[0].Platform_User_Lead__c];
		system.debug('*******lstPlatformUser******'+lstPlatformUser);
		
		List<Lead> lstStandardLead = [select Id,Status,Platform_User_Lead__c from Lead where Platform_User_Lead__c =: lstPlatformUser[0].Id];
		system.debug('*******lstStandardLead******'+lstStandardLead);
		
		List<X_Ray_Score_Card_Detail__c> lstXRayScoreCardDetail = new List<X_Ray_Score_Card_Detail__c>();
		
		for(X_Ray_Score_Card_Detail__c objXRayScoreCardDetail :  lstXrayScore)
		{
			system.debug('SSSSSSSSSSSSSS lstStandardLead[0].id;:'+lstStandardLead[0].id);
			objXRayScoreCardDetail.Lead__c = lstStandardLead[0].id;
			lstXRayScoreCardDetail.add(objXRayScoreCardDetail);
		}*/
		system.debug('***in XrayScore****');
		List<X_Ray_Score_Card_Detail__c> lstXrayScore = trigger.new;
		system.debug('***lstXrayScore****'+lstXrayScore);
		Map<Id,X_Ray_Score_Card_Detail__c> MapXrayScore = new Map<Id,X_Ray_Score_Card_Detail__c>();
		Map<Id,Lead_Platform_User__c> MapPlatformUser = new Map<Id,Lead_Platform_User__c>();
		Map<Id,Lead> MapStandardLead = new Map<Id,Lead>();
		boolean flag1,flag2,flag3,flag4;
		for(X_Ray_Score_Card_Detail__c objXrayScore : lstXrayScore )
		{
			if(objXrayScore.Platform_User_Lead__c != null)
			{
				if(!(MapXrayScore.containsKey(objXrayScore.Platform_User_Lead__c)))
       			{
       					MapXrayScore.put(objXrayScore.Platform_User_Lead__c,objXrayScore);
       					flag1 = true;
       			}
			}
			else
			{
				if(!(MapXrayScore.containsKey(objXrayScore.Lead__c)))
       			{
       					MapXrayScore.put(objXrayScore.Lead__c,objXrayScore);
       					flag1 = false;
       			}
			}
		}
		List<Lead_Platform_User__c> lstPlatformUser = new List<Lead_Platform_User__c>();
		List<Lead> lstStandardLead = new List<Lead>();
		Set<String> StdSet = new Set<String>();
		system.debug('flag ==1:":'+flag1);
		
		if(flag1)
		{
		 	lstPlatformUser = [select Id from Lead_Platform_User__c where id in : MapXrayScore.keySet()];
			system.debug('*******lstPlatformUser******'+lstPlatformUser);
			for(Lead_Platform_User__c objPlatformUser : lstPlatformUser )
			{
				if(!(MapPlatformUser.containsKey(objPlatformUser.Id)))
       			{
					MapPlatformUser.put(objPlatformUser.Id,objPlatformUser);
					flag2 = true;
       			}
			}
		
		}
		else
		{
		 	lstStandardLead = [select Id,Status,Platform_User_Lead__c from Lead where id  in : MapXrayScore.keySet()];
		 	if(lstStandardLead.size() > 0)
			{
		 		for(Lead objStandardLead : lstStandardLead )
				{
					if(objStandardLead.Platform_User_Lead__c != null )
					{
						if(!(MapStandardLead.containsKey(objStandardLead.Platform_User_Lead__c)))
	       				{
							MapStandardLead.put(objStandardLead.Id,objStandardLead);
							StdSet.add(objStandardLead.Platform_User_Lead__c);
							flag2 = false;
	       				}
					}
					else
					{
						system.debug('in else : to set flag=2');
						flag2 = false;
					}
				}
			}
			else
			{
				flag2 = false;
			}
		 	
		}
		
		system.debug('flag ==2:":'+flag2);
		if(flag2)
		{
			lstStandardLead = [select Id,Status,Platform_User_Lead__c from Lead where Platform_User_Lead__c  in : MapPlatformUser.keySet()];
			system.debug('*******lstStandardLead******'+lstStandardLead);
			
			for(Lead objStandardLead : lstStandardLead )
			{
					if(!(MapStandardLead.containsKey(objStandardLead.Platform_User_Lead__c)))
	       			{
						MapStandardLead.put(objStandardLead.Platform_User_Lead__c,objStandardLead);
						flag3 = true;
	       			}
			}
		}
		else
		{
			system.debug('in else : of flag 2'+StdSet);
			system.debug('in if : to set flag=3');
			lstPlatformUser = [select Id from Lead_Platform_User__c where id in : StdSet];
		    system.debug('*******lstPlatformUser******'+lstPlatformUser);
			if(lstPlatformUser.size() > 0)
			{
				for(Lead_Platform_User__c objPlatformUser : lstPlatformUser )
				{
					if(!(MapPlatformUser.containsKey(objPlatformUser.Id)))
   					{
						MapPlatformUser.put(objPlatformUser.Id,objPlatformUser);
						flag3 = false; 
   					}
				}
			}
			else
			{
				system.debug('***in else of Flag 3 : StdSet == null*******');
				flag3 = false; 
			}
		}
		system.debug('flag ==3:":'+flag3);
		List<X_Ray_Score_Card_Detail__c> lstXRayScoreCardDetail = new List<X_Ray_Score_Card_Detail__c>();
		Lead_Platform_User__c objCustomLead = new Lead_Platform_User__c();
		Lead objStdLead = new Lead();
		system.debug('LLLLLLLLLLLLLLLLLLlstXrayScore":'+lstXrayScore+'flag3flag3flag3:::'+flag3);
		for(X_Ray_Score_Card_Detail__c objXRayScoreCardDetailhj :  lstXrayScore)
		{
			if(flag3)
			{
				system.debug('******in if*****'+objXRayScoreCardDetailhj.Platform_User_Lead__c);
				
				if(MapXrayScore.containsKey(objXRayScoreCardDetailhj.Platform_User_Lead__c))
				{
					objCustomLead = MapPlatformUser.get(objXRayScoreCardDetailhj.Platform_User_Lead__c);
					system.debug('******in if :objCustomLead*****'+objCustomLead);
					if(objCustomLead != null)
					{
							
						if(MapStandardLead.containsKey(objCustomLead.Id))
						{
							objStdLead = MapStandardLead.get(objCustomLead.Id);
							if(objStdLead != null)
							{
								objXRayScoreCardDetailhj.Lead__c = objStdLead.Id;
								lstXRayScoreCardDetail.add(objXRayScoreCardDetailhj);
							}
						}
					}
				}
			}
			else
			{
			system.debug('******in else : objXRayScoreCardDetailhj****'+objXRayScoreCardDetailhj.Lead__c);
				if(MapXrayScore.containsKey(objXRayScoreCardDetailhj.Lead__c))
				{
					//objCustomLead = MapPlatformUser.get(objXRayScoreCardDetailhj.Id);
					if(MapStandardLead.containsKey(objXRayScoreCardDetailhj.Lead__c))
						{
							objStdLead = MapStandardLead.get(objXRayScoreCardDetailhj.Lead__c);
						}
					system.debug('******in else : objStdLead****'+objStdLead);
					if(objStdLead != null)
					{
						
						if(MapPlatformUser.containsKey(objStdLead.Platform_User_Lead__c))
						{
							objCustomLead = MapPlatformUser.get(objStdLead.Platform_User_Lead__c);
							if(objCustomLead != null)
							{
								objXRayScoreCardDetailhj.Platform_User_Lead__c = objCustomLead.Id;
								lstXRayScoreCardDetail.add(objXRayScoreCardDetailhj);
								system.debug('******lstXRayScoreCardDetail****'+lstXRayScoreCardDetail);
							}
						}
					}
				}
			}
		}
	 
}