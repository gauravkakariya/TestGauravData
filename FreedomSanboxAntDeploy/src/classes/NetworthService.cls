/*
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA            Initial Draft
   
   2.0         Niket Chandane     05/06/2011    Update the method "getLiabilitiesSummaryBean(String entityId)"
                                                added the aggrigate result to the LiabilityBean.getNetworthSummaryDetail method
                                                and pass the result to the SummaryBean's populateSummaryDetailList Method
                                                which will create the ListOfLiabilities for the perticular entity which will be shown on the
                                                NetworthPage  
                                                bean.populateSummaryDetailList(LiabilityBean.getNetworthSummaryDetail(result));
                                                totalLoan = totalLoan + (Double)result.get('liabilities');
                                                this is change is done for the Isuue F0035
   
   2.0         Manasi Ranade      22/06/2011    NetworthService Class: IssueID : F0051 :Commented previous code.Created new function in
                                                DatabaseSOQL to fetch the surrender value if it is null then 
                                                fetch current value of that insurance.So change in getAssetSummaryBean() function
   2.0         Manasi Ranade      31/10/2011    NetworthService Class: IssueID : FS0231 : Change in Function :getAssetSummaryBean()
                                                As per the requirement from Haren,Commented the Life Insurance related code 
               Prajakta           21-05-2013    Uncommennted the code and changed the Function which is used to show current values of Life Insurance in Networth
*/
public class NetworthService {
    DatabaseSOQL dbQuery;    
    
