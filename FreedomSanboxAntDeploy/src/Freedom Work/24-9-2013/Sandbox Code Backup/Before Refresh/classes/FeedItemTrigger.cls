public virtual class FeedItemTrigger 
{
	public static String TEXTPOST = 'TextPost';
	public FeedItem[] FeedItemOldList { set; get; }
    public FeedItem[] FeedItemNewList { set; get; }
    public Map<Id, FeedItem> FeedItemOldListMap { set; get; }
    public Map<Id, FeedItem> FeedItemNewListMap { set; get; }
    
    public FeedItemTrigger(FeedItem[] FeedItemOldList, FeedItem[] FeedItemNewList) {
        this.FeedItemNewList = FeedItemNewList == null ? new FeedItem[] {} : FeedItemNewList.clone();
        this.FeedItemOldList = FeedItemOldList == null ? new FeedItem[] {} : FeedItemOldList.clone();
        this.FeedItemOldListMap = new Map<Id, FeedItem> {};
        this.FeedItemNewListMap = new Map<Id, FeedItem> {};
        
        // Build the old map
        for(FeedItem FeedItemOld : this.FeedItemOldList) {
            if (FeedItemOld.Id != null) {
                FeedItemOldListMap.put(FeedItemOld.Id, FeedItemOld);
            }
        }
        
        //Building the new map
        for(FeedItem FeedItemNew : this.FeedItemNewList){
        	if(FeedItemNew.id != null){
        		FeedItemNewListMap.put(FeedItemNew.id,FeedItemNew);
        	}
        }
    }
    
    public virtual Boolean executable(FeedItem FeedItemOld, FeedItem FeedItemNew) {
        return true; 
    }
    
    public virtual void execute() {
        
        FeedItem[] FeedItemUpdateableList = new FeedItem[] {};
        for(FeedItem FeedItemNew : FeedItemNewList) {
            FeedItem FeedItemOld = FeedItemOldListMap.get(FeedItemNew.Id);
            FeedItemOld = FeedItemOld == null ? new FeedItem() : FeedItemOld;
            
            if (executable(FeedItemOld, FeedItemNew)) {
                FeedItemUpdateableList.add(FeedItemNew);
            }
        }
       
        if (FeedItemUpdateableList.size() != 0) {
            execute(FeedItemUpdateableList, trigger.IsAfter);
        }
    }
    
    public virtual void execute(FeedItem[] FeedItemList, Boolean forceUpdate) {
        // do nothing here
    }
   
    
   @IsTest
    public static void testCoverage() {
        new FeedItemTrigger(null, null).execute();
        new FeedItemTrigger(null, new FeedItem[] { new FeedItem() }).execute();
    }
}