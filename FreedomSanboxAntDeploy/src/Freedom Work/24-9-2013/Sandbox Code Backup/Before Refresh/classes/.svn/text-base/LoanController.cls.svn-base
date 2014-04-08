public class LoanController 
{
    public String entityId{get;set;}
    private LoanService loanService;
    private String selectedLoanType;
    //Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	
    public Boolean displayPopUp 
    { 
    	get 
    	{
            if(displayPopUp == null)
                displayPopUp = false;
            return displayPopUp;    
        }
        set;
    }
    public Boolean isLoanEmpty{get;set;}
    
    public LoanController() 
    {
    	//Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		
        entityId = System.currentPageReference().getParameters().get('EntityId');   
        loanService = new LoanService();
        
        //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
        User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
        if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
        {
        	isDisplaySaveButton = false;
        }
    }
    
    public List<Account> accountList 
    {
        get 
        {
            if(accountList == null)
            {
                accountList  = loanService.getRelatedEntities(entityId);
            }
            System.debug('accountList ' + accountList);
            return accountList; 
        }
        set;
    }
    
    public List<DataEntrySummaryBean> loanSummaryForDataEntry 
    {
        get 
        {
            List<DataEntrySummaryBean> dataEntrySummaryBeanList;
            DataEntrySummaryBean dataEntrySummaryBean = new DataEntrySummaryBean();
            
            dataEntrySummaryBeanList = loanService.getLoanSummaryForDataEntry(accountList,entityId);
            isLoanEmpty = dataEntrySummaryBeanList.isEmpty();
            if(isLoanEmpty) 
            {
                dataEntrySummaryBean.linkField = 'No Loans Entered';
                                
                for(Account acc :accountList)
                {
                    //dataEntrySummaryBean.columnsMap.put(acc.ID,'0');
                    dataEntrySummaryBean.fieldList.add(0);                                                                
                }
                dataEntrySummaryBeanList.add(dataEntrySummaryBean);             
            }    
            System.debug('LoanController.loanSummaryForDataEntry > ' + dataEntrySummaryBeanList);       
            return  dataEntrySummaryBeanList;           
        }
        set;
    }
    
    public LiabilityBean loanBean 
    {
        get {
                if((selectedLoanType == null )&& (loanBean == null)) 
                {
                    loanBean = loanService.getLoanList(entityId);
                }
                else if((selectedLoanType != null)&& (loanBean == null)) 
                {
                    loanBean = loanService.getLoanList(entityId,selectedLoanType);
                }
                return loanBean;    
        }
        set;
    }
    
    public void showPopUp()
    {
        String existingSelectedLoanType =selectedLoanType;
        selectedLoanType = System.currentPageReference().getParameters().get('selectedLoanType');
        if((selectedLoanType != null) && (!selectedLoanType.equals(existingSelectedLoanType)))
        {
            loanBean = null;        
        }        
        displayPopUp=true;
    }    
      
    public void closePopUp()
    {
        displayPopUp=false;
        loanBean = null; 
        selectedLoanType = null;
    }    
    
    public void addNewRow()
    {
        if(!displayPopUp) 
        {
            displayPopUp = !displayPopUp;           
        }
        loanBean.loanList.add(new Loan__c()); 
        loanBean.loanList.add(new Loan__c()); 
    }
            
    public pageReference Save() 
    {
        try 
        {
            loanBean = checkOwnerChange(loanBean);
            loanService.saveLoans(loanBean);
            displayPopUp = false;       
             accountList = loanService.getRelatedEntities(entityId);      
        }
        catch(ValidationException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
        } 
        return null;
    }
    
    public List<SelectOption> getOwnerItems() {
        List<SelectOption> options = loanService.getOwnerItems(accountList);            
        return options;
    }
    
    public void Remove(){
        loanService.removeRecords(loanBean.loanList);
        accountList = loanService.getRelatedEntities(entityId);
        
    }
    
	/*
	This function is used to check if owner of existing record is changed.If changed that record is deleted from previous entity and
 	new record is created for new owner
	*/
    public LiabilityBean checkOwnerChange(LiabilityBean  bean)
    {
     	LiabilityBean dbRecords = loanService.getLoanList(entityId,selectedLoanType);
     	list<loan__c>ownerChangeList = new list<loan__c>();
     	LiabilityBean   modifiedBean = new LiabilityBean  ();
      	for(loan__c loan : bean.loanList)
      	{
        	if(loan.id != null)
         	{
             	for(loan__c loandb : dbRecords.loanList)
             	{
                	if(loan.id == loandb.id && loan.entity__c != loandb.entity__c)
                 	{
                    	loan__c obj1 = new loan__c();
                    	obj1 = loan.clone(false);
                     	modifiedBean.loanList.add(obj1);
                     	ownerChangeList.add(loandb);
                 	}
                 	else if(loan.id == loandb.id )
                    	modifiedBean.loanList.add(loan);
             	}
         	}
         	else
            	modifiedBean.loanList.add(loan);
     	}
     	bean = null;
     	bean = modifiedBean;
     	loanService.removeOwnerChangeList(ownerChangeList);
     	return bean;
    }
}