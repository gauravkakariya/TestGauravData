/*
	
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0 		   Manasi Ranade	  13/9/2011 	Issue id: FS0167 : Made field 'Expected Growth Rate' Required.
   												Throw ValidationException if the field is blank
*/
public class AssetBean
{
    public List<Asset__c> AssetList {get; set;}
    public List<AggregateResult> AggQueryResult {get; set;}
    public List<RecordType> RTlist {get; set;}
    public List<Account> AccountList {get; set;}
    public List<OuterClass> SummaryTableList{get; set;}
    public Boolean displayPopUp {get; set;}
    public String ObjectName='Asset__c';    
    public String selRecordTypeId {get; set;}     
    public String selRecordTypeName {get; set;}     
    public String RecordTypeName {get; set;}
    public String EntityId {get; set;}   
    public String GrowthRateLabel 
    {
        get{
            if(selRecordTypeName==AssetRecTypes__c.getInstance('Retirement Accounts').Name
	             || selRecordTypeName==AssetRecTypes__c.getInstance('Govt. Saving Schemes').Name
	             ||selRecordTypeName==AssetRecTypes__c.getInstance('Deposits With Bank').Name)
            {
                GrowthRateLabel = 'Expected Growth Rate in Annual Contribution';
            }
            else
            {
            GrowthRateLabel = 'Expected Growth Rate';
            }
        	return GrowthRateLabel ;
        }
        set;
    }
       
    public String annualContributionLabel
    {
	    get{
	         if(selRecordTypeName==AssetRecTypes__c.getInstance('Retirement Accounts').Name
	         ||selRecordTypeName==AssetRecTypes__c.getInstance('Govt. Saving Schemes').Name)
	         {
	             annualContributionLabel='Annual Contribution';
	         }
	         else if(selRecordTypeName==AssetRecTypes__c.getInstance('Deposits With Bank').Name)
	         {
	             annualContributionLabel='Annual Deposit Contribution';
	         }
	         return annualContributionLabel;    
	    }
	    set;
    }  
    
    public String endYearlabel
    {
	    get
	    {
	        if(selRecordTypeName==AssetRecTypes__c.getInstance('Deposits With Bank').Name)
	        {
	            endYearlabel='Maturity Year';
	        }
	        else
	        {
	            endYearlabel='End Year';
	        }
	        return endYearlabel;
	        
	    }
	    set;
    }
    
    public AssetBean()
    {
        AssetList = new List<Asset__c>();
    }    
    
    //OuterClass contains list of InnerClass associated with a particular RecordType
    public class OuterClass
    {
        public String RecordType {get; set;}
        public String RecordTypeIdStr {get; set;}
        public List<InnerClass> InnerClassList {get; set;}  

        
        //OuterClass Constructor        
        public OuterClass()
        {
            InnerClassList  = new List<InnerClass>();
        }
    }

    //InnerClass contains AccountName and Amount for the particular account
    public class InnerClass
    {
        public String AccountName {get; set;}
        public Double AmountValue {get; set;}  
              
        //InnerClass Constructor      
        public InnerClass(String AccName, Double Amt)
        {
            AccountName = AccName;
            AmountValue = Amt;
        }
    }
   /** 
    *isRowEmpty function is used to check whether row is empty or not
    * Param: instance of asset__c
    * Returns:Boolean
    */
    public Boolean isRowEmpty(Asset__c asset)
    {
         if(asset.Asset_Types__c==null)
            if((asset.Current_Value__c==null) || (asset.Current_Value__c==0))
                if(asset.Account_Type__c==null )
                    if((asset.Current_Balance__c==null) || (asset.Current_Balance__c==0))
                        if((asset.Annual_Contribution__c==null) || (asset.Annual_Contribution__c==0))
                            if((asset.Accumulated_Value__c==null) || (asset.Accumulated_Value__c==0))
                                if(asset.start_year__c==null)
                                    if(asset.end_year__c==null)
                                        if(asset.Account_Number__c==null)
                                            if(asset.Description__c==null)
                                                if(asset.Acquisition_Year__c==null)
                                                    if(asset.Expected_Year_of_Sale__c==null)
                                                        if(asset.Expected_Growth_Rate__c==null)
                                                            if(asset.Bank_Name__c==null)
                                                                if(asset.Interest_Rate__c==null)
                                                                    return true;
                                                
        return false;
        
    }
       
   
    /** 
    * validate() is used to validate the record
    * Param: instance of asset__c
    * Returns:void           
    */
   
