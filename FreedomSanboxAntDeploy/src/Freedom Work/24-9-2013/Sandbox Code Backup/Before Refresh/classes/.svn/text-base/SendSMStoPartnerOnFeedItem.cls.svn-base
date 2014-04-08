public class SendSMStoPartnerOnFeedItem extends FeedItemTrigger
{
	public static string ACCOUNT_PREFIX = '001';
	public static string LEAD_PREFIX = '00Q';
	public static string LEAD = 'Chatter Comment Lead';
	public static string ACCOUNT = 'Chatter Comment';
	
	// Template Id = a0Z2000000BEQ6c
	
	public SendSMStoPartnerOnFeedItem (List<FeedItem> lstOldFeedItem,List<FeedItem> lstNewFeedItem){
		super(lstOldFeedItem,lstNewFeedItem);
	}
	
	public override void execute()
	{
		FeedCommentTrigger__c objFeedItemTrigger = FeedCommentTrigger__c.getInstance('FeedCommentTrigger');
		
		if(objFeedItemTrigger == null || !objFeedItemTrigger.SendSMStoPartnerOnFeedItem__c)
		return;
		
		List<smagicbasic__smsMagic__c> LstSmsObjects = new List<smagicbasic__smsMagic__c>();
		Map<ID,FeedItem> MapParentIdOfFeedItem = new Map<ID,FeedItem>();
		Map<Id,Account> MapAccount;
		Map<Id,Lead> MapLead;
		Map<Id,User> MapUser;
		Set<Id> SetCreatedBy = new Set<Id>();
		Map<String,smagicbasic__SMS_Template__c> MapTemplate = new Map<String,smagicbasic__SMS_Template__c>(); 
		
		for(FeedItem objFeedItem : FeedItemNewList){
			if(objFeedItem.Type != FeedItemTrigger.TEXTPOST 
			|| objFeedItem.Body == '' || objFeedItem.Body == NULL
			|| ((!String.valueOf(objFeedItem.ParentId).startsWith(ACCOUNT_PREFIX)) 
			&& (!String.valueOf(objFeedItem.ParentId).startsWith(LEAD_PREFIX))))
				continue;
			
			MapParentIdOfFeedItem.put(objFeedItem.ParentId,objFeedItem);
			SetCreatedBy.add(objFeedItem.createdById);
		}
		
		MapUser = new Map<Id,User>([Select Id,name from User where Id in : SetCreatedBy]);
		
		System.debug('MapParentIdOfFeedItem ----->'+MapParentIdOfFeedItem);
		
		// Virtual_Partner__c = 
		if(MapParentIdOfFeedItem.IsEmpty()) return;
		
		MapAccount = new Map<Id,Account>([Select Name,Id,Virtual_Partner__r.Phone, Virtual_Partner__r.Name,Virtual_Partner__r.Alternate_Mobile__c,Virtual_Partner__r.PersonMobilePhone,Virtual_Partner__c,PersonMobilePhone,Owner.Name,Owner.ContactId,Owner.Contact.Account.Id,Owner.Contact.Account.PersonMobilePhone,Owner.Contact.Account.Name from Account where Id In : MapParentIdOfFeedItem.keySet()]);
		System.debug('MapAccount ----->'+MapAccount);
		
		//Owner.Contact.Id,Owner.Contact.Account.Id,Owner.Contact.Account.PersonMobilePhone,Owner.Contact.Account.Name 
		MapLead = new Map<Id,Lead>([Select Name,Id,Virtual_Partner__r.Alternate_Mobile__c,Virtual_Partner__r.Id,Virtual_Partner__r.Name,Virtual_Partner__r.PersonMobilePhone,Virtual_Partner__r.Phone,Virtual_Partner__c,Owner.Name from Lead where Id In : MapParentIdOfFeedItem.keySet()]); 
		
		if(MapAccount.IsEmpty() && MapLead.IsEmpty()) return;
		
		List<smagicbasic__SMS_Template__c> template = [select Id,smagicbasic__Text__c,smagicbasic__Name__c from smagicbasic__SMS_Template__c where (smagicbasic__Name__c = 'Chatter Comment' or smagicbasic__Name__c = 'Chatter Comment Lead')]; //and (smagicbasic__ObjectName__c = 'Account' or smagicbasic__ObjectName__c = 'Lead'
		
		for(smagicbasic__SMS_Template__c objTemp : template){
			MapTemplate.put(objTemp.smagicbasic__Name__c,objTemp);
		}
				
		System.debug('template ----->'+template);
		
		for(String AccId : MapAccount.KeySet())
		{
			System.debug('MapParentIdOfFeedItem.ContainsKey(AccId) ----->'+MapParentIdOfFeedItem.ContainsKey(AccId));
			if(!MapParentIdOfFeedItem.ContainsKey(AccId))
			continue;
			
			if(MapAccount.get(AccId).Virtual_Partner__c == null && MapAccount.get(AccId).Owner.ContactId == null)
			continue;
			
			System.debug('============== ----->'+(MapAccount.get(AccId).Virtual_Partner__c == null && MapAccount.get(AccId).Owner.ContactId == null));
			
			if(MapAccount.get(AccId).Virtual_Partner__c != null) 
			{
				if(MapAccount.get(AccId).Virtual_Partner__r.PersonMobilePhone == null 
					&& MapAccount.get(AccId).Virtual_Partner__r.Alternate_Mobile__c == null) continue;
				
				Account objAcc = new Account(Id = MapAccount.get(AccId).Id);
				objAcc.Name = MapAccount.get(AccId).Name;
				objAcc.PersonMobilePhone = (MapAccount.get(AccId).Virtual_Partner__r.Phone != null) ? (MapAccount.get(AccId).Virtual_Partner__r.Phone) 
											: MapAccount.get(AccId).Virtual_Partner__r.Alternate_Mobile__c;
				
				if(objAcc.PersonMobilePhone == null)
				continue;
											
				String strOwnerName = MapUser.get(MapParentIdOfFeedItem.get(AccId).createdById).Name;//MapAccount.get(AccId).Owner.Name;
				LstSmsObjects.add(sendSMStoPartner(MapTemplate.get(ACCOUNT),objAcc,MapParentIdOfFeedItem.get(AccId),strOwnerName));
			}
		}
		
		for(String LeadId : MapLead.KeySet())
		{
			System.debug('MapParentIdOfFeedItem.ContainsKey(LeadId) ----->'+MapParentIdOfFeedItem.ContainsKey(LeadId));
			if(!MapParentIdOfFeedItem.ContainsKey(LeadId))
			continue;
			
			if(MapLead.get(LeadId).Virtual_Partner__c == null)
			continue;
			
			System.debug('============== ----->'+(MapLead.get(LeadId).Virtual_Partner__c == null));
			
			if(MapLead.get(LeadId).Virtual_Partner__c != null) 
			{
				if(MapLead.get(LeadId).Virtual_Partner__r.Phone == null 
					&& MapLead.get(LeadId).Virtual_Partner__r.Alternate_Mobile__c == null) continue;
				
				Lead objLead = new Lead(Id = MapLead.get(LeadId).Id);
				String LeadName = MapLead.get(LeadId).Name;
				objLead.MobilePhone = (MapLead.get(LeadId).Virtual_Partner__r.Phone != null) ? (MapLead.get(LeadId).Virtual_Partner__r.Phone) 
											: MapLead.get(LeadId).Virtual_Partner__r.Alternate_Mobile__c;
				
				if(objLead.MobilePhone == null)
				continue;
											
				String strOwnerName = MapUser.get(MapParentIdOfFeedItem.get(LeadId).createdById).Name;//MapLead.get(LeadId).Owner.Name;
				LstSmsObjects.add(sendSMStoPartnerLead(MapTemplate.get(LEAD),objLead,MapParentIdOfFeedItem.get(LeadId),strOwnerName,LeadName));
			}
		}
		
		System.debug('LstSmsObjects -------------->'+LstSmsObjects);
		
		if(!LstSmsObjects.IsEmpty())
			insert LstSmsObjects;
		
	}
	
	public smagicbasic__smsMagic__c sendSMStoPartner(smagicbasic__SMS_Template__c objSMSTemplate,Account objAcc,FeedItem objFeedItem,String strOwnerName)
	{
		smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
		String strSMSTempalatText;
		
		smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(objSMSTemplate.smagicbasic__Text__c);
        TEngine.getFieldMap(objAcc);
        strSMSTempalatText = TEngine.getReplacedTextForObject(objAcc, 0);
        
        smsObj.smagicbasic__PhoneNumber__c = objAcc.PersonMobilePhone;
        
        smsObj.smagicbasic__SMSText__c = strSMSTempalatText +' - '+ objFeedItem.Body +' - '+ strOwnerName;
        smsObj.smagicbasic__senderId__c = 'Ffreedom';
        smsObj.smagicbasic__Name__c = objAcc.Name;
        smsObj.Account__c = objAcc.Id;
        System.debug('smsObj ========================================>'+smsObj);
        return smsObj;
	}
	
	public smagicbasic__smsMagic__c sendSMStoPartnerLead(smagicbasic__SMS_Template__c objSMSTemplate,Lead objLead,FeedItem objFeedItem,String strOwnerName,String LeadName)
	{
		smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
		String strSMSTempalatText;
		
		smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(objSMSTemplate.smagicbasic__Text__c);
        TEngine.getFieldMap(objLead);
        strSMSTempalatText = TEngine.getReplacedTextForObject(objLead, 0);
        
        smsObj.smagicbasic__PhoneNumber__c = objLead.MobilePhone;
        
        smsObj.smagicbasic__SMSText__c = LeadName + strSMSTempalatText +' - '+ objFeedItem.Body +' - '+ strOwnerName;
        smsObj.smagicbasic__senderId__c = 'Ffreedom';
        smsObj.smagicbasic__Name__c = LeadName;
        smsObj.smagicbasic__Lead__c = objLead.Id;
        System.debug('sendSMStoPartnerLead ========================================>'+smsObj);
        return smsObj;
	}
}