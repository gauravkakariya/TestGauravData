public virtual class FeedCommentTrigger 
{
	public static  String COMMENTTYPE = 'TextComment';
	public FeedComment[] feedCommentOldList { set; get; }
    public FeedComment[] feedCommentNewList { set; get; }
    public Map<Id, FeedComment> feedCommentOldListMap { set; get; }
    public Map<Id, FeedComment> feedCommentNewListMap { set; get; }
    
    public FeedCommentTrigger(FeedComment[] feedCommentOldList, FeedComment[] feedCommentNewList) {
        this.feedCommentNewList = feedCommentNewList == null ? new FeedComment[] {} : feedCommentNewList.clone();
        this.feedCommentOldList = feedCommentOldList == null ? new FeedComment[] {} : feedCommentOldList.clone();
        this.feedCommentOldListMap = new Map<Id, FeedComment> {};
        this.feedCommentNewListMap = new Map<Id, FeedComment> {};
        
        // Build the old map
        for(FeedComment FeedCommentOld : this.feedCommentOldList) {
            if (FeedCommentOld.Id != null) {
                feedCommentOldListMap.put(FeedCommentOld.Id, FeedCommentOld);
            }
        }
        
        //Building the new map
        for(FeedComment FeedCommentNew : this.feedCommentNewList){
        	if(FeedCommentNew.id != null){
        		feedCommentNewListMap.put(FeedCommentNew.id,FeedCommentNew);
        	}
        }
    }
    
    public virtual Boolean executable(FeedComment FeedCommentOld, FeedComment FeedCommentNew) {
        return true; 
    }
    
    public virtual void execute() {
        
        FeedComment[] FeedCommentUpdateableList = new FeedComment[] {};
        for(FeedComment FeedCommentNew : feedCommentNewList) {
            FeedComment FeedCommentOld = feedCommentOldListMap.get(FeedCommentNew.Id);
            FeedCommentOld = FeedCommentOld == null ? new FeedComment() : FeedCommentOld;
            
            if (executable(FeedCommentOld, FeedCommentNew)) {
                FeedCommentUpdateableList.add(FeedCommentNew);
            }
        }
       
        if (FeedCommentUpdateableList.size() != 0) {
            execute(FeedCommentUpdateableList, trigger.IsAfter);
        }
    }
    
    public virtual void execute(FeedComment[] FeedCommentList, Boolean forceUpdate) {
        // do nothing here
    }
   
    
   @IsTest
    public static void testCoverage() {
        new FeedCommentTrigger(null, null).execute();
        new FeedCommentTrigger(null, new FeedComment[] { new FeedComment() }).execute();
    }
	
}