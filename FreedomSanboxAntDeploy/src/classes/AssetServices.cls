public class AssetServices
{
    public DatabaseSOQL DatabaseSOQLObj {get; set;}
    private DatabaseDML DatabaseDMLObj {get; set;}
            
    public AssetServices()
    {
        DatabaseSOQLObj = new DatabaseSOQL();
        DatabaseDMLObj = new DatabaseDML();
    }
    
    /** getRelatedEntities() gets related Entities 
        Input Parameters: entity id
       Returns: List Account
    */
    public List<Account> getRelatedEntities(String EntityId)
    { 
        List<Account> AccountList = DatabaseSOQLObj.getFamilyDetails(EntityId); 
        return AccountList ;
    }
    
    /** 
       addRow() is used to add new record in the system of particular record type
       Input Parameters: RecordTypeIdString, List of asset
       Returns: void 
    */     
    public void addRow(List<Asset__c> Assets,String RecordTypeIdString, Boolean includeHLV)
    {
        Asset__c AssetTempObj = new Asset__c();
        AssetTempObj.RecordTypeId = RecordTypeIdString;    //Create new record of given RecordType
        AssetTempObj.Is_Include_In_HLV_Asset__c = includeHLV;  /* Prajakta - FP changes - 13-6-13 */
        System.Debug('===In AssetServices addRow()==='+AssetTempObj);
        Assets.add(AssetTempObj);
    }
    
     /** 
        getAssetRecords() is used to get record from database of particular record type
        Input Parameters: RecordTypeId, List of account
        Returns: list of type asset
    */  
    public List<Asset__c> getAssetRecords(String RecordTypeId,List<Account> AccountList)
    {
        List<Asset__c> AssetList = DatabaseSOQLObj.getAssets(RecordTypeId,AccountList);
        return AssetList;
    }
    
    /** 
        getOwnerItems() is used to create picklist of owner
        Input Parameters: List of account
        Returns: list of type selectoption
    */ 
    public List<SelectOption> getOwnerItems(List<Account> AccountList)
    {
        List<SelectOption> options = new List<SelectOption>();
        for(Account TempAccount : AccountList)
        {
            options.add(new SelectOption(tempAccount.Id,tempAccount.Name));        
        }
        return options;
    }
      /** 
        saveAssets() is used to save assets in the system
        Input Parameters:  List of asset
        Returns: boolean
    */  
    public Boolean saveAssets(List<Asset__c> AssetList)
    {
        Boolean successflag=true;
        List<Asset__c> validatedAssetList=new List<Asset__c>(); 
        for(Asset__c asset: AssetList )
        {
            System.Debug('====inc===='+asset);
            try
            {
                AssetBean.validate(asset);
                asset.RemoveCheckbox__c = false;
                validatedAssetList.add(asset);
            }    
            catch(ValidationException e)
            {
                successflag=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }    
        } 
        if(successflag==true)
        {
            DatabaseDMLObj.upsertObject(validatedAssetList);
        }
        return successflag;   
    }
    
     /** 
        getAssetRecordTypes() is used to get record types
        Input Parameters:  object name
        Returns: list of all record type
    */ 
    public List<RecordType> getAssetRecordTypes(String ObjectName)
    {
        List<RecordType> RTList = DataBaseSOQLObj.getObjectRecordTypes(ObjectName);
        return RTList ;
    }

    public List<AggregateResult> getDBValues(List<Account> AccountList)
    {
        List<AggregateResult> AggQueryResult = DataBaseSOQLObj.getAssetDBValues(AccountList); 
        return AggQueryResult ;
    }
     /** 
        removeRecords() is used to remove records when remove checkbox is checked for that record
        Input Parameters: list of type asset__c 
        Returns: void 
    */ 
     public void removeRecords(list<asset__c> assetList)
     {
        list<Integer> removeIndexList = new list<Integer>();
        list<asset__c> deleteList = new list<asset__c>();
        
        integer index = 0;
        for(asset__c asset : assetList)
        {
            if(asset.RemoveCheckbox__c == true && asset.id != null)
            {
                removeIndexList.add(index);
                deleteList.add(asset);
            }
            else if(asset.RemoveCheckbox__c == true)
            {
                removeIndexList.add(index);
            }
            index++;
        }
     
       for(Integer i = removeIndexList.size() ; i > 0 ; i--)
           assetList.remove(removeIndexList.get(i-1));
          
       DatabaseDMLObj.deleteRecords(deleteList);
    }
    
     /** 
        removeRecords() is used to initialise SummaryTableListwith RecordTypes and AccountNames
        Input Parameters: list of type recordtype and account
        Returns: list of type assetbean.OuterClass
    */
    
    public List<AssetBean.OuterClass> initSummaryTableList(List<RecordType> RTList, List<Account> AccountList)
    {
        List<AssetBean.OuterClass> SummaryTableList = new List<AssetBean.OuterClass>();
        
        for(RecordType rType : RTList)
        {
             AssetBean.OuterClass OuterClassobj = new AssetBean.OuterClass();
             OuterClassObj.RecordType = rType.Name;
             OuterClassObj.RecordTypeIdStr = rType.Id;
             
             //Populating AccountNames with AccountNames and AmountValue to zero
             for(Account account : AccountList)
             {
                Double amt = 0;
                AssetBean.InnerClass InnerClassObj = new AssetBean.InnerClass(account.name,amt);
                OuterClassobj.InnerClassList.add(InnerClassObj);
             }
             SummaryTableList.add(outerClassObj);
        } 
        return SummaryTableList;
    }
    
    public void populateSummaryTableList(List<AggregateResult> AggQueryResult, List<AssetBean.OuterClass> SummaryTableList )
    {
        for( AggregateResult ar : AggQueryResult)
        {
             for( AssetBean.OuterClass oObj : SummaryTableList )
             {
                 if( oObj.RecordType == (String)ar.get('RTName'))
                 {
                     //Sum of different field values are to be shown in SummaryTable for different RecordTypes
                     String Sum;
                     if(oObj.RecordType == 'Business Assets'||oObj.RecordType == 'Cash and Cash Equivalents'||
                     				oObj.RecordType == 'Real Estate Assets'||oObj.RecordType == 'Personal Assets') 
                     {
                         Sum='AmtSum';
                     }            
                     else if(oObj.RecordType == 'Deposits with Bank')
                     {
                         Sum='BalanceSum';        
                     }
                     else if(oObj.RecordType == 'Govt. Saving Schemes'||oObj.RecordType=='Retirement Accounts')
                     {
                         Sum='AccValueSum';        
                     }

                     Integer lstcntr = 0;
                     for(AssetBean.InnerClass iobj : oObj.InnerClassList )
                     {
                          if(iObj.AccountName==((String)ar.get('Entity')))
                          {
                              if((Double)ar.get(Sum)!=null)
                                  oObj.InnerClassList.get(lstcntr).AmountValue=(Double)ar.get(Sum);
                              else
                                  oObj.InnerClassList.get(lstcntr).AmountValue=0.0;
                          }
                          lstcntr++;
                     }
                  } 
             } 
        }     
    }
    
   /**
   removeOwnerList() is used to remove the records of an entity when owner of that record is changed
   */ 
    public void removeOwnerList(list<asset__c> assetList)
    {
         DatabaseDMLObj.deleteRecords(assetList);
    }
}