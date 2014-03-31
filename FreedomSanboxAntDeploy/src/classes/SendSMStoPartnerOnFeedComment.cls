public without sharing class SendSMStoPartnerOnFeedComment extends FeedCommentTrigger{
	
	public static string ACCOUNT_PREFIX = '001';
	public static string LEAD_PREFIX = '00Q';
	public static string LEAD = 'Chatter Comment Lead';
	public static string ACCOUNT = 'Chatter Comment';
	// Template Id = a0Z2000000BEQ6c
	
	public SendSMStoPartnerOnFeedComment(List<FeedComment> lstOldFeedComment,List<FeedComment> lstNewFeedComment){
		super(lstOldFeedComment,lstNewFeedComment);
	}
	
	public override void execute()
	{
		FeedCommentTrigger__c objFeedCommentTrigger = FeedCommentTrigger__c.getInstance('FeedCommentTrigger');
		
		System.debug('objFeedCommentTrigger.SendSMStoPartnerOnFeedComment__c ----->'+objFeedCommentTrigger.SendSMStoPartnerOnFeedComment__c);
		
		if(objFeedCommentTrigger == null || !objFeedCommentTrigger.SendSMStoPartnerOnFeedComment__c)
		return;
		
		List<smagicbasic__smsMagic__c> LstSmsObjects = new List<smagicbasic__smsMagic__c>();
		Map<String,smagicbasic__SMS_Template__c> MapTemplate = new Map<String,smagicbasic__SMS_Template__c>();
		Map<ID,FeedComment> MapParentIdOfFeedComment = new Map<ID,FeedComment>();
		Map<Id,Account> MapAccount;
		Map<Id,Lead> MapLead;
		Map<Id,User> MapUser;
		Set<Id> SetCreatedBy = new Set<Id>();
		
		for(FeedComment objFeedComment : feedCommentNewList){
			if(objFeedComment.CommentType != FeedCommentTrigger.COMMENTTYPE 
			|| objFeedComment.CommentBody == '' || objFeedComment.CommentBody == NULL
			|| (!String.valueOf(objFeedComment.ParentId).startsWith(ACCOUNT_PREFIX))
			 && (!String.valueOf(objFeedComment.ParentId).startsWith(LEAD_PREFIX)))
				continue;
			
			MapParentIdOfFeedComment.put(objFeedComment.ParentId,objFeedComment);
			SetCreatedBy.add(objFeedComment.createdById);
		}
		
		MapUser = new Map<Id,User>([Select Id,name from User where Id in : SetCreatedBy]);
		
		System.debug('MapParentIdOfFeedComment ----->'+MapParentIdOfFeedComment);
		
		// Virtual_Partner__c = 
		if(MapParentIdOfFeedComment.IsEmpty()) return;
		
		MapAccount = new Map<Id,Account>([Select Name,Virtual_Partner__r.Phone,Id,Virtual_Partner__r.Name,Virtual_Partner__r.Alternate_Mobile__c,Virtual_Partner__r.PersonMobilePhone,Virtual_Partner__c,PersonMobilePhone,Owner.Name,Owner.ContactId,Owner.Contact.Account.Id,Owner.Contact.Account.PersonMobilePhone,Owner.Contact.Account.Name from Account where Id In : MapParentIdOfFeedComment.keySet()]);
		System.debug('MapAccount ----->'+MapAccount);
		
		MapLead = new Map<Id,Lead>([Select Name,Id,Virtual_Partner__r.Phone,Virtual_Partner__r.Alternate_Mobile__c,Virtual_Partner__r.Id,Virtual_Partner__r.Name,Virtual_Partner__r.PersonMobilePhone,Virtual_Partner__c,Owner.Name from Lead where Id In : MapParentIdOfFeedComment.keySet()]);
		
		if(MapAccount.IsEmpty() && MapLead.IsEmpty()) return;
		
		List<smagicbasic__SMS_Template__c> template = [select Id,smagicbasic__Text__c,smagicbasic__Name__c from smagicbasic__SMS_Template__c where (smagicbasic__Name__c = 'Chatter Comment' or smagicbasic__Name__c = 'Chatter Comment Lead')]; //and (smagicbasic__ObjectName__c = 'Account' or smagicbasic__ObjectName__c = 'Lead'
		
		for(smagicbasic__SMS_Template__c objTemp : template){
			MapTemplate.put(objTemp.smagicbasic__Name__c,objTemp);
		}
		
		System.debug('template ----->'+template);
		
		for(String AccId : MapAccount.KeySet())
		{
			System.debug('MapParentIdOfFeedComment.ContainsKey(AccId) ----->'+MapParentIdOfFeedComment.ContainsKey(AccId));
			if(!MapParentIdOfFeedComment.ContainsKey(AccId))
			continue;
			
			if(MapAccount.get(AccId).Virtual_Partner__c == null && MapAccount.get(AccId).Owner.ContactId == null)
			continue;
			
			System.debug('============== ----->'+(MapAccount.get(AccId).Virtual_Partner__c == null && MapAccount.get(AccId).Owner.ContactId == null));
			if(MapAccount.get(AccId).Virtual_Partner__c != null) 
			{
				if(MapAccount.get(AccId).Virtual_Partner__r.Phone == null 
					&& MapAccount.get(AccId).Virtual_Partner__r.Alternate_Mobile__c == null) continue;
				
				Account objAcc = new Account(Id = MapAccount.get(AccId).Id);
				objAcc.Name = MapAccount.get(AccId).Name;
				objAcc.PersonMobilePhone = (MapAccount.get(AccId).Virtual_Partner__r.Phone != null) ? (MapAccount.get(AccId).Virtual_Partner__r.Phone) 
											: MapAccount.get(AccId).Virtual_Partner__r.Alternate_Mobile__c;
				
				if(objAcc.PersonMobilePhone == null)
				continue;
											
				String strOwnerName = MapUser.get(MapParentIdOfFeedComment.get(AccId).createdById).Name;//MapAccount.get(AccId).Owner.Name;
				LstSmsObjects.add(sendSMStoPartner(template[0],objAcc,MapParentIdOfFeedComment.get(AccId),strOwnerName));
			}
		}
		
		for(String LeadId : MapLead.KeySet())
		{
			System.debug('MapParentIdOfFeedComment.ContainsKey(LeadId) ----->'+MapParentIdOfFeedComment.ContainsKey(LeadId));
			if(!MapParentIdOfFeedComment.ContainsKey(LeadId))
			continue;
			
			System.debug('============== ----->'+(MapLead.get(LeadId).Virtual_Partner__c == null));
			
			if(MapLead.get(LeadId).Virtual_Partner__c == null)
			continue;
			
			if(MapLead.get(LeadId).Virtual_Partner__c != null) 
			{
				if(MapLead.get(LeadId).Virtual_Partner__r.PersonMobilePhone == null 
					&& MapLead.get(LeadId).Virtual_Partner__r.Alternate_Mobile__c == null) continue;
				
				Lead objLead = new Lead(Id = MapLead.get(LeadId).Id);
				String LeadName = MapLead.get(LeadId).Name;
				objLead.MobilePhone = (MapLead.get(LeadId).Virtual_Partner__r.Phone != null) ? (MapLead.get(LeadId).Virtual_Partner__r.Phone) 
											: MapLead.get(LeadId).Virtual_Partner__r.Alternate_Mobile__c;
				
				if(objLead.MobilePhone == null)
				continue;
											
				String strOwnerName = MapUser.get(MapParentIdOfFeedComment.get(LeadId).createdById).Name;//MapLead.get(LeadId).Owner.Name;
				LstSmsObjects.add(sendSMStoPartnerLead(MapTemplate.get(LEAD),objLead,MapParentIdOfFeedComment.get(LeadId),strOwnerName,LeadName));
			}
		}
		
		System.debug('LstSmsObjects -------------->'+LstSmsObjects);
		
		if(!LstSmsObjects.IsEmpty())
			insert LstSmsObjects;
	}
	
	public smagicbasic__smsMagic__c sendSMStoPartner(smagicbasic__SMS_Template__c objSMSTemplate,Account objAcc,FeedComment objFeedComment,String strOwnerName)
	{
		smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
		String strSMSTempalatText;
		
		smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(objSMSTemplate.smagicbasic__Text__c);
        TEngine.getFieldMap(objAcc);
        strSMSTempalatText = TEngine.getReplacedTextForObject(objAcc, 0);
        
        smsObj.smagicbasic__PhoneNumber__c = objAcc.PersonMobilePhone;
        
        smsObj.smagicbasic__SMSText__c = strSMSTempalatText +' - '+ objFeedComment.CommentBody +' - '+ strOwnerName;
        smsObj.smagicbasic__senderId__c = 'Ffreedom';
        smsObj.smagicbasic__Name__c = objAcc.Name;
        smsObj.Account__c = objAcc.Id;
        System.debug('smsObj ========================================>'+smsObj);
        return smsObj;
	}
	
	public smagicbasic__smsMagic__c sendSMStoPartnerLead(smagicbasic__SMS_Template__c objSMSTemplate,Lead objLead,FeedComment objFeedComment,String strOwnerName,String LeadName)
	{
		smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
		String strSMSTempalatText;
		
		smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(objSMSTemplate.smagicbasic__Text__c);
        TEngine.getFieldMap(objLead);
        strSMSTempalatText = TEngine.getReplacedTextForObject(objLead, 0);
        
        smsObj.smagicbasic__PhoneNumber__c = objLead.MobilePhone;
        
        smsObj.smagicbasic__SMSText__c = strSMSTempalatText + objFeedComment.CommentBody +' - '+ strOwnerName;
        smsObj.smagicbasic__senderId__c = 'Ffreedom';
        smsObj.smagicbasic__Name__c = LeadName;
        smsObj.smagicbasic__Lead__c = objLead.Id;
        System.debug('sendSMStoPartnerLead ========================================>'+smsObj);
        return smsObj;
	}
	
	/*
	if(MapAccount.get(AccId).Owner.ContactId != null)
			{
				if(MapAccount.get(AccId).Owner.Contact.Account.PersonMobilePhone == null) continue;
				
				Account objAcc = new Account(Id = MapAccount.get(AccId).Id);
				objAcc.Name = MapAccount.get(AccId).Name;
				objAcc.PersonMobilePhone = MapAccount.get(AccId).Owner.Contact.Account.PersonMobilePhone;
				String strOwnerName = MapUser.get(MapParentIdOfFeedComment.get(AccId).createdById).Name;//MapAccount.get(AccId).Owner.Name;
				
				LstSmsObjects.add(sendSMStoPartner(template[0],objAcc,MapParentIdOfFeedComment.get(AccId),strOwnerName));
			}
			else
	*/
}