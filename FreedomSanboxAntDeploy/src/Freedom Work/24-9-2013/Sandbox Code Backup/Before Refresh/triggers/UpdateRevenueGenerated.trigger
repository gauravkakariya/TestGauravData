trigger UpdateRevenueGenerated on Execution_Tracker__c (after insert, after update, after delete) 
{
    Map<Id,Id> entityIds = new Map<Id, Id>();
    List<Account> actList = new List<Account>();
    if(Trigger.isInsert || Trigger.isUpdate){
	    for(Execution_Tracker__c ext: Trigger.new) {
	        
	         entityIds.put(ext.Entity_Name__c, ext.Entity_Name__c);
	    }
    }
    else {
    	for(Integer i=0; i<Trigger.size; i++){
    		entityIds.put(Trigger.old[i].Entity_Name__c, Trigger.old[i].Entity_Name__c);
    	}
    }
     actList = [Select Id from Account where Id IN :entityIds.keySet()];
     update actList;

}