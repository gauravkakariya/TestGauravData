/*
 * @Description:IncomeSummaryPageController is controller class for IncomeSummaryPage
 */
public class IncomeSummaryPageController
{
    public String entityId {get; set;}
    public IncomeServices service {get; set;}
    public IncomeBean bean {get; set;} 
    public FamilyMemberInfoBean fmBean{get;set;}
    public FamilyMemberInfoService fmInfoService{get;set;}
  	//Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
    /** 
    * Constructor for IncomeSummaryPageController
    */
    public IncomeSummaryPageController()
    {
        try
        {
        	//Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   			isDisplaySaveButton = true;
            service = new IncomeServices();
            bean = new IncomeBean();
            entityId = ApexPages.currentPage().getParameters().get('entityId');
            fmBean = new FamilyMemberInfoBean();
            fmInfoService = new FamilyMemberInfoService();
            fmInfoService.isCostomerProfile(fmBean);
            if(entityId != null)
            {
                bean.accountList = service.getRelatedEntities(entityId);
                bean.summaryTableList = service.getSummaryTableList(bean.accountList);
                //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	            User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	            if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
	            {
	            	isDisplaySaveButton = false;
	            }
                system.debug('=== summaryTableList ===' + bean.summaryTableList);
            }
        }
        catch(exception e){
            system.debug('======Controller Constructor Exception======'+e.getmessage());
        }
    }      
    
    /** 
    * showPopUp() shows IncomeTable popup according to selected RecordType
    * Param: None
    * Returns: pageReference
    */
    public pageReference showPopUp()
    {
        try
        {
            bean.displayPopUp = true;
            bean = service.setRecordTypeFlags(bean);    
            bean.incomeList = service.getIncomeRecords(bean.selRecordTypeId, bean.accountList);
            
            if(bean.incomeList.isEmpty())
            {
                service.addRow(bean.incomeList, bean.selRecordTypeId); 
                service.addRow(bean.incomeList, bean.selRecordTypeId); 
            }    
        }    
        catch(exception e){
            system.debug('======Controller showPopUp Exception======'+e.getmessage());
        }
        return null;
    }
    
    /** 
    * showPopUp() closes the IncomeTable popup 
    * Param: None
    * Returns: void
    */  
    public void closePopUp()
    {
        try
        {
            bean.displayPopUp = false;
            bean = service.resetRecordTypeFlags(bean); 
            bean.accountList = service.getRelatedEntities(entityId);
            bean.summaryTableList = service.getSummaryTableList(bean.accountList);
        }
        catch(exception e)
        {
            system.debug('======Controller closePopUp Exception======'+e.getmessage());
        }
    }
    /** 
    * addNewRow() adds a new row to the IncomeTable 
    * Param: None
    * Returns: void
    */
    public void addNewRow()
    {
        service.addRow(bean.incomeList,bean.selRecordTypeId); 
    }

    /** 
    * getOwnerItems() populates values of Owner picklist for IncomeTable 
    * Param: None
    * Returns: List<SelectOption>
    */
    public List<SelectOption> getOwnerItems()
    {
        return service.getOwnerItems(bean.accountList);    
    }
    
    /** 
    * getFrequency gets Frequency picklist values 
    * Param: void
    * Returns: List<SelectOption>      
    */
    public List<SelectOption> getFrequency()
    {
        return service.getFrequencyValues();
    }
    
    /** 
    * Save() saves records from IncomeTable,refreshes the SummaryTable and closes the popup
    * Param: None
    * Returns: void
    */
    public void Save()
    {
        try
        {
            Boolean saveSuccessFlag;
            List<Income__c> incomeObjList = new List<Income__c>();
            list<Income__c> ownerChangeList=new List<Income__c>();
            ApexPages.getMessages().clear();
            for(Income__c income:bean.incomeList)
            {
                if(!bean.isRowEmpty(income))
                {
                    incomeObjList.add(income);
                }
            }    
            incomeObjList=checkOwnerChange(incomeObjList);
            saveSuccessFlag=service.saveIncomes(incomeObjList);   
            if(saveSuccessFlag!=false)
            {
                    bean.summaryTableList=service.getSummaryTableList(bean.accountList);
                    bean.accountList=service.getRelatedEntities(entityId);
                    bean.displayPopUp=false;      
            }
       }
       catch(Exception e) 
       {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
       }                     
    }
    
    /** 
    * checkOwnerChange() checks if owner is changed in records
    * Param: List<Income__c>
    * Returns: List<Income__c>            
    */ 
    public List<Income__c> checkOwnerChange(list<Income__c> incomePageList)
    {
        try
        {
            List<Income__c> dbRecords = service.getIncomeRecords(bean.selRecordTypeId,bean.accountList);
            List<Income__c> ownerChangeList = new List<Income__c>();
            List<Income__c> modifiedList = new List<Income__c>();
            for(Income__c income:incomePageList)
            {
                if(income.id!=null)
                {
                    for(Income__c incomedb:dbRecords)
                    {
                        if(income.id==incomedb.id && income.entity__c != incomedb.entity__c)
                        {
                            Income__c obj1=new Income__c();
                            obj1=income.clone(false);
                            modifiedList.add(obj1);
                            ownerChangeList.add(incomedb);
                        }
                        else if(income.id==incomedb.id)
                            modifiedList.add(income);
                    }
                }
                else
                modifiedList.add(income);
            }
            incomePageList=null;
            incomePageList=modifiedList;
            service.removeOwnerList(ownerChangeList);
        }
       catch(Exception e) 
       {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
       }                     
       return incomePageList;
    }
     
    /** 
    * remove() removes records from incomes list
    * Param: None
    * Returns: void
    */ 
    public void remove()
    {
       try
       {
            service.removeRecords(bean.incomeList);
       }
       catch(Exception e) 
       {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
       }                     
    }
}