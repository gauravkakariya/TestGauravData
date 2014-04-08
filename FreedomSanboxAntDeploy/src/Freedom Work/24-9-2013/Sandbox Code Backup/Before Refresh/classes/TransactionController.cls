/*
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         Mahesh			   12/10/2011	Initial Draft
*/

public class TransactionController{

	public Map<Id, Account> childEntitiesList = new Map<Id, Account>();
	public List<summaryReportWrapper> SummaryDataList = new List<summaryReportWrapper>();
	
	private Account account;
	private List<Transaction__c> Summary_Transaction_List = new List<Transaction__c>();
	private List<childSummaryReportWrapper> childSummaryReportWrapperList = new List<childSummaryReportWrapper>();

	private Map<String, Transaction__c[]> map_Summary = new    Map<String, Transaction__c[]>();
	private Map<String, Transaction__c> map_transaction = new    Map<String, Transaction__c>();
	private Map<Account, Transaction__c[]> map_Entity_Transaction = new    Map<Account, Transaction__c[]>();
	private Map<String, Transaction__c[]> child_map_Summary = new    Map<String, Transaction__c[]>();
	private Planner_Details__c  detail;
	private summaryReportWrapper wrapper_Summary;
    
    //Constructor
	public TransactionController(){
		getAccount();
		getTransactionReport();
		getChildEntities();
		getChildTransactionReport();
	}
	
	/*
	Method Name : getCurrentUserDetails()
	Parameters  : none
	Description : This method gets the details of logged in user
	Return type : User
	Created By 	: Mahesh Hirugade
	Created Date: 12/10/2011
	*/
	public User getCurrentUserDetails(){
		User user = [select ID,Email,AccountId,Name from User where Id =: UserInfo.getUserId()];
		return user;
	}
    
    /*
	Method Name : getAccount()
	Paramter    : none
	Description : This method gets the account details of logged in parent entity
	Return type : Account
	Created By 	: Mahesh Hirugade
	Created Date: 12/10/2011
	*/
	public  Account getAccount(){
		if(account==null){
			String accountId = System.currentPageReference().getParameters().get('Id');
			system.debug('accountId::::'+accountId);
			List<Account>  parentEntities;
			if(accountId != null){
				parentEntities = [select Id,
				               			 Name,
				               			 FirstName,
				               			 BillingStreet,
				               			 OwnerId,
				               			 BillingCity,
				               			 BillingState,
				               			 PersonEmail 
				               	  from Account
				               	  where Id =: accountId];
				  System.debug('++++parentEntities1 ; ' + parentEntities);
			}
			else{
				parentEntities = [select Id,
										 Name,
										 FirstName,
										 BillingStreet,
										 OwnerId,
										 BillingCity,
										 BillingState,
										 PersonEmail
								  from Account
								  where Id =: getCurrentUserDetails().AccountId];
				System.debug('++++parentEntities2 ; ' + parentEntities);
			}
			
			if(parentEntities != null && parentEntities.size() > 0){
				account = parentEntities[0];
			}
		}
		return account;
	}

    /*
	Method Name : getChildEntities()
	Paramter    : none
	Description : This method gets the details of child entity
	Return type : Map<Id,Account>
	Created By 	: Mahesh Hirugade
	Created Date: 12/10/2011
	*/
	public Map<Id,Account> getChildEntities() {
		System.debug('+++getAccount() : ' + getAccount());
		System.debug('+++Parent_Entity__c : ' + getAccount().Id);
		
		if(childEntitiesList.isEmpty() && getAccount() != null)
		{
			System.debug('+++ Inside getChildEntities() IF');
			System.debug('+++ Query ; ' + [select Id,
								   Relationship_to_Entity__pc,
								   Name
							from Account
							where Parent_Entity__c = :getAccount().Id]);
			for(Account objAccount : [select Id,
								   Relationship_to_Entity__pc,
								   Name
							from Account
							where Parent_Entity__c = :getAccount().Id])
			{
				System.debug('+++objAccount.Id : ' + objAccount.Id);
				System.debug('+++objAccount : ' + objAccount);
				childEntitiesList.put(objAccount.Id, objAccount);  
			}                  
		}
		System.debug('+++childEntitiesList : ' + childEntitiesList);
		return childEntitiesList;
	}
	public Planner_Details__c getPlannerDescription(){
         if(detail==null){
                List<Planner_Details__c> planDetail= [select Name,
                                                    
                                                     Email__c,
                                                     MobilePhone__c,
                                                     Description__c 
                                                     from Planner_Details__c  
                                                     where OwnerId = :getAccount().OwnerId LIMIT 1];
            if(planDetail != null && !planDetail.isEmpty() ){
                detail = planDetail[0];
            }
         } 
         return detail;
    }
    
