global class UpdateLeadOwnerBatch implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		
		String query = 'Select Id,Name,Referred_By__c,OwnerId From Lead Where Lead.LeadSource = \'Web-XRay\'';
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		
		List<Lead> leadList = (List<Lead>)scope;
		system.debug('****leadList'+leadList);
		Map<Id, Id> entityMap = new map<Id, Id>();
		Map<String, Id> userMap = new map<String, Id>();
		List<User> userList = [select email,Id from User];
		List<Lead> leadToUpdate = new List<Lead>();
		Map<String, Id> virtualParnterEntityMap = new map<String, Id>();
		
		for(User user: userList){
			userMap.put(user.Email,user.Id);
		}
		
		List<Account> accountList = [select OwnerId, Email_ID__c,id from Account where RecordType.Name ='General' AND Related_To__c = 'Virtual Partner'];
		for(Account account : accountList){
			
			entityMap.put(account.OwnerId, account.Id);
			virtualParnterEntityMap.put(account.Email_ID__c, account.OwnerId);
		}
		
		for(Lead lead: leadList ){
			if(lead.OwnerId != userMap.get(lead.Referred_By__c)){
				if(userMap.containsKey(lead.Referred_By__c) || entityMap.containsKey(userMap.get(lead.Referred_By__c))){
					system.debug('****1');
					lead.OwnerId = userMap.get(lead.Referred_By__c);
					
				}	
				else if(virtualParnterEntityMap.containsKey(lead.Referred_By__c)){
					lead.OwnerId = virtualParnterEntityMap.get(lead.Referred_By__c);
				}
			}	
			leadToUpdate.add(lead);		
		}
		system.debug('***leadToUpdate'+leadToUpdate);
	}
	
	global void finish(Database.BatchableContext BC){
       
    }

}