trigger OnEntityGlobalAssumptionUpdate on Entity_Global_Assumption__c (before update){
	OnEntityGlobalAssumptionUpdate.UpdateEntityGlobalAssumptionFlag(trigger.new,trigger.oldMap);
}