    /*
	Method Name : getTransactionReport()
	Paramter    : none
	Description : This method fetches the parent records from Transaction object
	Return type : void
	Created By 	: Mahesh Hirugade
	Created Date: 12/10/2011
	*/
	public void getTransactionReport(){  
		if(map_transaction.isEmpty())
		{
			for(Transaction__c objTransaction : [Select Id, 
										   Units_Quantity__c,
										   Transaction_Type__c,
										   Scheme_Scrip__c,
										   Purchase_Price__c,
										   Purchase_Date__c,
										   Purchase_Amount__c,
										   Portfolio_Type__c,
										   Gain__c,
										   Folio_Number__c,
										   Days__c,
										   DR__c,
										   DIV_RS__c,
										   Current_Price__c,
										   Current_Value__c,
										   Current_Date__c,
										   CAGR__c,
										   Asset_Class__c,
										   ABS_RET__c,
										   Owner__c
									From Transaction__c
									where Owner__c =: getAccount().Id])
			{
				map_transaction.put(objTransaction.Id,objTransaction);
				if(map_Summary.containsKey(objTransaction.Asset_Class__c))
				{
					map_Summary.get(objTransaction.Asset_Class__c).add(objTransaction);
				}
				else
				{
					List<Transaction__c> transactionList = new List<Transaction__c>();
					transactionList.add(objTransaction);
					map_Summary.put(objTransaction.Asset_Class__c,transactionList);
				}    
			}//End FOR
		}
	}
	
	/*
	Method Name : getChildTransactionReport()
	Paramter    : none
	Description : This method fetches the child records from Transaction object
	Return type : void
	Created By 	: Mahesh Hirugade
	Created Date: 12/10/2011
	*/
	public void getChildTransactionReport(){
		System.debug('+++map_Entity_Transaction : ' + map_Entity_Transaction);     
		System.debug('+++childEntitiesList : ' + childEntitiesList);
		List<Transaction__c> objListTransaction = [Select Id,
														   Units_Quantity__c,
														   Transaction_Type__c,
														   Scheme_Scrip__c,
														   Purchase_Price__c,
														   Purchase_Date__c,
														   Purchase_Amount__c,
														   Portfolio_Type__c,
														   Gain__c,
														   Folio_Number__c,
														   Days__c,
														   DR__c,
														   DIV_RS__c,
														   Current_Price__c,
														   Current_Value__c,
														   Current_Date__c,
														   CAGR__c,
														   Asset_Class__c,
														   ABS_RET__c,
														   Owner__c
									From Transaction__c
									where Owner__c IN : childEntitiesList.keySet()];
		system.debug('EEEEE :: '+objListTransaction.size());
		system.debug('childEntitiesList.keySet():: '+childEntitiesList.keySet());
		
		if(map_Entity_Transaction.isEmpty() && !childEntitiesList.isEmpty())
		{
			for(Transaction__c childTransaction : [Select Id,
														   Units_Quantity__c,
														   Transaction_Type__c,
														   Scheme_Scrip__c,
														   Purchase_Price__c,
														   Purchase_Date__c,
														   Purchase_Amount__c,
														   Portfolio_Type__c,
														   Gain__c,
														   Folio_Number__c,
														   Days__c,
														   DR__c,
														   DIV_RS__c,
														   Current_Price__c,
														   Current_Value__c,
														   Current_Date__c,
														   CAGR__c,
														   Asset_Class__c,
														   ABS_RET__c,
														   Owner__c
									From Transaction__c
									where Owner__c IN : childEntitiesList.keySet()])
			{
				if(!map_Entity_Transaction.isEmpty() && map_Entity_Transaction.containsKey(childEntitiesList.get(childTransaction.Owner__c)))
				{
					map_Entity_Transaction.get(childEntitiesList.get(childTransaction.Owner__c)).add(childTransaction);
				}
				else
				{
					List<Transaction__c> transactionList = new List<Transaction__c>();
					transactionList.add(childTransaction);
					map_Entity_Transaction.put(childEntitiesList.get(childTransaction.Owner__c),transactionList);
				}
		   
				if(child_map_Summary.containsKey(childTransaction.Asset_Class__c) )
				{
					child_map_Summary.get(childTransaction.Asset_Class__c).add(childTransaction);
				}
				else
				{
					List<Transaction__c> transactionList1 = new List<Transaction__c>();
					transactionList1.add(childTransaction);
					child_map_Summary.put(childTransaction.Asset_Class__c,transactionList1);
				}
			}
		}     
	}
    
