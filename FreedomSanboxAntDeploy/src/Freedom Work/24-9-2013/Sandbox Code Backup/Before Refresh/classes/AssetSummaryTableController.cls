public class AssetSummaryTableController
{
    public AssetServices AssetServicesObj {get; set;}
    public AssetBean AssetBeanObj {get; set;} 
	//Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	public Boolean includeHLV {get;set;} /* Prajakta - FP changes - 13-6-13 */
	
    public AssetSummaryTableController()
    {
        //Create instances of Bean and Services class
        AssetServicesObj = new AssetServices();
        AssetBeanObj = new AssetBean();
        //Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
        AssetBeanObj.EntityId = ApexPages.currentPage().getParameters().get('EntityId');
        if(AssetBeanObj.EntityId!=null)
        {
            AssetBeanObj.AccountList = AssetServicesObj.getRelatedEntities(AssetBeanObj.EntityId);
            AssetBeanObj.AggQueryResult = AssetServicesObj.getDBValues(AssetBeanObj.AccountList); 
            //Get list of recordtypes for Asset__c
            AssetBeanObj.RTList = AssetServicesObj.getAssetRecordTypes( AssetBeanObj.ObjectName);
            //Initialises the Final List  
            AssetBeanObj.SummaryTableList = AssetServicesObj.initSummaryTableList( AssetBeanObj.RTList, AssetBeanObj.AccountList);
            //Populates the Final List to be displayed in the Summary table    
            AssetServicesObj.populateSummaryTableList(AssetBeanObj.AggQueryResult, AssetBeanObj.SummaryTableList);
            
            //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
            User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
            if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
            {
            	isDisplaySaveButton = false;
            }
       }
    }  
    

    //===============IncomeEditMethods==============
    // addNewRow() adds a new row to the IncomeTable 
    public void addNewRow()
    {
        AssetServicesObj.addRow(AssetBeanObj.AssetList,AssetBeanObj.selRecordTypeId,true ); /* Prajakta - FP changes - 13-6-13 */
    }

    // getOwnerItems() populates values of Owner picklist for IncomeTable 
    public List<SelectOption> getOwnerItems() 
    {
        return AssetServicesObj.getOwnerItems(AssetBeanObj.AccountList);    
    }

    // Save() saves records from IncomeTable 
    public void Save()
    {
        Boolean saveSuccessFlag;
        List<Asset__c> saveAssetList = new List<Asset__c>();
        for(Asset__c asset: AssetBeanObj.AssetList)
        {
            if(!AssetBeanObj.isRowEmpty(asset))
            {
               saveAssetList.add(asset);
            }
        }    
        saveAssetList=checkOwnerChange(saveAssetList); 
        saveSuccessFlag=AssetServicesObj.saveAssets(saveAssetList);
        
        if(saveSuccessFlag!=false)
        {
            AssetBeanObj.AggQueryResult = AssetServicesObj.getDBValues(AssetBeanObj.AccountList);
            AssetBeanObj.SummaryTableList= AssetServicesObj.initSummaryTableList( AssetBeanObj.RTList, AssetBeanObj.AccountList);
            AssetServicesObj.populateSummaryTableList(AssetBeanObj.AggQueryResult,AssetBeanObj.SummaryTableList);
            AssetBeanObj.AccountList= AssetServicesObj.getRelatedEntities(AssetBeanObj.EntityId);
            AssetBeanObj.displayPopUp=false;      
        }
    }
    
    public void showPopUp()
    {
        AssetBeanObj.displayPopUp=true;
        if(AssetBeanObj.selRecordTypeId == AssetRecTypes__c.getInstance(label.Business_Assets).RecordTypeId__c) {   
            AssetBeanObj.RecordTypeName = 'BusinessAsset';
        }
        else if(AssetBeanObj.selRecordTypeId == AssetRecTypes__c.getInstance(label.cashAndCashEquivalentsRecordType).RecordTypeId__c) {   
            AssetBeanObj.RecordTypeName = 'Cash&Equivalents';
        }
        else if(AssetBeanObj.selRecordTypeId == AssetRecTypes__c.getInstance(label.DepositeWithBankRecordType).RecordTypeId__c) {   
            AssetBeanObj.RecordTypeName = 'BankDeposit';
        }
        else if(AssetBeanObj.selRecordTypeId == AssetRecTypes__c.getInstance(label.PersonalAssetsRecordType).RecordTypeId__c) {   
            AssetBeanObj.RecordTypeName = 'PersonalAsset';
        }
        else if(AssetBeanObj.selRecordTypeId == AssetRecTypes__c.getInstance(label.PostOfficeRecordType).RecordTypeId__c) {   
            AssetBeanObj.RecordTypeName = 'POSaving';
        }    
        else if(AssetBeanObj.selRecordTypeId == AssetRecTypes__c.getInstance(label.RealEstateRecordType).RecordTypeId__c) {   
            AssetBeanObj.RecordTypeName = 'RealEstate';
        }
        else if(AssetBeanObj.selRecordTypeId == AssetRecTypes__c.getInstance(label.RetirementAccountRecordType).RecordTypeId__c) {   
            AssetBeanObj.RecordTypeName = 'Retirement';
        }
        
        //Populate DB records in IncomeList using ServicesObj
        AssetBeanObj.AssetList = AssetServicesObj.getAssetRecords(AssetBeanObj.selRecordTypeId,AssetBeanObj.AccountList);
        if(AssetBeanObj.AssetList.size()==0){
            addNewRow();
            addNewRow();
        }    
       
    }
    
    /**
        checkOwnerChange() method is used to check owner is changed or not 
        If owner is changed then previous record is deleted and for new owner new record is created 
    */
     public list<Asset__c> checkOwnerChange(list<asset__c> assetPageList)
     {
         list<Asset__c>dbRecords = AssetServicesObj.getAssetRecords(AssetBeanObj.selRecordTypeId,AssetBeanObj.AccountList);
         list<Asset__c>ownerChangeList = new list<Asset__c>();
         list<Asset__c> modifiedList = new list<Asset__c>();
         
	     for(Asset__c inc:assetPageList)
	     {
	        if(inc.id != null)
	        {
	            for(asset__c incdb:dbRecords)
	            {
	                if(inc.id == incdb.id && inc.entity__c != incdb.entity__c)
	                {
	                     asset__c obj1 = new asset__c();
	                     obj1 = inc.clone(false);
	                     modifiedList.add(obj1);
	                     ownerChangeList.add(incdb);
	                }
	                else if(inc.id == incdb.id)
	                     modifiedList.add(inc);
	             }
	         }
	         else
	             modifiedList.add(inc);
         }
         assetPageList = null;
         assetPageList = modifiedList;
         AssetServicesObj.removeOwnerList(ownerChangeList);
         return assetPageList;
     }
    
      
    public void closePopUp()
    {
        AssetBeanObj.AggQueryResult = AssetServicesObj.getDBValues(AssetBeanObj.AccountList);
        AssetBeanObj.SummaryTableList = AssetServicesObj.initSummaryTableList(AssetBeanObj.RTList, AssetBeanObj.AccountList);
        
        AssetServicesObj.populateSummaryTableList(AssetBeanObj.AggQueryResult,AssetBeanObj.SummaryTableList);
        AssetBeanObj.AccountList = AssetServicesObj.getRelatedEntities(AssetBeanObj.EntityId);
        AssetBeanObj.displayPopUp = false;
    }
    
    public void Remove()
    {
       AssetServicesObj.removeRecords(AssetBeanObj.AssetList);
    }
}