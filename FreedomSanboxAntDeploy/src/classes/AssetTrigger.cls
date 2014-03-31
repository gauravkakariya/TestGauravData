public virtual class AssetTrigger 
{
	public static final Schema.DescribeSObjectResult DESCRIBE_RESULT = Asset__c.SobjectType.getDescribe();
    public static final Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    
    public Asset__c[] assetOldList { set; get; }
    public Asset__c[] assetNewList { set; get; }
    public Map<Id, Asset__c> assetOldListMap { set; get; }
    public Map<Id, Asset__c> assetNewListMap { set; get; }
    
    public AssetTrigger(Asset__c[] assetOldList, Asset__c[] assetNewList) {
        this.assetNewList = assetNewList == null ? new Asset__c[] {} : assetNewList.clone();
        this.assetOldList = assetOldList == null ? new Asset__c[] {} : assetOldList.clone();
        this.assetOldListMap = new Map<Id, Asset__c> {};
        this.assetNewListMap = new Map<Id, Asset__c> {};
        
        // Build the old map
        for(Asset__c AssetOld : this.assetOldList) {
            if (AssetOld.Id != null) {
                assetOldListMap.put(AssetOld.Id, AssetOld);
            }
        }
        
        //Building the new map
        for(Asset__c AssetNew : this.assetNewList){
        	if(AssetNew.id != null){
        		assetNewListMap.put(AssetNew.id,AssetNew);
        	}
        }
    }
    
    public virtual Boolean executable(Asset__c AssetOld, Asset__c AssetNew) {
        return true; 
    }
    
    public virtual void execute() {
        
        Asset__c[] AssetUpdateableList = new Asset__c[] {};
        for(Asset__c AssetNew : assetNewList) {
            Asset__c AssetOld = assetOldListMap.get(AssetNew.Id);
            AssetOld = AssetOld == null ? new Asset__c() : AssetOld;
            
            if (executable(AssetOld, AssetNew)) {
                AssetUpdateableList.add(AssetNew);
            }
        }
       
        if (AssetUpdateableList.size() != 0) {
            execute(AssetUpdateableList, trigger.IsAfter);
        }
    }
    
    public virtual void execute(Asset__c[] AssetList, Boolean forceUpdate) {
        // do nothing here
    }
   
    
   @IsTest
    public static void testCoverage() {
        new AssetTrigger(null, null).execute();
        new AssetTrigger(null, new Asset__c[] { new Asset__c() }).execute();
    }
}