	/*
	Property Name : SummaryDataList
	Description : This property return the list of transaction records
	Return type : List<summaryReportWrapper>
	Created By 	: Mahesh Hirugade
	Created Date: 12/10/2011
	*/
	public List<summaryReportWrapper> getSummaryDataList(){
		if(SummaryDataList.isEmpty() && !map_Summary.isEmpty()){
			for(String assetClass : map_Summary.keySet())
			{
				Summary_Transaction_List = map_Summary.get(assetClass);
				wrapper_Summary = new summaryReportWrapper(assetClass,Summary_Transaction_List);
				SummaryDataList.add(wrapper_Summary);
			}
		}
		return SummaryDataList;
	}
	
	public List<childSummaryReportWrapper> getAllChildSummaryRecords() {
		for(Account objAccount : map_Entity_Transaction.keySet()){
			List<summaryReportWrapper> summaryList = new List<summaryReportWrapper>();
			if(map_Entity_Transaction.containsKey(objAccount)){
				for (Transaction__c objTransaction : map_Entity_Transaction.get(objAccount)){
					summaryReportWrapper summaryWrapper = new summaryReportWrapper(objTransaction.Asset_Class__c,child_map_Summary.get(objTransaction.Asset_Class__c));
					summaryList.add(summaryWrapper);
				}
				childSummaryReportWrapper objChildSummaryReportWrapper = new childSummaryReportWrapper(objAccount,summaryList);
				childSummaryReportWrapperList.add(objChildSummaryReportWrapper);
			}
		}
		return childSummaryReportWrapperList;
	}
    
	public class summaryReportWrapper{
		public List<Transaction__c> transactionList {get; set;}
		public string TestString {get;set;}
		public String asset_Class{get;set;}
		//Inner class constructor
		public summaryReportWrapper(String asset_Class, List<Transaction__c> transaction_List){
			this.asset_Class = asset_Class;
			this.transactionList = transaction_List;
			if(transaction_List != null && transaction_List.size() > 0)
				this.TestString = transaction_List[0].Portfolio_Type__c;
		}
	}
	
	public class childSummaryReportWrapper {
		public Account childEntity {get; set;}
		public List<summaryReportWrapper> summaryReportWrapperList {get; set;}
		//Inner class constructor
		public childSummaryReportWrapper(Account childEntity,List<summaryReportWrapper> summaryReportWrapperList){
			this.childEntity = childEntity;
			this.summaryReportWrapperList = summaryReportWrapperList;
		}
	} 
}