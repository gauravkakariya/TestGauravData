/*
    This class is to keep Investment Asset  and Fund  Object fields 
*/
public class InvestmentAssetBean 
{
    public List<InvestmentWrapper> investmentAssetWrapperList {get
            {
                if(investmentAssetWrapperList == null) {
                    investmentAssetWrapperList = new List<InvestmentWrapper>();
                }               
                return investmentAssetWrapperList;
            }
            set;
    }
    public List<SelectOption> options {get; set;}
    
    public InvestmentAssetBean() 
    {            
       options = new List<SelectOption>();  
    }    
    
    public void addInvestmentInstanceInList(Investment_Asset__c invAsset) 
    {
        InvestmentWrapper  wrapper = new InvestmentWrapper();
        wrapper.index =''+ investmentAssetWrapperList.size();
        wrapper.investmentAsset = invAsset;
      	//  wrapper.amcNameList = amcNameList;
        // wrapper.schemeNameList = schemeNameList;
        wrapper.selectedAMCName = invAsset.AMC_Name_Text__c;
        wrapper.selectedSchemeName = invAsset.Scheme_Name_Text__c;
         
        investmentAssetWrapperList.add(wrapper);
    }
    
    /*
        To Validate before storing object in Db  
    */    
    public static void validate(Investment_Asset__c investment,String recordName) 
    {
        String id;
        if(recordName.equals('Stocks')) {
        	system.debug('==========Stocks===========');
            if((investment.Script_Name__c == null) || (investment.Script_Name__c.trim().equals('')))                
                throw new ValidationException(Label.InvAssetScriptNameValidation);
        
        //Prajakta - FP changes - 25-02-2013        
        }else if(recordName.equals('Gold')) { /*Prajakta - 24-05-2013 */
        	system.debug('==========Gold===========');
            if((investment.Asset_Name__c == null) || (investment.Asset_Name__c.trim().equals('')))                
                throw new ValidationException(Label.InvAssetNameValidation);
                                           
        }else if (recordName.equals('Mutual_Fund')){
            if((investment.Scheme_Name_Text__c == null) || investment.Scheme_Name_Text__c.trim().equals(''))             
                throw new ValidationException(Label.InvAssetSchemeNameValidation);
            if((investment.AMC_Name_Text__c == null) || investment.AMC_Name_Text__c.trim().equals(''))
                throw new ValidationException(Label.InvAssetAMCNameValidation);                                          
        }
        //00001485
        if(investment.Asset_Type__c == null || investment.Asset_Type__c.trim().equals(''))
        	throw new ValidationException(Label.InvAssetAssetTypeValidation);
    }
    
    public static Boolean isRowEmpty(Investment_Asset__c investment) 
    {              
        if((investment.Script_Name__c == null) || (investment.Script_Name__c.trim().equals(''))) 
            if((investment.Description__c == null) || (investment.Description__c.trim().equals(''))) 
                if(investment.Asset_Type__c == null) 
                    if(((investment.Face_Value__c == null) || (investment.Face_Value__c ==0 ))) 
                        if((investment.Quantity__c == null) || (investment.Quantity__c == 0))
                            if((investment.Units__c == null)|| (investment.Units__c == 0))                              
                                if((investment.Acquisition_Date__c == null))
                                    if((investment.Purchase_NAV__c == null) || (investment.Purchase_NAV__c == 0))
                                        if((investment.Monthly_SIP_Amount__c == null) || (investment.Monthly_SIP_Amount__c == 0))
                                            if((investment.Purchase_Price__c == null) || (investment.Purchase_Price__c == 0))
                                                if((investment.Coupon_Rate__c == null) || (investment.Coupon_Rate__c == 0))
                                                    if((investment.Maturity_Date__c == null))
                                                        if((investment.AMC_Name_Text__c == null))
                                                            if((investment.Scheme_Name_Text__c == null))
                                                            	if((investment.Asset_Name__c == null))      //Prajakta - FP changes - 25-02-2013
                                                                 	if((investment.Current_NAV__c == null) || (investment.Current_NAV__c == 0))                                                 
                                                                		return true;        
        return false;            
    } 
        
    /*
        This method is being used on Networth page to show networth details for Investment asset by record Type.         
    */    
    public static SummaryBean.SummaryDetail getNetworthSummaryDetail(AggregateResult asset, String assetType)
    {
        SummaryBean.SummaryDetail networthSummary;  
        String assetClassStr;
        Double assetValue;
                
        assetClassStr = (String)asset.get('assetClass');                                                            
        assetValue = (Double) asset.get('assetValue');
        
        if(assetType != null) 
        {
            assetClassStr = assetType;  
        }
                                                                                                                                        
        networthSummary = new SummaryBean.SummaryDetail(assetClassStr,assetValue);
            
        return networthSummary; 
    } 
                                  
    /*
        Wrapper class is needed to have index in place to populate Fund and Scheme name properly on Edit page.       
    */    
    public class InvestmentWrapper 
    {
        public String index { get; set;}
        public Investment_Asset__c investmentAsset { get; set;}
        public String selectedAMCName { get; 
            set {
                selectedAMCName =  value;
            }
        }
        public String selectedSchemeName { get; 
                set {
                    selectedSchemeName =  value;
                }
        }
        
        public List<SelectOption> amcNameList {
                get {                       
                    return amcNameList;
                }
                set;    
        }
        public List<SelectOption> schemeNameList {
                get {
                    if(schemeNameList == null) {
                        schemeNameList = new List<SelectOption>();                      
                    }                   
                    return schemeNameList;
                }
                set;
        }                  
    }
}