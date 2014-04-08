public virtual class AccountTrigger {
	public static final Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    public static final Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    
    public Account[] accountOldList { set; get; }
    public Account[] accountNewList { set; get; }
    public Map<Id, Account> accountOldListMap { set; get; }
    public Map<Id, Account> accountNewListMap { set; get; }
    
    public accountTrigger(Account[] accountOldList, Account[] accountNewList) {
        this.accountNewList = accountNewList == null ? new Account[] {} : accountNewList.clone();
        this.accountOldList = accountOldList == null ? new Account[] {} : accountOldList.clone();
        this.accountOldListMap = new Map<Id, Account> {};
        this.accountNewListMap = new Map<Id, Account> {};
        
        // Build the old map
        for(Account accountOld : this.accountOldList) {
            if (accountOld.Id != null) {
                accountOldListMap.put(accountOld.Id, accountOld);
            }
        }
        
        //Building the new map
        for(Account accountNew : this.accountNewList){
        	if(accountNew.id != null){
        		accountNewListMap.put(accountNew.id,accountNew);
        	}
        }
    }
    
    public virtual Boolean executable(Account accountOld, Account accountNew) {
        return true; 
    }
    
    public virtual void execute() {
        
        Account[] accountUpdateableList = new Account[] {};
        for(Account accountNew : accountNewList) {
            Account accountOld = accountOldListMap.get(accountNew.Id);
            accountOld = accountOld == null ? new Account() : accountOld;
            
            if (executable(accountOld, accountNew)) {
                accountUpdateableList.add(accountNew);
            }
        }
       
        if (accountUpdateableList.size() != 0) {
            execute(accountUpdateableList, trigger.IsAfter);
        }
    }
    
    public virtual void execute(Account[] accountList, Boolean forceUpdate) {
        // do nothing here
    }
   
    
   @IsTest
    public static void testCoverage() {
        new AccountTrigger(null, null).execute();
        new AccountTrigger(null, new Account[] { new Account() }).execute();
    }
}