    public static void validate(Asset__c asset) 
    {                                       
         if(asset.Asset_Types__c==null &&  (asset.RecordTypeId==AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c 
                                          ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Business Assets').RecordTypeId__c 
                                          ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c)){
             throw new ValidationException(Label.AssetTypeRequired); 
         }
         if(asset.Current_Value__c==null &&  (asset.RecordTypeId==AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c 
                                            ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Business Assets').RecordTypeId__c 
                                            ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c
                                            ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Cash and Cash Equivalents').RecordTypeId__c)){
             throw new ValidationException(Label.AssetCurrentValueRequired); 
         }
         if(asset.Account_Type__c==null &&  (asset.RecordTypeId==AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c 
                                            ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c 
                                            ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c
                                            ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Cash and Cash Equivalents').RecordTypeId__c)){
             throw new ValidationException(Label.AccountTypeRequired); 
         }
         if(asset.Accumulated_Value__c==null &&  (asset.RecordTypeId==AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c 
                                             ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c)){
             throw new ValidationException(Label.AccumulatedValueRequired); 
         }
         if(asset.Annual_Contribution__c==null &&  (asset.RecordTypeId==AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c 
                                             ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c)){
             throw new ValidationException(Label.AnnualContributionRequired); 
         }
         /** Eternus Solutions  **/
			/** Author  : Dipak Nikam	**/
			/** Issue Id: 0001498      	**/
			/** Date    : 09/02/2012 	**/
			/** Purpose : Made Interest rate field on ‘Retirement Accounts’ required **/
                       
         if(asset.Interest_Rate__c==null &&  (asset.RecordTypeId==AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c 
                                             ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c)){
             throw new ValidationException(Label.InterrestRateRequired); 
         }
         if(asset.Current_Balance__c==null &&  (asset.RecordTypeId==AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c)){
             throw new ValidationException(Label.CurrentBalanceRequired); 
         }
         if( ((asset.End_Year__c < asset.Start_Year__c) || (asset.End_Year__c!=null && asset.Start_Year__c==null)) && 
                                         (asset.RecordTypeId==AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c 
                                         //||asset.RecordTypeId==AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c
                                           ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c) ) {
             throw new ValidationException(Label.EndYearValidation);
         } 
         if( ((asset.Acquisition_Year__c!=null && asset.Expected_Year_of_Sale__c!=null)) && (asset.Expected_Year_of_Sale__c < asset.Acquisition_Year__c) &&
                                         (asset.RecordTypeId==AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c 
                                         ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Business Assets').RecordTypeId__c
                                         ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c) ) {
             throw new ValidationException(Label.AssetExpectedYearValidation);
         }
        /** Eternus Solutions  **/
		/** Author  : Manasi Ranade	**/
		/** Issue Id: FS0167      	**/
		/** Date    : 13/9/2011 	**/
		/** Purpose : Made field 'Expected Growth Rate' Required **/
	    if((asset.Expected_Growth_Rate__c == null) 
	   			 && (asset.RecordTypeId==AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c 
                 ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Business Assets').RecordTypeId__c
                 ||asset.RecordTypeId==AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c) )
	    {
	         throw new ValidationException(Label.ExpectedGrowthRateValidation);
	    }
    }
    
    public static String[] assetTypeList = new String[]{
			                                'Business Assets',
			                                'Cash and Cash Equivalents',
			                                'Deposits With Bank',
			                                'Personal Assets',
			                                'Govt. Saving Schemes',
			                                'Real Estate Assets',
			                                'Retirement Accounts'
			                                //Added following oiptions in the list
			                                /*,'Mutual Fund',
			                                'Stocks'*/
			                            };                              
     /** 
    * getNetworthSummaryDetail() is used to get networth details
    * Param: AggregateResult asset
    * Returns:SummaryBean.SummaryDetail          
    */

    public static SummaryBean.SummaryDetail getNetworthSummaryDetail(AggregateResult asset)
    {
        SummaryBean.SummaryDetail networthSummary;  
        String assetClassStr;
        Double assetValue;
        
        assetClassStr = (String)asset.get('assetClass');
        assetValue = (Double) asset.get('asset_value');
        
        networthSummary = new SummaryBean.SummaryDetail(assetClassStr,assetValue);  
        return networthSummary; 
    }
}