/**
@description This is bean class for InsuranceSummaryPage
*/
/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   22/06/2011	Class name InsuranceBean: Issue ID : F0051 :
    											Created new function getNetworthSummaryTotal.It assigns calculated 
    											insurance to the SummaryBean.SummaryDetail
    2.0			Manasi			   3/1/2012 	Issue ID : FS0398 :Added error msg if Policy type is not selected 
*/
public class InsuranceBean
{
    public String selRecordTypeId {get; set;}
    public String selRecordTypeName {get; set;}
    public String EntityId {get; set;}
    public String ObjectName='Insurance__c';  
    public List<Insurance__c> InsuranceList {get; set;}
    public List<Account> AccountList {get; set;}
    public Account objAcc{get;set;}//Prajakta
    public List<AggregateResult> AggQueryResult {get; set;}
    public List<RecordType> RTlist {get; set;}
    public List<String> AccountNameList {get; set;} 
    public List<OuterClass> SummaryTableList{get; set;}
    public OuterClass TotalInsurance{get; set;}
    public Boolean displayPopUp {get; set;}
    public Boolean displayLifeFields {get; set;}
    public Boolean displayGeneralFields {get; set;}
    
    /**
    @Description constructor
    */
    public InsuranceBean()
    {
        displayLifeFields = false;
        displayGeneralFields = false;
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
    
    public Boolean isRowEmpty(Insurance__c insurance,String recordType)
    {
        if(recordType == 'General Insurance')
        {
            if(insurance.Policy_Type__c == null && insurance.Policy_Name__c == null && insurance.Policy_Number__c == null && (insurance.Premium_Amount_Rs__c==null 
            			|| insurance.Premium_Amount_Rs__c == 0.0)&& (insurance.Death_Benefit_Rs__c==null || insurance.Death_Benefit_Rs__c== 0.0) 
            			&& insurance.Premium_Frequency__c==null && insurance.Next_Premium_Due_Date__c==null && insurance.Sum_Assured_Rs__c==null)
                return true;
            else
                return false;
        }
        else if(recordType == 'Life Insurance')
        {
           if(insurance.Insurance_Company__c == null && insurance.Policy_Type__c == null && ( insurance.Policy_Name__c == ' '||insurance.Policy_Name__c==null)
           		 && insurance.Policy_Number__c == null && (insurance.Death_Benefit_Rs__c == null ||insurance.Death_Benefit_Rs__c == 0.0) 
           		 && (insurance.Premium_Amount_Rs__c == null || insurance.Premium_Amount_Rs__c == 0.0)&& (insurance.Premium_Frequency__c == null 
           		 ||insurance.Premium_Frequency__c=='-None-')  && insurance.Commencement_Date__c == null && insurance.Next_Premium_Due_Date__c == null 
           		 && insurance.Tenure_of_Insurance__c==null && insurance.Number_of_Years_Left__c == null && insurance.Surrender_Cash_Value__c == null)
           		 {              
                return true;
            }   
            else
                return false;
        }
        else
        {
            return false;
        }        
    }
    
     /**
        validate() is used to check all required fields are filled or not 
    */
    public void validate(Insurance__c ins) 
    {                                       
         if(ins.Entity__c == null)
            throw new ValidationException(Label.EntityValidation);                                         
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: FS0398      	**/
		/** Date    : 3/1/2012  	**/
		/** Purpose : Added error msg if Policy type is not selected 
		/****************************************************/
         if(ins.Policy_Type__c==null ){//&& ins.recordTypeId==InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c){
                 throw new ValidationException(Label.InsurancePolicyTypeValidation);                                         
         }
         if(ins.Premium_Amount_Rs__c==null){
                 throw new ValidationException(Label.InsurancePremiumAmountValidation);                                         
         }
         if(ins.Premium_Frequency__c==null){
                 throw new ValidationException(Label.InsurancePremiumFrequencyValidation);                                         
         }
         if(ins.Tenure_of_Insurance__c==null && ins.recordTypeId==InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c){
                 throw new ValidationException(Label.TenureOfInsuranceValidation);                                         
         }
         if(ins.Commencement_Date__c==null && ins.recordTypeId==InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c){
                 throw new ValidationException(Label.CommencementDateValidation);                                         
         }
         if((ins.Next_Premium_Due_Date__c < ins.Commencement_Date__c) 
             || (ins.Next_Premium_Due_Date__c!=null && ins.Commencement_Date__c==null)
             && ins.recordTypeId==InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c) {
                  throw new ValidationException(Label.NextPremiumDueDateValidation);
         }       
    }
    
    /**
        getNetworthSummaryDetail() is used to get total liabilities for networth page 
    */
    public static SummaryBean.SummaryDetail getNetworthSummaryDetail(AggregateResult asset)
    {
        SummaryBean.SummaryDetail networthSummary;  
        String assetClassStr;
        Double assetValue;
               
        assetClassStr = (String)asset.get('insuranceClass');                                                            
        assetValue = (Double) asset.get('insuranceValue');
                                                                                                                                                
        networthSummary = new SummaryBean.SummaryDetail(assetClassStr,assetValue);
            
        return networthSummary; 
    }
    
    /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: F0051      	**/
	/** Date    : 22/06/2011 	**/
	/** Purpose : Created new function getNetworthSummaryTotal.It assigns calculated insurance to the SummaryBean.SummaryDetail 
	/****************************************************/ 
   public static SummaryBean.SummaryDetail getNetworthSummaryTotal(Double dbasset)
   {
        SummaryBean.SummaryDetail networthSummary;  
        String assetClassStr;
        Double assetValue;
        assetClassStr = 'Life Insurance';                                                            
        assetValue = dbasset;                                                                                                                     
        networthSummary = new SummaryBean.SummaryDetail(assetClassStr,assetValue);
            
        return networthSummary; 
    }
                                                
}