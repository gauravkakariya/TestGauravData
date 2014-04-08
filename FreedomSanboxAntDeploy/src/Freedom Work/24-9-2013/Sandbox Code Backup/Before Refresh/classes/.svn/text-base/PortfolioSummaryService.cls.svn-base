/*
 * @Author: Anju G
 * @since :5th Feb 2011
 * @Description:PortfolioSummaryService is service class for PortfolioSummaryPage
 */
    public class PortfolioSummaryService {
        public DatabaseDML databaseAccess=new DatabaseDML();
        public DatabaseSOQL databaseObj = new DatabaseSOQL(); 
        public  Double currentAssetSum{get;set;}
        public  Double currentAssetPercent{get;set;}
        public  Double suggestedAssetSum{get;set;}
        public  Double suggestedAssetPercent{get;set;}
        Map<String,PortfolioValueBean> portfolioMap{get;set;}
        public PortfolioSummaryService(){
            portfolioMap=new Map<String,PortfolioValueBean>();
            currentAssetSum=0;
            currentAssetPercent=0;
            suggestedAssetSum=0;
            suggestedAssetPercent=0;
        }
    /*
     * getFamilyDetails() method used to get the details of family member associated with particular entity
     * params:id of particular Entity
     * Return Type:List of Account
     */ 
        public List<Account> getFamilyDetails(String entityId) {
            return databaseObj.getFamilyDetails(entityId);
        }
    /*
     * getPortfolioAssets() method used to get the current assets associated with particular entity/family members
     * params:List of family members
     * Return Type:AggregateResult
     */ 
        public List<AggregateResult> getPortfolioAssets(List<Account>EntityList) {
            return databaseObj.getPortfolioAssets(EntityList);
        }
    /*
     * getSuggestedAssets() method used to get the Suggested assets associated with particular entity/family members
     * params:List of family members
     * Return Type:AggregateResult
     */ 
        public List<AggregateResult> getSuggestedAssets(List<Account>EntityList) {
            return databaseObj.getSuggestedAssets(EntityList);
        }
    /*
     * getPortfolioInsurance() method used to get the current Insurance associated with particular entity/family members
     * params:List of family members
     * Return Type:AggregateResult
     */ 
        public List<AggregateResult> getPortfolioInsurance(List<Account>EntityList) {
          return databaseObj.getPortfolioInsurance(EntityList);
       }
    /*
     * getSuggestedInsurance() method used to get the Suggested insurance associated with particular entity/family members
     * params:List of family members
     * Return Type:AggregateResult
     */
        public List<AggregateResult> getSuggestedInsurance(List<Account>EntityList) {
            return databaseObj.getSuggestedInsurance(EntityList);
        }
    /*
     * getPortfolioInvestmentAssets() method used to get the current Investment Asset associated with particular entity/family members
     * params:List of family members
     * Return Type:AggregateResult
     */ 
        public List<AggregateResult> getPortfolioInvestmentAssets(List<Account>EntityList) {
            return databaseObj.getPortfolioInvestmentAssets(EntityList);
        }
    /*
     * getSuggestedInvestmentAssets() method used to get the Suggested Investment Asset associated with particular entity/family members
     * params:List of family members
     * Return Type:AggregateResult
     */
        public List<AggregateResult> getSuggestedInvestmentAssets(List<Account>EntityList) {
            return databaseObj.getSuggestedInvestmentAssets(EntityList);
        }
    /*
     * addmapValue() method used to categorize the values according to asset class
     * params:Asset class,crrent value for  asset class ,aggregateResult
     * Return Type:void
     */   
        public void addmapValue(String assetClass, double currentValue, AggregateResult ag)
        {
            PortfolioValueBean existingValue = new PortfolioValueBean();
            PortfolioValueBean pValueBean = new PortfolioValueBean();
            pValueBean.currentValue = currentValue;
            
            if(portfolioMap.get(assetClass) != null)
            {
                existingValue = portfolioMap.get(assetClass);
                existingValue.currentValue = existingValue.currentValue + pValueBean.currentValue;
                portfolioMap.put(assetClass,existingValue);
            }
            else
            {
                portfolioMap.put(assetClass,pValueBean);
            }
            currentAssetSum += currentValue;
        }
    /*
     * addmapPercent() method used to categorize the suggested Percentage according to asset class
     * params:Asset class,suggested percentage for  asset class ,aggregateResult
     * Return Type:void
     */
        public void addmapPercent(String assetClass,double suggestedPercent,AggregateResult ag)
        {
            PortfolioValueBean existingValue = new PortfolioValueBean();
            PortfolioValueBean pValueBean = new PortfolioValueBean();
            pValueBean.suggestedPercent = suggestedPercent;
            
            if(portfolioMap.get(assetClass) != null)
            {
                existingValue = portfolioMap.get(assetClass);
                existingValue.suggestedPercent = existingValue.suggestedPercent+pValueBean.suggestedPercent;
                portfolioMap.put(assetClass,existingValue);
            }
            else
            {
                portfolioMap.put(assetClass,pValueBean);
            }
        }
    /*
     * getSuggestedAsset() method used to get sum of suggested Asset
     * params:none
     * Return Type:void
     */
        public void getSuggestedAsset()
        {
            if(portfolioMap != null && portfolioMap.size()>0 )
            {
                for(String key:portfolioMap.keySet())
                {
                    PortfolioValueBean pfval = portfolioMap.get(key);
                    suggestedAssetSum += pfval.currentValue * pfval.suggestedPercent / 100;
                }
            }
        }
    /*
     * getPortfolioList() method used to get portfolioList
     * params:none
     * Return Type:List<PortfolioBean>
     */
        public List<PortfolioBean> getPortfolioList(){
            List<PortfolioBean>portfolioBeanList=new List<PortfolioBean>();
            Double assetPercent=0;
            if(portfolioMap!=null && portfolioMap.size()>0 ){
                for(String key:portfolioMap.keySet()){
                    PortfolioBean pfBean=new PortfolioBean();
                    pfBean.recordType=key;
                    pfBean.currentAsset=(portfolioMap.get(key)).currentValue;
                    assetPercent=(portfolioMap.get(key)).suggestedPercent;
                    system.debug('current Asset*********'+pfBean.currentAsset);
                    system.debug('assetPercent*********'+assetPercent);
                    pfBean.suggestedAsset=pfBean.currentAsset*assetPercent/100;
                     system.debug('pfBean.suggestedAsset*********'+pfBean.suggestedAsset);
                    if(currentAssetSum>0){
                        pfBean.currentPercent=(pfBean.currentAsset/currentAssetSum)*100;
                        currentAssetPercent+=pfBean.currentPercent;
                    }
                    else{
                        pfBean.currentPercent=0;
                    }
                    if(suggestedAssetSum>0){
                        pfBean.suggestedPercent=(pfBean.suggestedAsset/suggestedAssetSum)*100;
                        suggestedAssetPercent+=pfBean.suggestedPercent;
                    }
                    else{
                        pfBean.suggestedPercent=0;
                    }
                    portfolioBeanList.add(pfBean);
                }
            }
            return portfolioBeanList;
        }
    }