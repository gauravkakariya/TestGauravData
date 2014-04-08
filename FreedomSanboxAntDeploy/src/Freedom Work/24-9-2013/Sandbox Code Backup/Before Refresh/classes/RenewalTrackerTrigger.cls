/*
	Code Change Log
	==============================================
	Date			Created By 			Summary 
	9-April-2013  Aditi Satpute		Base class for All Renewal_Tracker trigger.
*/
public virtual class RenewalTrackerTrigger 
{
 	public static final Schema.DescribeSObjectResult DESCRIBE_RESULT = Renewal_Tracker__c.SobjectType.getDescribe();
    public static final Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    
    public Renewal_Tracker__c[] Renewal_TrackerOldList { set; get; }
    public Renewal_Tracker__c[] Renewal_TrackerNewList { set; get; }
    public Map<Id, Renewal_Tracker__c> Renewal_TrackerOldListMap { set; get; }
    public Map<Id, Renewal_Tracker__c> Renewal_TrackerNewListMap { set; get; }
    
    public RenewalTrackerTrigger(Renewal_Tracker__c[] Renewal_TrackerOldList, Renewal_Tracker__c[] Renewal_TrackerNewList) {
        this.Renewal_TrackerNewList = Renewal_TrackerNewList == null ? new Renewal_Tracker__c[] {} : Renewal_TrackerNewList.clone();
        this.Renewal_TrackerOldList = Renewal_TrackerOldList == null ? new Renewal_Tracker__c[] {} : Renewal_TrackerOldList.clone();
        this.Renewal_TrackerOldListMap = new Map<Id, Renewal_Tracker__c> {};
        this.Renewal_TrackerNewListMap = new Map<Id, Renewal_Tracker__c> {};
        
        // Build the old map
        for(Renewal_Tracker__c Renewal_TrackerOld : this.Renewal_TrackerOldList) {
            if (Renewal_TrackerOld.Id != null) {
                Renewal_TrackerOldListMap.put(Renewal_TrackerOld.Id, Renewal_TrackerOld);
            }
        }
        
        //Building the new map
        for(Renewal_Tracker__c Renewal_TrackerNew : this.Renewal_TrackerNewList){
        	if(Renewal_TrackerNew.id != null){
        		Renewal_TrackerNewListMap.put(Renewal_TrackerNew.id,Renewal_TrackerNew);
        	}
        }
    }
    
    public virtual Boolean executable(Renewal_Tracker__c Renewal_TrackerOld, Renewal_Tracker__c Renewal_TrackerNew) {
        return true; 
    }
    
    public virtual void execute() {
        
        Renewal_Tracker__c[] Renewal_TrackerUpdateableList = new Renewal_Tracker__c[] {};
        for(Renewal_Tracker__c Renewal_TrackerNew : Renewal_TrackerNewList) {
            Renewal_Tracker__c Renewal_TrackerOld = Renewal_TrackerOldListMap.get(Renewal_TrackerNew.Id);
            Renewal_TrackerOld = Renewal_TrackerOld == null ? new Renewal_Tracker__c() : Renewal_TrackerOld;
            
            if (executable(Renewal_TrackerOld, Renewal_TrackerNew)) {
                Renewal_TrackerUpdateableList.add(Renewal_TrackerNew);
            }
        }
       
        if (Renewal_TrackerUpdateableList.size() != 0) {
            execute(Renewal_TrackerUpdateableList, trigger.IsAfter);
        }
    }
    
    public virtual void execute(Renewal_Tracker__c[] Renewal_TrackerList, Boolean forceUpdate) {
        // do nothing here
    }
    
    @IsTest
    public static void testCoverage() 
    {
        new RenewalTrackerTrigger(null, null).execute();
        new RenewalTrackerTrigger(null, new Renewal_Tracker__c[] { new Renewal_Tracker__c() }).execute();
    }
}