    public SummaryBean getAssetSummaryBean(String entityId) {
        SummaryBean bean = new SummaryBean();
        AggregateResult result;
        
        /* Prajakta - FP changes - 27-02-2013 - Commented old code*/
        //SummaryBean.SummaryDetail mutualFundSummary = new SummaryBean.SummaryDetail('Mutual Funds',null);     
        SummaryBean.SummaryDetail investmentSummary;
        
        
        dbQuery = new DatabaseSOQL();
        
        // Fetch Asset details
        List<AggregateResult> assetSummaryList = dbQuery.getAssetListByClass(entityId);
        for(AggregateResult result1 : assetSummaryList) {
            bean.populateSummaryDetailList(AssetBean.getNetworthSummaryDetail(result1));
        }
        
        /**
            Commented Below Code on : 3/10/2013 - Aditi Satpute
            Purpose : Merged Multiple queries into one and Added Hybrid Funds - As per call with Shweta
        **/
        /*   
        // Fetch Stock Investment Asset
        result = dbQuery.getInvestmentAssetByClass(entityId,InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);
        if(result != null) {
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(result,'Equity Stocks'));
        }
        
        //Prajakta - FP changes - 26-02-2013 
        // Fetch Gold Investment Asset
        result = dbQuery.getInvestmentAssetByClass(entityId,InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c);//Prajakta - 24-05-2013 
        if(result != null) {
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(result,'Gold'));
        }
        
        // Fetch Fixed Income Investment Asset
        result = dbQuery.getInvestmentAssetByClass(entityId,InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c);
        if(result  != null) {
            system.debug('******Fixed Income*********result:+'+result);
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(result,null));
        } 
        
        // Fetch Equity and Debt Mutual Fund Investment Asset
        result = dbQuery.getMutualFundTotal(entityId,'Equity',InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
        if((result!= null)) {
            //Prajakta - FP changes - 27-02-2013 - Commented old code
            //bean.populateSummaryDetailList(mutualFundSummary);
            //mutualFundSummary = null;
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(result, 'Equity Funds'));
        }
        
        result = dbQuery.getMutualFundTotal(entityId,'Debt',InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
        if(result != null) {
            //Prajakta - FP changes - 27-02-2013 - Commented old code
            //if(mutualFundSummary != null) {
            //  bean.populateSummaryDetailList(mutualFundSummary);
            //  mutualFundSummary = null;                               
            //}
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(result,'Debt Funds'));
        }   
        result = dbQuery.getMutualFundTotal(entityId,'Hybrid - ',InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
        if(result != null) {
            
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(result,'Hybrid Funds'));
        }
        */
        /**
            Added on : 3/10/2013 - Aditi Satpute
            Purpose : Merged Multiple queries into one and Added Hybrid Funds - As per call with Shweta
        **/
        List<Investment_Asset__c> lstInvestmentAsset = dbQuery.getInvestmentAsset(entityId,true);
        if(lstInvestmentAsset != null)
        { 
            Double totalEquity = 0, totalDebt = 0,totalHybrid = 0;
            Double totalStock = 0, totalGold = 0, totalFI = 0;
            for(Investment_Asset__c result1 : lstInvestmentAsset)
            {
                
                if((result1.Asset_Type__c != null && result1.Asset_Type__c.contains(Label.Equity)) && result1.Is_Include_In_HLV_Inv_Asset__c == true)
                {
                    system.debug('-------result1-Equity-result.TotalAsset__c-'+result1.TotalAsset__c);
                    totalEquity += result1.TotalAsset__c;
                }
                else if((result1.Asset_Type__c != null && result1.Asset_Type__c.contains(Label.Debt)) && result1.Is_Include_In_HLV_Inv_Asset__c == true)
                {
                    totalDebt += result1.TotalAsset__c;
                }
                else if((result1.Asset_Type__c != null && result1.Asset_Type__c.contains(Label.Hybrid)) && result1.Is_Include_In_HLV_Inv_Asset__c == true)
                {
                    totalHybrid += result1.TotalAsset__c;
                }
                else if(result1.RecordTypeId == InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c && result1.Is_Include_In_HLV_Inv_Asset__c == true)
                {
                    totalStock += result1.TotalAsset__c;
                }
                else if(result1.RecordTypeId == InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c && result1.Is_Include_In_HLV_Inv_Asset__c == true)
                {
                    totalGold += result1.TotalAsset__c;
                }
                else if(result1.RecordTypeId == InvestmentAsset__c.getInstance(Label.FixedIncome).RecordTypeId__c && result1.Is_Include_In_HLV_Inv_Asset__c == true)
                {
                    totalFI += result1.TotalAsset__c;
                }
                  
            }
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(totalStock,'Equity Stocks'));
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(totalGold,'Gold'));
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(totalFI,'Fixed Income'));
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(totalEquity,'Equity Funds'));
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(totalDebt,'Debt Funds'));
            bean.populateSummaryDetailList(InvestmentAssetBean.getNetworthSummaryDetail(totalHybrid,'Hybrid Funds'));
        
        }
        
                             
        
        /** Eternus Solutions       **/
        /** Author  : Manasi Ranade **/
        /** Issue Id: F0051         **/
        /** Date    : 22/06/2011    **/
        /** Purpose : Commented previous code.Created new function in
                      DatabaseSOQL to fetch the surrender value if it is null then fetch current value of that insurance
        /****************************************************/
        // Fetch Insurance 
        //previous code
        /* Prajakta - FP changes II - 21-05-2013 - Uncommennted the code and changed the Function which is used to show current values of Life Insurance in Networth */
        //result = dbQuery.getInsuranceSumByRecordType(entityId,InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c);
        result = dbQuery.getInsuranceSumByRecordTypeCurrentValue(entityId,InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c);
        if(result != null) { 
            system.debug('***************result:+'+result);       
             bean.populateSummaryDetailList(InsuranceBean.getNetworthSummaryDetail(result));
        }
        /** Eternus Solutions : Manasi Ranade : FS0231 : 31/10/2011 : As per the requirement from Haren, Commented the Life Insurance related code
        /***************************************************
        Double dbInsuranceTotal = dbQuery.getSurrenderOrCurrentInsuranceByRecordType(entityId,InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c);
        if(dbInsuranceTotal != null)
        {
            bean.populateSummaryDetailList(InsuranceBean.getNetworthSummaryTotal(dbInsuranceTotal));
        }
        */
         system.debug('****in NetworthService getAssetSummaryBean*******'+Limits.getQueries());
        return bean;
        
    }
    
    public SummaryBean getLiabilitiesSummaryBean(String entityId) 
    {
        SummaryBean bean = new SummaryBean();
        Double totalLoan = 0;       
        dbQuery = new DatabaseSOQL();
        
        List<AggregateResult> liabilitiesList = dbQuery.getLiabilitiesList(entityId);
        /*
         Modified By : Niket Chandane.
         Modified On : 5 June 2011.
        */
        /*
             SummaryBean.SummaryDetail networthSummary;  
        String assetClassStr;
        Double assetValue;
        
        assetClassStr = (String)asset.get('assetClass');
        assetValue = (Double) asset.get('asset_value');
        
        networthSummary = new SummaryBean.SummaryDetail(assetClassStr,assetValue);  
        return networthSummary; 
        */
        for(AggregateResult result : liabilitiesList)
        {
            bean.populateSummaryDetailList(LiabilityBean.getNetworthSummaryDetail(result));
            totalLoan = totalLoan + (Double)result.get('liabilities');
        }
        //SummaryBean.SummaryDetail summary = new SummaryBean.SummaryDetail('Liabilities',totalLoan);
        //Error.DebugLog('summary ======>'+summary);
        //bean.populateSummaryDetailList(summary);
        return bean;
    }
    
}