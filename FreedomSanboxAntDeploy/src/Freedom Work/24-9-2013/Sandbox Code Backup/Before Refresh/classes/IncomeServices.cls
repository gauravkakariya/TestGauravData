/*
 * @Description:IncomeServices is service class for IncomeSummaryPage
 */
public with sharing class IncomeServices{
    DatabaseSOQL dbSOQL {get; set;}
    DatabaseDML dbDML {get; set;}
    
    /**
    * Description: Constructor 
    */        
    public IncomeServices(){
        dbSOQL = new DatabaseSOQL();
        dbDML = new DatabaseDML();
    }
         
    /** 
    * getIncomeRecords() gets Income records of given Accounts of particular RecordType
    * Param: recordTypeId, List of Accounts
    * Returns:List of incomes             
    */
    public List<Income__c> getIncomeRecords(String recordTypeId,List<Account> accountList){
        List<Income__c> incomeList = dbSOQL.getIncomes(recordTypeId,accountList); 
        return incomeList;
    }

    /** 
    * getRelatedEntities() gets related Entities 
    * Param: entityId
    * Returns: List of Account
    */
    public List<Account> getRelatedEntities(String entityId){
        List<Account> accountList = dbSOQL.getFamilyDetails(entityId); 
        return accountList ;
    }
    
    /** 
    * addRow() adds a row to list of incomes 
    * Param:recordTypeId, List of incomes
    * Returns: void            
    */
    public void addRow(List<Income__c> incomes,String recordTypeIdString){
        Income__c income = new Income__c();
        income.recordTypeId = recordTypeIdString;    //Create new record of given RecordType
        incomes.add(income);
    }
    
    /** 
    * getOwnerItems() gets values of related Entities to be displayed in Owner picklist 
    * Param: List<Account>
    * Returns: List<SelectOption>              
    */
    public List<SelectOption> getOwnerItems(List<Account> entityList){
        List<SelectOption> options = new List<SelectOption>();
        for (Account account : entityList){
            options.add(new SelectOption(account.Id,account.Name));        
        }
        return options;
    }
    
    /** 
    * getFrequencyValues() gets values of Frequency__c to be displayed in frequency picklist 
    * Param: None
    * Returns: List<SelectOption>
    */
    public List<SelectOption> getFrequencyValues(){
        List <SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Income__c.fields.Frequency__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry picklistOption : picklist) {
            options.add(new SelectOption(picklistOption.getValue(),picklistOption.getLabel()));
        }
        return options; 
    }
    
    /** 
    * saveincomes() saves records from incomes
    * Param: List<Income__c>
    * Returns: Boolean               
    */    
    public Boolean saveincomes(List<Income__c> incomes){
        Boolean saveSuccessFlag = true; 
        List <Income__c> validatedIncomeList = new List <Income__c>();
        for(Income__c income : incomes){
            try{
                IncomeBean.validate(income);
                income.RemoveCheckbox__c = false;
                validatedIncomeList.add(income);
            }    
            catch(ValidationException e){
                saveSuccessFlag=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }    
        }
        if(saveSuccessFlag==true){
            try{
                dbDML.upsertObject(validatedIncomeList);  
            }
            catch(Exception e){
                saveSuccessFlag=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }
        }
        return saveSuccessFlag;   
    }
    
    /** 
    * resetRecordTypeFlags() resets displayRecordTypeField flags in bean to false
    * Param: IncomeBean 
    * Returns: IncomeBean
    */
    public IncomeBean resetRecordTypeFlags(IncomeBean bean){
        bean.displaySalaryFields = false;
        bean.displayBusinessFields = false;
        bean.displayRentalFields = false;
        bean.displayPensionFields = false;
        bean.displayIncomeTypeField = false;
        return bean;
    }
    
    /** 
    * setRecordTypeFlags() sets particular displayRecordTypeField flag to true according to selected Recordtype
    * Param: IncomeBean
    * Returns: IncomeBean
    */
    public IncomeBean setRecordTypeFlags(IncomeBean bean){
        try{
            if(bean.selrecordTypeId == (IncomeRecTypes__c.getInstance('Salary Income').recordTypeId__c)){ 
                bean.displaySalaryFields = true;
            }
            else if(bean.selrecordTypeId == (IncomeRecTypes__c.getInstance('Business Income').recordTypeId__c)){
                bean.displayBusinessFields = true;
                bean.displayIncomeTypeField = true; 
            }
            else if(bean.selrecordTypeId == (IncomeRecTypes__c.getInstance('Rental Income').recordTypeId__c)){
                bean.displayRentalFields = true;
            }
            else if(bean.selrecordTypeId == (IncomeRecTypes__c.getInstance('Pension Income').recordTypeId__c)){
                bean.displayPensionFields = true;
            }  
            else if(bean.selrecordTypeId == (IncomeRecTypes__c.getInstance('Other Income').recordTypeId__c)){
                bean.displayIncomeTypeField = true;
            } 
        }
        catch(exception e){
            system.debug('======Service getSummaryTableList Exception======'+e.getmessage());
        }     
        return bean;
    } 

    /** 
    * getSummaryTableList() gets summaryTableList with RecordTypes and AccountNames
    * Param: List<Account>
    * Returns: populated summaryTableList
    */ 
    public List<OuterClass> getSummaryTableList(List<Account> accountList){
        List<OuterClass> summaryTableList= new List<OuterClass>();
        try{
            List<AggregateResult> aggQueryResult = dbSOQL.getIncomeDBValues(accountList);
            List<RecordType> recordTypeList = dbSOQL.getObjectRecordTypes('Income__c');
            for(RecordType recordType : recordTypeList){
                 OuterClass summary = new OuterClass();
                 summary.recordType = recordType.Name;
                 summary.recordTypeIdStr = recordType.Id;
                 
                 // Populating accountNames with Entity Names and amountValue to zero
                 for(Account account : accountList){
                     Double amount = 0;
                     summary.InnerClassList.add(new InnerClass(account.Name,amount));
                 }
                 summaryTableList.add(summary);
            } 
            populatesummaryTableList(aggQueryResult, summaryTableList);
        }
        catch(Exception e){
            system.debug('======Service getSummaryTableList Exception======'+e.getmessage());
        }    
        return summaryTableList;
    }
    
    /** 
    * populatesummaryTableList() populates summaryTableList with AmountValues from Database
    * Param: List<AggregateResult>, List<OuterClass>
    * Returns: void
    */
    private void populatesummaryTableList(List<AggregateResult> aggQueryResult, List<OuterClass> summaryTableList){
        for( AggregateResult ar : aggQueryResult){
            String RecordType=(String)ar.get('RTName');
            for(OuterClass summary : summaryTableList ){
                if(summary.RecordType == RecordType){
                    Integer lstcntr=0;
                    for(InnerClass detail: summary.InnerClassList){
                        if(detail.AccountName == (String)ar.get('Entity')){
                            if((Double)ar.get('AmtSum')!=null){
                                summary.InnerClassList.get(lstcntr).AmountValue = (Double)ar.get('AmtSum');
                            }
                            else{
                                summary.InnerClassList.get(lstcntr).AmountValue = 0.0;
                            }
                        }
                        lstcntr++;
                    }
                } 
            } 
        }   
    }
    
    /** 
    * removeRecords() removes records from incomes
    * Param: List<Income__c>
    * Returns: void
    */
    public void removeRecords(List<Income__c> incomeList){
        try{
            List<Integer> removeIndexList =new List<Integer>();
            List<Income__c> deleteList=new List<Income__c>();
            Integer index=0;
            for(Income__c income:incomeList){
                if(income.RemoveCheckbox__c==true && income.id!=null){
                    removeIndexList.add(index);
                    deleteList.add(income);
                }
                else if(income.RemoveCheckbox__c==true){
                    removeIndexList.add(index);
                }
                index++;
            }
           for(Integer i=removeIndexList.size();i>0;i--){
               incomeList.remove(removeIndexList.get(i-1));
           }
           dbDML.deleteRecords(deleteList);
        }
        catch(Exception e){
            system.debug('======Service removeRecords Exception======'+e.getmessage());
        }   
    }
    
    /** 
    * removeOwnerList() removes records from incomes when owner of the record is changed
    * Param: List<Income__c>
    * Returns: void
    */
    public void removeOwnerList(List<Income__c> incomeList){
        try{
            dbDML.deleteRecords(incomeList);
        }
        catch(Exception e){
            system.debug('======Service removeOwnerList Exception======'+e.getmessage());
        }    
    }
}