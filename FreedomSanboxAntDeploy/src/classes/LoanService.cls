/**
@description LoanService is service class for loan page
*/
public class LoanService 
{
    private DatabaseSOQL dbQuery;
    private DatabaseDML dbUpdate { get; set;}

    public LoanService() 
    {
        dbQuery = new DatabaseSOQL();
        dbUpdate = new DatabaseDML();       
    }   
   
    public List<Account> getRelatedEntities(String EntityId) 
    {
        List<Account> AccountList = dbQuery.getFamilyDetails(EntityId); 
        return AccountList ;
    }
    
    public List<DataEntrySummaryBean> getLoanSummaryForDataEntry(List<Account> accountList, String entityId)
    {        
        DataEntrySummaryBean dataEntrySummaryBean;
        String loanType;        
                                
        Map<String, DataEntrySummaryBean> loanMappingMap = new Map<String, DataEntrySummaryBean>();         
        Map<Id, integer> accountIndexMap = new Map<Id, Integer>();
        
        List<AggregateResult> resultList = dbQuery.getLiabilitiesList(entityId);
        
        for(AggregateResult result : resultList) 
        {          
            loanType = (String)result.get('Loan_Type__c');     
            dataEntrySummaryBean = loanMappingMap.get(loanType);
            
            if(dataEntrySummaryBean == null) 
            {              
                dataEntrySummaryBean = new DataEntrySummaryBean();
                loanMappingMap.put(loanType,dataEntrySummaryBean);
                accountIndexMap = new Map<Id,Integer>();                                                                
                for(Account account: accountList) 
                {                     
                        accountIndexMap.put(account.ID,dataEntrySummaryBean.fieldList.size());
                        dataEntrySummaryBean.fieldList.add(0);                                
                }                                               
            }
            LiabilityBean.getDataEntrySummary(dataEntrySummaryBean,accountIndexMap,result);                 
        }       
           
        return loanMappingMap.values();
    }
    
     /*
    This function is used to get loans from database 
    */
    public LiabilityBean getLoanList(String entityId) 
    {
        LiabilityBean bean = new LiabilityBean();
        bean.loanList = dbQuery.getLoanList(entityId);
        return bean; 
    }
    
    /*
    This function is used to get loans from database of selected loan type
    */
    public LiabilityBean getLoanList(String entityId, String loanType) 
    {
        LiabilityBean bean = new LiabilityBean();
        bean.loanList = dbQuery.getLoanList(entityId, loanType);
        return bean; 
    }
    
    /*
    This function is used to save the loans into database
    */
    public void saveLoans(LiabilityBean bean)
    {  
        List<Loan__c> loanList = bean.loanList;
        List<Loan__c>   tempLoanList = new List<Loan__c>(); 
        
        for(Loan__c loan : loanList) 
        {          
            if(!LiabilityBean.isRowEmpty(loan))
            {
                LiabilityBean.validate(loan);
                loan.removeCheckbox__c=false;
                tempLoanList.add(loan);
            }                                   
        }
        bean.loanList = tempLoanList;   
        upsert bean.loanList;       
    }   
    
    /*
        This function is used to create option list for owner
    */
    public List<SelectOption> getOwnerItems(List<Account> EntityList)
    {
        List<SelectOption> options = new List<SelectOption>();   
        for (Account tempAccount : EntityList )
        {
            options.add(new SelectOption(tempAccount.Id,tempAccount.Name));        
        }
        return options;
    }
    
    /*
    This function is used to remove the records
    */
    public void removeRecords(list<Loan__c> loanList)
    {
        list<Integer> removeIndexList = new list<Integer>();
        list<Loan__c> deleteList = new list<Loan__c>();
        
        Integer index = 0;
        for(Loan__c loan : loanList)
        {
            if(loan.RemoveCheckbox__c && loan.id != null){
                removeIndexList.add(index);
                deleteList.add(loan);
            }
            else if(loan.RemoveCheckbox__c)
            {
                removeIndexList.add(index);
            }
            index++;
        }
             
       for(Integer i = removeIndexList.size(); i > 0; i--)
       {
           loanList.remove(removeIndexList.get(i - 1));
         
       }
       
       dbUpdate .deleteRecords(deleteList);
    }
    
    /*
        This function is used to remove records of previous owner if owner is changed
    */
     public void removeOwnerChangeList(list<loan__c> loanList)
     {
         dbUpdate.deleteRecords(loanList);
     }
}