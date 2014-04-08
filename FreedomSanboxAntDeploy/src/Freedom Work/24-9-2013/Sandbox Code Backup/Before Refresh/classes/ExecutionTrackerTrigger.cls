/*
	Code Change Log
	==============================================
	Date			Created By 			Summary 
	8-April-2013  Niket Chandane		Base class for All Execution_Tracker trigger.
*/
public virtual class ExecutionTrackerTrigger 
{
 	public static final Schema.DescribeSObjectResult DESCRIBE_RESULT = Execution_Tracker__c.SobjectType.getDescribe();
    public static final Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    
    public Execution_Tracker__c[] Execution_TrackerOldList { set; get; }
    public Execution_Tracker__c[] Execution_TrackerNewList { set; get; }
    public Map<Id, Execution_Tracker__c> Execution_TrackerOldListMap { set; get; }
    public Map<Id, Execution_Tracker__c> Execution_TrackerNewListMap { set; get; }
    
    public ExecutionTrackerTrigger(Execution_Tracker__c[] Execution_TrackerOldList, Execution_Tracker__c[] Execution_TrackerNewList) {
       system.debug('*****Execution_TrackerOldList***'+Execution_TrackerOldList);
        system.debug('*****Execution_TrackerNewList***'+Execution_TrackerNewList);
        this.Execution_TrackerNewList = Execution_TrackerNewList == null ? new Execution_Tracker__c[] {} : Execution_TrackerNewList.clone();
        this.Execution_TrackerOldList = Execution_TrackerOldList == null ? new Execution_Tracker__c[] {} : Execution_TrackerOldList.clone();
        this.Execution_TrackerOldListMap = new Map<Id, Execution_Tracker__c> {};
        this.Execution_TrackerNewListMap = new Map<Id, Execution_Tracker__c> {};
        
        // Build the old map
        for(Execution_Tracker__c Execution_TrackerOld : this.Execution_TrackerOldList) {
            if (Execution_TrackerOld.Id != null) {
                Execution_TrackerOldListMap.put(Execution_TrackerOld.Id, Execution_TrackerOld);
            }
        }
        
        //Building the new map
        for(Execution_Tracker__c Execution_TrackerNew : this.Execution_TrackerNewList){
        	if(Execution_TrackerNew.id != null){
        		Execution_TrackerNewListMap.put(Execution_TrackerNew.id,Execution_TrackerNew);
        	}
        }
    }
    
    public virtual Boolean executable(Execution_Tracker__c Execution_TrackerOld, Execution_Tracker__c Execution_TrackerNew) {
        return true; 
    }
    
    public virtual void execute() {
        
        Execution_Tracker__c[] Execution_TrackerUpdateableList = new Execution_Tracker__c[] {};
        for(Execution_Tracker__c Execution_TrackerNew : Execution_TrackerNewList) {
            Execution_Tracker__c Execution_TrackerOld = Execution_TrackerOldListMap.get(Execution_TrackerNew.Id);
            Execution_TrackerOld = Execution_TrackerOld == null ? new Execution_Tracker__c() : Execution_TrackerOld;
            
            if (executable(Execution_TrackerOld, Execution_TrackerNew)) {
                Execution_TrackerUpdateableList.add(Execution_TrackerNew);
            }
        }
       
        if (Execution_TrackerUpdateableList.size() != 0) {
            execute(Execution_TrackerUpdateableList, trigger.IsAfter);
        }
    }
    
    public virtual void execute(Execution_Tracker__c[] Execution_TrackerList, Boolean forceUpdate) {
        // do nothing here
    }
    
    @IsTest
    public static void testCoverage() 
    {
        new ExecutionTrackerTrigger(null, null).execute();
        new ExecutionTrackerTrigger(null, new Execution_Tracker__c[] { new Execution_Tracker__c() }).execute();
    }
}